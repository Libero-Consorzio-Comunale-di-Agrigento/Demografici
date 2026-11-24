--liquibase formatted sql
--changeset amonopoli:202606170815 runAlways:true runOnChange:true stripComments:false
create or replace view anadcp_v
AS 
select dcp.*,
       (select dcc.descrizione from anadcc dcc where cod_cc = dcp.cod_Condizione) des_condizione,
       (select dco.tipo_comunicazione from anadco_zk dco where dco.codice_co = dcp.codice_co) tipo_comunicazione
  from anadcp dcp
/
comment on table anadcp_v is 'Anagrafe - Parametri per Comunicazioni (view)'
/
