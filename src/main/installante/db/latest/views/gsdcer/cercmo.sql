--liquibase formatted sql
--changeset amonopoli:202301121324 runOnChange:true stripComments:false
create or replace view cercmo 
	(ufficio,anno,atto,parte,parte_edit,serie,serie_edit,
         numero_atto_ansc,
	 ufficio_orig,anno_orig,atto_orig,parte_orig,
	 parte_orig_edit,serie_orig,serie_orig_edit,
         numero_atto_ansc_orig,
         comune_atto,
	 cognome_nome,cognome,nome,
	 codice_fiscale,sesso,sesso_m_f,nat_oa,nat_oa_il,
	 data_nascita,
	 comune_nascita,cap_comune_nascita,tribunale_nascita,
	 comune_atto_nascita,cap_comune_atto_nascita,
	 residenza,cap_residenza,indirizzo_ana,
	 decedut_oa,mort_oa,data_morte,
	 giorno_morte,giorno_morte_lettere,
	 mese_morte,
	 anno_morte,anno_morte_lettere,
	 comune_morte,cap_comune_morte,
	 ore,ore_lettere,minuti,minuti_lettere, 
	 e_minuti,e_minuti_lettere,
	 motivo_morte,stato_civile,
	 cognome_nome_coniuge,cognome_coniuge,nome_coniuge,
	 comune_data,comune,data,
	 tribunale,comune_registro,anno_nas,parte_nas,
	 serie_nas,atto_nas,ufficio_nas,atto_nas_edit,
         numero_atto_ansc_nas,
	 padre,cognome_padre,nome_padre,
         madre,cognome_madre,nome_madre,
         professione,luogo_morte,
	 autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	 frazione_prov, autorita_prov_ufficio,nota_rif,anno_nota_rif,data_nota_rif,
	 ufficiale_prov,qualifica_prov,
	 protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
         ente_straniero, comune_ente_straniero, stato_ente_straniero, data_atto_ente_straniero,
         tipo_atto_ente_straniero, estremi_atto_ente_straniero, 
         DATA_RICHIESTA_TRASPORTO, RICHIEDENTE_TRASPORTO, 
         DATA_TRASPORTO, ORE_TRASPORTO, MINUTI_TRASPORTO, 
         INCARICATO_TRASPORTO, COMUNE_DEST_TRASPORTO, 
         INDIRIZZO_DEST_TRASPORTO, CIMITERO_DEST_TRASPORTO, 
         DATA_CREMAZIONE, ORE_CREMAZIONE, MINUTI_CREMAZIONE, 
         COMUNE_CREMAZIONE, DESTINAZIONE_CENERI, NOTE_CREMAZIONE, 
         DITTA_ONORANZE_FUNEBRI, DATA_ONORANZE_FUNEBRI, 
         ORE_ONORANZE_FUNEBRI, MINUTI_ONORANZE_FUNEBRI, 
         COMUNE_ONORANZE_FUNEBRI, NOTE_TRASPORTO, 
         PROTOCOLLO_TRASPORTO, ANNO_PROTOCOLLO_TRASPORTO, DATA_PROTOCOLLO_TRASPORTO, 
         PROTOCOLLO_PERMESSO, ANNO_PROTOCOLLO_PERMESSO, DATA_PROTOCOLLO_PERMESSO, 
         PROT_PERMESSO_ALTRO_COMUNE, ANNO_PERMESSO_ALTRO_COMUNE, DATA_PERMESSO_ALTRO_COMUNE, 
         PROTOCOLLO_CREMAZIONE, ANNO_PROTOCOLLO_CREMAZIONE, DATA_PROTOCOLLO_CREMAZIONE, 
         terminalista_atto,
	 flag_comune_estero_res,
         ID_ATTO, NUMERO_UNICO_COMUNALE)
as
select 
-- ufficio 
       mor.ufficio,
-- anno
       mor.anno,
-- atto
       mor.atto,
-- parte
       mor.parte,
-- parte_edit
       decode(mor.parte,1,'I',2,'II'),
-- serie
       mor.serie,
-- serie_edit
       decode(mor.serie,'','','Serie '||mor.serie),
-- numero_atto_ansc
       f_CIV_numero_atto_ansc(mor.id_atto_ansc, mor.numero_unico),
-- ufficio_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         decode(dpa.ufficio_orig,'',
           decode(ana.ufficio_orig,'','__',ana.ufficio_orig),
           dpa.ufficio_orig)),
-- anno_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         decode(dpa.anno_orig,'',
           decode(ana.anno_orig,'','____',ana.anno_orig),
           dpa.anno_orig)),
-- atto_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         decode(dpa.atto_orig,'',
           decode(ana.atto_orig,'','____',to_char(ana.atto_orig)),
           to_char(dpa.atto_orig)),
         dpa.id_atto_ansc_orig),
-- parte_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         decode(dpa.parte_orig,'',
           decode(ana.parte_orig,'','__',ana.parte_orig),
           dpa.parte_orig)),
-- parte_orig_edit
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         decode(dpa.parte_orig,'',
           decode(ana.parte_orig,'','__',decode(ana.parte_orig,1,'I',2,'II')),
           decode(dpa.parte_orig,1,'I',2,'II'))),
-- serie_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         decode(dpa.serie_orig,'',
           decode(ana.serie_orig,'',decode(ana.atto_orig,'','__',''), ana.serie_orig),
           dpa.serie_orig)),
-- serie_orig_edit
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         decode(dpa.serie_orig,'',
           decode(ana.serie_orig,'',decode(ana.atto_orig,'','Serie __',''), 'Serie '||ana.serie_orig),
           'Serie '||dpa.serie_orig)),
-- numero_atto_ansc_orig
       f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig),
-- comune_atto
       f_CER_comune_atto_civ(5,mor.ufficio,mor.anno,mor.parte,mor.serie,mor.natura),
-- cognome_nome
       replace(mor.cognome_nome,'/',' '),
-- cognome
       substr(mor.cognome_nome,1,instr(mor.cognome_Nome,'/')-1),
-- nome
       substr(mor.cognome_nome,instr(mor.cognome_Nome,'/')+1),
-- codice_fiscale
       mor.cod_fiscale,
-- sesso
       decode(mor.sesso,'M','maschile','femminile'),
-- sesso_m_f
       mor.sesso,
-- nat_oa
       decode(mor.sesso,'M','nato','nata'),
-- nat_oa_il
       decode(mor.anni,'',decode(mor.sesso,'M','nato il','nata il'), ''),
-- data_nascita
       decode(mor.anni,'',
         decode(nvl(mor.flag_gg_imprecisato_nas,'N') || nvl(mor.flag_mm_imprecisato_nas,'N') || nvl(mor.flag_aa_imprecisato_nas,'N'), 
                'SSS', '00/00/0000',
                'SSN', '00/00/' || TO_CHAR (TO_DATE (mor.data_nas, 'j'), 'yyyy'),
                'SNN', '00/' || TO_CHAR (TO_DATE (mor.data_nas, 'j'), 'mm/yyyy'),
          DECODE (mor.anno_nas,'S','00/00/' || TO_CHAR (TO_DATE (mor.data_nas, 'j'), 'yyyy'), TO_CHAR (TO_DATE (mor.data_nas, 'j'), 'dd/mm/yyyy'))),
         'di anni '||mor.anni||decode(mor.sesso,'M',' nato',' nata')),
-- comune_nascita
--    a.descrizione||decode(a.sigla_provincia,'','',' ('||a.sigla_provincia||')'),
       rtrim(nvl(com_nas.descrizione_al1,com_nas.descrizione)||' '||
             f_provincia_stato_cer(com_nas.cod_provincia,com_nas.cod_comune,com_nas.sigla_provincia,'S','S',mor.data_nas)), 
-- cap_comune_nascita
       lpad(com_nas.cap,5,'0'),
-- tribunale_nascita
       nvl(com_nas_t.descrizione_al1,com_nas_T.descrizione),
-- comune_atto_nascita
       decode(mar.cod_pro_atto_nas||mar.cod_com_atto_nas,'',mar.comune_nas,nvl(com_atto_nas.descrizione_al1,com_atto_nas.descrizione)),
-- cap_comune_atto_nascita
       decode(mar.cod_pro_atto_nas||mar.cod_com_atto_nas,'',mar.comune_nas,lpad(com_atto_nas.cap,5,'0')),
-- residenza
--    b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),  
       rtrim(nvl(com_res.descrizione_al1,com_res.descrizione)||' '||
               f_provincia_stato(com_res.cod_provincia,com_res.cod_comune,com_res.sigla_provincia,'S','S')), 
-- cap_residenza
       lpad(com_res.cap,5,'0'),
-- indirizzo_ana
       vie_d.denom_uff||fam_d.civico_esterno,
-- decedut_oa
       decode(mor.des_evento_mor,null,upper(decode(mor.sesso,'M','deceduto','deceduta')),mor.des_evento_mor),
-- mort_ao
       decode(mor.des_evento_mor,null,decode(mor.sesso,'M','morto','morta'),mor.des_evento_mor),
-- data_morte
       decode(mor.des_data_mor,null,
         decode(mor.flag_gg_imprecisato||mor.flag_mm_imprecisato||mor.flag_aa_imprecisato,'',
           to_char(to_date(mor.data_mor,'j'),'dd/mm/yyyy'),
           decode(mor.flag_gg_imprecisato,'S','giorno IMPRECISATO',
             decode(mor.flag_mm_imprecisato,'S','mese IMPRECISATO',
               decode(mor.flag_aa_imprecisato,'S','anno IMPRECISATO')))),
         mor.des_data_mor),
-- giorno_morte
       decode(mor.des_data_mor, null, 
         decode(mor.flag_gg_imprecisato,'S','IMPRECISATO',
           ltrim(to_char(to_date(mor.data_mor,'j'),'dd'),0)),
         mor.des_data_mor),
-- giorno_morte_lettere
       DECODE (mor.des_data_mor,NULL,
         DECODE (mor.flag_gg_imprecisato,'S','IMPRECISATO',
           UPPER(DECODE (cl_c.lettere,'UN',DECODE (UPPER (inp.valore), 'S', 'PRIMO', 'UNO'),cl_c.lettere))),
         mor.des_data_mor),
-- mese_morte
       decode(mor.des_data_mor,null,decode(mor.flag_mm_imprecisato,'S','IMPRECISATO',
	 decode(to_char(to_date(mor.data_mor,'j'),'mm'),
            1,'GENNAIO',  2,'FEBBRAIO',  3,'MARZO',
            4,'APRILE',   5,'MAGGIO',    6,'GIUGNO', 
            7,'LUGLIO',   8,'AGOSTO',    9,'SETTEMBRE',
           10,'OTTOBRE', 11,'NOVEMBRE', 12,'DICEMBRE')),''),
-- anno_morte
       decode(mor.des_data_mor,null,
         decode(mor.flag_aa_imprecisato,'S','IMPRECISATO',
           to_char(to_date(mor.data_mor,'j'),'yyyy')),''),
-- anno_morte_lettere
       decode(mor.des_data_mor,null,decode(mor.flag_aa_imprecisato,'S','IMPRECISATO',
         upper(decode(substr(to_char(to_date(mor.data_mor,'j'),'yyyy'),1,2),
           18,'milleottocent', 19,'millenovecent', 20,'duemila','')||
           decode(substr(to_char(to_date(mor.data_mor,'j'),'yyyy'),1,2),20,'',
             decode(substr(to_char(to_date(mor.data_mor,'j'),'yyyy'),3,1),8,'','o'))||
               lower(decode(cl_d.lettere,'UN','UNO',cl_d.lettere)))),''),
-- comune_morte
--    c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')'),
       rtrim(nvl(com_mor.descrizione_al1,com_mor.descrizione)||' '||
             f_provincia_stato(com_mor.cod_provincia,com_mor.cod_comune,com_mor.sigla_provincia,'S','S')), 
-- cap_comune_morte
       lpad(com_mor.cap,5,'0'),
-- ore
       decode(mor.des_ore_minuti_mor,null,decode(mor.flag_hh_imprecisato,'S','IMPRECISATE', ore),mor.des_ore_minuti_mor),
-- ore_lettere
       decode(mor.des_ore_minuti_mor,null, decode(mor.flag_hh_imprecisato,'S','IMPRECISATE',
         upper(decode(ore,0,'ZERO',decode(cl_g.lettere,'UN','UNA',cl_g.lettere)))),mor.des_ore_minuti_mor),
-- minuti
       decode(mor.des_ore_minuti_mor,null,decode(mor.flag_mi_imprecisato,'S','IMPRECISATI', minuti),
         ''),
-- minuti_lettere
       decode(mor.des_ore_minuti_mor,null,decode(mor.flag_mi_imprecisato,'S','IMPRECISATI',
         upper(decode(minuti,0,'ZERO',decode(cl_h.lettere,'UN','UNO',cl_h.lettere)))),
         ''),
-- e_minuti
       decode(mor.des_ore_minuti_mor,null,decode(mor.flag_mi_imprecisato,'S','e minuti IMPRECISATI',
         decode(minuti,'','','e minuti '||minuti)),
         ''),
-- e_minuti_lettere
       decode(mor.des_ore_minuti_mor, null,decode(mor.flag_mi_imprecisato,'S','e minuti IMPRECISATI',
         decode(minuti,'','','e minuti '||upper(decode(minuti,0,'ZERO',decode(cl_h.lettere,'UN','UNO',cl_h.lettere))))),
         ''),
-- motivo_morte
       dmm.descrizione,
-- stato_civile
       decode(nvl(instr(upper(gmo.stato_civ_1),'LIBER'),0),0,
         decode(mor.stato_civile,
           'DV','Divorziat'||decode(mor.sesso,'M','o','a'),
           'GC','Gia'' coniugat'||decode(mor.sesso,'M','o','a'),
           'GU','Gia'' unit'||decode(mor.sesso,'M','o','a')||' civilmente',
                dsc.descrizione_cer), 
         gmo.stato_civ_1),
-- cognome_Nome_coniuge
       decode(nvl(instr(upper(gmo.stato_civ_1),'LIBER'),0),0,
         decode(mor.stato_civile,
           'CN',replace(mor.cognome_nome_cn,'/',' '),
           'VE',replace(mor.cognome_nome_cn,'/',' '),
           'UC',replace(mor.cognome_nome_cn,'/',' '),
           'VU',replace(mor.cognome_nome_cn,'/',' '),'')),
-- cognome_coniuge
       decode(nvl(instr(upper(gmo.stato_civ_1),'LIBER'),0),0,
         decode(mor.stato_civile,
           'CN',substr(mor.cognome_nome_cn,1,instr(mor.cognome_nome_cn,'/')-1),
           'VE',substr(mor.cognome_nome_cn,1,instr(mor.cognome_nome_cn,'/')-1),
           'UC',substr(mor.cognome_nome_cn,1,instr(mor.cognome_nome_cn,'/')-1),
           'VU',substr(mor.cognome_nome_cn,1,instr(mor.cognome_nome_cn,'/')-1),'')),
-- nome_coniuge
       decode(nvl(instr(upper(gmo.stato_civ_1),'LIBER'),0),0,
         decode(mor.stato_civile,
           'CN',substr(mor.cognome_nome_cn,instr(mor.cognome_nome_cn,'/')+1),
           'VE',substr(mor.cognome_nome_cn,instr(mor.cognome_nome_cn,'/')+1),
           'UC',substr(mor.cognome_nome_cn,instr(mor.cognome_nome_cn,'/')+1),
           'VU',substr(mor.cognome_nome_cn,instr(mor.cognome_nome_cn,'/')+1),'')),
-- comune_data
       com_ute.descrizione||' '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
       com_ute.descrizione,
-- data
       to_char(sysdate,'dd/mm/yyyy'),
-- tribunale
       nvl(com_atto_nas_T.descrizione_al1,com_atto_nas_T.descrizione),
-- comune_registro
       comune_nas,
-- anno_nas
       decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', nvl(mar.anno_nas,'_____')),
-- parte_nas
       decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', nvl(mar.parte_nas,'_____')),
-- serie_nas
       decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', decode(mar.serie_nas,'',decode(mar.atto_nas,'','__',''), mar.serie_nas)),
-- atto_nas
       decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', nvl(to_char(mar.atto_nas),'_____'),mar.id_atto_ansc_nas),
-- ufficio_nas
       decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', nvl(mar.ufficio_nas,'_____')),
-- atto_nas_edit
       decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', 
         decode(mar.atto_nas,'', to_char(null),
           'atto N. '||mar.atto_nas||' p.'||mar.parte_nas||
             decode(mar.serie_nas,'',to_char(null), ' s.'||mar.serie_nas)||
             decode(mar.ufficio_nas,'',to_char(null), ' uff. '||mar.ufficio_nas)||
             decode(mar.anno_nas,'',to_char(null),' / '||mar.anno_nas)),
         mar.id_atto_ansc_nas),
-- numero_atto_ansc_nas
       f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas),
-- padre
       'pt. '||replace(mor.paternita,'/',' '),
-- cognome_padre
       decode(instr(mor.paternita,'/'),0,
         substr(mor.cognome_nome,1,instr(mor.cognome_nome,'/')-1),
         substr(mor.paternita,1,instr(mor.paternita,'/')-1)),
-- nome_padre
       decode(instr(mor.paternita,'/'),0,
         mor.paternita,
         substr(mor.paternita,instr(mor.paternita,'/')+1)),
-- madre
       'mt. '||replace(mor.maternita,'/',' '),
-- cognome_madre
       substr(mor.maternita,1,instr(mor.maternita,'/')-1),
--nome_madre
       substr(mor.maternita,instr(mor.maternita,'/')+1),
-- professione
       professione,
-- luogo_morte
       decode(dmo.luogo_mor_1,'',
         dpa.luogo_mor_1||' '||dpa.luogo_mor_2,
         dmo.luogo_mor_1||' '||dmo.luogo_mor_2),
-- autorita_prov
       dpa.autorita_prov,
-- autorita_prov_da
       dpa.autorita_prov,
-- autorita_prov_in
       dpa.comune_prov,
-- comune_prov
       dpa.comune_prov,
-- autorita_prov_comune
       f_comune_al(dpa.cod_pro_prov, dpa.cod_com_prov, ''),
-- frazione_prov
       dpa.frazione_prov,
-- autorita_prov_ufficio
       dpa.frazione_prov,
-- nota rif.
       dpa.nota_rif,
-- anno_nota_rif
       dpa.anno_nota_rif,
-- data_nota_rif
       to_char(to_date(dpa.data_nota_rif,'j'),'dd/mm/yyyy'),
-- ufficiale_prov
       dpa.ufficiale_prov,
-- qualifica_prov
       dpa.qualifica_prov,
-- protocollo_prov
       dpa.protocollo,
-- anno_protocollo_prov
       dpa.anno_protocollo,
-- data_protocollo_prov
       to_char(to_date(dpa.data_protocollo,'j'),'dd/mm/yyyy'),
-- ente_straniero
       dpa.ente_straniero,
-- comune_ente_straniero
       rtrim(f_comune_al(dpa.ente_straniero_cod_pro, dpa.ente_straniero_cod_com, '')||' '||
         f_provincia_stato_al(dpa.ente_straniero_cod_pro, dpa.ente_straniero_cod_com,'','S','S','')),
-- stato_ente_straniero
       f_nazione(dpa.ente_straniero_cod_pro, dpa.ente_straniero_cod_com),
-- data_atto_ente_straniero
       to_char(dpa.d_ente_straniero_data_atto,'dd/mm/yyyy'),
-- tipo_atto_ente_straniero	
       dpa.ente_straniero_tipo_atto,
-- estremi_atto_ente_straniero	
       dpa.ente_straniero_estremi_atto,
-- dati trasporto / seppellimento / cremazione
-- DATA_RICHIESTA_TRASPORTO
       to_char(to_date(dts.data_richiesta,'j'),'dd/mm/yyyy'),
-- RICHIEDENTE_TRASPORTO
       nvl(dts.richiedente, dts.cognome_richiedente||decode(dts.nome_richiedente, null, null, ' '||dts.nome_richiedente)),
-- DATA_TRASPORTO
       to_char(to_date(dts.data_trasporto,'j'),'dd/mm/yyyy'),
-- ORE_TRASPORTO
       dts.ore_trasporto,
-- MINUTI_TRASPORTO
       lpad(dts.minuti_trasporto,2,'0'),
-- INCARICATO_TRASPORTO
       nvl(dts.incaricato_trasporto, dts.cognome_incaricato_tr||decode(dts.nome_incaricato_tr, null, null, ' '||dts.nome_incaricato_tr)),
-- COMUNE_DEST_TRASPORTO
       nvl(com_tra.descrizione_al1,com_tra.descrizione)||
         decode(com_tra.sigla_provincia,'','',' ('||com_tra.sigla_provincia||')'),
-- INDIRIZZO_DEST_TRASPORTO
       dts.indirizzo_dest,
-- CIMITERO_DEST_TRASPORTO
       dts.cimitero_dest,
-- DATA_CREMAZIONE
       to_char(to_date(dts.data_cremazione,'j'),'dd/mm/yyyy'),
-- ORE_CREMAZIONE
       dts.ore_cremazione,
-- MINUTI_CREMAZIONE
       lpad(dts.minuti_cremazione,2,'0'),
-- COMUNE_CREMAZIONE
       nvl(com_cre.descrizione_al1,com_cre.descrizione)||
         decode(com_cre.sigla_provincia,'','',' ('||com_cre.sigla_provincia||')'),
-- DESTINAZIONE_CENERI
       dts.destinazione_ceneri,
-- NOTE_CREMAZIONE
       dts.note_cremazione,
-- DITTA_ONORANZE_FUNEBRI
       dts.ditta_onoranze,
-- DATA_ONORANZE_FUNEBRI
       to_char(to_date(dts.data_onoranze,'j'),'dd/mm/yyyy'),
-- ORE_ONORANZE_FUNEBRI
       dts.ore_onoranze,
-- MINUTI_ONORANZE_FUNEBRI
       lpad(dts.minuti_onoranze,2,'0'),
-- COMUNE_ONORANZE_FUNEBRI
       nvl(com_onf.descrizione_al1,com_onf.descrizione)||
         decode(com_onf.sigla_provincia,'','',' ('||com_onf.sigla_provincia||')'),
-- NOTE_TRASPORTO
       dts.note,
-- PROTOCOLLO_TRASPORTO
       dts.protocollo_t,
-- ANNO_PROTOCOLLO_TRASPORTO
       dts.anno_protocollo_t,
-- DATA_PROTOCOLLO_TRASPORTO
       to_char(to_date(dts.data_protocollo_t,'j'),'dd/mm/yyyy'),
-- PROTOCOLLO_PERMESSO
       dts.protocollo_s,
-- ANNO_PROTOCOLLO_PERMESSO
       dts.anno_protocollo_s,
-- DATA_PROTOCOLLO_PERMESSO
       to_char(to_date(dts.data_protocollo_s,'j'),'dd/mm/yyyy'),
-- PROT_PERMESSO_ALTRO_COMUNE
       dts.prot_permesso_altro_com,
-- ANNO_PERMESSO_ALTRO_COMUNE
       dts.anno_permesso_altro_com,
-- DATA_PERMESSO_ALTRO_COMUNE
       to_char(to_date(dts.data_permesso_altro_com,'j'),'dd/mm/yyyy'),
-- PROTOCOLLO_CREMAZIONE
       dts.protocollo_c,
-- ANNO_PROTOCOLLO_CREMAZIONE
       dts.anno_protocollo_c,
-- DATA_PROTOCOLLO_CREMAZIONE
       to_char(to_date(dts.data_protocollo_c,'j'),'dd/mm/yyyy'),
--
-- terminalista_atto
       mor.terminalista,
-- flag_comune_estero_res
       decode(sign(mor.cod_pro_res-199),-1,to_char(null),'S'),
-- id_atto
       mor.id_atto,
-- numero_unico
       f_CIV_numero_unico_comunale(mor.numero_unico)
  from arcinp inp, 
       cilet cl_c, cilet cl_d, cilet cl_g, cilet cl_h,
       arccom com_ute, 
       arccom com_nas, arccom com_nas_T, 
       arccom com_atto_nas, arccom com_atto_nas_T, 
       arccom com_res, arccom com_mor, 
       arccom com_tra, arccom com_cre, arccom com_onf,
       arcvie vie_d, anafam fam_d, anaana ana_d,
       civdmm dmm, anadsc dsc, 
       civdts dts, civmar mar, civdmo dmo, civgmo gmo,
       civdpa dpa, civana ana, 
       civmor mor 
 where (com_ute.cod_provincia, com_ute.cod_comune) =  (select pro_cliente,com_cliente from menuditta)
   and com_nas_T.cod_comune         (+) = substr(lpad(com_nas.tribunale,6,0),4,3)
   and com_nas_T.cod_provincia      (+) = substr(lpad(com_nas.tribunale,6,0),1,3)
   and com_atto_nas_T.cod_comune    (+) = substr(lpad(com_atto_nas.tribunale,6,0),4,3)
   and com_atto_nas_T.cod_provincia (+) = substr(lpad(com_atto_nas.tribunale,6,0),1,3)
   and com_atto_nas.cod_provincia   (+) = mar.cod_pro_atto_nas
   and com_atto_nas.cod_comune      (+) = mar.cod_com_atto_nas
   and com_nas.cod_provincia        (+) = mor.cod_pro_nas
   and com_nas.cod_comune           (+) = mor.cod_com_nas 
   and com_res.cod_comune           (+) = mor.cod_com_res
   and com_res.cod_provincia        (+) = mor.cod_pro_res
   and com_mor.cod_comune           (+) = mor.cod_com_mor
   and com_mor.cod_provincia        (+) = mor.cod_pro_mor
   and com_tra.cod_provincia        (+) = dts.cod_pro_dest
   and com_tra.cod_comune           (+) = dts.cod_com_dest 
   and com_cre.cod_provincia        (+) = dts.cod_pro_cremazione
   and com_cre.cod_comune           (+) = dts.cod_com_cremazione
   and com_onf.cod_provincia        (+) = dts.cod_pro_onoranze
   and com_onf.cod_comune           (+) = dts.cod_com_onoranze
   and inp.parametro          = 'ATTI_PRIMO'
   and dmm.cod_mm      (+)    = mor.motivo_mor
   and cl_c.chiave            = nvl(to_char(to_date(mor.data_mor,'j'),'dd'),'0')
   and cl_c.tipo              = 'U'
   and cl_d.chiave            = nvl(to_char(to_date(mor.data_mor,'j'),'yy'),'0')
   and cl_d.tipo              = 'U'
   and cl_g.chiave            = to_char(nvl(mor.ore,0))
   and cl_g.tipo              = 'U'
   and cl_h.chiave            = to_char(nvl(mor.minuti,0))
   and cl_h.tipo              = 'U'
   AND dsc.cod_sc      (+)    = mor.stato_civile
   and dsc.sesso       (+)    = mor.sesso
   and vie_d.cod_via   (+)    = fam_d.cod_via
   and fam_d.fascia    (+)    = ana_d.fascia
   and fam_d.cod_fam   (+)    = ana_d.cod_fam
   and ana_d.fascia    (+)    = 1
   and ana_d.matricola (+)    = ana.matricola_1
   and dpa.id_atto     (+)    = mor.id_atto
   and gmo.id_atto     (+)    = mor.id_atto
   and dmo.id_atto     (+)    = mor.id_atto
   and mar.id_atto     (+)    = mor.id_atto
   and dts.id_atto     (+)    = mor.id_atto
   and ana.id_atto     (+)    = mor.id_atto
   and mor.cod_rec            in (0,3)
/ 
comment on table cercmo is 'Stato Civile - Dati Atti di Morte per Comunicazioni'
/
