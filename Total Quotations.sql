SELECT
    COUNT(DISTINCT q.name) AS total_quotations,
    q.owner AS created_by,
    e.department AS department,
    e.branch AS branch,
    q.company,
    q.transaction_date AS posting_date
FROM `tabQuotation` q
LEFT JOIN `tabEmployee` e 
    ON e.user_id = q.owner
WHERE
    q.docstatus = 1
GROUP BY
    q.owner, e.department, e.branch, q.company, q.transaction_date
ORDER BY
    total_quotations DESC;
