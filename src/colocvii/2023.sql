-- 1.
SELECT
    SOC_ASIGURARE.NUME_SOCIETATE,
    SOC_ASIGURARE.COD_ASIGURATOR,
    TIMBRU.COD_TIMBRU,
    TIMBRU.NUME,
    TIMBRU.DATA_EMITERE,
    TIMBRU.VALOARE
FROM
    ESTE_ASIGURAT
    INNER JOIN SOC_ASIGURARE ON ESTE_ASIGURAT.COD_ASIGURATOR = SOC_ASIGURARE.COD_ASIGURATOR
    INNER JOIN TIMBRU ON ESTE_ASIGURAT.COD_TIMBRU = TIMBRU.COD_TIMBRU
WHERE
    EXTRACT(
        YEAR
        FROM
            TIMBRU.DATA_EMITERE
    ) = 1990
ORDER BY
    TIMBRU.VALOARE;

-- 2.
WITH TOTAL_SUM_ENSURED AS (
    SELECT
        SUM(ESTE_ASIGURAT.VALOARE)
    FROM
        ESTE_ASIGURAT
        INNER JOIN SOC_ASIGURARE ON SOC_ASIGURARE.COD_ASIGURATOR = ESTE_ASIGURAT.COD_ASIGURATOR
    GROUP BY
        SOC_ASIGURARE.TARA,
        ESTE_ASIGURAT.COD_ASIGURATOR
)
SELECT
    ESTE_ASIGURAT.COD_ASIGURATOR,
    SOC_ASIGURARE.NUME_SOCIETATE,
    SOC_ASIGURARE.TARA,
    TIMBRU.COD_TIMBRU
FROM
    ESTE_ASIGURAT
    INNER JOIN SOC_ASIGURARE ON ESTE_ASIGURAT.COD_ASIGURATOR = SOC_ASIGURARE.COD_ASIGURATOR
    INNER JOIN TIMBRU ON TIMBRU.COD_TIMBRU = ESTE_ASIGURAT.COD_TIMBRU
GROUP BY
    ESTE_ASIGURAT.COD_ASIGURATOR,
    SOC_ASIGURARE.NUME_SOCIETATE,
    SOC_ASIGURARE.TARA,
    TIMBRU.COD_TIMBRU;

-- 3.
WITH RESULTS AS (
    SELECT
        VANZATOR.COD_VANZATOR,
        VANZATOR.NUME,
        COUNT(VINDE.COD_TIMBRU) AS TIMBRU_COUNT
    FROM
        VANZATOR
        INNER JOIN VINDE ON VINDE.COD_VANZATOR = VANZATOR.COD_VANZATOR
    GROUP BY
        VANZATOR.COD_VANZATOR,
        VANZATOR.NUME
    ORDER BY
        TIMBRU_COUNT DESC
)
SELECT
    *
FROM
    RESULTS
WHERE
    ROWNUM <= 2;

-- 4.
WITH AVERAGES AS (
    SELECT
        VANZATOR.COD_VANZATOR,
        AVG(VINDE.VAL_CUMPARARE) AS AVERAGE
    FROM
        VANZATOR
        INNER JOIN VINDE ON VINDE.COD_VANZATOR = VANZATOR.COD_VANZATOR
    GROUP BY
        VANZATOR.COD_VANZATOR
),
TOTAL_AVERAGE AS (
    SELECT
        AVG(AVERAGE) AS AVERAGE
    FROM
        AVERAGES
);

-- 5.
WITH TIMBRE_1990 AS (
    SELECT
        DISTINCT *
    FROM
        TIMBRU
    WHERE
        EXTRACT(
            YEAR
            FROM
                TIMBRU.DATA_EMITERE
        ) = 1990
)
SELECT
    SOC_ASIGURARE.COD_ASIGURATOR,
    SOC_ASIGURARE.NUME_SOCIETATE,
    SOC_ASIGURARE.TARA
FROM
    ESTE_ASIGURAT
    INNER JOIN TIMBRU ON TIMBRU.COD_TIMBRU = ESTE_ASIGURAT.COD_TIMBRU
    INNER JOIN SOC_ASIGURARE ON SOC_ASIGURARE.COD_ASIGURATOR = ESTE_ASIGURAT.COD_ASIGURATOR
WHERE
    EXTRACT(
        YEAR
        FROM
            TIMBRU.DATA_EMITERE
    ) = 1990
GROUP BY
    SOC_ASIGURARE.COD_ASIGURATOR,
    SOC_ASIGURARE.NUME_SOCIETATE,
    SOC_ASIGURARE.TARA
HAVING
    COUNT(TIMBRU.COD_TIMBRU) = (
        SELECT
            COUNT(COD_TIMBRU)
        FROM
            TIMBRE_1990
    );

-- 6.
SELECT
    COUNT(VINDE.COD_TIMBRU) AS NUMAR_DE_TIMBRE,
    SUM(VINDE.VAL_CUMPARARE) AS SUMA_TOTALA
FROM
    VINDE
WHERE
    EXTRACT(
        YEAR
        FROM
            VINDE.DATA_ACHIZITIE
    ) = 2020
    AND VINDE.VAL_PORNIRE = VINDE.VAL_CUMPARARE;

-- 7.
COMMIT;

CREATE TABLE VALOARE_TOTAL_AAE ();

ROLLBACK;