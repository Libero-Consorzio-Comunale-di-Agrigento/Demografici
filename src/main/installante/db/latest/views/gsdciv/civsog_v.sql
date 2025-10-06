--liquibase formatted sql
--changeset snocca:202303281200_4 runAlways:true runOnChange:true stripComments:false
create or replace view CIVSOG_V
AS
select sog.*,
-- cognome_nome
       sog.cognome||' '||sog.nome cognome_nome,
-- des_com_nas
       f_comune_al(sog.cod_pro_nas,sog.cod_com_nas,to_char(sog.d_data_nas,'j')) des_com_nas,
-- sigla_pro_nas
       f_provincia_stato_al(sog.cod_pro_nas,sog.cod_com_nas,'','S','',to_char(sog.d_data_nas,'j')) sigla_pro_nas,
-- des_com_res
       f_comune_al(sog.cod_pro_res,sog.cod_com_res,'') des_com_res,
-- sigla_pro_res
       f_provincia_stato_al(sog.cod_pro_res,sog.cod_com_res,'','S','','') sigla_pro_res,
-- cambio_generalita
case when tipo_soggetto = 'CG' and (cognome is not null or nome is not null or sesso is not null or d_data_nas is not null or
          cod_com_nas is not null or cod_pro_nas is not null or cod_com_res is not null or cod_pro_res is not null or nazionalita is not null)
     then 'SI' else 'NO' end cambio_generalita
  from civsog sog
/
comment on table CIVSOG_V is 'Stato Civile - Archivio Soggetti collegati all''atto (view)'
/
