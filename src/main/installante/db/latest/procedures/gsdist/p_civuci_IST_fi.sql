--liquibase formatted sql
--changeset amonopoli:202303071315_2 runOnChange:true stripComments:false
create or replace procedure CIVUCI_IST_FI
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
 a_cod_fiscale_m   	IN	varchar2,
 a_cognome_nome_f	IN	varchar2,
 a_data_nas_f		IN	number,
 a_cod_pro_res_f	IN	number,
 a_cod_com_res_f	IN	number,
 a_nazionalita_f	IN	varchar2,
 a_cod_fiscale_f	IN	varchar2,
 a_atto_old		IN	number,
 a_id_civdta		IN	number,
 a_id_atto		IN	varchar2,
 a_cod_pro_mat_old	IN	number,
 a_cod_com_mat_old	IN	number
)

IS

  w_natura_pr                   varchar2(1);

  w_matrimonio			number;
  w_stato_civile_m		varchar2(2);
  w_data_fine_mat_m		number;
  w_stato_civile_f		varchar2(2);
  w_data_fine_mat_f		number;

  w_nazionalita_ita_m	number(1);
  w_data_inizio_naz_m	number(8);
  w_data_nazionalita_m	number(8);
  w_nazionalita_ita_f	number(1);
  w_data_inizio_naz_f	number(8);
  w_data_nazionalita_f	varchar2(8);

  w_ufficio_pub		number;
  w_anno_pub		number;
  w_atto_pub		number;
  w_parte_pub		number;
  w_serie_pub		varchar2(1);
  w_esiste_pub		number := 0;
  w_aggiornato_pub	number := 0;

-- dati x i modelli statistici di scioglimenti (6SU / 12SU)
  w_tipo_divorzio		varchar2(255);

  w_cod_modello		varchar2(255);
  w_progr_questionario	number(8);
  w_tipo_accordo	number(1);	

  w_cod_fiscale_m 	varchar2(16) := a_cod_fiscale_m;
  w_cod_fiscale_f	varchar2(16) := a_cod_fiscale_f;

  w_ufficio_uci		number;
  w_anno_uci		number;
  w_atto_uci		number;
  w_parte_uci		number;
  w_serie_uci		varchar2(1);
  w_cod_pro_uci		number(3);
  w_cod_com_uci		number(3);
  w_data_uci		number(8);
  w_convenzioni_uci	number(1);

begin
--
-- . l'inserimento della pubblicazione in CIVUCI (natura 'V')
--   produce il riempimento della tabella ISTMDU (dati _PUB)
-- . l'inserimento dell'atto di unione in CIVUCI (natura 'O')
--   produce il completamento / riempimento della tabella ISTMDU (dati _MAT)
--
-- 22/12/2023 (AM): l'inserimento dell'atto di unione in CIVUCI (natura 'D' - flag_istat/cod_modello valorizzati) produce il riempimento della tabella ISTMSU
-- 18/01/2024 (AM): gestito UPDATE di comune matrimonio
--

  begin
    select 1 into w_matrimonio
      from menuditta
     where pro_cliente	= a_cod_pro_mat
       and com_cliente	= a_cod_com_mat
       and rownum	= 1
    ;
  exception
    when others then 
         w_matrimonio := 0;
  end;

  if a_id_civdta is not null then
     w_natura_pr := a_natura;
  else
     begin
       select natura_pr into w_natura_pr
         from civuci_natura
        where natura = a_natura
          and rownum = 1
       ;
     exception
       when others then 
            w_natura_pr := '';
     end;
  end if;
  ISTAT_PKG.ins_log('civuci_ist_fi','w_natura_pr: '||w_natura_pr);

if nvl(w_natura_pr,' ') = 'V' then
  if UPDATING then
     if a_atto_old < 0 and a_atto > 0 then
        begin
          update istmdu
             set atto_pub = a_atto
           where ufficio_pub        = a_ufficio
             and anno_pub           = a_anno
             and nvl(parte_pub,0)   = nvl(a_parte,0)
             and nvl(serie_pub,' ') = nvl(a_serie,' ')
             and atto_pub           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - update');
          end if;
        end;
     end if;
  end if;

  if INSERTING or (UPDATING and nvl(a_cod_pro_mat_old||a_cod_com_mat_old,0) != nvl(a_cod_pro_mat||a_cod_com_mat,0)) then
     if w_matrimonio = 1 and a_cod_rec = 3 then
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
	  select ana_m.stato_civile, 
		 decode(ana_m.stato_civile,
		   'VE',ana_m.data_ved,
		   'VU',ana_m.data_ved,
		   'DV',nvl(ana_m.data_div_ann,ana_m.data_div),
    	 	   'GC',nvl(ana_m.data_div_ann,ana_m.data_div),
    	 	   'GU',nvl(ana_m.data_div_ann,ana_m.data_div)),
                 decode(ana_m.fascia,1,decode(ana_m.nazionalita,'I',ana_m.data_inizio_naz)),
		 ana_f.stato_civile, 
		 decode(ana_f.stato_civile,
		   'VE',ana_f.data_ved,
		   'VU',ana_f.data_ved,
		   'DV',nvl(ana_f.data_div_ann,ana_f.data_div),
		   'GC',nvl(ana_f.data_div_ann,ana_f.data_div),
		   'GU',nvl(ana_f.data_div_ann,ana_f.data_div)),
                 decode(ana_m.fascia,1,decode(ana_m.nazionalita,'I',ana_m.data_inizio_naz))
	    into w_stato_civile_m, w_data_fine_mat_m,w_data_inizio_naz_m,
	         w_stato_civile_f, w_data_fine_mat_f,w_data_inizio_naz_f
	    from anaana ana_m, anaana ana_f, civana ana
	   where ana_m.matricola (+)	= ana.matricola_1
  	     and ana_f.matricola (+)	= ana.matricola_2
  	     and ana.tipo_atto		= 3
	     and ana.ufficio		= a_ufficio
	     and ana.anno	 	= a_anno
	     and ana.atto		= a_atto
	     and nvl(ana.parte,0)	= nvl(a_parte,0)
  	     and nvl(ana.serie,' ')	= nvl(a_serie,' ')
	  ;
          if w_nazionalita_ita_m = 1 and w_data_inizio_naz_m is not null then
             w_nazionalita_ita_m  := 2;
             w_data_nazionalita_m := w_data_inizio_naz_m;
          end if;
          if w_nazionalita_ita_f = 1 and w_data_inizio_naz_f is not null then
             w_nazionalita_ita_f  := 2;
             w_data_nazionalita_f := w_data_inizio_naz_f;
          end if;

	exception
  	  when others then 
	       w_stato_civile_m    := '';
               w_data_fine_mat_m   := '';
               w_data_inizio_naz_m := '';
	       w_stato_civile_f    := '';
               w_data_fine_mat_f   := '';
               w_data_inizio_naz_f := '';
	end;

	begin
	  insert into istmdu
		 (ufficio_mat, anno_mat, atto_mat, parte_mat, serie_mat,
 		  ufficio_pub, anno_pub, atto_pub, parte_pub, serie_pub,
 		  stato_civile_m, data_fine_mat_m, grado_istruzione_m,
 		  condizione_prof_m, posizione_prof_m, attivita_prof_m,
                  nazionalita_ita_m, data_nazionalita_m,
	  	  cod_pro_res_post_m, cod_com_res_post_m,
 		  stato_civile_f, data_fine_mat_f, grado_istruzione_f,
		  condizione_prof_f, posizione_prof_f, attivita_prof_f,
                  nazionalita_ita_f, data_nazionalita_f,
		  cod_pro_res_post_f, cod_com_res_post_f)
	  select '', '', '', '', '',
		 a_ufficio, a_anno, a_atto, a_parte, a_serie,
		 w_stato_civile_m, w_data_fine_mat_m, '',
		 '', '', '',
                 w_nazionalita_ita_m, w_data_nazionalita_m,
		 a_cod_pro_res_m, a_cod_com_res_m,
		 w_stato_civile_f, w_data_fine_mat_f, '',
	         '', '', '',
                 w_nazionalita_ita_f, w_data_nazionalita_f,
		 a_cod_pro_res_f, a_cod_com_res_f
	    from dual
	   where not exists (select 'x' 
			       from istmdu
			      where ufficio_pub		= a_ufficio
				and anno_pub		= a_anno
				and atto_pub		= a_atto
				and nvl(parte_pub,0)	= nvl(a_parte,0)
				and nvl(serie_pub,' ')	= nvl(a_serie,' '))
	  ;
          if sql%found then
             ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - insert');
          end if;
	end;
     end if;
  end if;

  if DELETING then
     if a_cod_rec in (0,3) then
        begin
          delete istmdu
           where ufficio_pub        = a_ufficio
             and anno_pub           = a_anno
             and nvl(parte_pub,0)   = nvl(a_parte,0)
             and nvl(serie_pub,' ') = nvl(a_serie,' ')
             and atto_pub           = a_atto
             and atto_mat           is null
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - delete');
          end if;
        end;
     end if;
  end if;

elsif nvl(w_natura_pr,' ') = 'O' then
  if UPDATING then
     if a_atto_old < 0 and a_atto > 0 then
        begin
          update istmdu
             set atto_mat = a_atto
           where ufficio_mat        = a_ufficio
             and anno_mat           = a_anno
             and nvl(parte_mat,0)   = nvl(a_parte,0)
             and nvl(serie_mat,' ') = nvl(a_serie,' ')
             and atto_mat           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - update');
          end if;
        end;
     end if;
  end if;

  if INSERTING or (UPDATING and nvl(a_cod_pro_mat_old||a_cod_com_mat_old,0) != nvl(a_cod_pro_mat||a_cod_com_mat,0)) then
     if w_matrimonio = 1 and nvl(w_natura_pr,' ') ='O' and a_cod_rec = 3 then
        begin
          select pub.ufficio, pub.anno, pub.atto, pub.parte, pub.serie
            into w_ufficio_pub, w_anno_pub, w_atto_pub, w_parte_pub, w_serie_pub
            from civuci pub
           where pub.cognome_nome_m	= a_cognome_nome_m
             and pub.data_nas_m		= a_data_nas_m
             and pub.cognome_nome_f	= a_cognome_nome_f
             and pub.data_nas_f		= a_data_nas_f
             and pub.natura             = 'V'
          ;
          w_esiste_pub := 1;
          ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - esiste pub');
        exception
          when others then 
               w_esiste_pub := 0;
              ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - non esiste pub');
        end;

        if w_esiste_pub = 1 then
           begin
             update istmdu
                set ufficio_mat	= a_ufficio,
                    anno_mat	= a_anno,
                    atto_mat	= a_atto,
                    parte_mat	= a_parte,
                    serie_mat	= a_serie
              where ufficio_pub	= w_ufficio_pub
                and anno_pub	= w_anno_pub
                and atto_pub	= w_atto_pub
                and nvl(parte_pub,0)   = nvl(w_parte_pub,0)
                and nvl(serie_pub,' ') = nvl(w_serie_pub,' ')
             ;
	     if SQL%notfound THEN
                w_aggiornato_pub := 0;
                ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - update ('||sqlerrm||')');
             else
                w_aggiornato_pub := 1;
                ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - update');
             end if;
           end;
        end if;

        if w_esiste_pub = 0 or w_aggiornato_pub = 0 then
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
	     select ana_m.stato_civile, 
		    decode(ana_m.stato_civile,
		      'VE',ana_m.data_ved,
   		      'VU',ana_m.data_ved,
		      'DV',nvl(ana_m.data_div_ann,ana_m.data_div),
    	 	      'GC',nvl(ana_m.data_div_ann,ana_m.data_div),
    	 	      'GU',nvl(ana_m.data_div_ann,ana_m.data_div)),
                    decode(ana_m.fascia,1,decode(ana_m.nazionalita,'I',ana_m.data_inizio_naz)),
		    ana_f.stato_civile, 
		    decode(ana_f.stato_civile,
		      'VE',ana_f.data_ved,
		      'VU',ana_f.data_ved,
		      'DV',nvl(ana_f.data_div_ann,ana_f.data_div),
		      'GC',nvl(ana_f.data_div_ann,ana_f.data_div),
		      'GU',nvl(ana_f.data_div_ann,ana_f.data_div)),
                    decode(ana_m.fascia,1,decode(ana_m.nazionalita,'I',ana_m.data_inizio_naz))
	       into w_stato_civile_m, w_data_fine_mat_m,w_data_inizio_naz_m,
	            w_stato_civile_f, w_data_fine_mat_f,w_data_inizio_naz_f
   	       from anaana ana_m, anaana ana_f, civana ana
	      where ana_m.matricola (+)	= ana.matricola_1
  	        and ana_f.matricola (+)	= ana.matricola_2
  	        and ana.tipo_atto		= -4
	        and ana.ufficio		= a_ufficio
	        and ana.anno	 	= a_anno
	        and ana.atto		= a_atto
	        and nvl(ana.parte,0)	= nvl(a_parte,0)
  	        and nvl(ana.serie,' ')	= nvl(a_serie,' ')
	     ;
             if w_nazionalita_ita_m = 1 and w_data_inizio_naz_m is not null then
                w_nazionalita_ita_m  := 2;
                w_data_nazionalita_m := w_data_inizio_naz_m;
             end if;
             if w_nazionalita_ita_f = 1 and w_data_inizio_naz_f is not null then
                w_nazionalita_ita_f  := 2;
                w_data_nazionalita_f := w_data_inizio_naz_f;
             end if;
	   exception
             when others then 
	          w_stato_civile_m    := '';
                  w_data_fine_mat_m   := '';
                  w_data_inizio_naz_m := '';
	          w_stato_civile_f    := '';
                  w_data_fine_mat_f   := '';
                  w_data_inizio_naz_f := '';
           end;

           begin
	     insert into istmdu
		    (ufficio_mat, anno_mat, atto_mat, parte_mat, serie_mat,
 		     ufficio_pub, anno_pub, atto_pub, parte_pub, serie_pub,
 		     stato_civile_m, data_fine_mat_m, grado_istruzione_m,
 		     condizione_prof_m, posizione_prof_m, attivita_prof_m,
                     nazionalita_ita_m, data_nazionalita_m,
	  	     cod_pro_res_post_m, cod_com_res_post_m,
 		     stato_civile_f, data_fine_mat_f, grado_istruzione_f,
		     condizione_prof_f, posizione_prof_f, attivita_prof_f,
                     nazionalita_ita_f, data_nazionalita_f,
		     cod_pro_res_post_f, cod_com_res_post_f)
	     select a_ufficio, a_anno, a_atto, a_parte, a_serie,
                    '', '', '', '', '',
		    w_stato_civile_m, w_data_fine_mat_m, '',
		    '', '', '',
                    w_nazionalita_ita_m, w_data_nazionalita_m,
		    a_cod_pro_res_m, a_cod_com_res_m,
		    w_stato_civile_f, w_data_fine_mat_f, '',
	            '', '', '',
                    w_nazionalita_ita_f, w_data_nazionalita_f,
		    a_cod_pro_res_f, a_cod_com_res_f
	       from dual
              where not exists (select 'x' 
	                          from istmdu
		   	         where ufficio_mat		= a_ufficio
			           and anno_mat			= a_anno
				   and atto_mat			= a_atto
				   and nvl(parte_mat,0)		= nvl(a_parte,0)
				   and nvl(serie_mat,' ')	= nvl(a_serie,' '))
	     ;
             if sql%found then
                ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - insert');
             end if;
	   end;

           begin
             update istmdu
 	        set flag_completo	= 'S'
	      where ufficio_mat		= a_ufficio
   	        and anno_mat		= a_anno
	        and atto_mat		= a_atto
	        and nvl(parte_mat,0)	= nvl(a_parte,0)
	        and nvl(serie_mat,' ')	= nvl(a_serie,' ')
	        and STATO_CIVILE_M	is not null
	        and GRADO_ISTRUZIONE_M	is not null
	        and CONDIZIONE_PROF_M	is not null
	        and POSIZIONE_PROF_M	is not null
	        and ATTIVITA_PROF_M	is not null
	        and COD_PRO_RES_POST_M	is not null
	        and COD_COM_RES_POST_M	is not null
	        and STATO_CIVILE_F	is not null
	        and GRADO_ISTRUZIONE_F	is not null
	        and CONDIZIONE_PROF_F	is not null
	        and POSIZIONE_PROF_F	is not null
	        and ATTIVITA_PROF_F	is not null
	        and COD_PRO_RES_POST_F	is not null
	        and COD_COM_RES_POST_F	is not null
	     ; 
             if sql%found then
                ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - update');
             end if;
	   end;
        end if; -- w_esiste_pub = 0 or w_aggiornato_pub = 0 then
     end if; -- if w_matrimonio = 1 and nvl(w_natura_pr,' ') ='O' and a_cod_rec = 3 then
  end if; -- if INSERTING

  if DELETING then
     if a_cod_rec in (0,3) then
        begin
          update istmdu
             set ufficio_mat   = '',
                 anno_mat      = '',
                 parte_mat     = '',
                 serie_mat     = '',
                 atto_mat      = '',
                 flag_completo = ''
           where ufficio_mat        = a_ufficio
             and anno_mat           = a_anno
             and nvl(parte_mat,0)   = nvl(a_parte,0)
             and nvl(serie_mat,' ') = nvl(a_serie,' ')
             and atto_mat           = a_atto
             and atto_pub           is not null
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - update');
          end if;
        end;

        begin
          delete istmdu
           where ufficio_mat        = a_ufficio
             and anno_mat           = a_anno
             and nvl(parte_mat,0)   = nvl(a_parte,0)
             and nvl(serie_mat,' ') = nvl(a_serie,' ')
             and atto_mat           = a_atto
             and atto_pub           is null
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civuci_ist_fi','istmdu - delete');
          end if;
        end;
     end if;
  end if;

elsif nvl(w_natura_pr,' ') = 'D' and a_anno >= 2024 then
  if UPDATING then
     if a_atto_old < 0 and a_atto > 0 then
        begin
          update istmsu
             set atto = a_atto
           where ufficio        = a_ufficio
             and anno           = a_anno
             and nvl(parte,0)   = nvl(a_parte,0)
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civuci_ist_fi','istmsu - update');
          end if;
        end;
     end if;
  end if;

  if INSERTING then
      /*begin
        select tipo_divorzio
          into w_tipo_divorzio
          from civdpa
         where id_atto = a_id_atto
           and rownum = 1
        ;
      exception
        when others then
             w_tipo_divorzio := '';
      end;*/

      if a_id_civdta is not null then
         begin
           select cta.cod_modello_istat, 3
             into w_cod_modello, w_tipo_accordo
             from civcta cta, civdta dta
            where cta.flag_divorzio is not null
              and cta.flag_istat    is not null
              and cta.id            = dta.id_civcta
              and dta.id            = a_id_civdta
              and rownum = 1
           ;
         exception
           when others then
                w_cod_modello  := '';
                w_tipo_accordo := '';
         end;
      else
         begin
           select cod_modello_ist, 3
             into w_cod_modello, w_tipo_accordo
             from civuci_natura
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
-- Gestione Modelli 6SU / 12SU - Scioglimenti
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
        select decode(ana.fascia,1,decode(ana.nazionalita,'I',ana.data_inizio_naz))
          INTO w_data_inizio_naz_m
          from anaana ana, civana civ
         where ana.matricola   = civ.matricola_1
 	   and civ.id_atto     = a_id_atto
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
 	   and civ.id_atto     = a_id_atto
        ;
        if w_nazionalita_ita_f = 1 then
           w_data_nazionalita_f := w_data_inizio_naz_f;
        end if;
      exception
        when others then
             w_data_nazionalita_f := '';
      end;

      begin
        select uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie,
               uci.COD_PRO_MAT, uci.cod_com_mat, uci.data_mat,
               decode(uci.convenzioni,'SI',2,1)
          INTO w_UFFICIO_uci, w_ANNO_uci, w_ATTO_uci, w_PARTE_uci, w_SERIE_uci,
               w_cod_pro_uci, w_cod_com_uci, w_data_uci, 
               w_convenzioni_uci
          from civuci uci
         where cognome_nome_f    = a_cognome_nome_f
           and nvl(data_nas_f,0) = decode(data_nas_f,'',0,a_data_nas_f)
           and cognome_nome_m    = a_cognome_nome_m
           and nvl(data_nas_m,0) = decode(data_nas_m,'',0,a_data_nas_m)
           and natura            = 'O'
           and rownum = 1
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

      begin
        insert into istmsu
              (ufficio, anno, atto, parte, serie, 
               cod_modello, progr_questionario, tipo_accordo, 
               ufficio_uci, anno_uci, atto_uci, parte_uci, serie_uci, 
               cod_pro_uci, cod_com_uci, data_uci, regime_patrimoniale_uci,
               cod_fiscale_1, nazionalita_ita_1, data_nazionalita_1, cod_pro_res_1, cod_com_res_1,
               cod_fiscale_2, nazionalita_ita_2, data_nazionalita_2, cod_pro_res_2, cod_com_res_2)
        select a_ufficio, a_anno, a_atto, a_parte, a_serie, 
               w_cod_modello, w_progr_questionario, w_tipo_accordo, 
               w_ufficio_uci, w_anno_uci, w_atto_uci, w_parte_uci, w_serie_uci, 
               w_cod_pro_uci, w_cod_com_uci, w_data_uci, w_convenzioni_uci,
               w_cod_fiscale_m, w_nazionalita_ita_m, w_data_nazionalita_m, a_cod_pro_res_m, a_cod_com_res_m,
               w_cod_fiscale_f, w_nazionalita_ita_f, w_data_nazionalita_f, a_cod_pro_res_f, a_cod_com_res_f
          from dual
         where not exists (select 'x' from istmsu b
                            where b.id_atto = a_id_atto)
        ;
        if sql%found then
           ISTAT_PKG.ins_log('civuci_ist_fi','istmsu - insert');
        end if;
      exception
        when others then
             raise_application_error(-20999, 'Errore in inserimento ISTMSU ('||SQLERRM||')');
      end;

<< fine >>
null;

  end if; -- if INSERTING

  if DELETING then
     if a_cod_rec in (0,3) then
        begin
          delete istmsu
           where id_atto = a_id_atto
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civuci_ist_fi','istmsu - delete');
          end if;
        end;
     end if;
  end if;
end if;

end;
/
