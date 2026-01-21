SELECT
    si.sales_person AS sales_person,
    SUM(si.grand_total) AS total_revenue
FROM
(
    SELECT
        si.name,
        si.grand_total,
        (SELECT sp.sales_person
         FROM `tabSales Team` sp
         WHERE sp.parent = si.name
         LIMIT 1) AS sales_person
    FROM
        `tabSales Invoice` si
    WHERE
        si.docstatus = 1
) si
GROUP BY
    si.sales_person
ORDER BY
    total_revenue DESC
LIMIT 10;
