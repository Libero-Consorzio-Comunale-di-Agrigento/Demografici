--liquibase formatted sql
--changeset snocca:202401241037 runOnChange:true stripComments:false
create or replace view CERDNS_V
AS
select dns.nome_sindaco as cod_dns, dns.nome_sindaco as cognome_nome
  from cerdns dns
/
comment on table CERDNS_V is 'Certificazione - Cognome sindaco (view)'
/
