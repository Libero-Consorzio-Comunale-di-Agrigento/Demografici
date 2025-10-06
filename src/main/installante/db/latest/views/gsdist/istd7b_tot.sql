--liquibase formatted sql
--changeset amonopoli:202503211241_3 runOnChange:true stripComments:false
create or replace view ISTD7B_tot
	(archivio, punto, des_punto, data_reg, totale_m, totale_f, totale)
AS
select v_int.archivio
     , v_int.punto
     , v_int.des_punto
     , v_int.data
     , count(decode(d7b.sesso,'M','M',''))
     , count(decode(d7b.sesso,'F','F',''))
     , count(decode(d7b.sesso,'','',d7b.sesso))
  from (select distinct d7b.data_reg data, int.* from istd7b d7b, istd7b_int int) v_int
     , istd7b d7b
 where d7b.archivio	(+) = v_int.archivio
   and d7b.punto	(+) = v_int.punto
   and d7b.data_reg	(+) = v_int.data
 group by v_int.archivio, v_int.punto, v_int.des_punto, v_int.data
/
comment on table ISTD7B_TOT is 'ISTAT - Dati Riepilogativi per Compilazione Modello D7B (view)'
/
