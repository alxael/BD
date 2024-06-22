COMMIT;

-- trebuie sterse mai intai toate referintele catre entry-ul cu COD_SPONSOR=20
-- in acest caz, singurul loc in care COD_SPONSOR este FOREIGN KEY este in COD_SPONSOR din CAMPANIE_AAE
UPDATE CAMPANIE_AAE SET COD_SPONSOR=NULL WHERE COD_SPONSOR=20;
-- ulterior, putem sterge si entry-ul cu COD_SPONSOR=20, intrucat acum nu mai are alte referinte
DELETE FROM SPONSOR_AAE WHERE COD_SPONSOR=20;

ROLLBACK;