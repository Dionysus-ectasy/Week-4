# Consumer Complaint Monitoring and Response Dashboard
**AnalystLab Africa, Experience Lab Internship, Week 4 (Data Analytics track)**
Project: Consumer Complaint Trends and Response Intelligence Platform
Author: Divine Okezie Nwaoha

## 1. Project overview
An interactive Power BI dashboard, with a SQL validation layer, for monitoring 62,516 CFPB consumer complaint records (1 May 2017 to 28 Aug 2023) described in the assignment as relating to Bank of America. It covers complaint volumes, products and issues, recorded company responses and the CFPB forwarding interval.

This is an independent analysis for the AnalystLab Africa programme. It is not an official product of, and is not affiliated with, Bank of America or the CFPB. A complaint is a consumer-reported issue and does not establish misconduct.

## 2. Repository contents

| File | Purpose |
|---|---|
| `clean_complaints.py` | Reproducible cleaning and field creation (reads the original Excel, writes the cleaned CSV) |
| `Consumer_Complaints_Cleaned.csv` | Cleaned dataset with added fields |
| `setup_database.sql` | Creates the MySQL database, the raw table and a simplified view |
| `kpi_queries.sql` | One query for each KPI, plus extras, used to validate the dashboard |
| Power BI report (`.pbix`) | The four-page dashboard |
| `Data_Quality_Documentation.pdf` | Inspection results, cleaning decisions, validation evidence, limitations |
| `Business_Insights_and_Recommendations.pdf` | Seven insights and five recommendations |

The original `Consumer_Complaints.xlsx` is not modified.

## 3. Methodology
1. **Inspect and clean:** structure, ID uniqueness, duplicates, missing values, date validity and unusual values were checked in Python. Blanks were treated by meaning, not as errors (see the data-quality document).
2. **Standardise and extend:** short product names, a product grouping, a response grouping and date and interval fields were added as new columns. The original columns are kept.
3. **Validate in SQL:** the cleaned data was loaded into MySQL 8.0 and every KPI was calculated independently.
4. **Build the dashboard:** Power BI measures were reconciled against the SQL results.
5. **Interpret:** findings use neutral wording, and limitations are stated on each dashboard page in a Data Trust note.

## 4. Tools
Python (pandas, openpyxl), MySQL 8.0 and MySQL Workbench, Power BI Desktop (DAX).

## 5. Setup and reproduction
1. Put `Consumer_Complaints.xlsx` beside `clean_complaints.py`, install pandas and openpyxl, and run `python clean_complaints.py`. This writes `Consumer_Complaints_Cleaned.csv` (62,516 rows, 25 columns).
2. In MySQL 8.0, run `setup_database.sql`. Then load the CSV into `complaints_raw` with the Workbench Table Data Import Wizard. Check the load with the validation query in the data-quality document.
3. Run `kpi_queries.sql` to reproduce the KPI values.
4. In Power BI Desktop, load the cleaned CSV as `Complaints`. Create the `DimDate` table (marked as the date table) and relate `DimDate[Date]` to `Complaints[Date submitted]`. Create the measures for the KPIs in section 6 in a `Measures` table.

## 6. KPI definitions

| KPI | Definition |
|---|---|
| Total complaints | Count of records (62,516) |
| Annual and monthly volume | Records grouped by year or month of Date submitted |
| By product, sub-product, issue, sub-issue | Record counts. Blank sub-issues and sub-products are labelled "Not specified" |
| Product share % | Complaints in a category / total complaints in the current selection |
| Response distribution | Share of records by Company response to consumer (and by Response Group) |
| Timely % | Yes / (Yes + No). In-progress records are excluded and reported separately |
| In progress | Count of records with response "In progress" |
| Avg and median forwarding interval | Mean and median of (Date received minus Date submitted) in days |
| Year-over-year change | (Volume this year / previous year) minus 1. Like-for-like (May to July) is also shown |
| Over 30 days | Records with forwarding interval above 30 days (analyst threshold) |

## 7. Dashboard pages
1. **Executive Overview:** total complaints, annual trend with a same-months comparison, product distribution, Timely % and forwarding KPIs.
2. **Product and Issue Analysis:** product group treemap, top 10 issues, decomposition tree (product, issue, sub-issue) and top 10 sub-products.
3. **Company Response Analysis:** response categories, untimely count with Timely % by year, in-progress complaints and public response categories.
4. **Complaint Timeline Analysis:** average monthly complaints by year, forwarding interval bands, and the share of long delays by product.

Each page has filters, finding-style titles and a Data Trust note.

## 8. Key findings
See `Business_Insights_and_Recommendations.pdf`. In brief:
- Average monthly complaints rose from 590 in 2019 to 1,141 in 2023.
- Checking & Savings and Credit & Prepaid Cards account for 65.6% of complaints.
- The top 5 issues account for 48.4% of complaints.
- The recorded timely-response rate fell from over 99% (2017 to 2020) to 89.02% in 2021, and was 96.06% overall.
- 79.39% of complaints were forwarded the same day, but 435 took more than 30 days, with a maximum of 275 days.

## 9. Assumptions
- Date submitted is the date the CFPB received the complaint. Date received is the date it was forwarded to the company.
- The Bank of America label comes from the assignment brief.
- 30 days is used as the long-delay threshold.
- Blank Timely response? values belong to In-progress complaints and are not counted as "No".

## 10. Limitations
- No company field, no complaint narratives and no outcome detail, so causes and reasons cannot be determined.
- A complaint does not prove misconduct, and a recorded response does not prove resolution.
- The forwarding interval is not the company's response time.
- 2017 and 2023 are partial years, so full-year comparisons for them can mislead.
- Product Group, short names and the 30-day threshold are analyst choices.
- The data is a static extract. Typed chart titles on the dashboard do not change with filters.

## 11. Business questions covered
This track answers questions 1 to 8 and part of 10 (the interactive dashboard). Question 9 (forecasting) and the AI assistant part of question 10 belong to the Machine Learning and Generative AI tracks, and this work supplies their validated definitions and figures.

## 12. Source
Dataset: Consumer Complaints on Financial Products and Services, Bank of America (2017 to 2023). Data provider: Consumer Financial Protection Bureau (CFPB), supplied by AnalystLab Africa.

Presentation video: https://drive.google.com/drive/folders/1kSvXJrNx8PqoQfT8HtT-dm9dv8MjWTQR?usp=sharing
