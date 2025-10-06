--liquibase formatted sql
--changeset amonopoli:202405161535_3 runOnChange:true stripComments:false
insert into CIVDRF (TIPO_ATTO, RICHIAMO, PROGR_DETTAGLIO, FORMULA, FLAG_DEFAULT, FLAG_RICORRENTE, FLAG_TESTO_FISSO, ID, FLAG_AGGIUNTA_A_CAPO, FLAG_AGGIUNTA_RICHIAMO)
select 3, 6, 1, '3-PDO-DUE', 'S', null, null, null, 'S', null
  from dual
 where not exists (select 1 from civdrf b
                    where b.tipo_atto = 3
                      and b.richiamo  = 6
                      and b.formula   = '3-PDO-DUE')
/
