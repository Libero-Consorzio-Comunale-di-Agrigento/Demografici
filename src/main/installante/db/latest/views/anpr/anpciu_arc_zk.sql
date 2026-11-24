--liquibase formatted sql
--changeset amonopoli:202606161220 runOnChange:true stripComments:false
create or replace view anpciu_arc_zk
     ( codice, descrizione, sequenza, flag_invio_massivo)
AS
select * from anpciu_arc
 where codice is not null
/
comment on table anpciu_arc_zk is 'ANPR - Archivi Rif. per Filtri di ricerca web-service (zk)'
/

