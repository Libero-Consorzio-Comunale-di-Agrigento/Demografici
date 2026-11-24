--liquibase formatted sql
--changeset amonopoli:202602261515_1 runOnChange:true stripComments:false
create or replace view anawp4_SDDR_zk
AS
select tpr.anagrafe, tpr.tipo_evento, ap4.anno_dic, ap4.numero_dic, ap4.anno_pratica, ap4.pratica,
-- bollo personalizzazione urf
       tpr.pratica||'/'||tpr.anno_pratica des_pratica_tpr,
       '__/__/____' data_pratica_tpr,
       f_get_nome_terminalista(tpr.terminalista) nome_terminalista_tpr,
-- testata dichiarazione
       case
          when tpr.tipo_evento = 'I' and tpr.cod_variazione != 'A' and ap4.cod_pro_eve is not null and ap4.cod_stato is null then
               'X'
       end b_dic_1,
       case
          when tpr.tipo_evento = 'I' and tpr.cod_variazione != 'A' and ap4.cod_pro_eve is not null and ap4.cod_stato is null then
               a.descrizione||decode(a.sigla_provincia,null,'',' ('||a.sigla_provincia||')')
       end f_dic_1,
       case
          when tpr.tipo_evento = 'I' and ap4.cod_pro_eve is not null and ap4.cod_stato is not null and c.descrizione is null then
               'X'
       end b_dic_2,
       case
          when tpr.tipo_evento = 'I' and ap4.cod_pro_eve is not null and ap4.cod_stato is not null and c.descrizione is null then
               a.descrizione||decode(a.sigla_provincia,null,'',' ('||a.sigla_provincia||')')
       end f_dic_2,
       case
          when tpr.tipo_evento = 'I' and c.descrizione is not null then
               'X'
       end b_dic_3,
       case
          when tpr.tipo_evento = 'I' and c.descrizione is not null then
               a.descrizione||decode(a.sigla_provincia,null,'',' ('||a.sigla_provincia||')')
       end f_dic_3,
       to_char(null) b_dic_4,
       case
          when tpr.tipo_evento = 'I' and tpr.cod_variazione != 'A' and ap4.cod_pro_eve||ap4.cod_stato||ap4.cod_pro_iscr_aire is null then
               'X'
       end b_dic_5,
       case
          when tpr.tipo_evento = 'I' and tpr.cod_variazione != 'A' and ap4.cod_pro_eve||ap4.cod_stato||ap4.cod_pro_iscr_aire is null then
               upper(dce.des_evento_tpr)
       end f_dic_5,
--
       nvl(to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),' ') data_pratica,
       nvl(to_char(to_date(data_decorrenza,'j'),'dd/mm/yyyy'),' ') data_decorrenza,
       tipo_richiesta,
       ap4.cod_pro_eve, ap4.cod_stato, ap4.cod_pro_iscr_aire,
       a.descrizione||decode(a.sigla_provincia,null,'',' ('||a.sigla_provincia||')') des_com_eve,
       a.descrizione comune_eve, a.sigla_provincia sigla_eve,
       decode(cod_stato,'','',
              b.descrizione||' ('||b.sigla_provincia||')') des_stato_estero,
       decode(cod_stato,'','',b.descrizione) comune_estero,
       decode(cod_stato,'','',b.sigla_provincia)  sigla_estero,
       c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') des_com_iscr_aire,
       c.descrizione comune_aire,c.sigla_provincia sigla_pro_aire,
       sottoscritto,
-- indirizzo
       'X' b_trasferito,
       com.descrizione f_comune,
       pro.descrizione f_provincia,
       vie.denom_uff f_indirizzo,
       num_civ||decode(suffisso,null,null,'/'||suffisso) f_num_civ,
       rtrim(to_char(interno)||'/'||sub_interno, '/') f_interno,
       scala f_scala, piano f_piano,
       (select decode(count(*),0,to_char(null), 1,to_char(null), 'X')
          from anaapm
         where anno_dic = ap4.anno_dic
           and numero_dic = ap4.numero_dic
           and flag_soggetto = 'S'
           and annullamento is null) b_familiari,
       famiglia_convivenza,
       translate(nvl(nvl(convivenza,presso),' '),'/',' ') presso,
       vie.denom_uff||civico_esterno||civico_interno indirizzo_a,
       nvl(flag_aggregazione,'N') flag_aggr,
       nvl(cod_fam_dest,-1) cod_fam_dest,
       to_number(null) cod_fam_prov,
-- dati CF aggregazione
       decode(ap4.flag_aggregazione,'S','X') b_aggregazione,
       ana_cf.cognome f_cognome_cf,
       ana_cf.nome f_nome_cf,
       decode(ana_cf.anno_nas, 'S',
         '00/00/'||to_char(to_date(ana_cf.data_nas,'j'),'yyyy'),
         to_char(to_date(ana_cf.data_nas,'j'),'dd/mm/yyyy')) f_data_nas_cf,
       com_nas_cf.descrizione||decode(com_nas_cf.sigla_provincia,'','',' ('||com_nas_cf.sigla_provincia||')') f_luogo_nascita_cf,
       to_char(null) f_estremi_doc_cf,
       to_char(null) b_flag_fam_no_par,
       to_char(null) b_flag_fam_si_par,
-- recapiti per comunicazioni
       to_char(null) b_flag_recapiti,
       to_char(null) f_comune_com,
       to_char(null) f_provincia_com,
       to_char(null) f_via_piazza_com,
       to_char(null) f_num_civico_com,
       to_char(null) f_telefono_com,
       to_char(null) f_cellulare_com,
       to_char(null) f_fax_com,
       to_char(null) f_email_com,
-- allegati
       to_char(null) f_allegato_1,
       to_char(null) f_allegato_2,
       to_char(null) f_allegato_3,
       to_char(null) f_allegato_4,
-- dati occupazione immobile
       decode (FLAG_LEGITTIMA,'S','X','') FLAG_LEGITTIMA,
       decode (FLAG_PROPRIETARIO,'S','X','') FLAG_PROPRIETARIO,
       nvl(SEZIONE_CATASTO,'____________') SEZIONE_CATASTO,
       nvl(FOGLIO_CATASTO,'_______') FOGLIO_CATASTO,
       nvl(NUMERO_CATASTO,'____________') NUMERO_CATASTO,
       nvl(SUBALTERNO_CATASTO,'_______') SUBALTERNO_CATASTO,
       decode (FLAG_LOCAZIONE,'S','X','')  FLAG_LOCAZIONE,
       '  '||nvl(SEDE_CONTRATTO_LOCAZIONE,'_____________________') SEDE_CONTRATTO_LOCAZIONE,
       nvl(to_char(to_date(DATA_CONTRATTO_LOCAZIONE,'j'),'dd/mm/yyyy'),'________') DATA_CONTRATTO_LOCAZIONE,
       nvl(NUM_CONTRATTO_LOCAZIONE,'________') NUM_CONTRATTO_LOCAZIONE,
       NOME_PROPRIETA_LOCAZIONE,
       CF_PROPRIETA_LOCAZIONE,COMUNE_PROPRIETA_LOCAZIONE,VIA_PROPRIETA_LOCAZIONE,
       decode (FLAG_LOCAZIONE_ERP,'S','X','')  FLAG_LOCAZIONE_ERP,
       NOTE_LOCAZIONE_ERP,
       decode (FLAG_COMODATO,'S','X','')  FLAG_COMODATO,
       '  '||nvl(SEDE_CONTRATTO_COMODATO,'_____________________') SEDE_CONTRATTO_COMODATO,
       nvl(to_char(to_date(DATA_CONTRATTO_COMODATO,'j'),'dd/mm/yyyy'),'________') DATA_CONTRATTO_COMODATO,
       nvl(NUM_CONTRATTO_COMODATO,'________') NUM_CONTRATTO_COMODATO,
       NOME_PROPRIETA_COMODATO,
       CF_PROPRIETA_COMODATO,COMUNE_PROPRIETA_COMODATO,VIA_PROPRIETA_COMODATO,
       decode (FLAG_USUFRUTTO,'S','X','') FLAG_USUFRUTTO,
       NOTE_USUFRUTTO,
       decode (FLAG_TITOLO,'S','X','') FLAG_TITOLO,
       NOTE_TITOLO,
--
       'rif. Pratica '||tpr.pratica||'/'||tpr.anno_pratica rif_pratica,
       'AP4'||lpad(ap4.id,10,'0') id,
       tpr.id id_anatpr
  from arcpro pro, arccom com, arccom a, arccom b, arccom c, arcvie vie,
       arccom com_nas_cf, anaana ana_cf,
       anadce dce, anadoi doi, anaap4 ap4, anatpr tpr
 where (com.cod_provincia, com.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and pro.cod_provincia     = com.cod_provincia
   and com_nas_cf.cod_provincia (+) = ana_cf.cod_pro_nas
   and com_nas_cf.cod_comune    (+) = ana_cf.cod_com_nas
   and ana_cf.rapporto_par      (+) = 'CF'
   and ana_cf.cod_fam_unique    (+) = ap4.cod_fam_unique_dest
   and a.cod_provincia (+)   = cod_pro_eve
   and a.cod_comune    (+)   = cod_com_eve
   and b.cod_provincia (+)   = cod_stato
   and b.cod_comune (+)      = 0
   and c.cod_provincia (+)   = cod_pro_iscr_aire
   and c.cod_comune    (+)   = cod_com_iscr_aire
   and vie.cod_via           = ap4.cod_via
   and doi.anagrafe     (+)  = tpr.anagrafe
   and doi.tipo_evento  (+)  = tpr.tipo_evento
   and doi.anno_pratica (+)  = tpr.anno_pratica
   and doi.pratica      (+)  = tpr.pratica
   and ap4.stato_pratica             is null
   and ap4.anno_pratica      = tpr.anno_pratica
   and ap4.pratica           = tpr.pratica
   and dce.anagrafe                 = tpr.anagrafe
   and dce.tipo_evento              = tpr.tipo_evento
   and nvl(dce.tipo_evento_tpr,' ') = nvl(tpr.cod_variazione,' ')
   and tpr.tipo_evento       = 'I'
   and tpr.anagrafe          = 'RES'
union
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.anno_pratica, tpr.pratica,
-- bollo personalizzazione urf
       tpr.pratica||'/'||tpr.anno_pratica des_pratica_tpr,
       '__/__/____' data_pratica_tpr,
       f_get_nome_terminalista(tpr.terminalista) nome_terminalista_tpr,
-- testata dichiarazione
       to_char(null) b_dic_1,
       to_char(null) f_dic_1,
       to_char(null) b_dic_2,
       to_char(null) f_dic_2,
       to_char(null) b_dic_3,
       to_char(null) f_dic_3,
       to_char(null) b_dic_4,
       to_char(null) b_dic_5,
       to_char(null) f_dic_5,
--
       null data_pratica,
       null data_decorrenza,
       null, to_number(null), to_number(null), to_number(null),
       null,null, null,null,null,null,null,null,null,
       cre.sottoscritto,
-- indirizzo
       'X' f_trasferito,
       com.descrizione f_comune,
       pro.descrizione f_provincia,
       vie.denom_uff indirizzo,
       num_civ||decode(suffisso,null,null,'/'||suffisso) num_civico,
       to_char(interno)||sub_interno interno,scala,piano,
       (select decode(count(*),0,to_char(null), 1,to_char(null), 'X')
          from anacrm
         where anno_pratica = cre.anno_pratica
           and pratica = cre.pratica
           and flag_soggetto = 'S'
           and flag_annullamento is null) b_familiari,
       famiglia_convivenza,
       translate(nvl(nvl(convivenza,presso),' '),'/',' ') presso,
       vie.denom_uff||civico_esterno||civico_interno indirizzo_a,
       nvl(flag_aggregazione,'N') flag_aggr,
       nvl(cod_fam_dest,-1) cod_fam_dest,
       cod_fam_prov,
-- dati CF aggregazione
       decode(cre.flag_aggregazione,'S','X') b_aggregazione,
       ana_cf.cognome f_cognome_cf,
       ana_cf.nome f_nome_cf,
       decode(ana_cf.anno_nas, 'S',
         '00/00/'||to_char(to_date(ana_cf.data_nas,'j'),'yyyy'),
         to_char(to_date(ana_cf.data_nas,'j'),'dd/mm/yyyy')) f_data_nas_cf,
       com_nas_cf.descrizione||decode(com_nas_cf.sigla_provincia,'','',' ('||com_nas_cf.sigla_provincia||')') f_luogo_nascita_cf,
       to_char(null) f_estremi_doc_cf,
       to_char(null) b_flag_fam_no_par,
       to_char(null) b_flag_fam_si_par,
-- recapiti per comunicazioni
       to_char(null) b_flag_recapiti,
       to_char(null) f_comune_com,
       to_char(null) f_provincia_com,
       to_char(null) f_via_piazza_com,
       to_char(null) f_num_civico_com,
       to_char(null) f_telefono_com,
       to_char(null) f_cellulare_com,
       to_char(null) f_fax_com,
       to_char(null) f_email_com,
-- allegati
       to_char(null) f_allegato_1,
       to_char(null) f_allegato_2,
       to_char(null) f_allegato_3,
       to_char(null) f_allegato_4,
-- dati occupazione immobile
       decode (FLAG_LEGITTIMA,'S','X','') FLAG_LEGITTIMA,
       decode (FLAG_PROPRIETARIO,'S','X','') FLAG_PROPRIETARIO,
       nvl(SEZIONE_CATASTO,'____________') SEZIONE_CATASTO,
       nvl(FOGLIO_CATASTO,'_______') FOGLIO_CATASTO,
       nvl(NUMERO_CATASTO,'____________') NUMERO_CATASTO,
       nvl(SUBALTERNO_CATASTO,'_______') SUBALTERNO_CATASTO,
       decode (FLAG_LOCAZIONE,'S','X','')  FLAG_LOCAZIONE,
       '  '||nvl(SEDE_CONTRATTO_LOCAZIONE,'_____________________') SEDE_CONTRATTO_LOCAZIONE,
       nvl(to_char(to_date(DATA_CONTRATTO_LOCAZIONE,'j'),'dd/mm/yyyy'),'________') DATA_CONTRATTO_LOCAZIONE,
       nvl(NUM_CONTRATTO_LOCAZIONE,'________') NUM_CONTRATTO_LOCAZIONE,
       NOME_PROPRIETA_LOCAZIONE,
       CF_PROPRIETA_LOCAZIONE,COMUNE_PROPRIETA_LOCAZIONE,VIA_PROPRIETA_LOCAZIONE,
       decode (FLAG_LOCAZIONE_ERP,'S','X','')  FLAG_LOCAZIONE_ERP,
       NOTE_LOCAZIONE_ERP,
       decode (FLAG_COMODATO,'S','X','')  FLAG_COMODATO,
       '  '||nvl(SEDE_CONTRATTO_COMODATO,'_____________________') SEDE_CONTRATTO_COMODATO,
       nvl(to_char(to_date(DATA_CONTRATTO_COMODATO,'j'),'dd/mm/yyyy'),'________') DATA_CONTRATTO_COMODATO,
       nvl(NUM_CONTRATTO_COMODATO,'________') NUM_CONTRATTO_COMODATO,
       NOME_PROPRIETA_COMODATO,
       CF_PROPRIETA_COMODATO,COMUNE_PROPRIETA_COMODATO,VIA_PROPRIETA_COMODATO,
       decode (FLAG_USUFRUTTO,'S','X','') FLAG_USUFRUTTO,
       NOTE_USUFRUTTO,
       decode (FLAG_TITOLO,'S','X','') FLAG_TITOLO,
       NOTE_TITOLO,
--
       'rif. Pratica '||tpr.pratica||'/'||tpr.anno_pratica rif_pratica,
       'CRE'||lpad(cre.id,10,'0') id,
       tpr.id id_anatpr
  from arcpro pro, arccom com, arcvie vie,
       arccom com_nas_cf, anaana ana_cf,
       anadoi doi, anacre cre, anatpr tpr
 where (com.cod_provincia, com.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and pro.cod_provincia     = com.cod_provincia
   and com_nas_cf.cod_provincia (+) = ana_cf.cod_pro_nas
   and com_nas_cf.cod_comune    (+) = ana_cf.cod_com_nas
   and ana_cf.rapporto_par      (+) = 'CF'
   and ana_cf.cod_fam_unique    (+) = cre.cod_fam_unique_dest
   and vie.cod_via (+)       = cre.cod_via
   and doi.anagrafe     (+)  = tpr.anagrafe
   and doi.tipo_evento  (+)  = tpr.tipo_evento
   and doi.anno_pratica (+)  = tpr.anno_pratica
   and doi.pratica      (+)  = tpr.pratica
   and cre.anno_pratica      = tpr.anno_pratica
   and cre.pratica           = tpr.pratica
   and tpr.tipo_evento       = 'E'
   and tpr.anagrafe          = 'RES'
/
comment on table anawp4_SDDR_zk is 'Anagrafe - Dati della pratica per Stampa Dichiarazione di Residenza'
/
