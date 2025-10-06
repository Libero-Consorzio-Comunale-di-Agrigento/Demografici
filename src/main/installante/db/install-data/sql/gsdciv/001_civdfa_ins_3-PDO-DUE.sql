--liquibase formatted sql
--changeset amonopoli:202405161535_1 runOnChange:true stripComments:false
insert into CIVDFA (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE)
select 3, '3-PDO-DUE', 'W', 'DOCUMENTI VERBALI (DUE COMUNI)', null, null, null, 'M', 'DOCUMENTI VERBALI (DUE COMUNI)'
  from dual
 where not exists (select 1 from civdfa b
                    where b.formula = '3-PDO-DUE')
/
