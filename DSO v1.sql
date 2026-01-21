WITH base_invoices AS (
  -- Get all CREDIT SALES ONLY (not returns, not cash sales)
  -- Credit sales = invoices with payment terms (outstanding_amount > 0 or status != 'Paid')
  SELECT si.name, si.company, si.cost_center, si.posting_date, si.base_grand_total, 
         si.outstanding_amount, si.status
  FROM `tabSales Invoice` si
  WHERE si.docstatus = 1
    AND si.is_return = 0
    AND si.outstanding_amount > 0  -- Only credit sales (still has outstanding balance)
    AND (@company IS NULL OR si.company = @company)
    AND (@cost_center IS NULL OR si.cost_center = @cost_center)
    AND (@year IS NULL OR YEAR(si.posting_date) = @year)
),
with_sales_person AS (
  -- Join with sales team to filter by sales_person if needed
  SELECT bi.*, st.sales_person
  FROM base_invoices bi
  LEFT JOIN `tabSales Team` st ON st.parent = bi.name
),
filtered_invoices AS (
  -- Apply sales_person filter
  SELECT * FROM with_sales_person
  WHERE (@sales_person IS NULL OR sales_person = @sales_person)
),
opening_ar AS (
  -- Opening AR: outstanding balance for invoices created before year start
  SELECT COALESCE(SUM(outstanding_amount), 0) AS opening_balance
  FROM filtered_invoices
  WHERE YEAR(posting_date) < COALESCE(@year, YEAR(NOW()))
),
closing_ar AS (
  -- Closing AR: current outstanding balance for all credit sales invoices
  SELECT COALESCE(SUM(outstanding_amount), 0) AS closing_balance
  FROM filtered_invoices
),
average_ar AS (
  -- Average AR = (Opening + Closing) / 2
  SELECT (oa.opening_balance + ca.closing_balance) / 2 AS avg_receivable
  FROM opening_ar oa, closing_ar ca
),
credit_revenue AS (
  -- Total CREDIT SALES revenue only
  SELECT COALESCE(SUM(base_grand_total), 0) AS total_credit_sales
  FROM filtered_invoices
)

SELECT
  oa.opening_balance,
  ca.closing_balance,
  aa.avg_receivable AS average_accounts_receivable,
  cr.total_credit_sales,
  365 AS number_of_days_in_period,
  CASE
    WHEN cr.total_credit_sales = 0 THEN NULL
    ELSE ROUND((aa.avg_receivable / cr.total_credit_sales) * 365, 2)
  END AS dso
FROM opening_ar oa, closing_ar ca, average_ar aa, credit_revenue cr;
