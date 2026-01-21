SELECT
    c.customer_name AS customer,
    sp.sales_person_name AS sales_person,
    e.department AS department,
    e.branch AS branch,
    si.company AS company,
    ROUND(AVG(DATEDIFF(pe.posting_date, si.posting_date)), 1) AS avg_days_to_collect,
    SUM(si.grand_total) AS total_invoiced,
    SUM(IFNULL(pe_ref.allocated_amount, 0)) AS total_collected,
    (SUM(si.grand_total) - SUM(IFNULL(pe_ref.allocated_amount, 0))) AS total_pending
FROM
    `tabSales Invoice` si
LEFT JOIN
    `tabPayment Entry Reference` pe_ref ON pe_ref.reference_name = si.name
LEFT JOIN
    `tabPayment Entry` pe ON pe.name = pe_ref.parent AND pe.docstatus = 1
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
    AND si.grand_total > 0
GROUP BY
    c.customer_name, sp.sales_person_name, e.department, e.branch, si.company
HAVING
    avg_days_to_collect IS NOT NULL
ORDER BY
    avg_days_to_collect DESC;
