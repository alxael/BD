SELECT
    (LAST_NAME || ' ' || FIRST_NAME) AS NAME,
    SALARY,
    JOBS.JOB_TITLE,
    DEPARTMENTS.DEPARTMENT_ID,
    DEPARTMENTS.DEPARTMENT_NAME,
    LOCATIONS.LOCATION_ID,
    LOCATIONS.CITY,
    COUNTRIES.COUNTRY_NAME,
    (
        SELECT
            (LAST_NAME || ' ' || FIRST_NAME)
        FROM
            EMPLOYEES
        WHERE
            (LOWER(LAST_NAME) || LOWER(FIRST_NAME)) = 'hunoldalexander'
    ) AS MANAGER_FULL_NAME
FROM
    EMPLOYEES
    INNER JOIN DEPARTMENTS ON (
        EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
        AND EMPLOYEES.MANAGER_ID =(
            SELECT
                EMPLOYEE_ID
            FROM
                EMPLOYEES
            WHERE
                (LOWER(LAST_NAME) || LOWER(FIRST_NAME)) = 'hunoldalexander'
        )
        AND (
            EMPLOYEES.HIRE_DATE BETWEEN TO_DATE('01-07-1991', 'dd-mm-yyyy')
            AND TO_DATE('28-02-1999', 'dd-mm-yyyy')
        )
    )
    INNER JOIN LOCATIONS ON (LOCATIONS.LOCATION_ID = DEPARTMENTS.LOCATION_ID)
    INNER JOIN JOBS ON (JOBS.JOB_ID = EMPLOYEES.JOB_ID)
    INNER JOIN COUNTRIES ON (COUNTRIES.COUNTRY_ID = LOCATIONS.COUNTRY_ID);