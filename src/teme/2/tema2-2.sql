SELECT
    JOB_ID,
    CASE
        WHEN SUBSTR(JOB_TITLE, 1, 1) = 'S' THEN SALARY_SUM
        WHEN JOB_ID IN (
            SELECT
                EMPLOYEES.JOB_ID
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEES.SALARY = (
                    SELECT
                        MAX(EMPLOYEES.SALARY)
                    FROM
                        EMPLOYEES
                )
        ) THEN SALARY_AVG
        ELSE SALARY_MIN
    END AS DATA,
    CASE
        WHEN SUBSTR(JOB_TITLE, 1, 1) = 'S' THEN 'SUM'
        WHEN JOB_ID IN (
            SELECT
                EMPLOYEES.JOB_ID
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEES.SALARY = (
                    SELECT
                        MAX(EMPLOYEES.SALARY)
                    FROM
                        EMPLOYEES
                )
        ) THEN 'AVG'
        ELSE 'MIN'
    END AS TYPE
FROM
    (
        SELECT
            JOBS.JOB_ID,
            JOBS.JOB_TITLE,
            SUM(EMPLOYEES.SALARY) AS SALARY_SUM,
            AVG(EMPLOYEES.SALARY) AS SALARY_AVG,
            MIN(EMPLOYEES.SALARY) AS SALARY_MIN
        FROM
            JOBS
            INNER JOIN EMPLOYEES ON EMPLOYEES.JOB_ID = JOBS.JOB_ID
        GROUP BY
            JOBS.JOB_ID,
            JOBS.JOB_TITLE
    )