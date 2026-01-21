SELECT
    a.name AS appointment_id,
    a.status,
    a.custom_company AS company,
    e.department AS department,
    e.branch AS branch,
    a.owner AS sales_person,
    a.creation AS creation_date,
    a.scheduled_time AS scheduled_time
FROM
    tabAppointment a
LEFT JOIN
    tabEmployee e ON e.user_id = a.owner
WHERE
    a.status IN ('Closed', 'Completed')
ORDER BY
    a.creation DESC;
