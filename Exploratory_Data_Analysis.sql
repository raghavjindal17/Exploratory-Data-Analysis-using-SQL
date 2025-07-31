-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging_2;

ALTER TABLE layoffs_staging_2
MODIFY COLUMN total_laid_off INT;

SELECT MAX(total_laid_off)
FROM layoffs_staging_2;

SELECT *
FROM layoffs_staging_2
WHERE total_laid_off = (SELECT MAX(total_laid_off)
FROM layoffs_staging_2);

UPDATE layoffs_staging_2
SET percentage_laid_off  = TRIM(TRAILING '%' FROM percentage_laid_off);

ALTER TABLE layoffs_staging_2
MODIFY COLUMN percentage_laid_off INT;

SELECT *
FROM layoffs_staging_2
ORDER BY percentage_laid_off DESC;

SELECT MAX(percentage_laid_off)
FROM layoffs_staging_2;

SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = (SELECT MAX(percentage_laid_off)
FROM layoffs_staging_2);

UPDATE layoffs_staging_2
SET funds_raised  = TRIM(LEADING '$' FROM funds_raised);

ALTER TABLE layoffs_staging_2
MODIFY COLUMN funds_raised INT;

SELECT *
FROM layoffs_staging_2
ORDER BY funds_raised DESC;

SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = 100
ORDER BY funds_raised DESC;

SELECT * 
FROM layoffs_staging_2
WHERE percentage_laid_off = 100
ORDER BY `date` DESC;

SELECT *
FROM layoffs_staging_2
WHERE country = 'India'
ORDER BY industry;

SELECT industry, COUNT(*) total
FROM layoffs_staging_2
GROUP BY industry
ORDER BY total DESC;

SELECT DISTINCT company, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging_2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY country
ORDER BY 2 DESC;

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY `date`
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging_2
WHERE  percentage_laid_off = 100
ORDER BY funds_raised DESC;

SELECT year(date), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY year(date)
ORDER BY 2 DESC;

SELECT month(date), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY month(date)
ORDER BY 2 DESC;

--------------------------------------------------------------------------------------------------

WITH layoff_by_year AS(
    SELECT company, LEFT(date,4) year_, SUM(total_laid_off) total
    FROM layoffs_staging_2
    GROUP BY company, year_
),
layoff_rank AS(
    SELECT company, year_, total, DENSE_RANK() OVER(PARTITION BY year_ ORDER BY total DESC) rank_
    FROM layoff_by_year
)
SELECT company, year_, total, rank_
FROM layoff_rank
WHERE rank_ <= 3
AND year_ IS NOT NULL
ORDER BY year_ ASC, total DESC;

--------------------------------------------------------------------------------------------------

WITH dates_cte AS(
    SELECT LEFT(date,7) dates, SUM(total_laid_off) total
    FROM layoffs_staging_2
    GROUP BY dates
)
SELECT dates, SUM(total) OVER(ORDER BY dates ASC) rolling_total
FROM dates_cte
ORDER BY dates ASC;

--------------------------------------------------------------------------------------------------
--The End
--Raghav Jindal
