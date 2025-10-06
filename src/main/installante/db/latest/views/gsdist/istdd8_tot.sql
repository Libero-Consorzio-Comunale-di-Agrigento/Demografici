--liquibase formatted sql
--changeset amonopoli:202503211243_3 runOnChange:true stripComments:false
create or replace view istdd8_tot
      (tipo_archivio, anno, des_tipo_atto, totale_m, totale_f, totale)
AS      
select 'CIT', 
       cit.anno, 
       cit.des_tipo_atto,
       count(decode(cit.sesso,'M','M','')) maschi, 
       count(decode(cit.sesso,'F','F','')) femmine, 
       count(*) totale
  from istdd8 cit
 group by cit.anno, cit.des_tipo_atto
UNION
select 'NAS', 
       nas.anno, 
       nas.des_tipo_atto,
       count(decode(nas.sesso,'M','M','')) maschi, 
       count(decode(nas.sesso,'F','F','')) femmine, 
       count(*) totale
  from istdd8_nas nas
 group by nas.anno, nas.des_tipo_atto
/
comment on table istdd8_tot is 'ISTAT - Dati Modello D.8 - Totali (view)'
/
