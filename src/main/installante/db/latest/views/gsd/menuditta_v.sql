--liquibase formatted sql
--changeset snocca:202311071131 runAlways:true runOnChange:true stripComments:false
create or replace view menuditta_v
as
select m.*
     , lpad(m.pro_cliente,3,'0')||lpad(m.com_cliente,3,'0') ID
  from menuditta m
/
