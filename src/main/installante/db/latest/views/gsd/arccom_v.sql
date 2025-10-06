--liquibase formatted sql
--changeset amonopoli:202403131710_1 runOnChange:true stripComments:false
create or replace view arccom_v
AS
select v.*
     , nvl(v.descrizione_al1,v.descrizione) DES_COMUNE
     , decode(v.DATA_SOPPRESSIONE,'','','S') FLAG_SOPPRESSO
     , to_date(v.DATA_SOPPRESSIONE,'j') D_DATA_SOPPRESSIONE
     , to_date(v.DATA_ISTITUZIONE,'j') D_DATA_ISTITUZIONE
     , lpad(v.cod_provincia,3,'0')||lpad(v.cod_comune,3,'0') ID
     , f_provincia_stato_al(v.cod_provincia,v.cod_comune,'','S','','') des_sigla_provincia
  from arccom v
/
comment on table arccom_v is 'Comuni - Archivio Attuale (view)'
/
