--liquibase formatted sql
--changeset amonopoli:202310261315_2 runOnChange:true stripComments:false
create or replace procedure p_CERW_riga_dati 
(p_tipo_archivio     	IN  	number
,p_matricola         	IN  	number
,p_ufficio           	IN  	number
,p_anno              	IN  	number
,p_atto              	IN  	number
,p_parte             	IN  	number
,p_serie             	IN  	varchar2
,p_storico           	IN  	varchar2
,p_data_cert         	IN  	varchar2
,p_cod_certificato   	IN  	varchar2
,p_progr_emissione	IN	number
,p_anno_emissione	IN	number
,p_terminale		IN	varchar2
,p_separatore		IN	varchar2
,p_flag_loop		IN	varchar2
,valori              	IN OUT  varchar2
,riga_cerinc          	IN OUT  varchar2
,riga_libera          	IN OUT  varchar2
,w_fascia            	IN OUT  number
,w_cod_fam           	IN OUT  number
,w_fascia_eve        	IN OUT  number
,w_cod_fam_eve       	IN OUT  number
,p_convenzioni       	IN OUT  varchar2
,w_messaggio_errore  	IN OUT  varchar2
)
   
IS
-- w_messaggio_errore 0 primo carattere : non bloccante
--                    1 primo carattere : bloccante                      
plsqlappoggio                        number;

w_sep			varchar2(255) := nvl(p_separatore,chr(9));

riga_dati_1                   varchar2(2000);
riga_carta_ci                 varchar2(4000);
riga_indirizzo                varchar2(2000);
riga_indirizzo_eve            varchar2(2000);
riga_dati_1bis                varchar2(2000);
riga_dati_2                   varchar2(2000);
riga_dati_albero              varchar2(2000);
riga_famiglia                 varchar2(2000);
riga_famiglia_eve             varchar2(2000);
dir_stato_civile              varchar2(2000);
imp_stato_civile              varchar2(2000);
segreteria                    varchar2(2000);
imp_segreteria                varchar2(2000);
carta_identita                varchar2(2000);
imp_carta_identita            varchar2(2000);
bollo                         varchar2(2000);
imp_bollo                     varchar2(2000);
rimborso_st                   varchar2(2000);
imp_rimborso_st               varchar2(2000);
tipo_firma                    number;
modalita                      number;
flag_in_stampa_zk             varchar2(255);
terminalista                  varchar2(2000);
qualifica                     varchar2(2000);
firma                         varchar2(2000);
modalita_1                    varchar2(2000);
modalita_2                    varchar2(2000);
validita_1                    varchar2(2000);
validita_2                    varchar2(2000);

terminalista_orig             varchar2(255);

w_messaggio                   varchar2(32000);

w_comune_utente               varchar2(255);
--

BEGIN
  if p_tipo_archivio in (0,6) then
      
     w_messaggio := f_CTR_WORD_CER(p_tipo_archivio, p_matricola, '', '', '', '', '');
     
-- Selezione Prima riga dati: riga_dati_1, riga_indirizzo, riga_dati_1bis
-- 'riga_indirizzo' viene tenuta da parte per essere sostituita da 
-- 'riga_inidirizzo_eve' in caso di certificazione storica
      begin
          select   to_char(MATRICOLA)||w_sep||COGNOME_NOME||w_sep||
                   COGNOME||w_sep||NOME||w_sep||
                   COGNOME_NOME_ELE||w_sep||SESSO||w_sep||STATO_CIVILE||w_sep||STATO_CIVILE_CDI||w_sep||
                   NAT_OA||w_sep||CITTADINO_ITALIANO||w_sep||CITTADINANZA||w_sep||INIZIO_CITTADINANZA||w_sep||
                   PATERNITA||w_sep||MATERNITA,
--                   
                   INDIRIZZO||w_sep||INDIRIZZO_INT||w_sep||INIZIO_INDIRIZZO||w_sep||INIZIO_FAMIGLIA,
--                   
                   RESIDENZA||w_sep||INIZIO_RESIDENZA||w_sep||VIA_AIRE||w_sep||COMUNE_AIRE||w_sep||
                   STATO_AIRE||w_sep||ZIPCODE||w_sep||PROVINCIA_CONTEA||w_sep||PRESSO||w_sep||
                   TITOLO_STUDIO||w_sep||PROFESSIONE||w_sep||DATA_NASCITA||w_sep||
                   COMUNE_NASCITA||w_sep||COMUNE_ATTO_NASCITA||w_sep||CAP_COMUNE_ATTO_NASCITA||w_sep||ATTO_NASCITA||w_sep||
                   CONIUGAT_OA||w_sep||COGNOME_NOME_CONIUGE||w_sep||COGNOME_NOME_CONIUGE_CN||w_sep||
                   ESTREMI_NASCITA_CONIUGE||w_sep||ESTREMI_NASCITA_CONIUGE_CN||w_sep||
                   ATTO_NASCITA_CONIUGE||w_sep||INDIRIZZO_CONIUGE||w_sep||RESIDENZA_CONIUGE||w_sep||
                   INIZIO_RESIDENZA_CONIUGE||w_sep||DATA_MORTE_CONIUGE||w_sep||ESTREMI_MAT_VED||w_sep||
                   ATTO_MAT_VED||w_sep||DATA_MATRIMONIO||w_sep||COMUNE_MATRIMONIO||w_sep||
                   COMUNE_ATTO_MATRIMONIO||w_sep||CAP_COMUNE_ATTO_MATRIMONIO||w_sep||
                   ATTO_MATRIMONIO||w_sep||DATA_VEDOVANZA||w_sep||
                   COMUNE_VEDOVANZA||w_sep||COMUNE_ATTO_VEDOVANZA||w_sep||CAP_COMUNE_ATTO_VEDOVANZA||w_sep||
                   ATTO_VEDOVANZA||w_sep||
                   COGNOME_NOME_CV||w_sep||COGNOME_CV||w_sep||NOME_CV||w_sep||
                   ESTREMI_NASCITA_CV||w_sep||ATTO_NASCITA_CV||w_sep||CODICE_FISCALE_CV||w_sep||
                   DATA_INIZIO_CDF||w_sep||COMUNE_INIZIO_CDF||w_sep||PRATICA_INIZIO_CDF||w_sep||
                   DATA_FINE_CDF||w_sep||COMUNE_FINE_CDF||w_sep||PRATICA_FINE_CDF||w_sep||
                   CONTRATTO_CONVIVENZA||w_sep||
                   DECEDUT_OA||w_sep||MORT_OA||w_sep||DATA_MORTE||w_sep||COMUNE_MORTE||w_sep||
                   COMUNE_ATTO_MORTE||w_sep||CAP_COMUNE_ATTO_MORTE||w_sep||
                   ATTO_MORTE||w_sep||CODICE_FISCALE||w_sep||CODICE_FISCALE_VALIDATO||w_sep||
                   to_char(CODICE_FAMIGLIA)||w_sep||to_char(ANNO_CENSIMENTO)||w_sep||
                   to_char(SEZIONE_CENSIMENTO)||w_sep||to_char(FOGLIO_CENSIMENTO)||w_sep||
                   INTESTATARIO_CONVIVENZA||w_sep||
                   ESTREMI_ULTIMO_EVENTO||w_sep||PRATICA_ULTIMO_EVENTO||w_sep||
                   DATA_ULTIMO_EVENTO||w_sep||DATA_RICOMPARSA 
            into riga_dati_1, riga_indirizzo, riga_dati_1bis
            from CERWAN
           where matricola       = p_matricola
             and rownum           = 1
             and w_messaggio    is null
            ;
      exception
           when no_data_found then
                riga_dati_1    := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep;
                riga_indirizzo := w_sep||w_sep||w_sep;
                riga_dati_1bis := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                  w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
               --   alert_message_caution('Dati 1 incompleti (archivio='||to_char(p_tipo_archivio)||')');
               w_messaggio_errore := '0-Dati 1 incompleti (archivio='||to_char(p_tipo_archivio)||')';
            when others then
                 riga_dati_1    := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep;
                 riga_indirizzo := w_sep||w_sep||w_sep;
                 riga_dati_1bis := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                   w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                 w_messaggio_errore := '1-Errore in ricerca dati 1 ('||SQLERRM||')';
          end;
        --alert_message_note(riga_dati_1);
-- Selezione Seconda riga dati: riga_dati_2 e riga_famiglia
-- 'riga_famiglia' viene tenuta da parte per essere sostituita da
-- 'riga_famiglia_eve' in caso di certificazione storica
          begin
            select  COMUNE_RICOMPARSA||w_sep||PRATICA_RICOMPARSA||w_sep||INDIRIZZO_PRECEDENTE||w_sep||ISCRITT_OA||w_sep||
                    INCORS_OA||w_sep||SOTTOSCRITT_OA||w_sep||DIRITTI_POLITICI||w_sep||to_char(SEZIONE)||w_sep||SEDE_SEZIONE||w_sep||
                    INDIRIZZO_SEZIONE||w_sep||PROGR_LISTA_GENERALE||w_sep||to_char(PROGR_LISTA_SEZIONALE)||w_sep||
                    to_char(TESSERA_ELETTORALE)||w_sep||DATA_TESSERA_ELETTORALE||w_sep||INDIRIZZO_ELE||w_sep||FASCICOLO_ELE||w_sep||
                    VERBALE_ELE||w_sep||DATA_VERBALE_ELE||w_sep||ISCRIZIONE_AIRE||w_sep||to_char(CLASSE_LEVA)||w_sep||to_char(NUMERO_LISTA)||w_sep||
                    MATRICOLA_LEVA||w_sep||DISTRETTO_LEVA||w_sep||FERMA||w_sep||ARMA||w_sep||CORPO||w_sep||FORZA_1||w_sep||FORZA_2||w_sep||
                    FORZA_3||w_sep||GRADO||w_sep||COMUNE_LEVA||w_sep||DATA_ARRUOLAMENTO||w_sep||DATA_CHIAMATA||w_sep||DATA_CONGEDO||w_sep|| 
                    ESITO_LEVA||w_sep||NUMERO_CARTA||w_sep||DATA_CARTA||w_sep||COMUNE_CARTA||w_sep||SCADENZA_CARTA||w_sep||
                    NUMERO_LIBRETTO_LAVORO||w_sep||DATA_LIBRETTO_LAVORO||w_sep||COMUNE_LIBRETTO_LAVORO||w_sep||
                    NUMERO_PATENTE||w_sep||NATURA_PATENTE||w_sep||DATA_PATENTE||w_sep||COMUNE_PATENTE||w_sep||
                    CATEGORIA_PATENTE||w_sep||NUMERO_PERMESSO||w_sep||NATURA_PERMESSO||w_sep||DATA_PERMESSO||w_sep||
                    COMUNE_PERMESSO||w_sep||SCADENZA_PERMESSO||w_sep||NUMERO_CARTA_SOGGIORNO||w_sep||NATURA_CARTA_SOGGIORNO||w_sep||
                    DATA_CARTA_SOGGIORNO||w_sep||COMUNE_CARTA_SOGGIORNO||w_sep||SCADENZA_CARTA_SOGGIORNO||w_sep||
                    NUMERO_ATTESTATO_U1||w_sep||NATURA_ATTESTATO_U1||w_sep||DATA_ATTESTATO_U1||w_sep||
                    COMUNE_ATTESTATO_U1||w_sep||SCADENZA_ATTESTATO_U1||w_sep|| NUMERO_ATTESTATO_U2||w_sep||
                    NATURA_ATTESTATO_U2||w_sep||DATA_ATTESTATO_U2||w_sep||COMUNE_ATTESTATO_U2||w_sep||
                    SCADENZA_ATTESTATO_U2||w_sep||
                    NUMERO_CIE||w_sep||NATURA_CIE||w_sep||DATA_CIE||w_sep||COMUNE_CIE||w_sep||SCADENZA_CIE||w_sep||w_sep|| -- FOTO_CIE
                    NUMERO_CI_CIE||w_sep||NATURA_CI_CIE||w_sep||DATA_CI_CIE||w_sep||COMUNE_CI_CIE||w_sep||SCADENZA_CI_CIE||w_sep||
                    CAP_COMUNE_RESIDENZA||w_sep||COMUNE_DATA||w_sep||COMUNE||w_sep||DATA||w_sep||
                    CAP_COMUNE_NASCITA||w_sep||CAP_COMUNE_ULT_EVE||w_sep||CAP_COMUNE_MORTE,
--
                    FAMIGLIA_CONVIVENZA||w_sep||DENOMINAZIONE_CONVIVENZA,
--
                    NUMERO_CARTA_CONIUGE||w_sep||NATURA_CARTA_CONIUGE||w_sep||DATA_CARTA_CONIUGE||w_sep||
                    COMUNE_CARTA_CONIUGE||w_sep||SCADENZA_CARTA_CONIUGE||w_sep||
                    NUMERO_CIE_CONIUGE||w_sep||NATURA_CIE_CONIUGE||w_sep||DATA_CIE_CONIUGE||w_sep||
                    COMUNE_CIE_CONIUGE||w_sep||SCADENZA_CIE_CONIUGE||w_sep||
                    NUMERO_CI_CIE_CONIUGE||w_sep||NATURA_CI_CIE_CONIUGE||w_sep||
                    DATA_CI_CIE_CONIUGE||w_sep||COMUNE_CI_CIE_CONIUGE||w_sep||SCADENZA_CI_CIE_CONIUGE||w_sep||
                    TIPO_CONSOLATO||w_sep||INDIRIZZO_CONSOLATO||w_sep||SEDE_CONSOLATO||w_sep||
                    DATA_INIZIO_TEMP||w_sep||DATA_FINE_TEMP||w_sep||COMUNE_TEMP||w_sep||INDIRIZZO_TEMP
              into riga_dati_2, riga_famiglia, riga_carta_ci
              from CERWAN
             where matricola         = p_matricola
               and rownum             = 1
               and w_messaggio    is null
            ;
          exception
              when no_data_found then
                if p_tipo_archivio =6 then
                    begin 
                      select w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             a.descrizione||' '||to_char(sysdate,'dd/mm/yyyy')||w_sep||
                             a.descrizione||w_sep||to_char(sysdate,'dd/mm/yyyy')||w_sep||w_sep||w_sep||w_sep
                into riga_dati_2
                from arccom a, menuditta
               where a.COD_PROVINCIA = pro_cliente
                 and a.COD_COMUNE = com_cliente;
                    end;
                else
                riga_dati_2:= w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                              w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                              w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                              w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                              w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                              w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                              w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                              w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                              w_sep||w_sep||w_sep||w_sep;
              end if;
              riga_famiglia := w_sep;
              riga_carta_ci := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep;
           w_messaggio_errore := '0-Dati 2 incompleti (archivio='||to_char(p_tipo_archivio)||')';
            when others then
              if p_tipo_archivio =6 then
                    begin 
                      select w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                             a.descrizione||' '||to_char(sysdate,'dd/mm/yyyy')||w_sep||
                             a.descrizione||w_sep||to_char(sysdate,'dd/mm/yyyy')||w_sep||w_sep||w_sep||w_sep
                into riga_dati_2
                from arccom a, menuditta
               where a.COD_PROVINCIA = pro_cliente
                 and a.COD_COMUNE = com_cliente;
                    end;
                else
                riga_dati_2 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep;
              end if;
              riga_famiglia := w_sep;
              riga_carta_ci := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep;
              w_messaggio_errore := '1-Errore in ricerca dati 2 ('||SQLERRM||')';
          end;
            
          begin
              select dta.descrizione||w_sep||dst.descrizione 
                into riga_dati_albero
                from anaalb alb, anadta dta,anadst dst
         where alb.COD_ST (+) = dst.COD_ST
           and alb.cod_ut (+) = dst.cod_ut
           and alb.tipo_albero  = dta.COD_TA
           and alb.matricola = p_matricola
           and rownum = 1
        ;
          exception
              when others then
                riga_dati_albero := w_sep;               
          end;
            
          if p_STORICO is not null then
             begin 
                 select vie.denom_uff||' n. '||eve.num_civ||
                        decode(eve.suffisso,'','','/'||eve.suffisso)||
                          decode(upper(ainp.valore),'N','',
                                     decode(eve.interno,'','',' int.'||eve.interno)||
                                       decode(eve.scala,'','',' S.'||eve.scala)||
                                       decode(eve.piano,'','',' P.'||eve.piano))||w_sep||
                                    vie.denom_uff||' n. '||eve.num_civ||
                        decode(eve.suffisso,'','','/'||eve.suffisso)||
                                 decode(eve.interno,'','',' int.'||eve.interno)||
                                   decode(eve.scala,'','',' S.'||eve.scala)||
                                   decode(eve.piano,'','',' P.'||eve.piano)||w_sep||w_sep
                    into riga_indirizzo_eve
                    from arcinp ainp, arcvie vie, anaeve eve
                   where ainp.parametro    = 'INTERNO'
                       and vie.cod_via            = eve.cod_via
                       and p_data_cert    between eve.data_inizio and eve.data_eve
                       and eve.cod_mov            = 11
                       and eve.matricola        = p_matricola
                UNION
                 select eve.via_aire||
                          ' - '||c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')')||w_sep||
                                    eve.via_aire||
                          ' - '||c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')')||w_sep||w_sep
                    from arccom c, anaeve eve
                   where c.cod_provincia    (+)    = eve.cod_pro_aire
                     and c.cod_comune        (+)    = eve.cod_com_aire
                       and p_data_cert    between eve.data_inizio and eve.data_eve
                       and eve.cod_mov            = 13
                       and eve.matricola        = p_matricola
                ;
             exception
                  when others then 
                    riga_indirizzo_eve:='';
                    begin
               select 1 into plsqlappoggio
                 from anaana
                where data_inizio_res <= p_data_cert
                  and matricola                = p_matricola
               ;
             exception
               when others then
                 riga_indirizzo := w_sep||w_sep||w_sep;
             end;
               end;

             begin 
                 select 1, fam.cod_fam,
                                 decode(fam.tipo_fam,null,'famiglia','convivenza')||w_sep||
                                  decode(fam.tipo_fam,null,to_char(null),'Convivenza: '||fam.convivenza)
                    into w_fascia_eve, w_cod_fam_eve, riga_famiglia_eve
                    from anafam fam, anaeve eve
                   where fam.fascia            in (1,2)
                     and fam.cod_fam          = eve.cod_fam
                     and p_data_cert    between eve.data_inizio and eve.data_eve
                       and eve.cod_mov            = 10
                       and eve.matricola        = p_matricola
                UNION
                 select 3, fam.cod_fam,
                                 decode(fam.tipo_fam,null,'famiglia','convivenza')||w_sep||
                                  decode(fam.tipo_fam,null,to_char(null),'Convivenza: '||fam.convivenza)
                    from anafam fam, anaeve eve
                   where fam.fascia            in (3,4)
                     and fam.cod_fam          = eve.cod_fam
                     and p_data_cert    between eve.data_inizio and eve.data_eve
                       and eve.cod_mov            = 12
                       and eve.matricola        = p_matricola
                ;
             exception
                  when others then 
                  w_fascia_eve:=null;
                  w_cod_fam_eve:=null;
                  riga_famiglia_eve:='';
                  begin
             select 1 into plsqlappoggio
               from anaana
              where data_inizio_fam <= p_data_cert
                and matricola                = p_matricola
               ;
           exception
             when others then
               w_fascia := '';
               w_cod_fam := '';
               riga_famiglia := w_sep;
           end;
               end;

               valori := riga_dati_1||w_sep||nvl(riga_indirizzo_eve,riga_indirizzo)||w_sep||
                         riga_dati_1bis||w_sep||
                         riga_dati_2||w_sep||nvl(riga_famiglia_eve,riga_famiglia)||w_sep||
                         riga_carta_ci||w_sep||riga_dati_albero;
          else

               valori := riga_dati_1||w_sep||riga_indirizzo||w_sep||riga_dati_1bis||w_sep||
                         riga_dati_2||w_sep||riga_famiglia||w_sep||
                         riga_carta_ci||w_sep||riga_dati_albero;
          end if;
          
           begin 
             select fascia, cod_fam
               into w_fascia, w_cod_fam
               from anaana
              where matricola    = p_matricola
              ;
         exception
              when others then
                          null;
         end;

  elsif p_tipo_archivio = 2 then
       
       w_messaggio := f_CTR_WORD_CER(p_tipo_archivio,'',p_ufficio,p_anno,p_atto,p_parte,p_serie);
       
  --    alert_message_note('archivio 2');
          begin
              select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', PARTE_EDIT)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
                     decode(NUMERO_ATTO_ANSC, '', SERIE_EDIT)||w_sep||
                     UFFICIO_ORIG||w_sep||ANNO_ORIG||w_sep||ATTO_ORIG||w_sep||PARTE_ORIG||w_sep||PARTE_ORIG_EDIT||w_sep||
                     SERIE_ORIG||w_sep||SERIE_ORIG_EDIT||w_sep||
                     NUMERO_UNICO_COMUNALE||w_sep||NUMERO_ATTO_ANSC||w_sep||
                     COMUNE_ATTO||w_sep||COGNOME_NOME||w_sep||COGNOME||w_sep||NOME||w_sep||CODICE_FISCALE||w_sep||
                     SECONDO_NOME||w_sep||TERZO_NOME||w_sep||
                     SESSO||w_sep||SESSO_M_F||w_sep||NAT_OA||w_sep||DATA_NASCITA||w_sep||
                     GIORNO_NASCITA||w_sep||GIORNO_NASCITA_LETTERE||w_sep||MESE_NASCITA||w_sep||
                     ANNO_NASCITA||w_sep||ANNO_NASCITA_LETTERE||w_sep||
                     COMUNE_NASCITA||w_sep||
                     ORE||w_sep||ORE_LETTERE||w_sep||MINUTI||w_sep||MINUTI_LETTERE||w_sep||
                     E_MINUTI||w_sep||E_MINUTI_LETTERE||w_sep||DEL_LUOGO_NASCITA||w_sep||
                     DEL_LUOGO_NASCITA_TRUNC||w_sep||LUOGO_NASCITA||w_sep||LUOGO_NASCITA_TRUNC||w_sep||
                     PATERNITA||w_sep||PATERNITA_SOLO_NOME||w_sep||COGNOME_PADRE||w_sep||NOME_PADRE||w_sep||
                     INDIRIZZO_ANA_PAT||w_sep||DATA_NAS_PAT||w_sep||
                     MATERNITA||w_sep||MATERNITA_SOLO_NOME||w_sep||COGNOME_MADRE||w_sep||NOME_MADRE||w_sep||
                     INDIRIZZO_ANA_MAT||w_sep||DATA_NAS_MAT||w_sep||
                     RESIDENZA||w_sep||CAP_RESIDENZA||w_sep||
                     COMUNE_DATA||w_sep||COMUNE||w_sep||DATA,
--                     
                     AUTORITA_PROV||w_sep||COMUNE_PROV||w_sep||FRAZIONE_PROV||w_sep||
                     NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
                     UFFICIALE_PROV||w_sep||QUALIFICA_PROV||w_sep||
                     PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV
              into riga_dati_1, riga_dati_2
              from CERCNA
             where ufficio                 = p_ufficio
                     and nvl(serie,' ') =  nvl(p_serie,' ')
                     and parte                     = p_parte
                     and atto                     = p_atto
                     and anno                     = p_anno
                     and rownum                    = 1
                     and w_messaggio        is null
            ;
          exception
              when no_data_found then
                   riga_dati_1:= w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                   riga_dati_2:= w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                 --alert_message_caution('Dati incompleti (archivio=2)');
                 w_messaggio_errore := '0-Dati incompleti (archivio=2)';
            when others then
                 riga_dati_1:= w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                 riga_dati_2:= w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                 w_messaggio_errore := '1-Errore in ricerca dati  (archivio=2) ('||SQLERRM||')';
          end;
            valori := riga_dati_1||w_sep||riga_dati_2;
              
  elsif p_tipo_archivio = 4 then
       
       w_messaggio := f_CTR_WORD_CER(p_tipo_archivio,'',p_ufficio,p_anno,p_atto,p_parte,p_serie);
       
    --alert_message_note('prima select word_dati');
        begin
                select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', PARTE_EDIT)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', SERIE_EDIT)||w_sep||
                       UFFICIO_ORIG||w_sep||ANNO_ORIG||w_sep||ATTO_ORIG||w_sep||PARTE_ORIG||w_sep||PARTE_ORIG_EDIT||w_sep||
                       SERIE_ORIG||w_sep||SERIE_ORIG_EDIT||w_sep||
                       NUMERO_UNICO_COMUNALE||w_sep||NUMERO_ATTO_ANSC||w_sep||
                       COMUNE_ATTO||w_sep||
                       COGNOME_NOME_SPOSO||w_sep||COGNOME_SPOSO||w_sep||NOME_SPOSO||w_sep||CODICE_FISCALE_SPOSO||w_sep||
                       NATO_IL||w_sep||DATA_NASCITA_SPOSO||w_sep||COMUNE_NASCITA_SPOSO||w_sep||
                       TRIBUNALE_NASCITA_SPOSO||w_sep||ATTO_NASCITA_SPOSO||w_sep||PARTE_NASCITA_SPOSO||w_sep||
                       SERIE_NASCITA_SPOSO||w_sep||ANNO_ATTO_NASCITA_SPOSO||w_sep||ATTO_NASCITA_SPOSO_EDIT||w_sep||
                       COMUNE_ATTO_NASCITA_SPOSO||w_sep||
                       NAZIONALITA_SPOSO||w_sep||
                       RESIDENZA_SPOSO||w_sep||CAP_RESIDENZA_SPOSO||w_sep||
                       INDIRIZZO_ANA_SPOSO||w_sep||
                       COGNOME_NOME_SPOSA||w_sep||COGNOME_SPOSA||w_sep||NOME_SPOSA||w_sep||CODICE_FISCALE_SPOSA||w_sep||
                       NATA_IL||w_sep||DATA_NASCITA_SPOSA||w_sep||COMUNE_NASCITA_SPOSA||w_sep||
                       TRIBUNALE_NASCITA_SPOSA||w_sep||ATTO_NASCITA_SPOSA||w_sep||PARTE_NASCITA_SPOSA||w_sep||
                       SERIE_NASCITA_SPOSA||w_sep||ANNO_ATTO_NASCITA_SPOSA||w_sep||ATTO_NASCITA_SPOSA_EDIT||w_sep||
                       COMUNE_ATTO_NASCITA_SPOSA||w_sep||
                       NAZIONALITA_SPOSA||w_sep||
                       RESIDENZA_SPOSA||w_sep||CAP_RESIDENZA_SPOSA||w_sep||
                       INDIRIZZO_ANA_SPOSA||w_sep||DATA_MATRIMONIO||w_sep||
                       GIORNO_MATRIMONIO||w_sep||GIORNO_MATRIMONIO_LETTERE||w_sep||
                       MESE_MATRIMONIO||w_sep||ANNO_MATRIMONIO||w_sep||ANNO_MATRIMONIO_LETTERE||w_sep||
                       COMUNE_MATRIMONIO||w_sep||
                       RITO||w_sep||COMUNE_DATA||w_sep||COMUNE||w_sep||DATA,
                       CONVENZIONI||w_sep||AUTORITA_PROV||w_sep||COMUNE_PROV||w_sep||FRAZIONE_PROV||w_sep||
                       NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
                       UFFICIALE_PROV||w_sep||QUALIFICA_PROV||w_sep||
                       PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV,
                       CONVENZIONI
             into riga_dati_1, riga_dati_2,p_convenzioni
                 from CERCMA
                where ufficio        = p_ufficio
                  and nvl(serie,' ') = nvl(p_serie,' ')
                  and parte          = p_parte
                  and atto           = p_atto
                  and anno           = p_anno
                  and rownum         = 1
                  and w_messaggio    is null
                    ;
        exception
             when no_data_found then
                riga_dati_1 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep;
                riga_dati_2 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                --alert_message_caution('Dati incompleti (archivio=4)');
                w_messaggio_errore := '0-Dati incompleti (archivio=4)';
           when others then
                riga_dati_1 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep;
                riga_dati_2 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                w_messaggio_errore := '1-Errore in ricerca dati  (archivio=4) ('||SQLERRM||')';
      end;
        valori := riga_dati_1||w_sep||riga_dati_2;
--alert_message_note('dopo select word_dati');
    elsif p_tipo_archivio = 5 then
        
         w_messaggio := f_CTR_WORD_CER(p_tipo_archivio,'',p_ufficio,p_anno,p_atto,p_parte,p_serie);
         
--      alert_message_note('archivio 5');
          begin
                select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', PARTE_EDIT)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', SERIE_EDIT)||w_sep||
                       UFFICIO_ORIG||w_sep||ANNO_ORIG||w_sep||ATTO_ORIG||w_sep||PARTE_ORIG||w_sep||PARTE_ORIG_EDIT||w_sep||
                       SERIE_ORIG||w_sep||SERIE_ORIG_EDIT||w_sep||
                       NUMERO_UNICO_COMUNALE||w_sep||NUMERO_ATTO_ANSC||w_sep||
                       COMUNE_ATTO||w_sep||
                       COGNOME_NOME||w_sep||COGNOME||w_sep||NOME||w_sep||CODICE_FISCALE||w_sep||SESSO||w_sep||SESSO_M_F||w_sep||
                       NAT_OA||w_sep||NAT_OA_IL||w_sep||
                       DATA_NASCITA||w_sep||COMUNE_NASCITA||w_sep||TRIBUNALE_NASCITA||w_sep||RESIDENZA||w_sep||
                       CAP_RESIDENZA||w_sep||INDIRIZZO_ANA||w_sep||
                       DECEDUT_OA||w_sep||MORT_OA||w_sep||DATA_MORTE,
--                       
                       GIORNO_MORTE||w_sep||GIORNO_MORTE_LETTERE||w_sep||MESE_MORTE||w_sep||
                       ANNO_MORTE||w_sep||ANNO_MORTE_LETTERE||w_sep||COMUNE_MORTE||w_sep||
                       ORE||w_sep||ORE_LETTERE||w_sep||MINUTI||w_sep||MINUTI_LETTERE||w_sep||
                       E_MINUTI||w_sep||E_MINUTI_LETTERE||w_sep||
                       MOTIVO_MORTE||w_sep||STATO_CIVILE||w_sep||COGNOME_NOME_CONIUGE||w_sep||
                       COGNOME_CONIUGE||w_sep||NOME_CONIUGE||w_sep||COMUNE_DATA||w_sep||
                       COMUNE||w_sep||DATA||w_sep||TRIBUNALE||w_sep||COMUNE_REGISTRO||w_sep||ANNO_NAS||w_sep||
                       PARTE_NAS||w_sep||SERIE_NAS||w_sep||
                       ATTO_NAS||w_sep||UFFICIO_NAS||w_sep||ATTO_NAS_EDIT||w_sep||
                       PADRE||w_sep||COGNOME_PADRE||w_sep||NOME_PADRE||w_sep||
                       MADRE||w_sep||COGNOME_MADRE||w_sep||NOME_MADRE||w_sep||PROFESSIONE||w_sep||LUOGO_MORTE||w_sep||
                       AUTORITA_PROV||w_sep||COMUNE_PROV||w_sep||FRAZIONE_PROV||w_sep||
                       NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
                       UFFICIALE_PROV||w_sep||QUALIFICA_PROV||w_sep||
                       PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV
            into riga_dati_1, riga_dati_2
                from CERCMO
             where ufficio        = p_ufficio
               and nvl(serie,' ') =  nvl(p_serie,' ')
               and parte          = p_parte
               and atto           = p_atto
               and anno           = p_anno
               and rownum         = 1
               and w_messaggio    is null
                    ;
          exception
               when no_data_found then
                  riga_dati_1 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep;
                  riga_dati_2 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                  --alert_message_caution('Dati incompleti (archivio=5)');
                  w_messaggio_errore := '0-Dati incompleti (archivio=5)';
             when others then
                  riga_dati_1 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep;
                  riga_dati_2 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                                 w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                  w_messaggio_errore := '1-Errore in ricerca dati  (archivio=5) ('||SQLERRM||')';
          end;
            valori := riga_dati_1||w_sep||riga_dati_2;

  elsif p_tipo_archivio = -4 then
       
       w_messaggio := f_CTR_WORD_CER(p_tipo_archivio,'',p_ufficio,p_anno,p_atto,p_parte,p_serie);
       
    --alert_message_note('prima select word_dati');
        begin
                select decode(NUMERO_ATTO_ANSC, '', UFFICIO)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', ANNO)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', to_char(ATTO), NUMERO_ATTO_ANSC)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', PARTE)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', PARTE_EDIT)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', SERIE)||w_sep||
                       decode(NUMERO_ATTO_ANSC, '', SERIE_EDIT)||w_sep||
                       UFFICIO_ORIG||w_sep||ANNO_ORIG||w_sep||ATTO_ORIG||w_sep||PARTE_ORIG||w_sep||PARTE_ORIG_EDIT||w_sep||
                       SERIE_ORIG||w_sep||SERIE_ORIG_EDIT||w_sep||
                       NUMERO_UNICO_COMUNALE||w_sep||NUMERO_ATTO_ANSC||w_sep||
                       COMUNE_ATTO||w_sep||
                       COGNOME_NOME_1||w_sep||COGNOME_1||w_sep||NOME_1||w_sep||CODICE_FISCALE_1||w_sep||
                       NAT_OA_IL_1||w_sep||DATA_NASCITA_1||w_sep||COMUNE_NASCITA_1||w_sep||
                       TRIBUNALE_NASCITA_1||w_sep||ATTO_NASCITA_1||w_sep||PARTE_NASCITA_1||w_sep||
                       SERIE_NASCITA_1||w_sep||ANNO_ATTO_NASCITA_1||w_sep||ATTO_NASCITA_1_EDIT||w_sep||
                       COMUNE_ATTO_NASCITA_1||w_sep||
                       CITTADIN_OA_1||w_sep||NAZIONALITA_1||w_sep||
                       RESIDENZA_1||w_sep||CAP_RESIDENZA_1||w_sep||
                       INDIRIZZO_ANA_1||w_sep||
                       COGNOME_NOME_2||w_sep||COGNOME_2||w_sep||NOME_2||w_sep||CODICE_FISCALE_2||w_sep||
                       NAT_OA_IL_2||w_sep||DATA_NASCITA_2||w_sep||COMUNE_NASCITA_2||w_sep||
                       TRIBUNALE_NASCITA_2||w_sep||ATTO_NASCITA_2||w_sep||PARTE_NASCITA_2||w_sep||
                       SERIE_NASCITA_2||w_sep||ANNO_ATTO_NASCITA_2||w_sep||ATTO_NASCITA_2_EDIT||w_sep||
                       COMUNE_ATTO_NASCITA_2||w_sep||
                       CITTADIN_OA_2||w_sep||NAZIONALITA_2||w_sep||
                       RESIDENZA_2||w_sep||CAP_RESIDENZA_2||w_sep||
                       INDIRIZZO_ANA_2||w_sep||DATA_UNIONE||w_sep||
                       GIORNO_UNIONE||w_sep||GIORNO_UNIONE_LETTERE||w_sep||
                       MESE_UNIONE||w_sep||ANNO_UNIONE||w_sep||ANNO_UNIONE_LETTERE||w_sep||
                       COMUNE_UNIONE||w_sep||
                       TESTIMONE_1||w_sep||
                       NAT_OA_IL_TESTIMONE_1||w_sep||COMUNE_NAS_TESTIMONE_1||w_sep||
                       DATA_NAS_TESTIMONE_1||w_sep||RESIDENZA_TESTIMONE_1||w_sep||CITTADIN_OA_TESTIMONE_1||w_sep||
                       NAZIONALITA_TESTIMONE_1||w_sep||
                       TESTIMONE_2||w_sep||
                       NAT_OA_IL_TESTIMONE_2||w_sep||COMUNE_NAS_TESTIMONE_2||w_sep||DATA_NAS_TESTIMONE_2||w_sep||
                       RESIDENZA_TESTIMONE_2||w_sep||CITTADIN_OA_TESTIMONE_2||w_sep||NAZIONALITA_TESTIMONE_2||w_sep||
                       COMUNE_DATA||w_sep||COMUNE||w_sep||DATA,
                       CONVENZIONI||w_sep||AUTORITA_PROV||w_sep||COMUNE_PROV||w_sep||FRAZIONE_PROV||w_sep||
                       NOTA_RIF||w_sep||ANNO_NOTA_RIF||w_sep||DATA_NOTA_RIF||w_sep||
                       UFFICIALE_PROV||w_sep||QUALIFICA_PROV||w_sep||
                       PROTOCOLLO_PROV||w_sep||ANNO_PROTOCOLLO_PROV||w_sep||DATA_PROTOCOLLO_PROV,
                       CONVENZIONI
             into riga_dati_1, riga_dati_2,p_convenzioni
                 from CERCUC
                where ufficio         = p_ufficio
                  and nvl(serie,' ')  = nvl(p_serie,' ')
                  and nvl(parte,0)    = nvl(p_parte,0)
                  and atto            = p_atto
                  and anno            = p_anno
                  and rownum          = 1
                  and w_messaggio     is null
                    ;
        exception
             when no_data_found then
                riga_dati_1 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                riga_dati_2 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep;
                --alert_message_caution('Dati incompleti (archivio=4)');
                w_messaggio_errore := '0-Dati incompleti (archivio=-4)';
           when others then
                riga_dati_1 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep;
                riga_dati_2 := w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||w_sep||
                               w_sep;
              w_messaggio_errore := '1-Errore in ricerca dati  (archivio=-4) ('||SQLERRM||')';
      end;
        valori := riga_dati_1||w_sep||riga_dati_2;
    end if;

-- Selezione dei diritti
  begin 
    select 
-- stato_civile
           decode(parametri,'',
             decode(cem.stato_civile,'','','Diritti Stato Civ.'),
             decode(substr(parametri,1,8),00000000,'','Diritti Stato Civ.')),
-- imp_stato_civile
           decode(parametri,'',
             decode(cem.stato_civile,'','','Euro '||to_char(cem.stato_civile,'90.00')),
             decode(substr(parametri,1,8),00000000,'','Euro '||lpad(decode(instr(LTRIM(SUBSTR(parametri,1,8),'0'),'.'),
                                                                    0, LTRIM(SUBSTR(parametri,1,8),'0')||'.00',
                                                                    1, '0'||rpad(LTRIM(SUBSTR(parametri,1,8),'0'),3,'0'),
                                                                    2, rpad(LTRIM(SUBSTR(parametri,1,8),'0'),4,'0'),
                                                                    3, rpad(LTRIM(SUBSTR(parametri,1,8),'0'),5,'0')),6))),
-- segreteria
           decode(parametri,'',
             decode(cem.segreteria,'','','Diritti Segreteria'),
             decode(substr(parametri,9,8),00000000,'','Diritti Segreteria')),
-- imp_segreteria
           decode(parametri,'',
             decode(cem.segreteria,'','','Euro '||to_char(cem.segreteria,'90.00')),
             decode(substr(parametri,9,8),00000000,'','Euro '||lpad(decode(instr(LTRIM(SUBSTR(parametri,9,8),'0'),'.'),
                                                                    0, LTRIM(SUBSTR(parametri,9,8),'0')||'.00',
                                                                    1, '0'||rpad(LTRIM(SUBSTR(parametri,9,8),'0'),3,'0'),
                                                                    2, rpad(LTRIM(SUBSTR(parametri,9,8),'0'),4,'0'),
                                                                    3, rpad(LTRIM(SUBSTR(parametri,9,8),'0'),5,'0')),6))),
-- carta_identita
           decode(parametri,'',
             decode(cem.carta_identita,'','','Carta d''Identita`'),
             decode(substr(parametri,17,8),00000000,'','Carta d''Identita`')),
-- imp_carta_identita
           decode(parametri,'',
             decode(cem.carta_identita,'','',to_char(cem.carta_identita,'90.00')),
             decode(substr(parametri,17,8),00000000,'','Euro '||lpad(decode(instr(LTRIM(SUBSTR(parametri,17,8),'0'),'.'),
                                                                     0, LTRIM(SUBSTR(parametri,17,8),'0')||'.00',
                                                                     1, '0'||rpad(LTRIM(SUBSTR(parametri,17,8),'0'),3,'0'),
                                                                     2, rpad(LTRIM(SUBSTR(parametri,17,8),'0'),4,'0'),
                                                                     3, rpad(LTRIM(SUBSTR(parametri,17,8),'0'),5,'0')),6))),
-- bollo
           decode(parametri,'',
             decode(cem.bollo,'','',0,'','Bollo'),
             decode(substr(parametri,25,8),00000000,'','Bollo')),
-- imp_bollo
           decode(parametri,'',
             decode(cem.bollo,'','',0,'',to_char(cem.bollo,'90.00')),
             decode(substr(parametri,25,8),00000000,'','Euro '||lpad(decode(instr(LTRIM(SUBSTR(parametri,25,8),'0'),'.'),
                                                                     0, LTRIM(SUBSTR(parametri,25,8),'0')||'.00',
                                                                     1, '0'||rpad(LTRIM(SUBSTR(parametri,25,8),'0'),3,'0'),
                                                                     2, rpad(LTRIM(SUBSTR(parametri,25,8),'0'),4,'0'),
                                                                     3, rpad(LTRIM(SUBSTR(parametri,25,8),'0'),5,'0')),6))),
-- Rimborso_st
           decode(parametri,'',
             decode(cem.rimborso_st,'','','Rimborso Stampati'),
             decode(substr(parametri,33,8),00000000,'','Rimborso Stampati')),
-- imp_rimborso_st
           decode(parametri,'',
             decode(cem.rimborso_st,'','',to_char(cem.rimborso_st,'90.00')),
             decode(substr(parametri,33,8),00000000,'','Euro '||lpad(decode(instr(LTRIM(SUBSTR(parametri,33,8),'0'),'.'),
                                                                     0, LTRIM(SUBSTR(parametri,33,8),'0')||'.00',
                                                                     1, '0'||rpad(LTRIM(SUBSTR(parametri,33,8),'0'),3,'0'),
                                                                     2, rpad(LTRIM(SUBSTR(parametri,33,8),'0'),4,'0'),
                                                                     3, rpad(LTRIM(SUBSTR(parametri,33,8),'0'),5,'0')),6))),
-- tipo_firma
           nvl(substr(parametri,41,1),dce.tipo_firma),
-- modalita
           nvl(lpad(ltrim(substr(parametri,42,2),'0'),2),cem.modalita_rilascio),
-- terminalista
           nvl(replace(rtrim(substr(parametri,44,30),' '),'\',''),cem.nome_terminalista),
-- qualifica
           nvl(rtrim(substr(parametri,74,30),' '),cem.qualifica_terminalista),
-- modalita_1
           replace(dri.descr_stampa_1,chr(10),' '),
-- modalita_2
           decode(dri.flag_descr_stampa_libera,'S',
             replace(cem.DES_MODALITA_RILASCIO_LIBERA,chr(10),' '),
             replace(dri.descr_stampa_2,chr(10),' ')),
-- validita_1
           replace(dvc.descr_stampa_1,chr(10),' '),
-- validita_2
           replace(dvc.descr_stampa_2,chr(10),' '),
-- terminalista_orig
           cem.terminalista,
-- flag_in_stampa_zk
           cem.flag_terminalista_in_stampa
      into dir_stato_civile, imp_stato_civile, segreteria, imp_segreteria,
           carta_identita, imp_carta_identita, bollo, imp_bollo,
           rimborso_st, imp_rimborso_st,
           tipo_firma, modalita, terminalista, qualifica,
           modalita_1, modalita_2, validita_1, validita_2,
           terminalista_orig,
           flag_in_stampa_zk
      from (select p_anno_emissione anno_emissione, p_progr_emissione progr_emissione, parametri
              from tabrep
             where chiave    = 'CERT'
               and terminale = sys_context('userenv','sessionID')) tabrep,
           cerdvc dvc, cerdce dce, cerdri dri, cercem cem
     where tabrep.anno_emissione  (+) = cem.anno_emissione
       and tabrep.progr_emissione (+) = cem.progr_emissione
       and dvc.cod_vc (+)      = dce.validita
       and dce.cod_certificato = p_cod_certificato
       and dri.cod_ri          = nvl(lpad(ltrim(substr(parametri,42,2),'0'),2),cem.modalita_rilascio)
       and cem.anno_emissione  = p_anno_emissione
       and cem.progr_emissione = p_progr_emissione
   ;
  exception
    when others then
     w_messaggio_errore := '1-Errore in ricerca TABREP ('||SQLERRM||')';
  end;
--dbms_output.put_line('p_cerw_riga_dati  - passato sel_cercem');

  if terminalista_orig = 'ON_LINE' then
     begin
       select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
         into w_comune_utente
         from menuditta
       ;
     exception
       when others then
            w_comune_utente := '000000';
     end;

     if w_comune_utente = '090054' then   -- PALAU
        begin
          select descrizione
               , decode(tipo_firma,3,
                   substr(dns.nome_sindaco,instr(dns.nome_sindaco,'/')+1)||' '||substr(dns.nome_sindaco,1,instr(dns.nome_sindaco,'/')-1),
                   'SABINA CUCCIARI')
               , ''
            into firma, terminalista, qualifica
            from cerdns dns, cerdfi dfi
           where dfi.cod_fi = tipo_firma
          ;
        exception
          when others then
               firma        := null;
               terminalista := null;
               qualifica    := null;
        end;
     else
        begin
          select descrizione
               , substr(dns.nome_sindaco,instr(dns.nome_sindaco,'/')+1)||' '||substr(dns.nome_sindaco,1,instr(dns.nome_sindaco,'/')-1)
               , ''
            into firma, terminalista, qualifica
            from cerdns dns, cerdfi dfi
           where dfi.cod_fi = 3
          ;
        exception
          when others then
               firma        := null;
               terminalista := null;
               qualifica    := null;
        end;
     end if;
  else
     begin
       select descrizione
         into firma
         from cerdfi
        where cod_fi = tipo_firma
       ;
     exception
        when others then
             firma := null;
     end;
--
-- 12/06/2024 (AM)
-- viene ri-eseguita la select del nome del terminalista, xchè il dato registrato in tabrep ha un limite di 30 caratteri
-- il nome del terminalista, invece potrebbe anche superare questo limite.
-- viene però controllato se il terminsalista (che arriva dalla tabrep) è valorizzato o meno.
-- nel caso non fosse valorizzato, vuole dire che a maschera è stato scelto di NON stampare il nome.
-- per cui la nuova select da CERDTE viene eseguita solo se il terminalista registrato in tabrep è valorizzato
--
     if rtrim(replace(terminalista,'\','')) is not null and flag_in_stampa_zk is null then
        begin
          select nome||' '||cognome
            into terminalista
            from cerdte
           where cod_utente = terminalista_orig
             and rownum = 1
          ;
        exception
          when others then
               null;
        end;

     elsif flag_in_stampa_zk = 'N' then
        terminalista := '';
        qualifica    := '';

     end if;
  end if;
--dbms_output.put_line('p_cerw_riga_dati  - passato sel_cerdfi');

  valori := valori||w_sep||
              dir_stato_civile||w_sep||imp_stato_civile||w_sep||segreteria||w_sep||imp_segreteria||w_sep||
              carta_identita||w_sep||imp_carta_identita||w_sep||
              bollo||w_sep||imp_bollo||w_sep||rimborso_st||w_sep||imp_rimborso_st||w_sep||firma||w_sep||
              replace(terminalista,'\','')||w_sep||qualifica||w_sep||
              modalita_1||w_sep||modalita_2||w_sep||validita_1||w_sep||validita_2;

  if p_tipo_archivio in (0,6) then
-- LOGO_CER, FAM_1... FAM_19, FAM_1_MIN... FAM_5_MIN, EVENTI_ANAGRAFE, EVENTI_STATO_CIVILE, DOC_1
-- PROGR_EMISSIONE, DATA_CERT_STORICO
-- DOC_PT_1, DOC_PT_2, DOC_CC_1, DOC_CC_2, URNE_CINERARIE
     riga_cerinc := NULL||w_sep||
                    'FAM_1_'||to_char(p_matricola)||w_sep||'FAM_2_'||to_char(p_matricola)||w_sep||
                    'FAM_3_'||to_char(p_matricola)||w_sep||'FAM_4_'||to_char(p_matricola)||w_sep||
                    'FAM_5_'||to_char(p_matricola)||w_sep||'FAM_6_'||to_char(p_matricola)||w_sep||
                    'FAM_7_'||to_char(p_matricola)||w_sep||'FAM_8_'||to_char(p_matricola)||w_sep||
                    'FAM_9_'||to_char(p_matricola)||w_sep||'FAM_10_'||to_char(p_matricola)||w_sep||
                    'FAM_11_'||to_char(p_matricola)||w_sep||'FAM_12_'||to_char(p_matricola)||w_sep||
                    'FAM_13_'||to_char(p_matricola)||w_sep||'FAM_14_'||to_char(p_matricola)||w_sep||
                    'FAM_15_'||to_char(p_matricola)||w_sep||'FAM_16_'||to_char(p_matricola)||w_sep||
                    'FAM_17_'||to_char(p_matricola)||w_sep||'FAM_18_'||to_char(p_matricola)||w_sep||
                    'FAM_19_'||to_char(p_matricola)||w_sep||
                    'FAM_1_MIN_'||to_char(p_matricola)||w_sep||'FAM_2_MIN_'||to_char(p_matricola)||w_sep||
                    'FAM_3_MIN_'||to_char(p_matricola)||w_sep||'FAM_4_MIN_'||to_char(p_matricola)||w_sep||
                    'FAM_5_MIN_'||to_char(p_matricola)||w_sep||
                    'EVE_'||to_char(p_matricola)||w_sep||'ESC_'||to_char(p_matricola)||w_sep||
                    'DOC_1_'||to_char(p_matricola);
     riga_cerinc := riga_cerinc||w_sep||
                    p_PROGR_EMISSIONE||'/'||p_ANNO_EMISSIONE||w_sep||
                    nvl(to_char(to_date(p_data_cert,'j'),'dd/mm/yyyy'),to_char(sysdate,'dd/mm/yyyy'));
     riga_cerinc := riga_cerinc||w_sep||
                    'DOC_PT_1_'||to_char(p_matricola)||w_sep||
                    'DOC_PT_2_'||to_char(p_matricola)||w_sep||
                    'DOC_CC_1_'||to_char(p_matricola)||w_sep||
                    'DOC_CC_2_'||to_char(p_matricola)||w_sep||
                    'URNE_CINERARIE_'||to_char(p_matricola);
  else
-- LOGO_CER, ANNOTAZIONI.. ANNOTAZIONI_3
-- PROGR_EMISSIONE
     riga_cerinc := NULL||w_sep||
                    'ANN_1_'||replace(p_tipo_archivio||p_anno||p_parte||p_serie||p_atto,' ','')||w_sep||
		    'ANN_2_'||replace(p_tipo_archivio||p_anno||p_parte||p_serie||p_atto,' ','')||w_sep||
		    'ANN_3_'||replace(p_tipo_archivio||p_anno||p_parte||p_serie||p_atto,' ','');
     riga_cerinc := riga_cerinc||w_sep||
                    p_PROGR_EMISSIONE||'/'||p_ANNO_EMISSIONE;
  end if;

  begin
-- RIGA_LIBERA_1.. RIGA_LIBERA_3
    select riga1||w_sep||riga2||w_sep||riga3
      into riga_libera
      from cerdrl
     where terminale   = p_terminale
       and p_flag_loop is null
    ;
  exception
    when others then
         riga_libera := w_sep||w_sep;
  end;

  if p_tipo_archivio in (0,6) then
     riga_libera := riga_libera||w_sep||
                    f_SER_riga_dati(w_sep,'ANA')||w_sep||
                    f_SER_riga_dati(w_sep,'CER')||w_sep||
                    f_SER_riga_dati(w_sep,'COM')||w_sep||
                    f_SER_riga_dati(w_sep,'URP');              
  else
     riga_libera := riga_libera||w_sep||
                    f_SER_riga_dati(w_sep,'CIV')||w_sep||
                    f_SER_riga_dati(w_sep,'CER')||w_sep||
                    f_SER_riga_dati(w_sep,'COM')||w_sep||
                    f_SER_riga_dati(w_sep,'URP');              
  end if;
                    
END;
/
