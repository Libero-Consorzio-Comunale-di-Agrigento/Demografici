--liquibase formatted sql
--changeset amonopoli:202410091525_5 runOnChange:true stripComments:false
create or replace view certpr
	(anagrafe, tipo_evento,
	 anno_pratica, pratica, data_pratica, 
	 anno_dic, numero_dic,
	 tipo_pratica, 
         cognome_nome_dichiarante, cod_fiscale_dichiarante,
	 riga_trasferimento_1, riga_trasferimento_2,
	 riga_trasferimento_3, riga_trasferimento_4,
	 cognome_nome, cognome, nome, 
	 sesso, paternita, maternita, 
	 nat_oa, data_nascita, comune_nascita,
	 comune_atto_nascita, atto_nascita,
       stato_civile, coniugat_oa, cognome_nome_coniuge,
	 cittadinanza, cod_fiscale,
	 rapporto_parentela, sequenza_par,
	 residenza, indirizzo, cap_comune_residenza,
       residenza_fam, indirizzo_fam,
	 indirizzo_dichiarato, comune_dichiarato,
	 numero_carta_dichiarante, data_carta_dichiarante,
	 comune_data, comune, data,
	 matricola, fascia, cod_fam, 
	 flag_PT, flag_CC, 
	 flag_soggetto, flag_annullamento, data_nas,
         matricola_dichiarante,sesso_dichiarante,
         descrizione_evento,
	 professione, professione_dichiarante,
	 titolo_studio, titolo_studio_dichiarante,
         numero_patente, estremi_mat_ved,
         comune_provenienza, data_decorrenza, 
         cod_pro_eve, cod_com_eve, 
         cod_pro_aire, cod_com_aire,
         cod_pro_aire_prec, cod_com_aire_prec,
         cod_pro_nas, cod_com_nas)
as 
--
-- cambio di abitazione
--
select tpr.anagrafe, tpr.tipo_evento,
     tpr.anno_pratica, tpr.pratica, 
     to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- anno_dic, numero_dic
     tpr.anno_pratica, tpr.pratica, 
-- tipo_pratica
     'Cambio Abitazione ____________________ vedi punto A',
-- cognome_nome_dichiarante
     translate(tpr.cognome_nome_dic,'/',' '),
-- cod_fiscale_dichiarante
     ana_dic.cod_fiscale,
-- riga_trasferimento_1
     decode(cre.civico_esterno,fam_prov.civico_esterno,
       'essersi trasferito/i dall''interno '||fam_prov.civico_interno||
       'all''interno'||cre.civico_interno,
       decode(crm_v.familiari,
          1,'essersi trasferito/a in:',
           'essersi trasferito/a con i familiari sotto segnati in:')),
-- riga_trasferimento_2
     decode(cre.civico_esterno,fam_prov.civico_esterno,
       to_char(null),
         bvie.denom_uff||cre.civico_esterno||cre.civico_interno),
-- riga_trasferimento_3
     decode(cre.flag_aggregazione,'S',
       decode(fam_dest.tipo_fam,1,
        'presso la convivenza anagrafica:',
        'presso '||nvl(translate(fam_dest.intestatario,'/',' '),cre.presso)),
       decode(cre.convivenza,'',
           decode(cre.flag_intero_nucleo,'','costituendo nuovo nucleo familiare',''),
           'costituendo nuova convivenza anagrafica:')),
-- riga_trasferimento_4
        decode(cre.flag_aggregazione,'S',
       decode(fam_dest.tipo_fam,1, fam_dest.convivenza, ''),
         decode(cre.convivenza,'',to_char(null), cre.convivenza)),
-- cognome_nome
     translate(ana.cognome_nome,'/',' '),
-- cognome
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
-- nome
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),
-- sesso
     ana.sesso,
-- paternita
       'pt. '||translate(ana.paternita,'/',' '),
-- maternita
       'mt. '||translate(ana.maternita,'/',' '),
-- nat_oa
       decode(ana.sesso,'M','nato','nata'),
-- data_nascita
     decode(ana.anno_nas,'S',
       '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
-- comune_nascita
     nvl(a.descrizione_al1,a.descrizione)||' '||
       f_provincia_stato_CER(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
    a1.descrizione||decode(a1.sigla_provincia,'','',' ('||a1.sigla_provincia||')'),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '||ana.atto_nas||
           ' p. '||decode(ana.parte_nas,1,'I',2,'II')||
           decode(ana.serie_nas,'','',' s. '||ana.serie_nas)||
           decode(ana.ufficio_nas,0,'','','',' - '||ana.ufficio_nas)||
           ' / '||ana.anno_atto_nas,
         'atto digitale N. '||ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,
-- coniugat_oa
       decode(ana.stato_civile,'CN',
       decode(ana.sesso,'M','coniugato','coniugata'),''),
-- cognome_nome_coniuge
     decode(ana.stato_civile,
         'CN',translate(ana.cognome_nome_cn,'/',' '),
         'VE',translate(ana.cognome_nome_cn,'/',' '),''),
-- cittadinanza
     dci.descrizione, 
-- cod_fiscale
--     decode(ana.cod_fiscale,'',to_char(null),
--       decode(ana.cf_calcolato,'',ana.cod_fiscale,to_char(null))),
     ana.cod_fiscale,
-- rapporto_parentela
       drp.descrizione,
-- sequenza_par
       nvl(crm.nuova_sequenza_par,crm.sequenza_par_prec),
-- residenza
     m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')'),
-- indirizzo
     decode(vie_11.denom_uff, '',
       avie.denom_uff||fam_prov.civico_esterno||fam_prov.civico_interno,
       vie_11.denom_uff||eve_11.civico_esterno||eve_11.civico_interno),
-- cap_comune_residenza
     lpad(m.cap,5,'0'),
-- residenza_fam
       decode(ana.fascia,
       1,'Residente a '||m.descrizione||' ('||m.sigla_provincia||')'||' '||
             decode(ana.stato,1,'dalla nascita',
                        'dal '||to_char(to_date(ana.data_ult_eve,'j'),'dd/mm/yyyy'))),
-- indirizzo_fam
     'abitante in '||
       decode(ana.fascia,1,
         avie.denom_uff||fam_prov.civico_esterno,
         fam_prov.via_aire),
-- indirizzo_dichiarato
       bvie.denom_uff||cre.civico_esterno||cre.civico_interno,
-- comune_dichiarato
--     m.descrizione||' ('||m.sigla_provincia||')',
     to_char(null),
-- numero_carta_dichiarante
    doc_DI.numero||decode(doc_di.numero,null,'',' - '||com_DI.descrizione||decode(com_di.sigla_provincia,'','',' ('||com_DI.sigla_provincia||')')),
-- data_carta_dichiarante
     to_char(to_date(doc_DI.data_emissione,'j'),'dd/mm/yyyy'),
-- comune_data
     m.descrizione||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
     m.descrizione,
-- data
     to_char(sysdate,'dd/mm/yyyy'),
-- matricola
     crm.matricola, 
-- fascia
     ana.fascia,
-- cod_fam
     cre.cod_fam_prov,
-- flag_pt
     decode(doc_PT.matricola,'',to_char(null),'S'),
-- flag_cc
     decode(doc_CC.matricola,'',to_char(null),'S'),
-- flag_soggetto
       crm.flag_soggetto,
-- flag_annullamento
       crm.flag_annullamento,
-- data_nas : per order by
     ana.data_nas,
-- matricola_dichiarante
     tpr.matricola_dic,
-- sesso_dichiarante
     ana_dic.sesso,
-- descrizione_evento
     dce.des_evento_tpr,
-- professione  
     dpr.descrizione,
-- professione_dichiarante
     dpr_d.descrizione,
-- titolo_studio
     dts.descrizione,
-- titolo_sudio_dichiarante
     dts_d.descrizione,
--  numero_patente
     doc_pt.numero,
--estremi_mat_ved
     DECODE (ana.stato_civile,'CN','il '||DECODE (ana.anno_mat,'S','00/00/'
                                          ||TO_CHAR(TO_DATE(ana.data_mat,'j'),'yyyy'),
                                 TO_CHAR(TO_DATE (ana.data_mat,'j'),'dd/mm/yyyy'))||' a '|| 
             c.descrizione||' '||f_provincia_stato (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'),
               'VE','dal '||TO_CHAR(TO_DATE (ana.data_ved,'j'),'dd/mm/yyyy')|| ' a '
                  ||d.descrizione||' '||f_provincia_stato (d.cod_provincia, d.cod_comune, d.sigla_provincia,'S','S'),
               ''),
-- comune provenienza    
    to_char(null),
-- data_decorrenza
   to_char(to_date(nvl(cre.data_decorrenza,tpr.data_pratica),'j'),'dd/mm/yyyy'),
-- 
       m.cod_provincia, m.cod_comune,
       to_number(null), to_number(null),
       to_number(null), to_number(null),
       ana.cod_pro_nas, ana.cod_com_nas
  from (select anno_pratica, pratica, count(*) familiari
        from anacrm 
       where flag_annullamento     is null
         and flag_soggetto        = 'S'
       group by anno_pratica, pratica) crm_v,
     arcinp ainp,
     arccom a, arccom a1, arccom m, arccom c, arccom d, arccom com_DI, 
     arcvie avie, arcvie bvie,
     anadrp drp, anadci dci, anadsc dsc, anadce dce,
     anadts dts, anadts dts_d,
     anadpr dpr,anadpr dpr_d,
     anadoc doc_PT, anadoc doc_CC, anadoc doc_DI,
     arcvie vie_11, anaeve eve_11,
     anafam fam_prov, anafam fam_dest, anaana ana, 
     anaana ana_dic,
     anacre cre, anacrm crm, anatpr tpr
 where ainp.parametro        = 'INTERNO'
   and avie.cod_via         (+) = fam_prov.cod_via
   and bvie.cod_via         (+) = cre.cod_via
   and a.cod_provincia      (+) = ana.cod_pro_nas
   and a.cod_comune         (+) = ana.cod_com_nas
   and a1.cod_provincia     (+) = ana.cod_pro_atto_nas
   and a1.cod_comune        (+) = ana.cod_com_atto_nas
   and c.cod_provincia(+) = ana.cod_pro_mat
   and c.cod_comune(+) = ana.cod_com_mat
   and d.cod_provincia(+) = ana.cod_pro_ved
   and d.cod_comune(+) = ana.cod_com_ved          
   and (m.cod_provincia, m.cod_comune) =  (select pro_cliente, com_cliente
                                             from menuditta)
   and dci.cod_ci           (+) = ana.nazionalita
   and drp.cod_rp               = nvl(crm.nuovo_rapporto_par,ana.rapporto_par)
   and drp.sesso                = ana.sesso
   and dsc.cod_sc               = ana.stato_civile
   and dsc.sesso                = ana.sesso
   and crm_v.pratica            = tpr.pratica
   and crm_v.anno_pratica       = tpr.anno_pratica
   and dts.cod_ts               (+) = ana.titolo_studio
   and dts_d.cod_ts             (+) = ana_dic.titolo_studio
   and doc_CC.natura_documento  (+) != 'A'
   and doc_CC.progr_documento   (+) = 1
   and doc_CC.tipo_documento    (+) = 'CC'
   and doc_CC.matricola         (+) = crm.matricola
   and doc_PT.natura_documento  (+) != 'A'
   and doc_PT.progr_documento   (+) = 1
   and doc_PT.tipo_documento    (+) = 'PT'
   and doc_PT.matricola         (+) = crm.matricola
   and com_DI.cod_provincia     (+) = doc_DI.cod_pro_ente
   and com_DI.cod_comune        (+) = doc_DI.cod_com_ente
   and doc_DI.progr_documento   (+) = 1
   and doc_DI.tipo_documento    (+) = f_get_campo_DI(tpr.matricola_dic,'TIPO_DOCUMENTO')
   and doc_DI.matricola         (+) = tpr.matricola_dic
   and vie_11.cod_via           (+) = eve_11.cod_via
   and eve_11.matricola         (+) = crm.matricola
   and eve_11.cod_mov           (+) = 11
   and eve_11.anno_pratica      (+) = crm.anno_pratica
   and eve_11.pratica           (+) = crm.pratica
   and dce.anagrafe                 = tpr.anagrafe
   and dce.tipo_evento              = tpr.tipo_evento
   and dce.flag_tpr                 = 'S'
   and nvl(dce.tipo_evento_tpr,' ') = nvl(tpr.cod_variazione,' ')
   and fam_dest.cod_fam         (+) = cre.cod_fam_dest
   and fam_dest.fascia          (+) = 1
   and fam_prov.cod_fam         (+) = cre.cod_fam_prov
   and fam_prov.fascia          (+) = 1
   and dpr_d.cod_pr               (+) = ana_dic.cod_prof
   and dpr_d.sesso                (+) = ana_dic.sesso
   and ana_dic.matricola         (+)   = tpr.matricola_dic
   and dpr.cod_pr               (+) = ana.cod_prof
   and dpr.sesso                (+) = ana.sesso
   and ana.matricola                = crm.matricola
   and crm.anno_pratica             = cre.anno_pratica
   and crm.pratica                  = cre.pratica
   and cre.anno_pratica             = tpr.anno_pratica
   and cre.pratica                  = tpr.pratica
   and tpr.anagrafe                 = 'RES'
   and tpr.tipo_evento              = 'E'
UNION
--
-- cancellazione apr (esclusa emigrazione aire)
--
select tpr.anagrafe, tpr.tipo_evento,
     tpr.anno_pratica, tpr.pratica, 
     to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- anno_dic, numero_dic
     cp4.anno_dic, cp4.numero_dic,
-- tipo_pratica
     'Cancellazione Anagrafica _____________ vedi punto B',
-- cognome_nome_dichiarante
     translate(ana_dic.cognome_nome,'/',' '),
-- cod_fiscale_dichiarante
     ana_dic.cod_fiscale,
-- riga_trasferimento_1
     to_char(null),
-- riga_trasferimento_2
     to_char(null),
-- riga_trasferimento_3
     to_char(null),
-- riga_trasferimento_4
     to_char(null),
-- cognome_nome
     translate(ana.cognome_nome,'/',' '),
-- cognome
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
-- nome
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),
-- sesso
     ana.sesso,
-- paternita
       'pt. '||translate(ana.paternita,'/',' '),
-- maternita
       'mt. '||translate(ana.maternita,'/',' '),
-- nat_oa
       decode(ana.sesso,'M','nato','nata'),
-- data_nascita
     decode(ana.anno_nas,'S',
       '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
-- comune_nascita
     nvl(a.descrizione_al1,a.descrizione)||' '||
       f_provincia_stato_CER(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
    a1.descrizione||decode(a1.sigla_provincia,'','',' ('||a1.sigla_provincia||')'),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '||ana.atto_nas||
           ' p. '||decode(ana.parte_nas,1,'I',2,'II')||
           decode(ana.serie_nas,'','',' s. '||ana.serie_nas)||
           decode(ana.ufficio_nas,0,'','','',' - '||ana.ufficio_nas)||
           ' / '||ana.anno_atto_nas,
         'atto digitale N. '||ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,
-- coniugat_oa
       decode(ana.stato_civile,'CN',
       decode(ana.sesso,'M','coniugato','coniugata'),''),
-- cognome_nome_coniuge
     decode(ana.stato_civile,
         'CN',translate(ana.cognome_nome_cn,'/',' '),
         'VE',translate(ana.cognome_nome_cn,'/',' '),''),
-- cittadinanza
     dci.descrizione, 
-- cod_fiscale
--     decode(ana.cod_fiscale,'',to_char(null),
--       decode(ana.cf_calcolato,'',ana.cod_fiscale,to_char(null))),
     ana.cod_fiscale,
-- rapporto_parentela
       drp.descrizione,
-- sequenza_par
       ana.sequenza_par,
-- residenza
     m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')'),
-- indirizzo
       avie.denom_uff||fam.civico_esterno||fam.civico_interno,
-- cap_comune_residenza
     lpad(m.cap,5,'0'),
-- residenza_fam
       decode(ana.fascia,
       1,'Residente a '||m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')')||' '||
             decode(ana.stato,1,'dalla nascita',
                        'dal '||to_char(to_date(ana.data_ult_eve,'j'),'dd/mm/yyyy'))),
-- indirizzo_fam
     'abitante in '||
       decode(ana.fascia,1,
         avie.denom_uff||fam.civico_esterno,
         fam.via_aire),
-- indirizzo_dichiarato
     decode(tpr.cod_variazione,'M',
       'CANC. PER MANCATO RINNOVO PERMESSO DI SOGGIORNO',
       decode(cp4.indirizzo_emi,'','',cp4.indirizzo_emi||' - ')||
         b.descrizione||' ('||b.sigla_provincia||')'),
-- comune_dichiarato
     b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),
-- numero_carta_dichiarante
    doc_DI.numero||decode(doc_di.numero,null,'',' - '||com_DI.descrizione||' ('||com_DI.sigla_provincia||')'),
-- data_carta_dichiarante
    to_char(to_date(doc_DI.data_emissione,'j'),'dd/mm/yyyy'),
-- comune_data
     m.descrizione||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
     m.descrizione,
-- data
     to_char(sysdate,'dd/mm/yyyy'),
-- matricola
     cpm.matricola, 
-- fascia
     ana.fascia,
-- cod_fam
     cp4.cod_fam_prov,
-- flag_pt
     decode(doc_PT.matricola,'',to_char(null),'S'),
-- flag_cc
     decode(doc_CC.matricola,'',to_char(null),'S'),
-- flag_soggetto
       cpm.flag_soggetto,
-- flag_annullamento
       cpm.annullamento,
-- data_nas : per order by
     ana.data_nas,
-- matricola_dichiarante
     cp4.matricola_dic,
-- sesso_dichiarante
     ana_dic.sesso,
-- descrizione_evento
     dce.des_evento_tpr,
-- professione  
     dpr.descrizione,
-- professione_dichiarante
     dpr_d.descrizione,
-- titolo_studio
     dts.descrizione,
-- titolo_sudio_dichiarante
     dts_d.descrizione,
--  numero_patente
     doc_pt.numero,
--estremi_mat_ved
     DECODE (ana.stato_civile,'CN','il '||DECODE (ana.anno_mat,'S','00/00/'
                                          ||TO_CHAR(TO_DATE(ana.data_mat,'j'),'yyyy'),
                                 TO_CHAR(TO_DATE (ana.data_mat,'j'),'dd/mm/yyyy'))||' a '|| 
             c.descrizione||' '||f_provincia_stato (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'),
               'VE','dal '||TO_CHAR(TO_DATE (ana.data_ved,'j'),'dd/mm/yyyy')|| ' a '
                  ||d.descrizione||' '||f_provincia_stato (d.cod_provincia, d.cod_comune, d.sigla_provincia,'S','S'),
               ''),
-- comune_provenienza
     to_char(null),
-- data decorrenza     
     to_char(to_date(nvl(cp4.data_decorrenza,tpr.data_pratica),'j'),'dd/mm/yyyy'),
-- 
       cp4.cod_pro_eve, cp4.cod_com_eve,
       to_number(null), to_number(null),
       to_number(null), to_number(null),
       ana.cod_pro_nas, ana.cod_com_nas
  from arcinp ainp,
     arccom a, arccom a1, arccom m, arccom b, arccom c, arccom d,arccom com_DI,
     arcvie avie, 
     anadrp drp, anadci dci, anadsc dsc, anadce dce,
     anadpr dpr, anadpr dpr_d, anadts dts, anadts dts_d,
     anadoc doc_PT, anadoc doc_CC, anadoc doc_DI,
     anafam fam, anaana ana, anaana ana_dic,
     anacp4 cp4, anacpm cpm, anatpr tpr
 where ainp.parametro           = 'INTERNO'
   and avie.cod_via             (+)    = fam.cod_via
   and a.cod_provincia          (+)    = ana.cod_pro_nas
   and a.cod_comune             (+)    = ana.cod_com_nas
   and a1.cod_provincia         (+)    = ana.cod_pro_atto_nas
   and a1.cod_comune            (+)    = ana.cod_com_atto_nas
   and c.cod_provincia(+) = ana.cod_pro_mat
   and c.cod_comune(+) = ana.cod_com_mat
   and d.cod_provincia(+) = ana.cod_pro_ved
   and d.cod_comune(+) = ana.cod_com_ved          
   and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente
                                            from menuditta)
   and b.cod_provincia          (+)    = cp4.cod_pro_eve
   and b.cod_comune             (+)    = cp4.cod_com_eve
   and dci.cod_ci               (+)    = ana.nazionalita
   and drp.cod_rp                      = ana.rapporto_par
   and drp.sesso                       = ana.sesso
   and dsc.cod_sc                      = ana.stato_civile
   and dsc.sesso                       = ana.sesso
   and dce.anagrafe                    = tpr.anagrafe
   and dce.tipo_evento                 = tpr.tipo_evento
   and dce.flag_tpr                    = 'S'
   and nvl(dce.tipo_evento_tpr,' ')    = nvl(tpr.cod_variazione,' ')
   and doc_CC.natura_documento  (+)    != 'A'
   and doc_CC.progr_documento   (+)    = 1
   and doc_CC.tipo_documento    (+)    = 'CC'
   and doc_CC.matricola         (+)    = cpm.matricola
   and doc_PT.natura_documento  (+)    != 'A'
   and doc_PT.progr_documento   (+)    = 1
   and doc_PT.tipo_documento    (+)    = 'PT'
   and doc_PT.matricola         (+)    = cpm.matricola
   and com_DI.cod_provincia     (+)    = doc_DI.cod_pro_ente
   and com_DI.cod_comune        (+)    = doc_DI.cod_com_ente
   and doc_DI.progr_documento   (+)    = 1
   and doc_DI.tipo_documento    (+)    = f_get_campo_DI(tpr.matricola_dic,'TIPO_DOCUMENTO')
   and doc_DI.matricola         (+)    = tpr.matricola_dic
   and dts.cod_ts               (+)    = ana.titolo_studio
   and dts_d.cod_ts             (+)    = ana_dic.titolo_studio
   and dpr_d.cod_pr             (+)    = ana_dic.cod_prof
   and dpr_d.sesso              (+)    = ana_dic.sesso
   and ana_dic.matricola        (+)       = cp4.matricola_dic
   and dpr.cod_pr               (+)    = ana.cod_prof
   and dpr.sesso                (+)    = ana.sesso
   and fam.cod_fam              (+)    = cp4.cod_fam_prov
   and fam.fascia               (+)    = 1
   and ana.matricola                   = cpm.matricola
   and cpm.anno_dic                    = cp4.anno_dic
   and cpm.numero_dic                  = cp4.numero_dic
   and cp4.anno_pratica                = tpr.anno_pratica
   and cp4.pratica                     = tpr.pratica
   and tpr.cod_variazione              != 'A'
   and tpr.anagrafe                    = 'RES'
   and tpr.tipo_evento                 = 'C'
UNION
--
-- cancellazione apr x emigrazione aire
--
select tpr.anagrafe, tpr.tipo_evento,
     tpr.anno_pratica, tpr.pratica, 
     to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- anno_dic, numero_dic
     tpr.anno_pratica, tpr.pratica, 
-- tipo_pratica
     'Cancellazione Anagrafica _____________ vedi punto B',
-- cognome_nome_dichiarante
     translate(tpr.cognome_nome_dic,'/',' '),
-- cod_fiscale_dichiarante
     ana_dic.cod_fiscale,
-- riga_trasferimento_1
     to_char(null),
-- riga_trasferimento_2
     to_char(null),
-- riga_trasferimento_3
     to_char(null),
-- riga_trasferimento_4
     to_char(null),
-- cognome_nome
     translate(ana.cognome_nome,'/',' '),
-- cognome
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
-- nome
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),
-- sesso
     ana.sesso,
-- paternita
       'pt. '||translate(ana.paternita,'/',' '),
-- maternita
       'mt. '||translate(ana.maternita,'/',' '),
-- nat_oa
       decode(ana.sesso,'M','nato','nata'),
-- data_nascita
     decode(ana.anno_nas,'S',
       '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
-- comune_nascita
     nvl(a.descrizione_al1,a.descrizione)||' '||
       f_provincia_stato_CER(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
    a1.descrizione||decode(a1.sigla_provincia,'','',' ('||a1.sigla_provincia||')'),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '||ana.atto_nas||
           ' p. '||decode(ana.parte_nas,1,'I',2,'II')||
           decode(ana.serie_nas,'','',' s. '||ana.serie_nas)||
           decode(ana.ufficio_nas,0,'','','',' - '||ana.ufficio_nas)||
           ' / '||ana.anno_atto_nas,
         'atto digitale N. '||ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,
-- coniugat_oa
       decode(ana.stato_civile,'CN',
       decode(ana.sesso,'M','coniugato','coniugata'),''),
-- cognome_nome_coniuge
     decode(ana.stato_civile,
         'CN',translate(ana.cognome_nome_cn,'/',' '),
         'VE',translate(ana.cognome_nome_cn,'/',' '),''),
-- cittadinanza
     dci.descrizione, 
-- cod_fiscale
--     decode(ana.cod_fiscale,'',to_char(null),
--       decode(ana.cf_calcolato,'',ana.cod_fiscale,to_char(null))),
     ana.cod_fiscale,
-- rapporto_parentela
       drp.descrizione,
-- sequenza_par
       ana.sequenza_par,
-- residenza
     m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')'),
-- indirizzo
       avie.denom_uff||fam.civico_esterno||fam.civico_interno,
-- cap_comune_residenza
     lpad(m.cap,5,'0'),
-- residenza_fam
       decode(ana.fascia,
       1,'Residente a '||m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')')||' '||
             decode(ana.stato,1,'dalla nascita',
                        'dal '||to_char(to_date(ana.data_ult_eve,'j'),'dd/mm/yyyy'))),
-- indirizzo_fam
     'abitante in '||
       decode(ana.fascia,1,
         avie.denom_uff||fam.civico_esterno,
         fam.via_aire),
-- indirizzo_dichiarato
     a01.via_aire||decode(a01.zipcode,'','',' - '||a01.zipcode)||
       ' - '||b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),
-- comune_dichiarato
     b.descrizione||' ('||b.sigla_provincia||')',
-- numero_carta_dichiarante
    doc_DI.numero||decode(doc_di.numero,null,'',' - '||com_DI.descrizione||' ('||com_DI.sigla_provincia||')'),
-- data_carta_dichiarante
    to_char(to_date(doc_DI.data_emissione,'j'),'dd/mm/yyyy'),
-- comune_data
     m.descrizione||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
     m.descrizione,
-- data
     to_char(sysdate,'dd/mm/yyyy'),
-- matricola
     a0m.matricola, 
-- fascia
     ana.fascia,
-- cod_fam
     a01.cod_fam_prov,
-- flag_pt
     decode(doc_PT.matricola,'',to_char(null),'S'),
-- flag_cc
     decode(doc_CC.matricola,'',to_char(null),'S'),
-- flag_soggetto
       a0m.flag_soggetto,
-- flag_annullamento
       a0m.flag_annullamento,
-- data_nas : per order by
     ana.data_nas,
-- matricola_dichiarante
     tpr.matricola_dic,
-- sesso_dichiarante
     ana_dic.sesso,
-- descrizione_evento
     dce.des_evento_tpr,
-- professione  
     dpr.descrizione,
-- professione_dichiarante
     dpr_d.descrizione,
-- titolo_studio
     dts.descrizione,
-- titolo_sudio_dichiarante
     dts_d.descrizione ,
--  numero_patente
     doc_pt.numero,
--estremi_mat_ved
     DECODE (ana.stato_civile,'CN','il '||DECODE (ana.anno_mat,'S','00/00/'
                                          ||TO_CHAR(TO_DATE(ana.data_mat,'j'),'yyyy'),
                                 TO_CHAR(TO_DATE (ana.data_mat,'j'),'dd/mm/yyyy'))||' a '|| 
             c.descrizione||' '||f_provincia_stato (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'),
               'VE','dal '||TO_CHAR(TO_DATE (ana.data_ved,'j'),'dd/mm/yyyy')|| ' a '
                  ||d.descrizione||' '||f_provincia_stato (d.cod_provincia, d.cod_comune, d.sigla_provincia,'S','S'),
               ''),
-- comune provenienza
    to_char(null),
-- data_decorrenza
    to_char(to_date(nvl(a01.data_decorrenza,tpr.data_pratica),'j'),'dd/mm/yyyy'),
-- 
       a01.cod_pro_aire, a01.cod_com_aire,
       a01.cod_pro_aire, a01.cod_com_aire,
       to_number(null), to_number(null),
       ana.cod_pro_nas, ana.cod_com_nas
  from arcinp ainp,
     arccom a, arccom a1, arccom m, arccom b, arccom c, arccom d, arccom com_DI,
     arcvie avie, 
     anadrp drp, anadci dci, anadsc dsc,anadce dce,
     anadpr dpr, anadpr dpr_d, anadts dts, anadts dts_d,
     anadoc doc_PT, anadoc doc_CC, anadoc doc_DI,
     anafam fam, anaana ana, anaana ana_dic,
     anaa01 a01, anaa0m a0m, anatpr tpr
 where ainp.parametro        = 'INTERNO'
   and avie.cod_via    (+)    = fam.cod_via
   and a.cod_provincia    (+)    = ana.cod_pro_nas
   and a.cod_comune    (+)    = ana.cod_com_nas
   and a1.cod_provincia    (+)    = ana.cod_pro_atto_nas
   and a1.cod_comune    (+)    = ana.cod_com_atto_nas
   and c.cod_provincia(+) = ana.cod_pro_mat
   and c.cod_comune(+) = ana.cod_com_mat
   and d.cod_provincia(+) = ana.cod_pro_ved
   and d.cod_comune(+) = ana.cod_com_ved          
   and (m.cod_provincia, m.cod_comune) = 
     (select pro_cliente, com_cliente
        from menuditta)
   and b.cod_provincia    (+)    = a01.cod_pro_aire
   and b.cod_comune    (+)    = a01.cod_com_aire
   and dci.cod_ci        (+)    = ana.nazionalita
   and drp.cod_rp            = ana.rapporto_par
   and drp.sesso            = ana.sesso
   and dsc.cod_sc            = ana.stato_civile
   and dsc.sesso            = ana.sesso
   and doc_CC.natura_documento    (+)    != 'A'
   and doc_CC.progr_documento    (+)    = 1
   and doc_CC.tipo_documento    (+)    = 'CC'
   and doc_CC.matricola        (+)    = a0m.matricola
   and doc_PT.natura_documento    (+)    != 'A'
   and doc_PT.progr_documento    (+)    = 1
   and doc_PT.tipo_documento    (+)    = 'PT'
   and doc_PT.matricola        (+)    = a0m.matricola
   and com_DI.cod_provincia    (+)    = doc_DI.cod_pro_ente
   and com_DI.cod_comune    (+)    = doc_DI.cod_com_ente
   and doc_DI.progr_documento    (+)    = 1
   and doc_DI.tipo_documento    (+)    = f_get_campo_DI(tpr.matricola_dic,'TIPO_DOCUMENTO')
   and doc_DI.matricola        (+)    = tpr.matricola_dic
   and dce.anagrafe                    = tpr.anagrafe
   and dce.tipo_evento                 = tpr.tipo_evento
   and dce.flag_tpr                    = 'S'
   and nvl(dce.tipo_evento_tpr,' ')    = nvl(tpr.cod_variazione,' ')
   and dts.cod_ts               (+)    = ana.titolo_studio
   and dts_d.cod_ts             (+)    = ana_dic.titolo_studio
   and dpr_d.cod_pr             (+)    = ana_dic.cod_prof
   and dpr_d.sesso              (+)    = ana_dic.sesso
   and ana_dic.matricola        (+)       = tpr.matricola_dic
   and dpr.cod_pr               (+)    = ana.cod_prof
   and dpr.sesso                (+)    = ana.sesso
   and fam.cod_fam              (+)    = a01.cod_fam_prov
   and fam.fascia               (+)    = 1
   and ana.matricola        = a0m.matricola
   and a0m.anno_pratica        = a01.anno_pratica
   and a0m.pratica        = a01.pratica
   and a01.anno_pratica        = tpr.anno_pratica
   and a01.pratica        = tpr.pratica
   and tpr.cod_variazione    = 'A'
   and tpr.anagrafe        = 'RES'
   and tpr.tipo_evento        = 'C'
UNION
--
-- iscrizioni apr (esclusa immigrazione da aire)
--
select tpr.anagrafe, tpr.tipo_evento,
     tpr.anno_pratica, tpr.pratica, 
     to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- anno_dic, numero_dic
     ap4.anno_dic, ap4.numero_dic,
-- tipo_pratica
     'Iscrizione Anagrafica ________________ vedi punto A',
-- cognome_nome_dichiarante
     translate(tpr.cognome_nome_dic,'/',' '),
-- cod_fiscale_dichiarante
     ana_dic.cod_fiscale,
-- riga_trasferimento_1
     to_char(null),
-- riga_trasferimento_2
     to_char(null),
-- riga_trasferimento_3
     decode(ap4.flag_aggregazione,'S',
       decode(fam_dest.tipo_fam,1,
        'presso la convivenza anagrafica:',
        'presso '||nvl(translate(fam_dest.intestatario,'/',' '),ap4.presso))),
-- riga_trasferimento_4
     decode(ap4.flag_aggregazione,'S',
        decode(fam_dest.tipo_fam,1,fam_dest.convivenza,'')),
-- cognome_nome
     translate(ana.cognome_nome,'/',' '),
-- cognome
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
-- nome
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),
-- sesso
     ana.sesso,
-- paternita
       'pt. '||translate(ana.paternita,'/',' '),
-- maternita
       'mt. '||translate(ana.maternita,'/',' '),
-- nat_oa
       decode(ana.sesso,'M','nato','nata'),
-- data_nascita
     decode(ana.anno_nas,'S',
       '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
-- comune_nascita
     nvl(a.descrizione_al1,a.descrizione)||' '||
       f_provincia_stato_CER(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
    a1.descrizione||decode(a1.sigla_provincia,'','',' ('||a1.sigla_provincia||')'),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '||ana.atto_nas|| 
           ' p. '||decode(ana.parte_nas,1,'I',2,'II')||
           decode(ana.serie_nas,'','',' s. '||ana.serie_nas)||
           decode(ana.ufficio_nas,0,'','','',' - '||ana.ufficio_nas)||
           ' / '||ana.anno_atto_nas,
         'atto digitale N. '||ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,
-- coniugat_oa
       decode(ana.stato_civile,'CN',
       decode(ana.sesso,'M','coniugato','coniugata'),''),
-- cognome_nome_coniuge
     decode(ana.stato_civile,
         'CN',translate(ana.cognome_nome_cn,'/',' '),
         'VE',translate(ana.cognome_nome_cn,'/',' '),''),
-- cittadinanza
     dci.descrizione, 
-- cod_fiscale
--     decode(ana.cod_fiscale,'',to_char(null),
--       decode(ana.cf_calcolato,'',ana.cod_fiscale,to_char(null))),
     ana.cod_fiscale,
-- rapporto_parentela
       drp.descrizione,
-- sequenza_par
       apm.nuova_sequenza_par,
-- residenza
     m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')'),
-- indirizzo
     null,
-- cap_comune_residenza
     lpad(m.cap,5,'0'),
-- residenza_fam
       to_char(null),
-- indirizzo_fam
     to_char(null),
-- indirizzo_dichiarato
       bvie.denom_uff||ap4.civico_esterno||ap4.civico_interno,
-- comune_dichiarato
     decode(b.descrizione,'',
       f.descrizione||decode(f.sigla_provincia,'','',' ('||f.sigla_provincia||')'),       
       b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')')),
-- numero_carta_dichiarante
    doc_DI.numero||decode(doc_di.numero,null,'',' - '||com_DI.descrizione||' ('||com_DI.sigla_provincia||')'),
-- data_carta_dichiarante
    to_char(to_date(doc_DI.data_emissione,'j'),'dd/mm/yyyy'),
-- comune_data
     m.descrizione||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
     m.descrizione,
-- data
     to_char(sysdate,'dd/mm/yyyy'),
-- matricola
     apm.matricola, 
-- fascia
     to_number(null),
-- cod_fam
     to_number(null),
-- flag_pt
     decode(doc_PT.matricola,'',to_char(null),'S'),
-- flag_cc
     decode(doc_CC.matricola,'',to_char(null),'S'),
-- flag_soggetto
       apm.flag_soggetto,
-- flag_annullamento
       apm.annullamento,
-- data_nas : per order by
     ana.data_nas,
-- matricola_dichiarante
     tpr.matricola_dic,
-- sesso_dichiarante
     ana_dic.sesso,
-- descrizione_evento
     dce.des_evento_tpr,
-- professione  
--     dnp.descrizione,
     dpr.descrizione,
-- professione_dichiarante
     dpr_d.descrizione,
-- titolo_studio
      dti.descrizione,--dts.descrizione,
-- titolo_sudio_dichiarante
     dts_d.descrizione,
--  numero_patente
     doc_pt.numero,
--estremi_mat_ved
     DECODE (ana.stato_civile,'CN','il '||DECODE (ana.anno_mat,'S','00/00/'
                                          ||TO_CHAR(TO_DATE(ana.data_mat,'j'),'yyyy'),
                                 TO_CHAR(TO_DATE (ana.data_mat,'j'),'dd/mm/yyyy'))||' a '|| 
             c.descrizione||' '||f_provincia_stato (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'),
               'VE','dal '||TO_CHAR(TO_DATE (ana.data_ved,'j'),'dd/mm/yyyy')|| ' a '
                  ||d.descrizione||' '||f_provincia_stato (d.cod_provincia, d.cod_comune, d.sigla_provincia,'S','S'),
               ''),
-- comune_provenienza
   f.descrizione||decode(f.sigla_provincia,'','',' ('||f.sigla_provincia||')'),
-- data_decorrenza
   to_char(to_date(ap4.data_decorrenza,'j'),'dd/mm/yyyy'),
-- 
       nvl(ap4.cod_pro_iscr_aire,ap4.cod_pro_eve),
       nvl(ap4.cod_com_iscr_aire,ap4.cod_com_eve),
       decode(ap4.cod_pro_iscr_aire,'',to_number(null),ap4.cod_pro_eve),
       decode(ap4.cod_pro_iscr_aire,'',to_number(null),ap4.cod_com_eve),
       to_number(null), to_number(null),
       ana.cod_pro_nas, ana.cod_com_nas
  from arcinp ainp,
     arccom a, arccom a1, arccom m, arccom b, arccom c, arccom d, arccom f, arccom com_DI,
     arcvie bvie, 
     anadrp drp, anadci dci, anadsc dsc,anadce dce,
     anadpr dpr, anadpr dpr_d, anadts dts, anadts dts_d,
     anadti dti, anadnp dnp,
     anadoc doc_PT, anadoc doc_CC, anadoc doc_DI, 
     anafam fam_dest, anaana ana, anaana ana_dic,
     anaap4 ap4, anaapm apm, anatpr tpr
 where ainp.parametro        = 'INTERNO'
   and bvie.cod_via    (+)    = ap4.cod_via
   and a.cod_provincia    (+)    = ana.cod_pro_nas
   and a.cod_comune    (+)    = ana.cod_com_nas
   and a1.cod_provincia    (+)    = ana.cod_pro_atto_nas
   and a1.cod_comune    (+)    = ana.cod_com_atto_nas
   and c.cod_provincia(+) = ana.cod_pro_mat
   and c.cod_comune(+) = ana.cod_com_mat
   and d.cod_provincia(+) = ana.cod_pro_ved
   and d.cod_comune(+) = ana.cod_com_ved
   and f.cod_provincia(+) = ap4.cod_pro_eve
   and f.cod_comune(+) = ap4.cod_com_eve          
   and (m.cod_provincia, m.cod_comune) = 
     (select pro_cliente, com_cliente
        from menuditta)
   and b.cod_provincia    (+)    = ap4.cod_pro_iscr_aire
   and b.cod_comune    (+)    = ap4.cod_com_iscr_aire
   and dci.cod_ci        (+)    = ana.nazionalita
   and drp.cod_rp            = apm.nuovo_rapporto_par
   and drp.sesso            = apm.sesso
   and dsc.cod_sc            = ana.stato_civile
   and dsc.sesso            = ana.sesso
   and doc_CC.natura_documento    (+)    != 'A'
   and doc_CC.progr_documento    (+)    = 1
   and doc_CC.tipo_documento    (+)    = 'CC'
   and doc_CC.matricola        (+)    = apm.matricola
   and doc_PT.natura_documento    (+)    != 'A'
   and doc_PT.progr_documento    (+)    = 1
   and doc_PT.tipo_documento    (+)    = 'PT'
   and doc_PT.matricola        (+)    = apm.matricola
   and com_DI.cod_provincia    (+)    = doc_DI.cod_pro_ente
   and com_DI.cod_comune    (+)    = doc_DI.cod_com_ente
   and doc_DI.progr_documento    (+)    = 1
   and doc_DI.tipo_documento    (+)    = f_get_campo_DI(tpr.matricola_dic,'TIPO_DOCUMENTO')
   and doc_DI.matricola        (+)    = tpr.matricola_dic
   and dce.anagrafe                    = tpr.anagrafe
   and dce.tipo_evento                 = tpr.tipo_evento
   and dce.flag_tpr                    = 'S'
   and nvl(dce.tipo_evento_tpr,' ')    = nvl(tpr.cod_variazione,' ')
   and dts.cod_ts               (+)    = ana.titolo_studio
   and dts_d.cod_ts             (+)    = ana_dic.titolo_studio
   and dpr_d.cod_pr             (+)    = ana_dic.cod_prof
   and dpr_d.sesso              (+)    = ana_dic.sesso
   and ana_dic.matricola        (+)       = tpr.matricola_dic
   and dpr.cod_pr               (+)    = ana.cod_prof
   and dpr.sesso                (+)    = ana.sesso
   and dti.ist_ts               (+)    = apm.ist_ts
   and dnp.ist_np               (+)    = apm.ist_np
   and dnp.sesso                (+)    = apm.sesso
   and fam_dest.cod_fam        (+)    = ap4.cod_fam_dest
   and fam_dest.fascia        (+)    = 1
   and ana.matricola        = apm.matricola
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic        = ap4.numero_dic
   and ap4.anno_dic        = tpr.anno_pratica
   and ap4.numero_dic        = tpr.pratica
   and tpr.cod_variazione    != 'A'
   and tpr.anagrafe        = 'RES'
   and tpr.tipo_evento        = 'I'
UNION
--
-- iscrizioni apr x immigrazione da aire
--
select tpr.anagrafe, tpr.tipo_evento,
     tpr.anno_pratica, tpr.pratica, 
     to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- anno_dic, numero_dic
     ap4.anno_dic, ap4.numero_dic,
-- tipo_pratica
     'Iscrizione Anagrafica ________________ vedi punto A',
-- cognome_nome_dichiarante
     translate(tpr.cognome_nome_dic,'/',' '),
-- cod_fiscale_dichiarante
     ana_dic.cod_fiscale,
-- riga_trasferimento_1
     to_char(null),
-- riga_trasferimento_2
     to_char(null),
-- riga_trasferimento_3
     decode(ap4.flag_aggregazione,'S',
       decode(fam_dest.tipo_fam,1,
        'presso la convivenza anagrafica:',
        'presso '||nvl(translate(fam_dest.intestatario,'/',' '),ap4.presso))),
-- riga_trasferimento_4
     decode(ap4.flag_aggregazione,'S',
        decode(fam_dest.tipo_fam,1,fam_dest.convivenza,'')),
-- cognome_nome
     translate(ana.cognome_nome,'/',' '),
-- cognome
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
-- nome
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),
-- sesso
     ana.sesso,
-- paternita
       'pt. '||translate(ana.paternita,'/',' '),
-- maternita
       'mt. '||translate(ana.maternita,'/',' '),
-- nat_oa
       decode(ana.sesso,'M','nato','nata'),
-- data_nascita
     decode(ana.anno_nas,'S',
       '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
-- comune_nascita
     nvl(a.descrizione_al1,a.descrizione)||' '||
       f_provincia_stato_CER(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
    a1.descrizione||decode(a1.sigla_provincia,'','',' ('||a1.sigla_provincia||')'),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '||ana.atto_nas||
           ' p. '||decode(ana.parte_nas,1,'I',2,'II')||
           decode(ana.serie_nas,'','',' s. '||ana.serie_nas)||
           decode(ana.ufficio_nas,0,'','','',' - '||ana.ufficio_nas)||
           ' / '||ana.anno_atto_nas,
         'atto digitale N. '||ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,
-- coniugat_oa
       decode(ana.stato_civile,'CN',
       decode(ana.sesso,'M','coniugato','coniugata'),''),
-- cognome_nome_coniuge
     decode(ana.stato_civile,
         'CN',translate(ana.cognome_nome_cn,'/',' '),
         'VE',translate(ana.cognome_nome_cn,'/',' '),''),
-- cittadinanza
     dci.descrizione, 
-- cod_fiscale
--     decode(ana.cod_fiscale,'',to_char(null),
--       decode(ana.cf_calcolato,'',ana.cod_fiscale,to_char(null))),
     ana.cod_fiscale,
-- rapporto_parentela
       drp.descrizione,
-- sequenza_par
       apm.nuova_sequenza_par,
-- residenza
     m.descrizione||decode(a.sigla_provincia,'','',' ('||m.sigla_provincia||')'),
-- indirizzo
     null,
-- cap_comune_residenza
     lpad(m.cap,5,'0'),
-- residenza_fam
       to_char(null),
-- indirizzo_fam
     to_char(null),
-- indirizzo_dichiarato
       bvie.denom_uff||ap4.civico_esterno||ap4.civico_interno,
-- comune_dichiarato
     b.descrizione||' (A.I.R.E. di '||m.descrizione||')',
-- numero_carta_dichiarante
    doc_DI.numero||decode(doc_di.numero,null,'',' - '||com_DI.descrizione||' ('||com_DI.sigla_provincia||')'),
-- data_carta_dichiarante
    to_char(to_date(doc_DI.data_emissione,'j'),'dd/mm/yyyy'),
-- comune_data
     m.descrizione||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
     m.descrizione,
-- data
     to_char(sysdate,'dd/mm/yyyy'),
-- matricola
     apm.matricola, 
-- fascia
     to_number(null),
-- cod_fam
     to_number(null),
-- flag_pt
     decode(doc_PT.matricola,'',to_char(null),'S'),
-- flag_cc
     decode(doc_CC.matricola,'',to_char(null),'S'),
-- flag_soggetto
       apm.flag_soggetto,
-- flag_annullamento
       apm.annullamento,
-- data_nas : per order by
     ana.data_nas,
-- matricola_dichiarante
     tpr.matricola_dic,
-- sesso_dichiarante
     ana_dic.sesso,
-- descrizione_evento
     dce.des_evento_tpr,
-- professione  
--     dnp.descrizione,
     dpr.descrizione,
-- professione_dichiarante
     dpr_d.descrizione,
-- titolo_studio
      dti.descrizione,--dts.descrizione,
-- titolo_sudio_dichiarante
     dts_d.descrizione,
--  numero_patente
     doc_pt.numero,
--estremi_mat_ved
     DECODE (ana.stato_civile,'CN','il '||DECODE (ana.anno_mat,'S','00/00/'
                                          ||TO_CHAR(TO_DATE(ana.data_mat,'j'),'yyyy'),
                                 TO_CHAR(TO_DATE (ana.data_mat,'j'),'dd/mm/yyyy'))||' a '|| 
             c.descrizione||' '||f_provincia_stato (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'),
               'VE','dal '||TO_CHAR(TO_DATE (ana.data_ved,'j'),'dd/mm/yyyy')|| ' a '
                  ||d.descrizione||' '||f_provincia_stato (d.cod_provincia, d.cod_comune, d.sigla_provincia,'S','S'),
               ''),
-- comune provenienza
  f.descrizione||decode(f.sigla_provincia,'','',' ('||f.sigla_provincia||')'),
--data_decorrenza
  to_char(to_date(ap4.data_decorrenza,'j'),'dd/mm/yyyy'),
-- 
       ap4.cod_pro_eve, ap4.cod_com_eve,
       to_number(null), to_number(null),
       ap4.cod_pro_eve, ap4.cod_com_eve,
       ana.cod_pro_nas, ana.cod_com_nas
  from arcinp ainp,
     arccom a, arccom a1, arccom m,arccom f, 
     arccom b, arccom c, arccom d,arccom com_DI,
     arcvie bvie, 
     anadrp drp, anadci dci, anadsc dsc,anadce dce,
     anadti dti, anadnp dnp,anadpr dpr,anadpr dpr_d,anadts dts_d,
     anadoc doc_PT, anadoc doc_CC, anadoc doc_DI,
     anafam fam_dest, anaana ana, anaana ana_dic,
     anaap4 ap4, anaapm apm, anatpr tpr
 where ainp.parametro        = 'INTERNO'
   and bvie.cod_via    (+)    = ap4.cod_via
   and a.cod_provincia    (+)    = ana.cod_pro_nas
   and a.cod_comune    (+)    = ana.cod_com_nas
   and a1.cod_provincia    (+)    = ana.cod_pro_atto_nas
   and a1.cod_comune    (+)    = ana.cod_com_atto_nas
   and c.cod_provincia(+) = ana.cod_pro_mat
   and c.cod_comune(+) = ana.cod_com_mat
   and d.cod_provincia(+) = ana.cod_pro_ved
   and d.cod_comune(+) = ana.cod_com_ved
   and f.cod_provincia(+) = ap4.cod_pro_eve
   and f.cod_comune(+) = ap4.cod_com_eve         
   and (m.cod_provincia, m.cod_comune) = 
     (select pro_cliente, com_cliente
        from menuditta)
   and b.cod_provincia    (+)    = ap4.cod_stato
   and b.cod_comune    (+)    = 0
   and dci.cod_ci        (+)    = ana.nazionalita
   and drp.cod_rp            = nvl(apm.nuovo_rapporto_par,apm.rapporto_par_prec)
   and drp.sesso            = apm.sesso
   and dsc.cod_sc            = ana.stato_civile
   and dsc.sesso            = ana.sesso
   and doc_CC.natura_documento    (+)    != 'A'
   and doc_CC.progr_documento    (+)    = 1
   and doc_CC.tipo_documento    (+)    = 'CC'
   and doc_CC.matricola        (+)    = apm.matricola
   and doc_PT.natura_documento    (+)    != 'A'
   and doc_PT.progr_documento    (+)    = 1
   and doc_PT.tipo_documento    (+)    = 'PT'
   and doc_PT.matricola        (+)    = apm.matricola
   and com_DI.cod_provincia    (+)    = doc_DI.cod_pro_ente
   and com_DI.cod_comune    (+)    = doc_DI.cod_com_ente
   and doc_DI.progr_documento    (+)    = 1
   and doc_DI.tipo_documento    (+)    = f_get_campo_DI(tpr.matricola_dic,'TIPO_DOCUMENTO')
   and doc_DI.matricola        (+)    = tpr.matricola_dic
   and dce.anagrafe                    = tpr.anagrafe
   and dce.tipo_evento                 = tpr.tipo_evento
   and dce.flag_tpr                    = 'S'
   and nvl(dce.tipo_evento_tpr,' ')    = nvl(tpr.cod_variazione,' ')
   and dts_d.cod_ts             (+)    = ana_dic.titolo_studio
   and dpr_d.cod_pr             (+)    = ana_dic.cod_prof
   and dpr_d.sesso              (+)    = ana_dic.sesso
   and dpr.cod_pr               (+)    = ana.cod_prof
   and dpr.sesso                (+)    = ana.sesso
   and ana_dic.matricola        (+)       = tpr.matricola_dic
   and dti.ist_ts               (+)    = apm.ist_ts
   and dnp.ist_np               (+)    = apm.ist_np
   and dnp.sesso                (+)    = apm.sesso
   and fam_dest.cod_fam        (+)    = ap4.cod_fam_dest
   and fam_dest.fascia        (+)    = 1
   and ana.matricola        = apm.matricola
   and apm.anno_dic        = ap4.anno_dic
   and apm.numero_dic        = ap4.numero_dic
   and ap4.anno_dic        = tpr.anno_pratica
   and ap4.numero_dic        = tpr.pratica
   and tpr.cod_variazione    = 'A'
   and tpr.anagrafe        = 'RES'
   and tpr.tipo_evento        = 'I'
UNION
--
-- Cancellazione AIRE 
--
select tpr.anagrafe, tpr.tipo_evento,
     tpr.anno_pratica, tpr.pratica,
     to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- anno_dic, numero_dic
     c01.anno_protocollo_aire, c01.protocollo_aire,
-- tipo_pratica
     'Cancellazione AIRE',
-- cognome_nome_dichiarante
     translate(tpr.cognome_nome_dic,'/',' '),
-- cod_fiscale_dichiarante
     ana_dic.cod_fiscale,
-- riga_trasferimento_1
     to_char(null),
-- riga_trasferimento_2
     to_char(null),    
-- riga_trasferimento_3
     to_char(null),    
-- riga_trasferimento_4
     to_char(null),    
-- cognome_nome
     translate(ana.cognome_nome,'/',' '),
-- cognome
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
-- nome
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),
-- sesso
     ana.sesso,
-- paternita
     decode(ana.paternita,'','','pt. '||translate(ana.paternita,'/',' ')),
-- maternita
     decode(ana.maternita,'','','mt. '||translate(ana.maternita,'/',' ')),
-- nat_oa
       decode(ana.sesso,'M','nato','nata'),
-- data_nascita
     decode(ana.anno_nas,'S',
       '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
-- comune_nascita
     nvl(a.descrizione_al1,a.descrizione)||' '||
       f_provincia_stato_CER(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
       decode(a1.descrizione,'','', a1.descrizione||' ('||a1.sigla_provincia||')'),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '||ana.atto_nas||
           ' p. '||decode(ana.parte_nas,1,'I',2,'II')||
           decode(ana.serie_nas,'','',' s. '||ana.serie_nas)||
           decode(ana.ufficio_nas,0,'','','',' - '||ana.ufficio_nas)||
           ' / '||ana.anno_atto_nas,
         'atto digitale N. '||ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,       
-- coniugat_oa
       decode(ana.stato_civile,'CN',
       decode(ana.sesso,'M','coniugato','coniugata'),''),
-- cognome_nome_coniuge
     decode(ana.stato_civile,
         'CN',translate(ana.cognome_nome_cn,'/',' '),
         'VE',translate(ana.cognome_nome_cn,'/',' '),''),  
-- cittadinanza
     dci.descrizione,               
-- cod_fiscale
--     decode(ana.cod_fiscale,'',to_char(null),
--       decode(ana.cf_calcolato,'',ana.cod_fiscale,to_char(null))),
     ana.cod_fiscale,
-- rapporto_parentela
       drp.descrizione,
-- sequenza_par
       ana.sequenza_par,     
-- residenza
     b.descrizione||' ('||b.sigla_provincia||')',
-- indirizzo
     fam.via_aire,
-- cap_comune_residenza
     lpad(b.cap,5,'0'),
-- residenza_fam
       decode(ana.fascia,
       3,'Residente a '||b.descrizione||' ('||b.sigla_provincia||')' ),
-- indirizzo_fam
     'abitante in '||fam.via_aire,
-- indirizzo_dichiarato
     c01.indirizzo_emi||decode(c.descrizione,'','',' - '||c.descrizione||' ('||c.sigla_provincia||')'),
-- comune_dichiarato
     c.descrizione||' ('||c.sigla_provincia||')',     
-- numero_carta_dichiarante
    doc_DI.numero||' - '||com_DI.descrizione||' ('||com_DI.sigla_provincia||')',
-- data_carta_dichiarante
    to_char(to_date(doc_DI.data_emissione,'j'),'dd/mm/yyyy'),
-- comune_data
     m.descrizione||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
     m.descrizione,
-- data
     to_char(sysdate,'dd/mm/yyyy'),        
-- matricola
     c0m.matricola, 
-- fascia
     ana.fascia,
-- cod_fam
     c01.cod_fam,
-- flag_pt
     decode(doc_PT.matricola,'',to_char(null),'S'),
-- flag_cc
     decode(doc_CC.matricola,'',to_char(null),'S'),     
-- flag_soggetto
       c0m.flag_soggetto,
-- flag_annullamento
       c0m.annullamento,
-- data_nas : per order by
     ana.data_nas,
-- matricola_dichiarante
     tpr.matricola_dic,
-- sesso_dichiarante
     ana_dic.sesso,
-- descrizione_evento
     dce.des_evento_tpr,
-- professione  
     dpr.descrizione,
-- professione_dichiarante
     dpr_d.descrizione,
-- titolo_studio
     dts.descrizione,
-- titolo_sudio_dichiarante
     dts_d.descrizione,
--  numero_patente
     doc_pt.numero,
--estremi_mat_ved
     DECODE (ana.stato_civile,'CN','il '||DECODE (ana.anno_mat,'S','00/00/'
                                          ||TO_CHAR(TO_DATE(ana.data_mat,'j'),'yyyy'),
                                 TO_CHAR(TO_DATE (ana.data_mat,'j'),'dd/mm/yyyy'))||' a '|| 
             e.descrizione||' '||f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S'),
               'VE','dal '||TO_CHAR(TO_DATE (ana.data_ved,'j'),'dd/mm/yyyy')|| ' a '
                  ||d.descrizione||' '||f_provincia_stato (d.cod_provincia, d.cod_comune, d.sigla_provincia,'S','S'),
               ''),
-- comune_provenienza
     to_char(null),
-- data decorrenza
     to_char(to_date(nvl(c01.data_decorrenza,tpr.data_pratica),'j'),'dd/mm/yyyy'),
-- 
       c01.cod_pro_eve, c01.cod_com_eve,
       to_number(null), to_number(null),
       fam.cod_pro_aire, fam.cod_com_aire,
       ana.cod_pro_nas, ana.cod_com_nas
  from arccom a, arccom a1, arccom b,arccom c,arccom e, arccom d,arccom m,arccom com_DI,
       anadrp drp,anadci dci,anadsc dsc,anadce dce,
       anadoc doc_PT, anadoc doc_CC,anadoc doc_DI,
       anadts dts, anadts dts_d, anadpr dpr,anadpr dpr_d,
       anafam fam, anaana ana, anaana ana_dic,
       anac01 c01, anac0m c0m, anatpr tpr
 where a.cod_provincia      (+)    = ana.cod_pro_nas
   and a.cod_comune         (+)    = ana.cod_com_nas
   and a1.cod_provincia     (+)    = ana.cod_pro_atto_nas
   and a1.cod_comune        (+)    = ana.cod_com_atto_nas
   and b.cod_provincia      (+)    = fam.cod_pro_aire
   and b.cod_comune         (+)    = fam.cod_com_aire
   and c.cod_provincia      (+)    = c01.cod_pro_eve
   and c.cod_comune         (+)    = c01.cod_com_eve
   and e.cod_provincia(+) = ana.cod_pro_mat
   and e.cod_comune(+) = ana.cod_com_mat
   and d.cod_provincia(+) = ana.cod_pro_ved
   and d.cod_comune(+) = ana.cod_com_ved          
   and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente
                                            from menuditta)
   and drp.cod_rp           = ana.rapporto_par
   and drp.sesso            = ana.sesso
   and dci.cod_ci           (+)    = ana.nazionalita        
   and dsc.cod_sc           = ana.stato_civile
   and dsc.sesso            = ana.sesso
   and doc_CC.natura_documento   (+)    != 'A'
   and doc_CC.progr_documento    (+)    = 1
   and doc_CC.tipo_documento     (+)    = 'CC'
   and doc_CC.matricola          (+)    = c0m.matricola
   and doc_PT.natura_documento   (+)    != 'A'
   and doc_PT.progr_documento    (+)    = 1
   and doc_PT.tipo_documento     (+)    = 'PT'
   and doc_PT.matricola          (+)    = c0m.matricola
   and com_DI.cod_provincia      (+)    = doc_DI.cod_pro_ente
   and com_DI.cod_comune         (+)    = doc_DI.cod_com_ente
   and doc_DI.progr_documento    (+)    = 1
   and doc_DI.tipo_documento     (+)    = f_get_campo_DI(tpr.matricola_dic,'TIPO_DOCUMENTO')
   and doc_DI.matricola          (+)    = tpr.matricola_dic
   and dce.anagrafe                 = tpr.anagrafe
   and dce.tipo_evento              = tpr.tipo_evento
   and dce.flag_tpr                 = 'S'
   and nvl(dce.tipo_evento_tpr,' ') = nvl(tpr.cod_variazione,' ')
   and dts.cod_ts               (+) = ana.titolo_studio
   and dts_d.cod_ts             (+) = ana_dic.titolo_studio
   and dpr_d.cod_pr               (+) = ana_dic.cod_prof
   and dpr_d.sesso                (+) = ana_dic.sesso
   and ana_dic.matricola          (+)  = tpr.matricola_dic
   and dpr.cod_pr               (+) = ana.cod_prof
   and dpr.sesso                (+) = ana.sesso
   and fam.cod_fam          (+)    = ana.cod_fam
   and fam.fascia           (+)    = ana.fascia
   and ana.matricola        = c0m.matricola
   and ana.fascia in (3,4)
   and c0m.anno_protocollo_aire    = c01.anno_protocollo_aire
   and c0m.protocollo_aire         = c01.protocollo_aire
   and c0m.anno_pratica is null
   and c0m.pratica is null
   and c01.anno_protocollo_aire    = tpr.anno_pratica
   and c01.protocollo_aire         = tpr.pratica
   and c01.anno_pratica is null
   and c01.pratica is null
   and tpr.anagrafe         = 'AIR'
   and tpr.tipo_evento      = 'C'
UNION
-----------------------
-- iscrizioni aire
-----------------------
select tpr.anagrafe, tpr.tipo_evento,
     tpr.anno_pratica, tpr.pratica, 
     to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- anno_dic, numero_dic
     a01.anno_protocollo_aire, a01.protocollo_aire,
-- tipo_pratica
     'Iscrizione AIRE',
-- cognome_nome_dichiarante
     translate(tpr.cognome_nome_dic,'/',' '),
-- cod_fiscale_dichiarante
     ana_dic.cod_fiscale,
-- riga_trasferimento_1
     to_char(null),
-- riga_trasferimento_2
     to_char(null),
-- riga_trasferimento_3
     to_char(null),
-- riga_trasferimento_4
     to_char(null),
-- cognome_nome
     translate(ana.cognome_nome,'/',' '),
-- cognome
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
-- nome
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),
-- sesso
     ana.sesso,
-- paternita
     decode(ana.paternita,'','','pt. '||translate(ana.paternita,'/',' ')),
-- maternita
     decode(ana.maternita,'','','mt. '||translate(ana.maternita,'/',' ')),
-- nat_oa
       decode(ana.sesso,'M','nato','nata'),
-- data_nascita
     decode(ana.anno_nas,'S',
       '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
-- comune_nascita
     nvl(a.descrizione_al1,a.descrizione)||' '||
        f_provincia_stato_CER(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
     decode(a1.descrizione,'','',a1.descrizione||' ('||a1.sigla_provincia||')'),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '||ana.atto_nas||
           ' p. '||decode(ana.parte_nas,1,'I',2,'II')||
           decode(ana.serie_nas,'','',' s. '||ana.serie_nas)||
           decode(ana.ufficio_nas,0,'','','',' - '||ana.ufficio_nas)||
           ' / '||ana.anno_atto_nas,
         'atto digitale N. '||ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,
-- coniugat_oa
       decode(ana.stato_civile,'CN',
       decode(ana.sesso,'M','coniugato','coniugata'),''),
-- cognome_nome_coniuge
     decode(ana.stato_civile,
         'CN',translate(ana.cognome_nome_cn,'/',' '),
         'VE',translate(ana.cognome_nome_cn,'/',' '),''),
-- cittadinanza
     dci.descrizione, 
-- cod_fiscale
--     decode(ana.cod_fiscale,'',to_char(null),
--       decode(ana.cf_calcolato,'',ana.cod_fiscale,to_char(null))),
     ana.cod_fiscale,
-- rapporto_parentela
       drp.descrizione,
-- sequenza_par
       a0m.nuova_sequenza_par,
-- residenza  (comune di provenienza di anaa01)
       decode(b.descrizione,'','',
             b.descrizione||' ('||b.sigla_provincia||')'),
-- indirizzo
    to_char(null),
-- cap_comune_residenza
    decode(b.descrizione,'','',lpad(b.cap,5,'0')),
-- residenza_fam
       to_char(null),
-- indirizzo_fam
     to_char(null),
-- indirizzo_dichiarato
     a01.via_aire, 
-- comune_dichiarato
     c.descrizione||' ('||c.sigla_provincia||')',
-- numero_carta_dichiarante
    doc_DI.numero||' - '||com_DI.descrizione||' ('||com_DI.sigla_provincia||')',
-- data_carta_dichiarante
    to_char(to_date(doc_DI.data_emissione,'j'),'dd/mm/yyyy'),
-- comune_data
     m.descrizione||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
     m.descrizione,
-- data
     to_char(sysdate,'dd/mm/yyyy'),
-- matricola
     a0m.matricola, 
-- fascia
     to_number(null),
-- cod_fam
     to_number(null),
-- flag_pt
     decode(doc_PT.matricola,'',to_char(null),'S'),
-- flag_cc
     decode(doc_CC.matricola,'',to_char(null),'S'),
-- flag_soggetto
       a0m.flag_soggetto,
-- flag_annullamento
       a0m.flag_annullamento,
-- data_nas : per order by
     ana.data_nas,
-- matricola_dichiarante
     tpr.matricola_dic,
-- sesso_dichiarante
     ana_dic.sesso,
-- descrizione_evento
     dce.des_evento_tpr,
-- professione  
     dpr.descrizione,
-- professione_dichiarante
     dpr_d.descrizione,
-- titolo_studio
     dts.descrizione,
-- titolo_sudio_dichiarante
     dts_d.descrizione,
--  numero_patente
     doc_pt.numero,
--estremi_mat_ved
     DECODE (ana.stato_civile,'CN','il '||DECODE (ana.anno_mat,'S','00/00/'
                                          ||TO_CHAR(TO_DATE(ana.data_mat,'j'),'yyyy'),
                                 TO_CHAR(TO_DATE (ana.data_mat,'j'),'dd/mm/yyyy'))||' a '|| 
             e.descrizione||' '||f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S'),
               'VE','dal '||TO_CHAR(TO_DATE (ana.data_ved,'j'),'dd/mm/yyyy')|| ' a '
                  ||d.descrizione||' '||f_provincia_stato (d.cod_provincia, d.cod_comune, d.sigla_provincia,'S','S'),
               ''),
-- comune_provenienza
  to_char(null),
-- data decorrenza
  to_char(to_date(a01.data_decorrenza,'j'),'dd/mm/yyyy'),
-- 
       a01.cod_pro_eve, a01.cod_com_eve,
       a01.cod_pro_eve, a01.cod_com_eve,
       to_number(null), to_number(null),
       ana.cod_pro_nas, ana.cod_com_nas
  from  arccom a, arccom a1, arccom m,arccom b, arccom c, arccom e, arccom d, arccom com_DI,
      arcvie avie, 
      anadsc dsc, anadci dci,anadrp drp,anadce dce,
      anadoc doc_DI, anadoc doc_PT,anadoc doc_CC, 
      anadts dts, anadts dts_d, anadpr dpr,anadpr dpr_d,
      anafam fam,anaana ana_dic,
      anaana ana, 
     anaa01 a01, anaa0m a0m, anatpr tpr
 where a.cod_provincia      (+) = ana.cod_pro_nas
   and a.cod_comune         (+) = ana.cod_com_nas
   and avie.cod_via         (+) = fam.cod_via
   and a1.cod_provincia     (+) = ana.cod_pro_atto_nas
   and a1.cod_comune        (+) = ana.cod_com_atto_nas
   and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente
                                            from menuditta)
   and e.cod_provincia(+) = ana.cod_pro_mat
   and e.cod_comune(+) = ana.cod_com_mat
   and d.cod_provincia(+) = ana.cod_pro_ved
   and d.cod_comune(+) = ana.cod_com_ved          
   and b.cod_provincia      (+) = a01.cod_pro_eve
   and b.cod_comune         (+) = a01.cod_com_eve
   and c.cod_provincia      (+) = a01.cod_pro_aire
   and c.cod_comune         (+) = a01.cod_com_aire
   and dci.cod_ci           (+) = ana.nazionalita
   and drp.cod_rp               = a0m.nuovo_rapporto_par
   and drp.sesso                = a0m.sesso
   and dsc.cod_sc               = ana.stato_civile
   and dsc.sesso                = ana.sesso
   and doc_CC.natura_documento  (+)    != 'A'
   and doc_CC.progr_documento   (+)    = 1
   and doc_CC.tipo_documento    (+)    = 'CC'
   and doc_CC.matricola         (+)    = a0m.matricola
   and doc_PT.natura_documento  (+)    != 'A'
   and doc_PT.progr_documento   (+)    = 1
   and doc_PT.tipo_documento    (+)    = 'PT'
   and doc_PT.matricola         (+)    = a0m.matricola
   and com_DI.cod_provincia     (+)    = doc_DI.cod_pro_ente
   and com_DI.cod_comune        (+)    = doc_DI.cod_com_ente
   and doc_DI.progr_documento   (+)    = 1
   and doc_DI.tipo_documento    (+)    = f_get_campo_DI(tpr.matricola_dic,'TIPO_DOCUMENTO')
   and doc_DI.matricola         (+)    = tpr.matricola_dic
   and dce.anagrafe                 = tpr.anagrafe
   and dce.tipo_evento              = tpr.tipo_evento
   and dce.flag_tpr                 = 'S'
   and nvl(dce.tipo_evento_tpr,' ') = nvl(tpr.cod_variazione,' ')
   and dts.cod_ts               (+) = ana.titolo_studio
   and dts_d.cod_ts             (+) = ana_dic.titolo_studio
   and dpr_d.cod_pr             (+) = ana_dic.cod_prof
   and dpr_d.sesso              (+) = ana_dic.sesso
   and ana_dic.matricola        (+)    = tpr.matricola_dic
   and dpr.cod_pr               (+) = ana.cod_prof
   and dpr.sesso                (+) = ana.sesso
   and fam.cod_fam       (+) = a01.cod_fam_prov
   and fam.fascia        (+) = 1
   and ana.matricola         = a0m.matricola
   and a0m.anno_protocollo_aire  = a01.anno_protocollo_aire
   and a0m.protocollo_aire       = a01.protocollo_aire
   and a0m.pratica is null
   and a0m.anno_pratica is null
   and a01.anno_protocollo_aire  = tpr.anno_pratica
   and a01.protocollo_aire       = tpr.pratica
   and a01.pratica is null
   and a01.anno_pratica is null
   and tpr.anagrafe        = 'AIR'
   and tpr.tipo_evento     = 'I'
UNION
--
-- cambio di abitazione AIRE
--
select tpr.anagrafe, tpr.tipo_evento,
     tpr.anno_pratica, tpr.pratica, 
     to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- anno_dic, numero_dic
     tpr.anno_pratica, tpr.pratica, 
-- tipo_pratica
     'Cambio Abitazione AIRE',
-- cognome_nome_dichiarante
     translate(tpr.cognome_nome_dic,'/',' '),
-- cod_fiscale_dichiarante
     ana_dic.cod_fiscale,
-- riga_trasferimento_1
    to_char(null),
-- riga_trasferimento_2
    to_char(null),
-- riga_trasferimento_3
     to_char(null),
-- riga_trasferimento_4
    to_char(null),
-- cognome_nome
     translate(ana.cognome_nome,'/',' '),
-- cognome
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1),
-- nome
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1),
-- sesso
     ana.sesso,
-- paternita
     decode(ana.paternita,'','','pt. '||translate(ana.paternita,'/',' ')),
-- maternita
     decode(ana.maternita,'','','mt. '||translate(ana.maternita,'/',' ')),
-- nat_oa
       decode(ana.sesso,'M','nato','nata'),
-- data_nascita
     decode(ana.anno_nas,'S',
       '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
        to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')),
-- comune_nascita
     nvl(a.descrizione_al1,a.descrizione)||' '||
       f_provincia_stato_CER(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
     decode(a1.descrizione,'','',a1.descrizione||' ('||a1.sigla_provincia||')'),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '||ana.atto_nas||
           ' p. '||decode(ana.parte_nas,1,'I',2,'II')||
           decode(ana.serie_nas,'','',' s. '||ana.serie_nas)||
           decode(ana.ufficio_nas,0,'','','',' - '||ana.ufficio_nas)||
           ' / '||ana.anno_atto_nas,
         'atto digitale N. '||ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,
-- coniugat_oa
       decode(ana.stato_civile,'CN',
       decode(ana.sesso,'M','coniugato','coniugata'),''),
-- cognome_nome_coniuge
     decode(ana.stato_civile,
         'CN',translate(ana.cognome_nome_cn,'/',' '),
         'VE',translate(ana.cognome_nome_cn,'/',' '),''),
-- cittadinanza
     dci.descrizione, 
-- cod_fiscale
--     decode(ana.cod_fiscale,'',to_char(null),
--       decode(ana.cf_calcolato,'',ana.cod_fiscale,to_char(null))),
     ana.cod_fiscale,
-- rapporto_parentela
       drp.descrizione,
-- sequenza_par
       nvl(cam.nuova_sequenza_par,cam.sequenza_par_prec),
-- residenza
     b.descrizione||' ('||b.sigla_provincia||')',
-- indirizzo
     fam_prov.via_aire  ,
-- cap_comune_residenza
     lpad(b.cap,5,'0'),
-- residenza_fam
       b.descrizione||' ('||b.sigla_provincia||')',
-- indirizzo_fam
     'abitante in '||fam_prov.via_aire,
-- indirizzo_dichiarato
      fam_dest.via_aire,
-- comune_dichiarato
      c.descrizione||' ('||c.sigla_provincia||')',
-- numero_carta_dichiarante
    decode(doc_di.numero,'','',doc_DI.numero||' - '||com_DI.descrizione||' ('||com_DI.sigla_provincia||')'),
-- data_carta_dichiarante
     to_char(to_date(doc_DI.data_emissione,'j'),'dd/mm/yyyy'),
-- comune_data
     m.descrizione||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
     m.descrizione,
-- data
     to_char(sysdate,'dd/mm/yyyy'),
-- matricola
     cam.matricola, 
-- fascia
     ana.fascia,
-- cod_fam
     caa.cod_fam_prov,
-- flag_pt
     decode(doc_PT.matricola,'',to_char(null),'S'),
-- flag_cc
     decode(doc_CC.matricola,'',to_char(null),'S'),
-- flag_soggetto
       cam.flag_soggetto,
-- flag_annullamento
       cam.flag_annullamento,
-- data_nas : per order by
     ana.data_nas,
-- matricola_dichiarante
     tpr.matricola_dic,
-- sesso_dichiarante
     ana_dic.sesso,
-- descrizione_evento
     dce.des_evento_tpr,
-- professione  
     dpr.descrizione,
-- professione_dichiarante
     dpr_d.descrizione,
-- titolo_studio
     dts.descrizione,
-- titolo_sudio_dichiarante
     dts_d.descrizione,
--  numero_patente
     doc_pt.numero,
--estremi_mat_ved
     DECODE (ana.stato_civile,'CN','il '||DECODE (ana.anno_mat,'S','00/00/'
                                          ||TO_CHAR(TO_DATE(ana.data_mat,'j'),'yyyy'),
                                 TO_CHAR(TO_DATE (ana.data_mat,'j'),'dd/mm/yyyy'))||' a '|| 
             e.descrizione||' '||f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S'),
               'VE','dal '||TO_CHAR(TO_DATE (ana.data_ved,'j'),'dd/mm/yyyy')|| ' a '
                  ||d.descrizione||' '||f_provincia_stato (d.cod_provincia, d.cod_comune, d.sigla_provincia,'S','S'),
               ''),
-- comune_provenienza
  to_char(null),
-- data decorrenza
    to_char(to_date(tpr.data_pratica,'j'),'dd/mm/yyyy'),
-- 
       fam_dest.cod_pro_aire, fam_dest.cod_com_aire,
       fam_dest.cod_pro_aire, fam_dest.cod_com_aire,
       fam_prov.cod_pro_aire, fam_prov.cod_com_aire,
       ana.cod_pro_nas, ana.cod_com_nas
  from (select anno_protocollo_aire, protocollo_aire, count(*) familiari
        from anacam 
       where flag_annullamento     is null
         and flag_soggetto        = 'S'
       group by anno_protocollo_aire, protocollo_aire) cam_v,
     arccom a, arccom a1, arccom b,arccom c, arccom e, arccom d,arccom m, arccom com_DI, 
     anadrp drp, anadci dci, anadsc dsc,anadce dce,
     anadoc doc_PT, anadoc doc_CC, anadoc doc_DI,
     anadts dts, anadts dts_d, anadpr dpr,anadpr dpr_d,
     anaana ana_dic,
     anafam fam_prov, anafam fam_dest, anaana ana, 
     anacaa caa, anacam cam, anatpr tpr
 where a.cod_provincia    (+)    = ana.cod_pro_nas
   and a.cod_comune    (+)    = ana.cod_com_nas
   and a1.cod_provincia    (+)    = ana.cod_pro_atto_nas
   and a1.cod_comune    (+)    = ana.cod_com_atto_nas
   and (m.cod_provincia, m.cod_comune) = 
     (select pro_cliente, com_cliente
        from menuditta)
   and e.cod_provincia(+) = ana.cod_pro_mat
   and e.cod_comune(+) = ana.cod_com_mat
   and d.cod_provincia(+) = ana.cod_pro_ved
   and d.cod_comune(+) = ana.cod_com_ved          
   and b.cod_provincia    (+) = fam_prov.cod_pro_aire
   and b.cod_comune       (+) = fam_prov.cod_com_aire
   and c.cod_provincia    (+) = fam_dest.cod_pro_aire
   and c.cod_comune       (+) = fam_dest.cod_com_aire
   and dci.cod_ci         (+) = ana.nazionalita
   and drp.cod_rp         = nvl(cam.nuovo_rapporto_par,ana.rapporto_par)
   and drp.sesso          = ana.sesso
   and dsc.cod_sc         = ana.stato_civile
   and dsc.sesso          = ana.sesso
   and cam_v.protocollo_aire        = tpr.pratica
   and cam_v.anno_protocollo_aire   = tpr.anno_pratica
   and doc_CC.natura_documento    (+)    != 'A'
   and doc_CC.progr_documento    (+)    = 1
   and doc_CC.tipo_documento    (+)    = 'CC'
   and doc_CC.matricola        (+)    = cam.matricola
   and doc_PT.natura_documento    (+)    != 'A'
   and doc_PT.progr_documento    (+)    = 1
   and doc_PT.tipo_documento    (+)    = 'PT'
   and doc_PT.matricola        (+)    = cam.matricola
   and com_DI.cod_provincia    (+)    = doc_DI.cod_pro_ente
   and com_DI.cod_comune    (+)    = doc_DI.cod_com_ente
   and doc_DI.progr_documento    (+)    = 1
   and doc_DI.tipo_documento    (+)    = f_get_campo_DI(tpr.matricola_dic,'TIPO_DOCUMENTO')
   and doc_DI.matricola        (+)    = tpr.matricola_dic
   and dce.anagrafe                 = tpr.anagrafe
   and dce.tipo_evento              = tpr.tipo_evento
   and dce.flag_tpr                 = 'S'
   and nvl(dce.tipo_evento_tpr,' ') = nvl(tpr.cod_variazione,' ')
   and dts.cod_ts               (+) = ana.titolo_studio
   and dts_d.cod_ts             (+) = ana_dic.titolo_studio
   and dpr_d.cod_pr             (+) = ana_dic.cod_prof
   and dpr_d.sesso              (+) = ana_dic.sesso
   and ana_dic.matricola        (+)    = tpr.matricola_dic
   and dpr.cod_pr               (+) = ana.cod_prof
   and dpr.sesso                (+) = ana.sesso
   and fam_dest.cod_fam        (+)     = caa.cod_fam_dest
   and fam_dest.fascia        (+)    = 3
   and fam_prov.cod_fam        (+)     = caa.cod_fam_prov
   and fam_prov.fascia        (+)    = 3
   and ana.matricola        = cam.matricola
   and cam.anno_protocollo_aire        = caa.anno_protocollo_aire
   and cam.protocollo_aire        = caa.protocollo_aire
   and caa.anno_protocollo_aire       = tpr.anno_pratica
   and caa.protocollo_aire        = tpr.pratica
   and tpr.anagrafe        = 'AIR'
   and tpr.tipo_evento        = 'E'
/
comment on table certpr is 'Anagrafe - Dati Pratiche / Individui per Stampe (view)'
/