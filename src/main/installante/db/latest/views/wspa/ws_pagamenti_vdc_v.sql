--liquibase formatted sql
--changeset vmigliore:202501101600 runAlways:true stripComments:false
create or replace view WS_PAGAMENTI_VDC_V 
as
select vdc.*,
       (select dtd.id from cerdtd dtd where cod_diritto = vdc.cod_diritto_rif and fascia_tariffaria = vdc.fascia_tariffaria_rif) ID_CERDTD_RIF,
       f_WSPA_get_provider PROVIDER
  from WS_PAGAMENTI_VDC vdc
/
comment on table ws_pagamenti_vdc_v is 'WS Pagamenti - Voci di Costo (view)'
/
