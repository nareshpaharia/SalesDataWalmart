create database if not exists salesDataWalmart;

create table if not exists sales(
     invoice_id varchar(30) not null primary key,
     branch varchar(5) not null,
     city varchar(30),
     customer_type varchar(30) not null,
     gender varchar(10) not null,
     product_line varchar(100) not null,
     unit_price decimal(10,2) not null,
     quantity int not null,
     VAT float (6,4) NOT null,
     total decimal (12,4) not null,
     date datetime not null,
     time TIME not null,
     payment varchar(15) not null,
     cogs decimal(10,2) not null,
     gross_margin_pct float(11,9),
     gross_income decimal(12,4) not null,
     rating float(2,1)
);




--  -----------------------------------------------------------------------
--  --------------------- Feature Engineering -----------------------------

-- time_of_day

select time,
(case 
     when 'time' between "00:00:00" and "12:00:00" then "Morning"
     when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
	end) as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day =(
  case 
         when 'time' between "00:00:00" and "12:00:00" then "Morning"
         when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
         else "Evening"
end
);

-- day_name 

select date,
dayname(date) AS day_name
from sales;

alter table sales add column day_name varchar(10);

update sales 
set day_name = dayname(date);


-- month_name
select date,
    monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);


-- ----------------------------------------------------------------------------



-- ----------------------------------------------------------------------------
-- ------------------------ Generic Questions ----------------------------------
# Generic Questions
-- Q1.How many unique cities does the data have?

select distinct city 
from sales;

-- Q2.In which city is each branch?

select distinct branch
from sales;

select distinct city, branch
from sales;



-- --------------------------------------------------------------------------------------
-- ------------------------------------- Product ----------------------------------------

-- Q1.How many unique product lines does the data have?
select distinct product_line from sales;

-- count()
select count(distinct product_line)
from sales;

-- Q2.What is the most common payment method?
select payment
from sales;
-- then we do
select payment,count(payment)
from sales
group by payment;

-- if we want see in order then
select payment, count(payment) as cnt
from sales
group by payment
order by cnt desc;


-- Q3.What is the most selling product line?
select product_line,count(product_line) as cnt
from sales
group by product_line
order by cnt desc ;

-- Q4.What is the total revenue by month?
select month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;


-- Q5.What month had the largest COGS?
select month_name as month,
sum(cogs) as cogs 
from sales
group by month_name
order by cogs desc;


-- Q6.What product line had the largest revenue?
select product_line,
sum(total) as largest_revenue
from sales
group by product_line
order by largest_revenue desc;

-- Q7.What is the city with the largest revenue?
select city,
sum(total) as largest_revenue
from sales
group by city
order by largest_revenue desc;

-- for branch
select city, branch,
sum(total) as largest_revenue
from sales
group by city, branch
order by largest_revenue desc;

-- Q8.What product line had the largest VAT?

select product_line,
    avg(VAT) AS avg_tax
from sales
group by product_line
order by avg_tax desc;


-- Q9.Which branch sold more products than average product sold?
select branch, 
sum(quantity) as qty 
from sales 
group by branch
order by qty desc;

select branch, 
sum(quantity) as qty 
from sales 
group by branch
having sum(quantity) > (select avg(quantity) from sales);


-- Q10.What is the most common product line by gender?

select gender,product_line,
count(gender) as total_cnt
from sales
group by gender,product_line
order by total_cnt desc;


-- Q11.What is the average rating of each product line?

select product_line,round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc ;

-- ---------------------------------------------------------------------------------------
-- ----------------------------------- Sales ---------------------------------------------

-- Q1.Which of the customer types brings the most revenue?
select customer_type,
sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Q2.Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,avg(VAT) as VAT
from sales
group by city
order by VAT DESC;

-- Q3.Which customer type pays the most in VAT?
select customer_type,avg(VAT) as VAT
from sales
group by customer_type
order by VAT DESC; 




-- ---------------------------------------------------------------------------------------
-- -------------------------------------- Customer ---------------------------------------

-- Q1.How many unique customer types does the data have? 
select distinct customer_type
from sales;

-- Q2.How many unique payment methods does the data have? 
select distinct payment
from sales;

-- Q3.Which customer type buys the most? 

select distinct customer_type,
count(*) as cstm_cnt
from sales
group by customer_type;

-- Q4.What is the gender of most of the customers? 

select gender, count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- Q5.What is the gender distribution per branch? 
select gender, count(*) as gender_cnt
from sales
where branch ="B"
group by gender
order by gender_cnt desc;

-- Q6.Which time of the day do customers give most ratings? 

select time_of_day,
avg(rating) as avg_rating 
from sales
group by time_of_day;


-- Q7.Which time of the day do customers give most ratings per branch? 
select time_of_day,
avg(rating) as avg_rating 
from sales
where branch = "C" 
group by time_of_day;

-- Q8.Which day fo the week has the best avg ratings? 

select day_name,
avg(rating) as avg_rating 
from sales
group by day_name
order by avg_rating desc;

-- Q9.Which day of the week has the best average ratings per branch? 

select day_name,
avg(rating) as avg_rating 
from sales
where branch ="A"
group by day_name
order by avg_rating desc;

-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
-- =====================================END============================================
-- ====================================================================================

