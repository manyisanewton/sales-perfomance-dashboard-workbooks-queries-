SELECT
    COUNT(DISTINCT o.name) AS total_opportunities,
    o.sales_stage AS sales_stage,  -- Using the correct sales_stage field
    o.owner AS created_by,
    e.department AS department,
    e.branch AS branch,
    o.company,
    o.creation AS posting_date
FROM `tabOpportunity` o
LEFT JOIN `tabEmployee` e ON e.user_id = o.owner
WHERE
    o.docstatus < 2
    AND o.sales_stage IS NOT NULL
GROUP BY
    o.sales_stage, o.owner, e.department, e.branch, o.company, o.creation
ORDER BY
    total_opportunities DESC;
