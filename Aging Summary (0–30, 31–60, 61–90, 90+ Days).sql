SELECT
    c.customer_name AS customer,
    sp.sales_person_name AS sales_person,
    e.department AS department,
    e.branch AS branch,
    si.company AS company,
    SUM(CASE WHEN DATEDIFF(CURDATE(), si.posting_date) <= 30 THEN si.outstanding_amount ELSE 0 END) AS `0_30_Days`,
    SUM(CASE WHEN DATEDIFF(CURDATE(), si.posting_date) BETWEEN 31 AND 60 THEN si.outstanding_amount ELSE 0 END) AS `31_60_Days`,
    SUM(CASE WHEN DATEDIFF(CURDATE(), si.posting_date) BETWEEN 61 AND 90 THEN si.outstanding_amount ELSE 0 END) AS `61_90_Days`,
    SUM(CASE WHEN DATEDIFF(CURDATE(), si.posting_date) > 90 THEN si.outstanding_amount ELSE 0 END) AS `90_plus_Days`,
    SUM(si.outstanding_amount) AS total_outstanding
FROM
    `tabSales Invoice` si
LEFT JOIN
    `tabCustomer` c ON si.customer = c.name
LEFT JOIN
    `tabSales Team` st ON st.parent = si.name
LEFT JOIN
    `tabSales Person` sp ON sp.name = st.sales_person
LEFT JOIN
    `tabEmployee` e ON e.name = sp.employee
WHERE
    si.docstatus = 1
    AND si.outstanding_amount > 0
GROUP BY
    c.customer_name, sp.sales_person_name, e.department, e.branch, si.company
ORDER BY
    total_outstanding DESC;
