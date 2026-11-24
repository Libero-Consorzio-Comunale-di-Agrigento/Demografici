--liquibase formatted sql
--changeset amonopoli:202603191045 runOnChange:true stripComments:false
create or replace view ansjsn_sezioni_v_lista
AS
select distinct servizio, tipo_atto, usecase, 
       servizio||nvl(tipo_atto,0)||lpad(nvl(usecase,0),10,'0') ID
  from ansjsn_sezioni
/
comment on table ansjsn_sezioni_v_lista is 'ANSC - Distinct di Servizi / Tipo Atto / Usecase per modifica JSON'
/
