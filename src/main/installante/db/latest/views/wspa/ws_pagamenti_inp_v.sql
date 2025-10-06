--liquibase formatted sql
--changeset vmigliore:202501101510 runAlways:true stripComments:false
create or replace view WS_PAGAMENTI_INP_V 
as
select inp.*,
       f_WSPA_get_provider PROVIDER 
  from arcinp inp
 where ((parametro like 'NEXT%' and f_WSPA_get_provider = 'NEXTSTEP')
        OR
        (parametro like 'DEPAG%' and f_WSPA_get_provider = 'DEPAG')
       )
/
comment on table ws_pagamenti_inp_v is 'WS Pagamenti - Parametri (view)'
/
