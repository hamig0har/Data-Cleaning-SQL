# Data Cleaning Project for Layoffs Dataset

## Project Overview

This project focuses on cleaning and preparing a dataset containing information about layoffs across various companies. The dataset includes details such as company name, location, industry, total number of employees laid off, percentage laid off, date of the layoffs, stage of the company, country, and funds raised in millions.

The primary goal of this project is to clean the data to ensure it is ready for analysis, which includes removing duplicates, standardizing fields, handling null values, and dropping unnecessary columns.

## Dataset

- **Source:** Layoffs dataset (https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv)
- **Fields:**
  - `company`: Name of the company
  - `location`: Location of the company
  - `industry`: Industry in which the company operates
  - `total_laid_off`: Total number of employees laid off
  - `percentage_laid_off`: Percentage of the workforce laid off
  - `date`: Date of the layoffs
  - `stage`: Stage of the company (e.g., Post-IPO, Private Equity)
  - `country`: Country where the company is located
  - `funds_raised_millions`: Funds raised by the company in millions of dollars

## Data Cleaning Steps

1. **Removing Duplicates:**
   - Duplicates were identified and removed based on the combination of all relevant fields.

2. **Standardizing Data:**
   - Trimmed whitespace from `company`, `industry`, and `country` fields.
   - Standardized industry names (e.g., `Crypto`, `Travel`).
   - Standardized country names (e.g., ensuring `United States` is consistent).

3. **Handling Null Values:**
   - Replaced blank fields in `industry` with `NULL` values.
   - Populated missing `industry` values by matching with other records from the same company.

4. **Removing Unnecessary Columns:**
   - Removed the `row_num` column, which was used for identifying duplicates.

## SQL Scripts

The entire data cleaning process was conducted using SQL scripts. The main script file is provided in this repository:

- **Script:** `data_cleaning_script.sql`
- **Description:** This script includes all the SQL commands used to clean the layoffs dataset.

