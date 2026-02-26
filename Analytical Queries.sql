--- Revenue & Profit Overview---

SELECT
    SUM(TotalRevenue) AS TotalRevenue,
    SUM(Profit) AS TotalProfit,
    SUM(Profit) * 100.0 / SUM(TotalRevenue) AS ProfitMarginPercent
FROM FactSales;

------------------------------------------------------------------------------------
---Monthly Revenue Trend---

SELECT
    d.Year,
    d.Month,
    d.MonthName,
    SUM(f.TotalRevenue) AS MonthlyRevenue
FROM FactSales f
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY d.Year, d.Month, d.MonthName
ORDER BY d.Year, d.Month;

------------------------------------------------------------------------------------
---Month-over-Month Growth %---

WITH MonthlyRevenue AS (
    SELECT
        d.Year,
        d.Month,
        SUM(f.TotalRevenue) AS Revenue
    FROM FactSales f
    JOIN DimDate d ON f.DateKey = d.DateKey
    GROUP BY d.Year, d.Month
)
SELECT *,
    LAG(Revenue) OVER (ORDER BY Year, Month) AS PrevMonthRevenue,
    (Revenue - LAG(Revenue) OVER (ORDER BY Year, Month))
        * 100.0 /
        LAG(Revenue) OVER (ORDER BY Year, Month)
        AS GrowthPercent
FROM MonthlyRevenue;

------------------------------------------------------------------------------------
---Top 5 Products by Revenue---

SELECT *
FROM (
    SELECT
        p.ProductName,
        SUM(f.TotalRevenue) AS Revenue,
        RANK() OVER (ORDER BY SUM(f.TotalRevenue) DESC) AS RankPosition
    FROM FactSales f
    JOIN DimProduct p ON f.ProductID = p.ProductID
    GROUP BY p.ProductName
) RankedProducts
WHERE RankPosition <= 5;

------------------------------------------------------------------------------------
---Region-wise Performance---

SELECT
    r.RegionName,
    SUM(f.TotalRevenue) AS Revenue,
    SUM(f.Profit) AS Profit,
    SUM(f.Profit) * 100.0 / SUM(f.TotalRevenue) AS ProfitMarginPercent
FROM FactSales f
JOIN DimRegion r ON f.RegionID = r.RegionID
GROUP BY r.RegionName
ORDER BY Revenue DESC;

------------------------------------------------------------------------------------
---Customer Segment Revenue Contribution %---

WITH SegmentRevenue AS (
    SELECT
        c.Segment,
        SUM(f.TotalRevenue) AS Revenue
    FROM FactSales f
    JOIN DimCustomer c ON f.CustomerID = c.CustomerID
    GROUP BY c.Segment
)
SELECT
    Segment,
    Revenue,
    Revenue * 100.0 / SUM(Revenue) OVER() AS ContributionPercent
FROM SegmentRevenue;

------------------------------------------------------------------------------------
---Running Total Revenue (Cumulative)---

SELECT
    d.Year,
    d.Month,
    SUM(f.TotalRevenue) AS MonthlyRevenue,
    SUM(SUM(f.TotalRevenue)) OVER (ORDER BY d.Year, d.Month)
        AS RunningTotalRevenue
FROM FactSales f
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;

------------------------------------------------------------------------------------
