SELECT
  LOWER(COALESCE(l.status, 'unspecified')) AS status,
  COUNT(*) AS qty
FROM `tabLead` l
WHERE l.docstatus < 2
GROUP BY LOWER(COALESCE(l.status, 'unspecified'))
ORDER BY qty DESC;
