--liquibase formatted sql
--changeset amonopoli:202504011135_1 runAlways:true runOnChange:true stripComments:false
create or replace view anaesc
	(data_reg, matricola, cod_eve, data_eve, 
	 stato_civile, sesso, cognome_nome_cn, matricola_cn, 
	 data_mat, cod_pro_mat, cod_com_mat, cod_pro_atto_mat, cod_com_atto_mat, 
	 data_ved, cod_pro_ved, cod_com_ved, cod_pro_atto_ved, cod_com_atto_ved, 
 	 data_div, cod_pro_div, cod_com_div, cod_pro_atto_div, cod_com_atto_div, 
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
 	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale,
	 archivio, des_cod_eve)
as
-- ANAANA: matrimonio / unione civile se attualmente 'CN' / 'UC'
select /*+ PUSH_SUBQ*/ data_mat, matricola, 93, data_mat,
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat, cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved, cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div, cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale, 
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale, 
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale, 
         atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale, 
	 'ANA', 
--	 decode(stato_civile,'CN','Matrimonio','UC','Unione Civile')
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anaana
 where data_mat 	is not null
   and stato_civile	in ('CN','UC')
UNION
-- ANAANA: vedovanza se attualmente 'VE' / 'VU'
select data_ved, matricola, 94, data_ved,
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat, cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved, cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div, cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale, 
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale, 
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale, 
	 atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale, 
	 'ANA', 
--         decode(stato_civile,'VE','Vedovanza','VU','Vedovanza da U.C.')
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anaana
 where data_ved 	is not null
   and stato_civile	in ('VE','VU')
UNION
-- ANAANA: cessazione se attualmente in ('GC','DV','GU')
select nvl(data_div,data_div_ann), matricola, 99, nvl(data_div,data_div_ann),
 	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat, cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved, cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div, cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale, 
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale, 
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale, 
	 atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale, 
	 'ANA', 
--	  'Cessazione'
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anaana
 where nvl(data_div,data_div_ann) is not null
   and stato_civile	in ('DV','GC','GU')
UNION
-- ANAMOV: matrimonio / unione civile da record di cancellazione
select data_mat, matricola, 93, data_mat,
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat, cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved, cod_pro_atto_ved, cod_com_atto_ved,
 	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div, cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale, 
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale, 
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale, 
	 atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale, 
	 'MOV_C', 
--	  decode(stato_civile,'CN','Matrimonio','UC','Unione Civile')
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where cod_mov 		in (2,4)
   and cod_eve 		!= 50
   and stato_civile 	in ('CN','UC')
   and data_mat		is not null
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 		= a.matricola
			    and ana.stato_civile 	= a.stato_civile
			    and ana.data_mat 		= a.data_mat)
UNION
-- ANAMOV: vedovanza da record di cancellazione
select data_ved, matricola, 94, data_ved,
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat, cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved,cod_pro_ved, cod_com_ved, cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div, cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale, 
 	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale, 
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale, 
	 atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale, 
	 'MOV_C', 
--	  decode(stato_civile,'VE','Vedovanza','VU','Vedovanza da U.C.')
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where cod_mov 		in (2,4)
   and cod_eve 		!= 50
   and stato_civile	in ('VE','VU')
   and data_ved		is not null
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 		= a.matricola
			    and ana.stato_civile 	= a.stato_civile
			    and ana.data_ved 		= a.data_ved)
UNION
-- ANAMOV: cessazione da record di cancellazione
select nvl(data_div,data_div_ann), matricola, 99, nvl(data_div,data_div_ann),
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat, cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved, cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div, cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale, 
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale, 
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale, 
	 atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale, 
	 'MOV_C', 
--	  'Cessazione'
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where cod_mov 		in (2,4)
   and cod_eve 		!= 50
   and stato_civile 	in ('DV','GC','GU')
   and nvl(data_div,data_div_ann) is not null
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 		= a.matricola
			    and ana.stato_civile 	= a.stato_civile
			    and nvl(ana.data_div,ana.data_div_ann) = nvl(a.data_div,a.data_div_ann))
UNION
-- ANAMOV: matrimonio / unione civile da dati precedenti di record di matrimonio / vedovanza / rettifica
-- nel caso di cod_eve = 94, i dati _PREC non sono valorizzati, ma esistono
-- solo quelli attuali
select nvl(data_mat_prec,data_mat), matricola, 93, nvl(data_mat_prec,data_mat),
	 stato_civile_prec, sesso_prec, 
         case 
              when stato_civile in ('CN','UC') then cognome_nome_cn_prec
              else nvl(cognome_nome_cn_prec, cognome_nome_cn)
         end,
         case 
              when stato_civile in ('CN','UC') then matricola_cn_prec
              else nvl(matricola_cn_prec, matricola_cn)
         end,
	 nvl(data_mat_prec,data_mat), 
         case 
              when stato_civile in ('CN','UC') then cod_pro_mat_prec
              else nvl(cod_pro_mat_prec,cod_pro_mat)
         end,
         case 
              when stato_civile in ('CN','UC') then cod_com_mat_prec
              else nvl(cod_com_mat_prec,cod_com_mat)
         end,
         case 
              when stato_civile in ('CN','UC') then cod_pro_atto_mat_prec
              else nvl(cod_pro_atto_mat_prec,cod_pro_atto_mat)
         end,
         case 
              when stato_civile in ('CN','UC') then cod_com_atto_mat_prec
              else nvl(cod_com_atto_mat_prec,cod_com_atto_mat)
         end,
	 data_ved_prec, cod_pro_ved_prec, cod_com_ved_prec,
	 cod_pro_atto_ved_prec, cod_com_atto_ved_prec,
 	 nvl(data_div_prec,data_div_ann_prec), cod_pro_div_prec, cod_com_div_prec,
	 cod_pro_atto_div_prec, cod_com_atto_div_prec,
         case when stato_civile in ('CN','UC') then atto_mat_prec
              else nvl(atto_mat_prec,atto_mat)
         end, 
         case 
              when stato_civile in ('CN','UC') then parte_mat_prec
              else nvl(parte_mat_prec,parte_mat)
         end,
         case 
              when stato_civile in ('CN','UC') then serie_mat_prec
              else nvl(serie_mat_prec,serie_mat)
         end, 
         case 
              when stato_civile in ('CN','UC') then ufficio_mat_prec
              else nvl(ufficio_mat_prec,ufficio_mat)
         end,
         case 
              when stato_civile in ('CN','UC') then anno_atto_mat_prec
              else nvl(anno_atto_mat_prec,anno_atto_mat)
         end,
         case 
              when stato_civile in ('CN','UC') then atto_mat_digitale_prec
              else nvl(atto_mat_digitale_prec,atto_mat_digitale)
         end,
         case 
              when stato_civile in ('CN','UC') then atto_mat_tr_prec
              else nvl(atto_mat_tr_prec,atto_mat_tr)
         end, 
         case 
              when stato_civile in ('CN','UC') then parte_mat_tr_prec
              else nvl(parte_mat_tr_prec,parte_mat_tr)
         end,
         case 
              when stato_civile in ('CN','UC') then serie_mat_tr_prec
              else nvl(serie_mat_tr_prec,serie_mat_tr)
         end,
         case 
              when stato_civile in ('CN','UC') then ufficio_mat_tr_prec
              else nvl(ufficio_mat_tr_prec,ufficio_mat_tr)
         end,
         case 
              when stato_civile in ('CN','UC') then anno_atto_mat_tr_prec
              else nvl(anno_atto_mat_tr_prec,anno_atto_mat_tr)
         end,
         case 
              when stato_civile in ('CN','UC') then atto_mat_tr_digitale_prec
              else nvl(atto_mat_tr_digitale_prec,atto_mat_tr_digitale)
         end,
	 atto_ved_prec, parte_ved_prec, serie_ved_prec, ufficio_ved_prec,
  	 anno_atto_ved_prec, atto_ved_digitale,
	 atto_div_prec, parte_div_prec, serie_div_prec, ufficio_div_prec,
	 anno_atto_div_prec, atto_div_digitale,
	 'MOV_PREC', 
--	  decode(stato_civile_prec,'CN','Matrimonio','UC','Unione Civile')
         f_ESC_descrizione_evento(matricola,stato_civile_prec,data_div_prec,data_div_ann_prec)
  from anamov a
 where cod_mov 		 		in (97,98)
   and cod_eve 		 		in (93,94,99)
   and stato_civile 	 		!= stato_civile_prec
   and stato_civile_prec 		in ('CN','UC')
   and nvl(data_mat_prec,data_mat)	is not null
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	= a.stato_civile_prec
	   		    and c.data_mat	= nvl(a.data_mat_prec,a.data_mat)
			    and c.matricola	= a.matricola)
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 		= a.matricola
			    and ana.stato_civile 	= a.stato_civile_prec
			    and ana.data_mat 		= nvl(a.data_mat_prec,a.data_mat))
UNION
-- ANAMOV: vedovanza da dati precedenti di record di matrimonio / unione civile - rettifica
select data_ved_prec, matricola, 94, data_ved_prec,
	 stato_civile_prec, sesso_prec, cognome_nome_cn_prec, matricola_cn_prec,
	 data_mat_prec, cod_pro_mat_prec, cod_com_mat_prec,
	 cod_pro_atto_mat_prec, cod_com_atto_mat_prec,
	 data_ved_prec, cod_pro_ved_prec, cod_com_ved_prec,
	 cod_pro_atto_ved_prec, cod_com_atto_ved_prec,
 	 nvl(data_div_prec,data_div_ann_prec), cod_pro_div_prec, cod_com_div_prec,
	 cod_pro_atto_div_prec, cod_com_atto_div_prec,
	 atto_mat_prec, parte_mat_prec, serie_mat_prec, ufficio_mat_prec,
	 anno_atto_mat_prec, atto_mat_digitale_prec,
	 atto_mat_tr_prec, parte_mat_tr_prec, serie_mat_tr_prec,
	 ufficio_mat_tr_prec, anno_atto_mat_tr_prec, atto_mat_tr_digitale_prec,
	 atto_ved_prec, parte_ved_prec, serie_ved_prec, ufficio_ved_prec,
  	 anno_atto_ved_prec, atto_ved_digitale_prec,
	 atto_div_prec, parte_div_prec, serie_div_prec, ufficio_div_prec,
	 anno_atto_div_prec, atto_div_digitale_prec,
	 'MOV_PREC', 
--	  decode(stato_civile_prec,'VE','Vedovanza','VU','Vedovanza da U.C.')
         f_ESC_descrizione_evento(matricola,stato_civile_prec,data_div_prec,data_div_ann_prec)
  from anamov a
 where cod_mov 		 in (97,98)
   and cod_eve 		 in (93,99)
   and stato_civile 	 != stato_civile_prec
   and stato_civile_prec in ('VE','VU')
   and data_ved_prec	 is not null
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	= a.stato_civile_prec
	   		    and c.data_ved	= a.data_ved_prec
			    and c.matricola	= a.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 		= a.matricola
			    and ana.stato_civile 	= a.stato_civile_prec
			    and ana.data_ved 		= a.data_ved_prec)
UNION
-- ANAMOV: cessazione da dati precedenti di record di matrimonio / unione civile - rettifica
select nvl(data_div_prec,data_div_ann_prec), matricola, 99, nvl(data_div_prec,data_div_ann_prec),
	 stato_civile_prec, sesso_prec, cognome_nome_cn_prec, matricola_cn_prec,
	 data_mat_prec, cod_pro_mat_prec, cod_com_mat_prec,
	 cod_pro_atto_mat_prec, cod_com_atto_mat_prec,
	 data_ved_prec, cod_pro_ved_prec, cod_com_ved_prec,
	 cod_pro_atto_ved_prec, cod_com_atto_ved_prec,
 	 nvl(data_div_prec,data_div_ann_prec), cod_pro_div_prec, cod_com_div_prec,
	 cod_pro_atto_div_prec, cod_com_atto_div_prec,
	 atto_mat_prec, parte_mat_prec, serie_mat_prec, ufficio_mat_prec,
	 anno_atto_mat_prec, atto_mat_digitale_prec,
	 atto_mat_tr_prec, parte_mat_tr_prec, serie_mat_tr_prec,
	 ufficio_mat_tr_prec, anno_atto_mat_tr_prec, atto_mat_tr_digitale_prec,
	 atto_ved_prec, parte_ved_prec, serie_ved_prec, ufficio_ved_prec,
  	 anno_atto_ved_prec, atto_ved_digitale_prec,
	 atto_div_prec, parte_div_prec, serie_div_prec, ufficio_div_prec,
	 anno_atto_div_prec, atto_div_digitale_prec,
	 'MOV_PREC', 
--	  'Cessazione'
         f_ESC_descrizione_evento(matricola,stato_civile_prec,data_div_prec,data_div_ann_prec)
  from anamov a
 where cod_mov 		 in (97,98)
   and cod_eve 		 in (93,99)
   and stato_civile 	 not in ('DV','GC','GU')
   and stato_civile_prec in ('DV','GC','GU')
   and nvl(data_div_prec,data_div_ann_prec) is not null
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	= a.stato_civile_prec
	   		    and nvl(c.data_div,c.data_div_ann) = nvl(a.data_div_prec,a.data_div_ann_prec)
			    and c.matricola	= a.matricola)
-- ANA
   and not exists (select 'x'
 	 		   from anaana ana
			  where ana.matricola 		= a.matricola
			    and ana.stato_civile 	= a.stato_civile_prec
			    and nvl(ana.data_div,ana.data_div_ann) = nvl(a.data_div_prec,a.data_div_ann_prec))
UNION
-- ANAMOV: matrimonio / unione civile da movimento di rettifica di stesso stato civile
select data_reg, matricola,
	 decode(cod_eve, 99,
	   decode(stato_civile, 'CN', 93, 'VE', 94, 'UC', 93, 'VU', 94, 99)),
	 decode(cod_eve, 93, data_mat, 94, data_ved, 99,
	   decode(stato_civile, 'CN', data_mat, 'VE', data_ved, 'UC', data_mat, 'VU', data_ved, nvl(data_div,data_div_ann))),
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
 	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved,ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div,ufficio_div, anno_atto_div, atto_div_digitale,
	 'MOV_R', 
--	   decode(stato_civile,'CN','Matrimonio','UC','Unione Civile')
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where data_mat_prec		!= data_mat
   and stato_civile_prec   	= stato_civile
   and cod_mov			in (97,98)
   and cod_eve			in (97,99)
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 	 = a.matricola
--			    and ana.stato_civile in ('CN','UC')
			    and ana.cognome_nome_cn = a.cognome_nome_cn)
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	in ('CN','UC')
	   		    and c.data_mat	= a.data_mat
			    and c.matricola	= a.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
			  where d.cod_mov 		in (97,98)
   			    and d.cod_eve 		in (94,99)
			    and d.stato_civile 		!= d.stato_civile_prec
   			    and d.stato_civile_prec 	in ('CN','UC')
		          and d.data_mat_prec	 	= a.data_mat
			    and d.matricola		= a.matricola)
UNION
-- ANAMOV: vedovanza da movimento di rettifica di stesso stato civile
select data_reg, matricola,
	 decode(cod_eve, 99,
	   decode(stato_civile, 'CN', 93, 'VE', 94, 'UC', 93, 'VU', 94, 99)),
	 decode(cod_eve, 93, data_mat, 94, data_ved, 99,
	   decode(stato_civile, 'CN', data_mat, 'VE', data_ved, 'UC', data_mat, 'VU', data_ved, nvl(data_div,data_div_ann))),
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
 	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved,ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div,ufficio_div, anno_atto_div, atto_div_digitale,
	 'MOV_R', 
--	  decode(stato_civile,'VE','Vedovanza','VU','Vedovanza da U.C.')
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where data_ved_prec		!= data_ved
   and stato_civile_prec   	= stato_civile
   and cod_mov			in (97,98)
   and cod_eve			in (97,99)
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 	 = a.matricola
			    and ana.stato_civile in ('VE','VU')
			    and ana.data_ved	 = a.data_ved)
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	in ('VE','VU')
	   		    and c.data_ved	= a.data_ved
			    and c.matricola	= a.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
			  where d.cod_mov 		in (97,98)
   			    and d.cod_eve 		in (93,99)
   			    and d.stato_civile 	 	!= d.stato_civile_prec
   			    and d.stato_civile_prec 	in ('VE','VU')
   			    and d.data_ved_prec	 	= a.data_ved
			    and d.matricola		= a.matricola)
UNION
-- ANAMOV: cessazione da movimento di rettifica di stesso stato civile
select data_reg, matricola,
	 decode(cod_eve, 99,
	   decode(stato_civile, 'CN', 93, 'VE', 94, 'UC', 93, 'VU', 94, 99)),
	 decode(cod_eve, 93, data_mat, 94, data_ved, 99,
	   decode(stato_civile, 'CN', data_mat, 'VE', data_ved, 'UC', data_mat, 'VU', data_ved, nvl(data_div,data_div_ann))),
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
 	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved,ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div,ufficio_div, anno_atto_div, atto_div_digitale,
	 'MOV_R', 
--  	  'Cessazione'
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where nvl(data_div_prec,data_div_ann_prec) != nvl(data_div,data_div_ann)
   and stato_civile_prec   	in ('DV','GC','GU')
   and stato_civile	 	in ('DV','GC','GU')
   and cod_mov			in (97,98)
   and cod_eve			in (99)
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 	 = a.matricola
			    and ana.stato_civile in ('DV','GC','GU')
			    and nvl(ana.data_div,ana.data_div_ann) = nvl(a.data_div,a.data_div_ann))
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	in ('DV','GC','GU')
	   		    and nvl(c.data_div,c.data_div_ann) = nvl(a.data_div,a.data_div_ann)
			    and c.matricola	= a.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
		   	  where d.cod_mov 		in (97,98)
   			    and d.cod_eve 		in (93,99)
   			    and d.stato_civile 	 	not in ('DV','GC','GU')
   			    and d.stato_civile_prec 	in ('DV','GC','GU')
   			    and nvl(d.data_div_prec,d.data_div_ann_prec) = nvl(a.data_div,a.data_div_ann)
			    and d.matricola		= a.matricola)
UNION
-- ANAMOV: matrimonio / unione civile da movimento specifico (se non esistono altre origini)
select data_reg, matricola, cod_eve,
	 decode(cod_eve, 93, data_mat, 94, data_ved, 99, nvl(data_div,data_div_ann)),
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
 	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved,ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div,ufficio_div, anno_atto_div, atto_div_digitale,
	 'MOV', 
--	  decode(stato_civile,'CN','Matrimonio','UC','Unione Civile')
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where cod_mov  in (97,98)
   and cod_eve  = 93
-- MOV_R
   and not exists (select 'x'
			   from anamov b
			  where b.data_mat_prec		!= b.data_mat
			    and b.data_mat_prec		= a.data_mat
			    and b.stato_civile_prec   = b.stato_civile
			    and b.stato_civile_prec 	= a.stato_civile
			    and b.matricola 		= a.matricola
			    and b.cod_mov			in (97,98)
			    and b.cod_eve			in (97,99))
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 	 = a.matricola
			    and ana.stato_civile in ('CN','UC')
			    and ana.data_mat	 = a.data_mat)
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	in ('CN','UC')
	   		    and c.data_mat	= a.data_mat
			    and c.matricola	= a.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
			  where d.cod_mov 			  in (97,98)
   			    and d.cod_eve 			  in (93,94,99)
			    and d.stato_civile 			  != d.stato_civile_prec
   			    and d.stato_civile_prec 		  in ('CN','UC')
		          and nvl(d.data_mat_prec,data_mat) = a.data_mat
			    and d.matricola			  = a.matricola)
UNION
-- ANAMOV: vedovanza da movimento specifico (se non esistono altre origini)
select data_reg, matricola, cod_eve,
	 decode(cod_eve, 93, data_mat, 94, data_ved, 99, nvl(data_div,data_div_ann)),
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
 	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved,ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div,ufficio_div, anno_atto_div, atto_div_digitale,
	 'MOV', 
-- 	  decode(stato_civile,'VE','Vedovanza','VU','Vedovanza da U.C.')
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where cod_mov  in (97,98)
   and cod_eve  = 94
-- MOV_R
   and not exists (select 'x'
			   from anamov b
			  where b.data_ved_prec		!= b.data_ved
			    and b.data_ved_prec		= a.data_ved
			    and b.stato_civile_prec   = b.stato_civile
			    and b.stato_civile_prec 	= a.stato_civile
			    and b.matricola 		= a.matricola
			    and b.cod_mov			in (97,98)
			    and b.cod_eve			in (97,99))
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 	 = a.matricola
			    and ana.stato_civile in ('VE','VU')
			    and ana.data_ved	 = a.data_ved)
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	in ('VE','VU')
	   		    and c.data_ved	= a.data_ved
			    and c.matricola	= a.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
			  where d.cod_mov 		in (97,98)
   			    and d.cod_eve 		in (93,99)
   			    and d.stato_civile 	 	!= d.stato_civile_prec
   			    and d.stato_civile_prec 	in ('VE','VU')
   			    and d.data_ved_prec	 	= a.data_ved
			    and d.matricola		= a.matricola)
UNION
-- ANAMOV: cessazione da movimento specifico (se non esistono altre origini)
select data_reg, matricola, cod_eve,
	 decode(cod_eve, 93, data_mat, 94, data_ved, 99, nvl(data_div,data_div_ann)),
	 stato_civile, sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
 	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved,ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div,ufficio_div, anno_atto_div, atto_div_digitale,
	 'MOV', 
--	  'Cessazione'
         f_ESC_descrizione_evento(matricola,stato_civile,data_div,data_div_ann)
  from anamov a
 where cod_mov  		in (97,98)
   and cod_eve  		= 99
   and stato_civile 		in ('DV','GC','GU')
   and stato_civile_prec 	in ('CN','UC')
   and nvl(data_div,data_div_ann) is not null
-- MOV_R
   and not exists (select 'x'
			   from anamov b
			  where nvl(b.data_div_prec,b.data_div_ann_prec) != nvl(b.data_div,b.data_div_ann)
			    and nvl(b.data_div_prec,b.data_div_ann_prec) = nvl(a.data_div,a.data_div_ann)
			    and b.stato_civile_prec   	in ('DV','GC','GU')
			    and b.stato_civile		in ('DV','GC','GU')
			    and b.matricola 		= a.matricola
			    and b.cod_mov		in (97,98)
			    and b.cod_eve		in (99))
-- ANA
   and not exists (select 'x'
			   from anaana ana
			  where ana.matricola 	 = a.matricola
			    and ana.stato_civile in ('DV','GC','GU')
			    and nvl(ana.data_div,ana.data_div_ann) = nvl(a.data_div,a.data_div_ann))
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	in ('DV','GC','GU')
	   		    and nvl(c.data_div,c.data_div_ann) = nvl(a.data_div,a.data_div_ann)
			    and c.matricola	= a.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
		   	  where d.cod_mov 		in (97,98)
   			    and d.cod_eve 		in (93,99)
   			    and d.stato_civile 	 	not in ('DV','GC','GU')
   			    and d.stato_civile_prec 	in ('DV','GC','GU')
   			    and nvl(d.data_div_prec,d.data_div_ann_prec) = nvl(a.data_div,a.data_div_ann)
			    and d.matricola		= a.matricola)
UNION
-- ANAANA: matrimonio se non esiste ANAMOV
select data_mat, matricola, 93, data_mat,
	 'CN', sesso, cognome_nome_cn, matricola_cn,
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale,
         atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale,
	 'ANA_no_MOV', 
--	  'Matrimonio'
         f_ESC_descrizione_evento(matricola,'CN','','')
  from anaana
 where data_mat 	is not null
   and stato_civile	not in ('CN','UC')
-- MOV_R
   and not exists (select 'x'
			   from anamov b
			  where b.data_mat_prec		!= b.data_mat
			    and b.data_mat		= anaana.data_mat
			    and b.stato_civile_prec   = b.stato_civile
			    and b.stato_civile_prec 	= anaana.stato_civile
			    and b.matricola 		= anaana.matricola
			    and b.cod_mov			in (97,98)
			    and b.cod_eve			in (97,99))
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	in ('CN','UC')
	   		    and c.data_mat	= anaana.data_mat
			    and c.matricola	= anaana.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
			  where d.cod_mov 			  in (97,98)
   			    and d.cod_eve 			  in (93,94,99)
			    and d.stato_civile 			  != d.stato_civile_prec
   			    and d.stato_civile_prec 		  in ('CN','UC')
		          and nvl(d.data_mat_prec,data_mat) = anaana.data_mat
			    and d.matricola			  = anaana.matricola)
-- MOV
   and not exists (select 'x'
			   from anamov e
 			  where e.cod_mov  	in (97,98)
   			    and e.cod_eve  	= 93
			    and e.data_mat	= anaana.data_mat
			    and e.matricola	= anaana.matricola)
UNION
-- ANAANA: vedovanza se non esiste ANAMOV
select data_ved, matricola, 94, data_ved,
	 'VE', sesso,
	 decode(sign(data_ved - data_mat),
	   -1, to_char(null), cognome_nome_cn),
	 decode(sign(data_ved - data_mat),
	   -1, to_number(null), matricola_cn),
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale,
	 'ANA_no_MOV', 
--	  'Vedovanza'
         f_ESC_descrizione_evento(matricola,'VE','','')
  from anaana
 where data_ved 	is not null
   and stato_civile	not in ('VE','VU')
-- MOV_R
   and not exists (select 'x'
			   from anamov b
			  where b.data_ved_prec		!= b.data_ved
			    and b.data_ved		= anaana.data_ved
			    and b.stato_civile_prec   = b.stato_civile
			    and b.stato_civile_prec 	= anaana.stato_civile
			    and b.matricola 		= anaana.matricola
			    and b.cod_mov			in (97,98)
			    and b.cod_eve			in (97,99))
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	IN ('VE','VU')
	   		    and c.data_ved	= anaana.data_ved
			    and c.matricola	= anaana.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
			  where d.cod_mov 		in (97,98)
   			    and d.cod_eve 		in (93,99)
   			    and d.stato_civile 	 	!= d.stato_civile_prec
   			    and d.stato_civile_prec 	IN ('VE','VU')
   			    and d.data_ved_prec	 	= anaana.data_ved
			    and d.matricola		= anaana.matricola)
-- MOV
   and not exists (select 'x'
			   from anamov e
			  where e.cod_mov  	in (97,98)
   			    and e.cod_eve  	= 94
			    and e.data_ved	= anaana.data_ved
			    and e.matricola	= anaana.matricola)
UNION
-- ANAANA: cessazione se non esiste ANAMOV
select nvl(data_div,data_div_ann), matricola, 99, nvl(data_div,data_div_ann),
 	 decode(sign(nvl(data_div,data_div_ann) - data_mat),
	   -1, 'GC', stato_civile), sesso,
	 decode(sign(nvl(data_div,data_div_ann) - data_mat),
	   -1, to_char(null), cognome_nome_cn),
	 decode(sign(nvl(data_div,data_div_ann) - data_mat),
	   -1, to_number(null), matricola_cn),
	 data_mat, cod_pro_mat, cod_com_mat,
	 cod_pro_atto_mat, cod_com_atto_mat,
	 data_ved, cod_pro_ved, cod_com_ved,
	 cod_pro_atto_ved, cod_com_atto_ved,
	 nvl(data_div,data_div_ann), cod_pro_div, cod_com_div,
	 cod_pro_atto_div, cod_com_atto_div,
	 atto_mat, parte_mat, serie_mat, ufficio_mat, anno_atto_mat, atto_mat_digitale,
	 atto_mat_tr, parte_mat_tr, serie_mat_tr, ufficio_mat_tr, anno_atto_mat_tr, atto_mat_tr_digitale,
	 atto_ved, parte_ved, serie_ved, ufficio_ved, anno_atto_ved, atto_ved_digitale,
	 atto_div, parte_div, serie_div, ufficio_div, anno_atto_div, atto_div_digitale,
	 'ANA_no_MOV', 
--	  'Cessazione'
         f_ESC_descrizione_evento(matricola,'GC',data_div,data_div_ann)
  from anaana
 where nvl(data_div,data_div_ann) is not null
   and stato_civile	not in ('DV','GC','GU')
-- MOV_R
   and not exists (select 'x'
			   from anamov b
			  where nvl(b.data_div_prec,b.data_div_ann_prec) != nvl(b.data_div,b.data_div_ann)
			    and nvl(b.data_div,b.data_div_ann) 		 = nvl(anaana.data_div,anaana.data_div_ann)
			    and b.stato_civile_prec   in ('DV','GC','GU')
			    and b.stato_civile		in ('DV','GC','GU')
			    and b.matricola 		= anaana.matricola
			    and b.cod_mov			in (97,98)
			    and b.cod_eve			in (99))
-- MOV_C
   and not exists (select 'x'
			   from anamov c
  	 	  	  where c.cod_mov 	in (2,4)
   			    and c.cod_eve 	!= 50
   			    and c.stato_civile 	in ('DV','GC','GU')
	   		    and nvl(c.data_div,c.data_div_ann) = nvl(anaana.data_div,anaana.data_div_ann)
			    and c.matricola	= anaana.matricola)
-- MOV_PREC
   and not exists (select 'x'
			   from anamov d
		   	  where d.cod_mov 		in (97,98)
   			    and d.cod_eve 		in (93,99)
   			    and d.stato_civile 	 	not in ('DV','GC','GU')
   			    and d.stato_civile_prec 	in ('DV','GC','GU')
   			    and nvl(d.data_div_prec,d.data_div_ann_prec) = nvl(anaana.data_div,anaana.data_div_ann)
			    and d.matricola		= anaana.matricola)
-- MOV
   and not exists (select 'x'
			   from anamov e
			  where e.cod_mov  		in (97,98)
			    and e.cod_eve  		= 99
			    and e.stato_civile 		in ('DV','GC','GU')
			    and e.stato_civile_prec 	in ('CN','UC')
			    and nvl(e.data_div,e.data_div_ann) = nvl(anaana.data_div,anaana.data_div_ann)
			    and e.matricola		= anaana.matricola)
/
comment on table anaesc is 'Anagrafe - Eventi di Stato Civie (view)'
/

