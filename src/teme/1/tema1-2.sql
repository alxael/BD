SELECT
    DEPARTMENT_ID,
    DEPARTMENT_NAME,
    NVL(
        TO_CHAR(MANAGER_ID),
        'Departamentul ' || TO_CHAR(DEPARTMENT_ID) || ' nu are manager.'
    ) AS DEPARTMENT_MANAGER,
    NVL(
        (
            SELECT
                WM_CONCAT(EMPLOYEE_ID)
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
        ),
        'Departamentul nu are angajati.'
    ) AS DEPARTMENT_EMPLOYEES
FROM
    DEPARTMENTS;