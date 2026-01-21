SELECT
    SUM(o.opportunity_amount) AS total_pipeline_value,
    o.owner AS created_by,
    e.department AS department,
    e.branch AS branch,
    o.company,
    o.creation AS posting_date
FROM `tabOpportunity` o
LEFT JOIN `tabEmployee` e 
    ON e.user_id = o.owner
WHERE
    o.docstatus < 2
GROUP BY
    o.owner, e.department, e.branch, o.company, o.creation
ORDER BY
    total_pipeline_value DESC;
