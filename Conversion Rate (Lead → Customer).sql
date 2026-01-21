SELECT
    e.department AS department,
    e.branch AS branch,
    l.company,
    l.owner AS created_by,
    COUNT(DISTINCT l.name) AS total_leads,
    COUNT(DISTINCT c.name) AS total_customers,
    ROUND(
        (COUNT(DISTINCT c.name) / COUNT(DISTINCT l.name)) * 100, 2
    ) AS conversion_rate,
    l.creation AS posting_date
FROM `tabLead` l
LEFT JOIN `tabCustomer` c 
    ON c.lead_name = l.name
LEFT JOIN `tabEmployee` e 
    ON e.user_id = l.owner
WHERE
    l.docstatus < 2
GROUP BY
    l.owner, e.department, e.branch, l.company, l.creation
ORDER BY
    conversion_rate DESC;
