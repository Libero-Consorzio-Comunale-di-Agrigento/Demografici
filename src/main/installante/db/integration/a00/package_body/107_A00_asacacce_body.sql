--liquibase formatted sql
--changeset amonopoli:202503261007_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY asacacce IS
  PROCEDURE Main ( prenotazione Number, passo Number ) is
begin
DELETE
  FROM A_ACCESSI ACCE
 WHERE ACCE.UTENTE    = (select nvl(max(valore),acce.utente)
                           from a_parametri para
                          where para.no_prenotazione = prenotazione
                            and para.parametro       = 'UTENTE'
                        )
   AND trunc(ACCE.DATA) <= (select nvl(max(to_date(valore
                                      ,decode(nvl(length(translate(valore,'a0123456789/','a')),0)
                                 , 0 ,'dd/mm/yyyy','dd-mon-yyyy'))
                                    ),acce.data)
                              from a_parametri para
                             where para.no_prenotazione = prenotazione
                               and para.parametro       = 'DATA'
                            )
;
COMMIT;
end;
END;
/

