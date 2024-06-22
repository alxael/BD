-- Aelenei Alex-Ioan
-- Grupa 152
-- Subiectul 1
-- Exercitiul 1
SELECT
    TURIST.ID AS "Cod turist",
    (TURIST.NUME || ' ' || TURIST.PRENUME) AS "Nume si prenume turist",
    HOTEL.ID AS "Cod hotel",
    HOTEL.DENUMIRE AS "Denumire hotel",
    HOTEL.NR_STELE AS "Nr. stele",
    FACILITATE.DENUMIRE AS "Denumire facilitate",
    REZERVARE.DATA_REZERVARE AS "Data rezervare"
FROM
    TURIST_REZERVARE
    INNER JOIN TURIST ON TURIST.ID = TURIST_REZERVARE.ID_TURIST
    INNER JOIN REZERVARE ON REZERVARE.ID = TURIST_REZERVARE.ID_REZERVARE
    INNER JOIN CAMERA ON CAMERA.ID = REZERVARE.ID_CAMERA
    INNER JOIN HOTEL ON HOTEL.ID = CAMERA.ID_HOTEL
    LEFT JOIN FACILITATI_HOTEL ON FACILITATI_HOTEL.ID_HOTEL = HOTEL.ID
    LEFT JOIN FACILITATE ON FACILITATE.ID = FACILITATI_HOTEL.ID_FACILITATE
WHERE
    EXTRACT(
        YEAR
        FROM
            REZERVARE.DATA_REZERVARE
    ) = 2023;

-- Exercitiul 2
WITH HOTEL_DATA AS (
    SELECT
        HOTEL.ID,
        HOTEL.DENUMIRE,
        COUNT(TURIST.ID) AS GUEST_COUNT
    FROM
        TURIST_REZERVARE
        INNER JOIN TURIST ON TURIST.ID = TURIST_REZERVARE.ID_TURIST
        INNER JOIN REZERVARE ON REZERVARE.ID = TURIST_REZERVARE.ID_REZERVARE
        INNER JOIN CAMERA ON CAMERA.ID = REZERVARE.ID_CAMERA
        INNER JOIN HOTEL ON CAMERA.ID_HOTEL = HOTEL.ID
        INNER JOIN TARIF_CAMERA ON TARIF_CAMERA.ID_CAMERA = CAMERA.ID
    WHERE
        REZERVARE.DATA_REZERVARE >= TARIF_CAMERA.DATA_START
    GROUP BY
        HOTEL.ID,
        HOTEL.DENUMIRE
),
TOP_HOTEL AS (
    SELECT
        *
    FROM
        HOTEL_DATA
    WHERE
        ROWNUM <= 1
)
SELECT
    TOP_HOTEL.ID,
    TOP_HOTEL.DENUMIRE,
    SUM(TARIF_CAMERA.TARIF) AS "Suma tarif"
FROM
    TOP_HOTEL
    INNER JOIN CAMERA ON CAMERA.ID_HOTEL = TOP_HOTEL.ID
    INNER JOIN REZERVARE ON REZERVARE.ID_CAMERA = CAMERA.ID
    INNER JOIN TARIF_CAMERA ON TARIF_CAMERA.ID_CAMERA = REZERVARE.ID_CAMERA
WHERE
    REZERVARE.NR_ZILE = 1
    AND REZERVARE.DATA_REZERVARE >= TARIF_CAMERA.DATA_START
GROUP BY
    TOP_HOTEL.ID,
    TOP_HOTEL.DENUMIRE;

-- Exercitiul 3
WITH SPECIFIC_HOTEL AS (
    SELECT
        *
    FROM
        HOTEL
    WHERE
        UPPER(HOTEL.LOCALITATE) = 'CONSTANTA'
        AND HOTEL.NR_STELE = 3
),
HOTEL_IDS AS (
    SELECT
        FH2.ID_HOTEL
    FROM
        SPECIFIC_HOTEL
        INNER JOIN FACILITATI_HOTEL FH1 ON FH1.ID_HOTEL = SPECIFIC_HOTEL.ID
        INNER JOIN FACILITATI_HOTEL FH2 ON FH2.ID_FACILITATE = FH1.ID_FACILITATE
    WHERE
        FH2.ID_HOTEL != (
            SELECT
                ID
            FROM
                SPECIFIC_HOTEL
        )
    GROUP BY
        FH2.ID_HOTEL
    HAVING
        COUNT(FH1.ID_FACILITATE) = (
            SELECT
                COUNT(*)
            FROM
                SPECIFIC_HOTEL
                INNER JOIN FACILITATI_HOTEL ON FACILITATI_HOTEL.ID_HOTEL = SPECIFIC_HOTEL.ID
        )
)
SELECT
    HOTEL_IDS.ID_HOTEL AS "Cod hotel",
    HOTEL.DENUMIRE AS "Denumire hotel",
    FACILITATE.DENUMIRE AS "Denumire facilitate"
FROM
    HOTEL_IDS
    INNER JOIN HOTEL ON HOTEL.ID = HOTEL_IDS.ID_HOTEL
    INNER JOIN FACILITATI_HOTEL ON FACILITATI_HOTEL.ID_HOTEL = HOTEL.ID
    INNER JOIN FACILITATE ON FACILITATE.ID = FACILITATI_HOTEL.ID_FACILITATE;

-- Exercitiul 4
COMMIT;

CREATE TABLE CAPACITATE_HOTEL (
    COD_HOTEL INTEGER NOT NULL,
    NUME_HOTEL VARCHAR2(255) NOT NULL,
    CAPACITATE INTEGER NOT NULL,
    CONSTRAINT ID_HOTEL_PK PRIMARY KEY (COD_HOTEL)
);

INSERT INTO
    CAPACITATE_HOTEL (COD_HOTEL, NUME_HOTEL, CAPACITATE) (
        SELECT
            HOTEL.ID AS COD_HOTEL,
            HOTEL.DENUMIRE AS NUME_HOTEL,
            SUM(CAMERA.CAPACITATE) AS CAPACITATE
        FROM
            HOTEL
            INNER JOIN CAMERA ON CAMERA.ID_HOTEL = HOTEL.ID
        GROUP BY
            HOTEL.ID,
            HOTEL.DENUMIRE
    );

SELECT
    *
FROM
    CAPACITATE_HOTEL;

DROP TABLE CAPACITATE_HOTEL;

ROLLBACK;