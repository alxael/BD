SELECT
    DEPARTMENTS.DEPARTMENT_ID,
    DEPARTMENTS.DEPARTMENT_NAME
FROM
    EMPLOYEES
    INNER JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
GROUP BY
    DEPARTMENTS.DEPARTMENT_ID,
    DEPARTMENTS.DEPARTMENT_NAME
HAVING
    COUNT(DISTINCT EMPLOYEES.JOB_ID) >= 2
ORDER BY
    DEPARTMENT_ID;