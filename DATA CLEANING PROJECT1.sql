  -- DATA CLEANING PROJECT- cleanig a raw data into useful data as per requirment 

/* BASIC STEPS 
1. Create a database 
2. Import dataset 
3. clean it */
-- 1. create schema db here rename it. 
-- 2. click db->table-> table data import wizard-> locate the raw file and import -> refresh 
-- 3. select * double click on db world layoff to avoid write it whole time(db selection)

-- CLEANING STEPS 
-- 1. Remove Duplicates
-- 2. Standardize the Data ( spellings...)
-- 3. Null Values or Blank values 
-- 4. Removing any/unnecessary  Cloumns

select * 
from layoffs;

-- copying data from raw table into staging table 
 
CREATE TABLE layoffs_staging
like layoffs;

-- checking 
SELECT * 
FROM layoffs_staging;

-- inserting data from layoffs 

INSERT layoffs_staging
SELECT * 
FROM layoffs;
-- data copied now work only on staging data rather on raw data 
# check here 
SELECT * 
FROM layoffs_staging;

-- 1. REMOVING DUPLICATES 
-- find unique columnn if there exists and try to find duplicates 
-- USING WINDOW FUNCTIONS 
SELECT * ,
ROW_NUMBER() OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num # here use ` ` coz date is default keyword of sql and include all the columns once 

FROM layoffs_staging;
/*now here if rank_num>1 means duplication beacuse ROW_NUMBER()	Assigns 1, 2, 3… per partition (or over the entire set if no partition),
 here if 1 comes means there is only 1 group which is being assigned 1. oherwise in case of similarity it will be more than 1.
 */
 # now apply filter if they have row_num>1 which means duplicacy 

 -- NOW CREATING CTE- for better readability 
 WITH duplicate_cte as 
 (
 SELECT * ,
ROW_NUMBER() OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num # here use ` ` coz date is default keyword of sql and include all the columns once 

FROM layoffs_staging
 )
 SELECT * 
 FROM duplicate_cte 
 where row_num>1;
 
# found duplicacy now we have keep one and rest of the duplicate copy remove it
# verify form duplicate companies ie
SELECT * 
FROM layoffs_staging
WHERE company ='Casper';

# now delete ie 

 WITH duplicate_cte as 
 (
 SELECT * ,
ROW_NUMBER() OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num # here use ` ` coz date is default keyword of sql and include all the columns once 

FROM layoffs_staging
 )
 DELETE 
 FROM duplicate_cte 
 WHERE row_num>1; # here think why? and a a cte can't be upadated error 1288 cause delete acts like update here 

 



# so now create some type of table which has an extra row  and then deleting the actual columns which has values = 2
-- ****** select schema->rc slayoffs-staging->copy to clipboard->create statement->and right lcick and paste blow
 # USE DIFFERENT NAME 
 CREATE TABLE `layoffs_staging5` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SELECT * 
FROM layoffs_staging5;

 INSERT INTO layoffs_staging5 
 SELECT * ,
ROW_NUMBER() OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num # here use ` ` coz date is default keyword of sql and include all the columns once 

FROM layoffs_staging;


# check the values 
SELECT * 
FROM layoffs_staging5;

# now filtering 
SELECT * 
FROM layoffs_staging5
where row_num > 1;

# now delete 
-- Turn off safe updates
SET SQL_SAFE_UPDATES = 0;

DELETE  
FROM layoffs_staging5
where row_num > 1;

SET SQL_SAFE_UPDATES = 1;

# NOW CHECK 
SELECT * 
FROM layoffs_staging5
where row_num > 1;
 
  # CHECK THE WHOLE TABLE 
  
  SELECT * 
FROM layoffs_staging5;
 
 
 # STEP 2 STANDARDIZING DATA- finding issues in your data and fixing it 
 
 -- 1. removing spaces in the begining of company table 
 
 SELECT company,(TRIM(company))
 FROM layoffs_staging5;
  
  # now to update- edit->preference->sql editor-> safe update uncheck and restart
  UPDATE layoffs_staging5
  SET company = TRIM(company);
  

  
  # CHECK 
  SELECT company
  FROM layoffs_staging5;
  
  # industry 
   SELECT DISTINCT industry 
 FROM layoffs_staging5
  ORDER BY 1; # here are some blank columns too so now sue order by, and here crypto, crypto Currency, cryptoCurrency all these are same 
  
  # now to label these so that they they do not be considered as unique 
SELECT *
FROM layoffs_staging5
where industry like 'crypto%';
# now update all them with the name crypto 
UPDATE layoffs_staging5
SET industry ='Crypto'
WHERE industry like 'Crypto%';

# now check 
SELECT *
FROM layoffs_staging5
where industry like 'crypto%';
# apply same if other industry are same 

# now lets clean location table 
 
 SELECT  DISTINCT location
 FROM layoffs_staging5
  ORDER BY 1;# here everything looks good so now move on country
  
  # now for country 
  
   SELECT  DISTINCT country
 FROM layoffs_staging5
  ORDER BY 1; # here united states has some isssue lets fix it 
  # update it 
    SELECT *
  FROM layoffs_staging5
   WHERE country LIKE 'UNITED STATES%'
  ORDER BY 1 ;
  
      SELECT country,TRIM( TRAILING '.' FROM country) # here only trim can't fix the problem so use trailing(coming after) to remove 
  FROM layoffs_staging5
   WHERE country LIKE 'UNITED STATES%'
  ORDER BY 1 ;
  
  UPDATE layoffs_staging5
  SET country = TRIM( TRAILING '.' FROM country)
  WHERE country LIKE 'United States'
  ;
  
  # now for date column, if we go to table-then staging5- then columns -and click on dates it is showing text definiton which does notch with data type so let's fix it 
  
  SELECT `date` # cause here date is a keyword of sql 
  FROM layoffs_staging5;
  
   # now lets format it like date-month-year 
   
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') # here m,d,Y, should follow the same order and only two parameters are required as date, and format 
FROM layoffs_staging5;
  
  # now update 
  UPDATE layoffs_staging5
  SET `date`=STR_TO_DATE(`date`, '%m/%d/%Y');
  
  # now check on 
  SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') #  here m,d,Y, should follow the same order and only two parameters are required as date, and format 
FROM layoffs_staging5;

# still its definition is text so lets cahnge it 
ALTER TABLE layoffs_staging5
MODIFY COLUMN `date` DATE;
 
 # NOW CHECK 
 SELECT * FROM
 layoffs_staging5;
-- now we can use steps to solve issues of different columns like this
# 3. DEALING WITH NULLS AND BLANKS VALUES 


 SELECT * 
 FROM layoffs_staging5
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL; # if two nulls in a row that nearly useless to us now check for combined columns if needed 
 
 SELECT * 
 FROM layoffs_staging5
 WHERE industry IS NULL 
 OR industry = '';# blank 
 
 # now 
 SELECT * 
 FROM layoffs_staging5
 WHERE company ='Airbnb';
 
 
 # we should populate the blank rows and populate the value if any value is available for the same company
 
 # using join 
 SELECT *
 FROM layoffs_staging5 as t1
 JOIN layoffs_staging5 as t2 
   on t1.company = t2.company
 WHERE (t1.industry is NULL OR t1.industry = '')
 AND t2.industry is NOT NULL;
 
    # NOW first  set blanks to nulls  
  UPDATE layoffs_staging5
  SET industry = NULL
  WHERE industry ='';
  
 
 
 
 # now update 
 UPDATE layoffs_staging5 as t1
 JOIN layoffs_staging5 as t2 
   on t1.company = t2.company
SET t1.industry = t2.industry
    WHERE t1.industry is NULL 
 AND t2.industry is NOT NULL; 
  
   # now check 
  
   SELECT * 
   FROM layoffs_staging5
   WHERE company ='Airbnb';
   
   # now final points 
   SELECT * 
   FROM layoffs_staging5 
   WHERE total_laid_off IS NULL
   AND percentage_laid_off IS NULL; # here deleting these rows depends on instructions because we have no data to populate but for now we can't trust that data so we have to delete it 
   
   
# so deleting it 
DELETE 
   FROM layoffs_staging5 
   WHERE total_laid_off IS NULL
   AND percentage_laid_off IS NULL;
   
   # NOW LETS CHECK 
   SELECT * 
   FROM layoffs_staging5;

# here now we dont need row_num anymore 
ALTER TABLE layoffs_staging5
DROP COLUMN row_num;

  # THANK YOU! now our data is cleaned.

