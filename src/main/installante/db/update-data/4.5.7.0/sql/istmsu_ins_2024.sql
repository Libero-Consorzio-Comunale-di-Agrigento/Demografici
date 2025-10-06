--liquibase formatted sql
--changeset snocca:202402091200 runOnChange:true stripComments:false
DECLARE

w_nazionalita_ita_m	number(1);
w_data_inizio_naz_m	number(8);
w_data_nazionalita_m	number(8);
w_nazionalita_ita_f	number(1);
w_data_inizio_naz_f	number(8);
w_data_nazionalita_f	varchar2(8);

w_ufficio_uci		number;
w_anno_uci		number;
w_atto_uci		number;
w_parte_uci		number;
w_serie_uci		varchar2(1);
w_cod_pro_uci		number(3);
w_cod_com_uci		number(3);
w_data_uci		number(8);
w_convenzioni_uci	number(1);

CURSOR sel_scio IS
select uci.*, cta.cod_modello_istat
  from civuci uci, civcta cta, civdta dta
 where uci.anno = 2024
   and uci.cod_rec in (0,3)
   and uci.id_civdta = dta.id
   and dta.id_civcta = cta.id
   and cta.tipo_Atto = -4
   and cta.sigla in ('UCO', 'AVV')
;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

BEGIN

  if nvl(w_integrazione_istat,'N') = 'S' then
	  FOR rec IN sel_scio LOOP
		  BEGIN
			DBMS_OUTPUT.PUT_LINE('recupero dati nazionalità');
			if nvl(rec.nazionalita_m,' ') = 'I' then
			   w_nazionalita_ita_m := 1;
			elsif nvl(rec.nazionalita_m,'I') != 'I' then
			   w_nazionalita_ita_m := 3;
			end if;
			if nvl(rec.nazionalita_f,' ') = 'I' then
			   w_nazionalita_ita_f := 1;
			elsif nvl(rec.nazionalita_f,'I') != 'I' then
			   w_nazionalita_ita_f := 3;
			end if;

			begin
			  select decode(ana.fascia,1,decode(ana.nazionalita,'I',ana.data_inizio_naz))
				INTO w_data_inizio_naz_m
				from anaana ana, civana civ
			   where ana.matricola   = civ.matricola_1
				 and civ.id_atto     = rec.id_atto
			  ;
			  if w_nazionalita_ita_m = 1 then
				 w_data_nazionalita_m := w_data_inizio_naz_m;
			  end if;
			exception
			  when others then
				   w_data_nazionalita_m := '';
			end;

			begin
			  select decode(ana.fascia,1,decode(ana.nazionalita,'I',ana.data_inizio_naz))
				INTO w_data_inizio_naz_f
				from anaana ana, civana civ
			   where ana.matricola   = civ.matricola_2
				 and civ.id_atto     = rec.id_atto
			  ;
			  if w_nazionalita_ita_f = 1 then
				 w_data_nazionalita_f := w_data_inizio_naz_f;
			  end if;
			exception
			  when others then
				   w_data_nazionalita_f := '';
			end;

			DBMS_OUTPUT.PUT_LINE('recupero dati unione civile');
			begin
			  select uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie,
					 uci.COD_PRO_MAT, uci.cod_com_mat, uci.data_mat,
					 decode(uci.convenzioni,'SI',2,1)
				INTO w_UFFICIO_uci, w_ANNO_uci, w_ATTO_uci, w_PARTE_uci, w_SERIE_uci,
					 w_cod_pro_uci, w_cod_com_uci, w_data_uci,
					 w_convenzioni_uci
				from civuci uci
			   where cognome_nome_f    = rec.cognome_nome_f
				 and data_nas_f = rec.data_nas_f
				 and cognome_nome_m    = rec.cognome_nome_m
				 and data_nas_m = rec.data_nas_m
				 and natura            = 'O'
			  ;
			exception
			  when others then
				   w_atto_uci    := '';
				   w_parte_uci   := '';
				   w_serie_uci   := '';
				   w_ufficio_uci := '';
				   w_anno_uci    := '';
				   w_cod_pro_uci := '';
				   w_Cod_Com_uci := '';
				   w_data_uci    := '';
				   w_convenzioni_uci := '';
			end;

			insert into istmsu
				  (ufficio, anno, atto, parte, serie,
				   cod_modello, progr_questionario, tipo_accordo,
				   ufficio_uci, anno_uci, atto_uci, parte_uci, serie_uci,
				   cod_pro_uci, cod_com_uci, data_uci, regime_patrimoniale_uci,
				   cod_fiscale_1, nazionalita_ita_1, data_nazionalita_1, cod_pro_res_1, cod_com_res_1,
				   cod_fiscale_2, nazionalita_ita_2, data_nazionalita_2, cod_pro_res_2, cod_com_res_2)
			select rec.ufficio, rec.anno, rec.atto, rec.parte, rec.serie,
				   rec.cod_modello_istat, to_number(null), 3,
				   w_ufficio_uci, w_anno_uci, w_atto_uci, w_parte_uci, w_serie_uci,
				   w_cod_pro_uci, w_cod_com_uci, w_data_uci, w_convenzioni_uci,
				   rec.cod_fiscale_m, w_nazionalita_ita_m, w_data_nazionalita_m, rec.cod_pro_res_m, rec.cod_com_res_m,
				   rec.cod_fiscale_f, w_nazionalita_ita_f, w_data_nazionalita_f, rec.cod_pro_res_f, rec.cod_com_res_f
			  from dual
			 where not exists (select 'x' from istmsu b
								where b.id_atto = rec.id_atto)
			;
			if sql%found then
			   DBMS_OUTPUT.PUT_LINE('effettuato inserimento');
			   ISTAT_PKG.ins_log('istamsu_ins_2024','istmsu - insert');
			end if;
		  END;
	  END LOOP;
  end if;
    
EXCEPTION
    WHEN others THEN
        null;
    
END;
/