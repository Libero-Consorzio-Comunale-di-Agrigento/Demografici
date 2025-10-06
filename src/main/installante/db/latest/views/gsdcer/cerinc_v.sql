--liquibase formatted sql
--changeset snocca:202404151100 runAlways:true runOnChange:true stripComments:false
create or replace view cerinc_v
AS
select inc.*
     , to_number(null) as tipo_atto
     , (inc.anno_emissione||lpad(inc.progr_emissione,6,'0')) as id_emissione
  from cerinc inc
/
comment on table cerinc_v is 'Certificazione - Individui da certificare'
/
