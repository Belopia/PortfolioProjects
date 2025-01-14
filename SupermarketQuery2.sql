-- Overview of the data -------------------------------------------------------------------------------------------

SELECT *
FROM [Portfolio 2]..[shopping_trends$];

-- Checking for Nulls --------------------------------------------------------------------------------------------- 
SELECT *
FROM [Portfolio 2]..[shopping_trends$]
WHERE NULL IN ([Customer ID], 
	Age, 
	Gender, 
	[Item Purchased], 
	Category, 
	[Purchase Amount (USD)], 
	Location, 
	Size, 
	Color, 
	Season, 
	[Review Rating], 
	[Subscription Status], 
	[Payment Method], 
	[Shipping Type], 
	[Discount Applied], 
	[Promo Code Used], 
	[Previous Purchases], 
	[Preferred Payment Method], 
	[Frequency of Purchases]);

-- No nulls so we can be sure that all data is filled in 

-- Ranking of Item Ranking (Per Seasons)
SELECT *
FROM [Portfolio 2]..[shopping_trends$];

SELECT Season,
	Category,
	[Item Purchased],
	COUNT(*) AS amount,
	DENSE_RANK() OVER(PARTITION BY Season ORDER BY COUNT(*) DESC) AS Ranks
FROM [Portfolio 2]..[shopping_trends$]
GROUP BY Season, Category,[Item Purchased]
ORDER BY Season;

-- Buying patterns of Category %
SELECT *
FROM [Portfolio 2]..[shopping_trends$];

SELECT Season, 
	Category,
	COUNT(*) AS Amount,
	SUM(COUNT(*)) OVER (PARTITION BY Season),
	CAST(COUNT(*) AS Float)/ (SUM(COUNT(*)) OVER (PARTITION BY Season)) * 100 AS Percentage
FROM [Portfolio 2]..[shopping_trends$]
GROUP BY Season, Category;


-- Buying patterns of Item Purchased %
SELECT *
FROM [Portfolio 2]..[shopping_trends$];

SELECT Season, 
	Category,
	[Item Purchased],
	COUNT(*) AS Amount,
	SUM(COUNT(*)) OVER (PARTITION BY Season, Category) AS Category_Total,
	CAST(COUNT(*) AS Float)/ (SUM(COUNT(*)) OVER (PARTITION BY Season, Category)) * 100 AS Percentage
FROM [Portfolio 2]..[shopping_trends$]
GROUP BY Season, Category, [Item Purchased];

-- Buying patterns of Gender %
  -- Category
SELECT Season,
	Gender,
	Category,
	COUNT(*) AS Amount,
	SUM(COUNT(*)) OVER (PARTITION BY Season, Gender) AS Season_Total_Per_Gender,
	CAST(COUNT(*) AS Float)/ (SUM(COUNT(*)) OVER (PARTITION BY Season, Gender)) * 100 AS Percentage
FROM [Portfolio 2]..[shopping_trends$]
GROUP BY Season, Gender, Category
ORDER BY Season, Gender, Category;

  -- Item Purchased
SELECT Season, 
	Gender,
	Category,
	[Item Purchased],
	COUNT(*) AS Amount,
	SUM(COUNT(*)) OVER (PARTITION BY Season, Gender, Category) AS Category_Total_Per_Gender,
	CAST(COUNT(*) AS Float)/ (SUM(COUNT(*)) OVER (PARTITION BY Season, Gender, Category)) * 100 AS Percentage
FROM [Portfolio 2]..[shopping_trends$]
GROUP BY Season, Gender, Category, [Item Purchased]
ORDER BY Season, Gender, Category, [Item Purchased];

-- Buying patterns of Discount %
SELECT Season, 
	[Discount Applied],
	COUNT(*) Amount,
	SUM(COUNT(*)) OVER (PARTITION BY Season) Total_Customers,
	CAST(COUNT(*) AS Float)/ (SUM(COUNT(*)) OVER (PARTITION BY Season)) * 100 AS Percentage
FROM [Portfolio 2]..[shopping_trends$]
GROUP BY Season, [Discount Applied]
ORDER BY Season, [Discount Applied]
;

-- Buying patterns of Promo Code %
SELECT Season, 
	[Promo Code Used],
	COUNT(*) Amount,
	SUM(COUNT(*)) OVER (PARTITION BY Season) Total_Customers,
	CAST(COUNT(*) AS Float)/ (SUM(COUNT(*)) OVER (PARTITION BY Season)) * 100 AS Percentage
FROM [Portfolio 2]..[shopping_trends$]
GROUP BY Season, [Promo Code Used]
ORDER BY Season, [Promo Code Used]
;
