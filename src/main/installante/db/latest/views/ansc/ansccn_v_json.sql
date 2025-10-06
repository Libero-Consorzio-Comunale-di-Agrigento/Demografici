--liquibase formatted sql
--changeset snocca:202310160930_2 runAlways:true runOnChange:true stripComments:false
create or replace view ansccn_v_json
       (id, idNotifica)
as
select id, id as idNotifica
  from ansnot
/
comment on table ansccn_v_json is 'ANSC - Criteri conferma notifica per request JSON (view)'
/