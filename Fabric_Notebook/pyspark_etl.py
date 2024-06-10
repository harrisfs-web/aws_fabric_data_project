from pyspark.sql.functions import *
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Elaborate PySpark Example") \
    .config("spark.sql.legacy.timeParserPolicy", "LEGACY") \
    .getOrCreate()

df = spark.read.format("csv").option("header","true").load("Files/loaded_data/*.csv")

df.printSchema()

df.show()

df = df.withColumn("order_date", to_date(col("order_date"), "yyyy-MM-dd")) \
       .withColumn("number_of_orders", col("number_of_orders").cast("integer")) \
       .withColumn("total_items_sold", col("total_items_sold").cast("integer")) \
       .withColumn("total_sales", col("total_sales").cast("double"))

df = df.filter(col("total_sales") > 5000)

df = df.withColumn("year", year(col("order_date"))) \
                                .withColumn("month", month(col("order_date")))

agg_df = df.groupBy("year", "month") \
                                  .agg(sum("total_sales").alias("total_sales_sum"),
                                       avg("total_sales").alias("average_sales"),
                                       max("total_sales").alias("max_sales"),
                                       min("total_sales").alias("min_sales"),
                                       count("order_date").alias("order_count"))

sorted_df = agg_df.orderBy(col("year"), col("month"))

table_name = "sales_data"

sorted_df.write.mode('append').saveAsTable(table_name) # save/append data to table

%%sql
SELECT * FROM sales_data #use SQL to select data from table and create a chart view