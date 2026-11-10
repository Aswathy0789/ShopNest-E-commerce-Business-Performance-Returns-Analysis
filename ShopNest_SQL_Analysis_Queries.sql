SET SQL_SAFE_UPDATES = 0;
SELECT COUNT(*) FROM FactOrders WHERE PaymentMode = 'Cod';

UPDATE FactOrders
SET PaymentMode = 'Cash On Delivery'
WHERE PaymentMode = 'Cod';

Select count(orderId)
From Factorders;

Select count(OrderId) AS total_orders, Sum(UnitPrice*Quantity) AS total_revenue
From factOrders;

-- Count of each Orderstatus --
Select count(OrderId) as Total_orders, Orderstatus
From FactOrders
Group by Orderstatus;

-- Return Revenue --
SELECT ROUND(SUM(UnitPrice * Quantity), 2) AS returned_revenue
FROM FactOrders
WHERE OrderStatus IN ('Returned', 'Refunded');

Select 
ROUND(SUM(UnitPrice * Quantity), 2) AS total_revenue,
ROUND(SUM(CASE WHEN OrderStatus IN ('Returned','Refunded') THEN UnitPrice * Quantity ELSE 0 END), 2) AS returned_revenue,
ROUND(SUM(CASE WHEN OrderStatus IN ('Returned','Refunded') THEN UnitPrice * Quantity ELSE 0 END) * 100 / SUM(UnitPrice * Quantity), 2) AS returned_revenue_percentage
FROM FactOrders;

-- Return rate for each order --
Select count(*) as Total_orders,
Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End) as Total_returned_orders,
Round(Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End)*100/(Count(*)),2) As return_rate_percentage
From FactOrders
Order by return_rate_percentage Desc;

-- Cancellation rate for each order --
Select count(*) as Total_orders,
SUM(CASE WHEN OrderStatus = "Cancelled" then 1 else 0 End) as Total_cancelled_orders,
ROUND(SUM(CASE WHEN OrderStatus ="Cancelled" then 1 else 0 End) * 100 / (Count(*)),2) As cancelled_rate_percentage
From FactOrders
Order by Cancelled_rate_percentage Desc;



-- Cancellation Revenue --

SELECT ROUND(SUM(UnitPrice * Quantity), 2) AS Cancelled_revenue
FROM FactOrders
WHERE OrderStatus="Cancelled";

-- Cancelled rate revenue --
Select 
    ROUND(SUM(UnitPrice * Quantity), 2) AS total_revenue,
    ROUND(SUM(CASE WHEN OrderStatus = "Cancelled" THEN UnitPrice * Quantity ELSE 0 END), 2) AS Cancelled_revenue,
    ROUND(SUM(CASE WHEN OrderStatus ="Cancelled" THEN UnitPrice * Quantity ELSE 0 END) * 100 / SUM(UnitPrice * Quantity), 2) AS Cancelled_revenue_percentage
FROM FactOrders;

-- cancellation per product category --
Select dp.ProductCategory, COUNT(*) AS total_orders,
SUM(CASE WHEN fo.OrderStatus = "Cancelled" THEN 1 ELSE 0 END) AS total_cancels,
ROUND(SUM(CASE WHEN fo.OrderStatus = "Cancelled" THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS cancelled_rate_percentage
From FactOrders fo
Join DimProducts dp ON dp.ProductID = fo.ProductID
Group by dp.ProductCategory
Order by cancelled_rate_percentage DESC;

-- return rate per prodcut category

Select dp.ProductCategory, COUNT(*) AS total_orders,
Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End) as Total_returned_orders,
Round(Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End)*100/(Count(*)),2) As return_rate_percentage
From FactOrders fo
Join DimProducts dp ON dp.ProductID = fo.ProductID
Group by dp.ProductCategory
Order by return_rate_percentage DESC;

-- Cancellation per paymentMode --
Select PaymentMode, COUNT(*) AS total_orders,
SUM(CASE WHEN OrderStatus = "Cancelled" THEN 1 ELSE 0 END) AS total_cancels,
ROUND(SUM(CASE WHEN OrderStatus = "Cancelled" THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS cancelled_rate_percentage
From FactOrders 
Group by PaymentMode
Order by cancelled_rate_percentage DESC;

-- return rate per paymentMode
Select PaymentMode , COUNT(*) AS total_orders,
Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End) as Total_returned_orders,
Round(Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End)*100/(Count(*)),2) As return_rate_percentage
From FactOrders 
Group by PaymentMode
Order by return_rate_percentage DESC;

-- Return rate each state --
Select dm.CustomerState, count(*) As total_orders,
Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End) as Total_returned_orders,
Round(Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End)*100/(Count(*)),2) As return_rate_percentage
From FactOrders as fo
Join DimCustomers as dm
On dm.CustomerId=fo.CustomerId
Group by dm.CustomerState
Order by return_rate_percentage DESC;

-- Cancellation rate each state --
select dm.CustomerState, Count(*) AS total_orders,
SUM(CASE WHEN OrderStatus = "Cancelled" THEN 1 ELSE 0 END) AS total_cancels,
ROUND(SUM(CASE WHEN OrderStatus = "Cancelled" THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS cancelled_rate_percentage
From FactOrders as fo
Join DimCustomers as dm
On dm.CustomerId=fo.CustomerId
Group by dm.CustomerState
Order by cancelled_rate_percentage DESC;

-- need to find the unknown state with most returns hen only we cans ee what causing the cancellation more in that particular state--

-- return rate customer segment --
Select dm.CustomerSegment, count(*) As total_orders,
Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End) as Total_returned_orders,
Round(Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End)*100/(Count(*)),2) As return_rate_percentage
From FactOrders as fo
Join DimCustomers as dm
On dm.CustomerId=fo.CustomerId
Group by dm.CustomerSegment
Order by return_rate_percentage DESC;

-- Cancellation rate customer segment --
Select dm.CustomerSegment, count(*) As total_orders,
SUM(CASE WHEN OrderStatus = "Cancelled" THEN 1 ELSE 0 END) AS total_cancels,
ROUND(SUM(CASE WHEN OrderStatus = "Cancelled" THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS cancelled_rate_percentage
From FactOrders as fo
Join DimCustomers as dm
On dm.CustomerId=fo.CustomerId
Group by dm.CustomerSegment
Order by cancelled_rate_percentage DESC;

-- Retrun rate by Month --
Select date_format(OrderDate,'%Y-%m')As Order_month,
Count(*) AS total_orders,
Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End) as Total_returned_orders,
Round(Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End)*100/(Count(*)),2) As return_rate_percentage
From FactOrders
group by Order_month
order by return_rate_percentage desc; 

Select monthname(OrderDate)As Order_month,
Count(*) AS total_orders,
Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End) as Total_returned_orders,
Round(Sum(Case when OrderStatus IN ("Returned","Refunded") then 1 else 0 End)*100/(Count(*)),2) As return_rate_percentage
From FactOrders
group by Order_month
order by return_rate_percentage desc; 

Select monthname(OrderDate)As Order_month,
Count(*) AS total_orders,
Sum(Case when OrderStatus ="Cancelled" then 1 else 0 End) as Total_cancelled_orders,
Round(Sum(Case when OrderStatus = "Cancelled" then 1 else 0 End)*100/(Count(*)),2) As cancelled_rate_percentage
From FactOrders
group by Order_month
order by cancelled_rate_percentage desc;

-- total revenue each product --
Select dp.productCategory, Sum(fo.UnitPrice*fo.Quantity) AS total_revenue
From FactOrders fo
Join DimProducts dp ON dp.ProductID = fo.ProductID
Group by dp.ProductCategory
Order by total_revenue DESC;

-- total revenue each payemntmode--
Select PaymentMode,count(*) as total_orders, Sum(UnitPrice*Quantity) AS total_revenue
From FactOrders 
Group by PaymentMode
Order by total_revenue DESC;

-- State with max Revenue --
select dm.CustomerState, Count(*) AS total_orders, 
Sum(fo.UnitPrice*fo.Quantity) AS total_revenue
From FactOrders as fo
Join DimCustomers as dm
On dm.CustomerId=fo.CustomerId
Group by dm.CustomerState
Order by total_revenue DESC;

-- State with most payemntmode
select Count(*) AS total_orders, fo.PaymentMode, dm.CustomerState
From FactOrders as fo
Join DimCustomers as dm
On dm.CustomerId=fo.CustomerId
Group by dm.CustomerState , fo.PaymentMode
Order by total_orders Desc;

-- delivery delay ech city --

SELECT dc.CustomerCity,
COUNT(fo.DeliveryDays) AS orders_with_delivery_days,
ROUND(AVG(fo.DeliveryDays), 2) AS avg_delivery_days,
ROUND(AVG(fo.DeliveryDays) - (SELECT AVG(DeliveryDays) FROM FactOrders), 2) AS diff_vs_company_avg
FROM FactOrders fo
JOIN DimCustomers dc ON dc.CustomerID = fo.CustomerID
GROUP BY dc.CustomerCity
ORDER BY avg_delivery_days DESC;

-- Delivery delay each state--
SELECT dc.CustomerState, count(*) As total_Orders,
COUNT(fo.DeliveryDays) AS orders_with_delivery_days,
ROUND(AVG(fo.DeliveryDays), 2) AS avg_delivery_days,
ROUND(AVG(fo.DeliveryDays) - (SELECT AVG(DeliveryDays) FROM FactOrders), 2) AS diff_vs_company_avg
FROM FactOrders fo
JOIN DimCustomers dc ON dc.CustomerID = fo.CustomerID
GROUP BY dc.CustomerState
ORDER BY avg_delivery_days DESC;

-- State with most premium customers --
Select dm.CustomerState, Count(*) As total_orders
From FactOrders As fo
Join DimCustomers As dm
on dm.CustomerId=fo.CustomerId
Where CustomerSegment = "Premium"
Group by dm.CustomerState
Order by  total_orders Desc;

-- State with New customers --
Select dm.CustomerState, Count(*) As total_orders
From FactOrders As fo
Join DimCustomers As dm
on dm.CustomerId=fo.CustomerId
Where CustomerSegment = "New"
Group by dm.CustomerState
Order by  total_orders Desc;

-- checking reason for most returns in kerala --
SELECT fo.ReturnReason,
       COUNT(*) AS returned_orders
FROM FactOrders fo
JOIN DimCustomers dc ON dc.CustomerID = fo.CustomerID
WHERE dc.CustomerState = 'Kerala'
  AND fo.OrderStatus IN ('Returned', 'Refunded')
GROUP BY fo.ReturnReason
ORDER BY returned_orders DESC;

-- Top product categories returned in Kerala --
Select dp.ProductCategory, Count(fo.OrderId) as Total_orders
from DimProducts dp
Join FactOrders fo
ON dp.ProductID = fo.ProductID
JOIN DimCustomers dc ON dc.CustomerID = fo.CustomerID
Where dc.CustomerState = 'Kerala' And fo.OrderStatus IN ('Returned', 'Refunded')
Group by dp.ProductCategory
Order by Total_orders Desc;

-- Products category with return reason --
SELECT dp.ProductCategory,
COUNT(*) AS total_returns,
SUM(CASE WHEN fo.ReturnReason = 'Size Issue' THEN 1 ELSE 0 END) AS size_issue,
SUM(CASE WHEN fo.ReturnReason = 'Quality Issue' THEN 1 ELSE 0 END) AS quality_issue,
SUM(CASE WHEN fo.ReturnReason = 'Damaged Product' THEN 1 ELSE 0 END) AS damaged_product,
SUM(CASE WHEN fo.ReturnReason = 'Wrong Item' THEN 1 ELSE 0 END) AS wrong_item,
SUM(CASE WHEN fo.ReturnReason = 'Changed Mind' THEN 1 ELSE 0 END) AS changed_mind,
SUM(CASE WHEN fo.ReturnReason = 'Reason Not Recorded' THEN 1 ELSE 0 END) AS not_recorded
FROM FactOrders fo
JOIN DimProducts dp ON dp.ProductID = fo.ProductID
WHERE fo.OrderStatus IN ('Returned', 'Refunded')
GROUP BY dp.ProductCategory
ORDER BY total_returns DESC;


-- Product category with ratings --
SELECT dp.ProductCategory,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN fo.CustomerRating = '5' THEN 1 ELSE 0 END) AS Excellent_5,
	SUM(CASE WHEN fo.CustomerRating = '4' THEN 1 ELSE 0 END) AS Good_4,
    SUM(CASE WHEN fo.CustomerRating = '3' THEN 1 ELSE 0 END) AS Ok_3,
    SUM(CASE WHEN fo.CustomerRating = '2' THEN 1 ELSE 0 END) AS Not_Great_2,
    SUM(CASE WHEN fo.CustomerRating = '1' THEN 1 ELSE 0 END) AS Very_Bad_1
FROM FactOrders fo
JOIN DimProducts dp ON dp.ProductID = fo.ProductID
GROUP BY dp.ProductCategory
ORDER BY total_orders DESC;

-- Average rating by CustomerSegment --
SELECT dc.CustomerSegment,
COUNT(fo.CustomerRating) AS orders_with_CustomerRating,
ROUND(AVG(fo.CustomerRating), 2) AS avg_CustomerRating
FROM FactOrders fo
JOIN DimCustomers dc ON dc.CustomerID = fo.CustomerID
GROUP BY dc.CustomerSegment
ORDER BY orders_with_CustomerRating  DESC;

-- Average rating by payment mode --
Select PaymentMode,
Count(CustomerRating) as Orders_with_CustomerRating,
Round(Avg(CustomerRating),2) AS avg_CustomerRating
FROM FactOrders fo
Group by PaymentMode
Order by Orders_with_CustomerRating Desc;

SELECT PaymentMode,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN fo.CustomerRating = '5' THEN 1 ELSE 0 END) AS Excellent_5,
	SUM(CASE WHEN fo.CustomerRating = '4' THEN 1 ELSE 0 END) AS Good_4,
    SUM(CASE WHEN fo.CustomerRating = '3' THEN 1 ELSE 0 END) AS Ok_3,
    SUM(CASE WHEN fo.CustomerRating = '2' THEN 1 ELSE 0 END) AS Not_Great_2,
    SUM(CASE WHEN fo.CustomerRating = '1' THEN 1 ELSE 0 END) AS Very_Bad_1
    FROM FactOrders fo
    Group by PaymentMode
Order by total_orders Desc;

Select count(*) AS total_orders
From FactOrders
Where OrderStatus IN ("Returned","Refunded");

Select count(OrderID) AS total_orders
From FactOrders
Where OrderStatus = "Returned";

Select count(OrderID) AS total_orders
From FactOrders
Where OrderStatus = "Refunded";

Select count(OrderID) AS total_orders
From FactOrders
Where OrderStatus = "Delivered";

Select count(OrderID) AS total_orders
From FactOrders
Where OrderStatus = "Shipped";

Select count(OrderID) AS total_orders
From FactOrders
Where OrderStatus = "Processing";
Select count(OrderID) AS total_orders
From FactOrders
Where OrderStatus = "Cancelled";

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN total_orders >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
    SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) AS one_time_customers,
    ROUND(
        SUM(CASE WHEN total_orders >= 2 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS repeat_customer_rate
FROM (
    SELECT
        CustomerID,
        COUNT(*) AS total_orders
    FROM FactOrders
    GROUP BY CustomerID
) AS customer_orders;