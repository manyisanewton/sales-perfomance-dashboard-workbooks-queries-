SELECT
    COUNT(DISTINCT si.customer) AS active_customers,
    si.owner AS created_by,
    e.department AS department,
    e.branch AS branch,
    si.company,
    si.posting_date AS posting_date
FROM `tabSales Invoice` si
LEFT JOIN `tabEmployee` e 
    ON e.user_id = si.owner
WHERE
    si.docstatus = 1
GROUP BY
    si.owner, e.department, e.branch, si.company, si.posting_date
ORDER BY
    active_customers DESC;
