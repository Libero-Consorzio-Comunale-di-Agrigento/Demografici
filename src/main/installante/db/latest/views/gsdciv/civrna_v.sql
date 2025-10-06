--liquibase formatted sql
--changeset amonopoli:202504031405 runAlways=true runOnChange:true stripComments:false
create or replace view civrna_v
AS
select rna.*,
-- des_com_nas
       f_comune_al(rna.cod_pro_nas,rna.cod_com_nas,rna.data_nas) des_com_nas,
-- sigla_pro_nas
       f_provincia_stato_al(rna.cod_pro_nas,rna.cod_com_nas,'','S','',rna.data_nas) sigla_pro_nas,
-- des_com_atto_nas
       f_comune_al(rna.cod_pro_atto_nas,rna.cod_com_atto_nas,rna.data_nas) des_com_atto_nas,
-- sigla_pro_atto_nas
       f_provincia_stato_al(rna.cod_pro_atto_nas,rna.cod_com_atto_nas,'','S','',rna.data_nas) sigla_pro_atto_nas
  from civrna rna
/
comment on table civrna is 'Stato Civile - Rubrica Nascite (view)'
/
