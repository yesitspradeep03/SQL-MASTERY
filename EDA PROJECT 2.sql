 -- Exploratory Data Analysis-data analysis/data science process where you deeply explore and understand a dataset before applying any models or algorithms.
 
 
 SELECT * 
 FROM layoffs_staging5;
 
 # with column total laid off
 # taking column info 
  SELECT MAX(total_laid_off), MAX(percentage_laid_off)
 FROM layoffs_staging5;
 
 # PARSING TABLES 
  SELECT * 
 FROM layoffs_staging5
 WHERE percentage_laid_off=1
 ORDER BY total_laid_off DESC; #  1 implies 100% laid off which is not a good sign
 
 # with funds raised in million 
   SELECT * 
 FROM layoffs_staging5
 WHERE percentage_laid_off=1
 ORDER BY  funds_raised_millions DESC;
 
 
    SELECT company, SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY company
 ORDER BY 2 DESC;
 
 # PARSING DATE RANGES 
 SELECT MIN(`date`), MAX(`date`)
 FROM layoffs_staging5;

# INDUSTRY PARSING FOR MOST LAYOFF
    SELECT industry, SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY industry
 ORDER BY 2 DESC;
 
 # PARSING COUNTRY TABLE 
    SELECT country, SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY country
 ORDER BY 2 DESC;
 # PARSING WITH DATE 
    SELECT `date`, SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY `date`
 ORDER BY 2 DESC;
 
 # PARSING WITH YEAR 
 
     SELECT YEAR(`date`), SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY `date`
 ORDER BY 2 DESC;
 
 #WITH STAGE 
   SELECT stage, SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY stage
 ORDER BY 2 DESC;
 
 # finding good indicator like sum or % 
  SELECT company, SUM(percentage_laid_off)
 FROM layoffs_staging5
 GROUP BY company
 ORDER BY 2 DESC; # here find % laid off is better parameter
 
 
 # NOW LOOK FOR PROGRESSION OF LAYOFF - A ROLLING SUM
 # pulling out month 
 SELECT substring(`date`,1,7) as `month`, SUM(total_laid_off)
 FROM layoffs_staging5
 WHERE substring(`date`,6,2) IS NOT NULL
 GROUP BY `month`
 ORDER BY 1 ASC;
 
 
 # GETTING ROLLING SUM 
 WITH Rolling_total as 
 (
  SELECT substring(`date`,1,7) as `month`, SUM(total_laid_off) AS total_off
 FROM layoffs_staging5
 WHERE substring(`date`,1,7) IS NOT NULL
 GROUP BY `month`
 ORDER BY 1 ASC
 )
 SELECT `month`,total_off,
 SUM(total_off) OVER(ORDER BY `month`) as rolling_total
 FROM Rolling_total;
 
 #with comapany again
 SELECT company, SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY company 
 ORDER BY 2 DESC;
 
 SELECT company, YEAR(`date`), SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY company, `date`
 ORDER BY company ASC;
 # RANKING WHICH YEAR THEY LAID OFF MOST OF THE EMPLOYEES
 
  SELECT company, YEAR(`date`), SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY company, YEAR(`date`)
 ORDER BY 3 DESC;
 
 
 WITH Company_Year  AS 
 (
 SELECT company, YEAR(`date`), SUM(total_laid_off)
 FROM layoffs_staging5
 GROUP BY company, YEAR(`date`)
 )
 SELECT * 
 FROM Company_Year;
 
 
 # now changing column names 
  WITH Company_Year (company, years, total_laid_off) AS 
(
  SELECT 
    company, 
    YEAR(`date`) AS years, 
    SUM(COALESCE(total_laid_off, 0)) AS total_laid_off
  FROM layoffs_staging5
  WHERE `date` IS NOT NULL
  GROUP BY company, YEAR(`date`)
)

SELECT * 
FROM Company_Year;
  
  
  # now lets find who laid off most 
  
  WITH Company_Year (company, years, total_laid_off) AS 
(
  SELECT 
    company, 
    YEAR(`date`) AS years, 
    SUM(COALESCE(total_laid_off, 0)) AS total_laid_off
  FROM layoffs_staging5
  WHERE `date` IS NOT NULL
  GROUP BY company, YEAR(`date`)
)

SELECT *, 
       DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;


 WITH Company_Year (company, years, total_laid_off) AS 
(
  SELECT 
    company, 
    YEAR(`date`) AS years, 
    SUM(COALESCE(total_laid_off, 0)) AS total_laid_off
  FROM layoffs_staging5
  WHERE `date` IS NOT NULL
  GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(
SELECT *, 
       DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC
)
SELECT * 
FROM Company_year_rank
WHERE Ranking <=5
ORDER BY Ranking DESC
;
 
 
 # THANK YOU! 
