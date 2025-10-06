--liquibase formatted sql
--changeset amonopoli:202503131505 runAlways:true stripComments:false
create or replace view anacdf_v_zk
AS
select /*+ PUSH_SUBQ*/
       cdf.*
     , f_comune_al(cdf.cod_pro_inizio,cdf.cod_com_inizio,'') des_com_inizio
     , f_provincia_stato_al(cdf.cod_pro_inizio,cdf.cod_com_inizio,'','S','','') sigla_pro_inizio
     , f_comune_al(cdf.cod_pro_fine,cdf.cod_com_fine,'') des_com_fine
     , f_provincia_stato_al(cdf.cod_pro_fine,cdf.cod_com_fine,'','S','','') sigla_pro_fine
     , f_cdf_contratto_convivenza(cdf.matricola) contratto_convivenza
  from anacdf cdf
/
comment on table anacdf_v_zk is 'Anagrafe - Dati della Convivenza di Fatto (view)'
/
