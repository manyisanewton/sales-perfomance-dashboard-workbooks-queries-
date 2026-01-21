SELECT
    COUNT(DISTINCT so.name) AS total_sales_orders,
    so.owner AS created_by,
    e.department AS department,
    e.branch AS branch,
    so.company,
    so.transaction_date AS posting_date
FROM `tabSales Order` so
LEFT JOIN `tabEmployee` e 
    ON e.user_id = so.owner
WHERE
    so.docstatus = 1
GROUP BY
    so.owner, e.department, e.branch, so.company, so.transaction_date
ORDER BY
    total_sales_orders DESC;
