-- Data Cleaning Process for Layoffs Data

-- Step 1: Create a staging table to work on data cleaning
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Verify the creation of the staging table
SELECT * 
FROM layoffs_staging;

-- Step 2: Insert data from the original layoffs table into the staging table
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- Step 3: Identify and remove duplicate records
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions 
               ORDER BY company) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;  -- View duplicate records

-- Create a second staging table to remove duplicates
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  `date` TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Step 4: Insert data into the new staging table, adding row numbers to identify duplicates
INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER(
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions 
           ORDER BY company) AS row_num
FROM layoffs_staging;

-- Step 5: Delete duplicate records based on row numbers
SET SQL_SAFE_UPDATES = 0;  -- Disable safe update mode temporarily

DELETE
FROM layoffs_staging2
WHERE row_num > 1;  -- Remove all rows except the first instance of each duplicate

-- Verify the result after deleting duplicates
SELECT *
FROM layoffs_staging2;

-- Step 6: Standardize data - Trim whitespace and correct values

-- Trim company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize industry names
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Trim trailing dots from country names
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Step 7: Standardize the date format

-- Convert date strings to date format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Modify the date column to ensure it's stored as a DATE type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Step 8: Handle null values

-- Identify and delete rows with null values in critical columns
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Set industry to NULL where the field is blank or contains only spaces
UPDATE layoffs_staging2
SET industry = NULL
WHERE TRIM(industry) = '' OR industry IS NULL;

-- Step 9: Fill in missing industry values using information from other records
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Verify if the industry value for Airbnb has been updated correctly
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Step 10: Clean up - Remove the row number column now that deduplication is complete
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final verification of cleaned data
SELECT *
FROM layoffs_staging2;


