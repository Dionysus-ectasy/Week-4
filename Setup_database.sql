-- setup_database.sql
-- Week 4: Consumer Complaints (Bank of America, 2017-2023)
-- Creates the database, the raw table and the simplified view.
-- Load Consumer_Complaints_Cleaned.csv into complaints_raw with the
-- Table Data Import Wizard after running the CREATE TABLE.

CREATE DATABASE IF NOT EXISTS complaints_db;
USE complaints_db;

CREATE TABLE complaints_raw (
  `Complaint ID` INT PRIMARY KEY,
  `Submitted via` VARCHAR(50),
  `Date submitted` DATE,
  `Date received` DATE,
  `State` VARCHAR(10),
  `Product` VARCHAR(150),
  `Sub-product` VARCHAR(150),
  `Issue` VARCHAR(255),
  `Sub-issue` VARCHAR(255),
  `Company public response` VARCHAR(500),
  `Company response to consumer` VARCHAR(100),
  `Timely response?` VARCHAR(50),
  `Forwarding Interval (Days)` INT,
  `Year` INT,
  `Month Number` INT,
  `Month Name` VARCHAR(10),
  `Year-Month` VARCHAR(10),
  `Quarter` VARCHAR(5),
  `Is In Progress` TINYINT,
  `Timely Valid Flag` TINYINT,
  `Long Forwarding Flag` TINYINT,
  `Product (Short)` VARCHAR(50),
  `Product Group` VARCHAR(50),
  `Response Group` VARCHAR(50),
  `Public Response (Short)` VARCHAR(50)
);

CREATE OR REPLACE VIEW complaints AS
SELECT
  `Complaint ID`                  AS complaint_id,
  `Submitted via`                 AS submitted_via,
  `Date submitted`                AS date_submitted,
  `Date received`                 AS date_received,
  `State`                         AS state,
  `Product`                       AS product,
  `Product (Short)`               AS product_short,
  `Product Group`                 AS product_group,
  `Sub-product`                   AS sub_product,
  `Issue`                         AS issue,
  `Sub-issue`                     AS sub_issue,
  `Company public response`       AS public_response,
  `Public Response (Short)`       AS public_response_short,
  `Company response to consumer`  AS company_response,
  `Response Group`                AS response_group,
  `Timely response?`              AS timely_response,
  `Timely Valid Flag`             AS timely_valid_flag,
  `Is In Progress`                AS is_in_progress,
  `Forwarding Interval (Days)`    AS forwarding_days,
  `Long Forwarding Flag`          AS long_forwarding_flag,
  `Year`                          AS year,
  `Quarter`                       AS quarter,
  `Month Number`                  AS month_number,
  `Month Name`                    AS month_name,
  `Year-Month`                    AS period_ym
FROM complaints_raw;