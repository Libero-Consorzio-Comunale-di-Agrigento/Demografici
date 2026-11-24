--liquibase formatted sql
--changeset amonopoli:202410091525 runOnChange:true stripComments:false
create or replace view ceresc 
AS
select esc.des_cod_eve||': '||
       esc.cognome_nome_cn||
       decode(esc.cod_eve,
	  93,' il '||to_char(to_date(esc.data_mat,'j'),'dd/mm/yyyy')||
               ' a '||m.descrizione||' ('||m.sigla_provincia||')',
	  94,' il '||to_char(to_date(esc.data_ved,'j'),'dd/mm/yyyy')||
               ' a '||v.descrizione||' ('||v.sigla_provincia||')',
	  99,' il '||to_char(to_date(esc.data_div,'j'),'dd/mm/yyyy')||
               ' a '||d.descrizione||' ('||d.sigla_provincia||')') dati_esc,
-- riga_evento_stato_civile_atto
	decode(esc.cod_eve,
	 93,decode(esc.atto_mat_digitale,'',
              decode(esc.atto_mat,'','',
		'Atto N. '||esc.atto_mat||
		decode(esc.parte_mat,'','',1,' p. I',2,' p. II', ' p. '||esc.parte_mat)||
		decode(esc.serie_mat,'','',' s. '||esc.serie_mat)||
		decode(esc.ufficio_mat,'','',' uff. '||esc.ufficio_mat)||
		decode(esc.anno_atto_mat,'','',' / '||esc.anno_atto_mat)||
		decode(am.descrizione,'','',m.descrizione,'',' - '||am.descrizione||' ('||am.sigla_provincia||')')),
              'Atto digitale N. '||esc.atto_mat_digitale||
		decode(am.descrizione,'','',m.descrizione,'',' - '||am.descrizione||' ('||am.sigla_provincia||')')),
	 94,decode(esc.atto_ved_digitale,'',
              decode(esc.atto_ved,'','',
		'Atto N. '||esc.atto_ved||
		decode(esc.parte_ved,'','',1,' p. I',2,' p. II', ' p. '||esc.parte_ved)||
		decode(esc.serie_ved,'','',' s. '||esc.serie_ved)||
		decode(esc.ufficio_ved,'','',' uff. '||esc.ufficio_ved)||
		decode(esc.anno_atto_ved,'','',' / '||esc.anno_atto_ved)||
		decode(av.descrizione,'','',v.descrizione,'',' - '||av.descrizione||' ('||av.sigla_provincia||')')),
              'Atto digitale N. '||esc.atto_ved_digitale||
		decode(av.descrizione,'','',v.descrizione,'',' - '||av.descrizione||' ('||av.sigla_provincia||')')),
	 99,decode(esc.atto_div_digitale,'',
              decode(esc.atto_div,'','',
		'Atto N. '||esc.atto_div||
		decode(esc.parte_div,'','',1,' p. I',2,' p. II', ' p. '||esc.parte_div)||
		decode(esc.serie_div,'','',' s. '||esc.serie_div)||
		decode(esc.ufficio_div,'','',' uff. '||esc.ufficio_div)||
		decode(esc.anno_atto_div,'','',' / '||esc.anno_atto_div)||
		decode(ad.descrizione,'','',d.descrizione,'',' - '||ad.descrizione||' ('||ad.sigla_provincia||')')),
              'Atto digitale N. '||esc.atto_ved_digitale||
		decode(ad.descrizione,'','',d.descrizione,'',' - '||ad.descrizione||' ('||ad.sigla_provincia||')'))) dati_esc_atto,
	to_char(to_date(esc.data_reg,'j'),'dd/mm/yyyy') data_reg,
	data_eve ord1,
	esc.matricola matricola
  from arccom m, arccom v, arccom d, arccom am, arccom av, arccom ad, anaesc esc
 where m.cod_provincia	(+)	= esc.cod_pro_mat
   and m.cod_comune	(+)	= esc.cod_com_mat
   and am.cod_provincia	(+)	= esc.cod_pro_atto_mat
   and am.cod_comune	(+)	= esc.cod_com_atto_mat
   and v.cod_provincia	(+)	= esc.cod_pro_ved
   and v.cod_comune	(+)	= esc.cod_com_ved
   and av.cod_provincia	(+)	= esc.cod_pro_atto_ved
   and av.cod_comune	(+)	= esc.cod_com_atto_ved
   and d.cod_provincia	(+)	= esc.cod_pro_div
   and d.cod_comune	(+)	= esc.cod_com_div
   and ad.cod_provincia	(+)	= esc.cod_pro_atto_div
   and ad.cod_comune	(+)	= esc.cod_com_atto_div
UNION
select tse.descrizione||' - Data Provvedimento '||to_char(to_date(sen.data_decreto,'j'),'dd/mm/yyyy') dati_esc,
       decode(sen.atto_tr_digitale,'',
         decode(sen.atto_tr,'','',
           'Atto N. '||sen.atto_tr||
		decode(sen.parte_atto_tr,'','',1,' p. I',2,' p. II', ' p. '||sen.parte_atto_tr)||
		decode(sen.serie_atto_tr,'','',' s. '||sen.serie_atto_tr)||
		decode(sen.ufficio_atto_tr,'','',' uff. '||sen.ufficio_atto_tr)||
		decode(sen.anno_atto_tr,'','',' / '||sen.anno_atto_tr)||
		decode(a.descrizione,'','',' - '||a.descrizione||' ('||a.sigla_provincia||')')),
           'Atto digitale N. '||sen.atto_tr_digitale||
		decode(a.descrizione,'','',' - '||a.descrizione||' ('||a.sigla_provincia||')')) dati_esc_atto,
	to_char(to_date(mov.data_reg,'j'),'dd/mm/yyyy') data_reg,
	data_decreto,
	sen.matricola
  from arccom a, anatse tse,anasen sen, anaana ana, anamov mov
 where a.cod_provincia	(+)  	= sen.cod_pro_atto_tr
   and a.cod_comune	(+)	= sen.cod_com_atto_tr
   and tse.cod_se 		= sen.tipo_sentenza
   and tse.flag_cer 		= 'S'
   and sen.privacy 		is null
   and ana.matricola 		= sen.matricola
   and mov.matricola 		= sen.matricola
   and mov.anno_progr 		= sen.anno_progr_mov
   and mov.numero_progr 	= sen.numero_progr_mov
/
comment on table ceresc is 'Certificazione - Eventi di Stato Civile (view)'
/
