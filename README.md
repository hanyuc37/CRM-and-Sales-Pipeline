# CRM-and-Sales-Pipeline

## 1. Business Goals Overview
XX Company seeks insights and evaluations from its CRM data and sales pipeline for leads registered over the last five months. The primary objectives are to **assess the sales pipeline's health**, **forecast potential income for the next six months**, and **compare sales agent performance**.

Our goal is to conduct a thorough analysis and create an interactive dashboard that enables our client to monitor salesperson performance, maintain the health of the sales pipeline, identify opportunities, enhance customer relations, make informed decisions, and optimize their strategies. 

## 2. Technical Highlights

To enhance our understanding of the dataset, we established an **SQL**  database, conducted data cleaning operations, and utilized queries and aggregation to extract meaningful insights. We employed **subqueries, window functions, and WITH clauses** extensively to extract information in a clear and structured format.
  
* **Sales funnel in %:** The sales funnel stage includes Opening, initial contact, nurturing, proposal sent, and won. It's crucial to visualize and understand the flow of leads through various stages of a CRM process.
It provides insights into % records that have progressed through each stage relative to the total number that started at the "Opened" Stage. 91.9% of leads were contacted initially by sales agents, 55% were nurtured, 27.7% were sent, and lastly, 10.3% won the proposal.
![sales funnel](https://github.com/user-attachments/assets/3418ebc9-310c-437a-9b8a-a71d53f7bb3c)

* **Industry View**: Understanding the main industries that the salespersons target, and the actual sales amount, unit sold, and main product/service of each industry helps them to adjust their target and optimize the strategies. Recreation & Sports, Retail & Distribution, and Entertainment & Media & Hospitality are the top 3 industries that generate the most sales amount and units sold.

![industry view pt1](https://github.com/user-attachments/assets/40b16b58-d3cd-4ece-b30f-0221be498383)

![indsutry view pt2](https://github.com/user-attachments/assets/f6ba08cb-abd7-4224-a2da-f13f352559f0)

* **Sales Productivity Track**: It helps in gaining insights into sales performance and effectiveness across different salespersons, facilitating informed decision-making and strategy optimization within a CRM context. To track each salesperson's productivity, Total Leads, Conversion Rate, Average Days to Convert, Advance Completion Time, and Customer Churn Rate are the KPIs to identify the Top Salesperson based on different criteria. The example provided below is ranked based on the conversion rate. 

![SALES PRODUCTIVITY 1](https://github.com/user-attachments/assets/20c95991-2e38-4f41-b5ec-12aa4e2074a2)

![SALES PRODUCTIVITY 2](https://github.com/user-attachments/assets/91b1cd66-ab72-4913-91a4-0ad494acd518)

![Sales](https://github.com/user-attachments/assets/6c1e22fe-2f7b-4eaf-9a25-812273bde744)

## 3. Insights and Dashboards

To track the health of the sales pipeline and monitor salesperson's sales performance, we created an interactive dashboard to showcase the performance. The dashboards are broken down into two parts, 

* **Sales Pipeline Overview**: the business overview where our clients can access high-level information such as the number of leads, amount of sales, number of customers monthly as well as the overall churn rate. The overview dashboard also contains information on the lead's demographical information such as the industry that they belong to, company size, countries that they reside in, and the service or product they acquire, where our clients can better target the leads and adjust the sales strategies.
![Sales pipeline overview](https://github.com/user-attachments/assets/f7947883-97b0-417c-81be-a895ae009a15)

* For example, Customer Solutions account for only 19.7% of all products and services. To increase the acquisition of Customer Solutions, it is recommended to target medium-sized companies in the IT services sector, as they generate the most sales per customer, have a decent conversion rate, and account for a significant portion of total customers.

* Month-to-month sales status is another key metric for monitoring customer status, allowing for monthly comparisons. This includes tracking the count of new customers, disqualified customers, churned customers, and opportunities, among other factors.


* **Sales Productivity Tracking**: The performance of salespersons is closely tied to the company's overall sales. Key performance indicators (KPIs) such as total leads, total customers, conversion rate, average conversion days, and total sales are utilized to evaluate each salesperson's performance and productivity. The sales funnel tracks leads as they progress through various stages, from the opened stage to the won stage.
One critical factor in sales efficiency is the time spent converting a customer. For instance, by comparing the average conversion time across salespersons, our clients can identify those who may need to adjust their sales strategies if their performance falls below the average.
![salesperson db](https://github.com/user-attachments/assets/c9c783bb-f174-426a-bace-dcb514611291)

## 4. Dashboard Link
https://public.tableau.com/app/profile/hanyu.chen7482/vizzes



