--liquibase formatted sql
--changeset amonopoli:202602261515_2 runOnChange:true stripComments:false
create or replace function f_SDDR_lista_targhe_CC
(a_matricola      IN       number
,a_categoria      IN       varchar2
)

return varchar2

IS

w_lista_targhe    varchar2(255);

cursor sel_doc is
select doc.numero
  from anadca dca, anadoc doc
 where substr(dca.descrizione,1,1) = a_categoria
   and dca.cod_ca                  = doc.categoria
   and doc.tipo_documento          = 'CC'
   and doc.natura_documento        != 'A'
   and doc.matricola               = a_matricola
 order by progr_documento
;

begin
  for rec in sel_doc loop
      w_lista_targhe := w_lista_targhe||' '||rec.numero;
  end loop;
  
  w_lista_targhe := ltrim(w_lista_targhe);
  
  return w_lista_targhe;
end;
/
create or replace view anawpm_SDDR_zk
AS
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica,
       decode(ap4.sottoscritto, '', apm.numero_ordine, 1, apm.numero_ordine, 9, apm.numero_ordine,
         decode(apm.numero_ordine, ap4.sottoscritto, 1, apm.numero_ordine+1)) numero_ordine,
       apm.matricola,
       ana.cognome f_cognome_s,
       ana.nome f_nome_s,
       ana.cod_fiscale f_cod_fiscale_s,
       decode(ana.anno_nas,'S','00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
         to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')) f_data_nas_s,
       a.descrizione f_luogo_nas_s,
       ana.sesso f_sesso_s,
       dsc.descrizione f_stato_civile_s,
       dci.descrizione f_citt_s,
       apm.ist_rp,
       (select descrizione from anadrp where cod_rp = nvl(apm.nuovo_rapporto_par,apm.RAPPORTO_PAR_PREC) and sesso = ana.sesso) des_rapporto_par,
       dpr.descrizione f_professione_s,
       ana.posizione_prof,
       decode(ana.posizione_prof,1,'X') b_prof_1,
       decode(ana.posizione_prof,2,'X') b_prof_2,
       decode(ana.posizione_prof,3,'X') b_prof_3,
       decode(ana.posizione_prof,4,'X') b_prof_4,
       decode(ana.posizione_prof,5,'X') b_prof_5,
       apm.ist_np,
       decode(apm.ist_np,1,'X') b_nprof_1,
       decode(apm.ist_np,2,'X') b_nprof_2,
       decode(apm.ist_np,3,'X') b_nprof_3,
       decode(apm.ist_np,4,'X') b_nprof_4,
       decode(apm.ist_np,5,'X') b_nprof_5,
       apm.ist_ts,
       decode(apm.ist_ts,1,'X') b_ts_1,
       decode(apm.ist_ts,2,'X') b_ts_2,
       decode(apm.ist_ts,3,'X') b_ts_3,
       decode(apm.ist_ts,4,'X') b_ts_4,
       decode(apm.ist_ts,5,'X') b_ts_5,
       decode(apm.ist_ts,6,'X') b_ts_6,
       decode(ap4.sottoscritto, '', apm.numero_ordine, 1, apm.numero_ordine, 9, apm.numero_ordine,
         decode(apm.numero_ordine, ap4.sottoscritto, 1, apm.numero_ordine+1)) w_ord_1,
       lpad(nvl(nvl(nuova_sequenza_par,sequenza_par_prec),0),2,'0')||ana.data_nas w_ord_2,
-- dati patente
       doc_pt.des_categoria f_tipo_pt,
       doc_pt.numero f_numero_pt,
       doc_pt.data_emissione f_data_emissione_pt,
       doc_pt.des_ente_emissione f_ente_emissione_pt,
       doc_pt.sigla_pro_ente_emissione f_sigla_provincia_pt,
-- dati veicoli
       f_SDDR_lista_targhe_CC(ana.matricola,'A') f_numero_cc_A,
       f_SDDR_lista_targhe_CC(ana.matricola,'R') f_numero_cc_R,
       f_SDDR_lista_targhe_CC(ana.matricola,'M') f_numero_cc_M,
       f_SDDR_lista_targhe_CC(ana.matricola,'C') f_numero_cc_C,
       'APM'||lpad(apm.id,10,'0') id,
       tpr.id id_anatpr
  from (select doc.matricola,
               dca.descrizione des_categoria,
               doc.numero,
               to_char(to_date(doc.data_emissione,'j'),'dd/mm/yyyy') data_emissione,
               den.descrizione des_ente_emissione,
               c.descrizione des_com_ente_emissione,
               c.sigla_provincia sigla_pro_ente_emissione
          from arccom c, anaden den, anadca dca, anadoc doc
         where c.cod_provincia (+)  = doc.cod_pro_ente
           and c.cod_comune    (+)  = doc.cod_com_ente
           and den.cod_en      (+)  = doc.ente_emissione
           and dca.cod_ca      (+)  = doc.categoria
           and doc.tipo_documento   = 'PT'
           and doc.natura_documento != 'A'
           and doc.progr_documento  = 1) doc_pt,
       arccom a,
       anadpr dpr, anadci dci, anadsc dsc,
       anaana ana, anaapm apm, anaap4 ap4, anatpr tpr
 where a.cod_provincia (+) = ana.cod_pro_nas
   and a.cod_comune    (+) = ana.cod_com_nas
   and dsc.sesso       (+) = ana.sesso
   and dsc.cod_sc      (+) = ana.stato_civile
   and dpr.cod_pr      (+) = ana.cod_prof
   and dpr.sesso       (+) = ana.sesso
   and dci.cod_ci      (+) = ana.nazionalita
   and doc_pt.matricola (+) = ana.matricola
   and ana.matricola       = apm.matricola
   and apm.annullamento    is null
   and apm.flag_soggetto   is not null
   and apm.numero_ordine   is not null
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic      = ap4.numero_dic
   and ap4.anno_pratica    = tpr.anno_pratica
   and ap4.pratica         = tpr.pratica
   and tpr.tipo_evento     = 'I'
   and tpr.anagrafe        = 'RES'
UNION
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica,
       decode(cre.sottoscritto, '', crm.numero_ordine, 1, crm.numero_ordine, 9, crm.numero_ordine,
         decode(crm.numero_ordine, cre.sottoscritto, 1, crm.numero_ordine+1)) numero_ordine,
       crm.matricola,
       ana.cognome,
       ana.nome,
       ana.cod_fiscale,
       decode(ana.anno_nas,'S','00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
         to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
       a.descrizione,
       ana.sesso,
       dsc.descrizione,
       dci.descrizione,
       nvl(nuovo_rapporto_par,RAPPORTO_PAR_PREC) ist_rp,
       (select descrizione from anadrp where cod_rp = nvl(crm.nuovo_rapporto_par,crm.RAPPORTO_PAR_PREC) and sesso = ana.sesso) des_rapporto_par,
       dpr.descrizione,
       ana.posizione_prof,
       decode(ana.posizione_prof,1,'X') b_prof_1,
       decode(ana.posizione_prof,2,'X') b_prof_2,
       decode(ana.posizione_prof,3,'X') b_prof_3,
       decode(ana.posizione_prof,4,'X') b_prof_4,
       decode(ana.posizione_prof,5,'X') b_prof_5,
       to_number(null) ist_np,
       to_char(null) b_nprof_1,
       to_char(null) b_nprof_2,
       to_char(null) b_nprof_3,
       to_char(null) b_nprof_4,
       to_char(null) b_nprof_5,
       to_number(null) ist_ts,
       to_char(null) b_ts_1,
       to_char(null) b_ts_2,
       to_char(null) b_ts_3,
       to_char(null) b_ts_4,
       to_char(null) b_ts_5,
       to_char(null) b_ts_6,
       decode(cre.sottoscritto, '', crm.numero_ordine, 1, crm.numero_ordine, 9, crm.numero_ordine,
         decode(crm.numero_ordine, cre.sottoscritto, 1, crm.numero_ordine+1)) w_ord_1,
       lpad(nvl(nvl(nuova_sequenza_par,sequenza_par_prec),0),2,'0')||ana.data_nas w_ord_2,
-- dati patente
       doc_pt.des_categoria f_tipo_pt,
       doc_pt.numero f_numero_pt,
       doc_pt.data_emissione f_data_emissione_pt,
       doc_pt.des_ente_emissione f_ente_emissione_pt,
       doc_pt.sigla_pro_ente_emissione f_sigla_provincia_pt,
-- dati veicoli
       f_SDDR_lista_targhe_CC(ana.matricola,'A') f_numero_cc_A,
       f_SDDR_lista_targhe_CC(ana.matricola,'R') f_numero_cc_R,
       f_SDDR_lista_targhe_CC(ana.matricola,'M') f_numero_cc_M,
       f_SDDR_lista_targhe_CC(ana.matricola,'C') f_numero_cc_C,
       'CRM'||lpad(crm.id,10,'0') id,
       tpr.id id_anatpr
  from (select doc.matricola,
               dca.descrizione des_categoria, 
               doc.numero,
               to_char(to_date(doc.data_emissione,'j'),'dd/mm/yyyy') data_emissione,
               den.descrizione des_ente_emissione,
               c.descrizione des_com_ente_emissione, 
               c.sigla_provincia sigla_pro_ente_emissione
          from arccom c, anaden den, anadca dca, anadoc doc
         where c.cod_provincia (+) = doc.cod_pro_ente
           and c.cod_comune    (+)  = doc.cod_com_ente
           and den.cod_en      (+)  = doc.ente_emissione
           and dca.cod_ca      (+)  = doc.categoria
           and doc.tipo_documento   = 'PT'
           and doc.natura_documento != 'A'
           and doc.progr_documento  = 1) doc_pt,  
       arccom a,
       anadpr dpr, anadci dci, anadsc dsc,
       anaana ana, anacrm crm, anacre cre, anatpr tpr
 where a.cod_provincia (+)   = ana.cod_pro_nas
   and a.cod_comune    (+)   = ana.cod_com_nas
   and dsc.sesso       (+)   = ana.sesso
   and dsc.cod_sc      (+)   = ana.stato_civile
   and dpr.cod_pr      (+)   = ana.cod_prof
   and dpr.sesso       (+)   = ana.sesso
   and dci.cod_ci      (+)   = ana.nazionalita
   and doc_pt.matricola (+) = ana.matricola
   and ana.matricola         = crm.matricola
   and crm.flag_soggetto     is not null
   and crm.flag_annullamento is null
   and crm.anno_pratica      = cre.anno_pratica
   and crm.pratica           = cre.pratica 
   and cre.anno_pratica      = tpr.anno_pratica
   and cre.pratica           = tpr.pratica
   and tpr.tipo_evento       = 'E'
   and tpr.anagrafe          = 'RES'
/
comment on table anawpm_SDDR_zk is 'Anagrafe - Dati dei soggetti della pratica per Stampa Dichiarazione di Residenza (view)'
/
