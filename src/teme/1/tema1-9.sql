DELETE FROM 
    SPONSOR_AAE SPONSOR 
WHERE
    NOT EXISTS (
        SELECT 
            * 
        FROM 
            CAMPANIE_AAE CAMPANIE 
        WHERE 
            CAMPANIE.COD_SPONSOR=SPONSOR.COD_SPONSOR
    );
    
SELECT * FROM SPONSOR_AAE;