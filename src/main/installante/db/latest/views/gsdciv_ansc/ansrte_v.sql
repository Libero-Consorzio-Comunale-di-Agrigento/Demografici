--liquibase formatted sql
--changeset amonopoli:202307311625_2 runOnChange:true stripComments:false
create or replace view ansrte_v
       (des_tipo_atto, 
        id_atto_ads, categoria_ads, natura_ads, anno_ads, numero_unico_ads,
        usecase_ansc, validato_ansc, firmato_ansc, valida_data_ansc,
        notifica_ansc, notifica_anpr, aggiornato_ana_ads,
        soggetti_ansc, 
        id_atto_ansc, id_usecase_ansc, des_usecase_ansc,
        id_soggetto_ansc_1, id_soggetto_ansc_2,
        cognome_1, nome_1, sesso_1, data_nas_1,
        cognome_2, nome_2, sesso_2, data_nas_2,
        data_reg, 
        lista_comunicazioni_ansc, 
        lista_notifiche_ansc
       )
AS
select t01.id||' - '||t01.descrizione des_tipo_atto,
       nas.id_atto id_atto_ads, 
       cta.sigla categoria_ads, 
       nas.natura natura_ads, 
       nas.anno anno_ads,
       nas.numero_unico numero_unico_ads,
       decode(nas.id_usecase_ansc, '', 'NO', 'SI') usecase_ansc,
       decode(nas.id_atto_ansc, '', 'NO', 'SI') validato_ansc,
       f_ANSC_flag_servizio_RTE('NAS',nas.id,'R007') firmato_ansc,
       f_ANSC_flag_servizio_RTE('NAS',nas.id,'R014') valida_data_ansc,
       f_ANSC_flag_notifica_ansc_RTE(nas.id_atto_ansc) notifica_ansc,
       f_ANSC_flag_notifica_anpr_RTE(nas.id_atto_ansc) notifica_anpr,
       f_ANSC_flag_aggiornato_ana_RTE('NAS',nas.id_atto_ansc) aggiornato_ana_ads,
       decode(nas.id_soggetto_ansc, '', 'NO', 'SI') soggetti_ansc,
       nas.id_atto_ansc, 
       nas.id_usecase_ansc, 
       t03.descrizione des_usecase_ansc,
       nas.id_soggetto_ansc id_soggetto_ansc_1,
       to_number(null) id_soggetto_ansc_2,
       nas.cognome, 
       nas.nome, 
       nas.sesso, 
       to_char(to_date(nas.data_nas,'j'),'dd/mm/yyyy') data_nas,
       to_char(null), 
       to_char(null), 
       to_char(null), 
       to_char(null),
       to_char(nas.d_data_reg,'dd/mm/yyyy hh24:mi:ss') data_reg,
       f_ANSC_lista_ciu_RTE('NAS',nas.id) lista_comunicazioni_ansc,
       f_ANSC_lista_not_RTE(nas.id_atto_ansc) lista_notifiche_ansc
  from anst01 t01,
       anst03 t03,
       civcta cta,
       civdta dta,
       civnas nas
 where t01.tipo_atto_ads = 2
   and t03.id (+)           = nas.id_usecase_ansc
   and cta.id               = dta.id_civcta
   and dta.id               = nas.id_civdta
   and nas.numero_unico     is not null
   and nas.cod_rec          in (0,3) 
   and nas.anno             != 1800
UNION ALL
select t01.id||' - '||t01.descrizione des_tipo_atto,
       mor.id_atto id_atto_ads,  
       cta.sigla categoria_ads, 
       mor.natura natura_ads, 
       mor.anno anno_ads,
       mor.numero_unico numero_unico_ads,
       decode(mor.id_usecase_ansc, '', 'NO', 'SI') usecase_ansc,
       decode(mor.id_atto_ansc, '', 'NO', 'SI') validato_ansc,
       f_ANSC_flag_servizio_RTE('MOR',mor.id,'R007') firmato_ansc,
       f_ANSC_flag_servizio_RTE('MOR',mor.id,'R014') valida_data_ansc,
       f_ANSC_flag_notifica_ansc_RTE(mor.id_atto_ansc) notifica_ansc,
       f_ANSC_flag_notifica_anpr_RTE(mor.id_atto_ansc) notifica_anpr,
       f_ANSC_flag_aggiornato_ana_RTE('MOR',mor.id_atto_ansc) aggiornato_ana_ads,
       decode(mor.id_soggetto_ansc, '', 'NO', 'SI') soggetti_ansc,
       mor.id_atto_ansc, mor.id_usecase_ansc, t03.descrizione des_usecase_ansc,
       mor.id_soggetto_ansc id_soggetto_ansc_1,
       to_number(null) id_soggetto_ansc_2,
       mor.cognome, 
       mor.nome, 
       mor.sesso, 
       to_char(to_date(mor.data_nas,'j'),'dd/mm/yyyy') data_nas,
       to_char(null), 
       to_char(null), 
       to_char(null), 
       to_char(null),
       to_char(mor.d_data_reg,'dd/mm/yyyy hh24:mi:ss') data_reg,
       f_ANSC_lista_ciu_RTE('MOR',mor.id) lista_comunicazioni_ansc,
       f_ANSC_lista_not_RTE(mor.id_atto_ansc) lista_notifiche_ansc
  from anst01 t01,
       anst03 t03,
       civcta cta,
       civdta dta,
       civmor mor
 where t01.tipo_atto_ads = 5
   and t03.id (+)           = mor.id_usecase_ansc
   and cta.id               = dta.id_civcta
   and dta.id               = mor.id_civdta
   and mor.numero_unico     is not null
   and mor.cod_rec          in (0,3) 
   and mor.anno             != 1800
UNION ALL
select t01.id||' - '||t01.descrizione des_tipo_atto,
       mat.id_atto id_atto_ads, 
       cta.sigla categoria_ads, 
       mat.natura natura_ads, 
       mat.anno anno_ads,
       mat.numero_unico numero_unico_ads,
       decode(mat.id_usecase_ansc, '', 'NO', 'SI') usecase_ansc,
       decode(mat.id_atto_ansc, '', 'NO', 'SI') validato_ansc,
       f_ANSC_flag_servizio_RTE('MAT',mat.id,'R007') firmato_ansc,
       f_ANSC_flag_servizio_RTE('MAT',mat.id,'R014') valida_data_ansc,
       f_ANSC_flag_notifica_ansc_RTE(mat.id_atto_ansc) notifica_ansc,
       f_ANSC_flag_notifica_anpr_RTE(mat.id_atto_ansc) notifica_anpr,
       f_ANSC_flag_aggiornato_ana_RTE('MAT',mat.id_atto_ansc) aggiornato_ana_ads,
       decode(mat.id_soggetto_ansc_m||mat.id_soggetto_ansc_f, '', 'NO', 'SI') soggetti_ansc,
       mat.id_atto_ansc, mat.id_usecase_ansc, t03.descrizione des_usecase_ansc,
       mat.id_soggetto_ansc_m id_soggetto_ansc_1,
       mat.id_soggetto_ansc_f id_soggetto_ansc_2,
       mat.cognome_m cognome_1, 
       mat.nome_m nome_1, 
       'M' seesso_1, 
       to_char(to_date(mat.data_nas_m,'j'),'dd/mm/yyyy') data_nas_1,
       mat.cognome_f cognome_2, 
       mat.nome_f nome_2, 
       'F' sesso_2, 
       to_char(to_date(mat.data_nas_f,'j'),'dd/mm/yyyy') data_nas_2,
       to_char(mat.d_data_reg,'dd/mm/yyyy hh24:mi:ss') data_reg,
       f_ANSC_lista_ciu_RTE('MAT',mat.id) lista_comunicazioni_ansc,
       f_ANSC_lista_not_RTE(mat.id_atto_ansc) lista_notifiche_ansc
  from anst01 t01,
       anst03 t03,
       civcta cta,
       civdta dta,
       civmat mat
 where t01.tipo_atto_ads = 4
   and t03.id (+)           = mat.id_usecase_ansc
   and cta.id               = dta.id_civcta
   and dta.id               = mat.id_civdta
   and mat.numero_unico     is not null
   and mat.cod_rec          in (0,3) 
   and mat.anno             != 1800
UNION ALL
select t01.id||' - '||t01.descrizione des_tipo_atto,
       uci.id_atto id_atto_ads, 
       cta.sigla categoria_ads, 
       uci.natura natura_ads, 
       uci.anno anno_ads,
       uci.numero_unico numero_unico_ads,
       decode(uci.id_usecase_ansc, '', 'NO', 'SI') usecase_ansc,
       decode(uci.id_atto_ansc, '', 'NO', 'SI') validato_ansc,
       f_ANSC_flag_servizio_RTE('UCI',uci.id,'R007') firmato_ansc,
       f_ANSC_flag_servizio_RTE('UCI',uci.id,'R014') valida_data_ansc,
       f_ANSC_flag_notifica_ansc_RTE(uci.id_atto_ansc) notifica_ansc,
       f_ANSC_flag_notifica_anpr_RTE(uci.id_atto_ansc) notifica_anpr,
       f_ANSC_flag_aggiornato_ana_RTE('UCI',uci.id_atto_ansc) aggiornato_ana_ads,
       decode(uci.id_soggetto_ansc_m||uci.id_soggetto_ansc_f, '', 'NO', 'SI') soggetti_ansc,
       uci.id_atto_ansc, 
       uci.id_usecase_ansc, 
       t03.descrizione des_usecase_ansc,
       uci.id_soggetto_ansc_m id_soggetto_ansc_1,
       uci.id_soggetto_ansc_f id_soggetto_ansc_2,
       uci.cognome_m cognome_1, 
       uci.nome_m nome_1, 
       uci.sesso_m sesso_1, 
       to_char(to_date(uci.data_nas_m,'j'),'dd/mm/yyyy') data_nas_1,
       uci.cognome_f cognome_2, 
       uci.nome_f nome_2, 
       uci.sesso_f sesso_2, 
       to_char(to_date(uci.data_nas_f,'j'),'dd/mm/yyyy') data_nas_2,
       to_char(uci.d_data_reg,'dd/mm/yyyy hh24:mi:ss') data_reg,
       f_ANSC_lista_ciu_RTE('UCI',uci.id) lista_comunicazioni_ansc,
       f_ANSC_lista_not_RTE(uci.id_atto_ansc) lista_notifiche_ansc
  from anst01 t01,
       anst03 t03,
       civcta cta,
       civdta dta,
       civuci uci
 where t01.tipo_atto_ads = -4
   and t03.id (+)           = uci.id_usecase_ansc
   and cta.id               = dta.id_civcta
   and dta.id               = uci.id_civdta
   and uci.numero_unico     is not null
   and uci.cod_rec          in (0,3) 
   and uci.anno             != 1800
UNION ALL
select t01.id||' - '||t01.descrizione des_tipo_atto,
       cit.id_atto id_atto_ads, 
       cta.sigla categoria_ads, 
       cit.natura natura_ads, 
       cit.anno anno_ads,
       cit.numero_unico numero_unico_ads,
       decode(cit.id_usecase_ansc, '', 'NO', 'SI') usecase_ansc,
       decode(cit.id_atto_ansc, '', 'NO', 'SI') validato_ansc,
       f_ANSC_flag_servizio_RTE('CIT',cit.id,'R007') firmato_ansc,
       f_ANSC_flag_servizio_RTE('CIT',cit.id,'R014') valida_data_ansc,
       f_ANSC_flag_notifica_ansc_RTE(cit.id_atto_ansc) notifica_ansc,
       f_ANSC_flag_notifica_anpr_RTE(cit.id_atto_ansc) notifica_anpr,
       f_ANSC_flag_aggiornato_ana_RTE('CIT',cit.id_atto_ansc) aggiornato_ana_ads,
       decode(cit.id_soggetto_ansc, '', 'NO', 'SI') soggetti_ansc,
       cit.id_atto_ansc, cit.id_usecase_ansc, t03.descrizione des_usecase_ansc,
       cit.id_soggetto_ansc id_soggetto_ansc_1,
       to_number(null) id_soggetto_ansc_2,
       cit.cognome, 
       cit.nome, 
       cit.sesso, 
       to_char(to_date(cit.data_nas,'j'),'dd/mm/yyyy') data_nas,
       to_char(null), 
       to_char(null), 
       to_char(null), 
       to_char(null),
       to_char(cit.d_data_reg,'dd/mm/yyyy hh24:mi:ss') data_reg,
       f_ANSC_lista_ciu_RTE('CIT',cit.id) lista_comunicazioni_ansc,
       f_ANSC_lista_not_RTE(cit.id_atto_ansc) lista_notifiche_ansc
  from anst01 t01,
       anst03 t03,
       civcta cta,
       civdta dta,
       civcit cit
 where t01.tipo_atto_ads = 1
   and t03.id (+)           = cit.id_usecase_ansc
   and cta.id               = dta.id_civcta
   and dta.id               = cit.id_civdta
   and cit.numero_unico     is not null
   and cit.cod_rec          in (0,3) 
   and cit.anno             != 1800
UNION ALL
select '99 - ANNOTAZIONE' des_tipo_atto,
       ann.id_atto id_atto_ads,
       ann.genere categoria_ads,
       to_char(null) natura_ads,
       nvl(ann.anno_annotazione,to_char(ann.d_data_reg,'yyyy')) anno_ads,
       ann.numero_unico numero_unico_ads,
       decode(ann.id_usecase_ansc, '', 'NO', 'SI') usecase_ansc,
       decode(ann.id_atto_ansc, '', 'NO', 'SI') validato_ansc,
       f_ANSC_flag_servizio_RTE('ANN',ann.id,'R007_A') firmato_ansc,
       f_ANSC_flag_servizio_RTE('ANN',ann.id,'R014') valida_data_ansc,
       f_ANSC_flag_notifica_ansc_RTE(ann.id_atto_ansc) notifica_ansc,
       to_char(null) notifica_anpr,
       to_char(null) aggiornato_ana_ads,
       to_char(null) soggetti_ansc,
       ann.id_atto_ansc, ann.id_usecase_ansc, t03.descrizione des_usecase_ansc,
       to_number(null) id_soggetto_ansc_1,
       to_number(null) id_soggetto_ansc_2,
       to_char(null) cognome,
       to_char(null) nome,
       to_char(null) sesso,
       to_char(null) data_nas,
       to_char(null), to_char(null), to_char(null), to_char(null),
       to_char(ann.d_data_reg,'dd/mm/yyyy hh24:mi:ss') data_reg,
       f_ANSC_lista_ciu_RTE('ANN',ann.id) lista_comunicazioni_ansc,
       f_ANSC_lista_not_RTE(ann.id_atto_ansc) lista_notifiche_ansc
  from anst03 t03,
       civann ann
 where t03.id (+)           = ann.id_usecase_ansc
   and ann.numero_unico  is not null
UNION ALL
select '00 - BUCO DI NUMERAZIONE' des_tipo_atto,
       to_char(null) id_atto_ads,
       to_char(null) categoria_ads,
       to_char(null) natura_ads,
       v.anno anno_ads,
       v.numero_unico numero_unico_ads,
       to_char(null) usecase_ansc,
       to_char(null) validato_ansc,
       to_char(null) firmato_ansc,
       to_char(null) valida_data_ansc,
       to_char(null) notifica_ansc,
       to_char(null) notifica_anpr,
       to_char(null) aggiornato_ana_ads,
       to_char(null) soggetti_ansc,
       to_char(null) id_atto_ansc, 
       to_number(null) id_usecase_ansc, 
       to_char(null) des_usecase_ansc,
       to_number(null) id_soggetto_ansc_1,
       to_number(null) id_soggetto_ansc_2,
       to_char(null) cognome,
       to_char(null) nome,
       to_char(null) sesso,
       to_char(null) data_nas,
       to_char(null) cognome_2, 
       to_char(null) nome_2,  
       to_char(null) sesso_2, 
       to_char(null) data_nas_2,
       to_char(null) data_reg,
       empty_clob() lista_comunicazioni_ansc,
       empty_clob() lista_notifiche_ansc
  from (select n01.anno, rownum numero_unico
          from anaana ana,
               civn01 n01
         where n01.anno = to_char(sysdate,'yyyy')
           and rownum <= n01.numero) v
 where not exists (select 'x' from civcit where cod_rec in (0,3) and anno = v.anno and numero_unico = v.numero_unico)
   and not exists (select 'x' from civnas where cod_rec in (0,3) and anno = v.anno and numero_unico = v.numero_unico)
   and not exists (select 'x' from civmat where cod_rec in (0,3) and anno = v.anno and numero_unico = v.numero_unico)
   and not exists (select 'x' from civuci where cod_rec in (0,3) and anno = v.anno and numero_unico = v.numero_unico)
   and not exists (select 'x' from civmor where cod_rec in (0,3) and anno = v.anno and numero_unico = v.numero_unico)
   and not exists (select 'x' from civann where anno_annotazione = v.anno and numero_unico = v.numero_unico)
   and not exists (select 'x' from civnas_plurimo where anno = v.anno and numero_unico = v.numero_unico)
UNION ALL
select '01 - NUMERI PRENOTATI (PARTO PLURIMO)' des_tipo_atto,
       nas_p.id_atto id_atto_ads,
       to_char(null) categoria_ads,
       to_char(null) natura_ads,
       nas_p.anno anno_ads,
       nas_p.numero_unico numero_unico_ads,
       to_char(null) usecase_ansc,
       to_char(null) validato_ansc,
       to_char(null) firmato_ansc,
       to_char(null) valida_data_ansc,
       to_char(null) notifica_ansc,
       to_char(null) notifica_anpr,
       to_char(null) aggiornato_ana_ads,
       to_char(null) soggetti_ansc,
       to_char(null) id_atto_ansc, 
       to_number(null) id_usecase_ansc, 
       to_char(null) des_usecase_ansc,
       to_number(null) id_soggetto_ansc_1,
       to_number(null) id_soggetto_ansc_2,
       to_char(null) cognome,
       to_char(null) nome,
       to_char(null) sesso,
       to_char(null) data_nas,
       to_char(null) cognome_2, 
       to_char(null) nome_2,  
       to_char(null) sesso_2, 
       to_char(null) data_nas_2,
       to_char(null) data_reg,
       empty_clob() lista_comunicazioni_ansc,
       empty_clob() lista_notifiche_ansc
  from civnas_plurimo nas_p
 where not exists (select 'x' from civnas where cod_rec in (0,3) and id_atto = nas_p.id_atto)
 order by 1, 7 desc, 5
/
comment on table ansrte_v is 'ANSC - Elenco Atti / Comunicazioni per Rapporto di Test (view)'
/
