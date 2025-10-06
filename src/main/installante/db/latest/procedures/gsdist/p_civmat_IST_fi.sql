--liquibase formatted sql
--changeset amonopoli:202303071315 runOnChange:true stripComments:false
create or replace procedure CIVMAT_IST_FI
(a_cod_rec		IN 	number,
 a_natura		IN	varchar2,
 a_ufficio		IN	number,
 a_anno			IN	number,
 a_atto			IN	number,
 a_parte		IN	number,
 a_serie		IN	varchar2,
 a_cod_pro_mat		IN 	number,
 a_cod_com_mat		IN	number,
 a_cognome_nome_m	IN	varchar2,
 a_data_nas_m		IN	number,
 a_cod_pro_res_m	IN	number,
 a_cod_com_res_m	IN	number,
 a_nazionalita_m	IN	varchar2,
 a_cod_fiscale_m	IN	varchar2,
 a_cognome_nome_f	IN	varchar2,
 a_data_nas_f		IN	number,
 a_cod_pro_res_f	IN	number,
 a_cod_com_res_f	IN	number,
 a_nazionalita_f	IN	varchar2,
 a_cod_fiscale_f	IN	varchar2,
 a_atto_old		IN	number,
 a_id_civdta		IN	number,
 a_id_atto		IN	varchar2,
 a_tipo_divorzio_dpa	IN	varchar2,
 a_cod_pro_mat_old	IN	number,
 a_cod_com_mat_old	IN	number
)
IS
-- dati x i modelli statistici di matrimonio
  w_matrimonio		number;
  w_ufficio_pub		number;
  w_anno_pub		number;
  w_atto_pub		number;
  w_parte_pub		number;
  w_serie_pub		varchar2(1);
  w_esiste_pub		number := 0;
  w_stato_civile_m	varchar2(2);
  w_data_fine_mat_m	number;
  w_stato_civile_f	varchar2(2);
  w_data_fine_mat_f	number;

-- dati x i modelli statistici di divorzi / separazioni
  w_tipo_divorzio	varchar2(255);

  w_cod_modello		varchar2(255);
  w_progr_questionario	number(8);
  w_tipo_accordo	number(1);	

  w_ufficio_mat		number;
  w_anno_mat		number;
  w_atto_mat		number;
  w_parte_mat		number;
  w_serie_mat		varchar2(1);
  w_cod_pro_mat		number(3);
  w_cod_com_mat		number(3);
  w_data_mat		number(8);
  w_rito_mat		number(1);
  w_convenzioni_mat	number(1);

  w_cod_fiscale_m 	varchar2(16) := a_cod_fiscale_m;
  w_indirizzo_res_m	varchar2(255);
  w_civico_res_m	varchar2(5);
  w_cap_res_m		varchar2(5);
  w_data_inizio_naz_m	number(8);
  w_nazionalita_ita_m	number(1);
  w_data_nazionalita_m	number(8);
  w_titolo_studio_m	varchar2(1);
  w_cod_fiscale_f	varchar2(16) := a_cod_fiscale_f;
  w_indirizzo_res_f	varchar2(255);
  w_civico_res_f	varchar2(5);
  w_cap_res_f		varchar2(5);
  w_data_inizio_naz_f	number(8);
  w_nazionalita_ita_f	number(1);
  w_data_nazionalita_f	varchar2(8);
  w_titolo_studio_f	varchar2(1);

  w_cognome_avv_m	varchar2(255);
  w_nome_avv_m		varchar2(255);
  w_cognome_avv_f 	varchar2(255);
  w_nome_avv_f		varchar2(255);
begin
--
-- l'inserimento del matrimonio in CIVMAT aggiorna i dati di ISTMD3, 
-- inserendo i riferimenti all'atto di matrimonio.
-- Se non si trova un verbale di pubblicazione corrispondente
-- si inserisce il record in ISTMD3
--
-- 30/09/2015 (AM): se il record di CIVMAT appena inserito e' relativo ad un divorzio (nuova gestione) viene inserito il record in ISTMSC
-- 25/11/2015 (AM): if DELETING
-- 08/01/2024 (AM): controllo modifica tipo_divorzio da civdpa
-- 18/01/2024 (AM): gestito UPDATE di comune matrimonio
--

  if a_id_civdta is not null and a_natura = 'D' then
     if a_tipo_divorzio_dpa is not null then
        w_tipo_divorzio := a_tipo_divorzio_dpa;
     else
        begin
          select tipo_divorzio
            into w_tipo_divorzio
            from civdpa
           where id_atto = a_id_atto
             and rownum = 1
          ;
         exception
           when others then
                w_tipo_divorzio := '';
         end;
      end if;
  end if;
  ISTAT_PKG.ins_log('civmat_ist_fi','w_tipo_divorzio: '||w_tipo_divorzio);

  if UPDATING then
     if a_atto_old < 0 and a_atto > 0 then
        begin
          update istmd3
             set atto_mat = a_atto
           where ufficio_mat        = a_ufficio
             and anno_mat           = a_anno
             and parte_mat          = a_parte
             and nvl(serie_mat,' ') = nvl(a_serie,' ')
             and atto_mat           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmat_ist_fi','istmd3 - update');
          end if;
        end;
        begin
          update istmsc
             set atto = a_atto
           where ufficio        = a_ufficio
             and anno           = a_anno
             and parte          = a_parte
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmat_ist_fi','istmsc - update');
          end if;
        end;
     end if;

     if a_tipo_divorzio_dpa is not null and nvl(w_tipo_divorzio,' ') = 'A' and a_cod_rec = 3 then
        begin
          delete istmsc
           where id_atto = a_id_atto
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmat_ist_fi','istmsc - delete');
          end if;
        end;
     end if;
  end if;

  begin
    select 1 into w_matrimonio
      from menuditta
     where pro_cliente	= a_cod_pro_mat
       and com_cliente	= a_cod_com_mat
       and rownum	= 1
    ;
  exception
    when no_data_found then w_matrimonio := 0;
    when others then w_matrimonio := 0;
  end;

  if INSERTING or (UPDATING and nvl(a_cod_pro_mat_old||a_cod_com_mat_old,0) != nvl(a_cod_pro_mat||a_cod_com_mat,0)) then

   if w_matrimonio = 1 and a_natura ='O' and a_cod_rec = 3 then
--
-- Gestione Modello D.3 - Matrimonio
--
     begin
       select pub.ufficio, pub.anno, pub.atto, pub.parte, pub.serie
 	 into w_ufficio_pub, w_anno_pub, w_atto_pub, w_parte_pub, w_serie_pub
	 from civpub pub
	where pub.cognome_nome_m	= a_cognome_nome_m
	  and pub.data_nas_m		= a_data_nas_m
  	  and pub.cognome_nome_f	= a_cognome_nome_f
	  and pub.data_nas_f		= a_data_nas_f
       ;
       w_esiste_pub := 1;
     exception
       when no_data_found then w_esiste_pub := 0;
       when others then null;
     end;

     if w_esiste_pub = 1 then
        begin
          update istmd3
 	     set ufficio_mat	= a_ufficio,
   	         anno_mat	= a_anno,
	         atto_mat	= a_atto,
	         parte_mat	= a_parte,
	         serie_mat	= a_serie
	   where ufficio_pub	= w_ufficio_pub
	     and anno_pub	= w_anno_pub
	     and atto_pub	= w_atto_pub
	     and parte_pub	= w_parte_pub
	     and nvl(serie_pub,' ') = nvl(w_serie_pub,' ')
	  ;
	  if SQL%notfound THEN
	      begin
	  	select  ana_m.stato_civile, 
			decode(ana_m.stato_civile,
			  'VE',ana_m.data_ved,
			  'VU',ana_m.data_ved,
			  'DV',nvl(ana_m.data_div_ann,ana_m.data_div),
			  'GC',nvl(ana_m.data_div_ann,ana_m.data_div),
			  'GU',nvl(ana_m.data_div_ann,ana_m.data_div)),
		        ana_f.stato_civile, 
			decode(ana_f.stato_civile,
			  'VE',ana_f.data_ved,
			  'VU',ana_f.data_ved,
			  'DV',nvl(ana_f.data_div_ann,ana_f.data_div),
			  'GC',nvl(ana_f.data_div_ann,ana_f.data_div),
			  'GU',nvl(ana_f.data_div_ann,ana_f.data_div))
	          into w_stato_civile_m, w_data_fine_mat_m,
	               w_stato_civile_f, w_data_fine_mat_f
	          from anaana ana_m, anaana ana_f, civana ana
	   	 where ana_m.matricola (+)	= ana.matricola_1
  	     	   and ana_f.matricola (+)	= ana.matricola_2
  	     	   and ana.tipo_atto		= 4
	     	   and ana.ufficio		= a_ufficio
	     	   and ana.anno	 	= a_anno
	     	   and ana.atto		= a_atto
	           and ana.parte		= a_parte	
  	     	   and nvl(ana.serie,' ')	= nvl(a_serie,' ')
	  	;
	      exception
	  	when no_data_found then null;
  	  	when others then null;
	      end;

	      begin
	  	insert into istmd3
		  	(ufficio_mat, anno_mat, atto_mat, parte_mat, serie_mat,
 		  	ufficio_pub, anno_pub, atto_pub, parte_pub, serie_pub,
 		  	stato_civile_m, data_fine_mat_m, grado_istruzione_m,
 		  	condizione_prof_m, posizione_prof_m, attivita_prof_m,
	  	  	cod_pro_res_post_m, cod_com_res_post_m,
 		 	stato_civile_f, data_fine_mat_f, grado_istruzione_f,
		  	condizione_prof_f, posizione_prof_f, attivita_prof_f,
		  	cod_pro_res_post_f, cod_com_res_post_f)
	  	select a_ufficio, a_anno, a_atto, a_parte, a_serie,
		 	'', '', '', '', '',
		 	w_stato_civile_m, w_data_fine_mat_m, '',
		 	'', '', '',
		 	a_cod_pro_res_m, a_cod_com_res_m,
		 	w_stato_civile_f, w_data_fine_mat_f, '',
	         	'', '', '',
		 	a_cod_pro_res_f, a_cod_com_res_f
	    	  from dual
	         where not exists (select 'x' 
			             from istmd3
			            where ufficio_mat		= a_ufficio
				      and anno_mat		= a_anno
				      and atto_mat		= a_atto
				      and parte_mat		= a_parte
				      and nvl(serie_mat,' ')	= nvl(a_serie,' '))
	 	;
                if sql%found then
                   ISTAT_PKG.ins_log('civmat_ist_fi','istmd3 - insert');
                end if;
	      end;
          end if; 
          update istmd3
 	     set flag_completo	= 'S'
	   where ufficio_mat		= a_ufficio
   	     and anno_mat		= a_anno
	     and atto_mat		= a_atto
	     and parte_mat		= a_parte
	     and nvl(serie_mat,' ')	= nvl(a_serie,' ')
	     and STATO_CIVILE_M		is not null
	     and GRADO_ISTRUZIONE_M	is not null
	     and CONDIZIONE_PROF_M	is not null
	     and POSIZIONE_PROF_M	is not null
	     and ATTIVITA_PROF_M	is not null
	     and COD_PRO_RES_POST_M	is not null
	     and COD_COM_RES_POST_M	is not null
	     and STATO_CIVILE_F		is not null
	     and GRADO_ISTRUZIONE_F	is not null
	     and CONDIZIONE_PROF_F	is not null
	     and POSIZIONE_PROF_F	is not null
	     and ATTIVITA_PROF_F	is not null
	     and COD_PRO_RES_POST_F	is not null
	     and COD_COM_RES_POST_F	is not null
	  ; 
          if sql%found then
             ISTAT_PKG.ins_log('civmat_ist_fi','istmd3 - update');
          end if;
	end;
     else	-- w_esiste_pub = 1
	begin
	  select ana_m.stato_civile, 
		 decode(ana_m.stato_civile,
		   'VE',ana_m.data_ved,
		   'VU',ana_m.data_ved,
		   'DV',nvl(ana_m.data_div_ann,ana_m.data_div),
    	 	   'GC',nvl(ana_m.data_div_ann,ana_m.data_div),
    	 	   'GU',nvl(ana_m.data_div_ann,ana_m.data_div)),
		 ana_f.stato_civile, 
		 decode(ana_f.stato_civile,
		   'VE',ana_f.data_ved,
		   'VU',ana_f.data_ved,
		   'DV',nvl(ana_f.data_div_ann,ana_f.data_div),
		   'GC',nvl(ana_f.data_div_ann,ana_f.data_div),
		   'GU',nvl(ana_f.data_div_ann,ana_f.data_div))
	    into w_stato_civile_m, w_data_fine_mat_m,
	         w_stato_civile_f, w_data_fine_mat_f
	    from anaana ana_m, anaana ana_f, civana ana
	   where ana_m.matricola (+)	= ana.matricola_1
  	     and ana_f.matricola (+)	= ana.matricola_2
  	     and ana.tipo_atto		= 4
	     and ana.ufficio		= a_ufficio
	     and ana.anno	 	= a_anno
	     and ana.atto		= a_atto
	     and ana.parte		= a_parte	
  	     and nvl(ana.serie,' ')	= nvl(a_serie,' ')
	  ;
	exception
	  when no_data_found then null;
  	  when others then null;
	end;

	begin
	  insert into istmd3
		 (ufficio_mat, anno_mat, atto_mat, parte_mat, serie_mat,
 		  ufficio_pub, anno_pub, atto_pub, parte_pub, serie_pub,
 		  stato_civile_m, data_fine_mat_m, grado_istruzione_m,
 		  condizione_prof_m, posizione_prof_m, attivita_prof_m,
	  	  cod_pro_res_post_m, cod_com_res_post_m,
 		  stato_civile_f, data_fine_mat_f, grado_istruzione_f,
		  condizione_prof_f, posizione_prof_f, attivita_prof_f,
		  cod_pro_res_post_f, cod_com_res_post_f)
	  select a_ufficio, a_anno, a_atto, a_parte, a_serie,
		 '', '', '', '', '',
		 w_stato_civile_m, w_data_fine_mat_m, '',
		 '', '', '',
		 a_cod_pro_res_m, a_cod_com_res_m,
		 w_stato_civile_f, w_data_fine_mat_f, '',
	         '', '', '',
		 a_cod_pro_res_f, a_cod_com_res_f
	    from dual
	   where not exists (select 'x' 
			       from istmd3
			      where ufficio_mat		= a_ufficio
				and anno_mat		= a_anno
				and atto_mat		= a_atto
				and parte_mat		= a_parte
				and nvl(serie_mat,' ')	= nvl(a_serie,' '))
	  ;
          if sql%found then
             ISTAT_PKG.ins_log('civmat_ist_fi','istmd3 - insert');
          end if;
	end;
     end if;

   end if;
  end if;

  if INSERTING or (UPDATING and a_tipo_divorzio_dpa is not null and w_tipo_divorzio != 'A') then
  ISTAT_PKG.ins_log('civmat_ist_fi','inserting / updating');

   if a_natura not in ('O','T') and a_cod_rec = 3 then
      if a_id_civdta is not null and w_tipo_divorzio is not null then
         begin
           select cta.cod_modello_istat, decode(w_tipo_divorzio,'X',1,2)
             into w_cod_modello, w_tipo_accordo
             from civcta cta, civdta dta
            where cta.flag_divorzio is not null
              and cta.flag_istat    is not null
              and cta.id            = dta.id_civcta
              and dta.id            = a_id_civdta
              and rownum = 1
              and w_tipo_divorzio   != 'A'
           ;
         exception
           when others then
                w_cod_modello  := '';
                w_tipo_accordo := '';
         end;
      else
         begin
           select cod_modello_ist, tipo_accordo_ist 
             into w_cod_modello, w_tipo_accordo
             from civmat_natura
            where natura   = a_natura
              and flag_ist = 'S'
           ;
         exception
           when others then
                w_cod_modello  := '';
                w_tipo_accordo := '';
         end;
      end if;

      if w_cod_modello is null then
         goto fine;
      end if;

--
-- Gestione Modelli SC.6sd / SC.12sd - Separazione / Divorzio
--
      if nvl(a_nazionalita_m,' ') = 'I' then
         w_nazionalita_ita_m := 1;
      elsif nvl(a_nazionalita_m,'I') != 'I' then
         w_nazionalita_ita_m := 3;
      end if;
      if nvl(a_nazionalita_f,' ') = 'I' then
         w_nazionalita_ita_f := 1;
      elsif nvl(a_nazionalita_f,'I') != 'I' then
         w_nazionalita_ita_f := 3;
      end if;

      begin
        select mat.ufficio, mat.anno, mat.atto, mat.parte, mat.serie,
               mat.COD_PRO_MAT, mat.cod_com_mat, mat.data_mat,
               decode(mat.parte||mat.serie,'2A',1,2),
               decode(mat.convenzioni,'SI',2,1)
          INTO w_UFFICIO_MAT, w_ANNO_MAT, w_ATTO_MAT, w_PARTE_MAT, w_SERIE_MAT,
               w_cod_pro_mat, w_cod_com_mat, w_data_mat, w_rito_mat, 
               w_convenzioni_mat
          from civmat mat
         where cognome_nome_f    = a_cognome_nome_f
           and nvl(data_nas_f,0) = decode(data_nas_f,'',0,a_data_nas_f)
           and cognome_nome_m    = a_cognome_nome_m
           and nvl(data_nas_m,0) = decode(data_nas_m,'',0,a_data_nas_m)
           and natura            = 'O'
           and rownum = 1
        ;
      exception
        when others then
             w_atto_mat    := '';
             w_parte_mat   := '';
             w_serie_mat   := '';
             w_ufficio_mat := '';
             w_anno_mat    := '';
             w_cod_pro_mat := '';
             w_Cod_Com_mat := '';
             w_data_Mat    := '';
             w_rito_mat    := '';
             w_convenzioni_mat := '';
      end;

--titolo_studio 2018
--select '1 - Nessun titolo di studio' descrizione, '1' codice from dual UNION
--select '2 - Licenza elementare e attestatao di valutazione finale', '2' from dual UNION
--select '3 - Licenza media o Diploma di Istruzione secondaria di I grado o Avviamento professionale', '3' from dual UNION
--select '4 - Diploma di istruzione secondaria di II grado, di qualifica professionale (corso di 4-4 anni), di IeFP, di IFTS', '4' from dual UNION
--select '5 - Laurea, Diploma universitario, Diploma accademico, Dottorato di ricerca, Diploma ITS', '5' from dual UNION
--select '9 - Non conosciuto / non fornito', '9' from dual
      begin
        select decode(ana.fascia,1,vie.denom_uff), 
               substr(decode(ana.fascia,1,fam.num_civ||decode(fam.suffisso,'','','/'||fam.suffisso)),1,5),
               decode(ana.fascia,1,f_cap(fam.cod_via, fam.num_civ, fam.suffisso)),
               decode(ana.fascia,1,decode(ana.nazionalita,'I',ana.data_inizio_naz)),
               decode(dts.gruppo, 'LR',5, 'DP',4, 'LM',3, 'LE',2, 9)
          INTO w_indirizzo_res_m, w_civico_res_m, w_cap_res_m,
               w_data_inizio_naz_m, w_titolo_studio_m
          from anadts dts, arcvie vie, anafam fam, anaana ana, civana civ
         where dts.cod_ts  (+) = ana.titolo_studio
           and vie.cod_via (+) = fam.cod_via
           and fam.cod_fam (+) = ana.cod_fam
           and fam.fascia  (+) = ana.fascia
           and ana.matricola   = civ.matricola_1
 	   and civ.tipo_atto   = 4
           and civ.ufficio     = a_ufficio
   	   and civ.anno        = a_anno
           and civ.atto        = a_atto
	   and civ.parte       = a_parte
	   and civ.serie       = a_serie
        ;
        if w_nazionalita_ita_m = 1 then
           w_data_nazionalita_m := w_data_inizio_naz_m;
        end if;
      exception
        when others then
             w_indirizzo_res_m    := '';
             w_civico_res_m       := '';
             w_cap_res_m          := '';
             w_data_nazionalita_m := '';
             w_titolo_studio_m    := '';
      end;

      begin
        select decode(ana.fascia,1,vie.denom_uff), 
               substr(decode(ana.fascia,1,fam.num_civ||decode(fam.suffisso,'','','/'||fam.suffisso)),1,5),
               decode(ana.fascia,1,f_cap(fam.cod_via, fam.num_civ, fam.suffisso)),
               decode(ana.fascia,1,decode(ana.nazionalita,'I',ana.data_inizio_naz)),
               decode(dts.gruppo, 'LR',5, 'DP',4, 'LM',3, 'LE',2, 9)
          INTO w_indirizzo_res_f, w_civico_res_f, w_cap_res_f,
               w_data_inizio_naz_f, w_titolo_studio_f
          from anadts dts, arcvie vie, anafam fam, anaana ana, civana civ
         where dts.cod_ts  (+) = ana.titolo_studio
           and vie.cod_via (+) = fam.cod_via
           and fam.cod_fam (+) = ana.cod_fam
           and fam.fascia  (+) = ana.fascia
           and ana.matricola   = civ.matricola_2
 	   and civ.tipo_atto   = 4
           and civ.ufficio     = a_ufficio
   	   and civ.anno        = a_anno
           and civ.atto        = a_atto
	   and civ.parte       = a_parte
	   and civ.serie       = a_serie
        ;
        if w_nazionalita_ita_f = 1 then
           w_data_nazionalita_f := w_data_inizio_naz_f;
        end if;
      exception
        when others then
             w_indirizzo_res_f    := '';
             w_civico_res_f       := '';
             w_cap_res_f          := '';
             w_data_nazionalita_f := '';
             w_titolo_studio_f    := '';
      end;

      begin
        select substr(dpa.avvocato_sposo, 1, instr(dpa.avvocato_sposo,' ')-1),
               substr(dpa.avvocato_sposo, instr(dpa.avvocato_sposo,' ')+1),
               substr(dpa.avvocato_sposa, 1, instr(dpa.avvocato_sposa,' ')-1),
               substr(dpa.avvocato_sposa, instr(dpa.avvocato_sposa,' ')+1)
          INTO w_cognome_avv_m, w_nome_avv_m, w_cognome_avv_f, w_nome_avv_f
          from civdpa dpa
         where dpa.tipo_atto = 4
           and dpa.ufficio   = a_ufficio
           and dpa.anno      = a_anno
           and dpa.atto      = a_atto
           and dpa.parte     = a_parte
           and dpa.serie     = a_serie
        ;
      exception
        when others then
             w_cognome_avv_m := '';
             w_nome_avv_m    := '';
             w_cognome_avv_f := '';
             w_nome_avv_f    := '';
      end;

      begin
        insert into istmsc
              (ufficio, anno, atto, parte, serie, 
               cod_modello, progr_questionario, tipo_accordo, 
               ufficio_mat, anno_mat, atto_mat, parte_mat, serie_mat, 
               cod_pro_mat, cod_com_mat, data_mat, rito_mat, regime_patrimoniale_mat,
               cod_fiscale_m, indirizzo_res_m, civico_res_m, cap_res_m,
               nazionalita_ita_m, data_nazionalita_m, titolo_studio_m, 
               cod_fiscale_f, indirizzo_res_f, civico_res_f, cap_res_f,
               nazionalita_ita_f, data_nazionalita_f, titolo_studio_f, 
               cognome_avv_m, nome_avv_m, cognome_avv_f, nome_avv_f,
               sostentamento_cn, abitazione_assegnata, 
               mantenimento_fg, 
               presenza_fg, presenza_fg_min, presenza_fg_mag, 
               mantenimento_fg_mag,
               cod_pro_res_m, cod_com_res_m,
               cod_pro_res_f, cod_com_res_f)
        select a_ufficio, a_anno, a_atto, a_parte, a_serie, 
               w_cod_modello, w_progr_questionario, w_tipo_accordo, 
               w_ufficio_mat, w_anno_mat, w_atto_mat, w_parte_mat, w_serie_mat, 
               w_cod_pro_mat, w_cod_com_mat, w_data_mat, w_rito_mat, w_convenzioni_mat,
               w_cod_fiscale_m, 
               decode(sign(a_anno-2024), -1, w_indirizzo_res_m), 
               decode(sign(a_anno-2024), -1, w_civico_res_m), 
               decode(sign(a_anno-2024), -1, w_cap_res_m),
               w_nazionalita_ita_m, w_data_nazionalita_m, 
               decode(sign(a_anno-2024), -1, w_titolo_studio_m), 
               w_cod_fiscale_f, 
               decode(sign(a_anno-2024), -1, w_indirizzo_res_f), 
               decode(sign(a_anno-2024), -1, w_civico_res_f), 
               decode(sign(a_anno-2024), -1, w_cap_res_f),
               w_nazionalita_ita_f, w_data_nazionalita_f, 
               decode(sign(a_anno-2024), -1, w_titolo_studio_f), 
               decode(sign(a_anno-2024), -1, w_cognome_avv_m),  
               decode(sign(a_anno-2024), -1, w_nome_avv_m), 
               decode(sign(a_anno-2024), -1, w_cognome_avv_f), 
               decode(sign(a_anno-2024), -1, w_nome_avv_f),
               decode(sign(a_anno-2024), -1, 2), 
               decode(sign(a_anno-2024), -1, 5), 
               decode(sign(a_anno-2024), -1, 2), 
               decode(sign(a_anno-2024), -1, 2), 
               decode(sign(a_anno-2024), -1, 2), 
               decode(sign(a_anno-2024), -1, 2), 
               decode(sign(a_anno-2024), -1, 2),
               decode(sign(a_anno-2024), -1, to_number(null), a_cod_pro_res_m),
               decode(sign(a_anno-2024), -1, to_number(null), a_cod_com_res_m),
               decode(sign(a_anno-2024), -1, to_number(null), a_cod_pro_res_f),
               decode(sign(a_anno-2024), -1, to_number(null), a_cod_com_res_f)
          from dual
         where not exists (select 'x' from istmsc b
                            where b.ufficio = a_ufficio
                              and b.anno    = a_anno
                              and b.atto    = a_atto
                              and b.parte   = a_parte
                              and b.serie   = a_serie)
        ;
        if sql%found then
           ISTAT_PKG.ins_log('civmat_ist_fi','istmsc - insert');
        end if;
      exception
        when others then
             raise_application_error(-20999, 'Errore in inserimento ISTMSC ('||SQLERRM||')');
      end;

<< fine >>
null;
     
   end if;
  end if;

  if DELETING then
     if a_cod_rec in (0,3) then
        begin
          update istmd3
             set ufficio_mat   = '',
                 anno_mat      = '',
                 parte_mat     = '',
                 serie_mat     = '',
                 atto_mat      = '',
                 flag_completo = ''
           where ufficio_mat        = a_ufficio
             and anno_mat           = a_anno
             and parte_mat          = a_parte
             and nvl(serie_mat,' ') = nvl(a_serie,' ')
             and atto_mat           = a_atto
             and atto_pub           is not null
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmat_ist_fi','istmd3 - update');
          end if;
        end;
        begin
          delete istmd3
           where ufficio_mat        = a_ufficio
             and anno_mat           = a_anno
             and parte_mat          = a_parte
             and nvl(serie_mat,' ') = nvl(a_serie,' ')
             and atto_mat           = a_atto
             and atto_pub           is null
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmat_ist_fi','istmd3 - delete');
          end if;
        end;
        begin
          delete istmsc
           where ufficio        = a_ufficio
             and anno           = a_anno
             and parte          = a_parte
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmat_ist_fi','istmsc - delete');
          end if;
        end;
     end if;
  end if;

end;
/
