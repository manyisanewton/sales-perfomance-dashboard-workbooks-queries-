SELECT
    sp.name AS sales_person_id,
    sp.sales_person_name AS salesperson_name,
    sp.department AS department,
    emp.branch AS branch,
    si.company AS company,
    si.posting_date AS posting_date,
    COUNT(DISTINCT si.name) AS total_invoices,
    SUM(si.grand_total) AS total_revenue,
    SUM(td.target_amount) AS total_target,
    CASE
        WHEN SUM(td.target_amount) > 0 THEN
            ROUND((SUM(si.grand_total) / SUM(td.target_amount)) * 100, 2)
        ELSE 0
    END AS percent_of_target_achieved
FROM
    `tabSales Invoice` AS si
INNER JOIN
    `tabSales Team` AS st
        ON st.parent = si.name
INNER JOIN
    `tabSales Person` AS sp
        ON sp.name = st.sales_person
LEFT JOIN
    `tabEmployee` AS emp
        ON emp.name = sp.employee
LEFT JOIN
    `tabTarget Detail` AS td
        ON td.parent = sp.name
WHERE
    si.docstatus = 1
GROUP BY
    sp.name, sp.sales_person_name, sp.department, emp.branch, si.company, si.posting_date
ORDER BY
    si.posting_date DESC;