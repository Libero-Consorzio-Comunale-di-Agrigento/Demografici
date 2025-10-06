--liquibase formatted sql
--changeset amonopoli:202503211242_3 runOnChange:true stripComments:false
create or replace view ISTDAP_tot
	(archivio, punto, des_punto, data_reg, totale_m, totale_f, totale)
AS
select v_int.archivio
     , v_int.punto
     , v_int.des_punto
     , v_int.data
     , count(decode(dap.sesso,'M','M',''))
     , count(decode(dap.sesso,'F','F',''))
     , count(decode(dap.sesso,'','',dap.sesso))
  from (select distinct dap.data_reg data, int.* from istdap dap, istdap_int int) v_int
     , istdap dap
 where dap.archivio 	(+) = v_int.archivio
   and dap.punto	(+) = v_int.punto
   and dap.data_reg	(+) = v_int.data
 group by v_int.archivio, v_int.punto, v_int.des_punto, v_int.data
/
comment on table ISTDAP_TOT is 'ISTAT - Dati Riepilogativi per Compilazione Modello APR/4 (view)'
/
