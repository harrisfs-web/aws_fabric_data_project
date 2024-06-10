drop table if exists timedim;
CREATE TABLE timedim (
    time_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    day INT,
    month INT,
    year INT,
    quarter INT,
    day_of_week VARCHAR(9)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS PopulateTimeDim;
CREATE PROCEDURE PopulateTimeDim()
BEGIN
    DECLARE v_start_date DATE;
    DECLARE v_current_date DATE;
    DECLARE v_day INT;
    DECLARE v_month INT;
    DECLARE v_year INT;
    DECLARE v_quarter INT;
    DECLARE v_day_of_week VARCHAR(9);

    -- Set the start date to two years ago from today
    SET v_start_date = DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
    SET v_current_date = v_start_date;

    WHILE v_current_date <= CURDATE() DO
        -- Extract components from the date
        SET v_day = DAY(v_current_date);
        SET v_month = MONTH(v_current_date);
        SET v_year = YEAR(v_current_date);
        SET v_day_of_week = DAYNAME(v_current_date);

        -- Determine the quarter
        SET v_quarter = CASE
            WHEN v_month BETWEEN 1 AND 3 THEN 1
            WHEN v_month BETWEEN 4 AND 6 THEN 2
            WHEN v_month BETWEEN 7 AND 9 THEN 3
            WHEN v_month BETWEEN 10 AND 12 THEN 4
        END;

        -- Insert the date and its components into the timedim table
        INSERT INTO timedim (date, day, month, year, quarter, day_of_week)
        VALUES (v_current_date, v_day, v_month, v_year, v_quarter, v_day_of_week);

        -- Move to the next day
        SET v_current_date = DATE_ADD(v_current_date, INTERVAL 1 DAY);
    END WHILE;
END$$

DELIMITER ;
CALL PopulateTimeDim();
