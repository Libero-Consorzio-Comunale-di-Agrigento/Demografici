--liquibase formatted sql
--changeset amonopoli:202503250850_3 runOnChange:true stripComments:false
create or replace procedure p_SCAW_riga_dati
(p_anno_progr_mov    	IN	number
,p_numero_progr_mov  	IN 	number
,p_matricola         	IN 	number
,p_anno_pratica      	in      number
,p_pratica           	in 	number
,p_cod_mov           	in 	number
,p_cod_eve           	in 	number
,p_data_reg          	in 	number
,p_ente_lp           	in 	number	
,p_modello           	IN 	varchar2
,p_stampa_terminalista 	IN 	varchar2
,p_nome_terminalista   	IN 	varchar2
,p_separatore		IN	varchar2
,p_valori_finali     	IN OUT 	varchar2
,p_anno_pratica_eve    	in OUT  number
,p_pratica_eve         	in OUT  number
,p_errore            	IN OUT 	varchar2
)

IS

w_sep			varchar2(255) := nvl(p_separatore,chr(9));

 riga_intesta           varchar2(4000);
 riga_dati_0            varchar2(4000);
 riga_dati_prec         varchar2(4000);
 riga_dati_civ          varchar2(4000);
 riga_dati_eve          varchar2(4000);
 riga_dati_aire         varchar2(4000);
 riga_dati_ele          varchar2(4000);
 riga_dati_ente         varchar2(4000);
 riga_dati_1            varchar2(4000);
 riga_dati_3            varchar2(4000);
 riga_dati_4            varchar2(4000);
 riga_dati_5            varchar2(4000);
 riga_dati_6            varchar2(4000);
 riga_dati_7            varchar2(4000);
 riga_dati_ric          varchar2(4000);
 riga_dati_ente_DEST    varchar2(4000);
 riga_dati_leva         varchar2(4000); 
--
 w_pratica_edit         varchar2(4000);
 w_pratica_eve          varchar2(4000);
 w_anno_pratica_eve     varchar2(4000);
 w_pro_cliente          varchar2(4000);
 w_com_cliente          varchar2(4000);
 w_comune               varchar2(4000);
 w_cap                  varchar2(4000);
 w_sesso                varchar2(4000);
 w_nuovo_cod_via        varchar2(4000);
 w_nuovo_num_civ        varchar2(4000);
 w_nuovo_suffisso       varchar2(4000);
 w_data_nas             number;
 w_cod_variazione       VARCHAR2(4000);
 w_vecchia_sezione      varchar2(4000);
 w_nuova_sezione        varchar2(4000);
 w_des_via_aire         varchar2(4000);
 w_des_cons1            varchar2(4000):= null;
 w_des_cons2            varchar2(4000):= null;
 w_des_cons3            varchar2(4000):= null;
 w_des_cons1_mov        varchar2(4000);
 w_des_cons2_mov        varchar2(4000);
 w_des_cons3_mov        varchar2(4000);
 w_des_cons1_mov_prec   varchar2(4000);
 w_des_cons2_mov_prec   varchar2(4000);
 w_des_cons3_mov_prec   varchar2(4000);
 w_cod_fiscale_prec     varchar2(4000);
 w_cod_fiscale          varchar2(4000);
 w_stato_ele            varchar2(4000);
 w_nazionalita          varchar2(4000);
 w_nazionalita_prec     varchar2(4000);
 w_stato_civ            varchar2(4000);
 w_stato_civ_prec       varchar2(4000);
 fine_mese_ele          number;
 anno_corrente          varchar2(4000);
 flag_contribuente      varchar2(4000);
 cod_contribuente       varchar2(4000);
 nuova_sezione          varchar2(4000):='';
 cap_comune_dst         varchar2(4000);
 w_flag_individui       varchar2(4000);
 w_individui            varchar2(4000);
 intest_iai             varchar2(4000);
 data_nas0_edit         varchar2(4000);
 oggetto                varchar2(4000);
 evento                 varchar2(4000);
 da_a                   varchar2(4000);
 protocollo_aire        varchar2(4000);
 des_protocollo_aire    varchar2(4000);
 iniziativa_aire        varchar2(4000); 
--
 trovato                number;
 str                    varchar2(4000);
 str_fam                varchar2(4000);
 i                      number:=0;
 flag                   varchar2(4000);
--
 w_ente_dest            number;
--
 w_des_consolato_1_mov  varchar2(4000);
 w_des_consolato_2_mov  varchar2(4000);
 w_des_consolato_3_mov  varchar2(4000);
 w_des_consolato_1_prec varchar2(4000);
 w_des_consolato_2_prec varchar2(4000);
 w_des_consolato_3_prec varchar2(4000);
--
 w_matricola_aire       varchar2(4000);
 W_cod_fam_aire         varchar2(4000);
--
 w_data_eve_j           number;
 w_cap_com_eve          varchar2(255);
 w_des_com_eve          varchar2(255);
 
 doc_app                number;

 terminalista           	varchar2(4000);
 w_terminalista_mov     	varchar2(4000);
 w_firma_omessa         	varchar2(255);
 w_firma_omessa_term_mov     	varchar2(255);

BEGIN                                    
  begin
        select 
-- riga_dati_0 (3-1)
              MATRICOLA||w_sep||COD_MOV||w_sep||COD_EVE,
-- riga_dati_prec (30-1)            
              COGNOME_NOME_PREC||w_sep||PATERNITA_PREC||w_sep||MATERNITA_PREC||w_sep||
              COD_VIA_PREC||w_sep||
              decode(p_modello,'CRU',substr(DES_COD_VIA_PREC,13),DES_COD_VIA_PREC)||w_sep||
              TIT_STUDIO_PREC||w_sep||
              TITOLO_STUDIO_PREC||w_sep||COD_PROF_PREC||w_sep||DES_COD_PROF_PREC||w_sep||
              NAZIONALITA_PREC||w_sep||STATO_CIV_PREC||w_sep||DATA_NAS_PREC||w_sep||
              DATA_NAS_PREC_EDIT||w_sep||DES_COM_NAS_PREC||w_sep||SESSO_PREC||w_sep||
              COGNOME_NOME_CN_PREC||w_sep||VIA_AIRE_PREC||w_sep||DES_VIA_AIRE_PREC||w_sep||
              DES_COM_AIRE_PREC||w_sep||ZIPCODE_PREC||w_sep||PROVINCIA_CONTEA_PREC||w_sep||
              PRESSO_PREC||w_sep||
              decode(P_cod_eve,4,'',DES_CONSOLATO_1_PREC)||w_sep||
              decode(p_cod_eve,4,'',DES_CONSOLATO_2_PREC)||w_sep||
              decode(p_cod_eve,4,'',DES_CONSOLATO_3_PREC)||w_sep||
              DES_NAZIONALITA_PREC||w_sep||DATA_INIZIO_NAZ_PREC||w_sep||
              DES_STATO_CIV_PREC||w_sep||
              COD_FISCALE_PREC||w_sep||DES_COD_FISCALE_PREC,
    -- riga_dati_civ (4-1)          
              STATO_CIVILE||w_sep||COGNOME_NOME_CN||w_sep||DATA_MAT_VED||w_sep||ATTO_MAT_VED,
    -- riga_dati_eve (3-1)          
              DATA_EVE||w_sep||DES_COM_EVE||w_sep||PRATICA_EDIT,
    -- riga_dati_1 (49-1)          
              COGNOME_NOME||w_sep||SESSO||w_sep||DI_SESSO||w_sep||DATA_NAS_EDIT||w_sep||DES_COM_NAS||w_sep||
              ATTO_NAS||w_sep||RAPPORTO_PAR||w_sep||NAZIONALITA||w_sep||STATO_CIV||w_sep||
              PATERNITA||w_sep||MATERNITA||w_sep||
              COD_VIA||w_sep||DES_COD_VIA_CHIUSURA||w_sep||
              decode(p_modello,'CRU',substr(DES_COD_VIA,13),DES_COD_VIA)||w_sep||
              INDIRIZZO_EMI||w_sep||
              TIT_STUDIO||w_sep||TITOLO_STUDIO||w_sep||COD_PROF||w_sep||DES_COD_PROF||w_sep||
              DES_NAZIONALITA||w_sep||DATA_INIZIO_NAZ||w_sep||
              DES_STATO_CIV||w_sep||PRATICA_EVE||w_sep||ANNO_PRATICA_EVE||w_sep||DATA_REG||w_sep||TESSERA_ELE||w_sep||
              VECCHIA_SEZIONE||w_sep||NUOVO_COD_VIA||w_sep||NUOVO_NUM_CIV||w_sep||
              NUOVO_SUFFISSO||w_sep||NUOVO_INTERNO||w_sep||NUOVO_SCALA||w_sep||NUOVO_PIANO||w_sep||
              DATA_REG_EDIT||w_sep||COD_FISCALE||w_sep||DES_COD_FISCALE||w_sep||
              INTESTATARIO||w_sep||COD_VARIAZIONE||w_sep||
              DES_COD_VARIAZIONE||w_sep||VARIAZIONE||w_sep||ISCRITTO_ASC_V||w_sep||ISCRITTO_ASC_R||w_sep||
              ISCRITTO_AGP_S||w_sep||ISCRITTO_AGP_P||w_sep||ISCRITTO_APS||w_sep||ZIPCODE_IAI||w_sep||
              decode(P_cod_eve,4,des_consolato_1_prec,DES_CONSOLATO_1_MOV)||w_sep||
              decode(p_cod_eve,4,des_consolato_2_prec,DES_CONSOLATO_2_MOV)||w_sep||
              decode(p_cod_eve,4,des_consolato_3_prec,DES_CONSOLATO_3_MOV),
-- riga_dati_aire (8-1)             
              decode(p_modello,'EMI',nvl(DES_COM_ISCR_AIRE,DES_COM_EVE),
                     decode(des_com_iscr_aire,null,'',' (A.I.R.E. di '||DES_COM_ISCR_AIRE||')'))||w_sep||
              decode(des_com_iscr_aire,null,'',' (A.I.R.E. di '||DES_COM_ISCR_AIRE||')')||w_sep||VIA_AIRE||w_sep||
              DES_VIA_AIRE||w_sep||DES_COM_AIRE_IAI||w_sep||DES_COM_AIRE||w_sep||PROVINCIA_CONTEA||w_sep||PRESSO,
-- riga_dati_ele (7-1)             
              STATO_ELE||w_sep||LISTA_GEN||w_sep||SEZIONE||w_sep||LISTA_SEZ||w_sep||FASCICOLO||w_sep||ANNO||w_sep||
              DES_TIPO_LISTA||w_sep||
              LISTA_AGG_C||w_sep||LISTA_GEN_C||w_sep||SEZIONE_C||w_sep||LISTA_SEZ_C||w_sep||
              FASCICOLO_C||w_sep||ANNO_C||w_sep||TESSERA_ELE_C||w_sep||
              LISTA_AGG_E||w_sep||LISTA_GEN_E||w_sep||SEZIONE_E||w_sep||LISTA_SEZ_E||w_sep||
              FASCICOLO_E||w_sep||ANNO_E||w_sep||TESSERA_ELE_E||w_sep||
              LISTA_AGG_T||w_sep||LISTA_GEN_T||w_sep||SEZIONE_T||w_sep||LISTA_SEZ_T||w_sep||
              FASCICOLO_T||w_sep||ANNO_T||w_sep||TESSERA_ELE_T||w_sep||
              LISTA_AGG_V||w_sep||LISTA_GEN_V||w_sep||SEZIONE_V||w_sep||LISTA_SEZ_V||w_sep||
              FASCICOLO_V||w_sep||ANNO_V||w_sep||TESSERA_ELE_V||w_sep||
              LISTA_AGG_B||w_sep||LISTA_GEN_B||w_sep||SEZIONE_B||w_sep||LISTA_SEZ_B||w_sep||
              FASCICOLO_B||w_sep||ANNO_B||w_sep||TESSERA_ELE_B,
-- riga_dati_ente (6-1)             
              w_sep||w_sep||w_sep||w_sep||w_sep,--ENTE_EMISSIONE;DES_ENTE_EMISSIONE;INDIRIZZO_ENTE;DES_COM_ENTE;CAP_COMUNE_ENTE;INTESTAZIONE_INPS
              pratica_edit,anno_pratica_eve,pratica_eve,
              nuovo_cod_via,nuovo_num_civ,nuovo_suffisso,data_nas,cod_variazione,sesso,
              vecchia_sezione,cod_fiscale_prec,cod_fiscale,stato_ele,
              NAZIONALITA,NAZIONALITA_PREC,stato_civ, stato_civ_prec,
-- riga_dati_ente_dest (3-1)            
              w_sep||w_sep,
              terminalista_mov,
              des_consolato_1_mov, des_consolato_2_mov, des_consolato_3_mov,
              des_consolato_1_prec, des_consolato_2_prec, des_consolato_3_prec,
-- riga_dati_5
              'Distintivo Iscrizione : '||matricola_aire||w_sep||
              'Foglio di Famiglia    : '||cod_fam_aire,
-- riga_dati_leva
              MATRICOLA_MILITARE||w_sep||CLASSE_LEVA||w_sep||NUMERO_LISTA||w_sep||
              DES_ESITO||w_sep||DES_COM_LEVA||w_sep||DES_COM_DISTRETTO||w_sep||      
              DATA_ARRUOLAMENTO||w_sep||DATA_CHIAMATA||w_sep||DATA_CONGEDO||w_sep||
              DES_ARMA||w_sep||DES_CORPO||w_sep||FORZA||w_sep||DES_GRADO,
-- w_matricola_aire
              matricola_aire,
-- w_cod_fam_aire
              cod_fam_aire,
-- w_data_eve_j
              to_char(to_date(data_eve,'dd/mm/yyyy'),'j'), 
              cap_com_eve, des_com_eve
      into riga_dati_0,riga_dati_prec,riga_dati_civ,riga_dati_eve,
           riga_dati_1,riga_dati_aire,riga_dati_ele,riga_dati_ente,
           w_pratica_edit,w_anno_pratica_eve,w_pratica_eve,
           w_nuovo_cod_via,w_nuovo_num_civ,w_nuovo_suffisso,w_data_nas,
           w_cod_variazione,w_sesso,w_vecchia_sezione,
           w_cod_fiscale_prec,w_cod_fiscale,w_stato_ele,
           w_nazionalita,w_nazionalita_prec,
           w_stato_civ, w_stato_civ_prec,
           riga_dati_ente_dest,
           w_terminalista_mov,
           w_des_consolato_1_mov, w_des_consolato_2_mov, w_des_consolato_3_mov,
           w_des_consolato_1_prec, w_des_consolato_2_prec, w_des_consolato_3_prec,
           riga_dati_5,riga_dati_leva,
           w_matricola_aire, w_cod_fam_aire,w_data_eve_J,
           w_cap_com_eve, w_des_com_eve
      from anawmo
     where anno_progr_mov     = p_anno_progr_mov
       and numero_progr_mov   = p_numero_progr_mov
       and matricola          = p_matricola
     ;
  exception
      when no_data_found then
            riga_dati_0         := w_sep||w_sep;
            riga_dati_prec      := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
            riga_dati_civ       := w_sep||w_sep||w_sep;
            riga_dati_eve       := w_sep||w_sep;
            riga_dati_1         := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep; 
            riga_dati_aire      := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
            riga_dati_ele       := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep;
            riga_dati_ente      := w_sep||w_sep||w_sep||w_sep||w_sep;
            riga_dati_ente_dest := w_sep||w_sep;
            w_terminalista_mov  := '';
            riga_dati_5         := w_sep;
            riga_dati_leva      := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep;
            p_errore := '0-(Dati incompleti riga 0('||SQLERRM||')';
    when others then
            riga_dati_0         := w_sep||w_sep;
            riga_dati_prec      := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
            riga_dati_civ       := w_sep||w_sep||w_sep;
            riga_dati_eve       := w_sep||w_sep;
            riga_dati_1         := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep; 
            riga_dati_aire      := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
            riga_dati_ele       := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep;
            riga_dati_ente      := w_sep||w_sep||w_sep||w_sep||w_sep;
            riga_dati_ente_dest := w_sep||w_sep;
            w_terminalista_mov  := '';
            riga_dati_5         := w_sep;
            riga_dati_leva      := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep;
  end;
    
--sel_anaa01
        if p_cod_mov not in (12,13,3,4) and p_cod_eve != 4 then
             protocollo_aire     := null;
             des_protocollo_aire := null;
             iniziativa_aire     := null;
             w_des_cons1         := null;
             w_des_cons2         := null;
             w_des_cons3         := null;

        elsif p_cod_mov = 4 or p_cod_eve = 4 or (p_cod_mov = 3 and p_cod_eve != 52) then
      begin
          SELECT nvl(w_des_consolato_1_prec,w_des_consolato_1_mov),
                 nvl(w_des_consolato_2_prec,w_des_consolato_2_mov),
                 nvl(w_des_consolato_3_prec,w_des_consolato_3_mov),
                 nvl(w_matricola_aire,ana.matricola_aire)
          into   w_des_cons1, w_des_cons2, w_des_cons3, w_matricola_aire
          FROM anaana ana
         where ana.matricola    = p_matricola
        ;
      exception
            when others then
                 w_des_cons1         := nvl(w_des_consolato_1_prec,w_des_consolato_1_mov);
                 w_des_cons2         := nvl(w_des_consolato_2_prec,w_des_consolato_2_mov);
                 w_des_cons3         := nvl(w_des_consolato_3_prec,w_des_consolato_3_mov);
            end;

      if p_cod_mov = 3 then       
              begin
                  select 'Protocollo A.I.R.E. '||decode(a0m.protocollo_aire,'','_____',a0m.protocollo_aire)||'/'||a0m.anno_protocollo_aire,
                         'Distintivo Iscrizione : '||nvl(w_matricola_aire,a0m.matricola_aire)||w_sep||
                         'Foglio di Famiglia    : '||w_cod_fam_aire,
                          null
                    into protocollo_aire, riga_dati_5, iniziativa_aire
                    from anaa0m a0m
                   where a0m.matricola                = p_matricola
                     and a0m.anno_protocollo_aire||lpad(a0m.protocollo_aire,6,'0') = 
                         (select max(b.anno_protocollo_aire||lpad(b.protocollo_aire,6,'0'))
                            from anaa0m b, anaa01 a01
                           where b.matricola                      = a0m.matricola
                             and b.matricola_aire              is not null
                             and a01.anno_protocollo_aire = a0m.anno_protocollo_aire
                             and a01.protocollo_aire         = a0m.protocollo_aire
                             and a01.data_decorrenza     <= w_data_eve_j)
                      ;
              exception
                when others then 
                     protocollo_aire := 'Protocollo A.I.R.E. '||nvl(to_char(p_pratica),'_____')||' / '||nvl(to_char(p_anno_pratica),'_____');
                     riga_dati_5     := 'Distintivo Iscrizione : '||nvl(w_matricola_aire,'____________')||w_sep||
                                        'Foglio di Famiglia    : '||w_cod_fam_aire;
                     iniziativa_aire := null;
                 end;
      else
              begin
                  select 'Protocollo A.I.R.E. '||decode(c0m.protocollo_aire,'','_____',c0m.protocollo_aire)||'/'||c0m.anno_protocollo_aire,
                         'Distintivo Iscrizione : '||nvl(w_matricola_aire,c0m.matricola_aire)||w_sep||
                             'Foglio di Famiglia    : '||w_cod_fam_aire,
                             null
                        into protocollo_aire, riga_dati_5, iniziativa_aire
                        from anac0m c0m
                       where c0m.matricola                = p_matricola
                         and c0m.anno_protocollo_aire||lpad(c0m.protocollo_aire,6,'0') = 
                               (select max(b.anno_protocollo_aire||lpad(b.protocollo_aire,6,'0'))
                                  from anac0m b, anac01 c01
                                 where b.matricola                      = c0m.matricola
                                   and b.matricola_aire              is not null
                                   and c01.anno_protocollo_aire = c0m.anno_protocollo_aire
                                   and c01.protocollo_aire         = c0m.protocollo_aire
                                   and c01.data_decorrenza     <= w_data_eve_j)
                      ;
              exception
                when others then 
                     protocollo_aire := 'Protocollo A.I.R.E. '||nvl(to_char(p_pratica),'_____')||' / '||nvl(to_char(p_anno_pratica),'_____');
                     riga_dati_5     := 'Distintivo Iscrizione : '||nvl(w_matricola_aire,'____________')||w_sep||
                                              'Foglio di Famiglia    : '||w_cod_fam_aire;
                           iniziativa_aire := null;
              end;
      end if;
        
        elsif p_cod_mov = 3 and p_cod_eve = 52 then
      begin
           SELECT 'Protocollo A.I.R.E. '||to_char(a0m.protocollo_aire)||'/'||a0m.anno_protocollo_aire,
               a01.iniziativa,
               nvl(DECODE(dco.tipo_consolato,'','',0,'All''','Al ')||dco.descrizione,
                    w_des_consolato_1_mov),
               nvl(con.indirizzo,w_des_consolato_2_mov),
               nvl(con.sede,w_des_consolato_3_mov),
               'Distintivo Iscrizione : '||nvl(w_matricola_aire,nvl(a0m.matricola_aire,ana.matricola_aire))||w_sep||
                         'Foglio di Famiglia    : '||w_cod_fam_aire
          into protocollo_aire,iniziativa_aire,w_des_cons1,w_des_cons2,w_des_cons3,
                 riga_dati_5
          FROM ARCDCO dco,ARCCON con,ANAA01 a01,ANAA0M a0m, anaana ana
         WHERE dco.tipo_consolato (+) = con.tipo_consolato
           AND con.tipo_consolato (+) = a01.tipo_consolato
           AND con.cod_consolato  (+) = a01.cod_consolato
           AND con.stato          (+) = a01.cod_territorio
           and ana.matricola          = a0m.matricola
           AND a0m.matricola          = p_matricola
           AND a0m.protocollo_aire    = a01.protocollo_aire
           AND a0m.anno_pratica       = a01.anno_pratica
           AND A01.ANNO_PRATICA       = p_anno_pratica
           AND NVL(A01.PRATICA,A01.PROTOCOLLO_AIRE)    = p_pratica
           and rownum = 1
         ORDER BY a01.data_reg DESC
        ;
      exception
              when no_data_found then
                 protocollo_aire     := 'Protocollo A.I.R.E. '||'_____'||'/'||p_anno_pratica;
                 des_protocollo_aire := 'Protocollo A.I.R.E. '||'_____'||'/'||p_anno_pratica;
                 iniziativa_aire     := null;
                 w_des_cons1         := w_des_consolato_1_mov;
                 w_des_cons2         := w_des_consolato_2_mov;
                 w_des_cons3         := w_des_consolato_3_mov;
            when others then
                 protocollo_aire     := null;
                 des_protocollo_aire := null;
                 iniziativa_aire     := null;
                 w_des_cons1         := null;
                 w_des_cons2         := null;
                 w_des_cons3         := null;
                 p_errore := '0-(Errore in ricerca dati 1 ('||SQLERRM||')';
      end;
         
    elsif p_cod_mov in (12,13) then
          protocollo_aire     := 'Protocollo A.I.R.E. '||p_pratica||'/'||p_anno_pratica;
          des_protocollo_aire := 'Protocollo A.I.R.E. '||p_pratica||'/'||p_anno_pratica;
          w_des_cons1         := w_des_consolato_1_mov;
          w_des_cons2         := w_des_consolato_2_mov;
          w_des_cons3         := w_des_consolato_3_mov;
       begin
            SELECT 'Distintivo Iscrizione : '||nvl(w_matricola_aire,ana.matricola_aire)||w_sep||
                   'Foglio di Famiglia    : '||w_cod_fam_aire
              into riga_dati_5
              FROM anaana ana
             where ana.matricola    = p_matricola
            ;
       exception
            when others then
                 riga_dati_5 := 'Distintivo Iscrizione : '||w_matricola_aire||w_sep||
                                'Foglio di Famiglia    : '||w_cod_fam_aire;
       end;
    end if;
    
--sel_comune_data
    begin
        SELECT LPAD(com.cap,5,'0')||w_sep||
               com.descrizione||' ('||com.sigla_provincia||')'||w_sep||
               com.descrizione||' '||TO_CHAR(SYSDATE,'dd/mm/yyyy')||w_sep||
               pro.descrizione||' ('||com.sigla_provincia||')',
               com.cod_provincia , com.cod_comune,
               com.descrizione||' ('||com.sigla_provincia||')',LPAD(com.cap,5,'0')
        into riga_dati_3,w_pro_cliente, w_com_cliente, w_comune,w_cap
        FROM ARCPRO pro,arccom com
       WHERE pro.cod_provincia                    = com.cod_provincia
         AND (com.cod_provincia,com.cod_comune) =
              (SELECT pro_cliente,com_cliente FROM menuditta);
    exception
        when no_data_found then
            riga_dati_3:= w_sep||w_sep||w_sep; --  CAP;COMUNE;COMUNE_DATA;PROVINCIA
          when others then
            riga_dati_3:= w_sep||w_sep||w_sep;
            p_errore := '0-(Errore in ricerca dati 2('||SQLERRM||')';
    end;
    
--sel_enti_inps
      begin
      SELECT 'ALL''ISTITUTO NAZIONALE DELLA PREVIDENZA SOCIALE'||w_sep||
             ANADEN.indirizzo_ente||w_sep||
             decode(ANADEN.CAP_ENTE,'','',ANADEN.CAP_ENTE||' ')||
             decode(ANADEN.COD_PRO_ENTE,'','',
                    bcom.descrizione||' ('||bcom.sigla_provincia||')')
        into riga_dati_4
        FROM arccom bcom,ANADEN
       WHERE bcom.cod_provincia (+)= ANADEN.cod_pro_ente
         AND bcom.cod_comune (+)   = ANADEN.cod_com_ente
         AND anaden.cod_en         = 2
      ;
      exception
          when no_data_found then
            riga_dati_4 := w_sep||w_sep;--    DES_ENTE_EMISSIONE_INPS;INDIRIZZO_ENTE_INPS;CAP_COMUNE_ENTE_INPS
          when others then
            riga_dati_4 := w_sep||w_sep;
            p_errore := '0-(Errore in ricerca dati 3 ('||SQLERRM||')';
      end;
      
      begin
          SELECT DECODE(TO_CHAR(SYSDATE,'mm'),
                         '01',TO_CHAR(TO_DATE('31/12/'||TO_CHAR(SYSDATE,'yyyy'),'dd/mm/yyyy'),'j'),
                         '02',TO_CHAR(TO_DATE('31/12/'||TO_CHAR(SYSDATE,'yyyy'),'dd/mm/yyyy'),'j'),
                         '03',TO_CHAR(TO_DATE('31/12/'||TO_CHAR(SYSDATE,'yyyy'),'dd/mm/yyyy'),'j'),
                         '04',TO_CHAR(TO_DATE('31/12/'||TO_CHAR(SYSDATE,'yyyy'),'dd/mm/yyyy'),'j'),
                         '05',TO_CHAR(TO_DATE('31/12/'||TO_CHAR(SYSDATE,'yyyy'),'dd/mm/yyyy'),'j'),
                         '06',TO_CHAR(TO_DATE('31/12/'||TO_CHAR(SYSDATE,'yyyy'),'dd/mm/yyyy'),'j'),
                         '07',TO_CHAR(TO_DATE('30/06/'||TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')+1),
                                'dd/mm/yyyy'),'j'),
                         '08',TO_CHAR(TO_DATE('30/06/'||TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')+1),
                                'dd/mm/yyyy'),'j'),
                         '09',TO_CHAR(TO_DATE('30/06/'||TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')+1),
                                'dd/mm/yyyy'),'j'),
                         '10',TO_CHAR(TO_DATE('30/06/'||TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')+1),
                                    'dd/mm/yyyy'),'j'),
                         '11',TO_CHAR(TO_DATE('30/06/'||TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')+1),
                                'dd/mm/yyyy'),'j'),
                         '12',TO_CHAR(TO_DATE('30/06/'||TO_NUMBER(TO_CHAR(SYSDATE,'yyyy')+1),
                         'dd/mm/yyyy'),'j')),TO_CHAR(SYSDATE,'yyyy')
           into fine_mese_ele,anno_corrente
           FROM dual;
      exception
          when no_data_found then
            fine_mese_ele:= null;
            anno_corrente := null;
          when others then
            fine_mese_ele:= null;
            anno_corrente := null;
            p_errore := '0-(Errore in ricerca dati 4 ('||SQLERRM||')';
      end;

      oggetto := f_SCAW_oggetto(p_cod_eve,p_cod_mov,w_cod_variazione,p_modello,w_pro_cliente,w_com_cliente,w_stato_civ,w_stato_civ_prec,w_nazionalita,w_nazionalita_prec);
      evento  := f_SCAW_evento(p_cod_eve,p_cod_mov,w_sesso,w_cod_variazione,w_nazionalita,w_nazionalita_prec);
      
      begin
          select 'Ricomparso a '||a.descrizione||' ('||a.sigla_provincia||') '||
                           'il '||to_char(to_date(eve.data_ric,'j'),'dd/mm/yyyy')||
                           ' - Pratica '||eve.pratica_ric||'/'||eve.anno_pratica_ric
            into riga_dati_ric
            from arccom a, anaeve eve
           where a.cod_provincia     = eve.cod_pro_ric
             and a.cod_comune        = eve.cod_com_ric
             and eve.matricola       = p_matricola
             and eve.cod_mov         = p_cod_mov
             and eve.cod_eve         = p_cod_eve
             and eve.pratica         = p_pratica
             and eve.anno_pratica    = p_anno_pratica
             and eve.data_ric        = p_data_reg
             and eve.cod_pro_ric     is not null
             and rownum = 1
          ;    
      exception
          when others then
               riga_dati_ric := '';
      end;
      
      begin
          SELECT DECODE(p_cod_eve,2,'da',
                        3,'da',4,'da',
                        7,'da',50,'a',
                        51,'a',52,'a',
                        55,'a',56,'a',93,'a',94,'a','')
            into da_a
            FROM dual;
      exception 
          when others then
            da_a := null;
      end;

--sel_anatri  (vedere quando eseguirlo)
     begin
          SELECT 'S',cod_contribuente
            into flag_contribuente,cod_contribuente
            FROM anatri
           WHERE matricola    = p_matricola
             ;
     exception
          when others then
            flag_contribuente := '';
            cod_contribuente  := '';--COD_CONTRIBUENTE
     end;
          
-- sel_nuova_sezione   
       begin
        SELECT sezione
          into nuova_sezione
          FROM ELEDSS
         WHERE cod_via = w_nuovo_cod_via
           AND LPAD(w_nuovo_num_civ,6,' ')||NVL(w_nuovo_suffisso,' ')
               BETWEEN LPAD(civico_inf,6,' ')||NVL(suffisso_inf,' ')
                   AND LPAD(civico_sup,6,' ')||NVL(suffisso_sup,' ')
           AND (pari_dispari = DECODE(MOD(w_nuovo_num_civ,2),1,'D','P') OR
                pari_dispari IS NULL)
        ;
       exception
            when others then
              nuova_sezione:= null;--NUOVA_SEZIONE
       end;
       
--cap_comune_dst
       begin
            SELECT DECODE(INSTR(ANADST.descrizione,' '),0,
                      ANADST.descrizione||' '||w_comune,
                      ANADST.descrizione)
         into cap_comune_dst
         FROM ANADST,ANASTE
        WHERE ANADST.cod_ut         = ANASTE.cod_ut
          AND ANADST.cod_st         = ANASTE.cod_st
          AND ANASTE.cod_ut     = 99
          AND ANASTE.cod_via     = w_nuovo_cod_via
          AND LPAD(w_nuovo_num_civ,6,' ')||w_nuovo_suffisso
               BETWEEN LPAD(ANASTE.civico_inf,6,' ')||
                            ANASTE.suffisso_inf
                   AND LPAD(ANASTE.civico_sup,6,' ')||
                            NVL(ANASTE.suffisso_sup,'}}}')
          AND (ANASTE.pari_dispari = DECODE(MOD(w_nuovo_num_civ,2),1,'D','P') OR
               ANASTE.pari_dispari IS NULL)
       ;
     exception  
       when others then
              cap_comune_dst:= null;--CAP_COMUNE_DST
     end;

--sel_posta
      begin
      SELECT DISTINCT ufficio_postale||w_sep||SUBSTR(dup.descrizione,1,35)
        into riga_dati_6
        FROM ANADUP dup,ANADCA dca,ANADEN den,ANADOC
       WHERE dup.cod_up (+)          = ufficio_postale
         AND dca.descrizione     LIKE '%INV%CIV%'    
         AND cod_ca                      = categoria
         AND cod_en                = ente_emissione
         AND natura_documento      = 'O'
         AND ANADOC.tipo_documento              = 'LP'
         AND matricola             = p_matricola
         and rownum = 1;
     exception
              when no_data_found then
            riga_dati_6:= w_sep;--UFFICIO_POSTALE;DES_UFFICIO_POSTALE
          when others then
            riga_dati_6:= w_sep;
            p_errore := '1- (Errore in ricerca dati 6 ('||SQLERRM||')';
     end;
     
--PRATICA;ANNO_PRATICA;AL_SIG;AL_SIGNOR;CAP_COMUNE
     begin
       select p_pratica||w_sep||p_anno_pratica||w_sep||
              decode(w_sesso,'M','Al Sig.'||w_sep||'Al Signor'||w_sep,'Alla Sig.ra'||w_sep||'Alla Signora'||w_sep)
              ||nvl(cap_comune_dst,' '||w_cap||' '||w_comune)
         into riga_dati_7
         from dual;
     exception
          when others then
            riga_dati_7 := w_sep||w_sep||w_sep||w_sep;
     end;

--sel_individui
     begin
        SELECT 1,'unitamente alla famiglia,'
          into w_flag_individui,w_individui
          FROM dual
         WHERE 1 < (SELECT COUNT(*)
                      FROM ANAMOV
                     WHERE DECODE(cod_eve,3,2,cod_eve) =
                           DECODE(p_cod_eve,3,2,p_cod_eve)
                       AND cod_mov      = p_cod_mov
                       AND pratica      = w_pratica_eve
                       AND anno_pratica = w_anno_pratica_eve
                       AND data_reg     = p_data_reg)
        ;
     exception
          when others then
            w_individui := null;
            w_flag_individui := null;
     end;  
     
--intest_iai
     if  ADD_MONTHS(TO_DATE(w_data_nas,'j'),216) <= TO_DATE(fine_mese_ele,'j') THEN
       intest_iai := 'Circa il godimento dei diritti elettorali si precisa che Ella ';
       if p_cod_eve = 52 then
            intest_iai := intest_iai||'rester ';
       else
            intest_iai := intest_iai||'verr ';
       end if;
       intest_iai := intest_iai||' iscritta nelle liste elettorali di questo Comune senza limiti di tempo,'||
                    ' sempre che conservi i requisiti per essere elettore. Tale iscrizione Le da'''||
                    ' il diritto di partecipare a tutte le consultazioni elettorali italiane. '||
                    'Affinch  per  Ella possa ricevere tempestiva notizia della data di ogni '||
                    'consultazione ed i documenti per fruire delle agevolazioni di legge per la '||
                    'effettiva partecipazione al voto,   pregata di voler inviare al Comune scrivente, '||
                    'per il tramite dell''autorit  consolare italiana competente, comunicazione di '||
                    'variazione di indirizzo.';
     else
          intest_iai := null;
     end if;
     
--sel-data_nas0_edit
     begin
       SELECT decode(ana.sesso,'F','nata il ','nato il ')||
                  '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy')
         into data_nas0_edit
         from anaana ana
        where ana.anno_nas     = 'S'
          and ana.matricola    = p_matricola
       ;
     exception
          when others then
                     begin
                     SELECT decode(w_sesso,'F','nata il ','nato il ')||
                          to_char(to_date(w_data_nas,'j'),'dd/mm/yyyy')
                         into data_nas0_edit
                         from dual
                     ;
                     exception
                         when others then
                                data_nas0_edit := null;
                   end;
     end;
     
    if p_modello = 'ELE' then
      
      if p_cod_mov NOT in (11,13,97,98) then
         riga_dati_prec := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                           w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                           w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                           w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                           w_sep;
      end if;
      
      if p_cod_eve not in (93,94,97) then
                   null;
      else
         riga_dati_eve := w_sep||w_sep;
         riga_dati_aire:= w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
         da_a          := null;
         evento        := null;
      end if;
      
      if p_cod_eve in (50,51,53,54,55,56,57,90,93,94,97,99) then
          null;
      else
          if w_des_via_aire is not null then
              null;
          else
            if nvl(w_vecchia_sezione,0) != nvl(nuova_sezione,0) then
                if nuova_sezione is not null then
                    w_nuova_sezione := 'NUOVA SEZIONE: '||nuova_sezione;
                else
                    w_nuova_sezione := 'La nuova residenza non   associata a nessuna sezione.';
                end if;
              end if;
          end if;
      end if;

    elsif  p_modello in ('ENT') then    
--SEL_ENTI
     begin
          SELECT ente_emissione||w_sep||-- ENTE_EMISSIONE,
              MAX(DECODE(ente_emissione,'2','ALL''ISTITUTO NAZIONALE DELLA PREVIDENZA SOCIALE',
              'AL '||RPAD(ANADEN.descrizione,(74 - LENGTH(ANADEN.descrizione)),' ')))||w_sep||-- DES_ENTE_EMISSIONE,
              DECODE(ANADOC.cod_pro_ente,'','','di '||com.descrizione||
                 ' ('||com.sigla_provincia||')')||w_sep||-- DES_COM_ENTE,
              MAX(ANADEN.indirizzo_ente)||w_sep||-- INDIRIZZO_ENTE,
              MAX(decode(ANADEN.CAP_ENTE,'','',ANADEN.CAP_ENTE||' '))||MAX(decode(ANADEN.COD_PRO_ENTE,'','',
                      bcom.descrizione||' ('||bcom.sigla_provincia||')'))||w_sep|| --CAP_COMUNE_ENTE
                    'ALL''ISTITUTO NAZIONALE DELLA PREVIDENZA SOCIALE' --INTESTAZIONE_INPS
         INTO riga_dati_ente
         FROM arccom com,arccom bcom,ANADEN,ANADOC
        WHERE com.cod_provincia (+) = ANADOC.cod_pro_ente
          AND com.cod_comune         (+) = ANADOC.cod_com_ente
          AND bcom.cod_provincia(+)    = ANADEN.cod_pro_ente
          AND bcom.cod_comune     (+) = ANADEN.cod_com_ente
          AND anaden.cod_en         = anadoc.ente_emissione
          AND anadoc.tipo_documento    = 'LP'
          AND anadoc.matricola      = p_matricola
          and ente_emissione        = p_ente_lp
          and rownum = 1
       GROUP BY ente_emissione,
               DECODE(ANADOC.cod_pro_ente,'','','di '||com.descrizione||' ('||com.sigla_provincia||')');
     exception
          when no_data_found then
              riga_dati_ente := w_sep||w_sep||w_sep||w_sep||w_sep;
            when others then
              riga_dati_ente := w_sep||w_sep||w_sep||w_sep||w_sep;
              p_errore := '1-(Errore in ricerca dati  inps('||SQLERRM||')';
     end;    

     elsif  p_modello = 'LEV' then    
        if p_cod_mov not in (11,13,97,98) then
           riga_dati_prec := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep;
        end if;

     elsif p_modello = 'PRE' then
        if protocollo_aire is null then
           des_protocollo_aire := 'Protocollo A.I.R.E. _____ /'||p_anno_pratica;
        else
           des_protocollo_aire := protocollo_aire;
        end if;
        if w_des_cons1 is null then
           w_des_cons1:= nvl(w_des_cons1_mov,'Al Consolato');
           w_des_cons2:= null;
           w_des_cons3:= null;
        end if;

     elsif p_modello = 'QUE' then
        if p_cod_mov not in (11,13,97,98) then
           riga_dati_prec := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep;
        end if;

     elsif p_modello = 'TRB' then
        if w_cod_fiscale_prec is not null then
           evento := '';
           da_a := '';
           riga_dati_eve := w_sep||w_sep;
        end if;

     elsif p_modello = 'IMM' then
       cap_comune_dst := nvl(cap_comune_dst,' '||w_cap||' '||w_comune);

     elsif p_modello = 'IAI' then
          if protocollo_aire is null then
           des_protocollo_aire := '(Protocollo A.I.R.E. _____ /'||p_anno_pratica||')';
       else
         des_protocollo_aire := '('||protocollo_aire||')';
       end if;
     end if;
    
     begin
          select decode(p_stampa_terminalista,'SI',P_nome_terminalista,null)
            into terminalista
            from dual;
     exception
          when others then
            terminalista :=null;
     end;

     begin
          select ltrim(f_valore_inp('SCAN_'||p_modello,8,2,'9',''),'0')
            into w_ente_dest
            from dual
          ;
     exception
          when others then
                  w_ente_dest := 0;
     end;
     
         if nvl(w_ente_dest,0) > 0 and p_modello not in ('ENT') then
        begin
             select den.descrizione||w_sep||
                          den.indirizzo_ente||w_sep||
                          lpad(den.cap_ente,5,'0')||' '||a.descrizione||' ('||a.sigla_provincia||')'
                 into riga_dati_ente_dest
                 from arccom a, anaden den
              where a.cod_provincia (+)  = den.cod_pro_ente
                and a.cod_comune    (+)  = den.cod_com_ente
                and den.cod_en           = w_ente_dest
             ;
        exception
            when others then
                 riga_dati_ente_dest := w_sep||w_sep;
        end;
         elsif p_modello in ('EMI') then
        begin
             select ''||w_sep||''||w_sep||
                    lpad(w_cap_com_eve,5,'0')||' '||w_des_com_eve
               into riga_dati_ente_dest
               from dual
             ;
        exception
            when others then
                 riga_dati_ente_dest := w_sep||w_sep;
        end;
     else
          riga_dati_ente_dest := w_sep||w_sep;
     end if;
     
     if terminalista is not null then
        w_firma_omessa := f_get_firma_omessa('SCAW','ANA_FIRMA');
     else
        w_firma_omessa := '';
     end if;

     if w_terminalista_mov is not null then
        w_firma_omessa_term_mov := f_get_firma_omessa('SCAW','ANA_FIRMA');
     else
        w_firma_omessa_term_mov := '';
     end if;

     p_valori_finali:= riga_dati_0||w_sep||riga_dati_prec||w_sep||riga_dati_civ||w_sep||
                     riga_dati_eve||w_sep||riga_dati_1||w_sep||riga_dati_aire||w_sep||
                     riga_dati_ele||w_sep||riga_dati_ente||w_sep||
                     protocollo_aire||w_sep||des_protocollo_aire||w_sep||iniziativa_aire||w_sep||
                     w_des_cons1||w_sep||w_des_cons2||w_sep||w_des_cons3||w_sep||
                     riga_dati_3||w_sep||riga_dati_4||w_sep||
                     fine_mese_ele||w_sep||anno_corrente||w_sep||
                     riga_dati_5||w_sep||riga_dati_leva||w_sep||
                     oggetto||w_sep||evento||w_sep||da_a||w_sep||riga_dati_ric||w_sep||
                     riga_dati_6||w_sep||cod_contribuente||w_sep||
                     w_nuova_sezione||w_sep||cap_comune_dst||w_sep||riga_dati_7||w_sep||
                     riga_dati_ente_dest||w_sep||
                     w_individui||w_sep||intest_iai||w_sep||data_nas0_edit||w_sep||
                     terminalista||w_sep||w_firma_omessa||w_sep||
                     w_terminalista_mov||w_sep||w_firma_omessa_term_mov||w_sep||
                     'LOGO_ANA'||w_sep||
                     'FAM_1_'||p_anno_progr_mov||lpad(p_numero_progr_mov,7,'0')||w_sep||
                     'FAM_2_'||p_anno_progr_mov||lpad(p_numero_progr_mov,7,'0')||w_sep||
                     'FAM_3_'||p_anno_progr_mov||lpad(p_numero_progr_mov,7,'0')||w_sep||
                     'FAM_4_'||p_anno_progr_mov||lpad(p_numero_progr_mov,7,'0')||w_sep||
                     'FAM_5_'||p_anno_progr_mov||lpad(p_numero_progr_mov,7,'0')||w_sep||
                     'DOC_1_'||p_matricola||w_sep||
                     'DOC_CI_1_'||p_matricola||w_sep||
                     'DOC_LP_1_'||p_matricola
                     ;
      begin
           SELECT 1
             into doc_app
             from ANADOC
          where matricola = p_matricola;
      exception
          when no_data_found then
            doc_app := 0;
          when too_many_rows then
            doc_app := 1;
          when others then
            doc_app := 0;
      end;                     
                  
      if doc_app = 1 then
          p_valori_finali := p_valori_finali||w_sep||'DOC_PS_1_'||p_matricola||w_sep||'DOC_PT_1_'||p_matricola;
      else
          p_valori_finali := p_valori_finali||w_sep||w_sep;
      end if;
      
-- urne cinerarie
      p_valori_finali := p_valori_finali||w_sep||'AUC_'||p_matricola;
      
      p_valori_finali     :=  p_valori_finali||w_sep||f_SER_riga_dati(w_sep,'ANA')||w_sep||f_SER_riga_dati(w_sep,'COM')||w_sep||f_SER_riga_dati(w_sep,'URP');
      p_anno_pratica_eve  := w_anno_pratica_eve;
      p_pratica_eve       := w_pratica_eve;
      
END;
/
