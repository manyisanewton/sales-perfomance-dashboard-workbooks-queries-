SELECT
    si.name AS sales_invoice,
    si.posting_date,
    si.customer,
    si.status,
    si.company,
    si.grand_total AS invoice_amount,
    st.sales_person AS salesperson_id,
    sp.sales_person_name AS salesperson_name,
    sp.employee AS employee,
    sp.department AS department,
    td.item_group AS target_item_group,
    td.fiscal_year AS target_year,
    td.target_qty AS target_qty,
    td.target_amount AS target_amount,
    td.distribution_id AS target_distribution
FROM
    `tabSales Invoice` AS si
INNER JOIN
    `tabSales Team` AS st
        ON st.parent = si.name
INNER JOIN
    `tabSales Person` AS sp
        ON sp.name = st.sales_person
LEFT JOIN
    `tabTarget Detail` AS td
        ON td.parent = sp.name
WHERE
    si.docstatus = 1
ORDER BY
    si.posting_date DESC;
