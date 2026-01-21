SELECT
    c.customer_name AS customer,
    sp.sales_person_name AS sales_person,
    e.department AS department,
    e.branch AS branch,
    si.company AS company,
    ptd.credit_days AS credit_term,
    SUM(CASE WHEN DATEDIFF(CURDATE(), si.posting_date) <= 30 THEN si.outstanding_amount ELSE 0 END) AS days_0_30,
    SUM(CASE WHEN DATEDIFF(CURDATE(), si.posting_date) BETWEEN 31 AND 60 THEN si.outstanding_amount ELSE 0 END) AS days_31_60,
    SUM(CASE WHEN DATEDIFF(CURDATE(), si.posting_date) BETWEEN 61 AND 90 THEN si.outstanding_amount ELSE 0 END) AS days_61_90,
    SUM(CASE WHEN DATEDIFF(CURDATE(), si.posting_date) > 90 THEN si.outstanding_amount ELSE 0 END) AS days_over_90,
    SUM(si.outstanding_amount) AS total_outstanding
FROM
    `tabSales Invoice` si
LEFT JOIN `tabCustomer` c ON si.customer = c.name
LEFT JOIN `tabPayment Terms Template` ptt ON ptt.name = c.payment_terms
LEFT JOIN `tabPayment Terms Template Detail` ptd ON ptd.parent = ptt.name
LEFT JOIN `tabSales Team` st ON st.parent = si.name
LEFT JOIN `tabSales Person` sp ON sp.name = st.sales_person
LEFT JOIN `tabEmployee` e ON e.name = sp.employee
WHERE
    si.docstatus = 1
    AND si.outstanding_amount > 0
GROUP BY
    c.customer_name, sp.sales_person_name, e.department, e.branch, si.company, ptd.credit_days
ORDER BY
    total_outstanding DESC;
