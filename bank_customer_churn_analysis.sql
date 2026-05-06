select * from customer_churn;



#Overall Churn Rate KPI
select round(sum(Exited)/(select count(*) from customer_churn)*100,2) as overall_churn_cust
from customer_churn
where Exited=1;

#Which geography (country/region) has the highest number of customers?
select Geography,count(*) as total_customers
from customer_churn
group by Geography
order by total_customers desc
limit 1;

#Average Credit Score KPI
select round(avg(CreditScore),2) as avg_creditScore
from customer_churn;

#What percentage of customers have raised complaints?
select round((sum(case when Complain=1 then 1 else 0 end)/count(*))*100,2) as complain_rate
from customer_churn;


#How does customer churn rate vary across different tenure groups?
select Tenure_Group ,
round(sum(case when Exited=1 then 1 else 0 end)/count(*)*100,2) as ChurnRate_by_Tenure
from customer_churn
group by Tenure_Group;

#How does the average credit score vary across different age groups?
select Age_category,round(avg(CreditScore),2) as avg_creditscore_agegroup
from customer_churn
group by Age_category;

#How does average account balance change as customer tenure increases?
select Tenure_Group ,
round(avg(Balance),2) as avg_balance_tenure
from customer_churn
group by Tenure_Group;

#How many customers churned in each tenure year?
select Tenure_Group ,
sum(Exited) as total_churn
from customer_churn
group by Tenure_Group;

#How does churn rate differ across gender and geography segments?
select Gender,Geography,
round(sum(case when Exited=1 then 1 else 0 end)/count(*)*100,2) as churn_by_Gender_Geography
from customer_churn
group by Gender,Geography;

#Which top 5 card types have the highest average points earned by customers?
select `Card Type`,round(avg(`Point Earned`),2) as avg_point_by_cardtype
from customer_churn
group by `Card Type`;

#How are customers segmented into high-value and low-value groups based on balance range?
 SELECT 
	CASE WHEN Balance > 100000 AND IsActiveMember = 1 THEN 'High-Value Active' 
	WHEN Balance > 100000 THEN 'High-Value Inactive' 
    ELSE 'Low-Value' 
END AS Segment, 
	COUNT(*) AS CustomerCount 
    FROM customer_churn 
GROUP BY 
	CASE WHEN Balance > 100000 AND IsActiveMember = 1 THEN 'High-Value Active' 
	WHEN Balance > 100000 THEN 'High-Value Inactive' 
    ELSE 'Low-Value' END;
	
#Churn by Satisfaction Score
select `Satisfaction Score`,sum(Exited) as churn_by_SatisfactionScore
from customer_churn
group by `Satisfaction Score`;

#Rank Customers by Points
select 
	`Point Earned`,
    dense_rank() over(order by `Point Earned` desc) as rank_by_points
from customer_churn;

#For each card type, how many customers have a balance above their own card type’s average balance?
SELECT 
	CardType, 
	COUNT(*) AS AboveAvgCount 
FROM customer_churn c 
WHERE Balance > (SELECT AVG(Balance) FROM customer_churn WHERE CardType = c.CardType) 
GROUP BY CardType;

#Complaint Impact on Churn
SELECT 
	Complain, 
    ROUND((SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS ChurnRate 
FROM customer_churn 
GROUP BY Complain;
