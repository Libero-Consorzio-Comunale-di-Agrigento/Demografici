--liquibase formatted sql
--changeset amonopoli:202510021525 runOnChange:true stripComments:false
create or replace function f_TPR_inserisci_MOV
(a_anagrafe		IN	varchar2
,a_tipo_evento		IN	varchar
,a_anno_pratica		IN	number
,a_pratica		IN	number
,a_terminalista		IN	varchar2
,a_flag_annullamento	IN	varchar2
,a_cod_fam		IN	number
,a_cod_fam_unique	IN	varchar2
,a_intestatario		IN	varchar2
)

return number

IS

w_anagrafe	varchar2(255) := upper(a_anagrafe);
w_tipo_evento	varchar2(255) := upper(a_tipo_evento);

w_ANNO_PROGR                       NUMBER;
w_NUMERO_PROGR                     NUMBER;
w_ID_ANAMOV                        NUMBER;

w_MATRICOLA                        NUMBER;
w_COD_MOV                          NUMBER;
w_COD_EVE                          NUMBER;
w_DATA_EVE                         NUMBER;
w_COD_PRO_EVE                      NUMBER;
w_COD_COM_EVE                      NUMBER;
w_ANNO_PRATICA                     NUMBER;
w_PRATICA                          NUMBER;
w_NUCLEO_PARTENZA                  NUMBER;
w_NUCLEO_ARRIVO                    NUMBER;
w_COGNOME_NOME_PREC                VARCHAR2(255);
w_STATO_CIVILE_PREC                VARCHAR2(255);
w_SESSO_PREC                       VARCHAR2(255);
w_NAZIONALITA_PREC                 VARCHAR2(255);
w_PATERNITA_PREC                   VARCHAR2(255);
w_MATERNITA_PREC                   VARCHAR2(255);
w_TITOLO_STUDIO_PREC               VARCHAR2(255);
w_COD_PROF_PREC                    NUMBER;
w_ATTIVITA_PROF_PREC               NUMBER;
w_POSIZIONE_PROF_PREC              NUMBER;
w_PENSIONATO_PREC                  VARCHAR2(255);
w_COD_FAM_PREC                     NUMBER;
w_INTESTATARIO_PREC                VARCHAR2(255);
w_RAPPORTO_PAR_PREC                VARCHAR2(255);
w_COD_VIA_PREC                     NUMBER;
w_NUM_CIV_PREC                     NUMBER;
w_SUFFISSO_PREC                    VARCHAR2(255);
w_INTERNO_PREC                     NUMBER;
w_VIA_AIRE_PREC                    VARCHAR2(255);
w_COD_PRO_AIRE_PREC                NUMBER;
w_COD_COM_AIRE_PREC                NUMBER;
w_COGNOME_NOME_CN_PREC             VARCHAR2(255);
w_MATRICOLA_CN_PREC                NUMBER;
w_ANNO_CENS_PREC                   NUMBER;
w_SEZIONE_CENS_PREC                NUMBER;
w_FOGLIO_CENS_PREC                 NUMBER;
w_COD_PRO_NAS_PREC                 NUMBER;
w_COD_COM_NAS_PREC                 NUMBER;
w_DATA_NAS_PREC                    NUMBER;
w_COD_PRO_ATTO_NAS_PREC            NUMBER;
w_COD_COM_ATTO_NAS_PREC            NUMBER;
w_ANNO_ATTO_NAS_PREC               NUMBER;
w_ATTO_NAS_PREC                    NUMBER;
w_PARTE_NAS_PREC                   NUMBER;
w_SERIE_NAS_PREC                   VARCHAR2(255);
w_UFFICIO_NAS_PREC                 NUMBER;
w_ANNO_ATTO_NAS_TR_PREC            NUMBER;
w_ATTO_NAS_TR_PREC                 NUMBER;
w_PARTE_NAS_TR_PREC                NUMBER;
w_SERIE_NAS_TR_PREC                VARCHAR2(255);
w_UFFICIO_NAS_TR_PREC              NUMBER;
w_COD_PRO_MAT_PREC                 NUMBER;
w_COD_COM_MAT_PREC                 NUMBER;
w_DATA_MAT_PREC                    NUMBER;
w_ANNO_ATTO_MAT_PREC               NUMBER;
w_ATTO_MAT_PREC                    NUMBER;
w_PARTE_MAT_PREC                   NUMBER;
w_SERIE_MAT_PREC                   VARCHAR2(255);
w_UFFICIO_MAT_PREC                 NUMBER;
w_ANNO_ATTO_MAT_TR_PREC            NUMBER;
w_ATTO_MAT_TR_PREC                 NUMBER;
w_PARTE_MAT_TR_PREC                NUMBER;
w_SERIE_MAT_TR_PREC                VARCHAR2(255);
w_UFFICIO_MAT_TR_PREC              NUMBER;
w_COD_PRO_MOR_PREC                 NUMBER;
w_COD_COM_MOR_PREC                 NUMBER;
w_DATA_MOR_PREC                    NUMBER;
w_ANNO_ATTO_MOR_PREC               NUMBER;
w_ATTO_MOR_PREC                    NUMBER;
w_PARTE_MOR_PREC                   NUMBER;
w_SERIE_MOR_PREC                   VARCHAR2(255);
w_UFFICIO_MOR_PREC                 NUMBER;
w_ANNO_ATTO_MOR_TR_PREC            NUMBER;
w_ATTO_MOR_TR_PREC                 NUMBER;
w_PARTE_MOR_TR_PREC                NUMBER;
w_SERIE_MOR_TR_PREC                VARCHAR2(255);
w_UFFICIO_MOR_TR_PREC              NUMBER;
w_COD_PRO_VED_PREC                 NUMBER;
w_COD_COM_VED_PREC                 NUMBER;
w_DATA_VED_PREC                    NUMBER;
w_ANNO_ATTO_VED_PREC               NUMBER;
w_ATTO_VED_PREC                    NUMBER;
w_PARTE_VED_PREC                   NUMBER;
w_SERIE_VED_PREC                   VARCHAR2(255);
w_UFFICIO_VED_PREC                 NUMBER;
w_COD_FISCALE_PREC                 VARCHAR2(255);
w_COGNOME_NOME                     VARCHAR2(255);
w_STATO_CIVILE                     VARCHAR2(255);
w_SESSO                            VARCHAR2(255);
w_NAZIONALITA                      VARCHAR2(255);
w_PATERNITA                        VARCHAR2(255);
w_MATERNITA                        VARCHAR2(255);
w_TITOLO_STUDIO                    VARCHAR2(255);
w_COD_PROF                         NUMBER;
w_ATTIVITA_PROF                    NUMBER;
w_POSIZIONE_PROF                   NUMBER;
w_PENSIONATO                       VARCHAR2(255);
w_COD_FAM                          NUMBER;
w_INTESTATARIO                     VARCHAR2(255);
w_RAPPORTO_PAR                     VARCHAR2(255);
w_DATA_INIZIO_FAM                  NUMBER;
w_COD_VIA                          NUMBER;
w_NUM_CIV                          NUMBER;
w_SUFFISSO                         VARCHAR2(255);
w_INTERNO                          NUMBER;
w_VIA_AIRE                         VARCHAR2(255);
w_COD_PRO_AIRE                     NUMBER;
w_COD_COM_AIRE                     NUMBER;
w_DATA_INIZIO_RES                  NUMBER;
w_COGNOME_NOME_CN                  VARCHAR2(255);
w_MATRICOLA_CN                     NUMBER;
w_ANNO_CENS                        NUMBER;
w_SEZIONE_CENS                     NUMBER;
w_FOGLIO_CENS                      NUMBER;
w_COD_PRO_NAS                      NUMBER;
w_COD_COM_NAS                      NUMBER;
w_DATA_NAS                         NUMBER;
w_COD_PRO_ATTO_NAS                 NUMBER;
w_COD_COM_ATTO_NAS                 NUMBER;
w_ANNO_ATTO_NAS                    NUMBER;
w_ATTO_NAS                         NUMBER;
w_PARTE_NAS                        NUMBER;
w_SERIE_NAS                        VARCHAR2(255);
w_UFFICIO_NAS                      NUMBER;
w_ANNO_ATTO_NAS_TR                 NUMBER;
w_ATTO_NAS_TR                      NUMBER;
w_PARTE_NAS_TR                     NUMBER;
w_SERIE_NAS_TR                     VARCHAR2(255);
w_UFFICIO_NAS_TR                   NUMBER;
w_COD_PRO_MAT                      NUMBER;
w_COD_COM_MAT                      NUMBER;
w_DATA_MAT                         NUMBER;
w_ANNO_ATTO_MAT                    NUMBER;
w_ATTO_MAT                         NUMBER;
w_PARTE_MAT                        NUMBER;
w_SERIE_MAT                        VARCHAR2(255);
w_UFFICIO_MAT                      NUMBER;
w_ANNO_ATTO_MAT_TR                 NUMBER;
w_ATTO_MAT_TR                      NUMBER;
w_PARTE_MAT_TR                     NUMBER;
w_SERIE_MAT_TR                     VARCHAR2(255);
w_UFFICIO_MAT_TR                   NUMBER;
w_COD_PRO_MOR                      NUMBER;
w_COD_COM_MOR                      NUMBER;
w_DATA_MOR                         NUMBER;
w_ANNO_ATTO_MOR                    NUMBER;
w_ATTO_MOR                         NUMBER;
w_PARTE_MOR                        NUMBER;
w_SERIE_MOR                        VARCHAR2(255);
w_UFFICIO_MOR                      NUMBER;
w_ANNO_ATTO_MOR_TR                 NUMBER;
w_ATTO_MOR_TR                      NUMBER;
w_PARTE_MOR_TR                     NUMBER;
w_SERIE_MOR_TR                     VARCHAR2(255);
w_UFFICIO_MOR_TR                   NUMBER;
w_COD_PRO_VED                      NUMBER;
w_COD_COM_VED                      NUMBER;
w_DATA_VED                         NUMBER;
w_ANNO_ATTO_VED                    NUMBER;
w_ATTO_VED                         NUMBER;
w_PARTE_VED                        NUMBER;
w_SERIE_VED                        VARCHAR2(255);
w_UFFICIO_VED                      NUMBER;
w_COD_FISCALE                      VARCHAR2(255);
w_DATA_REG                         NUMBER;
w_TERMINALISTA                     VARCHAR2(255);
w_ELETTORALE                       VARCHAR2(255);
w_ANNULLAMENTO                     VARCHAR2(255);
w_COD_PRO_DIV_PREC                 NUMBER;
w_COD_COM_DIV_PREC                 NUMBER;
w_DATA_DIV_PREC                    NUMBER;
w_ANNO_ATTO_DIV_PREC               NUMBER;
w_ATTO_DIV_PREC                    NUMBER;
w_PARTE_DIV_PREC                   NUMBER;
w_SERIE_DIV_PREC                   VARCHAR2(255);
w_UFFICIO_DIV_PREC                 NUMBER;
w_COD_PRO_DIV                      NUMBER;
w_COD_COM_DIV                      NUMBER;
w_DATA_DIV                         NUMBER;
w_ANNO_ATTO_DIV                    NUMBER;
w_ATTO_DIV                         NUMBER;
w_PARTE_DIV                        NUMBER;
w_SERIE_DIV                        VARCHAR2(255);
w_UFFICIO_DIV                      NUMBER;
w_MATRICOLA_AIRE_PREC              VARCHAR2(255);
w_MATRICOLA_AIRE                   VARCHAR2(255);
w_COD_PRO_ATTO_MAT_PREC            NUMBER;
w_COD_COM_ATTO_MAT_PREC            NUMBER;
w_COD_PRO_ATTO_VED_PREC            NUMBER;
w_COD_COM_ATTO_VED_PREC            NUMBER;
w_COD_PRO_ATTO_MOR_PREC            NUMBER;
w_COD_COM_ATTO_MOR_PREC            NUMBER;
w_COD_PRO_ATTO_MAT                 NUMBER;
w_COD_COM_ATTO_MAT                 NUMBER;
w_COD_PRO_ATTO_VED                 NUMBER;
w_COD_COM_ATTO_VED                 NUMBER;
w_COD_PRO_ATTO_MOR                 NUMBER;
w_COD_COM_ATTO_MOR                 NUMBER;
w_CF_CALCOLATO_PREC                VARCHAR2(255);
w_CF_CALCOLATO                     VARCHAR2(255);
w_COD_VARIAZIONE                   VARCHAR2(255);
w_SCALA_PREC                       VARCHAR2(255);
w_PIANO_PREC                       VARCHAR2(255);
w_ZIPCODE_PREC                     VARCHAR2(255);
w_SCALA                            VARCHAR2(255);
w_PIANO                            VARCHAR2(255);
w_ZIPCODE                          VARCHAR2(255);
w_COD_EDIFICIO_CENS_PREC           NUMBER;
w_COD_EDIFICIO_CENS                NUMBER;
w_NO_CONTEGGIO                     VARCHAR2(255);
w_COD_PRO_ATTO_DIV                 NUMBER;
w_COD_COM_ATTO_DIV                 NUMBER;
w_DATA_DIV_GIU                     NUMBER;
w_DATA_DIV_ANN                     NUMBER;
w_COD_PRO_ATTO_DIV_PREC            NUMBER;
w_COD_COM_ATTO_DIV_PREC            NUMBER;
w_DATA_DIV_GIU_PREC                NUMBER;
w_DATA_DIV_ANN_PREC                NUMBER;
w_COD_PRO_ISCR_AIRE                NUMBER;
w_COD_COM_ISCR_AIRE                NUMBER;
w_PROVINCIA_CONTEA_PREC            VARCHAR2(255);
w_PRESSO_PREC                      VARCHAR2(255);
w_PROVINCIA_CONTEA                 VARCHAR2(255);
w_PRESSO                           VARCHAR2(255);
w_ANNO_NAS_PREC                    VARCHAR2(255);
w_ANNO_MAT_PREC                    VARCHAR2(255);
w_ANNO_NAS                         VARCHAR2(255);
w_ANNO_MAT                         VARCHAR2(255);
w_SUB_INTERNO                      VARCHAR2(255);
w_CIVICO_ESTERNO                   VARCHAR2(255);
w_CIVICO_INTERNO                   VARCHAR2(255);
w_SUB_INTERNO_PREC                 VARCHAR2(255);
w_CIVICO_ESTERNO_PREC              VARCHAR2(255);
w_CIVICO_INTERNO_PREC              VARCHAR2(255);
w_MATRICOLA_PD_PREC                NUMBER;
w_MATRICOLA_MD_PREC                NUMBER;
w_MATRICOLA_PD                     NUMBER;
w_MATRICOLA_MD                     NUMBER;
w_DATA_INIZIO_NAZ                  NUMBER;
w_DATA_INIZIO_NAZ_PREC             NUMBER;
w_NO_VANA                          VARCHAR2(255);
w_ATTO_NAS_DIGITALE_PREC           VARCHAR2(255);
w_ATTO_NAS_TR_DIGITALE_PREC        VARCHAR2(255);
w_ATTO_MAT_DIGITALE_PREC           VARCHAR2(255);
w_ATTO_MAT_TR_DIGITALE_PREC        VARCHAR2(255);
w_ATTO_DIV_DIGITALE_PREC           VARCHAR2(255);
w_ATTO_VED_DIGITALE_PREC           VARCHAR2(255);
w_ATTO_MOR_DIGITALE_PREC           VARCHAR2(255);
w_ATTO_MOR_TR_DIGITALE_PREC        VARCHAR2(255);
w_ATTO_NAS_DIGITALE                VARCHAR2(255);
w_ATTO_NAS_TR_DIGITALE             VARCHAR2(255);
w_ATTO_MAT_DIGITALE                VARCHAR2(255);
w_ATTO_MAT_TR_DIGITALE             VARCHAR2(255);
w_ATTO_DIV_DIGITALE                VARCHAR2(255);
w_ATTO_VED_DIGITALE                VARCHAR2(255);
w_ATTO_MOR_DIGITALE                VARCHAR2(255);
w_ATTO_MOR_TR_DIGITALE             VARCHAR2(255);
--
w_FLAG_METRICO_PREC                VARCHAR2(255);
w_PROGR_SNC_PREC                   VARCHAR2(255);
w_FLAG_LETTERA_PREC                VARCHAR2(255);
w_FLAG_ESPONENTE_PREC              VARCHAR2(255);
w_FLAG_NUI_PREC                    VARCHAR2(255);
w_NUI_PREC                         VARCHAR2(255);
w_COLORE_PREC                      VARCHAR2(255);
w_CORTE_PREC                       VARCHAR2(255);
w_INTERNO2_PREC                    NUMBER;
w_SUB_INTERNO2_PREC                VARCHAR2(255);
w_SECONDARIO_PREC                  VARCHAR2(255);
w_SCALA_ESTERNA_PREC               VARCHAR2(255);
w_FLAG_METRICO                     VARCHAR2(255);
w_PROGR_SNC                        VARCHAR2(255);
w_FLAG_LETTERA                     VARCHAR2(255);
w_FLAG_ESPONENTE                   VARCHAR2(255);
w_FLAG_NUI                         VARCHAR2(255);
w_NUI                              VARCHAR2(255);
w_COLORE                           VARCHAR2(255);
w_CORTE                            VARCHAR2(255);
w_INTERNO2                         NUMBER;
w_SUB_INTERNO2                     VARCHAR2(255);
w_SECONDARIO                       VARCHAR2(255);
w_SCALA_ESTERNA                    VARCHAR2(255);

cursor sel_apm_perf is
select apm.ist_rp	-- w_ord_1
--
     , dce.cod_mov
     , dce.cod_eve
     , dce.cod_variazione
     , nvl(to_char(tpr.d_data_decorrenza,'j'),tpr.data_pratica) data_eve
     , ap4.cod_pro_eve
     , ap4.cod_com_eve
     , ap4.cod_pro_iscr_aire
     , ap4.cod_com_iscr_aire
     , ap4.cod_via
     , ap4.num_civ
     , ap4.suffisso
     , ap4.interno
     , ap4.sub_interno
     , ap4.scala
     , ap4.piano
     , ap4.FLAG_METRICO
     , ap4.PROGR_SNC
     , ap4.FLAG_LETTERA
     , ap4.FLAG_ESPONENTE
     , ap4.FLAG_NUI
     , ap4.NUI
     , ap4.COLORE
     , ap4.CORTE
     , ap4.INTERNO2
     , ap4.SUB_INTERNO2
     , ap4.SECONDARIO
     , ap4.SCALA_ESTERNA
     , ana.*
--
     , ap4.cod_fam_dest cod_fam_dest
     , ap4.cod_fam_unique_dest cod_fam_unique_dest
     , apm.nuovo_rapporto_par rapporto_par_dest
     , fam.intestatario intestatario_dest
     , decode(ap4.flag_aggregazione,'S',decode(ana.rapporto_par,'CF',1),1) nucleo_arrivo
--
     , nvl(ap4.cod_fam_prov,apm.cod_fam_ripristino) cod_fam_prov
     , nvl(ap4.cod_fam_unique_prov,f_ana_get_cod_fam_unique(3,apm.cod_fam_ripristino)) cod_fam_unique_prov
     , decode(ap4.cod_fam_prov, '', to_char(''), fam_prov.intestatario) intestatario_prov
     , decode(ap4.cod_fam_prov, '', to_char(''), decode(ap4.flag_intero_nucleo, 'S', 1)) nucleo_partenza
     , decode(ap4.cod_fam_prov, '', to_char(''), nvl(apm.rapporto_par_prec,apm.rapporto_par_ripristino)) rapporto_par_prov
     , decode(ap4.cod_fam_prov, '', to_number(''), fam_prov.cod_pro_aire) cod_pro_aire_prov
     , decode(ap4.cod_fam_prov, '', to_number(''), fam_prov.cod_com_aire) cod_com_aire_prov
     , decode(ap4.cod_fam_prov, '', to_char(''), fam_prov.via_aire) via_aire_prov
     , decode(ap4.cod_fam_prov, '', to_char(''), fam_prov.zipcode) zipcode_prov
     , decode(ap4.cod_fam_prov, '', to_char(''), fam_prov.provincia_contea) provincia_contea_prov
     , decode(ap4.cod_fam_prov, '', to_char(''), fam_prov.presso) presso_prov
     , apm.fascia_ripristino
     , apm.stato_ripristino
  from anadce dce
     , anafam fam_prov
     , anafam fam
     , anaana ana
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where fam_prov.cod_fam_unique (+) = ap4.cod_fam_unique_prov
   and dce.anagrafe        = tpr.anagrafe
   and dce.tipo_evento     = tpr.tipo_evento
   and dce.tipo_evento_tpr = tpr.cod_variazione
   and fam.cod_fam_unique  = ana.cod_fam_unique
   and ana.matricola       = apm.matricola
   and apm.flag_soggetto   = 'S'
   and (apm.annullamento is null and nvl(a_flag_annullamento,'N') = 'N')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
 order by 1
;

w_conta_apm_prov	number;

cursor sel_apm_prov is
select nvl(apm.sequenza_par_ripristino,apm.sequenza_par_prec)	w_ord_1
     , apm.ist_rp						w_ord_2
--
     , dce.cod_mov
     , dce.cod_eve
     , dce.cod_variazione
     , nvl(to_char(tpr.d_data_decorrenza,'j'),tpr.data_pratica) data_eve
     , ap4.cod_via
     , ap4.num_civ
     , ap4.suffisso
     , ap4.interno
     , ap4.sub_interno
     , ap4.scala
     , ap4.piano
     , ap4.FLAG_METRICO
     , ap4.PROGR_SNC
     , ap4.FLAG_LETTERA
     , ap4.FLAG_ESPONENTE
     , ap4.FLAG_NUI
     , ap4.NUI
     , ap4.COLORE
     , ap4.CORTE
     , ap4.INTERNO2
     , ap4.SUB_INTERNO2
     , ap4.SECONDARIO
     , ap4.SCALA_ESTERNA
     , ana.*
--
     , apm.rapporto_par_prec rapporto_par_dest
     , apm.rapporto_par_ripristino rapporto_par_prov
--
     , decode(ap4.flag_intero_nucleo,'S',1) nucleo_partenza
     , ap4.cod_fam_prov
     , ap4.cod_fam_unique_prov
     , fam_prov.intestatario intestatario_prov
  from anadce dce
     , anafam fam_prov
     , anaana ana
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where dce.anagrafe            = tpr.anagrafe
   and dce.tipo_evento         = tpr.tipo_evento
   and dce.tipo_evento_tpr     = tpr.cod_variazione
   and fam_prov.cod_fam_unique = ap4.cod_fam_unique_prov
   and ana.matricola       = apm.matricola
   and apm.rapporto_par_ripristino != apm.rapporto_par_prec
   and apm.flag_soggetto   is null
   and (apm.annullamento is null and nvl(a_flag_annullamento,'N') = 'N')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
 order by 1, 2
;

cursor sel_apm_ann is
select mov.anno_progr 		w_ord_1
     , mov.numero_progr  	w_ord_2
--
     , mov.*
  from anamov mov
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where mov.cod_mov         = 1
   and mov.cod_eve         = 17
   and mov.data_eve        = nvl(to_char(tpr.d_data_decorrenza,'j'),to_char(tpr.d_data_pratica,'j'))
   and mov.matricola       = apm.matricola
   and apm.flag_soggetto   = 'S'
   and (nvl(apm.annullamento,'N') = 'S' or nvl(a_flag_annullamento,'N') = 'S')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
UNION
select mov.anno_progr 		w_ord_1
     , mov.numero_progr 	w_ord_2
--
     , mov.*
  from anamov mov
     , anaapm apm
     , anaap4 ap4
     , anatpr tpr
 where mov.cod_mov         = 12
   and mov.cod_eve         = 90
   and mov.data_eve        = nvl(to_char(tpr.d_data_decorrenza,'j'),to_char(tpr.d_data_pratica,'j'))
   and mov.matricola       = apm.matricola
   and apm.flag_soggetto   is null
   and (nvl(apm.annullamento,'N') = 'S' or nvl(a_flag_annullamento,'N') = 'S')
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.anno_pratica    = a_anno_pratica
   and tpr.pratica         = a_pratica
 order by 1,2
;

cursor sel_sen is
select sen.*
  from anasen sen
 where matricola        = w_matricola
   and anagrafe_tpr     = a_anagrafe
   and tipo_evento_tpr  = a_tipo_evento
   and anno_pratica_tpr = a_anno_pratica
   and pratica_tpr      = a_pratica
   and rownum = 1
;

w_fase_log		varchar2(255) := 'ZK';
w_parametri_log		varchar2(2000);
w_note_log		varchar2(2000);
w_terminalista_log	varchar2(255) := a_terminalista;
w_operazione_log	varchar2(255);
w_return_log		number;

w_return	number;

errore		exception;
w_errore	varchar2(4000);

begin
  w_return := 0;

  if a_anagrafe       is not null and
     a_tipo_evento    is not null and
     a_anno_pratica   is not null and
     a_pratica        is not null
  then
     if w_anagrafe = 'RES' and w_tipo_evento = 'I' then
        w_operazione_log := 'Iscrizione APR (zk)';
        for rec in sel_apm_perf loop
            w_ANNO_PROGR   := '';
            w_NUMERO_PROGR := '';
            w_ID_ANAMOV    := '';
            ANAMOV_NR(w_ANNO_PROGR, w_NUMERO_PROGR);
            w_ID_ANAMOV                 := w_ANNO_PROGR||lpad(w_NUMERO_PROGR,6,'0');
--
            w_MATRICOLA                 := rec.matricola;
            w_COD_MOV                   := rec.cod_mov;
            w_COD_EVE                   := rec.cod_eve;
            if w_cod_eve = 2 and rec.fascia_ripristino = 2 and rec.stato_ripristino = 51 then
               w_cod_eve := 3;
            end if;
            w_COD_VARIAZIONE            := rec.cod_variazione;
            w_DATA_EVE                  := rec.data_eve;
            w_COD_PRO_EVE               := rec.cod_pro_eve;
            w_COD_COM_EVE               := rec.cod_com_eve;
            w_ANNO_PRATICA              := a_anno_pratica;
            w_PRATICA                   := a_pratica;
            w_NUCLEO_PARTENZA           := rec.nucleo_partenza;
            w_NUCLEO_ARRIVO             := rec.nucleo_arrivo;
            w_DATA_REG                  := to_char(sysdate,'j');
            w_TERMINALISTA              := a_terminalista;
            w_ELETTORALE                := '';
            w_ANNULLAMENTO              := '';
            w_NO_CONTEGGIO              := ''; -- lo calcola il trigger?
            w_NO_VANA                   := '';
--
            w_COGNOME_NOME_PREC         := '';
            w_STATO_CIVILE_PREC         := '';
            w_SESSO_PREC                := '';
            w_NAZIONALITA_PREC          := '';
            w_PATERNITA_PREC            := '';
            w_MATERNITA_PREC            := '';
            w_TITOLO_STUDIO_PREC        := '';
            w_COD_PROF_PREC             := '';
            w_ATTIVITA_PROF_PREC        := '';
            w_POSIZIONE_PROF_PREC       := '';
            w_PENSIONATO_PREC           := '';
            w_COD_FAM_PREC              := rec.cod_fam_prov;
            w_INTESTATARIO_PREC         := rec.intestatario_prov;
            w_RAPPORTO_PAR_PREC         := rec.rapporto_par_prov;
            w_COD_VIA_PREC              := '';
            w_NUM_CIV_PREC              := '';
            w_SUFFISSO_PREC             := '';
            w_INTERNO_PREC              := '';
            w_VIA_AIRE_PREC             := rec.via_aire_prov;
            w_COD_PRO_AIRE_PREC         := rec.cod_pro_aire_prov;
            w_COD_COM_AIRE_PREC         := rec.cod_com_aire_prov;
            w_COGNOME_NOME_CN_PREC      := '';
            w_MATRICOLA_CN_PREC         := '';
            w_ANNO_CENS_PREC            := '';
            w_SEZIONE_CENS_PREC         := '';
            w_FOGLIO_CENS_PREC          := '';
            w_COD_PRO_NAS_PREC          := '';
            w_COD_COM_NAS_PREC          := '';
            w_DATA_NAS_PREC             := '';
            w_COD_PRO_ATTO_NAS_PREC     := '';
            w_COD_COM_ATTO_NAS_PREC     := '';
            w_ANNO_ATTO_NAS_PREC        := '';
            w_ATTO_NAS_PREC             := '';
            w_PARTE_NAS_PREC            := '';
            w_SERIE_NAS_PREC            := '';
            w_UFFICIO_NAS_PREC          := '';
            w_ANNO_ATTO_NAS_TR_PREC     := '';
            w_ATTO_NAS_TR_PREC          := '';
            w_PARTE_NAS_TR_PREC         := '';
            w_SERIE_NAS_TR_PREC         := '';
            w_UFFICIO_NAS_TR_PREC       := '';
            w_COD_PRO_MAT_PREC          := '';
            w_COD_COM_MAT_PREC          := '';
            w_DATA_MAT_PREC             := '';
            w_ANNO_ATTO_MAT_PREC        := '';
            w_ATTO_MAT_PREC             := '';
            w_PARTE_MAT_PREC            := '';
            w_SERIE_MAT_PREC            := '';
            w_UFFICIO_MAT_PREC          := '';
            w_ANNO_ATTO_MAT_TR_PREC     := '';
            w_ATTO_MAT_TR_PREC          := '';
            w_PARTE_MAT_TR_PREC         := '';
            w_SERIE_MAT_TR_PREC         := '';
            w_UFFICIO_MAT_TR_PREC       := '';
            w_COD_PRO_MOR_PREC          := '';
            w_COD_COM_MOR_PREC          := '';
            w_DATA_MOR_PREC             := '';
            w_ANNO_ATTO_MOR_PREC        := '';
            w_ATTO_MOR_PREC             := '';
            w_PARTE_MOR_PREC            := '';
            w_SERIE_MOR_PREC            := '';
            w_UFFICIO_MOR_PREC          := '';
            w_ANNO_ATTO_MOR_TR_PREC     := '';
            w_ATTO_MOR_TR_PREC          := '';
            w_PARTE_MOR_TR_PREC         := '';
            w_SERIE_MOR_TR_PREC         := '';
            w_UFFICIO_MOR_TR_PREC       := '';
            w_COD_PRO_VED_PREC          := '';
            w_COD_COM_VED_PREC          := '';
            w_DATA_VED_PREC             := '';
            w_ANNO_ATTO_VED_PREC        := '';
            w_ATTO_VED_PREC             := '';
            w_PARTE_VED_PREC            := '';
            w_SERIE_VED_PREC            := '';
            w_UFFICIO_VED_PREC          := '';
            w_COD_FISCALE_PREC          := '';
            w_COGNOME_NOME              := rec.cognome_nome;
            w_STATO_CIVILE              := rec.stato_civile;
            w_SESSO                     := rec.sesso;
            w_NAZIONALITA               := rec.nazionalita;
            w_PATERNITA                 := rec.paternita;
            w_MATERNITA                 := rec.maternita;
            w_TITOLO_STUDIO             := rec.titolo_studio;
            w_COD_PROF                  := rec.cod_prof;
            w_ATTIVITA_PROF             := rec.attivita_prof;
            w_POSIZIONE_PROF            := rec.posizione_prof;
            w_PENSIONATO                := rec.pensionato;
--            w_COD_FAM                   := rec.cod_fam;
            w_COD_FAM                   := rec.cod_fam_dest; --nvl(a_cod_fam,rec.cod_fam_dest);
            w_INTESTATARIO              := rec.intestatario_dest; --nvl(a_intestatario,rec.intestatario_dest);
--            w_RAPPORTO_PAR              := rec.rapporto_par;
            w_RAPPORTO_PAR              := rec.rapporto_par_dest;
            w_DATA_INIZIO_FAM           := rec.data_eve;
            w_COD_VIA                   := rec.cod_via;
            w_NUM_CIV                   := rec.num_civ;
            w_SUFFISSO                  := rec.suffisso;
            w_INTERNO                   := rec.interno;
            w_VIA_AIRE                  := '';
            w_COD_PRO_AIRE              := '';
            w_COD_COM_AIRE              := '';
            w_DATA_INIZIO_RES           := rec.data_eve;
            w_COGNOME_NOME_CN           := rec.cognome_nome_cn;
            w_MATRICOLA_CN              := rec.matricola_cn;
            w_ANNO_CENS                 := rec.anno_cens;
            w_SEZIONE_CENS              := rec.sezione_cens;
            w_FOGLIO_CENS               := rec.foglio_cens;
            w_COD_PRO_NAS               := rec.cod_pro_nas;
            w_COD_COM_NAS               := rec.cod_com_nas;
            w_DATA_NAS                  := rec.data_nas;
            w_COD_PRO_ATTO_NAS          := rec.cod_pro_atto_nas;
            w_COD_COM_ATTO_NAS          := rec.cod_com_atto_nas;
            w_ANNO_ATTO_NAS             := rec.anno_atto_nas;
            w_ATTO_NAS                  := rec.atto_nas;
            w_PARTE_NAS                 := rec.parte_nas;
            w_SERIE_NAS                 := rec.serie_nas;
            w_UFFICIO_NAS               := rec.ufficio_nas;
            w_ANNO_ATTO_NAS_TR          := rec.anno_atto_nas;
            w_ATTO_NAS_TR               := rec.atto_nas_tr;
            w_PARTE_NAS_TR              := rec.parte_nas_tr;
            w_SERIE_NAS_TR              := rec.serie_nas_tr;
            w_UFFICIO_NAS_TR            := rec.ufficio_nas_tr;
            w_COD_PRO_MAT               := rec.cod_pro_mat;
            w_COD_COM_MAT               := rec.cod_com_mat;
            w_DATA_MAT                  := rec.data_mat;
            w_ANNO_ATTO_MAT             := rec.anno_atto_mat;
            w_ATTO_MAT                  := rec.atto_mat;
            w_PARTE_MAT                 := rec.parte_mat;
            w_SERIE_MAT                 := rec.serie_mat;
            w_UFFICIO_MAT               := rec.ufficio_mat;
            w_ANNO_ATTO_MAT_TR          := rec.anno_atto_mat_tr;
            w_ATTO_MAT_TR               := rec.atto_mat_tr;
            w_PARTE_MAT_TR              := rec.parte_mat_tr;
            w_SERIE_MAT_TR              := rec.serie_mat_tr;
            w_UFFICIO_MAT_TR            := rec.ufficio_mat_tr;
            w_COD_PRO_MOR               := '';
            w_COD_COM_MOR               := '';
            w_DATA_MOR                  := '';
            w_ANNO_ATTO_MOR             := '';
            w_ATTO_MOR                  := '';
            w_PARTE_MOR                 := '';
            w_SERIE_MOR                 := '';
            w_UFFICIO_MOR               := '';
            w_ANNO_ATTO_MOR_TR          := '';
            w_ATTO_MOR_TR               := '';
            w_PARTE_MOR_TR              := '';
            w_SERIE_MOR_TR              := '';
            w_UFFICIO_MOR_TR            := '';
            w_COD_PRO_VED               := rec.cod_pro_ved;
            w_COD_COM_VED               := rec.cod_com_ved;
            w_DATA_VED                  := rec.data_ved;
            w_ANNO_ATTO_VED             := rec.anno_atto_ved;
            w_ATTO_VED                  := rec.atto_ved;
            w_PARTE_VED                 := rec.parte_ved;
            w_SERIE_VED                 := rec.serie_ved;
            w_UFFICIO_VED               := rec.ufficio_ved;
            w_COD_FISCALE               := rec.cod_fiscale;
            w_COD_PRO_DIV_PREC          := '';
            w_COD_COM_DIV_PREC          := '';
            w_DATA_DIV_PREC             := '';
            w_ANNO_ATTO_DIV_PREC        := '';
            w_ATTO_DIV_PREC             := '';
            w_PARTE_DIV_PREC            := '';
            w_SERIE_DIV_PREC            := '';
            w_UFFICIO_DIV_PREC          := '';
            w_COD_PRO_DIV               := rec.cod_pro_div;
            w_COD_COM_DIV               := rec.cod_com_div;
            w_DATA_DIV                  := rec.data_div;
            w_ANNO_ATTO_DIV             := rec.anno_atto_div;
            w_ATTO_DIV                  := rec.atto_div;
            w_PARTE_DIV                 := rec.parte_div;
            w_SERIE_DIV                 := rec.serie_div;
            w_UFFICIO_DIV               := rec.ufficio_div;
            w_MATRICOLA_AIRE_PREC       := rec.matricola_aire;
            w_MATRICOLA_AIRE            := '';
            w_COD_PRO_ATTO_MAT_PREC     := '';
            w_COD_COM_ATTO_MAT_PREC     := '';
            w_COD_PRO_ATTO_VED_PREC     := '';
            w_COD_COM_ATTO_VED_PREC     := '';
            w_COD_PRO_ATTO_MOR_PREC     := '';
            w_COD_COM_ATTO_MOR_PREC     := '';
            w_COD_PRO_ATTO_MAT          := rec.cod_pro_atto_mat;
            w_COD_COM_ATTO_MAT          := rec.cod_com_atto_mat;
            w_COD_PRO_ATTO_VED          := rec.cod_pro_atto_ved;
            w_COD_COM_ATTO_VED          := rec.cod_com_atto_ved;
            w_COD_PRO_ATTO_MOR          := rec.cod_pro_atto_mor;
            w_COD_COM_ATTO_MOR          := rec.cod_com_atto_mor;
            w_CF_CALCOLATO_PREC         := '';
            w_CF_CALCOLATO              := rec.cf_calcolato;
            w_SCALA_PREC                := '';
            w_PIANO_PREC                := '';
            w_ZIPCODE_PREC              := rec.zipcode_prov;
            w_SCALA                     := rec.scala;
            w_PIANO                     := rec.piano;
            w_ZIPCODE                   := '';
            w_COD_EDIFICIO_CENS_PREC     := '';
            w_COD_EDIFICIO_CENS         := rec.cod_edificio_cens;
            w_COD_PRO_ATTO_DIV          := rec.cod_pro_atto_div;
            w_COD_COM_ATTO_DIV          := rec.cod_com_atto_div;
            w_DATA_DIV_GIU              := rec.data_div_giu;
            w_DATA_DIV_ANN              := rec.data_div_ann;
            w_COD_PRO_ATTO_DIV_PREC     := '';
            w_COD_COM_ATTO_DIV_PREC     := '';
            w_DATA_DIV_GIU_PREC         := '';
            w_DATA_DIV_ANN_PREC         := '';
            w_COD_PRO_ISCR_AIRE         := rec.cod_pro_iscr_aire;
            w_COD_COM_ISCR_AIRE         := rec.cod_com_iscr_aire;
            w_PROVINCIA_CONTEA_PREC     := rec.provincia_contea_prov;
            w_PRESSO_PREC               := rec.presso_prov;
            w_PROVINCIA_CONTEA          := '';
            w_PRESSO                    := '';
            w_ANNO_NAS_PREC             := '';
            w_ANNO_MAT_PREC             := '';
            w_ANNO_NAS                  := rec.anno_nas;
            w_ANNO_MAT                  := rec.anno_mat;
            w_SUB_INTERNO               := rec.sub_interno;
            w_CIVICO_ESTERNO            := '';
            w_CIVICO_INTERNO            := '';
            w_SUB_INTERNO_PREC          := '';
            w_CIVICO_ESTERNO_PREC       := '';
            w_CIVICO_INTERNO_PREC       := '';
            w_MATRICOLA_PD_PREC         := '';
            w_MATRICOLA_MD_PREC         := '';
            w_MATRICOLA_PD              := rec.matricola_pd;
            w_MATRICOLA_MD              := rec.matricola_md;
            w_DATA_INIZIO_NAZ           := rec.data_inizio_naz;
            w_DATA_INIZIO_NAZ_PREC      := '';
            w_ATTO_NAS_DIGITALE_PREC    := '';
            w_ATTO_NAS_TR_DIGITALE_PREC := '';
            w_ATTO_MAT_DIGITALE_PREC    := '';
            w_ATTO_MAT_TR_DIGITALE_PREC := '';
            w_ATTO_DIV_DIGITALE_PREC    := '';
            w_ATTO_VED_DIGITALE_PREC    := '';
            w_ATTO_MOR_DIGITALE_PREC    := '';
            w_ATTO_MOR_TR_DIGITALE_PREC := '';
            w_ATTO_NAS_DIGITALE         := rec.atto_nas_digitale;
            w_ATTO_NAS_TR_DIGITALE      := rec.atto_nas_tr_digitale;
            w_ATTO_MAT_DIGITALE         := rec.atto_mat_digitale;
            w_ATTO_MAT_TR_DIGITALE      := rec.atto_mat_tr_digitale;
            w_ATTO_DIV_DIGITALE         := rec.atto_div_digitale;
            w_ATTO_VED_DIGITALE         := rec.atto_ved_digitale;
            w_ATTO_MOR_DIGITALE         := rec.atto_mor_digitale;
            w_ATTO_MOR_TR_DIGITALE      := rec.atto_mor_tr_digitale;
            w_FLAG_METRICO_PREC         := '';
            w_PROGR_SNC_PREC            := '';
            w_FLAG_LETTERA_PREC         := '';
            w_FLAG_ESPONENTE_PREC       := '';
            w_FLAG_NUI_PREC             := '';
            w_NUI_PREC                  := '';
            w_COLORE_PREC               := '';
            w_CORTE_PREC                := '';
            w_INTERNO2_PREC             := '';
            w_SUB_INTERNO2_PREC         := '';
            w_SECONDARIO_PREC           := '';
            w_SCALA_ESTERNA_PREC        := '';
            w_FLAG_METRICO              := rec.flag_metrico;
            w_PROGR_SNC                 := rec.progr_snc;
            w_FLAG_LETTERA              := rec.flag_lettera;
            w_FLAG_ESPONENTE            := rec.flag_esponente;
            w_FLAG_NUI                  := rec.flag_nui;
            w_NUI                       := rec.nui;
            w_COLORE                    := rec.colore;
            w_CORTE                     := rec.corte;
            w_INTERNO2                  := rec.interno2;
            w_SUB_INTERNO2              := rec.sub_interno2;
            w_SECONDARIO                := rec.secondario;
            w_SCALA_ESTERNA             := rec.scala_esterna;

            w_parametri_log             := '[perf]'||' - '||
                                           'anno_pratica: '||w_anno_pratica||' - '||
                                           'pratica: '||w_pratica||' - '||
                                           'matricola: '||w_matricola||' - '||
                                           'cod_mov: '||w_cod_mov||' - '||
                                           'cod_eve: '||w_cod_eve||' - '||
                                           'cod_variazione: '||w_cod_variazione||' - '||
                                           'nucleo_partenza: '||w_nucleo_partenza||' - '||
                                           'cod_fam_prec: '||w_cod_fam_prec||' - '||
                                           'rapporto_par_prec: '||w_rapporto_par_prec||' - '||
                                           'nucleo_arrivo: '||w_nucleo_arrivo||' - '||
                                           'cod_fam: '||w_cod_fam||' - '||
                                           'rapporto_par: '||w_rapporto_par;
            w_return_log                := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);

            begin
              insert into anamov
                     (MATRICOLA, COD_MOV, COD_EVE, COD_VARIAZIONE,
                      DATA_EVE, COD_PRO_EVE, COD_COM_EVE, ANNO_PRATICA, PRATICA,
                      NUCLEO_PARTENZA, NUCLEO_ARRIVO,
                      COGNOME_NOME_PREC, STATO_CIVILE_PREC, SESSO_PREC,
                      COD_FISCALE_PREC, CF_CALCOLATO_PREC,
                      NAZIONALITA_PREC, DATA_INIZIO_NAZ_PREC,
                      PATERNITA_PREC, MATRICOLA_PD_PREC,
                      MATERNITA_PREC, MATRICOLA_MD_PREC,
                      COGNOME_NOME_CN_PREC, MATRICOLA_CN_PREC,
                      TITOLO_STUDIO_PREC, COD_PROF_PREC, ATTIVITA_PROF_PREC, POSIZIONE_PROF_PREC, PENSIONATO_PREC,
                      COD_FAM_PREC, INTESTATARIO_PREC, RAPPORTO_PAR_PREC,
                      COD_VIA_PREC, NUM_CIV_PREC, SUFFISSO_PREC, INTERNO_PREC, SUB_INTERNO_PREC, SCALA_PREC, PIANO_PREC,
                      FLAG_METRICO_PREC, PROGR_SNC_PREC, FLAG_LETTERA_PREC, FLAG_ESPONENTE_PREC,
                      FLAG_NUI_PREC, NUI_PREC, COLORE_PREC, CORTE_PREC, INTERNO2_PREC, SUB_INTERNO2_PREC,
                      SECONDARIO_PREC, SCALA_ESTERNA_PREC,
                      MATRICOLA_AIRE_PREC,
                      VIA_AIRE_PREC, COD_PRO_AIRE_PREC, COD_COM_AIRE_PREC, ZIPCODE_PREC,
                      PROVINCIA_CONTEA_PREC, PRESSO_PREC,
                      ANNO_CENS_PREC, SEZIONE_CENS_PREC, FOGLIO_CENS_PREC, COD_EDIFICIO_CENS_PREC,
                      COD_PRO_NAS_PREC, COD_COM_NAS_PREC, DATA_NAS_PREC, ANNO_NAS_PREC,
                      COD_PRO_ATTO_NAS_PREC, COD_COM_ATTO_NAS_PREC,
                      ANNO_ATTO_NAS_PREC, ATTO_NAS_PREC, PARTE_NAS_PREC, SERIE_NAS_PREC, UFFICIO_NAS_PREC,
                      ANNO_ATTO_NAS_TR_PREC, ATTO_NAS_TR_PREC, PARTE_NAS_TR_PREC, SERIE_NAS_TR_PREC, UFFICIO_NAS_TR_PREC,
                      ATTO_NAS_DIGITALE_PREC, ATTO_NAS_TR_DIGITALE_PREC,
                      COD_PRO_MAT_PREC, COD_COM_MAT_PREC, DATA_MAT_PREC, ANNO_MAT_PREC,
                      COD_PRO_ATTO_MAT_PREC, COD_COM_ATTO_MAT_PREC,
                      ANNO_ATTO_MAT_PREC, ATTO_MAT_PREC, PARTE_MAT_PREC, SERIE_MAT_PREC, UFFICIO_MAT_PREC,
                      ANNO_ATTO_MAT_TR_PREC, ATTO_MAT_TR_PREC, PARTE_MAT_TR_PREC, SERIE_MAT_TR_PREC, UFFICIO_MAT_TR_PREC,
                      ATTO_MAT_DIGITALE_PREC, ATTO_MAT_TR_DIGITALE_PREC,
                      COD_PRO_MOR_PREC, COD_COM_MOR_PREC, DATA_MOR_PREC,
                      COD_PRO_ATTO_MOR_PREC, COD_COM_ATTO_MOR_PREC,
                      ANNO_ATTO_MOR_PREC, ATTO_MOR_PREC, PARTE_MOR_PREC, SERIE_MOR_PREC, UFFICIO_MOR_PREC,
                      ANNO_ATTO_MOR_TR_PREC, ATTO_MOR_TR_PREC, PARTE_MOR_TR_PREC, SERIE_MOR_TR_PREC, UFFICIO_MOR_TR_PREC,
                      ATTO_MOR_DIGITALE_PREC, ATTO_MOR_TR_DIGITALE_PREC,
                      COD_PRO_VED_PREC, COD_COM_VED_PREC, DATA_VED_PREC,
                      COD_PRO_ATTO_VED_PREC, COD_COM_ATTO_VED_PREC,
                      ANNO_ATTO_VED_PREC, ATTO_VED_PREC, PARTE_VED_PREC, SERIE_VED_PREC, UFFICIO_VED_PREC,
                      ATTO_VED_DIGITALE_PREC,
                      COD_PRO_DIV_PREC, COD_COM_DIV_PREC, DATA_DIV_PREC, DATA_DIV_GIU_PREC, DATA_DIV_ANN_PREC,
                      COD_PRO_ATTO_DIV_PREC, COD_COM_ATTO_DIV_PREC,
                      ANNO_ATTO_DIV_PREC, ATTO_DIV_PREC, PARTE_DIV_PREC, SERIE_DIV_PREC, UFFICIO_DIV_PREC,
                      ATTO_DIV_DIGITALE_PREC,
                      COGNOME_NOME, STATO_CIVILE, SESSO,
                      COD_FISCALE, CF_CALCOLATO,
                      NAZIONALITA, DATA_INIZIO_NAZ,
                      PATERNITA, MATRICOLA_PD,
                      MATERNITA, MATRICOLA_MD,
                      COGNOME_NOME_CN, MATRICOLA_CN,
                      TITOLO_STUDIO, COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO,
                      COD_FAM, INTESTATARIO, RAPPORTO_PAR, DATA_INIZIO_FAM,
                      COD_VIA, NUM_CIV, SUFFISSO, INTERNO, SUB_INTERNO, SCALA, PIANO,
                      FLAG_METRICO, PROGR_SNC, FLAG_LETTERA, FLAG_ESPONENTE,
                      FLAG_NUI, NUI, COLORE, CORTE, INTERNO2, SUB_INTERNO2,
                      SECONDARIO, SCALA_ESTERNA,
                      MATRICOLA_AIRE,
                      VIA_AIRE, COD_PRO_AIRE, COD_COM_AIRE, ZIPCODE,
                      PROVINCIA_CONTEA, PRESSO,
                      COD_PRO_ISCR_AIRE, COD_COM_ISCR_AIRE,
                      DATA_INIZIO_RES,
                      ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS, COD_EDIFICIO_CENS,
                      COD_PRO_NAS, COD_COM_NAS, DATA_NAS, ANNO_NAS,
                      COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
                      ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS,
                      ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
                      ATTO_NAS_DIGITALE, ATTO_NAS_TR_DIGITALE,
                      COD_PRO_MAT, COD_COM_MAT, DATA_MAT, ANNO_MAT,
                      COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT,
                      ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
                      ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
                      ATTO_MAT_DIGITALE, ATTO_MAT_TR_DIGITALE,
                      COD_PRO_MOR, COD_COM_MOR, DATA_MOR,
                      COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR,
                      ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
                      ANNO_ATTO_MOR_TR, ATTO_MOR_TR, PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
                      ATTO_MOR_DIGITALE, ATTO_MOR_TR_DIGITALE,
                      COD_PRO_VED, COD_COM_VED, DATA_VED,
                      COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
                      ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
                      ATTO_VED_DIGITALE,
                      COD_PRO_DIV, COD_COM_DIV, DATA_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
                      COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV,
                      ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
                      ATTO_DIV_DIGITALE,
                      DATA_REG, TERMINALISTA,
                      ELETTORALE, ANNULLAMENTO,
                      ANNO_PROGR, NUMERO_PROGR,
                      NO_CONTEGGIO, NO_VANA
                     )
              select w_MATRICOLA, w_COD_MOV, w_COD_EVE, w_COD_VARIAZIONE,
                      w_DATA_EVE, w_COD_PRO_EVE, w_COD_COM_EVE, w_ANNO_PRATICA, w_PRATICA,
                      w_NUCLEO_PARTENZA, w_NUCLEO_ARRIVO,
                      w_COGNOME_NOME_PREC, w_STATO_CIVILE_PREC, w_SESSO_PREC,
                      w_COD_FISCALE_PREC, w_CF_CALCOLATO_PREC,
                      w_NAZIONALITA_PREC, w_DATA_INIZIO_NAZ_PREC,
                      w_PATERNITA_PREC, w_MATRICOLA_PD_PREC,
                      w_MATERNITA_PREC, w_MATRICOLA_MD_PREC,
                      w_COGNOME_NOME_CN_PREC, w_MATRICOLA_CN_PREC,
                      w_TITOLO_STUDIO_PREC, w_COD_PROF_PREC, w_ATTIVITA_PROF_PREC, w_POSIZIONE_PROF_PREC, w_PENSIONATO_PREC,
                      w_COD_FAM_PREC, w_INTESTATARIO_PREC, w_RAPPORTO_PAR_PREC,
                      w_COD_VIA_PREC, w_NUM_CIV_PREC, w_SUFFISSO_PREC, w_INTERNO_PREC, w_SUB_INTERNO_PREC, w_SCALA_PREC, w_PIANO_PREC,
                      w_FLAG_METRICO_PREC, w_PROGR_SNC_PREC, w_FLAG_LETTERA_PREC, w_FLAG_ESPONENTE_PREC,
                      w_FLAG_NUI_PREC, w_NUI_PREC, w_COLORE_PREC, w_CORTE_PREC, w_INTERNO2_PREC, w_SUB_INTERNO2_PREC,
                      w_SECONDARIO_PREC, w_SCALA_ESTERNA_PREC,
                      w_MATRICOLA_AIRE_PREC,
                      w_VIA_AIRE_PREC, w_COD_PRO_AIRE_PREC, w_COD_COM_AIRE_PREC, w_ZIPCODE_PREC,
                      w_PROVINCIA_CONTEA_PREC, w_PRESSO_PREC,
                      w_ANNO_CENS_PREC, w_SEZIONE_CENS_PREC, w_FOGLIO_CENS_PREC, w_COD_EDIFICIO_CENS_PREC,
                      w_COD_PRO_NAS_PREC, w_COD_COM_NAS_PREC, w_DATA_NAS_PREC, w_ANNO_NAS_PREC,
                      w_COD_PRO_ATTO_NAS_PREC, w_COD_COM_ATTO_NAS_PREC,
                      w_ANNO_ATTO_NAS_PREC, w_ATTO_NAS_PREC, w_PARTE_NAS_PREC, w_SERIE_NAS_PREC, w_UFFICIO_NAS_PREC,
                      w_ANNO_ATTO_NAS_TR_PREC, w_ATTO_NAS_TR_PREC, w_PARTE_NAS_TR_PREC, w_SERIE_NAS_TR_PREC, w_UFFICIO_NAS_TR_PREC,
                      w_ATTO_NAS_DIGITALE_PREC, w_ATTO_NAS_TR_DIGITALE_PREC,
                      w_COD_PRO_MAT_PREC, w_COD_COM_MAT_PREC, w_DATA_MAT_PREC, w_ANNO_MAT_PREC,
                      w_COD_PRO_ATTO_MAT_PREC, w_COD_COM_ATTO_MAT_PREC,
                      w_ANNO_ATTO_MAT_PREC, w_ATTO_MAT_PREC, w_PARTE_MAT_PREC, w_SERIE_MAT_PREC, w_UFFICIO_MAT_PREC,
                      w_ANNO_ATTO_MAT_TR_PREC, w_ATTO_MAT_TR_PREC, w_PARTE_MAT_TR_PREC, w_SERIE_MAT_TR_PREC, w_UFFICIO_MAT_TR_PREC,
                      w_ATTO_MAT_DIGITALE_PREC, w_ATTO_MAT_TR_DIGITALE_PREC,
                      w_COD_PRO_MOR_PREC, w_COD_COM_MOR_PREC, w_DATA_MOR_PREC,
                      w_COD_PRO_ATTO_MOR_PREC, w_COD_COM_ATTO_MOR_PREC,
                      w_ANNO_ATTO_MOR_PREC, w_ATTO_MOR_PREC, w_PARTE_MOR_PREC, w_SERIE_MOR_PREC, w_UFFICIO_MOR_PREC,
                      w_ANNO_ATTO_MOR_TR_PREC, w_ATTO_MOR_TR_PREC, w_PARTE_MOR_TR_PREC, w_SERIE_MOR_TR_PREC, w_UFFICIO_MOR_TR_PREC,
                      w_ATTO_MOR_DIGITALE_PREC, w_ATTO_MOR_TR_DIGITALE_PREC,
                      w_COD_PRO_VED_PREC, w_COD_COM_VED_PREC, w_DATA_VED_PREC,
                      w_COD_PRO_ATTO_VED_PREC, w_COD_COM_ATTO_VED_PREC,
                      w_ANNO_ATTO_VED_PREC, w_ATTO_VED_PREC, w_PARTE_VED_PREC, w_SERIE_VED_PREC, w_UFFICIO_VED_PREC,
                      w_ATTO_VED_DIGITALE_PREC,
                      w_COD_PRO_DIV_PREC, w_COD_COM_DIV_PREC, w_DATA_DIV_PREC, w_DATA_DIV_GIU_PREC, w_DATA_DIV_ANN_PREC,
                      w_COD_PRO_ATTO_DIV_PREC, w_COD_COM_ATTO_DIV_PREC,
                      w_ANNO_ATTO_DIV_PREC, w_ATTO_DIV_PREC, w_PARTE_DIV_PREC, w_SERIE_DIV_PREC, w_UFFICIO_DIV_PREC,
                      w_ATTO_DIV_DIGITALE_PREC,
                      w_COGNOME_NOME, w_STATO_CIVILE, w_SESSO,
                      w_COD_FISCALE, w_CF_CALCOLATO,
                      w_NAZIONALITA, w_DATA_INIZIO_NAZ,
                      w_PATERNITA, w_MATRICOLA_PD,
                      w_MATERNITA, w_MATRICOLA_MD,
                      w_COGNOME_NOME_CN, w_MATRICOLA_CN,
                      w_TITOLO_STUDIO, w_COD_PROF, w_ATTIVITA_PROF, w_POSIZIONE_PROF, w_PENSIONATO,
                      w_COD_FAM, w_INTESTATARIO, w_RAPPORTO_PAR, w_DATA_INIZIO_FAM,
                      w_COD_VIA, w_NUM_CIV, w_SUFFISSO, w_INTERNO, w_SUB_INTERNO, w_SCALA, w_PIANO,
                      w_FLAG_METRICO, w_PROGR_SNC, w_FLAG_LETTERA, w_FLAG_ESPONENTE,
                      w_FLAG_NUI, w_NUI, w_COLORE, w_CORTE, w_INTERNO2, w_SUB_INTERNO2,
                      w_SECONDARIO, w_SCALA_ESTERNA,
                      w_MATRICOLA_AIRE,
                      w_VIA_AIRE, w_COD_PRO_AIRE, w_COD_COM_AIRE, w_ZIPCODE,
                      w_PROVINCIA_CONTEA, w_PRESSO,
                      w_COD_PRO_ISCR_AIRE, w_COD_COM_ISCR_AIRE,
                      w_DATA_INIZIO_RES,
                      w_ANNO_CENS, w_SEZIONE_CENS, w_FOGLIO_CENS, w_COD_EDIFICIO_CENS,
                      w_COD_PRO_NAS, w_COD_COM_NAS, w_DATA_NAS, w_ANNO_NAS,
                      w_COD_PRO_ATTO_NAS, w_COD_COM_ATTO_NAS,
                      w_ANNO_ATTO_NAS, w_ATTO_NAS, w_PARTE_NAS, w_SERIE_NAS, w_UFFICIO_NAS,
                      w_ANNO_ATTO_NAS_TR, w_ATTO_NAS_TR, w_PARTE_NAS_TR, w_SERIE_NAS_TR, w_UFFICIO_NAS_TR,
                      w_ATTO_NAS_DIGITALE, w_ATTO_NAS_TR_DIGITALE,
                      w_COD_PRO_MAT, w_COD_COM_MAT, w_DATA_MAT, w_ANNO_MAT,
                      w_COD_PRO_ATTO_MAT, w_COD_COM_ATTO_MAT,
                      w_ANNO_ATTO_MAT, w_ATTO_MAT, w_PARTE_MAT, w_SERIE_MAT, w_UFFICIO_MAT,
                      w_ANNO_ATTO_MAT_TR, w_ATTO_MAT_TR, w_PARTE_MAT_TR, w_SERIE_MAT_TR, w_UFFICIO_MAT_TR,
                      w_ATTO_MAT_DIGITALE, w_ATTO_MAT_TR_DIGITALE,
                      w_COD_PRO_MOR, w_COD_COM_MOR, w_DATA_MOR,
                      w_COD_PRO_ATTO_MOR, w_COD_COM_ATTO_MOR,
                      w_ANNO_ATTO_MOR, w_ATTO_MOR, w_PARTE_MOR, w_SERIE_MOR, w_UFFICIO_MOR,
                      w_ANNO_ATTO_MOR_TR, w_ATTO_MOR_TR, w_PARTE_MOR_TR, w_SERIE_MOR_TR, w_UFFICIO_MOR_TR,
                      w_ATTO_MOR_DIGITALE, w_ATTO_MOR_TR_DIGITALE,
                      w_COD_PRO_VED, w_COD_COM_VED, w_DATA_VED,
                      w_COD_PRO_ATTO_VED, w_COD_COM_ATTO_VED,
                      w_ANNO_ATTO_VED, w_ATTO_VED, w_PARTE_VED, w_SERIE_VED, w_UFFICIO_VED,
                      w_ATTO_VED_DIGITALE,
                      w_COD_PRO_DIV, w_COD_COM_DIV, w_DATA_DIV, w_DATA_DIV_GIU, w_DATA_DIV_ANN,
                      w_COD_PRO_ATTO_DIV, w_COD_COM_ATTO_DIV,
                      w_ANNO_ATTO_DIV, w_ATTO_DIV, w_PARTE_DIV, w_SERIE_DIV, w_UFFICIO_DIV,
                      w_ATTO_DIV_DIGITALE,
                      w_DATA_REG, w_TERMINALISTA,
                      w_ELETTORALE, w_ANNULLAMENTO,
                      w_ANNO_PROGR, w_NUMERO_PROGR,
                      w_NO_CONTEGGIO, w_NO_VANA
                from dual
               where not exists (select 1 from anamov b
                                  where b.matricola               = w_matricola
                                    and b.cod_mov                 = w_cod_mov
                                    and b.cod_eve                 = w_cod_eve
                                    and nvl(b.cod_variazione,' ') = nvl(w_cod_variazione,' ')
                                    and b.pratica                 = w_pratica
                                    and b.anno_pratica            = w_anno_pratica
                                    and b.data_eve                = w_data_eve)
              ;
              if sql%found then
                 w_return := 1;
                 for rec_sen in sel_sen loop
                     begin
                       insert into anasen
                              (MATRICOLA, ROWID_MOV, ANNO_PROGR_MOV, NUMERO_PROGR_MOV,
                               TIPO_SENTENZA, COD_PRO_TRIB, COD_COM_TRIB, DATA_DECRETO, NUMERO_DECRETO, D_DATA_DECRETO,
                               COD_PRO_ATTO_TR, COD_COM_ATTO_TR, DATA_ATTO_TR, D_DATA_ATTO_TR,
                               ANNO_ATTO_TR, ATTO_TR, PARTE_ATTO_TR, SERIE_ATTO_TR, UFFICIO_ATTO_TR, ATTO_TR_DIGITALE,
                               PRIVACY,
                               TIPO_PROVVEDIMENTO, ENTE_PROVVEDIMENTO, AUTORE_PROVVEDIMENTO,
                               ID,
                               ID_ANAMOV,
                               ANAGRAFE_TPR, TIPO_EVENTO_TPR, ANNO_PRATICA_TPR, PRATICA_TPR, ID_ANATPR)
                       values (rec_sen.MATRICOLA, to_char(null), w_ANNO_PROGR, w_NUMERO_PROGR,
                               rec_sen.TIPO_SENTENZA, rec_sen.COD_PRO_TRIB, rec_sen.COD_COM_TRIB,
                               rec_sen.DATA_DECRETO, rec_sen.NUMERO_DECRETO, rec_sen.D_DATA_DECRETO,
                               rec_sen.COD_PRO_ATTO_TR, rec_sen.COD_COM_ATTO_TR, rec_sen.DATA_ATTO_TR, rec_sen.D_DATA_ATTO_TR,
                               rec_sen.ANNO_ATTO_TR, rec_sen.ATTO_TR, rec_sen.PARTE_ATTO_TR, rec_sen.SERIE_ATTO_TR, rec_sen.UFFICIO_ATTO_TR,
                               rec_sen.ATTO_TR_DIGITALE,
                               rec_sen.PRIVACY,
                               rec_sen.TIPO_PROVVEDIMENTO, rec_sen.ENTE_PROVVEDIMENTO, rec_sen.AUTORE_PROVVEDIMENTO,
                               to_number(null),
                               w_ID_ANAMOV,
                               to_char(null), to_char(null), to_number(null), to_number(null), to_number(null)
                              )
                       ;
                     exception
                       when others then
                            null;
                     end;
                 end loop;
              end if;
            exception
              when others then
                   w_errore := 'Errore in ins_anamov - perf (matricola: '||rec.matricola||')';
                   w_return := -1;
            end;
        end loop;

        w_conta_apm_prov := 0;
        for rec in sel_apm_prov loop
            w_conta_apm_prov := w_conta_apm_prov + 1;
            if w_conta_apm_prov = 1 then
               if rec.w_ord_1 = 1 then
                  w_INTESTATARIO_PREC := rec.cognome_nome;
               else
                  w_INTESTATARIO_PREC := rec.intestatario_prov;
               end if;
            end if;

            w_ANNO_PROGR   := '';
            w_NUMERO_PROGR := '';
            w_ID_ANAMOV    := '';
            ANAMOV_NR(w_ANNO_PROGR, w_NUMERO_PROGR);
            w_ID_ANAMOV                 := w_ANNO_PROGR||lpad(w_NUMERO_PROGR,6,'0');
--
            w_MATRICOLA                 := rec.matricola;
            w_COD_MOV                   := 12;
            w_COD_EVE                   := 90;
            w_COD_VARIAZIONE            := rec.cod_variazione;
            w_DATA_EVE                  := rec.data_eve;
            w_COD_PRO_EVE               := '';
            w_COD_COM_EVE               := '';
            w_ANNO_PRATICA              := a_anno_pratica;
            w_PRATICA                   := a_pratica;
            w_NUCLEO_PARTENZA           := rec.nucleo_partenza;
            w_NUCLEO_ARRIVO             := '';
            w_DATA_REG                  := to_char(sysdate,'j');
            w_TERMINALISTA              := a_terminalista;
            w_ELETTORALE                := '';
            w_ANNULLAMENTO              := '';
            w_NO_CONTEGGIO              := ''; -- lo calcola il trigger?
            w_NO_VANA                   := '';
--
            w_COGNOME_NOME_PREC         := '';
            w_STATO_CIVILE_PREC         := '';
            w_SESSO_PREC                := '';
            w_NAZIONALITA_PREC          := '';
            w_PATERNITA_PREC            := '';
            w_MATERNITA_PREC            := '';
            w_TITOLO_STUDIO_PREC        := '';
            w_COD_PROF_PREC             := '';
            w_ATTIVITA_PROF_PREC        := '';
            w_POSIZIONE_PROF_PREC       := '';
            w_PENSIONATO_PREC           := '';
            w_COD_FAM_PREC              := rec.cod_fam_prov;
--            w_INTESTATARIO_PREC         := '';
            w_RAPPORTO_PAR_PREC         := rec.rapporto_par_prov;
            w_COD_VIA_PREC              := '';
            w_NUM_CIV_PREC              := '';
            w_SUFFISSO_PREC             := '';
            w_INTERNO_PREC              := '';
            w_VIA_AIRE_PREC             := '';
            w_COD_PRO_AIRE_PREC         := '';
            w_COD_COM_AIRE_PREC         := '';
            w_COGNOME_NOME_CN_PREC      := '';
            w_MATRICOLA_CN_PREC         := '';
            w_ANNO_CENS_PREC            := '';
            w_SEZIONE_CENS_PREC         := '';
            w_FOGLIO_CENS_PREC          := '';
            w_COD_PRO_NAS_PREC          := '';
            w_COD_COM_NAS_PREC          := '';
            w_DATA_NAS_PREC             := '';
            w_COD_PRO_ATTO_NAS_PREC     := '';
            w_COD_COM_ATTO_NAS_PREC     := '';
            w_ANNO_ATTO_NAS_PREC        := '';
            w_ATTO_NAS_PREC             := '';
            w_PARTE_NAS_PREC            := '';
            w_SERIE_NAS_PREC            := '';
            w_UFFICIO_NAS_PREC          := '';
            w_ANNO_ATTO_NAS_TR_PREC     := '';
            w_ATTO_NAS_TR_PREC          := '';
            w_PARTE_NAS_TR_PREC         := '';
            w_SERIE_NAS_TR_PREC         := '';
            w_UFFICIO_NAS_TR_PREC       := '';
            w_COD_PRO_MAT_PREC          := '';
            w_COD_COM_MAT_PREC          := '';
            w_DATA_MAT_PREC             := '';
            w_ANNO_ATTO_MAT_PREC        := '';
            w_ATTO_MAT_PREC             := '';
            w_PARTE_MAT_PREC            := '';
            w_SERIE_MAT_PREC            := '';
            w_UFFICIO_MAT_PREC          := '';
            w_ANNO_ATTO_MAT_TR_PREC     := '';
            w_ATTO_MAT_TR_PREC          := '';
            w_PARTE_MAT_TR_PREC         := '';
            w_SERIE_MAT_TR_PREC         := '';
            w_UFFICIO_MAT_TR_PREC       := '';
            w_COD_PRO_MOR_PREC          := '';
            w_COD_COM_MOR_PREC          := '';
            w_DATA_MOR_PREC             := '';
            w_ANNO_ATTO_MOR_PREC        := '';
            w_ATTO_MOR_PREC             := '';
            w_PARTE_MOR_PREC            := '';
            w_SERIE_MOR_PREC            := '';
            w_UFFICIO_MOR_PREC          := '';
            w_ANNO_ATTO_MOR_TR_PREC     := '';
            w_ATTO_MOR_TR_PREC          := '';
            w_PARTE_MOR_TR_PREC         := '';
            w_SERIE_MOR_TR_PREC         := '';
            w_UFFICIO_MOR_TR_PREC       := '';
            w_COD_PRO_VED_PREC          := '';
            w_COD_COM_VED_PREC          := '';
            w_DATA_VED_PREC             := '';
            w_ANNO_ATTO_VED_PREC        := '';
            w_ATTO_VED_PREC             := '';
            w_PARTE_VED_PREC            := '';
            w_SERIE_VED_PREC            := '';
            w_UFFICIO_VED_PREC          := '';
            w_COD_FISCALE_PREC          := '';
            w_COGNOME_NOME              := rec.cognome_nome;
            w_STATO_CIVILE              := rec.stato_civile;
            w_SESSO                     := rec.sesso;
            w_NAZIONALITA               := rec.nazionalita;
            w_PATERNITA                 := rec.paternita;
            w_MATERNITA                 := rec.maternita;
            w_TITOLO_STUDIO             := rec.titolo_studio;
            w_COD_PROF                  := rec.cod_prof;
            w_ATTIVITA_PROF             := rec.attivita_prof;
            w_POSIZIONE_PROF            := rec.posizione_prof;
            w_PENSIONATO                := rec.pensionato;
            w_COD_FAM                   := rec.cod_fam_prov; --nvl(a_cod_fam,rec.cod_fam_dest);
            w_INTESTATARIO              := rec.intestatario_prov; --nvl(a_intestatario,rec.intestatario_dest);
            w_RAPPORTO_PAR              := rec.rapporto_par_dest;
            w_DATA_INIZIO_FAM           := rec.data_eve;
            w_COD_VIA                   := rec.cod_via;
            w_NUM_CIV                   := rec.num_civ;
            w_SUFFISSO                  := rec.suffisso;
            w_INTERNO                   := rec.interno;
            w_VIA_AIRE                  := '';
            w_COD_PRO_AIRE              := '';
            w_COD_COM_AIRE              := '';
            w_DATA_INIZIO_RES           := '';
            w_COGNOME_NOME_CN           := rec.cognome_nome_cn;
            w_MATRICOLA_CN              := rec.matricola_cn;
            w_ANNO_CENS                 := rec.anno_cens;
            w_SEZIONE_CENS              := rec.sezione_cens;
            w_FOGLIO_CENS               := rec.foglio_cens;
            w_COD_PRO_NAS               := rec.cod_pro_nas;
            w_COD_COM_NAS               := rec.cod_com_nas;
            w_DATA_NAS                  := rec.data_nas;
            w_COD_PRO_ATTO_NAS          := rec.cod_pro_atto_nas;
            w_COD_COM_ATTO_NAS          := rec.cod_com_atto_nas;
            w_ANNO_ATTO_NAS             := rec.anno_atto_nas;
            w_ATTO_NAS                  := rec.atto_nas;
            w_PARTE_NAS                 := rec.parte_nas;
            w_SERIE_NAS                 := rec.serie_nas;
            w_UFFICIO_NAS               := rec.ufficio_nas;
            w_ANNO_ATTO_NAS_TR          := rec.anno_atto_nas;
            w_ATTO_NAS_TR               := rec.atto_nas_tr;
            w_PARTE_NAS_TR              := rec.parte_nas_tr;
            w_SERIE_NAS_TR              := rec.serie_nas_tr;
            w_UFFICIO_NAS_TR            := rec.ufficio_nas_tr;
            w_COD_PRO_MAT               := rec.cod_pro_mat;
            w_COD_COM_MAT               := rec.cod_com_mat;
            w_DATA_MAT                  := rec.data_mat;
            w_ANNO_ATTO_MAT             := rec.anno_atto_mat;
            w_ATTO_MAT                  := rec.atto_mat;
            w_PARTE_MAT                 := rec.parte_mat;
            w_SERIE_MAT                 := rec.serie_mat;
            w_UFFICIO_MAT               := rec.ufficio_mat;
            w_ANNO_ATTO_MAT_TR          := rec.anno_atto_mat_tr;
            w_ATTO_MAT_TR               := rec.atto_mat_tr;
            w_PARTE_MAT_TR              := rec.parte_mat_tr;
            w_SERIE_MAT_TR              := rec.serie_mat_tr;
            w_UFFICIO_MAT_TR            := rec.ufficio_mat_tr;
            w_COD_PRO_MOR               := '';
            w_COD_COM_MOR               := '';
            w_DATA_MOR                  := '';
            w_ANNO_ATTO_MOR             := '';
            w_ATTO_MOR                  := '';
            w_PARTE_MOR                 := '';
            w_SERIE_MOR                 := '';
            w_UFFICIO_MOR               := '';
            w_ANNO_ATTO_MOR_TR          := '';
            w_ATTO_MOR_TR               := '';
            w_PARTE_MOR_TR              := '';
            w_SERIE_MOR_TR              := '';
            w_UFFICIO_MOR_TR            := '';
            w_COD_PRO_VED               := rec.cod_pro_ved;
            w_COD_COM_VED               := rec.cod_com_ved;
            w_DATA_VED                  := rec.data_ved;
            w_ANNO_ATTO_VED             := rec.anno_atto_ved;
            w_ATTO_VED                  := rec.atto_ved;
            w_PARTE_VED                 := rec.parte_ved;
            w_SERIE_VED                 := rec.serie_ved;
            w_UFFICIO_VED               := rec.ufficio_ved;
            w_COD_FISCALE               := rec.cod_fiscale;
            w_COD_PRO_DIV_PREC          := '';
            w_COD_COM_DIV_PREC          := '';
            w_DATA_DIV_PREC             := '';
            w_ANNO_ATTO_DIV_PREC        := '';
            w_ATTO_DIV_PREC             := '';
            w_PARTE_DIV_PREC            := '';
            w_SERIE_DIV_PREC            := '';
            w_UFFICIO_DIV_PREC          := '';
            w_COD_PRO_DIV               := rec.cod_pro_div;
            w_COD_COM_DIV               := rec.cod_com_div;
            w_DATA_DIV                  := rec.data_div;
            w_ANNO_ATTO_DIV             := rec.anno_atto_div;
            w_ATTO_DIV                  := rec.atto_div;
            w_PARTE_DIV                 := rec.parte_div;
            w_SERIE_DIV                 := rec.serie_div;
            w_UFFICIO_DIV               := rec.ufficio_div;
            w_MATRICOLA_AIRE_PREC       := '';
            w_MATRICOLA_AIRE            := '';
            w_COD_PRO_ATTO_MAT_PREC     := '';
            w_COD_COM_ATTO_MAT_PREC     := '';
            w_COD_PRO_ATTO_VED_PREC     := '';
            w_COD_COM_ATTO_VED_PREC     := '';
            w_COD_PRO_ATTO_MOR_PREC     := '';
            w_COD_COM_ATTO_MOR_PREC     := '';
            w_COD_PRO_ATTO_MAT          := rec.cod_pro_atto_mat;
            w_COD_COM_ATTO_MAT          := rec.cod_com_atto_mat;
            w_COD_PRO_ATTO_VED          := rec.cod_pro_atto_ved;
            w_COD_COM_ATTO_VED          := rec.cod_com_atto_ved;
            w_COD_PRO_ATTO_MOR          := rec.cod_pro_atto_mor;
            w_COD_COM_ATTO_MOR          := rec.cod_com_atto_mor;
            w_CF_CALCOLATO_PREC         := '';
            w_CF_CALCOLATO              := rec.cf_calcolato;
            w_SCALA_PREC                := '';
            w_PIANO_PREC                := '';
            w_ZIPCODE_PREC              := '';
            w_SCALA                     := rec.scala;
            w_PIANO                     := rec.piano;
            w_ZIPCODE                   := '';
            w_COD_EDIFICIO_CENS_PREC     := '';
            w_COD_EDIFICIO_CENS         := rec.cod_edificio_cens;
            w_COD_PRO_ATTO_DIV          := rec.cod_pro_atto_div;
            w_COD_COM_ATTO_DIV          := rec.cod_com_atto_div;
            w_DATA_DIV_GIU              := rec.data_div_giu;
            w_DATA_DIV_ANN              := rec.data_div_ann;
            w_COD_PRO_ATTO_DIV_PREC     := '';
            w_COD_COM_ATTO_DIV_PREC     := '';
            w_DATA_DIV_GIU_PREC         := '';
            w_DATA_DIV_ANN_PREC         := '';
            w_COD_PRO_ISCR_AIRE         := '';
            w_COD_COM_ISCR_AIRE         := ''	;
            w_PROVINCIA_CONTEA_PREC     := '';
            w_PRESSO_PREC               := '';
            w_PROVINCIA_CONTEA          := '';
            w_PRESSO                    := '';
            w_ANNO_NAS_PREC             := '';
            w_ANNO_MAT_PREC             := '';
            w_ANNO_NAS                  := rec.anno_nas;
            w_ANNO_MAT                  := rec.anno_mat;
            w_SUB_INTERNO               := rec.sub_interno;
            w_CIVICO_ESTERNO            := '';
            w_CIVICO_INTERNO            := '';
            w_SUB_INTERNO_PREC          := '';
            w_CIVICO_ESTERNO_PREC       := '';
            w_CIVICO_INTERNO_PREC       := '';
            w_MATRICOLA_PD_PREC         := '';
            w_MATRICOLA_MD_PREC         := '';
            w_MATRICOLA_PD              := rec.matricola_pd;
            w_MATRICOLA_MD              := rec.matricola_md;
            w_DATA_INIZIO_NAZ           := rec.data_inizio_naz;
            w_DATA_INIZIO_NAZ_PREC      := '';
            w_ATTO_NAS_DIGITALE_PREC    := '';
            w_ATTO_NAS_TR_DIGITALE_PREC := '';
            w_ATTO_MAT_DIGITALE_PREC    := '';
            w_ATTO_MAT_TR_DIGITALE_PREC := '';
            w_ATTO_DIV_DIGITALE_PREC    := '';
            w_ATTO_VED_DIGITALE_PREC    := '';
            w_ATTO_MOR_DIGITALE_PREC    := '';
            w_ATTO_MOR_TR_DIGITALE_PREC := '';
            w_ATTO_NAS_DIGITALE         := rec.atto_nas_digitale;
            w_ATTO_NAS_TR_DIGITALE      := rec.atto_nas_tr_digitale;
            w_ATTO_MAT_DIGITALE         := rec.atto_mat_digitale;
            w_ATTO_MAT_TR_DIGITALE      := rec.atto_mat_tr_digitale;
            w_ATTO_DIV_DIGITALE         := rec.atto_div_digitale;
            w_ATTO_VED_DIGITALE         := rec.atto_ved_digitale;
            w_ATTO_MOR_DIGITALE         := rec.atto_mor_digitale;
            w_ATTO_MOR_TR_DIGITALE      := rec.atto_mor_tr_digitale;
            w_FLAG_METRICO_PREC         := '';
            w_PROGR_SNC_PREC            := '';
            w_FLAG_LETTERA_PREC         := '';
            w_FLAG_ESPONENTE_PREC       := '';
            w_FLAG_NUI_PREC             := '';
            w_NUI_PREC                  := '';
            w_COLORE_PREC               := '';
            w_CORTE_PREC                := '';
            w_INTERNO2_PREC             := '';
            w_SUB_INTERNO2_PREC         := '';
            w_SECONDARIO_PREC           := '';
            w_SCALA_ESTERNA_PREC        := '';
            w_FLAG_METRICO              := rec.flag_metrico;
            w_PROGR_SNC                 := rec.progr_snc;
            w_FLAG_LETTERA              := rec.flag_lettera;
            w_FLAG_ESPONENTE            := rec.flag_esponente;
            w_FLAG_NUI                  := rec.flag_nui;
            w_NUI                       := rec.nui;
            w_COLORE                    := rec.colore;
            w_CORTE                     := rec.corte;
            w_INTERNO2                  := rec.interno2;
            w_SUB_INTERNO2              := rec.sub_interno2;
            w_SECONDARIO                := rec.secondario;
            w_SCALA_ESTERNA             := rec.scala_esterna;

            w_parametri_log             := '[prov]'||' - '||
                                           'anno_pratica: '||w_anno_pratica||' - '||
                                           'pratica: '||w_pratica||' - '||
                                           'matricola: '||w_matricola||' - '||
                                           'cod_mov: '||w_cod_mov||' - '||
                                           'cod_eve: '||w_cod_eve||' - '||
                                           'cod_variazione: '||w_cod_variazione||' - '||
                                           'nucleo_partenza: '||w_nucleo_partenza||' - '||
                                           'cod_fam_prec: '||w_cod_fam_prec||' - '||
                                           'rapporto_par_prec: '||w_rapporto_par_prec||' - '||
                                           'nucleo_arrivo: '||w_nucleo_arrivo||' - '||
                                           'cod_fam: '||w_cod_fam||' - '||
                                           'rapporto_par: '||w_rapporto_par;
            w_return_log                := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);

            begin
              insert into anamov
                     (MATRICOLA, COD_MOV, COD_EVE, COD_VARIAZIONE,
                      DATA_EVE, COD_PRO_EVE, COD_COM_EVE, ANNO_PRATICA, PRATICA,
                      NUCLEO_PARTENZA, NUCLEO_ARRIVO,
                      COGNOME_NOME_PREC, STATO_CIVILE_PREC, SESSO_PREC,
                      COD_FISCALE_PREC, CF_CALCOLATO_PREC,
                      NAZIONALITA_PREC, DATA_INIZIO_NAZ_PREC,
                      PATERNITA_PREC, MATRICOLA_PD_PREC,
                      MATERNITA_PREC, MATRICOLA_MD_PREC,
                      COGNOME_NOME_CN_PREC, MATRICOLA_CN_PREC,
                      TITOLO_STUDIO_PREC, COD_PROF_PREC, ATTIVITA_PROF_PREC, POSIZIONE_PROF_PREC, PENSIONATO_PREC,
                      COD_FAM_PREC, INTESTATARIO_PREC, RAPPORTO_PAR_PREC,
                      COD_VIA_PREC, NUM_CIV_PREC, SUFFISSO_PREC, INTERNO_PREC, SUB_INTERNO_PREC, SCALA_PREC, PIANO_PREC,
                      FLAG_METRICO_PREC, PROGR_SNC_PREC, FLAG_LETTERA_PREC, FLAG_ESPONENTE_PREC,
                      FLAG_NUI_PREC, NUI_PREC, COLORE_PREC, CORTE_PREC, INTERNO2_PREC, SUB_INTERNO2_PREC,
                      SECONDARIO_PREC, SCALA_ESTERNA_PREC,
                      MATRICOLA_AIRE_PREC,
                      VIA_AIRE_PREC, COD_PRO_AIRE_PREC, COD_COM_AIRE_PREC, ZIPCODE_PREC,
                      PROVINCIA_CONTEA_PREC, PRESSO_PREC,
                      ANNO_CENS_PREC, SEZIONE_CENS_PREC, FOGLIO_CENS_PREC, COD_EDIFICIO_CENS_PREC,
                      COD_PRO_NAS_PREC, COD_COM_NAS_PREC, DATA_NAS_PREC, ANNO_NAS_PREC,
                      COD_PRO_ATTO_NAS_PREC, COD_COM_ATTO_NAS_PREC,
                      ANNO_ATTO_NAS_PREC, ATTO_NAS_PREC, PARTE_NAS_PREC, SERIE_NAS_PREC, UFFICIO_NAS_PREC,
                      ANNO_ATTO_NAS_TR_PREC, ATTO_NAS_TR_PREC, PARTE_NAS_TR_PREC, SERIE_NAS_TR_PREC, UFFICIO_NAS_TR_PREC,
                      ATTO_NAS_DIGITALE_PREC, ATTO_NAS_TR_DIGITALE_PREC,
                      COD_PRO_MAT_PREC, COD_COM_MAT_PREC, DATA_MAT_PREC, ANNO_MAT_PREC,
                      COD_PRO_ATTO_MAT_PREC, COD_COM_ATTO_MAT_PREC,
                      ANNO_ATTO_MAT_PREC, ATTO_MAT_PREC, PARTE_MAT_PREC, SERIE_MAT_PREC, UFFICIO_MAT_PREC,
                      ANNO_ATTO_MAT_TR_PREC, ATTO_MAT_TR_PREC, PARTE_MAT_TR_PREC, SERIE_MAT_TR_PREC, UFFICIO_MAT_TR_PREC,
                      ATTO_MAT_DIGITALE_PREC, ATTO_MAT_TR_DIGITALE_PREC,
                      COD_PRO_MOR_PREC, COD_COM_MOR_PREC, DATA_MOR_PREC,
                      COD_PRO_ATTO_MOR_PREC, COD_COM_ATTO_MOR_PREC,
                      ANNO_ATTO_MOR_PREC, ATTO_MOR_PREC, PARTE_MOR_PREC, SERIE_MOR_PREC, UFFICIO_MOR_PREC,
                      ANNO_ATTO_MOR_TR_PREC, ATTO_MOR_TR_PREC, PARTE_MOR_TR_PREC, SERIE_MOR_TR_PREC, UFFICIO_MOR_TR_PREC,
                      ATTO_MOR_DIGITALE_PREC, ATTO_MOR_TR_DIGITALE_PREC,
                      COD_PRO_VED_PREC, COD_COM_VED_PREC, DATA_VED_PREC,
                      COD_PRO_ATTO_VED_PREC, COD_COM_ATTO_VED_PREC,
                      ANNO_ATTO_VED_PREC, ATTO_VED_PREC, PARTE_VED_PREC, SERIE_VED_PREC, UFFICIO_VED_PREC,
                      ATTO_VED_DIGITALE_PREC,
                      COD_PRO_DIV_PREC, COD_COM_DIV_PREC, DATA_DIV_PREC, DATA_DIV_GIU_PREC, DATA_DIV_ANN_PREC,
                      COD_PRO_ATTO_DIV_PREC, COD_COM_ATTO_DIV_PREC,
                      ANNO_ATTO_DIV_PREC, ATTO_DIV_PREC, PARTE_DIV_PREC, SERIE_DIV_PREC, UFFICIO_DIV_PREC,
                      ATTO_DIV_DIGITALE_PREC,
                      COGNOME_NOME, STATO_CIVILE, SESSO,
                      COD_FISCALE, CF_CALCOLATO,
                      NAZIONALITA, DATA_INIZIO_NAZ,
                      PATERNITA, MATRICOLA_PD,
                      MATERNITA, MATRICOLA_MD,
                      COGNOME_NOME_CN, MATRICOLA_CN,
                      TITOLO_STUDIO, COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO,
                      COD_FAM, INTESTATARIO, RAPPORTO_PAR, DATA_INIZIO_FAM,
                      COD_VIA, NUM_CIV, SUFFISSO, INTERNO, SUB_INTERNO, SCALA, PIANO,
                      FLAG_METRICO, PROGR_SNC, FLAG_LETTERA, FLAG_ESPONENTE,
                      FLAG_NUI, NUI, COLORE, CORTE, INTERNO2, SUB_INTERNO2,
                      SECONDARIO, SCALA_ESTERNA,
                      MATRICOLA_AIRE,
                      VIA_AIRE, COD_PRO_AIRE, COD_COM_AIRE, ZIPCODE,
                      PROVINCIA_CONTEA, PRESSO,
                      COD_PRO_ISCR_AIRE, COD_COM_ISCR_AIRE,
                      DATA_INIZIO_RES,
                      ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS, COD_EDIFICIO_CENS,
                      COD_PRO_NAS, COD_COM_NAS, DATA_NAS, ANNO_NAS,
                      COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
                      ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS,
                      ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
                      ATTO_NAS_DIGITALE, ATTO_NAS_TR_DIGITALE,
                      COD_PRO_MAT, COD_COM_MAT, DATA_MAT, ANNO_MAT,
                      COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT,
                      ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
                      ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
                      ATTO_MAT_DIGITALE, ATTO_MAT_TR_DIGITALE,
                      COD_PRO_MOR, COD_COM_MOR, DATA_MOR,
                      COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR,
                      ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
                      ANNO_ATTO_MOR_TR, ATTO_MOR_TR, PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
                      ATTO_MOR_DIGITALE, ATTO_MOR_TR_DIGITALE,
                      COD_PRO_VED, COD_COM_VED, DATA_VED,
                      COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
                      ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
                      ATTO_VED_DIGITALE,
                      COD_PRO_DIV, COD_COM_DIV, DATA_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
                      COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV,
                      ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
                      ATTO_DIV_DIGITALE,
                      DATA_REG, TERMINALISTA,
                      ELETTORALE, ANNULLAMENTO,
                      ANNO_PROGR, NUMERO_PROGR,
                      NO_CONTEGGIO, NO_VANA
                     )
              select w_MATRICOLA, w_COD_MOV, w_COD_EVE, w_COD_VARIAZIONE,
                      w_DATA_EVE, w_COD_PRO_EVE, w_COD_COM_EVE, w_ANNO_PRATICA, w_PRATICA,
                      w_NUCLEO_PARTENZA, w_NUCLEO_ARRIVO,
                      w_COGNOME_NOME_PREC, w_STATO_CIVILE_PREC, w_SESSO_PREC,
                      w_COD_FISCALE_PREC, w_CF_CALCOLATO_PREC,
                      w_NAZIONALITA_PREC, w_DATA_INIZIO_NAZ_PREC,
                      w_PATERNITA_PREC, w_MATRICOLA_PD_PREC,
                      w_MATERNITA_PREC, w_MATRICOLA_MD_PREC,
                      w_COGNOME_NOME_CN_PREC, w_MATRICOLA_CN_PREC,
                      w_TITOLO_STUDIO_PREC, w_COD_PROF_PREC, w_ATTIVITA_PROF_PREC, w_POSIZIONE_PROF_PREC, w_PENSIONATO_PREC,
                      w_COD_FAM_PREC, w_INTESTATARIO_PREC, w_RAPPORTO_PAR_PREC,
                      w_COD_VIA_PREC, w_NUM_CIV_PREC, w_SUFFISSO_PREC, w_INTERNO_PREC, w_SUB_INTERNO_PREC, w_SCALA_PREC, w_PIANO_PREC,
                      w_FLAG_METRICO_PREC, w_PROGR_SNC_PREC, w_FLAG_LETTERA_PREC, w_FLAG_ESPONENTE_PREC,
                      w_FLAG_NUI_PREC, w_NUI_PREC, w_COLORE_PREC, w_CORTE_PREC, w_INTERNO2_PREC, w_SUB_INTERNO2_PREC,
                      w_SECONDARIO_PREC, w_SCALA_ESTERNA_PREC,
                      w_MATRICOLA_AIRE_PREC,
                      w_VIA_AIRE_PREC, w_COD_PRO_AIRE_PREC, w_COD_COM_AIRE_PREC, w_ZIPCODE_PREC,
                      w_PROVINCIA_CONTEA_PREC, w_PRESSO_PREC,
                      w_ANNO_CENS_PREC, w_SEZIONE_CENS_PREC, w_FOGLIO_CENS_PREC, w_COD_EDIFICIO_CENS_PREC,
                      w_COD_PRO_NAS_PREC, w_COD_COM_NAS_PREC, w_DATA_NAS_PREC, w_ANNO_NAS_PREC,
                      w_COD_PRO_ATTO_NAS_PREC, w_COD_COM_ATTO_NAS_PREC,
                      w_ANNO_ATTO_NAS_PREC, w_ATTO_NAS_PREC, w_PARTE_NAS_PREC, w_SERIE_NAS_PREC, w_UFFICIO_NAS_PREC,
                      w_ANNO_ATTO_NAS_TR_PREC, w_ATTO_NAS_TR_PREC, w_PARTE_NAS_TR_PREC, w_SERIE_NAS_TR_PREC, w_UFFICIO_NAS_TR_PREC,
                      w_ATTO_NAS_DIGITALE_PREC, w_ATTO_NAS_TR_DIGITALE_PREC,
                      w_COD_PRO_MAT_PREC, w_COD_COM_MAT_PREC, w_DATA_MAT_PREC, w_ANNO_MAT_PREC,
                      w_COD_PRO_ATTO_MAT_PREC, w_COD_COM_ATTO_MAT_PREC,
                      w_ANNO_ATTO_MAT_PREC, w_ATTO_MAT_PREC, w_PARTE_MAT_PREC, w_SERIE_MAT_PREC, w_UFFICIO_MAT_PREC,
                      w_ANNO_ATTO_MAT_TR_PREC, w_ATTO_MAT_TR_PREC, w_PARTE_MAT_TR_PREC, w_SERIE_MAT_TR_PREC, w_UFFICIO_MAT_TR_PREC,
                      w_ATTO_MAT_DIGITALE_PREC, w_ATTO_MAT_TR_DIGITALE_PREC,
                      w_COD_PRO_MOR_PREC, w_COD_COM_MOR_PREC, w_DATA_MOR_PREC,
                      w_COD_PRO_ATTO_MOR_PREC, w_COD_COM_ATTO_MOR_PREC,
                      w_ANNO_ATTO_MOR_PREC, w_ATTO_MOR_PREC, w_PARTE_MOR_PREC, w_SERIE_MOR_PREC, w_UFFICIO_MOR_PREC,
                      w_ANNO_ATTO_MOR_TR_PREC, w_ATTO_MOR_TR_PREC, w_PARTE_MOR_TR_PREC, w_SERIE_MOR_TR_PREC, w_UFFICIO_MOR_TR_PREC,
                      w_ATTO_MOR_DIGITALE_PREC, w_ATTO_MOR_TR_DIGITALE_PREC,
                      w_COD_PRO_VED_PREC, w_COD_COM_VED_PREC, w_DATA_VED_PREC,
                      w_COD_PRO_ATTO_VED_PREC, w_COD_COM_ATTO_VED_PREC,
                      w_ANNO_ATTO_VED_PREC, w_ATTO_VED_PREC, w_PARTE_VED_PREC, w_SERIE_VED_PREC, w_UFFICIO_VED_PREC,
                      w_ATTO_VED_DIGITALE_PREC,
                      w_COD_PRO_DIV_PREC, w_COD_COM_DIV_PREC, w_DATA_DIV_PREC, w_DATA_DIV_GIU_PREC, w_DATA_DIV_ANN_PREC,
                      w_COD_PRO_ATTO_DIV_PREC, w_COD_COM_ATTO_DIV_PREC,
                      w_ANNO_ATTO_DIV_PREC, w_ATTO_DIV_PREC, w_PARTE_DIV_PREC, w_SERIE_DIV_PREC, w_UFFICIO_DIV_PREC,
                      w_ATTO_DIV_DIGITALE_PREC,
                      w_COGNOME_NOME, w_STATO_CIVILE, w_SESSO,
                      w_COD_FISCALE, w_CF_CALCOLATO,
                      w_NAZIONALITA, w_DATA_INIZIO_NAZ,
                      w_PATERNITA, w_MATRICOLA_PD,
                      w_MATERNITA, w_MATRICOLA_MD,
                      w_COGNOME_NOME_CN, w_MATRICOLA_CN,
                      w_TITOLO_STUDIO, w_COD_PROF, w_ATTIVITA_PROF, w_POSIZIONE_PROF, w_PENSIONATO,
                      w_COD_FAM, w_INTESTATARIO, w_RAPPORTO_PAR, w_DATA_INIZIO_FAM,
                      w_COD_VIA, w_NUM_CIV, w_SUFFISSO, w_INTERNO, w_SUB_INTERNO, w_SCALA, w_PIANO,
                      w_FLAG_METRICO, w_PROGR_SNC, w_FLAG_LETTERA, w_FLAG_ESPONENTE,
                      w_FLAG_NUI, w_NUI, w_COLORE, w_CORTE, w_INTERNO2, w_SUB_INTERNO2,
                      w_SECONDARIO, w_SCALA_ESTERNA,
                      w_MATRICOLA_AIRE,
                      w_VIA_AIRE, w_COD_PRO_AIRE, w_COD_COM_AIRE, w_ZIPCODE,
                      w_PROVINCIA_CONTEA, w_PRESSO,
                      w_COD_PRO_ISCR_AIRE, w_COD_COM_ISCR_AIRE,
                      w_DATA_INIZIO_RES,
                      w_ANNO_CENS, w_SEZIONE_CENS, w_FOGLIO_CENS, w_COD_EDIFICIO_CENS,
                      w_COD_PRO_NAS, w_COD_COM_NAS, w_DATA_NAS, w_ANNO_NAS,
                      w_COD_PRO_ATTO_NAS, w_COD_COM_ATTO_NAS,
                      w_ANNO_ATTO_NAS, w_ATTO_NAS, w_PARTE_NAS, w_SERIE_NAS, w_UFFICIO_NAS,
                      w_ANNO_ATTO_NAS_TR, w_ATTO_NAS_TR, w_PARTE_NAS_TR, w_SERIE_NAS_TR, w_UFFICIO_NAS_TR,
                      w_ATTO_NAS_DIGITALE, w_ATTO_NAS_TR_DIGITALE,
                      w_COD_PRO_MAT, w_COD_COM_MAT, w_DATA_MAT, w_ANNO_MAT,
                      w_COD_PRO_ATTO_MAT, w_COD_COM_ATTO_MAT,
                      w_ANNO_ATTO_MAT, w_ATTO_MAT, w_PARTE_MAT, w_SERIE_MAT, w_UFFICIO_MAT,
                      w_ANNO_ATTO_MAT_TR, w_ATTO_MAT_TR, w_PARTE_MAT_TR, w_SERIE_MAT_TR, w_UFFICIO_MAT_TR,
                      w_ATTO_MAT_DIGITALE, w_ATTO_MAT_TR_DIGITALE,
                      w_COD_PRO_MOR, w_COD_COM_MOR, w_DATA_MOR,
                      w_COD_PRO_ATTO_MOR, w_COD_COM_ATTO_MOR,
                      w_ANNO_ATTO_MOR, w_ATTO_MOR, w_PARTE_MOR, w_SERIE_MOR, w_UFFICIO_MOR,
                      w_ANNO_ATTO_MOR_TR, w_ATTO_MOR_TR, w_PARTE_MOR_TR, w_SERIE_MOR_TR, w_UFFICIO_MOR_TR,
                      w_ATTO_MOR_DIGITALE, w_ATTO_MOR_TR_DIGITALE,
                      w_COD_PRO_VED, w_COD_COM_VED, w_DATA_VED,
                      w_COD_PRO_ATTO_VED, w_COD_COM_ATTO_VED,
                      w_ANNO_ATTO_VED, w_ATTO_VED, w_PARTE_VED, w_SERIE_VED, w_UFFICIO_VED,
                      w_ATTO_VED_DIGITALE,
                      w_COD_PRO_DIV, w_COD_COM_DIV, w_DATA_DIV, w_DATA_DIV_GIU, w_DATA_DIV_ANN,
                      w_COD_PRO_ATTO_DIV, w_COD_COM_ATTO_DIV,
                      w_ANNO_ATTO_DIV, w_ATTO_DIV, w_PARTE_DIV, w_SERIE_DIV, w_UFFICIO_DIV,
                      w_ATTO_DIV_DIGITALE,
                      w_DATA_REG, w_TERMINALISTA,
                      w_ELETTORALE, w_ANNULLAMENTO,
                      w_ANNO_PROGR, w_NUMERO_PROGR,
                      w_NO_CONTEGGIO, w_NO_VANA
                from dual
               where not exists (select 1 from anamov b
                                  where b.matricola               = w_matricola
                                    and b.cod_mov                 = w_cod_mov
                                    and b.cod_eve                 = w_cod_eve
                                    and nvl(b.cod_variazione,' ') = nvl(w_cod_variazione,' ')
                                    and b.pratica                 = w_pratica
                                    and b.anno_pratica            = w_anno_pratica
                                    and b.data_eve                = w_data_eve)
              ;
            exception
              when others then
                   w_errore := 'Errore in ins_anamov - prov (matricola: '||rec.matricola||')';
                   w_return := -1;
            end;
        end loop;

        for rec in sel_apm_ann loop
            if rec.cod_mov = 1 then
               w_ANNO_PROGR   := '';
               w_NUMERO_PROGR := '';
               w_ID_ANAMOV    := '';
               ANAMOV_NR(w_ANNO_PROGR, w_NUMERO_PROGR);
               w_ID_ANAMOV                 := w_ANNO_PROGR||lpad(w_NUMERO_PROGR,6,'0');
--
               w_MATRICOLA                 := rec.matricola;
               w_COD_MOV                   := 2;
               w_COD_EVE                   := 62;
               w_COD_VARIAZIONE            := rec.cod_variazione;
               w_ANNO_PRATICA              := a_anno_pratica;
               w_PRATICA                   := a_pratica;
               w_DATA_REG                  := to_char(sysdate,'j');
               w_TERMINALISTA              := a_terminalista;
               w_NUCLEO_PARTENZA           := rec.nucleo_arrivo;
               w_NUCLEO_ARRIVO             := '';
               w_DATA_REG                  := to_char(sysdate,'j');
               w_TERMINALISTA              := a_terminalista;
               w_ELETTORALE                := '';
               w_ANNULLAMENTO              := '';
               w_NO_CONTEGGIO              := ''; -- lo calcola il trigger?
               w_NO_VANA                   := '';
--
               w_COD_FAM_PREC              := '';
               w_INTESTATARIO_PREC         := '';
               w_RAPPORTO_PAR_PREC         := '';
               w_COD_FAM                   := rec.cod_fam;
               w_INTESTATARIO              := rec.intestatario;
               w_RAPPORTO_PAR              := rec.rapporto_par;
               w_DATA_INIZIO_FAM           := '';
               w_COD_VIA                   := rec.cod_via;
               w_NUM_CIV                   := rec.num_civ;
               w_SUFFISSO                  := rec.suffisso;
               w_INTERNO                   := rec.interno;
               w_SUB_INTERNO               := rec.sub_interno;
               w_SCALA                     := rec.scala;
               w_PIANO                     := rec.piano;
               w_FLAG_METRICO              := rec.flag_metrico;
               w_PROGR_SNC                 := rec.progr_snc;
               w_FLAG_LETTERA              := rec.flag_lettera;
               w_FLAG_ESPONENTE            := rec.flag_esponente;
               w_FLAG_NUI                  := rec.flag_nui;
               w_NUI                       := rec.nui;
               w_COLORE                    := rec.colore;
               w_CORTE                     := rec.corte;
               w_INTERNO2                  := rec.interno2;
               w_SUB_INTERNO2              := rec.sub_interno2;
               w_SECONDARIO                := rec.secondario;
               w_SCALA_ESTERNA             := rec.scala_esterna;

            elsif rec.cod_mov = 12 then
               w_ANNO_PROGR   := '';
               w_NUMERO_PROGR := '';
               w_ID_ANAMOV    := '';
               ANAMOV_NR(w_ANNO_PROGR, w_NUMERO_PROGR);
               w_ID_ANAMOV                 := w_ANNO_PROGR||lpad(w_NUMERO_PROGR,6,'0');
--
               w_MATRICOLA                 := rec.matricola;
               w_COD_MOV                   := rec.cod_mov;
               w_COD_EVE                   := rec.cod_eve;
               w_COD_VARIAZIONE            := 'X';
               w_ANNO_PRATICA              := a_anno_pratica;
               w_PRATICA                   := a_pratica;
               w_DATA_REG                  := to_char(sysdate,'j');
               w_TERMINALISTA              := a_terminalista;
               w_NUCLEO_PARTENZA           := rec.nucleo_arrivo;
               w_NUCLEO_ARRIVO             := rec.nucleo_partenza;
               w_DATA_REG                  := to_char(sysdate,'j');
               w_TERMINALISTA              := a_terminalista;
               w_ELETTORALE                := '';
               w_ANNULLAMENTO              := '';
               w_NO_CONTEGGIO              := ''; -- lo calcola il trigger?
               w_NO_VANA                   := '';
--
               w_COD_FAM_PREC              := rec.cod_fam;
               w_INTESTATARIO_PREC         := rec.intestatario_prec;
               w_RAPPORTO_PAR_PREC         := rec.rapporto_par;
               w_COD_FAM                   := nvl(rec.cod_fam_prec,rec.cod_fam);
               w_INTESTATARIO              := nvl(rec.intestatario_prec,rec.intestatario);
               w_RAPPORTO_PAR              := nvl(rec.rapporto_par_prec,rec.rapporto_par);
               w_DATA_INIZIO_FAM           := rec.data_eve;
               w_COD_VIA                   := '';
               w_NUM_CIV                   := '';
               w_SUFFISSO                  := '';
               w_INTERNO                   := '';
               w_SUB_INTERNO               := '';
               w_SCALA                     := '';
               w_PIANO                     := '';
               w_FLAG_METRICO              := '';
               w_PROGR_SNC                 := '';
               w_FLAG_LETTERA              := '';
               w_FLAG_ESPONENTE            := '';
               w_FLAG_NUI                  := '';
               w_NUI                       := '';
               w_COLORE                    := '';
               w_CORTE                     := '';
               w_INTERNO2                  := '';
               w_SUB_INTERNO2              := '';
               w_SECONDARIO                := '';
               w_SCALA_ESTERNA             := '';
            end if;

            w_COGNOME_NOME_PREC         := '';
            w_STATO_CIVILE_PREC         := '';
            w_SESSO_PREC                := '';
            w_NAZIONALITA_PREC          := '';
            w_PATERNITA_PREC            := '';
            w_MATERNITA_PREC            := '';
            w_TITOLO_STUDIO_PREC        := '';
            w_COD_PROF_PREC             := '';
            w_ATTIVITA_PROF_PREC        := '';
            w_POSIZIONE_PROF_PREC       := '';
            w_PENSIONATO_PREC           := '';
            w_COD_VIA_PREC              := '';
            w_NUM_CIV_PREC              := '';
            w_SUFFISSO_PREC             := '';
            w_INTERNO_PREC              := '';
            w_VIA_AIRE_PREC             := '';
            w_COD_PRO_AIRE_PREC         := '';
            w_COD_COM_AIRE_PREC         := '';
            w_COGNOME_NOME_CN_PREC      := '';
            w_MATRICOLA_CN_PREC         := '';
            w_ANNO_CENS_PREC            := '';
            w_SEZIONE_CENS_PREC         := '';
            w_FOGLIO_CENS_PREC          := '';
            w_COD_PRO_NAS_PREC          := '';
            w_COD_COM_NAS_PREC          := '';
            w_DATA_NAS_PREC             := '';
            w_COD_PRO_ATTO_NAS_PREC     := '';
            w_COD_COM_ATTO_NAS_PREC     := '';
            w_ANNO_ATTO_NAS_PREC        := '';
            w_ATTO_NAS_PREC             := '';
            w_PARTE_NAS_PREC            := '';
            w_SERIE_NAS_PREC            := '';
            w_UFFICIO_NAS_PREC          := '';
            w_ANNO_ATTO_NAS_TR_PREC     := '';
            w_ATTO_NAS_TR_PREC          := '';
            w_PARTE_NAS_TR_PREC         := '';
            w_SERIE_NAS_TR_PREC         := '';
            w_UFFICIO_NAS_TR_PREC       := '';
            w_COD_PRO_MAT_PREC          := '';
            w_COD_COM_MAT_PREC          := '';
            w_DATA_MAT_PREC             := '';
            w_ANNO_ATTO_MAT_PREC        := '';
            w_ATTO_MAT_PREC             := '';
            w_PARTE_MAT_PREC            := '';
            w_SERIE_MAT_PREC            := '';
            w_UFFICIO_MAT_PREC          := '';
            w_ANNO_ATTO_MAT_TR_PREC     := '';
            w_ATTO_MAT_TR_PREC          := '';
            w_PARTE_MAT_TR_PREC         := '';
            w_SERIE_MAT_TR_PREC         := '';
            w_UFFICIO_MAT_TR_PREC       := '';
            w_COD_PRO_MOR_PREC          := '';
            w_COD_COM_MOR_PREC          := '';
            w_DATA_MOR_PREC             := '';
            w_ANNO_ATTO_MOR_PREC        := '';
            w_ATTO_MOR_PREC             := '';
            w_PARTE_MOR_PREC            := '';
            w_SERIE_MOR_PREC            := '';
            w_UFFICIO_MOR_PREC          := '';
            w_ANNO_ATTO_MOR_TR_PREC     := '';
            w_ATTO_MOR_TR_PREC          := '';
            w_PARTE_MOR_TR_PREC         := '';
            w_SERIE_MOR_TR_PREC         := '';
            w_UFFICIO_MOR_TR_PREC       := '';
            w_COD_PRO_VED_PREC          := '';
            w_COD_COM_VED_PREC          := '';
            w_DATA_VED_PREC             := '';
            w_ANNO_ATTO_VED_PREC        := '';
            w_ATTO_VED_PREC             := '';
            w_PARTE_VED_PREC            := '';
            w_SERIE_VED_PREC            := '';
            w_UFFICIO_VED_PREC          := '';
            w_COD_FISCALE_PREC          := '';
            w_COGNOME_NOME              := rec.cognome_nome;
            w_STATO_CIVILE              := rec.stato_civile;
            w_SESSO                     := rec.sesso;
            w_NAZIONALITA               := rec.nazionalita;
            w_PATERNITA                 := rec.paternita;
            w_MATERNITA                 := rec.maternita;
            w_TITOLO_STUDIO             := rec.titolo_studio;
            w_COD_PROF                  := rec.cod_prof;
            w_ATTIVITA_PROF             := rec.attivita_prof;
            w_POSIZIONE_PROF            := rec.posizione_prof;
            w_PENSIONATO                := rec.pensionato;
            w_VIA_AIRE                  := '';
            w_COD_PRO_AIRE              := '';
            w_COD_COM_AIRE              := '';
            w_DATA_INIZIO_RES           := '';
            w_COGNOME_NOME_CN           := rec.cognome_nome_cn;
            w_MATRICOLA_CN              := rec.matricola_cn;
            w_ANNO_CENS                 := rec.anno_cens;
            w_SEZIONE_CENS              := rec.sezione_cens;
            w_FOGLIO_CENS               := rec.foglio_cens;
            w_COD_PRO_NAS               := rec.cod_pro_nas;
            w_COD_COM_NAS               := rec.cod_com_nas;
            w_DATA_NAS                  := rec.data_nas;
            w_COD_PRO_ATTO_NAS          := rec.cod_pro_atto_nas;
            w_COD_COM_ATTO_NAS          := rec.cod_com_atto_nas;
            w_ANNO_ATTO_NAS             := rec.anno_atto_nas;
            w_ATTO_NAS                  := rec.atto_nas;
            w_PARTE_NAS                 := rec.parte_nas;
            w_SERIE_NAS                 := rec.serie_nas;
            w_UFFICIO_NAS               := rec.ufficio_nas;
            w_ANNO_ATTO_NAS_TR          := rec.anno_atto_nas;
            w_ATTO_NAS_TR               := rec.atto_nas_tr;
            w_PARTE_NAS_TR              := rec.parte_nas_tr;
            w_SERIE_NAS_TR              := rec.serie_nas_tr;
            w_UFFICIO_NAS_TR            := rec.ufficio_nas_tr;
            w_COD_PRO_MAT               := rec.cod_pro_mat;
            w_COD_COM_MAT               := rec.cod_com_mat;
            w_DATA_MAT                  := rec.data_mat;
            w_ANNO_ATTO_MAT             := rec.anno_atto_mat;
            w_ATTO_MAT                  := rec.atto_mat;
            w_PARTE_MAT                 := rec.parte_mat;
            w_SERIE_MAT                 := rec.serie_mat;
            w_UFFICIO_MAT               := rec.ufficio_mat;
            w_ANNO_ATTO_MAT_TR          := rec.anno_atto_mat_tr;
            w_ATTO_MAT_TR               := rec.atto_mat_tr;
            w_PARTE_MAT_TR              := rec.parte_mat_tr;
            w_SERIE_MAT_TR              := rec.serie_mat_tr;
            w_UFFICIO_MAT_TR            := rec.ufficio_mat_tr;
            w_COD_PRO_MOR               := '';
            w_COD_COM_MOR               := '';
            w_DATA_MOR                  := '';
            w_ANNO_ATTO_MOR             := '';
            w_ATTO_MOR                  := '';
            w_PARTE_MOR                 := '';
            w_SERIE_MOR                 := '';
            w_UFFICIO_MOR               := '';
            w_ANNO_ATTO_MOR_TR          := '';
            w_ATTO_MOR_TR               := '';
            w_PARTE_MOR_TR              := '';
            w_SERIE_MOR_TR              := '';
            w_UFFICIO_MOR_TR            := '';
            w_COD_PRO_VED               := rec.cod_pro_ved;
            w_COD_COM_VED               := rec.cod_com_ved;
            w_DATA_VED                  := rec.data_ved;
            w_ANNO_ATTO_VED             := rec.anno_atto_ved;
            w_ATTO_VED                  := rec.atto_ved;
            w_PARTE_VED                 := rec.parte_ved;
            w_SERIE_VED                 := rec.serie_ved;
            w_UFFICIO_VED               := rec.ufficio_ved;
            w_COD_FISCALE               := rec.cod_fiscale;
            w_COD_PRO_DIV_PREC          := '';
            w_COD_COM_DIV_PREC          := '';
            w_DATA_DIV_PREC             := '';
            w_ANNO_ATTO_DIV_PREC        := '';
            w_ATTO_DIV_PREC             := '';
            w_PARTE_DIV_PREC            := '';
            w_SERIE_DIV_PREC            := '';
            w_UFFICIO_DIV_PREC          := '';
            w_COD_PRO_DIV               := rec.cod_pro_div;
            w_COD_COM_DIV               := rec.cod_com_div;
            w_DATA_DIV                  := rec.data_div;
            w_ANNO_ATTO_DIV             := rec.anno_atto_div;
            w_ATTO_DIV                  := rec.atto_div;
            w_PARTE_DIV                 := rec.parte_div;
            w_SERIE_DIV                 := rec.serie_div;
            w_UFFICIO_DIV               := rec.ufficio_div;
            w_MATRICOLA_AIRE_PREC       := '';
            w_MATRICOLA_AIRE            := '';
            w_COD_PRO_ATTO_MAT_PREC     := '';
            w_COD_COM_ATTO_MAT_PREC     := '';
            w_COD_PRO_ATTO_VED_PREC     := '';
            w_COD_COM_ATTO_VED_PREC     := '';
            w_COD_PRO_ATTO_MOR_PREC     := '';
            w_COD_COM_ATTO_MOR_PREC     := '';
            w_COD_PRO_ATTO_MAT          := rec.cod_pro_atto_mat;
            w_COD_COM_ATTO_MAT          := rec.cod_com_atto_mat;
            w_COD_PRO_ATTO_VED          := rec.cod_pro_atto_ved;
            w_COD_COM_ATTO_VED          := rec.cod_com_atto_ved;
            w_COD_PRO_ATTO_MOR          := rec.cod_pro_atto_mor;
            w_COD_COM_ATTO_MOR          := rec.cod_com_atto_mor;
            w_CF_CALCOLATO_PREC         := '';
            w_CF_CALCOLATO              := rec.cf_calcolato;
            w_SCALA_PREC                := '';
            w_PIANO_PREC                := '';
            w_ZIPCODE_PREC              := '';
            w_ZIPCODE                   := '';
            w_COD_EDIFICIO_CENS_PREC    := '';
            w_COD_EDIFICIO_CENS         := rec.cod_edificio_cens;
            w_COD_PRO_ATTO_DIV          := rec.cod_pro_atto_div;
            w_COD_COM_ATTO_DIV          := rec.cod_com_atto_div;
            w_DATA_DIV_GIU              := rec.data_div_giu;
            w_DATA_DIV_ANN              := rec.data_div_ann;
            w_COD_PRO_ATTO_DIV_PREC     := '';
            w_COD_COM_ATTO_DIV_PREC     := '';
            w_DATA_DIV_GIU_PREC         := '';
            w_DATA_DIV_ANN_PREC         := '';
            w_COD_PRO_ISCR_AIRE         := rec.cod_pro_iscr_aire;
            w_COD_COM_ISCR_AIRE         := rec.cod_com_iscr_aire;
            w_PROVINCIA_CONTEA_PREC     := '';
            w_PRESSO_PREC               := '';
            w_PROVINCIA_CONTEA          := '';
            w_PRESSO                    := '';
            w_ANNO_NAS_PREC             := '';
            w_ANNO_MAT_PREC             := '';
            w_ANNO_NAS                  := rec.anno_nas;
            w_ANNO_MAT                  := rec.anno_mat;
            w_CIVICO_ESTERNO            := '';
            w_CIVICO_INTERNO            := '';
            w_SUB_INTERNO_PREC          := '';
            w_CIVICO_ESTERNO_PREC       := '';
            w_CIVICO_INTERNO_PREC       := '';
            w_MATRICOLA_PD_PREC         := '';
            w_MATRICOLA_MD_PREC         := '';
            w_MATRICOLA_PD              := rec.matricola_pd;
            w_MATRICOLA_MD              := rec.matricola_md;
            w_DATA_INIZIO_NAZ           := rec.data_inizio_naz;
            w_DATA_INIZIO_NAZ_PREC      := '';
            w_ATTO_NAS_DIGITALE_PREC    := '';
            w_ATTO_NAS_TR_DIGITALE_PREC := '';
            w_ATTO_MAT_DIGITALE_PREC    := '';
            w_ATTO_MAT_TR_DIGITALE_PREC := '';
            w_ATTO_DIV_DIGITALE_PREC    := '';
            w_ATTO_VED_DIGITALE_PREC    := '';
            w_ATTO_MOR_DIGITALE_PREC    := '';
            w_ATTO_MOR_TR_DIGITALE_PREC := '';
            w_ATTO_NAS_DIGITALE         := rec.atto_nas_digitale;
            w_ATTO_NAS_TR_DIGITALE      := rec.atto_nas_tr_digitale;
            w_ATTO_MAT_DIGITALE         := rec.atto_mat_digitale;
            w_ATTO_MAT_TR_DIGITALE      := rec.atto_mat_tr_digitale;
            w_ATTO_DIV_DIGITALE         := rec.atto_div_digitale;
            w_ATTO_VED_DIGITALE         := rec.atto_ved_digitale;
            w_ATTO_MOR_DIGITALE         := rec.atto_mor_digitale;
            w_ATTO_MOR_TR_DIGITALE      := rec.atto_mor_tr_digitale;
            w_FLAG_METRICO_PREC         := '';
            w_PROGR_SNC_PREC            := '';
            w_FLAG_LETTERA_PREC         := '';
            w_FLAG_ESPONENTE_PREC       := '';
            w_FLAG_NUI_PREC             := '';
            w_NUI_PREC                  := '';
            w_COLORE_PREC               := '';
            w_CORTE_PREC                := '';
            w_INTERNO2_PREC             := '';
            w_SUB_INTERNO2_PREC         := '';
            w_SECONDARIO_PREC           := '';
            w_SCALA_ESTERNA_PREC        := '';

            w_parametri_log             := '[ann]'||' - '||
                                           'anno_pratica: '||w_anno_pratica||' - '||
                                           'pratica: '||w_pratica||' - '||
                                           'matricola: '||w_matricola||' - '||
                                           'cod_mov: '||w_cod_mov||' - '||
                                           'cod_eve: '||w_cod_eve||' - '||
                                           'cod_variazione: '||w_cod_variazione||' - '||
                                           'nucleo_partenza: '||w_nucleo_partenza||' - '||
                                           'cod_fam_prec: '||w_cod_fam_prec||' - '||
                                           'rapporto_par_prec: '||w_rapporto_par_prec||' - '||
                                           'nucleo_arrivo: '||w_nucleo_arrivo||' - '||
                                           'cod_fam: '||w_cod_fam||' - '||
                                           'rapporto_par: '||w_rapporto_par;
            w_return_log                := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);

            begin
              insert into anamov
                     (MATRICOLA, COD_MOV, COD_EVE, COD_VARIAZIONE,
                      DATA_EVE, COD_PRO_EVE, COD_COM_EVE, ANNO_PRATICA, PRATICA,
                      NUCLEO_PARTENZA, NUCLEO_ARRIVO,
                      COGNOME_NOME_PREC, STATO_CIVILE_PREC, SESSO_PREC,
                      COD_FISCALE_PREC, CF_CALCOLATO_PREC,
                      NAZIONALITA_PREC, DATA_INIZIO_NAZ_PREC,
                      PATERNITA_PREC, MATRICOLA_PD_PREC,
                      MATERNITA_PREC, MATRICOLA_MD_PREC,
                      COGNOME_NOME_CN_PREC, MATRICOLA_CN_PREC,
                      TITOLO_STUDIO_PREC, COD_PROF_PREC, ATTIVITA_PROF_PREC, POSIZIONE_PROF_PREC, PENSIONATO_PREC,
                      COD_FAM_PREC, INTESTATARIO_PREC, RAPPORTO_PAR_PREC,
                      COD_VIA_PREC, NUM_CIV_PREC, SUFFISSO_PREC, INTERNO_PREC, SUB_INTERNO_PREC, SCALA_PREC, PIANO_PREC,
                      FLAG_METRICO_PREC, PROGR_SNC_PREC, FLAG_LETTERA_PREC, FLAG_ESPONENTE_PREC,
                      FLAG_NUI_PREC, NUI_PREC, COLORE_PREC, CORTE_PREC, INTERNO2_PREC, SUB_INTERNO2_PREC,
                      SECONDARIO_PREC, SCALA_ESTERNA_PREC,
                      MATRICOLA_AIRE_PREC,
                      VIA_AIRE_PREC, COD_PRO_AIRE_PREC, COD_COM_AIRE_PREC, ZIPCODE_PREC,
                      PROVINCIA_CONTEA_PREC, PRESSO_PREC,
                      ANNO_CENS_PREC, SEZIONE_CENS_PREC, FOGLIO_CENS_PREC, COD_EDIFICIO_CENS_PREC,
                      COD_PRO_NAS_PREC, COD_COM_NAS_PREC, DATA_NAS_PREC, ANNO_NAS_PREC,
                      COD_PRO_ATTO_NAS_PREC, COD_COM_ATTO_NAS_PREC,
                      ANNO_ATTO_NAS_PREC, ATTO_NAS_PREC, PARTE_NAS_PREC, SERIE_NAS_PREC, UFFICIO_NAS_PREC,
                      ANNO_ATTO_NAS_TR_PREC, ATTO_NAS_TR_PREC, PARTE_NAS_TR_PREC, SERIE_NAS_TR_PREC, UFFICIO_NAS_TR_PREC,
                      ATTO_NAS_DIGITALE_PREC, ATTO_NAS_TR_DIGITALE_PREC,
                      COD_PRO_MAT_PREC, COD_COM_MAT_PREC, DATA_MAT_PREC, ANNO_MAT_PREC,
                      COD_PRO_ATTO_MAT_PREC, COD_COM_ATTO_MAT_PREC,
                      ANNO_ATTO_MAT_PREC, ATTO_MAT_PREC, PARTE_MAT_PREC, SERIE_MAT_PREC, UFFICIO_MAT_PREC,
                      ANNO_ATTO_MAT_TR_PREC, ATTO_MAT_TR_PREC, PARTE_MAT_TR_PREC, SERIE_MAT_TR_PREC, UFFICIO_MAT_TR_PREC,
                      ATTO_MAT_DIGITALE_PREC, ATTO_MAT_TR_DIGITALE_PREC,
                      COD_PRO_MOR_PREC, COD_COM_MOR_PREC, DATA_MOR_PREC,
                      COD_PRO_ATTO_MOR_PREC, COD_COM_ATTO_MOR_PREC,
                      ANNO_ATTO_MOR_PREC, ATTO_MOR_PREC, PARTE_MOR_PREC, SERIE_MOR_PREC, UFFICIO_MOR_PREC,
                      ANNO_ATTO_MOR_TR_PREC, ATTO_MOR_TR_PREC, PARTE_MOR_TR_PREC, SERIE_MOR_TR_PREC, UFFICIO_MOR_TR_PREC,
                      ATTO_MOR_DIGITALE_PREC, ATTO_MOR_TR_DIGITALE_PREC,
                      COD_PRO_VED_PREC, COD_COM_VED_PREC, DATA_VED_PREC,
                      COD_PRO_ATTO_VED_PREC, COD_COM_ATTO_VED_PREC,
                      ANNO_ATTO_VED_PREC, ATTO_VED_PREC, PARTE_VED_PREC, SERIE_VED_PREC, UFFICIO_VED_PREC,
                      ATTO_VED_DIGITALE_PREC,
                      COD_PRO_DIV_PREC, COD_COM_DIV_PREC, DATA_DIV_PREC, DATA_DIV_GIU_PREC, DATA_DIV_ANN_PREC,
                      COD_PRO_ATTO_DIV_PREC, COD_COM_ATTO_DIV_PREC,
                      ANNO_ATTO_DIV_PREC, ATTO_DIV_PREC, PARTE_DIV_PREC, SERIE_DIV_PREC, UFFICIO_DIV_PREC,
                      ATTO_DIV_DIGITALE_PREC,
                      COGNOME_NOME, STATO_CIVILE, SESSO,
                      COD_FISCALE, CF_CALCOLATO,
                      NAZIONALITA, DATA_INIZIO_NAZ,
                      PATERNITA, MATRICOLA_PD,
                      MATERNITA, MATRICOLA_MD,
                      COGNOME_NOME_CN, MATRICOLA_CN,
                      TITOLO_STUDIO, COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO,
                      COD_FAM, INTESTATARIO, RAPPORTO_PAR, DATA_INIZIO_FAM,
                      COD_VIA, NUM_CIV, SUFFISSO, INTERNO, SUB_INTERNO, SCALA, PIANO,
                      FLAG_METRICO, PROGR_SNC, FLAG_LETTERA, FLAG_ESPONENTE,
                      FLAG_NUI, NUI, COLORE, CORTE, INTERNO2, SUB_INTERNO2,
                      SECONDARIO, SCALA_ESTERNA,
                      MATRICOLA_AIRE,
                      VIA_AIRE, COD_PRO_AIRE, COD_COM_AIRE, ZIPCODE,
                      PROVINCIA_CONTEA, PRESSO,
                      COD_PRO_ISCR_AIRE, COD_COM_ISCR_AIRE,
                      DATA_INIZIO_RES,
                      ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS, COD_EDIFICIO_CENS,
                      COD_PRO_NAS, COD_COM_NAS, DATA_NAS, ANNO_NAS,
                      COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
                      ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS,
                      ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
                      ATTO_NAS_DIGITALE, ATTO_NAS_TR_DIGITALE,
                      COD_PRO_MAT, COD_COM_MAT, DATA_MAT, ANNO_MAT,
                      COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT,
                      ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
                      ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
                      ATTO_MAT_DIGITALE, ATTO_MAT_TR_DIGITALE,
                      COD_PRO_MOR, COD_COM_MOR, DATA_MOR,
                      COD_PRO_ATTO_MOR, COD_COM_ATTO_MOR,
                      ANNO_ATTO_MOR, ATTO_MOR, PARTE_MOR, SERIE_MOR, UFFICIO_MOR,
                      ANNO_ATTO_MOR_TR, ATTO_MOR_TR, PARTE_MOR_TR, SERIE_MOR_TR, UFFICIO_MOR_TR,
                      ATTO_MOR_DIGITALE, ATTO_MOR_TR_DIGITALE,
                      COD_PRO_VED, COD_COM_VED, DATA_VED,
                      COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
                      ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
                      ATTO_VED_DIGITALE,
                      COD_PRO_DIV, COD_COM_DIV, DATA_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
                      COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV,
                      ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
                      ATTO_DIV_DIGITALE,
                      DATA_REG, TERMINALISTA,
                      ELETTORALE, ANNULLAMENTO,
                      ANNO_PROGR, NUMERO_PROGR,
                      NO_CONTEGGIO, NO_VANA
                     )
              select w_MATRICOLA, w_COD_MOV, w_COD_EVE, w_COD_VARIAZIONE,
                      w_DATA_EVE, w_COD_PRO_EVE, w_COD_COM_EVE, w_ANNO_PRATICA, w_PRATICA,
                      w_NUCLEO_PARTENZA, w_NUCLEO_ARRIVO,
                      w_COGNOME_NOME_PREC, w_STATO_CIVILE_PREC, w_SESSO_PREC,
                      w_COD_FISCALE_PREC, w_CF_CALCOLATO_PREC,
                      w_NAZIONALITA_PREC, w_DATA_INIZIO_NAZ_PREC,
                      w_PATERNITA_PREC, w_MATRICOLA_PD_PREC,
                      w_MATERNITA_PREC, w_MATRICOLA_MD_PREC,
                      w_COGNOME_NOME_CN_PREC, w_MATRICOLA_CN_PREC,
                      w_TITOLO_STUDIO_PREC, w_COD_PROF_PREC, w_ATTIVITA_PROF_PREC, w_POSIZIONE_PROF_PREC, w_PENSIONATO_PREC,
                      w_COD_FAM_PREC, w_INTESTATARIO_PREC, w_RAPPORTO_PAR_PREC,
                      w_COD_VIA_PREC, w_NUM_CIV_PREC, w_SUFFISSO_PREC, w_INTERNO_PREC, w_SUB_INTERNO_PREC, w_SCALA_PREC, w_PIANO_PREC,
                      w_FLAG_METRICO_PREC, w_PROGR_SNC_PREC, w_FLAG_LETTERA_PREC, w_FLAG_ESPONENTE_PREC,
                      w_FLAG_NUI_PREC, w_NUI_PREC, w_COLORE_PREC, w_CORTE_PREC, w_INTERNO2_PREC, w_SUB_INTERNO2_PREC,
                      w_SECONDARIO_PREC, w_SCALA_ESTERNA_PREC,
                      w_MATRICOLA_AIRE_PREC,
                      w_VIA_AIRE_PREC, w_COD_PRO_AIRE_PREC, w_COD_COM_AIRE_PREC, w_ZIPCODE_PREC,
                      w_PROVINCIA_CONTEA_PREC, w_PRESSO_PREC,
                      w_ANNO_CENS_PREC, w_SEZIONE_CENS_PREC, w_FOGLIO_CENS_PREC, w_COD_EDIFICIO_CENS_PREC,
                      w_COD_PRO_NAS_PREC, w_COD_COM_NAS_PREC, w_DATA_NAS_PREC, w_ANNO_NAS_PREC,
                      w_COD_PRO_ATTO_NAS_PREC, w_COD_COM_ATTO_NAS_PREC,
                      w_ANNO_ATTO_NAS_PREC, w_ATTO_NAS_PREC, w_PARTE_NAS_PREC, w_SERIE_NAS_PREC, w_UFFICIO_NAS_PREC,
                      w_ANNO_ATTO_NAS_TR_PREC, w_ATTO_NAS_TR_PREC, w_PARTE_NAS_TR_PREC, w_SERIE_NAS_TR_PREC, w_UFFICIO_NAS_TR_PREC,
                      w_ATTO_NAS_DIGITALE_PREC, w_ATTO_NAS_TR_DIGITALE_PREC,
                      w_COD_PRO_MAT_PREC, w_COD_COM_MAT_PREC, w_DATA_MAT_PREC, w_ANNO_MAT_PREC,
                      w_COD_PRO_ATTO_MAT_PREC, w_COD_COM_ATTO_MAT_PREC,
                      w_ANNO_ATTO_MAT_PREC, w_ATTO_MAT_PREC, w_PARTE_MAT_PREC, w_SERIE_MAT_PREC, w_UFFICIO_MAT_PREC,
                      w_ANNO_ATTO_MAT_TR_PREC, w_ATTO_MAT_TR_PREC, w_PARTE_MAT_TR_PREC, w_SERIE_MAT_TR_PREC, w_UFFICIO_MAT_TR_PREC,
                      w_ATTO_MAT_DIGITALE_PREC, w_ATTO_MAT_TR_DIGITALE_PREC,
                      w_COD_PRO_MOR_PREC, w_COD_COM_MOR_PREC, w_DATA_MOR_PREC,
                      w_COD_PRO_ATTO_MOR_PREC, w_COD_COM_ATTO_MOR_PREC,
                      w_ANNO_ATTO_MOR_PREC, w_ATTO_MOR_PREC, w_PARTE_MOR_PREC, w_SERIE_MOR_PREC, w_UFFICIO_MOR_PREC,
                      w_ANNO_ATTO_MOR_TR_PREC, w_ATTO_MOR_TR_PREC, w_PARTE_MOR_TR_PREC, w_SERIE_MOR_TR_PREC, w_UFFICIO_MOR_TR_PREC,
                      w_ATTO_MOR_DIGITALE_PREC, w_ATTO_MOR_TR_DIGITALE_PREC,
                      w_COD_PRO_VED_PREC, w_COD_COM_VED_PREC, w_DATA_VED_PREC,
                      w_COD_PRO_ATTO_VED_PREC, w_COD_COM_ATTO_VED_PREC,
                      w_ANNO_ATTO_VED_PREC, w_ATTO_VED_PREC, w_PARTE_VED_PREC, w_SERIE_VED_PREC, w_UFFICIO_VED_PREC,
                      w_ATTO_VED_DIGITALE_PREC,
                      w_COD_PRO_DIV_PREC, w_COD_COM_DIV_PREC, w_DATA_DIV_PREC, w_DATA_DIV_GIU_PREC, w_DATA_DIV_ANN_PREC,
                      w_COD_PRO_ATTO_DIV_PREC, w_COD_COM_ATTO_DIV_PREC,
                      w_ANNO_ATTO_DIV_PREC, w_ATTO_DIV_PREC, w_PARTE_DIV_PREC, w_SERIE_DIV_PREC, w_UFFICIO_DIV_PREC,
                      w_ATTO_DIV_DIGITALE_PREC,
                      w_COGNOME_NOME, w_STATO_CIVILE, w_SESSO,
                      w_COD_FISCALE, w_CF_CALCOLATO,
                      w_NAZIONALITA, w_DATA_INIZIO_NAZ,
                      w_PATERNITA, w_MATRICOLA_PD,
                      w_MATERNITA, w_MATRICOLA_MD,
                      w_COGNOME_NOME_CN, w_MATRICOLA_CN,
                      w_TITOLO_STUDIO, w_COD_PROF, w_ATTIVITA_PROF, w_POSIZIONE_PROF, w_PENSIONATO,
                      w_COD_FAM, w_INTESTATARIO, w_RAPPORTO_PAR, w_DATA_INIZIO_FAM,
                      w_COD_VIA, w_NUM_CIV, w_SUFFISSO, w_INTERNO, w_SUB_INTERNO, w_SCALA, w_PIANO,
                      w_FLAG_METRICO, w_PROGR_SNC, w_FLAG_LETTERA, w_FLAG_ESPONENTE,
                      w_FLAG_NUI, w_NUI, w_COLORE, w_CORTE, w_INTERNO2, w_SUB_INTERNO2,
                      w_SECONDARIO, w_SCALA_ESTERNA,
                      w_MATRICOLA_AIRE,
                      w_VIA_AIRE, w_COD_PRO_AIRE, w_COD_COM_AIRE, w_ZIPCODE,
                      w_PROVINCIA_CONTEA, w_PRESSO,
                      w_COD_PRO_ISCR_AIRE, w_COD_COM_ISCR_AIRE,
                      w_DATA_INIZIO_RES,
                      w_ANNO_CENS, w_SEZIONE_CENS, w_FOGLIO_CENS, w_COD_EDIFICIO_CENS,
                      w_COD_PRO_NAS, w_COD_COM_NAS, w_DATA_NAS, w_ANNO_NAS,
                      w_COD_PRO_ATTO_NAS, w_COD_COM_ATTO_NAS,
                      w_ANNO_ATTO_NAS, w_ATTO_NAS, w_PARTE_NAS, w_SERIE_NAS, w_UFFICIO_NAS,
                      w_ANNO_ATTO_NAS_TR, w_ATTO_NAS_TR, w_PARTE_NAS_TR, w_SERIE_NAS_TR, w_UFFICIO_NAS_TR,
                      w_ATTO_NAS_DIGITALE, w_ATTO_NAS_TR_DIGITALE,
                      w_COD_PRO_MAT, w_COD_COM_MAT, w_DATA_MAT, w_ANNO_MAT,
                      w_COD_PRO_ATTO_MAT, w_COD_COM_ATTO_MAT,
                      w_ANNO_ATTO_MAT, w_ATTO_MAT, w_PARTE_MAT, w_SERIE_MAT, w_UFFICIO_MAT,
                      w_ANNO_ATTO_MAT_TR, w_ATTO_MAT_TR, w_PARTE_MAT_TR, w_SERIE_MAT_TR, w_UFFICIO_MAT_TR,
                      w_ATTO_MAT_DIGITALE, w_ATTO_MAT_TR_DIGITALE,
                      w_COD_PRO_MOR, w_COD_COM_MOR, w_DATA_MOR,
                      w_COD_PRO_ATTO_MOR, w_COD_COM_ATTO_MOR,
                      w_ANNO_ATTO_MOR, w_ATTO_MOR, w_PARTE_MOR, w_SERIE_MOR, w_UFFICIO_MOR,
                      w_ANNO_ATTO_MOR_TR, w_ATTO_MOR_TR, w_PARTE_MOR_TR, w_SERIE_MOR_TR, w_UFFICIO_MOR_TR,
                      w_ATTO_MOR_DIGITALE, w_ATTO_MOR_TR_DIGITALE,
                      w_COD_PRO_VED, w_COD_COM_VED, w_DATA_VED,
                      w_COD_PRO_ATTO_VED, w_COD_COM_ATTO_VED,
                      w_ANNO_ATTO_VED, w_ATTO_VED, w_PARTE_VED, w_SERIE_VED, w_UFFICIO_VED,
                      w_ATTO_VED_DIGITALE,
                      w_COD_PRO_DIV, w_COD_COM_DIV, w_DATA_DIV, w_DATA_DIV_GIU, w_DATA_DIV_ANN,
                      w_COD_PRO_ATTO_DIV, w_COD_COM_ATTO_DIV,
                      w_ANNO_ATTO_DIV, w_ATTO_DIV, w_PARTE_DIV, w_SERIE_DIV, w_UFFICIO_DIV,
                      w_ATTO_DIV_DIGITALE,
                      w_DATA_REG, w_TERMINALISTA,
                      w_ELETTORALE, w_ANNULLAMENTO,
                      w_ANNO_PROGR, w_NUMERO_PROGR,
                      w_NO_CONTEGGIO, w_NO_VANA
                from dual
               where not exists (select 1 from anamov b
                                  where b.matricola               = w_matricola
                                    and b.cod_mov                 = w_cod_mov
                                    and b.cod_eve                 = w_cod_eve
                                    and nvl(b.cod_variazione,' ') = nvl(w_cod_variazione,' ')
                                    and b.pratica                 = w_pratica
                                    and b.anno_pratica            = w_anno_pratica
                                    and b.data_eve                = w_data_eve)
              ;
            exception
              when others then
                   w_errore := 'Errore in ins_anamov - ann '||w_cod_mov||'-'||w_cod_eve||'-'||w_cod_variazione||' (matricola: '||rec.matricola||')';
                   w_return := -1;
            end;

        end loop;
     end if;
  end if; --if a_anagrafe       is not null and

  return w_return;

exception
  when errore then
       raise_application_error(-20999,w_errore);
       return w_return;
  when others then
       return w_return;
end;
/
