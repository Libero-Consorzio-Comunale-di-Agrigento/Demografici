--liquibase formatted sql
--changeset amonopoli:202503261006_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY asacanac IS
  PROCEDURE Main ( prenotazione Number, passo Number ) is
d_vita_accessi number(10);
begin
SELECT vita_accessi 
into d_vita_accessi
FROM A_PARAMETRI_SCHED
WHERE rownum = 1
;
DELETE FROM A_ACCESSI acce
WHERE to_number(to_char(acce.data,'J')) <
      ( to_number(to_char(sysdate,'J')) - d_vita_accessi )
;
COMMIT;
end;
END;
/

