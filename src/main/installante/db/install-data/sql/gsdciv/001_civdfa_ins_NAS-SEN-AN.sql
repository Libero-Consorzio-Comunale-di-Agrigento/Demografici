--liquibase formatted sql
--changeset amonopoli:202406181655_1 runOnChange:true stripComments:false
insert into civdfa (TIPO_ATTO, FORMULA, TIPO_ANNOTAZIONE, DESCRIZIONE_1, DESCRIZIONE_2, DESCRIZIONE_3, FLAG_NUOVO_ORDINAMENTO, FLAG_PROVENIENZA, DESCRIZIONE, GENERE, FLAG_SECRETATO, FLAG_ISTAT)
select 2, 'NAS-SEN-AN', 'M', 'MARGINE - SENTENZA DICHIARAZIONE TARDIVA', null, null, 'S', null, 'MARGINE - SENTENZA DICHIARAZIONE TARDIVA', null, null, null
  from dual
 where not exists (select 1 from civdfa
                    where formula = 'NAS-SEN-AN')
/

