--liquibase formatted sql
--changeset amonopoli:202503050805_1 runOnChange:true stripComments:false
create or replace view anavt8
	(archivio, cod_eve_pr, cod_mov, cod_fam, data_eve, sequenza_par, cod_fam_unique)
as 
--
-- chiusure famiglia con riferimento al COD_EVE_PR
-- (DES_EVENTO = decodifica del COD_EVE_PR)
-- (COD_EVE_PR '92' verra' decodificato TRASFERIMENTO AD ALTRO NUCLEO)
-- 
select 'EVE 1',
	e.cod_eve_pr,decode(e.cod_mov,10,2,4),e.cod_fam,e.data_eve+1,
       	min(lpad(drp.sequenza,2,'0')),
        e.cod_fam_unique
  from anadrp drp,anaeve e
 where drp.cod_rp 	= e.rapporto_par
   and e.cod_mov 	in (10,12)
   and e.cod_eve_pr	is not null
group by e.cod_eve_pr,e.cod_mov,e.cod_fam,e.data_eve,e.cod_fam_unique
union
--
-- chiusure famiglia collegate ad altre chiusure di famiglia 
-- (DES_EVENTO = TRASFERIMENTO DA ALTRO NUCLEO)
-- 
select max('EVE 2'),
	max(0),decode(e.cod_mov,10,1,3),e.cod_fam,e.data_inizio,
       	min(lpad(drp.sequenza,2,'0')),
        e.cod_fam_unique
  from anadrp drp, anaeve e2, anaeve e
 where drp.cod_rp 	= e.rapporto_par 
   and ((e.cod_mov = 10 and e2.cod_mov = 10) or
	(e.cod_mov = 12 and e2.cod_mov = 12))
   and e2.matricola 	= e.matricola
   and e2.data_eve  	= e.data_inizio - 1
   and e2.cod_fam   	!= e.cod_fam
 group by e.cod_mov,e.cod_fam,e.data_inizio,e.cod_fam_unique
union
--
-- chiusure famiglia collegate ad eventi di iscrizione
-- (DES_EVENTO = decodifica del COD_EVE_PR di iscrizione)
-- 
select max('EVE 3'),
	e2.cod_eve_pr,e2.cod_mov,e.cod_fam,e2.data_eve,
       	min(lpad(drp.sequenza,2,'0')),
        e.cod_fam_unique
  from anadrp drp,anaeve e2, anaeve e
 where drp.cod_rp 	= e.rapporto_par
   and ((e.cod_mov = 10 and e2.cod_mov = 1) or
	(e.cod_mov = 12 and e2.cod_mov = 3))
   and e2.matricola 	= e.matricola
   and e2.data_eve  	= e.data_inizio
   and e2.cod_eve_pr	is not null
 group by e2.cod_eve_pr,e2.cod_mov,e.cod_fam,e2.data_eve,e.cod_fam_unique
union
--
-- chiusure famiglia collegate all'ultimo evento di anagrafe
-- solo per NASCITA
-- (DES_EVENTO = decodifica dello STATO di ANAANA)
-- 
select 'EVE 4',	
	a.stato,a.fascia,e.cod_fam,a.data_ult_eve,
       	min(lpad(a.sequenza_par,2,'0')),
        e.cod_fam_unique
  from anaana a, anaeve e
 where ((e.cod_mov = 10 and a.fascia = 1) or
	(e.cod_mov = 12 and a.fascia = 3))
   and a.matricola    	 = e.matricola
   and a.stato        	 = 1
   and a.data_ult_eve 	 = e.data_inizio
   and a.data_inizio_fam = e.data_inizio
   and a.cod_fam	 = e.cod_fam
group by a.stato,a.fascia,e.cod_fam,a.data_ult_eve,e.cod_fam_unique
union
--
-- chiusure famiglia collegate alla data di nascita
-- nel caso di ultimo evento diverso da nascita (???)
-- (DES_EVENTO = NASCITA)
-- 
select 'EVE 5',
	1,decode(e.cod_mov,10,1,12,3),e.cod_fam,a.data_nas,
       	lpad(a.sequenza_par,2,'0'),
        e.cod_fam_unique
  from anaana a, anaeve e
 where e.cod_mov 	in (10,12)
   and a.matricola    	= e.matricola
--   and a.data_ult_eve	> a.data_nas
   and a.data_nas 	= e.data_inizio
union
--
-- posizione famiglia recuperata dall'anagrafe se non esistono
-- chiusure successive all'ultimo evento
-- (DES_EVENTO = decodifica dello STATO di ANAANA)
-- 
select max('ANA 1'),
	a.stato,a.fascia,a.cod_fam,a.data_inizio_fam,
       	min(lpad(a.sequenza_par,2,'0')),
        a.cod_fam_unique
  from anaana a
 where a.fascia  	 in (1,3)
   and a.data_inizio_fam = a.data_ult_eve
group by a.stato,a.fascia,a.cod_fam,a.data_inizio_fam,a.cod_fam_unique
union
--
-- chiusure famiglia collegate all'attuale posizione famiglia di anagrafe
-- nel caso in cui questa abbia subito variaizioni dall'ultimo evento
-- (DES_EVENTO = TRASFERIMENTO DA ALTRO NUCLEO)
-- 
select max('ANA 2'),
	max(0),a.fascia,a.cod_fam,a.data_inizio_fam,
       	min(lpad(a.sequenza_par,2,'0')),
        a.cod_fam_unique
  from anaeve e, anaana a
 where ((a.fascia = 1 and e.cod_mov = 10) or
	(a.fascia = 3 and e.cod_mov = 12))
   and a.data_inizio_fam > a.data_ult_eve
   and e.matricola 	 = a.matricola
   and e.data_eve  	 = a.data_inizio_fam - 1
   and e.cod_fam   	 != a.cod_fam
group by a.fascia,a.cod_fam,a.data_inizio_fam,a.cod_fam_unique
/
comment on table anavt8 is 'Anagrafe - Storico anagrafico della Famiglia per Visualizzazione forms11 (view)'
/
