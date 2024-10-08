-- DATABASE CREATION
/* 
 DATABASE CREATION
 The first section is to create a SQL database which contains all the necessary information and ensure the data types and structure for better further analysis 
 */

-- Create a Schema
CREATE SCHEMA CRM;
USE CRM;
-- Create a table contains all the CRM information
CREATE TABLE CRM_INFO (
Id INT PRIMARY KEY,
Organization VARCHAR(200) NOT NULL,
Country VARCHAR(200) NOT NULL,
Lattitude DECIMAL(10,8),
Longitude DECIMAL(11,8),
Industry VARCHAR(200),
Organization_size VARCHAR(200),
Salesperson VARCHAR(200),
Lead_acquisition_date DATE,
Product VARCHAR(200),
Status VARCHAR(200),
Status_seq INT,
Stage VARCHAR (200), -- contains "N/A"
Stage_seq VARCHAR(200), -- contains "N/A", will convert to INT
Deal_value INT,
Probability INT,
Expected_close_date DATE,
Actual_close_date VARCHAR(200) -- contains "N/A", will convert to DATE
);
-- DROP TABLE CRM_INFO;

-- Load csv. file to the CRM_INFO table
LOAD DATA INFILE 'CRM and Sales Pipelines_cleaned.csv'
INTO TABLE CRM_INFO
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM CRM_INFO;

-- Replace ";" to "," where I replaced all the "," in the excel file to ";" since the csv. file is separated by commas
UPDATE CRM_INFO
SET Organization = REPLACE(Organization, ";", ",");

-- Change text "N/A" as NULL
UPDATE CRM_INFO
SET Actual_close_date = CASE WHEN Actual_close_date LIKE 'N/A%' THEN NULL ELSE Actual_close_date END;
    
UPDATE CRM_INFO
SET 
    Stage = NULLIF(Stage, 'N/A'),
    Stage_seq = NULLIF(Stage_seq, 'N/A');
    
-- Change the Actual_close_date to DATE
ALTER TABLE CRM_INFO
MODIFY COLUMN Actual_close_date DATE;

/* 
DATA OBSERVATION
For better understanding the dataset and the project objectives, I use T-SQL command to querry and aggregate data to gain some basic insights.
*/


/* Conversion Rate: The conversion rate stands as the pivotal KPI for assessing the vitality of a sales pipeline. 
To delineate customers, I tally the frequency of leads categorized under statuses such as "Customer","Sales Accepted", and "Churned Customer".
*/
WITH customer_cnt AS
	(
    SELECT
		  COUNT(*) AS Total_customer
	FROM CRM_INFO
	WHERE Status IN ("Customer","Sales Accepted","Churned Customer")
    ),
lead_cnt AS
	(
	SELECT
		COUNT(*) AS Total_lead
	FROM CRM_INFO
    )
SELECT 
		CONCAT(ROUND(Total_customer/Total_lead,2) * 100, ' ' , '%' ) AS Conversion_Rate
FROM customer_cnt, lead_cnt;

--  Deal Cycle Time 
	-- Actual _close_date - Lead_acquistion_date 
/* Deal Cycle Time: The time it takes to convert a customer, known as the Deal Cycle Time. 
Understanding this duration allows us to set sales goals based on day ranges andn average conversion time,
aiming to optimize efficiency without compromising service quality. 
*/
SELECT 
	   MIN(TIMESTAMPDIFF(DAY,Lead_acquisition_date, Actual_close_date)) AS Min_convert_days,
       MAX(TIMESTAMPDIFF(DAY,Lead_acquisition_date, Actual_close_date)) AS Max_convert_days,
	   FLOOR(AVG(TIMESTAMPDIFF(DAY,Lead_acquisition_date, Actual_close_date))) AS Avg_convert_days,
       FLOOR(STDDEV_POP(TIMESTAMPDIFF(DAY,Lead_acquisition_date, Actual_close_date))) AS std
FROM CRM_INFO
WHERE Status IN ("Customer","Sales Accepted","Churned Customer");

	-- Won Rate
    -- the percentage of proposals that won the bid 
WITH Won AS
(
SELECT 
	COUNT(*) AS won_cnt
FROM CRM_INFO
WHERE Stage = "Won"
),
All_stages AS
(
SELECT 
	COUNT(*) AS stage_cnt
FROM CRM_INFO
WHERE Stage IS NOT NULL
)
SELECT 
	CONCAT(ROUND(won_cnt/stage_cnt *100,2), ' ' , '%') AS Won_rate
FROM All_stages, Won;




/* It's crucial to visualize and understand the flow of leads through various stages if a CRM process.
It provides insights into % records have progressed through each stage relative to the total number that started at the "Opened" Stage.

*/

CREATE TABLE Sales_Funnel AS
	WITH accumulated_t AS
	(	
		SELECT
			  DISTINCT Salesperson,
			  Stage,
			  COUNT(*) OVER (PARTITION BY Salesperson ORDER BY Stage_seq DESC) AS accumulated_cnt
		FROM CRM_INFO
		WHERE Stage <> 'Lost' 
		AND Stage IS NOT NULL
		),
	opened_cnt AS
	(SELECT
			Salesperson, 
			accumulated_cnt AS opened_cnt
	FROM accumulated_t
	WHERE Stage = 'Opened'
	)
	SELECT accumulated_t.Salesperson,
		   Stage,
		   ROUND(accumulated_cnt/opened_cnt,4) AS stage_percentage
	FROM accumulated_t
	INNER JOIN opened_cnt
	ON accumulated_t.Salesperson = opened_cnt.Salesperson;


/* Industry Views
Understanding the primary industries targeted by salespersons, along with the actual sales amount, units sold, and key products or services within each industry, 
enables them to refine their targets and optimize their strategies effectively. 
Recreation & Sports, Retail & Distribution, and Entertainment & Media & Hospitality emerge as the top three industries generating the highest sales amounts and unit sales. 
This insight guides salespersons in adjusting their goals and refining their approach to maximize success in these lucrative sectors.
*/
    WITH total_potential_sales_t AS
    (SELECT Industry,
			FLOOR(AVG(Deal_value))AS Avg_potential_sales
		FROM CRM_INFO
		GROUP BY 1),
		Actual_sales_t AS
		(SELECT Industry,
				FLOOR(AVG(Deal_value)) AS Avg_Actual_sales,
				COUNT(*) AS Unit_sales
		FROM CRM_INFO
		WHERE Status IN ("Customer","Sales Accepted","Churned Customer")
		GROUP BY 1
    ),
    Main_prod_t AS
    (SELECT Industry,
			Product
	 FROM 
			(SELECT Industry,
					Product,
					RANK()OVER(PARTITION BY Industry ORDER BY cnt DESC, Product ASC) AS rks
			 FROM 
				 (SELECT Industry,
						 Product,
						COUNT(*) AS cnt
				FROM CRM_INFO
                WHERE Status IN ("Customer","Sales Accepted","Churned Customer")
				GROUP BY 1, 2)temp
			)temp1
		WHERE rks = 1)
        
	SELECT t1.Industry,
		   Avg_potential_sales,
           Avg_Actual_sales,
           Unit_sales,
           Product AS Main_product_sales
	FROM total_potential_sales_t t1
    LEFT JOIN Actual_sales_t t2
    ON t1. Industry = t2.Industry
    INNER JOIN Main_prod_t t3
    ON t2.Industry = t3.Industry
    ORDER BY 3 DESC, 4 DESC;
    
/* Oragnization Size View
Understand the performance of different organization sizes in terms of actual versus expected sales count, and the conversion rate. 
It helps evaluating the effectiveness of sales stragies across different sizes within a CRM context.
Adjustments can be made based on specific business requirements and additional filters or conditions can be applied as necessary.
*/
WITH Actual_org_sales AS
	(
    SELECT Organization_size,
		   COUNT(*) AS Actual_cnt
	FROM CRM_INFO
	WHERE Status IN ("Customer","Sales Accepted","Churned Customer")
	GROUP BY 1
    ),
	Expected_org_sales AS
    (
    SELECT Organization_size,
			COUNT(*) AS Expected_cnt
	FROM CRM_INFO
    GROUP BY 1
    )
    SELECT t2.Organization_size,
		  Actual_cnt,
		  Expected_cnt,
          CONCAT(ROUND((Actual_cnt/Expected_cnt*100),1),'%') AS percentage_converted
	FROM Actual_org_sales t1
    RIGHT JOIN Expected_org_sales t2
    ON t1.Organization_size = t2.Organization_size
    ORDER BY 2 DESC,4 DESC;
		
/* Salesperson's Productivity
 It helps in gaining insights into sales performance and effectiveness across different salespersons, 
 facilitating informed decision-making and strategy optimization within a CRM context.
Matrics:
Total_lead: Total number of leads for each salesperson.
Total_sales: Total sum of deal values for each salesperson.
Conversion_Rate: Percentage of leads that converted into customers.
Avg_days_to_convert: Average number of days to convert a lead into a customer.
Advance_completion_time: Average number of days ahead or behind the expected close date.
Churn_Rate: Percentage of churned customers relative to total customers.
*/
WITH Customer_sales AS 
	(SELECT Salesperson,
		   SUM(Deal_value) AS Total_sales,
           COUNT(*) AS Total_customer,
           FLOOR(AVG(TIMESTAMPDIFF(DAY, Lead_acquisition_date, Actual_close_date))) AS Avg_days_to_convert,
           FLOOR(AVG(TIMESTAMPDIFF(DAY, Actual_close_date,Expected_close_date))) AS Advance_completion_time
	FROM CRM_INFO
    WHERE Status IN ("Customer","Sales Accepted","Churned Customer")
    GROUP BY 1),
    
	Total AS
    (SELECT Salesperson,
		   COUNT(*) AS Total_lead
	FROM CRM_INFO
    GROUP BY 1),
    
    Customer_churned AS
    (SELECT Salesperson,
		   COUNT(*) AS Churned_customer
    FROM CRM_INFO
    WHERE Status = "Churned Customer"
    GROUP BY 1)
    
    SELECT t1.Salesperson,
		   Total_lead,
           Total_sales,
           CASE WHEN (CONCAT(ROUND(Total_customer/Total_lead*100,1), "%")) IS NULL THEN 0
           ELSE CONCAT(ROUND(Total_customer/Total_lead*100,1), "%") END AS Conversion_Rate,
           Avg_days_to_convert,
           Advance_completion_time,
           CASE WHEN (CONCAT(ROUND(Churned_customer/(Total_customer+ Churned_customer) *100,1),"%")) IS NULL THEN 0 
				ELSE CONCAT(ROUND(Churned_customer/(Total_customer+ Churned_customer) *100,1),"%") END AS Churn_Rate
	FROM Total t1
    LEFT JOIN Customer_sales t2
    ON t1. Salesperson = t2.Salesperson
    LEFT JOIN  Customer_churned t3 
    ON t2.Salesperson = t3.Salesperson
    ORDER BY 4 DESC;
           