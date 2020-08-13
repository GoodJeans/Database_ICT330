SELECT	* 
FROM SKU_DATA

SELECT	Department, Buyer
FROM	SKU_DATA;

SELECT	DISTINCT Buyer, Department
FROM	SKU_DATA;

SELECT	*
FROM	SKU_DATA
WHERE Department = 'Water Sports';

SELECT SKU_Description, Buyer
FROM	SKU_DATA
WHERE Department = 'Climbing';

SELECT	*
FROM	 ORDER_ITEM
ORDER BY	OrderNumber, Price; 

SELECT	*
FROM	ORDER_ITEM
ORDER BY	Price DESC, OrderNumber ASC;

SELECT	*
FROM		SKU_DATA
WHERE Department =  'Water Sports'
	  AND Buyer = 'Nancy Meyers';

SELECT	*
FROM		SKU_DATA
WHERE	Department = 'Camping'
        OR	Department = 'Climbing';

SELECT	*
FROM	SKU_DATA
WHERE	 Buyer IN ('Nancy Meyers','Cindy Lo', 'Jerry Martin');

SELECT	*
FROM	 SKU_DATA
WHERE Buyer NOT IN ('Nancy Meyers', 'Cindy Lo', 'Jerry Martin');

SELECT	*
FROM	 ORDER_ITEM
WHERE ExtendedPrice BETWEEN 100 AND 200;
	
SELECT	*
FROM	 ORDER_ITEM
WHERE ExtendedPrice >= 100 AND ExtendedPrice <= 200;

SELECT	*
FROM	SKU_DATA
WHERE	Buyer LIKE 'Pete%';

SELECT	*
FROM	 SKU_DATA
WHERE SKU_Description LIKE '%Tent%';

SELECT	*
FROM SKU_DATA
WHERE SKU LIKE '%2__';

SELECT	 count(*) as 'Item Count', SUM(ExtendedPrice) AS Order3000Sum
FROM	 ORDER_ITEM
WHERE OrderNumber  = 3000;

SELECT	
SUM (ExtendedPrice) AS OrderItemSum,
AVG (ExtendedPrice) AS OrderItemAvg,
MIN (ExtendedPrice) AS OrderItemMin,
MAX (ExtendedPrice) AS OrderItemMax
FROM	ORDER_ITEM;

SELECT	COUNT(*) AS NumberOfRows
FROM	ORDER_ITEM;

SELECT COUNT(DISTINCT Department)
AS DeptCount
FROM	SKU_DATA;

SELECT	Department, Buyer,COUNT(*) AS Dept_Buyer_SKU_Count
FROM	SKU_DATA
GROUP BY Department, Buyer;

select * from sku_data WHERE SKU <> 302000

SELECT COUNT(*) AS Dept_SKU_Count
FROM	SKU_DATA
WHERE	 SKU <> 302000
GROUP BY  	Department
ORDER BY Dept_SKU_Count;

SELECT Department, buyer, COUNT(*) AS Dept_SKU_Count
FROM	SKU_DATA
WHERE	 SKU <> 302000
GROUP BY  	buyer, Department
ORDER BY Dept_SKU_Count;

SELECT Department,  COUNT(distinct buyer) AS Dept_SKU_Count
FROM	SKU_DATA
WHERE	 SKU <> 302000
GROUP BY  	Department
ORDER BY Dept_SKU_Count;

SELECT	Department, COUNT(*) AS Dept_SKU_Count
FROM		SKU_DATA
WHERE	SKU <> 302000
GROUP BY 	Department
--HAVING 	COUNT (*) > 1
ORDER BY	Dept_SKU_Count;



-- Arithmetic in SELECT Statement 
SELECT 
Quantity * Price AS EP, ExtendedPrice
FROM	 ORDER_ITEM;

SELECT	DISTINCT RTRIM (Buyer)+ ' in ' + RTRIM (Department) AS Sponsor
FROM	SKU_DATA;

select * from sku_data 
where sku in (
select distinct sku from order_item)


select * from sku_data
select * from retail_order
select * from order_item

--show the sku description for those sku ordered in december

SELECT SKU 
FROM ORDER_ITEM WHERE PRICE >
(select AVG(price)
from order_item)


select sku_description 
from sku_data 
where sku in
	(select distinct sku 
	from order_item where
	ordernumber  in 
		(select ro.ordernumber 
		from retail_order ro join order_item oi 
		   on ro.ordernumber = oi.orderNumber
		where orderMonth = 'December'
		group by ro.ordernumber 
		having count(*) > 2
		))

-- NO PLAN SOLUTION 
select RO.orderNumber, orderMonth --, count(*) as 'number of items ordered'
from order_item OI JOIN RETAIL_ORDER RO ON OI.ORDERNUMBER = RO.ORDERNUMBER
group by RO.orderNumber, ORDERMONTH
having count(*) >= 3
-- PLAN - USE SUBQUERY

SELECT ORDERNUMBER, ORDERMONTH
FROM RETAIL_ORDER
WHERE ORDERNUMBER IN 
(SELECT ORDERNUMBER
FROM ORDER_ITEM
GROUP BY ORDERNUMBER
HAVING COUNT(*) >= 3)

select sku_data.sku, sku_description, count(*) as 'times ordered', 
sum(quantity) as 'Total Qty Ordered'
from order_item join sku_data on order_item.sku = sku_data.sku
group by sku_data.sku, sku_description


SELECT	
SUM (ExtendedPrice) 
   As Revenue
FROM	ORDER_ITEM
WHERE	 SKU IN
	( 100100, 100200, 
    101100, 101200
   );


SELECT	SUM (ExtendedPrice) 
          As Revenue
FROM	ORDER_ITEM
WHERE	SKU IN
	( SELECT SKU 
     FROM SKU_DATA
	  WHERE Department = 
            'Water Sports‘
   );

SELECT Buyer
FROM	SKU_DATA
WHERE	SKU IN
 (SELECT SKU 
  FROM ORDER_ITEM
	WHERE OrderNumber IN
   (SELECT OrderNumber
	  FROM RETAIL_ORDER
	  WHERE OrderMonth = 'January'
	  AND	OrderYear = 2009
   )
 );


SELECT Buyer, ExtendedPrice
FROM	SKU_DATA s JOIN ORDER_ITEM o
ON	 s.SKU = o.SKU;


SELECT Buyer, SUM(ExtendedPrice)
	AS BuyerRevenue
FROM	SKU_DATA s 
JOIN ORDER_ITEM o
ON	 s.SKU = o.SKU
GROUP BY Buyer
ORDER BY BuyerRevenue DESC;

SELECT Buyer, ExtendedPrice, OrderMonth
FROM	SKU_DATA s JOIN ORDER_ITEM o	 
ON s.SKU = o.SKU
JOIN RETAIL_ORDER r
ON o.OrderNumber =
	r.OrderNumber;


-- VRG ----
SELECT C.LastName, C.FirstName,
	A.LastName AS ArtistName
FROM CUSTOMER AS C LEFT OUTER
	JOIN CUSTOMER_ARTIST_INT AS CI
	  ON C.CustomerID = CI.CustomerID
	LEFT OUTER JOIN ARTIST AS A
		 ON CI.ArtistID = A.ArtistID;

SELECT C.LastName, C.FirstName,
	T.TransactionID, T.SalesPrice
FROM CUSTOMER AS C RIGHT JOIN 
TRANS AS T    ON C.CustomerID = T.CustomerID
ORDER BY T.TransactionID;
