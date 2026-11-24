--liquibase formatted sql
--changeset amonopoli:202606081630_11 runOnChange:true stripComments:false
create or replace procedure ANATPR_FI
(a_anagrafe				IN	varchar2,
 a_tipo_evento			IN	varchar2,
 a_anno_pratica			IN	number,
 a_pratica				IN	number,
 a_cod_variazione_old		IN	varchar2,
 a_cod_variazione_new		IN	varchar2,
 a_flag_perfezionamento_old	IN	varchar2,
 a_flag_perfezionamento_new	IN	varchar2,
 a_flag_annullamento_old	IN	varchar2,
 a_flag_annullamento_new	IN	varchar2
)

IS

w_flag_preliminare	varchar2(1);

w_cod_fam_dest		number;
w_presso			varchar2(255);

w_cod_fam_air		number;
w_rapporto_par_air	varchar2(2);
w_sequenza_par_air	number;
w_data_inizio_fam_air	number;
w_data_inizio_res_air	number;

w_errore			varchar2(4000);
errore			exception;

begin
--	Creata il 30/04/2012 (A. Monopoli)

if UPDATING then
--
-- cod_variazione
-- 'P' = Iscrizione Preliminare
-- 'a' = Iscrizione Preliminare da AIRE
--
   if a_anagrafe = 'RES' and a_tipo_evento = 'I' and a_cod_variazione_new in ('P','a') and 
      a_flag_perfezionamento_old is null and a_flag_perfezionamento_new = 'S'
   then
      w_flag_preliminare := f_flag_preliminare(a_anagrafe, a_tipo_evento, a_anno_pratica, a_pratica);
      if w_flag_preliminare is not null then
         w_errore := 'Impossibile perfezionare nuovamente Iscrizione Preliminare. Procedere con la modifica del Codice Variazione';
         raise errore;
      end if;
   end if;

--w_errore := a_anagrafe||' '||a_tipo_evento||' '||
--            a_cod_variazione_old||' '||a_cod_variazione_new||' '||
--            a_flag_perfezionamento_old||' '||a_flag_perfezionamento_new||' '||
--            a_flag_annullamento_old||' '||a_flag_annullamento_new;
--raise errore;

   if a_anagrafe = 'RES' and a_tipo_evento = 'I' and 
      ((a_flag_perfezionamento_old is null and a_flag_perfezionamento_new = 'S')
       or (a_flag_annullamento_old is null and a_flag_annullamento_new = 'S'))
   then
	begin
        insert into anamov
		(COD_MOV, COD_EVE, COD_VARIAZIONE,
             DATA_EVE, PRATICA, ANNO_PRATICA, COD_PRO_EVE, COD_COM_EVE,
		 MATRICOLA, COGNOME_NOME, 
		 STATO_CIVILE, SESSO, NAZIONALITA, PATERNITA, MATERNITA, TITOLO_STUDIO,
		 COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO, 
		 COD_FAM, RAPPORTO_PAR, NUCLEO_PARTENZA,
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
	  select 2, 62, mov.cod_variazione,  
             mov.data_eve, a_pratica, a_anno_pratica, mov.cod_pro_eve, mov.cod_com_eve,
		 mov.MATRICOLA, mov.COGNOME_NOME, 
		 mov.STATO_CIVILE, mov.SESSO, mov.NAZIONALITA, mov.PATERNITA, mov.MATERNITA, mov.TITOLO_STUDIO,
		 mov.COD_PROF, mov.ATTIVITA_PROF, mov.POSIZIONE_PROF, mov.PENSIONATO, 
		 mov.COD_FAM, mov.RAPPORTO_PAR, 
             decode(a_flag_annullamento_new,'S',decode(mov.rapporto_par,'CF',1)),
		 mov.COGNOME_NOME_CN, mov.MATRICOLA_CN, 
	 	 mov.ANNO_CENS, mov.SEZIONE_CENS, mov.FOGLIO_CENS,
		 mov.COD_PRO_NAS, mov.COD_COM_NAS, mov.DATA_NAS, mov.COD_PRO_ATTO_NAS, mov.COD_COM_ATTO_NAS,
		 mov.ANNO_ATTO_NAS, mov.ATTO_NAS, mov.PARTE_NAS, mov.SERIE_NAS, mov.UFFICIO_NAS, 
		 mov.ANNO_ATTO_NAS_TR, mov.ATTO_NAS_TR, mov.PARTE_NAS_TR, mov.SERIE_NAS_TR, mov.UFFICIO_NAS_TR,
		 mov.COD_PRO_MAT, mov.COD_COM_MAT, mov.DATA_MAT, 
		 mov.ANNO_ATTO_MAT, mov.ATTO_MAT, mov.PARTE_MAT, mov.SERIE_MAT, mov.UFFICIO_MAT,
	 	 mov.ANNO_ATTO_MAT_TR, mov.ATTO_MAT_TR, mov.PARTE_MAT_TR, mov.SERIE_MAT_TR, mov.UFFICIO_MAT_TR,
		 mov.DATA_MOR, mov.COD_PRO_MOR, mov.COD_COM_MOR, 
		 mov.ANNO_ATTO_MOR, mov.ATTO_MOR, mov.PARTE_MOR, mov.SERIE_MOR, mov.UFFICIO_MOR,
		 mov.ANNO_ATTO_MOR_TR, mov.ATTO_MOR_TR, mov.PARTE_MOR_TR, mov.SERIE_MOR_TR, mov.UFFICIO_MOR_TR,
		 mov.COD_PRO_VED, mov.COD_COM_VED, mov.DATA_VED,
		 mov.ANNO_ATTO_VED, mov.ATTO_VED, mov.PARTE_VED, mov.SERIE_VED, mov.UFFICIO_VED,
		 mov.COD_FISCALE, mov.COD_PRO_DIV, mov.COD_COM_DIV, mov.DATA_DIV,
		 mov.ANNO_ATTO_DIV, mov.ATTO_DIV, mov.PARTE_DIV, mov.SERIE_DIV, mov.UFFICIO_DIV,
		 mov.MATRICOLA_AIRE, mov.CF_CALCOLATO, 
		 mov.COD_PRO_ATTO_MAT, mov.COD_COM_ATTO_MAT, mov.COD_PRO_ATTO_VED, mov.COD_COM_ATTO_VED,
	  	 mov.COD_PRO_ATTO_MOR, mov.COD_COM_ATTO_MOR, mov.COD_EDIFICIO_CENS,
		 mov.COD_PRO_ATTO_DIV, mov.COD_COM_ATTO_DIV, mov.DATA_DIV_GIU, mov.DATA_DIV_ANN,
		 to_char(sysdate,'j')
	    from anaana ana, anamov mov, anaapm apm
	   where ana.fascia		= mov.cod_mov
           and ana.stato		= mov.cod_eve
           and ana.matricola		= mov.matricola
           and mov.matricola		= apm.matricola
           and mov.cod_mov		= 1
           and mov.cod_eve		= 17
           and mov.anno_pratica	= apm.anno_dic
           and mov.pratica		= apm.numero_dic
           and apm.flag_soggetto	is not null
           and nvl(apm.annullamento,a_flag_annullamento_new) is not null
           and apm.anno_dic		= a_anno_pratica
           and apm.numero_dic		= a_pratica
	  ;
        exception
           when others then
                w_errore := 'Errore in inserimento ANAMOV 2-62 ('||SQLCODE||')'; 
                raise errore;
	  end;

        if a_cod_variazione_new in ('P','I') then
-- cod_variazione = 'P' (maiuscolo) -- perfezionamento di una Iscr. Preliminare da altro comune (non AIRE)
-- cod_variazione = 'I' (maiuscolo) -- perfezionamento di una Iscr. Definitiva  da altro comune (non AIRE)
         begin
          delete anaeve
           where cod_mov 	= 1
             and cod_eve 	= 17
             and pratica 	= a_pratica
             and anno_pratica = a_anno_pratica
             and matricola in (select matricola 
                                 from anaapm
                                where anno_dic     = a_anno_pratica
                                  and numero_dic   = a_pratica
                                  and nvl(annullamento,a_flag_annullamento_new) is not null
                                  and flag_soggetto is not null)
          ; 
         exception
          when others then
               w_errore := 'Errore in eliminazione ANAEVE 1-17 ('||SQLCODE||')';
               raise errore;
         end;

         begin
          update anaana ana
             set (fascia, stato, data_ult_eve, cod_fam, rapporto_par, sequenza_par) = 
                 (select eve.cod_mov, eve.cod_eve, eve.data_eve, eve_10.cod_fam, eve_10.rapporto_par, drp.sequenza
                    from anadrp drp, anaeve eve, anaeve eve_10
                   where drp.cod_rp      = eve_10.rapporto_par
                     and drp.sesso       = ana.sesso 
                     and eve_10.matricola	= eve.matricola
                     and eve_10.cod_mov	= 10
                     and eve_10.data_eve	= eve.data_eve - 1
                     and eve.matricola 	= ana.matricola
                     and eve.cod_mov 	in (2,4)
                     and rownum 		= 1
                     and eve.data_eve 	= (select max(e.data_eve)
                                               from anaeve e
                                              where e.matricola 	= eve.matricola
                                                and e.cod_mov 	in (2,4))),
                 data_inizio_fam = '',
                 data_inizio_res = '',
                 note            = ltrim(note||' Accertamenti Negativi dopo Iscrizione Preliminare (pratica '||a_pratica||'/'||a_anno_pratica||')')
           where exists (select 'x'
                           from anaapm apm
                          where nvl(apm.annullamento,a_flag_annullamento_new)	is not null
                            and apm.flag_soggetto	is not null
                            and apm.matricola 		= ana.matricola
                            and apm.anno_dic		= a_anno_pratica
                            and apm.numero_dic		= a_pratica)
             and exists (select 'x'
                           from anaeve eve
                          where eve.cod_mov   in (2,4)
                            and eve.matricola = ana.matricola)
             and fascia = 1
             and stato  = 17
          ;
          update anaana ana
             set fascia          = 5, 
                 stato           = 71,
                 data_inizio_fam = '',
                 data_inizio_res = '',
                 note            = ltrim(note||' Accertamenti Negativi dopo Iscrizione Preliminare (pratica '||a_pratica||'/'||a_anno_pratica||')')
           where exists (select 'x'
                           from anaapm apm
                          where nvl(apm.annullamento,a_flag_annullamento_new) is not null
                            and apm.flag_soggetto	is not null
                            and apm.matricola 		= ana.matricola
                            and apm.anno_dic		= a_anno_pratica
                            and apm.numero_dic		= a_pratica)
             and fascia = 1
             and stato  = 17
          ;
         exception
          when others then
               w_errore := 'Errore in aggiornamento ANAANA 5-71 ('||SQLCODE||')';
               raise errore;
         end;
        
        elsif a_cod_variazione_new in ('i','a') then
-- cod_variazione = 'a' (minuscolo) -- perfezionamento di una Iscr. Preliminare da AIRE (successiva a Iscr. Preliminare)
-- cod_variazione = 'i' (minuscolo) -- perfezionamento di una Iscr. Definitiva  da AIRE
         begin
           update anafam fam
              set fascia = 3
            where fascia = 4
              and cod_fam = (select distinct eve_12.cod_fam
                               from anaeve eve_12, anaana ana, anaapm apm
                              where eve_12.data_eve	      = ana.data_ult_eve - 1
                                and eve_12.cod_mov	      = 12
                                and eve_12.cod_eve		= 17
                                and eve_12.matricola        = ana.matricola
                                and nvl(apm.annullamento,a_flag_annullamento_new)	is not null
                                and apm.flag_soggetto   	is not null
                                and apm.matricola 		= ana.matricola
                                and apm.anno_dic		= a_anno_pratica
                                and apm.numero_dic		= a_pratica)
           ;
         exception
          when others then
               w_errore := 'Errore in aggiornamento ANAFAM AIR ('||SQLCODE||')';
               raise errore;
         end;

         begin
          update anaana ana
             set (fascia, stato, data_ult_eve) = 
                 (select eve.cod_mov, eve.cod_eve, eve.data_eve
                    from anaeve eve
                   where eve.matricola 	= ana.matricola
                     and eve.cod_mov 	= 3
                     and eve.data_eve 	= (select max(e.data_eve)
                                               from anaeve e
                                              where e.matricola 	= eve.matricola
                                                and e.cod_mov 	= 3)
                     and rownum 		= 1),
                 (cod_fam, rapporto_par, sequenza_par, data_inizio_fam, data_inizio_res) = 
                 (select eve_12.cod_fam, eve_12.rapporto_par, drp.sequenza, eve_12.data_inizio, eve_13.data_inizio
                    from anadrp drp, anaeve eve_12, anaeve eve_13
                   where drp.cod_rp        = eve_12.rapporto_par
                     and drp.sesso         = ana.sesso
                     and eve_12.data_eve	 = ana.data_ult_eve - 1
                     and eve_12.cod_mov	 = 12
                     and eve_12.cod_eve	 = 17
                     and eve_12.matricola  = ana.matricola
                     and eve_13.data_eve	 = ana.data_ult_eve - 1
                     and eve_13.cod_mov	 = 13
                     and eve_13.cod_eve	 = 17
                     and eve_13.matricola	 = ana.matricola
                     and rownum 		 = 1),
                 note            = ltrim(note||' Accertamenti Negativi dopo Iscrizione Preliminare (pratica '||a_pratica||'/'||a_anno_pratica||')')
           where exists (select 'x'
                           from anaapm apm
                          where nvl(apm.annullamento,a_flag_annullamento_new)	is not null
                            and apm.flag_soggetto	is not null
                            and apm.matricola 		= ana.matricola
                            and apm.anno_dic		= a_anno_pratica
                            and apm.numero_dic		= a_pratica)
             and exists (select 'x'
                           from anaeve eve
                          where eve.cod_mov        = 1
                            and eve.cod_eve        = 17
                            and eve.cod_variazione = 'A'
                            and eve.matricola      = ana.matricola)
             and fascia = 1
             and stato  = 17
          ;
         exception
          when others then
               w_errore := 'Errore in aggiornamento ANAANA AIR ('||SQLCODE||')';
               raise errore;
         end;

         begin
          delete anaeve
           where cod_mov        = 1
             and cod_eve 	  = 17
             and cod_variazione = 'A'
             and pratica 	  = a_pratica
             and anno_pratica   = a_anno_pratica
             and matricola      in (select matricola 
                                      from anaapm
                                     where anno_dic     = a_anno_pratica
                                       and numero_dic   = a_pratica
                                       and nvl(annullamento,a_flag_annullamento_new) is not null
                                       and flag_soggetto is not null)
          ; 
          delete anaeve
           where cod_mov        in (12,13)
             and cod_eve 	  = 17
             and pratica 	  = a_pratica
             and anno_pratica   = a_anno_pratica
             and matricola      in (select matricola 
                                      from anaapm
                                     where anno_dic     = a_anno_pratica
                                       and numero_dic   = a_pratica
                                       and nvl(annullamento,a_flag_annullamento_new) is not null
                                       and flag_soggetto is not null)
          ; 
         exception
          when others then
               w_errore := 'Errore in eliminazione ANAEVE 1-17-A ('||SQLCODE||')';
               raise errore;
         end;

        end if;
   end if;

   if a_anagrafe = 'RES' and a_tipo_evento = 'C' and 
      ((a_flag_perfezionamento_old is null and a_flag_perfezionamento_new = 'S')
       or (a_flag_annullamento_old is null and a_flag_annullamento_new = 'S'))
   then
      begin
        update anacpm cpm
           set flag_soggetto = 'S',
               annullamento  = 'S'
         where flag_ripristino = 'S'
           and (anno_dic, numero_dic) in (select cp4.anno_dic, cp4.numero_dic
                                            from anacp4 cp4
                                           where cp4.anno_pratica = a_anno_pratica
                                             and cp4.pratica      = a_pratica)
           and flag_soggetto is null
        ;
      exception
        when others then
             w_errore := 'Errore in aggiornamento ANACPM - ripristini ('||SQLCODE||')';
             raise errore;
      end;
   end if;

end if;

exception
  when errore then
--       rollback;
       raise_application_error (-20999, w_errore);
  when others then
--       rollback;
       raise_application_error (-20999, 'errore ('||SQLERRM||')');
end;
/* End Procedure: ANATPR_FI */
/
