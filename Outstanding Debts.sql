SELECT
    sp.name AS sales_person_id,
    sp.sales_person_name AS salesperson_name,
    sp.department AS department,
    emp.branch AS branch,
    si.company AS company,
    si.posting_date AS posting_date,
    SUM(si.grand_total) AS total_invoiced,
    SUM(si.outstanding_amount) AS total_outstanding,
    SUM(si.grand_total - si.outstanding_amount) AS total_collected,
    ROUND(
        CASE 
            WHEN SUM(si.grand_total) > 0 THEN 
                (SUM(si.grand_total - si.outstanding_amount) / SUM(si.grand_total)) * 100
            ELSE 0
        END, 2
    ) AS percent_collected
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
WHERE
    si.docstatus = 1
GROUP BY
    sp.name, sp.sales_person_name, sp.department, emp.branch, si.company, si.posting_date
ORDER BY
    si.posting_date DESC;
