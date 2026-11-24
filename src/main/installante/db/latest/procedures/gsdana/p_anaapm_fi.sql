--liquibase formatted sql
--changeset amonopoli:202606091245_11 runOnChange:true stripComments:false
create or replace procedure ANAAPM_FI
(a_matricola		number,
 a_anno_dic		number,
 a_numero_dic		number,
 a_annullamento		varchar2,
 a_matricola_old	number,
 a_anno_dic_old		number,
 a_numero_dic_old	number,
 a_annullamento_old	varchar2)

is

w_motivo		varchar2(2000);
w_data_scad		varchar2(100);

w_ctr_aire		number;

begin
-- Creata il 13/09/2005 (A.Monopoli)
-- 05/06/2006 (A.Monopoli) - Salvataggio Anagrafica
-- 09/02/2009 (A.Monopoli) - Registrazione DATA_REG
-- 10/05/2012 (A.Monopoli) - Blocco Iscrizione AIRE diversa da IMAI

if INSERTING then
-- dbms_output.put_line('if inserting');

      begin
        select 1
          into w_ctr_aire
          from anaana ana
         where ana.matricola  = a_matricola
           and ana.fascia 	= 3
           and exists (select 'x' 
                         from anatpr
                        where anagrafe			= 'RES'
                          and tipo_evento			= 'I'
                          and anno_pratica		= a_anno_dic
                          and pratica			= a_numero_dic
                          and upper(cod_variazione)	!= 'A')
        ;
        raise too_many_rows;
      exception
	   when no_data_found then
              null;
         when too_many_rows then
     	        raise_application_error
	          (-20999,'Impossibile procedere con l''inserimento. Soggetto AIRE che deve essere iscritto con altro motivo');
         when others then
              raise_application_error
                (-20999,'Errore in controllo soggetto AIRE ('||SQLCODE||')');
      end;

	begin
         select decode(ini.motivo,'','',' - Motivo: '||ini.motivo),
	          decode(ini.data_scadenza,'','',' - Scadenza Provvedimento: '||
		      to_char(to_date(ini.data_scadenza,'j'),'dd/mm/yyyy'))
           into w_motivo, w_data_scad
           from anaini ini,anaana ana
          where nvl(ini.data_scadenza,9999999) >= to_char(sysdate,'j')
  	      and ini.cognome_nome 	= ana.cognome_nome
  	      and ini.sesso		= ana.sesso
	      and ini.data_nas		= ana.data_nas
	      and nvl(ini.cod_pro_nas,0)	= nvl(ana.cod_pro_nas,0)
	      and nvl(ini.cod_com_nas,0)	= nvl(ana.cod_com_nas,0)
	      and ana.matricola		= a_matricola
 	      and rownum 	 = 1
  	   ;
         raise too_many_rows;
      exception
	   when no_data_found then
              null;
         when too_many_rows then
     	        raise_application_error
	          (-20999,'ATTENZIONE! Inidividuo non Immigrabile'||w_motivo||w_data_scad);
         when others then
              raise_application_error
                (-20999,'Errore in ricerca ANAINI ('||SQLCODE||')');
      end;

	begin
	  insert into anamov	
		(COD_MOV, COD_EVE, DATA_EVE, PRATICA, ANNO_PRATICA,
		 MATRICOLA, COGNOME_NOME, 
		 STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 
		 COD_FAM, RAPPORTO_PAR, 
		 COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 
		 ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 COD_PRO_VED, COD_COM_VED, DATA_VED,
		 ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 MATRICOLA_AIRE, CF_CALCOLATO, 
		 COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
		 DATA_REG)
	  select 5, 70, to_char(sysdate,'j'), a_numero_dic, a_anno_dic,
		 MATRICOLA, COGNOME_NOME, 
		 STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 
		 COD_FAM, RAPPORTO_PAR, 
		 COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 
		 ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 COD_PRO_VED, COD_COM_VED, DATA_VED,
		 ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 MATRICOLA_AIRE, CF_CALCOLATO, 
		 COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
		 to_char(sysdate,'j')
	    from anaana ana
	   where ana.matricola	= a_matricola
	  ;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in inserimento ANAMOV 5-70 ('||SQLCODE||')');
	end;

elsif UPDATING then
-- dbms_output.put_line('if updating');
   if nvl(a_anno_dic_old, a_anno_dic) != a_anno_dic 		or
      nvl(a_numero_dic_old, a_numero_dic) != a_numero_dic
   then
	begin
	  update anamov
	     set pratica	= a_numero_dic,
		 anno_pratica	= a_anno_dic
	   where matricola 	= nvl(a_matricola_old, a_matricola)
	     and anno_pratica	= nvl(a_anno_dic_old, a_anno_dic)
 	     and pratica	= nvl(a_numero_dic_old, a_numero_dic)
	     and cod_mov	= 5
	     and cod_eve	in (70,71)
	  ;
	exception
           when others then
                raise_application_error
                  (-20999,'Errore in aggiornamento ANAMOV 5-70,71 ('||SQLCODE||')');
	end;
   end if;

   if a_annullamento_old is null and a_annullamento = 'S' then
-- dbms_output.put_line('dentro if x update');

	begin
	  insert into anamov	
		(COD_MOV, COD_EVE, DATA_EVE, PRATICA, ANNO_PRATICA,
		 MATRICOLA, COGNOME_NOME, 
		 STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 
		 COD_FAM, RAPPORTO_PAR, 
		 COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 
		 ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 COD_PRO_VED, COD_COM_VED, DATA_VED,
		 ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 MATRICOLA_AIRE, CF_CALCOLATO, 
		 COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
		 DATA_REG)
	  select 5, 71, to_char(sysdate,'j'), a_numero_dic, a_anno_dic,
		 MATRICOLA, COGNOME_NOME, 
		 STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 
		 COD_FAM, RAPPORTO_PAR, 
		 COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 
		 ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 COD_PRO_VED, COD_COM_VED, DATA_VED,
		 ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 MATRICOLA_AIRE, CF_CALCOLATO, 
		 COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
		 to_char(sysdate,'j')
	    from anaana ana
	   where ana.matricola	= a_matricola
	  ;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in inserimento ANAMOV 5-71 ('||SQLCODE||')');
	end;

/*
        begin
	  update anaana
	     set (COGNOME_NOME, 
		 	STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 	COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 	
		 	COD_FAM, RAPPORTO_PAR, 
		 	COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 	ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 	COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 	ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 	ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 	COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 	
		 	ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 	ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 	DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 	ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 	ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 	COD_PRO_VED, COD_COM_VED, DATA_VED,
		 	ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 	COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 	ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 	MATRICOLA_AIRE, CF_CALCOLATO, 
		 	COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 	COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 	COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
			SEQUENZA_PAR) =
		 (select COGNOME_NOME, 
		 	STATO_CIVILE, mov.SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 	COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 	
		 	COD_FAM, RAPPORTO_PAR, 
		 	COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 	ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 	COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 	ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 	ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 	COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 	
		 	ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 	ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 	DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 	ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 	ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 	COD_PRO_VED, COD_COM_VED, DATA_VED,
		 	ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 	COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 	ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 	MATRICOLA_AIRE, CF_CALCOLATO, 
		 	COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 	COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 	COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
	 	 	drp.sequenza
	    	   from anadrp drp, anamov mov
	   	  where drp.cod_rp	(+)	= mov.rapporto_par
		    and drp.sesso	(+)	= mov.sesso
		    and mov.matricola		= nvl(a_matricola_old,a_matricola)
	 	    and mov.pratica		= nvl(a_numero_dic_old,a_numero_dic)
		    and mov.anno_pratica	= nvl(a_anno_dic_old,a_anno_dic)
		    and mov.cod_mov		= 5
		    and mov.cod_eve		= 70)
           where matricola = nvl(a_matricola_old,a_matricola)
	     and exists (select 'x' from anamov mov
			  where mov.matricola		= nvl(a_matricola_old,a_matricola)
			    and mov.pratica		= nvl(a_numero_dic_old,a_numero_dic)
		 	    and mov.anno_pratica	= nvl(a_anno_dic_old,a_anno_dic)
			    and mov.cod_mov		= 5
			    and mov.cod_eve		= 70)	   
	  ;
--	  IF sql%notfound then
--                raise_application_error
--                  (-20999,'nessun record aggiornato');	
--	  end if;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in aggiornamento ANAANA 5-70 ('||SQLCODE||')');
	end;
*/

      begin
	  delete anamov mov
	   where mov.matricola		= nvl(a_matricola_old,a_matricola)
	     and mov.pratica		= nvl(a_numero_dic_old,a_numero_dic)
	     and mov.anno_pratica	= nvl(a_anno_dic_old,a_anno_dic)
	     and mov.cod_mov		= 5
	     and mov.cod_eve		= 70
	  ;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in eliminazione ANAMOV 5-70 ('||SQLCODE||')');
	end;

   end if;

   if a_annullamento_old = 'S' and a_annullamento is null then
-- dbms_output.put_line('dentro if x update');

	begin
	  insert into anamov	
		(COD_MOV, COD_EVE, DATA_EVE, PRATICA, ANNO_PRATICA,
		 MATRICOLA, COGNOME_NOME, 
		 STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 
		 COD_FAM, RAPPORTO_PAR, 
		 COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 
		 ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 COD_PRO_VED, COD_COM_VED, DATA_VED,
		 ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 MATRICOLA_AIRE, CF_CALCOLATO, 
		 COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
		 DATA_REG)
	  select 5, 70, to_char(sysdate,'j'), a_numero_dic, a_anno_dic,
		 MATRICOLA, COGNOME_NOME, 
		 STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 
		 COD_FAM, RAPPORTO_PAR, 
		 COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 
		 ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 COD_PRO_VED, COD_COM_VED, DATA_VED,
		 ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 MATRICOLA_AIRE, CF_CALCOLATO, 
		 COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
		 to_char(sysdate,'j') 
	    from anaana ana
	   where ana.matricola	= a_matricola
	  ;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in inserimento ANAMOV 5-71 ('||SQLCODE||')');
	end;

/*
        begin
	  update anaana
	     set (COGNOME_NOME, 
		 	STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 	COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 	
		 	COD_FAM, RAPPORTO_PAR, 
		 	COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 	ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 	COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 	ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 	ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 	COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 	
		 	ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 	ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 	DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 	ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 	ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 	COD_PRO_VED, COD_COM_VED, DATA_VED,
		 	ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 	COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 	ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 	MATRICOLA_AIRE, CF_CALCOLATO, 
		 	COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 	COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 	COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
			SEQUENZA_PAR) =
		 (select COGNOME_NOME, 
		 	STATO_CIVILE, mov.SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 	COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 	
		 	COD_FAM, RAPPORTO_PAR, 
		 	COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 	ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 	COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 	ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 	ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 	COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 	
		 	ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 	ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 	DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 	ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 	ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 	COD_PRO_VED, COD_COM_VED, DATA_VED,
		 	ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 	COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 	ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 	MATRICOLA_AIRE, CF_CALCOLATO, 
		 	COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 	COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 	COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
	 	 	drp.sequenza
	    	   from anadrp drp, anamov mov
	   	  where drp.cod_rp	(+)	= mov.rapporto_par
		    and drp.sesso	(+)	= mov.sesso
		    and mov.matricola		= nvl(a_matricola_old,a_matricola)
	 	    and mov.pratica		= nvl(a_numero_dic_old,a_numero_dic)
		    and mov.anno_pratica	= nvl(a_anno_dic_old,a_anno_dic)
		    and mov.cod_mov		= 5
		    and mov.cod_eve		= 71)
           where matricola = nvl(a_matricola_old,a_matricola)
	     and exists (select 'x' from anamov mov
			  where mov.matricola		= nvl(a_matricola_old,a_matricola)
			    and mov.pratica		= nvl(a_numero_dic_old,a_numero_dic)
		 	    and mov.anno_pratica	= nvl(a_anno_dic_old,a_anno_dic)
			    and mov.cod_mov		= 5
			    and mov.cod_eve		= 71)	   
	  ;
--	  IF sql%notfound then
--                raise_application_error
--                  (-20999,'nessun record aggiornato');	
--	  end if;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in aggiornamento ANAANA 5-71 ('||SQLCODE||')');
	end;
*/

        begin
	  delete anamov mov
	   where mov.matricola		= nvl(a_matricola_old,a_matricola)
	     and mov.pratica		= nvl(a_numero_dic_old,a_numero_dic)
	     and mov.anno_pratica	= nvl(a_anno_dic_old,a_anno_dic)
	     and mov.cod_mov		= 5
	     and mov.cod_eve		= 71
	  ;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in eliminazione ANAMOV 5-71 ('||SQLCODE||')');
	end;

   end if;

elsif DELETING then
-- dbms_output.put_line('if deleting');

/*
        begin
	  update anaana
	     set (COGNOME_NOME, 
		 	STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 	COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 	
		 	COD_FAM, RAPPORTO_PAR, 
		 	COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 	ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 	COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 	ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 	ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 	COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 	
		 	ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 	ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 	DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 	ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 	ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 	COD_PRO_VED, COD_COM_VED, DATA_VED,
		 	ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 	COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 	ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 	MATRICOLA_AIRE, CF_CALCOLATO, 
		 	COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 	COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 	COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN) =
		 (select COGNOME_NOME, 
		 	STATO_CIVILE, mov.SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 	COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 	
		 	COD_FAM, RAPPORTO_PAR, 
		 	COGNOME_NOME_CN, MATRICOLA_CN, 
	 	 	ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS,
		 	COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
		 	ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS, 
		 	ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
		 	COD_PRO_MAT, COD_COM_MAT, DATA_MAT, 	
		 	ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
	 	 	ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
		 	DATA_MOR, COD_PRO_MOR,  COD_COM_MOR, 
		 	ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
		 	ANNO_ATTO_MOR_TR, ATTO_MOR_TR,PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
		 	COD_PRO_VED, COD_COM_VED, DATA_VED,
		 	ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
		 	COD_FISCALE, COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
		 	ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
		 	MATRICOLA_AIRE, CF_CALCOLATO, 
		 	COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
	  	 	COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR, COD_EDIFICIO_CENS,
		 	COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN
	    	   from anamov mov
	   	  where mov.matricola		= a_matricola_old
	 	    and mov.pratica		= a_numero_dic_old
		    and mov.anno_pratica	= a_anno_dic_old
		    and mov.cod_mov		= 5
		    and mov.cod_eve		= 70)
           where matricola = a_matricola_old
	     and exists (select 'x' from anamov mov
			  where mov.matricola		= a_matricola_old
			    and mov.pratica		= a_numero_dic_old
		 	    and mov.anno_pratica	= a_anno_dic_old
			    and mov.cod_mov		= 5
			    and mov.cod_eve		= 70)	   
	  ;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in aggiornamento ANAANA 5-70 ('||SQLCODE||')');
	end;
*/

	BEGIN
	  delete anamov
	   where matricola	= a_matricola_old
	     and pratica	= a_numero_dic_old
	     and anno_pratica	= a_anno_dic_old
	     and cod_mov	= 5
	     and cod_eve	in (70,71)
 	  ;
        exception
           when others then
                raise_application_error
                  (-20999,'Errore in eliminazione ANAMOV 5-70,71 ('||SQLCODE||')');
	end;

end if;

end;
/
