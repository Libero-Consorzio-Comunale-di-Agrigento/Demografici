--liquibase formatted sql
--changeset amonopoli:202512231125 runOnChange:true stripComments:false
create or replace view anatpr_v_zk_soggetti
AS
select v.*,
       v.id_pratica||'-'||lpad(nvl(v.matricola_dichiarante,0),10,'0')||'-'||lpad(nvl(v.matricola_soggetto_min,0),10,'0') id
  from (
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr,
       tpr.id_pratica,
       ap4.anno_dic, ap4.numero_dic,
       f_ANA_get_id_pratica(tpr.anagrafe, tpr.tipo_evento, ap4.anno_dic, ap4.numero_dic) id_dichiarazine,
       tpr.cod_fam_dic cod_fam_dichiarante,
       f_cognome(ana_dic.cognome_nome) cognome_dichiarante,
       f_nome(ana_dic.cognome_nome) nome_dichiarante,
       ana_dic.cod_fiscale cod_fiscale_dichiarante,
       ana_dic.matricola matricola_dichiarante,
       f_ANPR_id_scheda(ana_dic.matricola,'','','','','') id_anpr_dichiarante,
       f_ANPR_id_unico(ana_dic.matricola,'') id_unico_anpr_dichiarante,
       f_cognome(ana_min.cognome_nome) cognome_soggetto_min,
       f_nome(ana_min.cognome_nome) nome_soggetto_min,
       ana_min.cod_fiscale cod_fiscale_soggetto_min,
       ana_min.matricola matricola_soggetto_min,
       f_ANPR_id_scheda(ana_min.matricola,'','','','','') id_anpr_soggetto_min,
       f_ANPR_id_unico(ana_min.matricola,'') id_unico_anpr_soggetto_min       
  from anaana ana_min, anaana ana_dic, anaap4 ap4, anatpr tpr
 where ana_min.matricola (+) = f_TPR_get_matricola_min(tpr.anagrafe,tpr.tipo_evento,tpr.anno_pratica,tpr.pratica,tpr.anno_pratica,tpr.pratica)
   and ana_dic.matricola (+) = tpr.matricola_dic
   and ap4.anno_pratica	 (+) = tpr.anno_pratica
   and ap4.pratica	 (+) = tpr.pratica
   and tpr.anagrafe	     = 'RES'
   and tpr.tipo_evento	     = 'I'
UNION
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr,
       tpr.id_pratica,
       cp4.anno_dic, cp4.numero_dic,
       f_ANA_get_id_pratica(tpr.anagrafe, tpr.tipo_evento, cp4.anno_dic, cp4.numero_dic) id_dichiarazine,
       cp4.cod_fam_prov cod_fam_dichiarante,
       f_cognome(ana_dic.cognome_nome) cognome_dichiarante,
       f_nome(ana_dic.cognome_nome) nome_dichiarante,
       ana_dic.cod_fiscale cod_fiscale_dichiarante,
       ana_dic.matricola matricola_dichiarante,
       f_ANPR_id_scheda(ana_dic.matricola,'','','','','') id_anpr_dichiarante,
       f_ANPR_id_unico(ana_dic.matricola,'') id_unico_anpr_dichiarante,
       f_cognome(ana_min.cognome_nome) cognome_soggetto_min,
       f_nome(ana_min.cognome_nome) nome_soggetto_min,
       ana_min.cod_fiscale cod_fiscale_soggetto_min,
       ana_min.matricola matricola_soggetto_min,
       f_ANPR_id_scheda(ana_min.matricola,'','','','','') id_anpr_soggetto_min,
       f_ANPR_id_unico(ana_min.matricola,'') id_unico_anpr_soggetto_min
  from anaana ana_min, anaana ana_dic, anacp4 cp4, anatpr tpr
 where ana_min.matricola (+) = f_TPR_get_matricola_min(tpr.anagrafe,tpr.tipo_evento,tpr.anno_pratica,tpr.pratica,tpr.anno_pratica,tpr.pratica)
   and ana_dic.matricola (+) = cp4.matricola_dic
   and cp4.anno_pratica	 (+) = tpr.anno_pratica
   and cp4.pratica	 (+) = tpr.pratica
   and tpr.anagrafe	     = 'RES'
   and tpr.tipo_evento	     = 'C'
UNION
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr,
       tpr.id_pratica,
       tpr.anno_pratica anno_dic, tpr.pratica numero_dic,
       f_ANA_get_id_pratica(tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica) id_dichiarazine,
       tpr.cod_fam_dic cod_fam_dichiarante,
       f_cognome(ana_dic.cognome_nome) cognome_dichiarante,
       f_nome(ana_dic.cognome_nome) nome_dichiarante,
       ana_dic.cod_fiscale cod_fiscale_dichiarante,
       ana_dic.matricola matricola_dichiarante,
       f_ANPR_id_scheda(ana_dic.matricola,'','','','','') id_anpr_dichiarante,
       f_ANPR_id_unico(ana_dic.matricola,'') id_unico_anpr_dichiarante,
       f_cognome(ana_min.cognome_nome) cognome_soggetto_min,
       f_nome(ana_min.cognome_nome) nome_soggetto_min,
       ana_min.cod_fiscale cod_fiscale_soggetto_min,
       ana_min.matricola matricola_soggetto_min,
       f_ANPR_id_scheda(ana_min.matricola,'','','','','') id_anpr_soggetto_min,
       f_ANPR_id_unico(ana_min.matricola,'') id_unico_anpr_soggetto_min
  from anaana ana_min, anaana ana_dic, anacre cre, anatpr tpr
 where ana_min.matricola (+) = f_TPR_get_matricola_min(tpr.anagrafe,tpr.tipo_evento,tpr.anno_pratica,tpr.pratica,'','')
   and ana_dic.matricola (+) = tpr.matricola_dic
   and cre.anno_pratica	 (+) = tpr.anno_pratica
   and cre.pratica	 (+) = tpr.pratica
   and tpr.anagrafe	     = 'RES'
   and tpr.tipo_evento	     = 'E'
UNION
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr,
       tpr.id_pratica,
       tpr.anno_pratica anno_dic, tpr.pratica numero_dic,
       f_ANA_get_id_pratica(tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica) id_dichiarazine,
       tpr.cod_fam_dic cod_fam_dichiarante,
       f_cognome(ana_dic.cognome_nome) cognome_dichiarante,
       f_nome(ana_dic.cognome_nome) nome_dichiarante,
       ana_dic.cod_fiscale cod_fiscale_dichiarante,
       ana_dic.matricola matricola_dichiarante,
       f_ANPR_id_scheda(ana_dic.matricola,'','','','','') id_anpr_dichiarante,
       f_ANPR_id_unico(ana_dic.matricola,'') id_unico_anpr_dichiarante,
       f_cognome(ana_min.cognome_nome) cognome_soggetto_min,
       f_nome(ana_min.cognome_nome) nome_soggetto_min,
       ana_min.cod_fiscale cod_fiscale_soggetto_min,
       ana_min.matricola matricola_soggetto_min,
       f_ANPR_id_scheda(ana_min.matricola,'','','','','') id_anpr_soggetto_min,
       f_ANPR_id_unico(ana_min.matricola,'') id_unico_anpr_soggetto_min
  from anaana ana_min, anaana ana_dic, anaret ret, anatpr tpr
 where ana_min.matricola (+) = f_TPR_get_matricola_min(tpr.anagrafe,tpr.tipo_evento,tpr.anno_pratica,tpr.pratica,'','')
   and ana_dic.matricola (+) = tpr.matricola_dic
   and ret.anno_pratica	 (+) = tpr.anno_pratica
   and ret.pratica	 (+) = tpr.pratica
   and tpr.anagrafe	     = 'RES'
   and tpr.tipo_evento	     = 'R'
UNION
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr,
       tpr.id_pratica,
       tpr.anno_pratica anno_dic, tpr.pratica numero_dic,
       f_ANA_get_id_pratica(tpr.anagrafe, tpr.tipo_evento, '', '') id_dichiarazine,
       tpr.cod_fam_dic cod_fam_dichiarante,
       f_cognome(ana_dic.cognome_nome) cognome_dichiarante,
       f_nome(ana_dic.cognome_nome) nome_dichiarante,
       ana_dic.cod_fiscale cod_fiscale_dichiarante,
       ana_dic.matricola matricola_dichiarante,
       f_ANPR_id_scheda(ana_dic.matricola,'','','','','') id_anpr_dichiarante,
       f_ANPR_id_unico(ana_dic.matricola,'') id_unico_anpr_dichiarante,
       f_cognome(ana_min.cognome_nome) cognome_soggetto_min,
       f_nome(ana_min.cognome_nome) nome_soggetto_min,
       ana_min.cod_fiscale cod_fiscale_soggetto_min,
       ana_min.matricola matricola_soggetto_min,
       f_ANPR_id_scheda(ana_min.matricola,'','','','','') id_anpr_soggetto_min,
       f_ANPR_id_unico(ana_min.matricola,'') id_unico_anpr_soggetto_min       
  from anaana ana_min, anaana ana_dic, anaa01 a01, anatpr tpr
 where ana_min.matricola        (+) = f_TPR_get_matricola_min(tpr.anagrafe,tpr.tipo_evento,tpr.anno_pratica,tpr.pratica,'','')
   and ana_dic.matricola        (+) = tpr.matricola_dic
   and a01.anno_protocollo_aire (+) = tpr.anno_pratica
   and a01.protocollo_aire      (+) = tpr.pratica
   and tpr.anagrafe	            = 'AIR'
   and tpr.tipo_evento	            = 'I'
   and a01.anno_pratica||a01.pratica is null
UNION
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr,
       tpr.id_pratica,
       tpr.anno_pratica anno_dic, tpr.pratica numero_dic,
       f_ANA_get_id_pratica(tpr.anagrafe, tpr.tipo_evento, '', '') id_dichiarazine,
       tpr.cod_fam_dic cod_fam_dichiarante,
       f_cognome(ana_dic.cognome_nome) cognome_dichiarante,
       f_nome(ana_dic.cognome_nome) nome_dichiarante,
       ana_dic.cod_fiscale cod_fiscale_dichiarante,
       ana_dic.matricola matricola_dichiarante,
       f_ANPR_id_scheda(ana_dic.matricola,'','','','','') id_anpr_dichiarante,
       f_ANPR_id_unico(ana_dic.matricola,'') id_unico_anpr_dichiarante,
       f_cognome(ana_min.cognome_nome) cognome_soggetto_min,
       f_nome(ana_min.cognome_nome) nome_soggetto_min,
       ana_min.cod_fiscale cod_fiscale_soggetto_min,
       ana_min.matricola matricola_soggetto_min,
       f_ANPR_id_scheda(ana_min.matricola,'','','','','') id_anpr_soggetto_min,
       f_ANPR_id_unico(ana_min.matricola,'') id_unico_anpr_soggetto_min       
  from anaana ana_min, anaana ana_dic, anac01 c01, anatpr tpr
 where ana_min.matricola        (+) = f_TPR_get_matricola_min(tpr.anagrafe,tpr.tipo_evento,tpr.anno_pratica,tpr.pratica,'','')
   and ana_dic.matricola        (+) = tpr.matricola_dic
   and c01.anno_protocollo_aire (+) = tpr.anno_pratica
   and c01.protocollo_aire      (+) = tpr.pratica
   and tpr.anagrafe	            = 'AIR'
   and tpr.tipo_evento	            = 'C'
   and c01.anno_pratica||c01.pratica is null
UNION
select tpr.anagrafe, tpr.tipo_evento, tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr,
       tpr.id_pratica,
       tpr.anno_pratica anno_dic, tpr.pratica numero_dic,
       f_ANA_get_id_pratica(tpr.anagrafe, tpr.tipo_evento, '', '') id_dichiarazine,
       tpr.cod_fam_dic cod_fam_dichiarante,
       f_cognome(ana_dic.cognome_nome) cognome_dichiarante,
       f_nome(ana_dic.cognome_nome) nome_dichiarante,
       ana_dic.cod_fiscale cod_fiscale_dichiarante,
       ana_dic.matricola matricola_dichiarante,
       f_ANPR_id_scheda(ana_dic.matricola,'','','','','') id_anpr_dichiarante,
       f_ANPR_id_unico(ana_dic.matricola,'') id_unico_anpr_dichiarante,
       f_cognome(ana_min.cognome_nome) cognome_soggetto_min,
       f_nome(ana_min.cognome_nome) nome_soggetto_min,
       ana_min.cod_fiscale cod_fiscale_soggetto_min,
       ana_min.matricola matricola_soggetto_min,
       f_ANPR_id_scheda(ana_min.matricola,'','','','','') id_anpr_soggetto_min,
       f_ANPR_id_unico(ana_min.matricola,'') id_unico_anpr_soggetto_min       
  from anaana ana_min, anaana ana_dic, anacaa caa, anatpr tpr
 where ana_min.matricola        (+) = f_TPR_get_matricola_min(tpr.anagrafe,tpr.tipo_evento,tpr.anno_pratica,tpr.pratica,'','')
   and ana_dic.matricola        (+) = tpr.matricola_dic
   and caa.anno_protocollo_aire (+) = tpr.anno_pratica
   and caa.protocollo_aire      (+) = tpr.pratica
   and tpr.anagrafe	            = 'AIR'
   and tpr.tipo_evento	            = 'E'
) v
/
comment on table anatpr_v_zk_soggetti is 'Pratiche Anagrafe - Dichiaranti Pratiche (view)'
/
