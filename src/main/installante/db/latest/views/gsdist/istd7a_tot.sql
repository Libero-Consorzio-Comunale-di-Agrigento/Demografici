--liquibase formatted sql
--changeset amonopoli:202312151725 runOnChange:true stripComments:false
create or replace view ISTD7A_tot
	(archivio, punto, des_punto, data_eve, totale_m, totale_f, totale)
AS
select v_int.archivio
     , v_int.punto
     , v_int.des_punto
     , v_int.data
     , count(decode(d7a.sesso,'M','M',''))
     , count(decode(d7a.sesso,'F','F',''))
     , count(decode(d7a.atto,'','',d7a.atto))
  from (select distinct d7a.data_eve data, int.* from istd7a d7a, istd7a_int int) v_int,
       istd7a d7a
 where d7a.archivio	(+) = v_int.archivio
   and d7a.punto	(+) = v_int.punto
   and d7a.data_eve	(+) = v_int.data
   and v_int.archivio not in ('MAT','DIV','SCI')
 group by v_int.archivio, v_int.punto, v_int.des_punto, v_int.data
UNION
select v_int.archivio
     , v_int.punto
     , v_int.des_punto
     , v_int.data
     , to_number(null)
     , to_number(null)
     , count(decode(d7a.atto,'','',d7a.atto))
  from (select distinct d7a.data_eve data, int.* from istd7a d7a, istd7a_int int) v_int,
       istd7a d7a
 where d7a.archivio	(+) = v_int.archivio
   and d7a.punto	(+) = v_int.punto
   and d7a.data_eve	(+) = v_int.data
   and v_int.archivio in ('MAT','DIV','SCI')
 group by v_int.archivio, v_int.punto, v_int.des_punto, v_int.data
/
comment on table ISTD7A_TOT is 'ISTAT - Dati Riepilogativi per Compilazione Modello D7A (view)'
/
