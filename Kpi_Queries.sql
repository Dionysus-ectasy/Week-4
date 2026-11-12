USE complaints_db;

-- KPI 1: Total complaints
SELECT COUNT(*) AS total_complaints
FROM complaints;

-- KPI 2: Annual complaint volume
SELECT year, COUNT(*) AS complaints
FROM complaints
GROUP BY year
ORDER BY year;

-- KPI 3: Monthly complaint volume
SELECT period_ym, COUNT(*) AS complaints
FROM complaints
GROUP BY period_ym
ORDER BY period_ym;
USE complaints_db;

-- KPI 4 + 7: Complaints by product and % of total
SELECT product_short AS product,
       COUNT(*) AS complaints,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM complaints
GROUP BY product_short
ORDER BY complaints DESC;

-- KPI 5: Top 10 reported issues
SELECT issue,
       COUNT(*) AS complaints,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM complaints
GROUP BY issue
ORDER BY complaints DESC
LIMIT 10;

-- KPI 6a: Complaints by sub-product (top 10)
SELECT product_short AS product, sub_product,
       COUNT(*) AS complaints
FROM complaints
GROUP BY product_short, sub_product
ORDER BY complaints DESC
LIMIT 10;

-- KPI 6b: Complaints by sub-issue (top 10, "Not specified" shown as its own row)
SELECT sub_issue,
       COUNT(*) AS complaints
FROM complaints
GROUP BY sub_issue
ORDER BY complaints DESC
LIMIT 10;
USE complaints_db;

-- KPI 8: Company response category distribution
SELECT company_response,
       COUNT(*) AS complaints,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM complaints
GROUP BY company_response
ORDER BY complaints DESC;

-- KPI 9: Timely response % (only Yes/No in the denominator)
SELECT SUM(timely_response = 'Yes')                       AS timely_yes,
       SUM(timely_response = 'No')                        AS timely_no,
       SUM(timely_valid_flag)                             AS valid_denominator,
       ROUND(SUM(timely_response = 'Yes') * 100.0 / SUM(timely_valid_flag), 2) AS timely_pct,
       SUM(1 - timely_valid_flag)                         AS excluded_records
FROM complaints;

-- KPI 10: In-progress complaints
SELECT SUM(is_in_progress) AS in_progress_complaints
FROM complaints;

-- Extra: public response categories (short version)
SELECT public_response_short,
       COUNT(*) AS complaints
FROM complaints
GROUP BY public_response_short
ORDER BY complaints DESC;

-- Extra: Timely % by year
SELECT year,
       SUM(timely_valid_flag) AS valid_records,
       ROUND(SUM(timely_response = 'Yes') * 100.0 / SUM(timely_valid_flag), 2) AS timely_pct
FROM complaints
GROUP BY year
ORDER BY year;

USE complaints_db;

-- KPI 11a: Average forwarding interval + spread
SELECT ROUND(AVG(forwarding_days), 3) AS avg_days,
       MAX(forwarding_days)           AS max_days,
       SUM(forwarding_days = 0)       AS same_day,
       SUM(forwarding_days <= 1)      AS within_1_day,
       SUM(long_forwarding_flag)      AS over_30_days
FROM complaints;

-- KPI 11b: Median forwarding interval (MySQL has no MEDIAN, so use a window function)
SELECT AVG(forwarding_days) AS median_days
FROM (
  SELECT forwarding_days,
         ROW_NUMBER() OVER (ORDER BY forwarding_days) AS rn,
         COUNT(*) OVER ()                             AS total
  FROM complaints
) t
WHERE rn IN (FLOOR((total + 1) / 2), CEIL((total + 1) / 2));

-- KPI 12a: Year-over-year change (full years, 2017 and 2023 are partial)
SELECT year,
       COUNT(*) AS complaints,
       ROUND((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY year)) * 100.0
             / LAG(COUNT(*)) OVER (ORDER BY year), 2) AS yoy_pct
FROM complaints
GROUP BY year
ORDER BY year;

-- KPI 12b: Like-for-like YoY (May to July only, which exists in all 7 years)
SELECT year,
       COUNT(*) AS complaints_may_jul,
       ROUND((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY year)) * 100.0
             / LAG(COUNT(*)) OVER (ORDER BY year), 2) AS yoy_pct
FROM complaints
WHERE month_number BETWEEN 5 AND 7
GROUP BY year
ORDER BY year;

USE complaints_db;

-- Extra 1: Complaints by product group
SELECT product_group,
       COUNT(*) AS complaints,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM complaints
GROUP BY product_group
ORDER BY complaints DESC;

-- Extra 2: Forwarding interval by product (average, median, max, share over 30 days)
SELECT product_short AS product,
       COUNT(*) AS complaints,
       ROUND(AVG(forwarding_days), 2) AS avg_days,
       MAX(forwarding_days) AS max_days,
       SUM(long_forwarding_flag) AS over_30_days,
       ROUND(SUM(long_forwarding_flag) * 100.0 / COUNT(*), 2) AS pct_over_30_days
FROM complaints
GROUP BY product_short
ORDER BY pct_over_30_days DESC;

-- Extra 3: Median forwarding interval by product
SELECT product_short AS product,
       AVG(forwarding_days) AS median_days
FROM (
  SELECT product_short, forwarding_days,
         ROW_NUMBER() OVER (PARTITION BY product_short ORDER BY forwarding_days) AS rn,
         COUNT(*)     OVER (PARTITION BY product_short) AS total
  FROM complaints
) t
WHERE rn IN (FLOOR((total + 1) / 2), CEIL((total + 1) / 2))
GROUP BY product_short
ORDER BY product_short;

-- Extra 4: Top issue within each product (product vs issue)
SELECT product_short AS product, issue, complaints
FROM (
  SELECT product_short, issue, COUNT(*) AS complaints,
         ROW_NUMBER() OVER (PARTITION BY product_short ORDER BY COUNT(*) DESC) AS rnk
  FROM complaints
  GROUP BY product_short, issue
) t
WHERE rnk = 1
ORDER BY complaints DESC;