# CRM-and-Sales-Pipeline

## 1. Business Goals Overview
XX Company seeks insights and evaluations from its CRM data and sales pipeline for leads registered over the last five months. The primary objectives are to **assess the sales pipeline's health**, **forecast potential income for the next six months**, and **compare sales agent performance**.

Our goal is to conduct a thorough analysis and create an interactive dashboard that enables our client to monitor salesperson performance, maintain the health of the sales pipeline, identify opportunities, enhance customer relations, make informed decisions, and optimize their strategies. 

## 2. Technical Highlights

To enhance our understanding of the dataset, we established an **SQL**  database, conducted data cleaning operations, and utilized queries and aggregation to extract meaningful insights. We employed **subqueries, window functions, and WITH clauses** extensively to extract information in a clear and structured format.

* **Conversion Rate:** The conversion rate is one of the KPIs used to evaluate sales performance.  29% of the leads were successfully converted to customers. 

![conversion rate](https://github.com/user-attachments/assets/4ae750e8-abc2-409a-961f-44664c6bf0bf)
* **Days that takes to convert a lead to a customer** gives a distribution of the range, average, maximum, and minimum days a lead converts to a customer. It takes 1-120, with an average of 63 days (std 34 days) of cycle time to convert a lead to a customer.
  
![days takes to convert a lead](https://github.com/user-attachments/assets/3b34ef9c-9d0e-4948-b807-39d9b978abd9)

* **Sales funnel in %:** The sales funnel stage includes Opening, initial contact, nurturing, proposal sent, and won. It's crucial to visualize and understand the flow of leads through various stages of a CRM process.
It provides insights into % records that have progressed through each stage relative to the total number that started at the "Opened" Stage. 91.9% of leads were contacted initially by sales agents, 55% were nurtured, 27.7% were sent, and lastly, 10.3% won the proposal.

![saels funnel](https://github.com/user-attachments/assets/adb904a5-b330-4a92-a343-0a064b6e4422)

* **Industry View**: Understanding the main industries that the salespersons target, and the actual sales amount, unit sold, and main product/service of each industry helps them to adjust their target and optimize the strategies. Recreation & Sports, Retail & Distribution, and Entertainment & Media & Hospitality are the top 3 industries that generate the most sales amount and units sold.

![industry view pt1](https://github.com/user-attachments/assets/40b16b58-d3cd-4ece-b30f-0221be498383)

![indsutry view pt2](https://github.com/user-attachments/assets/f6ba08cb-abd7-4224-a2da-f13f352559f0)

* **Sales Productivity Track**: It helps in gaining insights into sales performance and effectiveness across different salespersons, facilitating informed decision-making and strategy optimization within a CRM context. To track each salesperson's productivity, Total Leads, Conversion Rate, Average Days to Convert, Advance Completion Time, and Customer Churn Rate are the KPIs to identify the Top Salesperson based on different criteria. The example provided below is ranked based on the conversion rate. 

![SALES PRODUCTIVITY 1](https://github.com/user-attachments/assets/20c95991-2e38-4f41-b5ec-12aa4e2074a2)

![SALES PRODUCTIVITY 2](https://github.com/user-attachments/assets/91b1cd66-ab72-4913-91a4-0ad494acd518)

![Sales](https://github.com/user-attachments/assets/6c1e22fe-2f7b-4eaf-9a25-812273bde744)


