--liquibase formatted sql
--changeset amonopoli:202304061735 runAlways:true runOnChange:true stripComments:false
create or replace view civwuc_totale
        (COD_REC, UFFICIO, ANNO, ATTO, PARTE, SERIE, NATURA, NATURA_UCI,
         NUMERO_ATTO_ANSC,
         UFFICIO_ORIG, ANNO_ORIG, ATTO_ORIG, PARTE_ORIG, SERIE_ORIG,
         NUMERO_ATTO_ANSC_ORIG,
         ANNO_OGGI, MESE_OGGI,GIORNO_OGGI, ORE_OGGI, MINUTI_OGGI,
         DATA_UNIONE_VERBALE, 
         DATA_UNIONE, ANNO_UNIONE, MESE_UNIONE, GIORNO_UNIONE,
         COMUNE_UNIONE,
         COGNOME_NOME_1, COGNOME_1, NOME_1, SESSO_1,
         NAT_OA_1, DATA_NASCITA_1, 
         ANNO_NASCITA_1, MESE_NASCITA_1, GIORNO_NASCITA_1,
         ATTO_NASCITA_1, COMUNE_NASCITA_1, COMUNE_ATTO_NASCITA_1, COMUNE_RESIDENZA_1,
         CITTADIN_OA_1, NAZIONALITA_1, 
         PROFESSIONE_1, STATO_CIVILE_1, comprensione_1, motivo_impedimento_1,
         CAMBIO_COGNOME_1, COGNOME_AGGIUNTIVO_1,
         COGNOME_NOME_2,  COGNOME_2, NOME_2,  SESSO_2,
         NAT_OA_2, DATA_NASCITA_2, 
         ANNO_NASCITA_2, MESE_NASCITA_2, GIORNO_NASCITA_2,
         ATTO_NASCITA_2, COMUNE_NASCITA_2, COMUNE_ATTO_NASCITA_2, COMUNE_RESIDENZA_2,
         CITTADIN_OA_2, NAZIONALITA_2, 
         PROFESSIONE_2, STATO_CIVILE_2, comprensione_2, motivo_impedimento_2,
         CAMBIO_COGNOME_2, COGNOME_AGGIUNTIVO_2,
         COGNOME_COMUNE,cognome_nome_officiante,
         testimoni_cognome_nome_1, testimoni_nato_1, testimoni_comune_nas_1,
         testimoni_data_nas_1, testimoni_professione_1, testimoni_residenza_1,
         testimoni_cittadino_1, testimoni_nazionalita_1,
         testimoni_cognome_nome_2, testimoni_nato_2, testimoni_comune_nas_2,
         testimoni_data_nas_2, testimoni_professione_2, testimoni_residenza_2,
         testimoni_cittadino_2, testimoni_nazionalita_2,
	 testimoni_cognome_nome_3, testimoni_nato_3, testimoni_comune_nas_3,
         testimoni_data_nas_3, testimoni_professione_3, testimoni_residenza_3,
	 testimoni_cittadino_3, testimoni_nazionalita_3,
	 testimoni_cognome_nome_4, testimoni_nato_4, testimoni_comune_nas_4,
         testimoni_data_nas_4, testimoni_professione_4, testimoni_residenza_4,
	 testimoni_cittadino_4, testimoni_nazionalita_4,
         COGNOME_INTERPRETE, NOME_INTERPRETE, COMUNE_NASCITA_INTERPRETE, COMUNE_RESIDENZA_INTERPRETE, DATA_NASCITA_INTERPRETE,
         COGNOME_RICHIEDENTE, NOME_RICHIEDENTE, COMUNE_NASCITA_RICHIEDENTE, COMUNE_RESIDENZA_RICHIEDENTE, DATA_NASCITA_RICHIEDENTE,
         COMUNE_DATA, COMUNE, DATA,
         autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
         frazione_prov, autorita_prov_ufficio, nota_rif, anno_nota_rif, data_nota_rif,
         ufficiale_prov, qualifica_prov,
         protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
	 ente_straniero, comune_ente_straniero, stato_ente_straniero, data_atto_ente_straniero,
	 tipo_atto_ente_straniero, estremi_atto_ente_straniero, 
         ufficiale_utente,cognome_avvocato_1,nome_avvocato_1,cognome_avvocato_2,nome_avvocato_2,
         nel_luogo_UNIONE, luogo_UNIONE,
         RIGA_ESTRATTO_1, COMUNE_ESTRATTO_1, DATA_ESTRATTO_1,
         RIGA_CUMULATIVO_1, COMUNE_CUMULATIVO_1, DATA_CUMULATIVO_1,
         RIGA_ESTRATTO_2, COMUNE_ESTRATTO_2, DATA_ESTRATTO_2,
         RIGA_CUMULATIVO_2, COMUNE_CUMULATIVO_2, DATA_CUMULATIVO_2,
         PRESA_VISIONE_DOCUMENTI,
         avvocato_1, sede_avvocato_1, avvocato_2, sede_avvocato_2, data_accordo, atto_accordo, accordo_comune, accordo_estremi_atto, conferma_data,
         legge_convenzioni, corpo_convenzioni, 
-- SEL_MAR
	 margine_convenzioni, 
	 margine_convenzioni_comune, margine_convenzioni_li_data, 
	 margine_convenzioni_ufficiale, margine_convenzioni_firma,
	 margine_cognome_1, margine_cognome_1_li_data, 
	 margine_cognome_1_ufficiale, margine_cognome_1_firma,
	 margine_cognome_2, margine_cognome_2_li_data, 
	 margine_cognome_2_ufficiale, margine_cognome_2_firma,
-- atto originale
	 DATA_ATTO_ORIGINALE,ANNO_ATTO_ORIGINALE,MESE_ATTO_ORIGINALE,
	 GIORNO_ATTO_ORIGINALE,ORE_ATTO_ORIGINALE,MINUTI_ATTO_ORIGINALE,
	 uci_prec_data, uci_prec_comune, uci_prec_comune_atto, uci_prec_estremi_atto, sentenza_tribunale, sentenza_data,
	 luogo_fuori_casa, segretario_comunale, impossibilita_nominativo, impossibilita_altro_contraente, impossibilita_certificato, impossibilita_data_certificato)
AS
select uci.cod_rec, uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie, uci.natura, uci.natura_uci,
       f_CIV_numero_atto_ansc(uci.id_atto_ansc),
-- estremi atto originale
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.ufficio_orig), 
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.anno_orig), 
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', to_char(dpa.atto_orig), dpa.id_atto_ansc_orig),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', decode(dpa.parte_orig,'',to_char(null),1,'I',2,'II')),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.serie_orig),
       f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig),
-- anno_oggi
       f_CIV_campi_testata(-4,uci.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'anno_oggi'),
-- mese_oggi
       f_CIV_campi_testata(-4,uci.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'mese_oggi'),
-- giorno_oggi
       f_CIV_campi_testata(-4,uci.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'giorno_oggi'),
-- ore_oggi
       f_CIV_campi_testata(-4,uci.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ore_oggi'),
-- minuti_oggi
       f_CIV_campi_testata(-4,uci.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'minuti_oggi'),
-- data_UNIONE_VERBALE
       nvl(f_CIV_cifre_lettere('D',to_char(uci.d_data_uci_verbale,'dd/mm/yyyy'),inp.valore,''),
          rpad('...',10,'_')),
-- data_UNIONE
       nvl(f_CIV_cifre_lettere('D',to_char(uci.d_data_mat,'dd/mm/yyyy'),inp.valore,''),
          rpad('...',10,'_')),
-- anno_UNIONE
       f_CIV_cifre_lettere('A',to_char(uci.d_data_mat,'yyyy'),'',''),
-- mese_UNIONE
       f_CIV_cifre_lettere('M',to_char(uci.d_data_mat,'mm'),'',''),
-- giorno_UNIONE
       f_CIV_cifre_lettere('G',to_char(uci.d_data_mat,'dd'),inp.valore,''),
-- comune_UNIONE
       f_comune_al(uci.cod_pro_mat,uci.cod_com_mat,uci.data_mat)||' '||
         f_provincia_stato_al(uci.cod_pro_mat,uci.cod_com_mat,null,'S','S',uci.data_mat),
-- cognome_nome_1
       decode(occ.atto,'', translate(uci.cognome_nome_m,'/',' '), occ.cognome||' '||occ.nome),
-- cognome_1
       decode(occ.atto,'', uci.cognome_m, occ.cognome),
-- nome_1
       decode(occ.atto,'', uci.nome_m, occ.nome),
-- sesso_1
       decode(uci.sesso_m,'M','maschile','femminile'),
-- nat_oa_1
       decode(uci.sesso_m,'M','nato','nata'),
-- data_nascita_1
       decode(uci.data_nas_m,'',
         decode(uci.anni_m,'','','di anni '||f_CIV_cifre_lettere('U',uci.anni_m,'','S')),
         decode(uci.anno_nas_m,'S',f_CIV_cifre_lettere('A',to_char(uci.d_data_nas_m,'yyyy'),'','S'),
           f_CIV_cifre_lettere('D',to_char(uci.d_data_nas_m,'dd/mm/yyyy'),inp.valore,''))),
-- anno_nascita_1
       f_CIV_cifre_lettere('A',to_char(uci.d_data_nas_m,'yyyy'),'',''),
-- mese_nascita_1
       f_CIV_cifre_lettere('M',to_char(uci.d_data_nas_m,'mm'),'',''),
-- giorno_nascita_1
       f_CIV_cifre_lettere('G',to_char(uci.d_data_nas_m,'dd'),inp.valore,''),
-- atto_nascita_1
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',       
         'Atto N. '||nvl(to_char(spo.atto_nas_m),'_____')||
           ' P. '||decode(spo.parte_nas_m,'1','I','2','II',nvl(spo.parte_nas_m,'__'))||
           ' S. '||nvl(spo.serie_nas_m,'__')||
           ' - '||nvl(to_char(spo.anno_atto_nas_m),'_____'),
         'Atto N. '||spo.id_atto_ansc_nas_m),
-- comune_nascita_1
       f_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.data_nas_m)||' '||
         f_provincia_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,null,'S','S',uci.data_nas_m),
-- comune_atto_nascita_1
       f_comune_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,uci.data_nas_m)||' '||
         f_provincia_stato_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,null,'S','S',uci.data_nas_m),
-- comune_residenza_1
       f_comune_al(uci.cod_pro_res_m,uci.cod_com_res_m,'')||' '|| 
         f_provincia_stato (uci.cod_pro_res_m,uci.cod_com_res_m,'','S','S'),
-- cittadin_oa_1
       decode(uci.sesso_m,'M','cittadino','F','cittadina','cittadinanza'),
-- nazionalita_1
       lower(f_get_descrizione_DCI(uci.nazionalita_m,uci.sesso_m)),
-- professione_1
       nvl(lower(f_get_descrizione_DPR(ana_1.cod_prof,uci.sesso_m)),rpad('...',20,'_')),
-- stato_civile_1
       nvl(lower(f_get_descrizione_DSC(ana_1.stato_civile,uci.sesso_m,'','','S')),
         decode(uci.sesso_m,'M','celibe','F','nubile')),
-- comprensione_1
	f_CIV_comprensione(uci.comprensione_m, uci.sesso_m),
-- motivo_impedimento_1
	decode(uci.comprensione_m, '', null, uci.motivo_impedimento_m),
-- cambio_cognome_1
       decode(uci.cambio_cognome_m,'','','A','anteposto','P','posposto'),
-- cognome_aggiunti_1
       uci.cognome_agg_m,
-- cognome_nome_2
       decode(occ.atto,'', translate(uci.cognome_nome_f,'/',' '), occ.cognome_cn||' '||occ.nome_cn),
-- cognome_2
       decode(occ.atto,'', uci.cognome_f, occ.cognome_cn),
-- nome_2
       decode(occ.atto,'', uci.nome_f, occ.nome_cn),
-- sesso_2
       decode(uci.sesso_f,'M','maschile','F','femminile'),
-- nat_oa_2
       decode(uci.sesso_f,'M','nato','F','nata','nato/a'),
-- data_nascita_2
       decode(uci.data_nas_f,'',
         decode(uci.anni_f,'','','di anni '||f_CIV_cifre_lettere('U',uci.anni_f,'','S')),
         decode(uci.anno_nas_f,'S',f_CIV_cifre_lettere('A',to_char(uci.d_data_nas_f,'yyyy'),'','S'),
           f_CIV_cifre_lettere('D',to_char(uci.d_data_nas_f,'dd/mm/yyyy'),inp.valore,''))),
-- anno_nascita_2
       f_CIV_cifre_lettere('A',to_char(uci.d_data_nas_f,'yyyy'),'',''),
-- mese_nascita_2
       f_CIV_cifre_lettere('M',to_char(uci.d_data_nas_f,'mm'),'',''),
-- giorno_nascita_2
       f_CIV_cifre_lettere('G',to_char(uci.d_data_nas_f,'dd'),inp.valore,''),
-- atto_nascita_2
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '',       
         'Atto N. '||nvl(to_char(spo.atto_nas_f),'_____')||
           ' P. '||decode(spo.parte_nas_f,'1','I','2','II',nvl(spo.parte_nas_f,'__'))||
           ' S. '||nvl(spo.serie_nas_f,'___')||
           ' - '||nvl(to_char(spo.anno_atto_nas_f),'____'),
         'Atto N. '||spo.id_atto_ansc_nas_f),
-- comune_nascita_2
       f_comune_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.data_nas_f)||' '||
         f_provincia_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,null,'S','S',uci.data_nas_f),
-- comune_atto_nascita_2
       f_comune_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,uci.data_nas_f)||' '||
         f_provincia_stato_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,null,'S','S',uci.data_nas_f),
-- comune_residenza_2
       f_comune_al(uci.cod_pro_res_f,uci.cod_com_res_f,'')||' '|| 
         f_provincia_stato (uci.cod_pro_res_f,uci.cod_com_res_f,'','S','S'),
-- cittadin_oa_2
       decode(uci.sesso_f,'M','cittadino','F','cittadina','cittadinanza'),
-- nazionalita_2
       lower(f_get_descrizione_DCI(uci.nazionalita_f,uci.sesso_f)),
-- professione_2
       nvl(lower(f_get_descrizione_DPR(ana_2.cod_prof,uci.sesso_f)),rpad('...',20,'_')),
-- stato_civile_2
       nvl(lower(f_get_descrizione_DSC(ana_2.stato_civile,uci.sesso_f,'','','S')),
         decode(uci.sesso_f,'M','celibe','F','nubile')),
-- comprensione_2
       f_CIV_comprensione(uci.comprensione_f, uci.sesso_f),
-- motivo_impedimento_2
	decode(uci.comprensione_f, '', null, uci.motivo_impedimento_f),
-- cambio_cognome_2
       decode(uci.cambio_cognome_f,'','','A','anteposto','P','posposto'),
-- cognome_aggiunti_2
       uci.cognome_agg_f,
-- cognome_comune
       uci.cognome_agg_m||uci.cognome_agg_f,
-- cognome_nome_officiante
       COALESCE(dpa.ministro_art, dpa.ministro, dpa.ufficiale_prov, dpa.ufficiale_utente),
-- testimoni_..._1
  -- testimoni_cognome_nome_1
       decode(tta.atto,'', translate(nvl(test_1,'-'),'/',' '), tta.cognome_1||' '||tta.nome_1),
  -- testimoni_nato_1
       decode(tta.atto,'', decode(tte.nato_1,'','-','nat'||tte.nato_1), decode(tta.sesso_1,'M','nato','F','nata','nato/a')),
  -- testimoni_comune_nas_1
       decode(tta.atto,'', decode(tte.com_nas_1,'','-','in '||tte.com_nas_1), 
         f_comune_al(tta.COD_PRO_NAS_1,tta.COD_COM_NAS_1,to_char(tta.D_DATA_NAS_1,'j'))||
           decode(sign(tta.cod_pro_res_1-200),1,' '||f_provincia_stato_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,null,'S','S',to_char(tta.d_data_nas_1,'j')))
       ),
  -- testimoni_data_nas_1
       decode(tta.atto,'', nvl(tte.data_nas_1, f_CIV_cifre_lettere('D',to_char(to_date(tte.data_nas_2_j,'j'),'dd/mm/yyyy'),inp.valore,'S')), 
         f_CIV_cifre_lettere('D',to_char(tta.D_DATA_NAS_1,'dd/mm/yyyy'),inp.valore,'S')),
  -- testimoni_professione_1
       decode(tta.atto,'', nvl(tte.prof_1,'-'), ''), 
  -- testimoni_residenza_1
       decode(tta.atto,'', nvl(tte.residenza_1,'-'), 
         f_comune_al(tta.COD_PRO_RES_1,tta.COD_COM_RES_1,uci.data_mat)||
           decode(sign(tta.cod_pro_res_1-200),1,' '||f_provincia_stato_al(tta.cod_pro_res_1,tta.cod_com_res_1,null,'S','S',uci.data_mat))
       ),
  -- testimoni_cittadino_1
       decode(tta.atto,'', decode(tte.cittadino_1,'','-','cittadin'||tte.cittadino_1),
         decode(tta.sesso_1,'M','cittadino','F','cittadina','cittadinanza')),
  -- testimoni_nazionalita_1
       decode(tta.atto,'', nvl(tte.nazionalita_1,'-'), f_get_descrizione_DCI(tta.nazionalita_1,tta.sesso_1)),
-- testimoni_..._2
  -- testimoni_cognome_nome_2
       decode(tta.atto,'', translate(nvl(test_2,'-'),'/',' '), tta.cognome_2||' '||tta.nome_2),
  -- testimoni_nato_2
       decode(tta.atto,'', decode(tte.nato_2,'','-','nat'||tte.nato_2), decode(tta.sesso_2,'M','nato','F','nata','nato/a')),
  -- testimoni_comune_nas_2
       decode(tta.atto,'', decode(tte.com_nas_2,'','-','in '||tte.com_nas_2), 
         f_comune_al(tta.COD_PRO_NAS_2,tta.COD_COM_NAS_2,to_char(tta.D_DATA_NAS_2,'j'))||
           decode(sign(tta.cod_pro_res_2-200),1,' '||f_provincia_stato_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,null,'S','S',to_char(tta.d_data_nas_2,'j')))
       ),
  -- testimoni_data_nas_2
       decode(tta.atto,'', nvl(tte.data_nas_2, f_CIV_cifre_lettere('D',to_char(to_date(tte.data_nas_2_j,'j'),'dd/mm/yyyy'),inp.valore,'S')), 
         f_CIV_cifre_lettere('D',to_char(tta.D_DATA_NAS_2,'dd/mm/yyyy'),inp.valore,'S')),
  -- testimoni_professione_2
       decode(tta.atto,'', nvl(tte.prof_2,'-'), ''), 
  -- testimoni_residenza_2
       decode(tta.atto,'', nvl(tte.residenza_2,'-'), 
         f_comune_al(tta.COD_PRO_RES_2,tta.COD_COM_RES_2,uci.data_mat)||
           decode(sign(tta.cod_pro_res_2-200),1,' '||f_provincia_stato_al(tta.cod_pro_res_2,tta.cod_com_res_2,null,'S','S',uci.data_mat))
       ),
  -- testimoni_cittadino_2
       decode(tta.atto,'', decode(tte.cittadino_2,'','-','cittadin'||tte.cittadino_2),
         decode(tta.sesso_2,'M','cittadino','F','cittadina','cittadinanza')),
  -- testimoni_nazionalita_2
       decode(tta.atto,'', nvl(tte.nazionalita_2,'-'), f_get_descrizione_DCI(tta.nazionalita_2,tta.sesso_2)),
-- testimoni_..._3
  -- testimoni_cognome_nome_3
       decode(tta.atto,'',null,
        rtrim(tta.cognome_3||' '||tta.nome_3)
       ),
  -- testimoni_nato_3
       decode(tta.atto,'',null, decode(tta.sesso_3,'M','o','F','a')),
  -- testimoni_comune_nas_3
       decode(tta.atto,'',null,  
         'in '||f_comune_al(tta.COD_PRO_NAS_3,tta.COD_COM_NAS_3,to_char(tta.D_DATA_NAS_3,'j'))||
           decode(sign(tta.cod_pro_res_3-200),1,' '||f_provincia_stato_al(tta.cod_pro_nas_3,tta.cod_com_nas_3,null,'S','S',to_char(tta.d_data_nas_3,'j')))
       ),
  -- testimoni_data_nas_3
       nvl(f_CIV_cifre_lettere('D',to_char(tta.D_DATA_NAS_3,'dd/mm/yyyy'),inp.valore,'S'),rpad('...',10,'_')),
  -- testimoni_professione_3
       to_char(null),
  -- testimoni_residenza_3
       decode(tta.atto,'', null, 
         f_comune_al(tta.COD_PRO_RES_3,tta.COD_COM_RES_3,uci.data_mat)||
         decode(sign(tta.cod_pro_res_3-200),1,' '||f_provincia_stato_al(tta.cod_pro_res_3,tta.cod_com_res_3,null,'S','S',uci.data_mat))
       ),
  -- testimoni_cittadino_3
       decode(tta.atto,'', null,
         decode(tta.sesso_3,'M','cittadino','F','cittadina','cittadinanza')),
  -- testimoni_nazionalita_3
       decode(tta.atto,'', null, f_get_descrizione_DCI(tta.nazionalita_3,tta.sesso_3)),
-- testimoni_..._4
  -- testimoni_cognome_nome_4
       decode(tta.atto,'',null, 
        rtrim(tta.cognome_4||' '||tta.nome_4)
       ),
  -- testimoni_nato_4
       decode(tta.atto,'',null, decode(tta.sesso_4,'M','o','F','a')),
  -- testimoni_comune_nas_4
       decode(tta.atto,'', null,
         'in '||f_comune_al(tta.COD_PRO_NAS_4,tta.COD_COM_NAS_4,to_char(tta.D_DATA_NAS_4,'j'))||
         decode(sign(tta.cod_pro_res_4-200),1,' '||f_provincia_stato_al(tta.cod_pro_nas_4,tta.cod_com_nas_4,null,'S','S',to_char(tta.d_data_nas_4,'j')))
       ),
  -- testimoni_data_nas_4
       nvl(f_CIV_cifre_lettere('D',to_char(tta.D_DATA_NAS_4,'dd/mm/yyyy'),inp.valore,'S'),rpad('...',10,'_')),
  -- testimoni_professione_4
       to_char(null),
  -- testimoni_residenza_4
       decode(tta.atto,'', null,
         f_comune_al(tta.COD_PRO_RES_4,tta.COD_COM_RES_4,uci.data_mat)||
         decode(sign(tta.cod_pro_res_4-200),1,' '||f_provincia_stato_al(tta.cod_pro_res_4,tta.cod_com_res_4,null,'S','S',uci.data_mat))
       ),
  -- testimoni_cittadino_4
       decode(tta.atto,'', null,
         decode(tta.sesso_4,'M','cittadino','F','cittadina','cittadinanza')),
  -- testimoni_nazionalita_4
       decode(tta.atto,'', null, f_get_descrizione_DCI(tta.nazionalita_4,tta.sesso_4)),
-- cognome_interprete
       sog_IT.cognome,
-- nome_interprete
       sog_IT.nome,
-- comune_nascita_interprete
       nvl(rtrim(f_comune_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,to_char(sog_IT.d_data_nas,'j'))||' '||
                 f_provincia_stato_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,null,'S','S',to_char(sog_IT.d_data_nas,'j'))),
           lpad('...',30,'_')
       ),
-- comune_residenza_interprete
       nvl(rtrim(f_comune_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,to_char(uci.d_data_mat,'j'))||' '||
                 f_provincia_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,null,'S','S',to_char(uci.d_data_mat,'j'))),
           lpad('...',30,'_')
       ),
-- data_nascita_interprete
       f_CIV_cifre_lettere('G',to_char(sog_IT.d_data_nas,'dd'),inp.valore,'')||' '||
             f_CIV_cifre_lettere('M',to_char(sog_IT.d_data_nas,'mm'),'','')||' '||
             f_CIV_cifre_lettere('A',to_char(sog_IT.d_data_nas,'yyyy'),'',''),
-- cognome_richiedente
       decode(cta.sigla, 'TEP', dpa.cognome_dic),
-- nome_richiedente
       decode(cta.sigla, 'TEP', dpa.nome_dic),
-- comune_nascita_richiedente
       decode(cta.sigla, 'TEP', 
         nvl(rtrim(f_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,to_char(dpa.d_data_nas_dic,'j'))||
                     decode(sign(dpa.cod_pro_nas_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,null,'S','S',to_char(dpa.d_data_nas_dic,'j')))),
             lpad('...',30,'_'))
       ),
-- comune_residenza_richiedente
       decode(cta.sigla, 'TEP',
         nvl(rtrim(f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,uci.data_mat)||
                     decode(sign(dpa.cod_pro_res_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,null,'S','S',uci.data_mat))),
             lpad('...',30,'_'))
             ),
-- data_nascita_richiedente
       decode(cta.sigla, 'TEP', decode(cta.sigla, 'TEP', f_CIV_cifre_lettere('D',to_char(dpa.d_data_nas_dic,'dd/mm/yyyy'),inp.valore,'S'))),
-- comune_data
       f_get_comune_cliente('DES_COM')||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
       f_get_comune_cliente('DES_COMUNE'),
-- data
       to_char(sysdate,'dd/mm/yyyy'),
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
-- ufficiale_utente
       nvl(f_CIV_campi_testata(-4,uci.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ufficiale_utente'),rpad('...',30,'_')),
-- avvocato_1
	decode(cta.flag_divorzio,'S', dpa.avvocato_sposo_cognome),
	decode(cta.flag_divorzio,'S', dpa.avvocato_sposo_nome),
-- avvocato_2
	decode(cta.flag_divorzio,'S', dpa.avvocato_sposa_cognome),
	decode(cta.flag_divorzio,'S', dpa.avvocato_sposa_nome),
-- nel_luogo_UNIONE
       'nel'||dpa.nel_mat||' '||nvl(dpa.luogo_mat,rpad('...',30,'_')),
-- luogo_UNIONE
       nvl(dpa.luogo_mat,rpad('...',30,'_')),
--
-- RIGA_ESTRATTO_1
       decode(pdo.COD_PRO_ESTRATTO_M||COD_COM_ESTRATTO_M||D_DATA_ESTRATTO_M,'','',
         'l''estratto e la copia integrale dell''atto di nascita rilasciati'||
         ' dal Comune di '||
            f_comune_al(pdo.cod_pro_estratto_m,pdo.cod_com_estratto_m,'')||' '||
            f_provincia_stato_al(pdo.cod_pro_estratto_m,pdo.cod_com_estratto_m,'','S','S','')||
         ' il '||to_char(pdo.d_data_estratto_m,'dd/mm/yyyy')),
-- COMUNE_ESTRATTO_1
       f_comune_al(pdo.cod_pro_estratto_m,pdo.cod_com_estratto_m,'')||' '||
         f_provincia_stato_al(pdo.cod_pro_estratto_m,pdo.cod_com_estratto_m,'','S','S',''),
-- DATA_ESTRATTO_1
       to_char(pdo.d_data_estratto_m,'dd/mm/yyyy'),
-- RIGA_CUMULATIVO_1
       decode(COD_PRO_CUMULATIVO_M||COD_COM_CUMULATIVO_M||D_DATA_CUMULATIVO_M,'','',
         'il certificato contestuale di residenza, cittadinanza, stato libero rilasciato'||
         ' dal Comune di '||
           f_comune_al(pdo.cod_pro_cumulativo_m,pdo.cod_com_cumulativo_m,'')||' '||
           f_provincia_stato_al(pdo.cod_pro_cumulativo_m,pdo.cod_com_cumulativo_m,'','S','S','')||
         ' il '||to_char(pdo.d_data_cumulativo_m,'dd/mm/yyyy')),
-- COMUNE_CUMULATIVO_1
       f_comune_al(pdo.cod_pro_cumulativo_m,pdo.cod_com_cumulativo_m,'')||' '||
         f_provincia_stato_al(pdo.cod_pro_cumulativo_m,pdo.cod_com_cumulativo_m,'','S','S',''),
-- DATA_CUMULATIVO_1
       to_char(pdo.d_data_cumulativo_m,'dd/mm/yyyy'),
-- RIGA_ESTRATTO_2
       decode(pdo.COD_PRO_ESTRATTO_F||COD_COM_ESTRATTO_F||D_DATA_ESTRATTO_F,'','',
         'l''estratto e la copia integrale dell''atto di nascita rilasciati'||
         ' dal Comune di '||
           f_comune_al(pdo.cod_pro_estratto_f,pdo.cod_com_estratto_f,'')||' '||
           f_provincia_stato_al(pdo.cod_pro_estratto_f,pdo.cod_com_estratto_f,'','S','S','')||
         ' il '||to_char(pdo.d_data_estratto_f,'dd/mm/yyyy')),
-- COMUNE_ESTRATTO_2
       f_comune_al(pdo.cod_pro_estratto_f,pdo.cod_com_estratto_f,'')||' '||
         f_provincia_stato_al(pdo.cod_pro_estratto_f,pdo.cod_com_estratto_f,'','S','S',''),
-- DATA_ESTRATTO_2
       to_char(pdo.d_data_estratto_f,'dd/mm/yyyy'),
-- RIGA_CUMULATIVO_2
       decode(COD_PRO_CUMULATIVO_F||COD_COM_CUMULATIVO_F||D_DATA_CUMULATIVO_F,'','',
         'il certificato contestuale di residenza, cittadinanza, stato libero rilasciato'||
         ' dal Comune di '||
           f_comune_al(pdo.cod_pro_cumulativo_f,pdo.cod_com_cumulativo_f,'')||' '||
           f_provincia_stato_al(pdo.cod_pro_cumulativo_f,pdo.cod_com_cumulativo_f,'','S','S','')||
         ' il '||to_char(pdo.d_data_cumulativo_f,'dd/mm/yyyy')),
-- COMUNE_CUMULATIVO_2
       f_comune_al(pdo.cod_pro_cumulativo_f,pdo.cod_com_cumulativo_f,'')||' '||
         f_provincia_stato_al(pdo.cod_pro_cumulativo_f,pdo.cod_com_cumulativo_f,'','S','S',''),
-- DATA_CUMULATIVO_2
       to_char(pdo.d_data_cumulativo_f,'dd/mm/yyyy'),
-- PRESA_VISIONE_DOCUMENTI
       nvl(rtrim(ltrim(
         decode(pdo.flag_documenti_prodotti,'','','prodottimi,')||
         decode(pdo.flag_documenti_acquisiti,'','',' da me acquisiti,')),','),
        '[] prodottimi [] da me acquisiti '),
--
-- avvocato_1
       translate(dpa.avvocato_sposo,'/',' '),
-- sede_avvocato_1
       nvl(dpa.sede_avvocato_sposo, '...__________'),
-- avvocato_2
       translate(dpa.avvocato_sposa,'/',' '),
-- sede_avvocato_2
       nvl(dpa.sede_avvocato_sposa, '...__________'),
-- accordo_data
       decode(dpa.accordo_data,'','',
         f_CIV_cifre_lettere('D',to_char(dpa.d_accordo_data,'dd/mm/yyyy'),inp.valore,'')),
-- atto_accordo
       decode(dpa.accordo_atto,'','',dpa.accordo_atto)||
         decode(dpa.accordo_parte,'','',1,' p.I',2,' p.II')||
         decode(dpa.accordo_anno,'','',' / '||dpa.accordo_anno),
-- accordo_comune
       nvl(rtrim(f_comune_al(dpa.accordo_cod_pro,dpa.accordo_cod_com,to_char(dpa.d_accordo_data,'j'))||' '||
                   f_provincia_stato_al(dpa.accordo_cod_pro,dpa.accordo_cod_com,'','S','S',to_char(dpa.d_accordo_data,'j'))),
         rpad('...',30,'_')),
-- accordo_estremi_atto
       decode(dpa.accordo_numero, 
         '', nvl(dpa.accordo_atto||
                   decode(dpa.accordo_parte,'','',' parte '||dpa.accordo_parte||'^')||
                   decode(dpa.accordo_anno,'','',' anno '||dpa.accordo_anno), '_____ parte 2^ anno _____'),
             dpa.accordo_numero),
-- conferma_data
       nvl(f_CIV_cifre_lettere('D',to_char(dpa.d_conferma_data,'dd/mm/yyyy'),inp.valore,'S'),'...__________'),
-- legge_convenzioni
       nvl(mar.legge_conv,'...__________'),
-- corpo_convenzioni
       decode(uci.convenzioni,'SI','Le parti, alla presenza degli stessi testimoni, '||
                                   'mi hanno dichiarato di scegliere il regime della '||
                                   'separazione dei beni, a norma dell''articolo 1, '||
                                   'comma 13, della legge n. 76, del 2016.'),
-- SEL_MAR
-- convenzioni patrimoniali
--Con dichiarazione resa nell'atto di unione civile tra persone dello stesso sesso controscritto,
--le persone da unire civilmente hanno dichiarato di scegliere la legge #1 #2 da applicare ai loro rapporti patrimoniali, 
--ai sensi dell'art. 32-ter, quarto comma, della legge 31 maggio 1995, n. 218.
       decode(uci.convenzioni,'SI',
         decode(mar.scelta_conv,2,
           'Con dichiarazione resa nell''atto'||
           ' di unione civile tra persone dello stesso sesso controscritto,'||
           ' le persone da unire civilmente hanno dichiarato di scegliere la legge '||nvl(mar.legge_conv_1,'italiana')||
           decode(mar.legge_conv_2,'','',' '||mar.legge_conv_2)||
           decode(mar.legge_conv_3,'','',' '||mar.legge_conv_3)||
           ' da applicare ai loro rapporti patrimoniali,'||
           ' ai sensi dell''art. 32-ter, quarto comma,'||
           ' della legge 31 maggio 1995, n. 218.',
          'Con dichiarazione resa nell''atto'||
          ' di unione civile controscritto,'||
          ' le persone da unire civilmente hanno'||
          ' scelto il regime della separazione dei beni.')),
       decode(uci.convenzioni,'SI',nvl(f_comune_al(uci.cod_pro_mat,uci.cod_com_mat,uci.data_mat),rpad('_',20,'_'))),
       decode(uci.convenzioni,'SI',', li '||nvl(to_char(to_date(uci.data_convenzioni,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))),
       decode(uci.convenzioni,'SI','L''UFFICIALE DELLO STATO CIVILE'),
       decode(uci.convenzioni,'SI',
         decode(uci.natura, 'T','F.to: '||nvl(dpa.UFFICIALE_PROV,rpad('_',24,'_')),
                                rpad('_',30,'_'))),
-- cambio_cognome_1
       decode(uci.cambio_cognome_m,'','',decode(occ.atto,'', translate(uci.cognome_nome_m,'/',' '), occ.cognome||' '||occ.nome)||
                                         ' ha assunto il nuovo cognome '||
                                         decode(uci.cambio_cognome_m,
                                           'A',uci.cognome_agg_m||' '||decode(occ.atto,'', substr(uci.cognome_nome_m,1,instr(uci.cognome_nome_m,'/')-1), occ.cognome),
                                           'P',decode(occ.atto,'', substr(uci.cognome_nome_m,1,instr(uci.cognome_nome_m,'/')-1), occ.cognome)||' '||uci.cognome_agg_m,
                                           'S',uci.cognome_agg_m)||
                                         ' come da dichiarazione resa'||
                                         ' nell''atto controscritto.'),
       decode(uci.cambio_cognome_m,'','','li '||nvl(to_char(to_date(uci.data_mat,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))),
       decode(uci.cambio_cognome_m,'','','L''UFFICIALE DELLO STATO CIVILE'),
       decode(uci.cambio_cognome_m,'','',
         decode(uci.natura, 'T', 'F.to: '||nvl(dpa.UFFICIALE_PROV,rpad('_',24,'_')),
                                 rpad('_',30,'_'))),
-- cambio_cognome_2
       decode(uci.cambio_cognome_f,'','',decode(occ.atto,'', translate(uci.cognome_nome_f,'/',' '), occ.cognome_cn||' '||occ.nome_cn)||
                                         ' ha assunto il nuovo cognome '||
                                         decode(uci.cambio_cognome_f,
                                           'A',uci.cognome_agg_f||' '||decode(occ.atto,'', substr(uci.cognome_nome_f,1,instr(uci.cognome_nome_f,'/')-1), occ.cognome_cn),
                                           'P',decode(occ.atto,'', substr(uci.cognome_nome_f,1,instr(uci.cognome_nome_f,'/')-1), occ.cognome_cn)||' '||uci.cognome_agg_f,
                                           'S',uci.cognome_agg_f)||
                                         ' come da dichiarazione resa'||
                                         ' nell''atto controscritto.'),
       decode(uci.cambio_cognome_f,'','','li '||nvl(to_char(to_date(uci.data_mat,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))),
       decode(uci.cambio_cognome_f,'','','L''UFFICIALE DELLO STATO CIVILE'),
       decode(uci.cambio_cognome_f,'','',
         decode(uci.natura, 'T', 'F.to: '||nvl(dpa.UFFICIALE_PROV,rpad('_',24,'_')),
                                 rpad('_',30,'_'))),
-- data_atto_originale
       f_CIV_cifre_lettere('D',to_char(to_date(dpa.data_atto_orig,'j'),'dd/mm/yyyy'),inp.valore,'') data_orig,
-- anno_atto_originale
       f_CIV_cifre_lettere('U',to_char(to_date(dpa.data_atto_orig,'j'),'yy'),'','') anno_orig,
-- mese_atto_originale
       f_CIV_cifre_lettere('M',to_char(to_date(dpa.data_atto_orig,'j'),'mm'),'','') mese_orig,
-- giorno_atto_originale
       f_CIV_cifre_lettere('G',to_char(to_date(dpa.data_atto_orig,'j'),'dd'),inp.valore,'') giorno_orig,
-- ore_atto_originale
       f_CIV_cifre_lettere('h',nvl(dpa.ore_atto_orig,'0'),'','') ore_orig,
-- minuti_atto_originale
       f_CIV_cifre_lettere('m',nvl(dpa.minuti_atto_orig,'0'),'','') minuti_orig,    
-- uci_prec_data
       nvl(f_CIV_cifre_lettere('D',to_char(spo.d_data_mat,'dd/mm/yyyy'),inp.valore,'S'),
         decode(f_get_flag_comune_utente(spo.cod_pro_atto_mat,spo.cod_com_atto_mat),
           'S', nvl(f_CIV_cifre_lettere('D',to_char(uci_prec.d_data_mat,'dd/mm/yyyy'),inp.valore,'S'),'...__________'),
                '...__________')
       ),
-- uci_prec_comune
       nvl(rtrim(f_comune_al(spo.cod_pro_mat,spo.cod_com_mat,to_char(spo.d_data_mat,'j'))||' '||
                 f_provincia_stato_al(spo.cod_pro_mat,spo.cod_com_mat,'','S','S',to_char(spo.d_data_mat,'j'))),
         decode(f_get_flag_comune_utente(spo.cod_pro_atto_mat,spo.cod_com_atto_mat),
           'S', nvl(rtrim(f_comune_al(uci_prec.cod_pro_mat,uci_prec.cod_com_mat,uci_prec.data_mat)||' '||
                          f_provincia_stato_al(uci_prec.cod_pro_mat,uci_prec.cod_com_mat,'','S','S',uci_prec.data_mat)), rpad('...',30,'_')),
                rpad('...',30,'_'))
       ),
-- uci_prec_comune_atto
       nvl(rtrim(f_comune_al(spo.cod_pro_atto_mat,spo.cod_com_atto_mat,'')||' '||
                   f_provincia_stato_al(spo.cod_pro_atto_mat,spo.cod_com_atto_mat,'','S','S','')),
           rpad('...',30,'_')),
-- uci_prec_estremi_atto
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '',       
         nvl(spo.atto_mat||
           decode(spo.parte_mat,'','',' parte '||spo.parte_mat||'^')||
           decode(spo.anno_atto_mat,'','',' anno '||spo.anno_atto_mat),'_____ parte _____ anno _____'),
         spo.id_atto_ansc_mat),
-- sentenza_tribunale
       decode(dpa.sentenza_tribunale, null, rpad('...',20,'_'), dpa.sentenza_tribunale),
-- sentenza_data
       decode(dpa.d_sentenza_data, null, '...__________', to_char(dpa.d_sentenza_data,'dd/mm/yyyy')),
-- luogo_fuori_casa
       decode(dpa.luogo_uci, null, rpad('...',20,'_'), dpa.luogo_uci),
-- segretario_comunale
       decode(dpa.segretario_utente, null, rpad('...',20,'_'), dpa.segretario_utente),
-- impossibilita_nominativo
       decode(dpa.impossibilitato_uci, 'C1', decode(occ.atto,'', translate(uci.cognome_nome_m,'/',' '), occ.cognome||' '||occ.nome), 'C2', decode(occ.atto,'', translate(uci.cognome_nome_f,'/',' '), occ.cognome_cn||' '||occ.nome_cn), '...__________'),
-- impossibilita_altro_contraente
       decode(dpa.impossibilitato_uci, 'C1', decode(occ.atto,'', translate(uci.cognome_nome_f,'/',' '), occ.cognome_cn||' '||occ.nome_cn), 'C2', decode(occ.atto,'', translate(uci.cognome_nome_m,'/',' '), occ.cognome||' '||occ.nome), '...__________'),
-- impossibilita_certificato
       decode(dpa.certificato_uci, null, '...__________', dpa.certificato_uci),
-- impossibilita_data_certific
       nvl(f_CIV_cifre_lettere('D',to_char(dpa.d_data_certificato_uci,'dd/mm/yyyy'),inp.valore,'S'),'...__________')
  from arcinp inp,
       civcta cta, civdta dta,
       anaana ana_1, anaana ana_2, civana ana, 
       civuci uci_prec,
       civocc occ, 
       civpdo pdo, civspo spo, civsog sog_IT,
       civtte tte, civtta tta,
       civdpa dpa, civmar mar, 
       civttr ttr, civtes tes,
       civuci uci
 where inp.parametro        = 'ATTI_PRIMO'
   and cta.id           (+) = dta.id_civcta
   and dta.id           (+) = uci.id_civdta
--
   and ana_1.matricola  (+) = ana.matricola_1
   and ana_2.matricola  (+) = ana.matricola_2
   and ana.id_atto      (+) = uci.id_atto
   and sog_IT.id_atto        (+) = uci.id_atto
   and sog_IT.tipo_soggetto  (+) = 'IT'
--
   and uci_prec.id_atto (+) = f_CIV_get_id_atto(spo.tipo_atto,spo.ufficio_mat,spo.anno_atto_mat,spo.parte_mat,spo.serie_mat,spo.atto_mat)
--
   and tta.id_atto      (+) = uci.id_atto
   and tte.id_atto      (+) = uci.id_atto
   and spo.id_atto      (+) = uci.id_atto
   and pdo.id_atto      (+) = uci.id_atto
   and dpa.id_atto      (+) = uci.id_atto
   and mar.id_atto      (+) = uci.id_atto
   and occ.id_atto      (+) = uci.id_atto
   and tes.id_atto      (+) = uci.id_atto
   and ttr.id_atto      (+) = uci.id_atto
--
   and uci.cod_rec          in (0,3)
/
comment on table civwuc_totale is 'Stato Civile - Variabili per composizione Processi Verbali e Atti di Unione Civile'
/