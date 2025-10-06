--liquibase formatted sql
--changeset snocca:202301021601 runAlways:true runOnChange:true stripComments:false
create or replace view civwma_totale
       (cod_rec, ufficio, anno, atto, parte, serie, natura,
        numero_atto_ansc,
        UFFICIO_ORIG, ANNO_ORIG, ATTO_ORIG, PARTE_ORIG, SERIE_ORIG,
        numero_atto_ansc_orig,
        ANNO_OGGI, MESE_OGGI,GIORNO_OGGI, ORE_OGGI, MINUTI_OGGI,
        DATA_MATRIMONIO, 
        ANNO_MATRIMONIO, MESE_MATRIMONIO, GIORNO_MATRIMONIO,
        COMUNE_MATRIMONIO,
        DATA_RICONCILIAZIONE,
        COGNOME_NOME_SPOSO, cognome_sposo, nome_sposo, 
        DATA_NASCITA_SPOSO, 
        ANNO_NASCITA_SPOSO, MESE_NASCITA_SPOSO, GIORNO_NASCITA_SPOSO,
        ATTO_NASCITA_SPOSO, COMUNE_NASCITA_SPOSO, COMUNE_ATTO_NASCITA_SPOSO, 
        COMUNE_RESIDENZA_SPOSO,
        NAZIONALITA_SPOSO, PROFESSIONE_SPOSO, STATO_CIVILE_SPOSO,
	COMPRENSIONE_SPOSO, MOTIVO_IMPEDIMENTO_SPOSO,
        COGNOME_NOME_SPOSA, cognome_sposa, nome_sposa,
        DATA_NASCITA_SPOSA, 
        ANNO_NASCITA_SPOSA, MESE_NASCITA_SPOSA, GIORNO_NASCITA_SPOSA,
        ATTO_NASCITA_SPOSA, COMUNE_NASCITA_SPOSA, COMUNE_ATTO_NASCITA_SPOSA, 
        COMUNE_RESIDENZA_SPOSA,
        NAZIONALITA_SPOSA, PROFESSIONE_SPOSA, STATO_CIVILE_SPOSA,
	COMPRENSIONE_SPOSA, MOTIVO_IMPEDIMENTO_SPOSA,
        COMUNE_DATA,COMUNE,DATA,
        autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	frazione_prov, autorita_prov_ufficio, nota_rif, anno_nota_rif, data_nota_rif,
	ufficiale_prov, qualifica_prov,
        protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
	ente_straniero, comune_ente_straniero, stato_ente_straniero, data_atto_ente_straniero,
	tipo_atto_ente_straniero, estremi_atto_ente_straniero, 
        ufficiale_utente,
        ministro,qualita_ministro_1,qualita_ministro_2,
        nel_luogo_matrimonio,luogo_matrimonio,
        legge_convenzioni,
        COMUNE_AFFISSIONE_PUB_1, DA_DATA_AFFISSIONE_PUB_1, A_DATA_AFFISSIONE_PUB_1,
        COMUNE_AFFISSIONE_PUB_2, DA_DATA_AFFISSIONE_PUB_2, A_DATA_AFFISSIONE_PUB_2,
        TIPO_DIVORZIO,
        AVVOCATO_SPOSO, SEDE_AVVOCATO_SPOSO, 
        AVVOCATO_SPOSA, SEDE_AVVOCATO_SPOSA, 
        DATA_ACCORDO_DIVORZIO, DATA_ACCORDO_DIVORZIO_ggmmaaaa, 
        ATTO_ACCORDO_DIVORZIO, COMUNE_ACCORDO_DIVORZIO,
        data_matrimonio_prec, comune_matrimonio_prec, 
        comune_atto_matrimonio_prec, dinanzi_matrimonio_prec, estremi_atto_matrimonio_prec,
        DATA_ATTO_ORIGINALE,ANNO_ATTO_ORIGINALE,MESE_ATTO_ORIGINALE,
        GIORNO_ATTO_ORIGINALE,ORE_ATTO_ORIGINALE,MINUTI_ATTO_ORIGINALE,
        ente_separazione,comune_separazione,data_doc_separazione,estremi_doc_separazione,
        provenienza_autorita, provenienza_comune, provenienza_frazione, 
        provenienza_nota_rif, provenienza_anno_nota_rif, provenienza_data_nota_rif,
        provenienza_protocollo, provenienza_anno_protocollo, provenienza_data_protocollo,
        accordo_data, accordo_comune, accordo_estremi_atto, 
        conferma_data,
        matrimonio_prec_data, matrimonio_prec_comune, 
        matrimonio_prec_comune_atto, matrimonio_prec_dinanzi, matrimonio_prec_estremi_atto, 
--
        citt_matrimonio_riga1, citt_matrimonio_riga2, citt_matrimonio_riga3, 
        citt_matrimonio_riga4, citt_matrimonio_riga5, citt_matrimonio_riga6, 
        citt_matrimonio_riga7, citt_matrimonio_riga8, citt_matrimonio_riga9, 
        citt_matrimonio_riga10, citt_matrimonio_riga11, citt_matrimonio_riga12, 
        citt_matrimonio_riga13, citt_matrimonio_riga14, citt_matrimonio_riga15,
        citt_matrimonio_riga16, citt_matrimonio_riga17, citt_matrimonio_riga18, 
        citt_matrimonio_riga19, citt_matrimonio_firma, citt_matrimonio_firma_mar,
        dati_finali_riga1, dati_finali_riga2, dati_finali_riga3,
        dati_finali_riga4, dati_finali_riga5, dati_finali_riga6,
        dati_finali_riga7, dati_finali_riga8, dati_finali_riga9,
        dati_finali_riga10, dati_finali_riga11, dati_finali_riga12,
        dati_matrimonio_anno, dati_matrimonio_giorno, dati_matrimonio_mese, 
        dati_matrimonio_ore, dati_matrimonio_minuti,
        dati_matrimonio_comune, dati_matrimonio_nel, dati_matrimonio_luogo,
        dati_matrimonio_rito_riga1, dati_matrimonio_rito_riga2, dati_matrimonio_rito_riga3,
        articoli_ministro_riga1, articoli_ministro_riga2, 
        pubblicazione_non, 
        pubblicazione_riga1, pubblicazione_riga2, pubblicazione_riga3, 
        pubblicazione_riga4, pubblicazione_riga5, pubblicazione_riga6, 
        richiesta_il, richiesta_documento, richiesta_descritto, richiesta_munito,                           
        richiesta_cognome_nome_sposa, richiesta_cognome_nome_sposo,                                   
        documenti_il, documenti_documento, documenti_presentato,
        documenti_riga1, documenti_riga2, documenti_riga3, 
        documenti_riga4, documenti_riga5, documenti_riga6,
        documenti_riga7, documenti_riga8, documenti_riga9, 
        documenti_riga10, documenti_riga11, documenti_riga12,
        chiusura_riga1, chiusura_riga2, chiusura_riga3, 
        chiusura_riga4, chiusura_riga5, chiusura_riga6,                                    
        chiusura_riga7, chiusura_riga8, chiusura_riga9, 
        chiusura_riga10, chiusura_riga11,
        trascrizione_anno, trascrizione_giorno, trascrizione_mese,
        trascrizione_ore, trascrizione_minuti, trascrizione_ufficiale,         
        trascrizione_comune, trascrizione_motivo, trascrizione_comune_orig,
        testata_anno, testata_giorno, testata_mese, 
        testata_ore, testata_minuti, testata_ufficiale, 
        testata_comune, testata_motivo,
        testata_ministro, testata_qualita_riga1, testata_qualita_riga2,
        sposi_cognome_m, sposi_nome_m,
        sposi_comune_nas_m, sposi_data_nas_m_riga1, sposi_data_nas_m_riga2,
        sposi_comune_atto_nas_m, sposi_atto_nas_m, sposi_parte_nas_m, sposi_serie_nas_m, sposi_anno_atto_nas_m,
        sposi_numero_atto_ansc_nas_m, 
        sposi_stato_civile_m, sposi_professione_m,
        sposi_residenza_m, sposi_cittadinanza_m,
        sposi_cognome_f, sposi_nome_f,
        sposi_comune_nas_f, sposi_data_nas_f_riga1, sposi_data_nas_f_riga2,
        sposi_comune_atto_nas_f, sposi_atto_nas_f, sposi_parte_nas_f, sposi_serie_nas_f, sposi_anno_atto_nas_f,
        sposi_numero_atto_ansc_nas_f, 
        sposi_stato_civile_f, sposi_professione_f,
        sposi_residenza_f, sposi_cittadinanza_f,
        cognome_nome_officiante,
        COGNOME_INTERPRETE, NOME_INTERPRETE, COMUNE_NASCITA_INTERPRETE, COMUNE_RESIDENZA_INTERPRETE, DATA_NASCITA_INTERPRETE,
        COGNOME_RICHIEDENTE, NOME_RICHIEDENTE, COMUNE_NASCITA_RICHIEDENTE, COMUNE_RESIDENZA_RICHIEDENTE, DATA_NASCITA_RICHIEDENTE,
        testimoni_cognome_nome_1, testimoni_nato_1, testimoni_comune_nas_1,
        testimoni_data_nas_1, testimoni_professione_1, testimoni_residenza_1,
        testimoni_cognome_nome_2, testimoni_nato_2, testimoni_comune_nas_2,
        testimoni_data_nas_2, testimoni_professione_2, testimoni_residenza_2,
	testimoni_cognome_nome_3, testimoni_nato_3, testimoni_comune_nas_3,
        testimoni_data_nas_3, testimoni_professione_3, testimoni_residenza_3,
	testimoni_cognome_nome_4, testimoni_nato_4, testimoni_comune_nas_4,
        testimoni_data_nas_4, testimoni_professione_4, testimoni_residenza_4,
        margine_tramsesso_data, margine_trasmesso_anno,
        margine_trasmesso_ministro_1, margine_trasmesso_ministro_2, margine_trasmesso_ministro_1_2,
        margine_trasmesso, margine_trasmesso_ufficiale, margine_trasmesso_firma,
        margine_trascritto_comune_1, margine_trascritto_atto_1,
        margine_trascritto_parte_1, margine_trascritto_serie_1,
        margine_trascritto_anno_1,
        margine_trascritto_data_com_1, margine_trascritto_num_com_1,
        margine_trascritto_com_firma_1, margine_trascritto_data_1,
        margine_trascritto_1, 
        margine_trascritto_li_data_1,
        margine_trascritto_ufficiale_1, margine_trascritto_firma_1,
        margine_trascritto_comune_2, margine_trascritto_atto_2,
        margine_trascritto_parte_2, margine_trascritto_serie_2,
        margine_trascritto_anno_2,
        margine_trascritto_data_com_2, margine_trascritto_num_com_2,
        margine_trascritto_com_firma_2, margine_trascritto_data_2,
        margine_trascritto_2, 
        margine_trascritto_li_data_2,
        margine_trascritto_ufficiale_2, margine_trascritto_firma_2,
        margine_convenzioni, 
        margine_convenzioni_comune, margine_convenzioni_li_data, 
        margine_convenzioni_ufficiale, margine_convenzioni_firma,
        margine_libretto, margine_libretto_li_data, 
        margine_libretto_ufficiale, margine_libretto_firma
       )
AS 
SELECT mat.cod_rec, mat.ufficio, mat.anno, mat.atto, mat.parte, mat.serie, mat.natura,
       f_CIV_numero_atto_ansc(mat.id_atto_ansc),
-- estremi atto originale
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.ufficio_orig), 
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.anno_orig), 
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', to_char(dpa.atto_orig), dpa.id_atto_ansc_orig),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', decode(dpa.parte_orig,'',to_char(null),1,'I',2,'II')),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.serie_orig),
       f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig),
-- anno_oggi
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'anno_oggi'),
-- mese_oggi
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'mese_oggi'),
-- giorno_oggi
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'giorno_oggi'),
-- ore_oggi
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ore_oggi'),
-- minuti_oggi
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'minuti_oggi'),
-- data_matrimonio
       decode(mat.flag_GG_imprecisato,'S','',f_CIV_cifre_lettere('G',to_char(mat.d_data_mat,'dd'),inp.valore,'')||' ')||
         decode(mat.flag_MM_imprecisato,'S','',f_CIV_cifre_lettere('M',to_char(mat.d_data_mat,'mm'),'','')||' ')||
         decode(mat.flag_AA_imprecisato,'S','imprecisata',f_CIV_cifre_lettere('A',to_char(mat.d_data_mat,'yyyy'),'','')||' '),
-- anno_matrimonio
       decode(mat.flag_AA_imprecisato,'S','IMPRECISATO',f_CIV_cifre_lettere('A',to_char(mat.d_data_mat,'yyyy'),'','')),
-- mese_matrimonio
       decode(mat.flag_MM_imprecisato,'S','IMPRECISATO',f_CIV_cifre_lettere('M',to_char(mat.d_data_mat,'mm'),'','')),
-- giorno_matrimonio
       decode(mat.flag_GG_imprecisato,'S','IMPRECISATO',f_CIV_cifre_lettere('G',to_char(mat.d_data_mat,'dd'),inp.valore,'')),
-- comune_matrimonio
       f_comune_al(mat.cod_pro_mat,mat.cod_com_mat,mat.data_mat)||' '||f_provincia_stato_al(mat.cod_pro_mat,mat.cod_com_mat,null,'S','S',mat.data_mat),
-- data_riconciliazione
       decode(cta.sigla, 'RCN',
         decode(mat.flag_GG_imprecisato,'S','',f_CIV_cifre_lettere('G',to_char(mat.d_data_mat,'dd'),inp.valore,'')||' ')||
           decode(mat.flag_MM_imprecisato,'S','',f_CIV_cifre_lettere('M',to_char(mat.d_data_mat,'mm'),'','')||' ')||
           decode(mat.flag_AA_imprecisato,'S','imprecisata',f_CIV_cifre_lettere('A',to_char(mat.d_data_mat,'yyyy'),'','')||' ')),
-- cognome_nome_m
       decode(occ.atto,'', translate(mat.cognome_nome_m,'/',' '), occ.cognome||' '||occ.nome),
-- cognome_m
       decode(occ.atto,'', nvl(rtrim(spo.cognome_m), mat.cognome_m), occ.cognome),
-- nome_m
       decode(occ.atto,'', nvl(rtrim(spo.nome_m), mat.nome_m), occ.nome),
-- data_nascita_m
       decode(mat.data_nas_m,'',
         decode(mat.anni_m,'','','di anni '||f_CIV_cifre_lettere('U',mat.anni_m,'','S')),
         f_CIV_cifre_lettere('D',to_char(mat.d_data_nas_m,'dd/mm/yyyy'),inp.valore,'S')
       ),
-- anno_nascita_m
       f_CIV_cifre_lettere('A',to_char(mat.d_data_nas_m,'yyyy'),'','S'),
-- mese_nascita_m
       f_CIV_cifre_lettere('M',to_char(mat.d_data_nas_m,'mm'),'','S'),
-- giorno_nascita_m
       f_CIV_cifre_lettere('G',to_char(mat.d_data_nas_m,'mm'),inp.valore,'S'),
-- atto_nascita_m
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
         'Atto N. '||nvl(to_char(spo.atto_nas_m),'____')||
           ' P. '||decode(spo.parte_nas_m,'1','I','2','II',nvl(spo.parte_nas_m,'__'))||
           ' S. '||nvl(spo.serie_nas_m,'__')||
           ' - '||nvl(to_char(spo.anno_atto_nas_m),'____'),
         'Atto N. '||spo.id_atto_ansc_nas_m),
-- comune_nascita_m
       nvl(rtrim(f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m)||' '||
                 f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,null,'S','S',mat.data_nas_m)),
           rpad('...',30,'_')
       ),
-- comune_atto_nascita_m
       nvl(decode(spo.cod_pro_atto_nas_m,'',
             rtrim(f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m)||' '||
                 f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,null,'S','S',mat.data_nas_m)),
             rtrim(f_comune_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,mat.data_nas_m)||' '||
                 f_provincia_stato_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,null,'S','S',mat.data_nas_m))),
           rpad('...',30,'_')
       ),
-- comune_residenza_m
       nvl(rtrim(f_comune_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.data_mat)||' '||
                 f_provincia_stato_al(mat.cod_pro_res_m,mat.cod_com_res_m,null,'S','S',mat.data_mat)),
           rpad('...',30,'_')
       ),
-- nazionalita_m
       nvl(lower(f_get_descrizione_DCI(mat.nazionalita_m,'')),rpad('...',20,'_')),
-- professione_m
       rpad('...',20,'_'),
-- stato_civile_m
       nvl(lower(f_get_descrizione_DSC(ana_1.stato_civile,'M','','','S')),'celibe'),
-- comprensione_m
       f_CIV_comprensione(mat.comprensione_m, 'M'),
-- motivo_impedimento_m
       decode(mat.comprensione_m, '', null, mat.motivo_impedimento_m),
-- cognome_nome_f
       decode(occ.atto,'', translate(mat.cognome_nome_f,'/',' '), occ.cognome_cn||' '||occ.nome_cn),
-- cognome_f
       decode(occ.atto,'', nvl(rtrim(spo.cognome_f), mat.cognome_f), occ.cognome_cn),
-- nome_f
       decode(occ.atto,'', nvl(rtrim(spo.nome_f), mat.nome_f), occ.nome_cn), 
-- data_nascita_f
       decode(mat.data_nas_f,'',
         decode(mat.anni_f,'','','di anni '||f_CIV_cifre_lettere('U',mat.anni_f,'','S')),
         f_CIV_cifre_lettere('D',to_char(mat.d_data_nas_f,'dd/mm/yyyy'),inp.valore,'S')
       ),
-- anno_nascita_f
       f_CIV_cifre_lettere('A',to_char(mat.d_data_nas_f,'yyyy'),'','S'),
-- mese_nascita_f
       f_CIV_cifre_lettere('M',to_char(mat.d_data_nas_f,'mm'),'','S'),
-- giorno_nascita_f
       f_CIV_cifre_lettere('G',to_char(mat.d_data_nas_f,'dd'),inp.valore,'S'),
-- atto_nascita_f
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '',
         'Atto N. '||nvl(to_char(spo.atto_nas_f),'____')||
           ' P. '||decode(spo.parte_nas_f,'1','I','2','II',nvl(spo.parte_nas_f,'__'))||
           ' S. '||nvl(spo.serie_nas_f,'__')||
           ' - '||nvl(to_char(spo.anno_atto_nas_f),'____'),
         'Atto N. '||spo.id_atto_ansc_nas_f),
-- comune_nascita_f
       nvl(rtrim(f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f)||' '||
                 f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,null,'S','S',mat.data_nas_f)),
           rpad('...',30,'_')
       ),
-- comune_atto_nascita_f
       nvl(decode(spo.cod_pro_atto_nas_f,'',
             rtrim(f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f)||' '||
                 f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,null,'S','S',mat.data_nas_f)),
             rtrim(f_comune_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,mat.data_nas_f)||' '||
                 f_provincia_stato_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,null,'S','S',mat.data_nas_f))),
           rpad('...',30,'_')
       ),
-- comune_residenza_f
       nvl(rtrim(f_comune_al(mat.cod_pro_res_f,mat.cod_com_res_f,mat.data_mat)||' '||
                 f_provincia_stato_al(mat.cod_pro_res_f,mat.cod_com_res_f,null,'S','S',mat.data_mat)),
           rpad('...',30,'_')
       ),
-- nazionalita_f
       nvl(lower(f_get_descrizione_DCI(mat.nazionalita_f,'')),rpad('...',20,'_')),
-- professione_f
       rpad('...',20,'_'),
-- stato_civile_f
       nvl(lower(f_get_descrizione_DSC(ana_2.stato_civile,'F','','','S')),'nubile'),
-- comprensione_f
       f_CIV_comprensione(mat.comprensione_f, 'F'),
-- motivo_impedimento_f
       decode(mat.comprensione_f, '', null, mat.motivo_impedimento_f),
-- comune_data
       f_get_comune_cliente('DES_COM')||', '||to_char(sysdate,'dd/mm/yyyy'),
       f_get_comune_cliente('DES_COMUNE'),
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
       nvl(f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ufficiale_utente'),rpad('...',30,'_')),
-- ministro
       nvl(dpa.ministro,rpad('...',30,'_')),
-- qualita_ministro_1
       nvl(dpa.qualita_1,rpad('...',30,'_')),
-- qualita_ministro_2
       nvl(dpa.qualita_2,rpad('...',30,'_')),
-- nel_luogo_matrimonio
       'nel'||dpa.nel_mat||' '||nvl(dpa.luogo_mat,rpad('...',30,'_')),
-- luogo_matrimonio
       nvl(dpa.luogo_mat,rpad('...',30,'_')),
-- legge_convenzioni
       nvl(mar.legge_conv,'...__________'),
-- COMUNE_AFFISSIONE_PUB_1
       mar.comune_aff_1,
-- DA_DATA_AFFISSIONE_PUB_1
       to_char(to_date(mar.da_data_aff_1,'j'),'dd/mm/yyyy'),
-- A_DATA_AFFISSIONE_PUB_1
       to_char(to_date(mar.a_data_aff_1,'j'),'dd/mm/yyyy'),
-- COMUNE_AFFISSIONE_PUB_2
       mar.comune_aff_2,
-- DA_DATA_AFFISSIONE_PUB_2
       to_char(to_date(mar.da_data_aff_2,'j'),'dd/mm/yyyy'),
-- A_DATA_AFFISSIONE_PUB_2
       to_char(to_date(mar.a_data_aff_2,'j'),'dd/mm/yyyy'),
-- TIPO_DIVORZIO
       decode(dpa.tipo_divorzio,
         'C', 'CESSAZIONE DEGLI EFFETTI CIVILI DEL MATRIMONIO',
         'S', 'SCIOGLIMENTO DEL MATRIMONIO',
         'X', 'SEPARAZIONE PERSONALE',
              'SEPARAZIONE PERSONALE (oppure CESSAZIONE DEGLI EFFETTI CIVILI/SCIOGLIMENTO DEL MATRIMONIO)'
       ),
-- AVVOCATO_SPOSO
       dpa.avvocato_sposo,
-- SEDE_AVVOCATO_SPOSO
       dpa.sede_avvocato_sposo,
-- AVVOCATO_SPOSA
       dpa.avvocato_sposa,
-- SEDE_AVVOCATO_SPOSA
       dpa.sede_avvocato_sposa,
-- DATA_ACCORDO_DIVORZIO
       decode(dpa.accordo_data,'','...__________',
         f_CIV_cifre_lettere('D',to_char(dpa.D_ACCORDO_DATA,'dd/mm/yyyy'),inp.valore,'S')
       ),
-- DATA_ACCORDO_DIVORZIO_GGMMAAA
       nvl(to_char(dpa.d_accordo_data,'dd/mm/yyyy'),'...__________'),
-- ATTO_ACCORDO_DIVORZIO
       decode(dpa.accordo_numero,'',
         decode(dpa.accordo_atto,'',
           decode(f_CIV_numero_atto_ansc(dpa.accordo_id_atto_ansc),'','',
             dpa.accordo_id_atto_ansc),
           decode(f_CIV_numero_atto_ansc(dpa.accordo_id_atto_ansc),'',
             'Atto N. '||dpa.accordo_atto||
               ' P. '||decode(dpa.accordo_parte,'1','I','2','II')||
               ' S. '||dpa.accordo_serie||
                ' - '||dpa.accordo_anno),
             'Atto N. '||dpa.accordo_id_atto_ansc),
         dpa.accordo_numero
       ),
-- comune_ACCORDO_DIVORZIO
       nvl(rtrim(f_comune_al(dpa.accordo_cod_pro,dpa.accordo_cod_com,dpa.accordo_data)||' '||
                 f_provincia_stato_al(dpa.accordo_cod_pro,dpa.accordo_cod_com,'','S','S',dpa.accordo_data)),
           '...__________'
       ),
-- data_matrimonio_prec
       nvl(f_CIV_cifre_lettere('D',to_char(spo.d_data_mat,'dd/mm/yyyy'),inp.valore,'S'),
         decode(f_get_flag_comune_utente(spo.cod_pro_atto_mat,spo.cod_com_atto_mat), 
           'S', nvl(f_CIV_cifre_lettere('D',to_char(mat_prec.d_data_mat,'dd/mm/yyyy'),inp.valore,'S'),'...__________'),
                '...__________')
       ),
-- comune_matrimonio_prec
       nvl(rtrim(f_comune_al(spo.cod_pro_mat,spo.cod_com_mat,to_char(spo.d_data_mat,'j'))||' '||
                          f_provincia_stato_al(spo.cod_pro_mat,spo.cod_com_mat,'','S','S',to_char(spo.d_data_mat,'j'))),
         decode(f_get_flag_comune_utente(spo.cod_pro_atto_mat,spo.cod_com_atto_mat),
           'S', nvl(rtrim(f_comune_al(mat_prec.cod_pro_mat,mat_prec.cod_com_mat,mat_prec.data_mat)||' '||
                          f_provincia_stato_al(mat_prec.cod_pro_mat,mat_prec.cod_com_mat,'','S','S',mat_prec.data_mat)),rpad('...',30,'_')),
                rpad('...',30,'_'))
       ),
-- comune_atto_matrimonio_prec
       nvl(rtrim(f_comune_al(spo.cod_pro_atto_mat,spo.cod_com_atto_mat,'')||' '||
                   f_provincia_stato_al(spo.cod_pro_atto_mat,spo.cod_com_atto_mat,'','S','S','')),rpad('...',30,'_')),
-- dinanzi_matrimonio_prec
       nvl(spo.officiante_mat,
         decode(f_get_flag_comune_utente(spo.cod_pro_atto_mat,spo.cod_com_atto_mat),
           'S', nvl(nvl(dpa_prec.ministro_art,nvl(dpa_prec.ufficiale_prov,dpa_prec.ufficiale_utente)),rpad('...',20,'_')),
                rpad('...',20,'_'))
       ),
-- estremi_atto_matrimonio_prec
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat),'',
         nvl(spo.atto_mat||
           decode(spo.parte_mat,'','',' parte '||spo.parte_mat||'^')||
           decode(spo.serie_mat,'','',' serie '||spo.serie_mat)||
           decode(spo.anno_atto_mat,'','',' anno '||spo.anno_atto_mat),'_____ parte _____ serie _____ anno _____'),
         spo.id_atto_ansc_mat),
-- data_atto_originale
       f_CIV_cifre_lettere('D',to_char(to_date(dpa.data_atto_orig,'j'),'dd/mm/yyyy'),'',''),
-- anno_atto_originale
       f_CIV_cifre_lettere('A',to_char(to_date(dpa.data_atto_orig,'j'),'yyyy'),'',''),
-- mese_atto_originale
       f_CIV_cifre_lettere('M',to_char(to_date(dpa.data_atto_orig,'j'),'mm'),'',''),
-- giorno_atto_originale
       f_CIV_cifre_lettere('G',to_char(to_date(dpa.data_atto_orig,'j'),'dd'),'',''),
-- ore_atto_originale
       f_CIV_cifre_lettere('h',dpa.ore_atto_orig,'',''),
-- minuti_atto_originale
       f_CIV_cifre_lettere('m',dpa.minuti_atto_orig,'',''),
-- ente_separazione
       dpa.separazione_ente,
-- comune_separazione
       rtrim(f_comune_al(dpa.separazione_cod_pro, dpa.separazione_cod_com, '')||' '||
             f_provincia_stato_al(dpa.separazione_cod_pro, dpa.separazione_cod_com,'','S','S','')),
-- data_doc_separazione
       to_char(dpa.d_separazione_data_doc,'dd/mm/yyyy'),
-- estremi_doc_separazione
       dpa.separazione_estremi_doc,
--
-- provenienza_autorita
       dpa.autorita_prov,
-- provenienza_comune
       dpa.comune_prov,
-- provenienza_frazione
       dpa.frazione_prov,
-- provenienza_nota_rif
       dpa.nota_rif,
-- provenienza_anno_nota_rif
       dpa.anno_nota_rif,
-- provenienza_data_nota_rif
       to_char(to_date(dpa.data_nota_rif,'j'),'dd/mm/yyyy'),
-- provenienza_protocollo
       dpa.protocollo,
-- provenienza_anno_protocollo
       dpa.anno_protocollo,
-- provenienza_data_protocollo
       to_char(to_date(dpa.data_protocollo,'j'),'dd/mm/yyyy'),
-- accordo_data
       nvl(f_CIV_cifre_lettere('D',to_char(dpa.d_accordo_data,'dd/mm/yyyy'),inp.valore,'S'),'...__________'),
-- accordo_comune
       nvl(rtrim(f_comune_al(dpa.accordo_cod_pro,dpa.accordo_cod_com,to_char(dpa.d_accordo_data,'j'))||' '||
                 f_provincia_stato_al(dpa.accordo_cod_pro,dpa.accordo_cod_com,'','S','S',to_char(dpa.d_accordo_data,'j'))),
           '...__________'
       ),
-- accordo_estremi_atto
       decode(dpa.accordo_numero, '', 
         decode(f_CIV_numero_atto_ansc(dpa.accordo_id_atto_ansc),'',
           nvl(dpa.accordo_atto||
             decode(dpa.accordo_parte,'','',' parte '||dpa.accordo_parte||'^')||
             decode(dpa.accordo_serie,'','',' serie '||dpa.accordo_serie)||
             decode(dpa.accordo_anno,'','',' anno '||dpa.accordo_anno), '_____ parte 2^ serie C anno _____'),
           dpa.accordo_id_atto_ansc),
         dpa.accordo_numero),
-- conferma_data
       nvl(f_CIV_cifre_lettere('D',to_char(dpa.d_conferma_data,'dd/mm/yyyy'),inp.valore,'S'),'...__________'),
-- matrimonio_prec_data
       nvl(f_CIV_cifre_lettere('D',to_char(spo.d_data_mat,'dd/mm/yyyy'),inp.valore,'S'),
         decode(f_get_flag_comune_utente(spo.cod_pro_atto_mat,spo.cod_com_atto_mat),
           'S', nvl(f_CIV_cifre_lettere('D',to_char(mat_prec.d_data_mat,'dd/mm/yyyy'),inp.valore,'S'),'...__________'),
                '...__________')
       ),
-- matrimonio_prec_comune
       nvl(rtrim(f_comune_al(spo.cod_pro_mat,spo.cod_com_mat,to_char(spo.d_data_mat,'j'))||' '||
                          f_provincia_stato_al(spo.cod_pro_mat,spo.cod_com_mat,'','S','S',to_char(spo.d_data_mat,'j'))),
         decode(f_get_flag_comune_utente(spo.cod_pro_atto_mat,spo.cod_com_atto_mat),
           'S', nvl(rtrim(f_comune_al(mat_prec.cod_pro_mat,mat_prec.cod_com_mat,mat_prec.data_mat)||' '||
                          f_provincia_stato_al(mat_prec.cod_pro_mat,mat_prec.cod_com_mat,'','S','S',mat_prec.data_mat)),rpad('...',30,'_')),
                rpad('...',30,'_'))
       ),
-- matrimonio_prec_comune_atto
       nvl(rtrim(f_comune_al(spo.cod_pro_atto_mat,spo.cod_com_atto_mat,'')||' '||
                   f_provincia_stato_al(spo.cod_pro_atto_mat,spo.cod_com_atto_mat,'','S','S','')),rpad('...',30,'_')),
-- matrimonio_prec_dinanzi
       nvl(spo.officiante_mat,
         decode(f_get_flag_comune_utente(spo.cod_pro_atto_mat,spo.cod_com_atto_mat),
           'S', nvl(nvl(dpa_prec.ministro_art,nvl(dpa_prec.ufficiale_prov,dpa_prec.ufficiale_utente)),rpad('...',20,'_')),
                rpad('...',20,'_'))
       ),
-- matrimonio_prec_estremi_atto
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat),'',
         nvl(spo.atto_mat||
           decode(spo.parte_mat,'','',' parte '||spo.parte_mat||'^')||
           decode(spo.serie_mat,'','',' serie '||spo.serie_mat)||
           decode(spo.anno_atto_mat,'','',' anno '||spo.anno_atto_mat),'_____ parte _____ serie _____ anno _____'),
         spo.id_atto_ansc_mat),
-- citt_matrimonio_...
       nvl(cma.riga1,'-'), nvl(cma.riga2,'-'), nvl(cma.riga3,'-'),
       nvl(cma.riga4,'-'), nvl(cma.riga5,'-'), nvl(cma.riga6,'-'),
       nvl(cma.riga7,'-'), nvl(cma.riga8,'-'), nvl(cma.riga9,'-'),
       nvl(cma.riga10,'-'), nvl(cma.riga11,'-'), nvl(cma.riga12,'-'),
       nvl(cma.riga13,'-'), nvl(cma.riga14,'-'), nvl(cma.riga15,'-'),
       nvl(cma.riga16,'-'), nvl(cma.riga17,'-'), nvl(cma.riga18,'-'),
       nvl(cma.riga19,'-'), 
-- citt_matrimonio_firma
       cma.firma, 
-- citt_matrimonio_firma_mar
       rtrim(cma.firma),
-- dati_finali_...
       nvl(dfi.riga1,'-'), nvl(dfi.riga2,'-'), nvl(dfi.riga3,'-'),
       nvl(dfi.riga4,'-'), nvl(dfi.riga5,'-'), nvl(dfi.riga6,'-'),
       nvl(dfi.riga7,'-'), nvl(dfi.riga8,'-'), nvl(dfi.riga9,'-'),
       nvl(dfi.riga10,'-'), nvl(dfi.riga11,'-'), nvl(dfi.riga12,'-'),
-- dati_matrimonio_...
-- dati_matrimonio_anno
       f_CIV_cifre_lettere('A',to_char(to_date(mat.data_mat,'j'),'yyyy'),'',''),
-- dati_matrimonio_giorno
       f_CIV_cifre_lettere('G',to_char(to_date(mat.data_mat,'j'),'dd'),inp.valore,''),
-- dati_matrimonio_mese
       f_CIV_cifre_lettere('M',to_char(to_date(mat.data_mat,'j'),'mm'),'',''),       
-- dati_matrimonio_ore
       f_CIV_cifre_lettere('h',mat.ore,'',''),
-- dati_matrimonio_minuti
       f_CIV_cifre_lettere('m',mat.minuti,'',''),
-- dati_matrimonio_comune
       nvl(f_comune_al(mat.cod_pro_mat, mat.cod_com_mat, mat.data_mat),rpad('...',30,'_')),
-- dati_matrimonio_nel
       decode(dpa.luogo_mat,'', dma.nel, dpa.nel_mat),
-- dati_matrimonio_luogo
       decode(dpa.luogo_mat,'', dma.luogo_mat, dpa.luogo_mat),
-- dati_matrimonio_rito_riga1
       decode(dpa.rito,'', nvl(dma.rito1,'-'), initcap(dpa.rito)),
-- dati_matrimonio_rito_riga2
       decode(dpa.rito,'', nvl(dma.rito2,'-'), ''),
-- dati_matrimonio_rito_riga3
       decode(dpa.rito,'', nvl(dma.rito3,'-'), ''),
-- articoli_...
-- articoli_ministro_riga1
       decode(dpa.ministro_art,'', nvl(art.ministro1,'-'), dpa.ministro_art),   
-- articoli_ministro_riga2
       decode(dpa.ministro_art,'', nvl(art.ministro2,'-'), ''),
-- pubblicazione_...
-- pubblicazione_non, 
       decode(dpa.ministro_art,'', nvl(art.non,'-'),
         decode(mar.documenti_presentati_mat,'OME','non','')
       ),
-- pubblicazione_riga1
       decode(dpa.ministro_art,'', nvl(art.riga1,'-'), ''),
-- pubblicazione_riga2
       decode(dpa.ministro_art,'', nvl(art.riga2,'-'), ''),
-- pubblicazione_riga3
       decode(dpa.ministro_art,'', nvl(art.riga3,'-'), ''),
-- pubblicazione_riga4
       decode(dpa.ministro_art,'', nvl(art.riga4,'-'), ''),
-- pubblicazione_riga5
       decode(dpa.ministro_art,'', nvl(art.riga5,'-'), ''),
-- pubblicazione_riga6
       decode(dpa.ministro_art,'', nvl(art.riga6,'-'), ''),
-- richiesta_...
		nvl(rma.il,'-'), nvl(rma.documento,'-'), nvl(rma.descritto,'-'),       
               	nvl(rma.munito,'-'), 
--       nvl(rma.cognome_nome_f,'-'), nvl(rma.cognome_nome_m,'-'), 
       decode(rma.cognome_nome_f,'',
         decode(occ.atto,'', translate(mat.cognome_nome_f,'/',' '), occ.cognome_cn||' '||occ.nome_cn),
         rma.cognome_nome_f),
       decode(rma.cognome_nome_m,'',
         decode(occ.atto,'', translate(mat.cognome_nome_m,'/',' '), occ.cognome||' '||occ.nome),
         rma.cognome_nome_m),
-- documenti_...
-- documenti_il
       decode(mar.documenti_presentati_mat,'', nvl(doc.il,'-'), 'UNO','l', 'OME','l', ''), 
-- documenti_documento
       decode(mar.documenti_presentati_mat,'', nvl(doc.documento,'-'), 'UNO','o','OME','o','i'),
-- documenti_presentato
       decode(mar.documenti_presentati_mat,'', nvl(doc.presentato,'_'), 'UNO','o','OME','o','i'),
-- documenti_riga1
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga1,'-'), ''),
-- documenti_riga2
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga2,'-'), ''),
-- documenti_riga3
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga3,'-'), ''),
-- documenti_riga4
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga4,'-'), ''),
-- documenti_riga5
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga5,'-'), ''),
-- documenti_riga6
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga6,'-'), ''),
-- documenti_riga7
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga7,'-'), ''),
-- documenti_riga8
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga8,'-'), ''),
-- documenti_riga9
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga9,'-'), ''),
-- documenti_riga10
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga10,'-'), ''),
-- documenti_riga11
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga11,'-'), ''),
-- documenti_riga12 ''),
       decode(mar.documenti_presentati_mat,'', nvl(doc.riga12,'-'), ''),
-- chiusura_...
               	nvl(chi.riga1,'-'), nvl(chi.riga2,'-'), nvl(chi.riga3,'-'),
               	nvl(chi.riga4,'-'), nvl(chi.riga5,'-'), nvl(chi.riga6,'-'),
               	nvl(chi.riga7,'-'), nvl(chi.riga8,'-'), nvl(chi.riga9,'-'),
               	nvl(chi.riga10,'-'), nvl(chi.riga11,'-'),
-- trascrizione_...
-- trascrizione_anno
       decode(trunc(to_char(dpa.d_data_atto_utente,'yyyy')/100),
           '',decode(sign(50 - nvl(f_CIV_lettere_cifre(ttr.anno_tr),0)),-1,'millenovecento','duemila'),
         '18','milleottocento',
         '19','millenovecento',
         '20','duemila',
         '21','duemilacento')||
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'anno_tr'),
-- trascrizione_giorno
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'giorno_tr'),
-- trascrizione_mese
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'mese_tr'),
-- trascrizione_ore
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ore_tr'),
-- trascrizione_minuti
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'minuti_tr'),
-- trascrizione_ufficiale
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ufficiale_tr'),
-- trascrizione_comune
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'comune_tr'),
-- trascrizione_motivo
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'motivo_tr'),
-- trascrizione_comune_orig
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'comune_or'),
-- testata_...
-- testata_anno
       decode(trunc(nvl(to_char(dpa.d_data_atto_orig,'yyyy'),to_char(dpa.d_data_atto_utente,'yyyy'))/100),
           '',decode(sign(50 - nvl(f_CIV_lettere_cifre(tes.anno_testata),0)),-1,'millenovecento','duemila'),
         '18','milleottocento',
         '19','millenovecento',
         '20','duemila',
         '21','duemilacento')||
         f_CIV_campi_testata(2,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'anno_testata'),
-- testata_giorno
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'giorno'),
-- testata_mese
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'mese'),
-- testata_ore
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'ore'),
-- testata_minuti
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'minuti'),
-- testata_ufficiale
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'ufficiale'),
-- testata_comune
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'comune'),
-- testata_motivo
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'motivo'),
-- testata_ministro
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'ministro',
                             dpa.ministro,dpa.qualita_1,tes.ministro,tes.qualita_1,tes.qualita_2),
-- testata_qualita_1
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'qualita_1',
                             dpa.ministro,dpa.qualita_1,tes.ministro,tes.qualita_1,tes.qualita_2),
-- testata_qualita_2
       f_CIV_campi_testata(4,mat.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             '','','',
                             'qualita_2',
                             dpa.ministro,dpa.qualita_1,tes.ministro,tes.qualita_1,tes.qualita_2),
-- sposi_...
-- sposi_cognome_m
       nvl(spo.cognome_m,mat.cognome_m),
-- sposi_nome_m
       nvl(spo.nome_m,mat.nome_m),
-- sposi_comune_nas_m
       nvl(spo.com_nas_m,
         f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m)||
         decode(sign(mat.cod_pro_nas_m-200),1,' '||f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,null,'S','S',mat.data_nas_m))
       ),
-- sposi_data_nas_m_riga1
       nvl(spo.data_nas1_m,f_CIV_cifre_lettere('D',to_char(mat.d_data_nas_m,'dd/mm/yyyy'),inp.valore,'S')),
-- sposi_data_nas_m_riga2
       decode(spo.data_nas1_m,'','',spo.data_nas2_m),
-- sposi_comune_atto_nas_m
       decode(spo.cod_pro_atto_nas_m,'',
         nvl(spo.com_nas_m,
           f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m)||
             decode(sign(mat.cod_pro_nas_m-200),1,' '||f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,null,'S','S',mat.data_nas_m))),
         f_comune_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,mat.data_nas_m)||' '||
           f_provincia_stato_al(spo.cod_pro_atto_nas_m,spo.cod_com_atto_nas_m,null,'S','S',mat.data_nas_m)
       ),
-- sposi_atto_nas_m
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '', to_char(spo.atto_nas_m), spo.id_atto_ansc_nas_m), 
-- sposi_parte_nas_m
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '', nvl(spo.parte_nas_m,'-')), 
-- sposi_serie_nas_m
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '', nvl(spo.serie_nas_m,'-')),
-- sposi_anno_atto_nas_m
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '', spo.anno_atto_nas_m),
-- sposi_numero_atto_ansc_nas_m
       f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m),
-- sposi_stato_civile_m
       nvl(spo.stato_civile_m, nvl(lower(f_get_descrizione_DSC(ana_1.stato_civile,'M','','','S')),'celibe')),
-- sposi_professione_m
       spo.prof_m, 
-- sposi_residenza_m
       nvl(spo.residenza_m,f_comune_al(mat.cod_pro_res_m,mat.cod_com_res_m,mat.data_mat)||
         decode(sign(mat.cod_pro_res_m-200),1,' '||f_provincia_stato_al(mat.cod_pro_res_m,mat.cod_com_res_m,null,'S','S',mat.data_mat))
       ),
-- sposi_cittadinanza_m
       nvl(spo.cittadinanza_m, f_get_descrizione_DCI(mat.nazionalita_m,'')),
-- sposi_cognome_f
       nvl(spo.cognome_f,mat.cognome_f),
-- sposi_nome_f
       nvl(spo.nome_f,mat.nome_f),
-- sposi_comune_nas_f
       nvl(spo.com_nas_f,
         f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f)||
         decode(sign(mat.cod_pro_nas_f-200),1,' '||f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,null,'S','S',mat.data_nas_f))
       ),
-- sposi_data_nas_f_riga1
       nvl(spo.data_nas1_f,f_CIV_cifre_lettere('D',to_char(mat.d_data_nas_f,'dd/mm/yyyy'),inp.valore,'S')), 
-- sposi_data_nas_f_riga2
       decode(spo.data_nas1_f,'','',spo.data_nas2_f),
-- sposi_comune_atto_nas_f
       decode(spo.cod_pro_atto_nas_f,'',
          nvl(spo.com_nas_f,
            f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f)||
              decode(sign(mat.cod_pro_nas_f-200),1,' '||f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,null,'S','S',mat.data_nas_f))),
          f_comune_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,mat.data_nas_f)||' '||
            f_provincia_stato_al(spo.cod_pro_atto_nas_f,spo.cod_com_atto_nas_f,null,'S','S',mat.data_nas_f)
       ),
-- sposi_atto_nas_f
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', to_char(spo.atto_nas_f), spo.id_atto_ansc_nas_f), 
-- sposi_parte_nas_f
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', nvl(spo.parte_nas_f,'-')), 
-- sposi_serie_nas_f
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', nvl(spo.serie_nas_f,'-')),
-- sposi_anno_atto_nas_f
       decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', spo.anno_atto_nas_f),
-- sposi_numero_atto_ansc_nas_f
       f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f),
-- sposi_stato_civile_f
       nvl(spo.stato_civile_f, nvl(lower(f_get_descrizione_DSC(ana_2.stato_civile,'F','','','S')),'nubile')),
-- sposi_professione_f
       spo.prof_f, 
-- sposi_residenza_f
       nvl(spo.residenza_f, f_comune_al(mat.cod_pro_res_f,mat.cod_com_res_f,mat.data_mat)||
         decode(sign(mat.cod_pro_res_f-200),1,' '||f_provincia_stato_al(mat.cod_pro_res_f,mat.cod_com_res_f,null,'S','S',mat.data_mat))
       ),
-- sposi_cittadinanza_f
       nvl(spo.cittadinanza_f, f_get_descrizione_DCI(mat.nazionalita_f,'')),
-- cognome_nome_officiante
       COALESCE(dpa.ministro_art, dpa.ministro, dpa.ufficiale_prov, dpa.ufficiale_utente),
-- interprete
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
       nvl(rtrim(f_comune_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,to_char(mat.d_data_mat,'j'))||' '||
                 f_provincia_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,null,'S','S',to_char(mat.d_data_mat,'j'))),
           lpad('...',30,'_')
       ),
-- data_nascita_it
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
         nvl(rtrim(f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mat.data_mat)||
                     decode(sign(dpa.cod_pro_res_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,null,'S','S',mat.data_mat))),
             lpad('...',30,'_'))
             ),
-- data_nascita_richiedente
       decode(cta.sigla, 'TEP', decode(cta.sigla, 'TEP', f_CIV_cifre_lettere('D',to_char(dpa.d_data_nas_dic,'dd/mm/yyyy'),inp.valore,'S'))),
-- testimoni_...
-- testimoni_cognome_nome_1
       decode(tta.atto,'', translate(nvl(test_1,'-'),'/',' '), tta.cognome_1||' '||tta.nome_1),
-- testimoni_nato_1
       decode(tta.atto,'', nvl(tte.nato_1,'-'), decode(tta.sesso_1,'M','o','F','a')),
-- testimoni_comune_nas_1
       decode(tta.atto,'', 
         decode(tte.com_nas_1,'','-','in '||tte.com_nas_1), 
         'in '||f_comune_al(tta.COD_PRO_NAS_1,tta.COD_COM_NAS_1,to_char(tta.D_DATA_NAS_1,'j'))||
           decode(sign(tta.cod_pro_nas_1-200),1,' '||f_provincia_stato_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,null,'S','S',to_char(tta.d_data_nas_1,'j')))
       ),
-- testimoni_data_nas_1
       decode(tta.atto,'', nvl(tte.data_nas_1,'-'), f_CIV_cifre_lettere('D',to_char(tta.D_DATA_NAS_1,'dd/mm/yyyy'),inp.valore,'S')),
-- testimoni_professione_1
       decode(tta.atto,'', nvl(tte.prof_1,'-'), ''), 
-- testimoni_residenza_1
       decode(tta.atto,'', 
         nvl(tte.residenza_1,'-'), 
         f_comune_al(tta.COD_PRO_RES_1,tta.COD_COM_RES_1,mat.data_mat)||
           decode(sign(tta.cod_pro_res_1-200),1,' '||f_provincia_stato_al(tta.cod_pro_res_1,tta.cod_com_res_1,null,'S','S',mat.data_mat))
       ),
-- testimoni_cognome_nome_2
       decode(tta.atto,'', translate(nvl(test_2,'-'),'/',' '), tta.cognome_2||' '||tta.nome_2),
-- testimoni_nato_2
       decode(tta.atto,'', nvl(tte.nato_2,'-'), decode(tta.sesso_2,'M','o','F','a')),
-- testimoni_comune_nas_2
       decode(tta.atto,'', 
         decode(tte.com_nas_2,'','-','in '||tte.com_nas_2), 
         'in '||f_comune_al(tta.COD_PRO_NAS_2,tta.COD_COM_NAS_2,to_char(tta.D_DATA_NAS_2,'j'))||
           decode(sign(tta.cod_pro_nas_2-200),1,' '||f_provincia_stato_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,null,'S','S',to_char(tta.d_data_nas_2,'j')))
       ),
-- testimoni_data_nas_2
       decode(tta.atto,'', nvl(tte.data_nas_2,'-'), f_CIV_cifre_lettere('D',to_char(tta.D_DATA_NAS_2,'dd/mm/yyyy'),inp.valore,'S')),
-- testimoni_professione_2
       decode(tta.atto,'', nvl(tte.prof_2,'-'), ''),
-- testimoni_residenza_2
       decode(tta.atto,'', 
         nvl(tte.residenza_2,'-'), 
         f_comune_al(tta.COD_PRO_RES_2,tta.COD_COM_RES_2,mat.data_mat)||
         decode(sign(tta.cod_pro_res_2-200),1,' '||f_provincia_stato_al(tta.cod_pro_res_2,tta.cod_com_res_2,null,'S','S',mat.data_mat))
       ),
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
         f_comune_al(tta.COD_PRO_RES_3,tta.COD_COM_RES_3,mat.data_mat)||
         decode(sign(tta.cod_pro_res_3-200),1,' '||f_provincia_stato_al(tta.cod_pro_res_3,tta.cod_com_res_3,null,'S','S',mat.data_mat))
       ),
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
         f_comune_al(tta.COD_PRO_RES_4,tta.COD_COM_RES_4,mat.data_mat)||
         decode(sign(tta.cod_pro_res_4-200),1,' '||f_provincia_stato_al(tta.cod_pro_res_4,tta.cod_com_res_4,null,'S','S',mat.data_mat))
       ),
-- SEL_MAR
-- margine_tramsesso_data
       decode(mar.stampa_min,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
		    'A4', nvl(mar.data_tras,rpad('_',10,'_')),
                          rpad(nvl(mar.data_tras,'_'),25,'_')
              ),
              rpad('_',25,'_')
       ),
-- margine_trasmesso_anno,
       decode(mar.stampa_min,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
		    'A4', nvl(mar.anno_tras,rpad('_',15,'_')),
                          rpad(nvl(mar.anno_tras,'_'),15,'_')
              ),
              rpad('_',15,'_')
       ),
-- margine_trasmesso_ministro_1
       decode(mar.stampa_min,
         'S', nvl(mar.ministro_1,rpad('_',20,'_'))
       ),
-- margine_trasmesso_ministro_2
       decode(mar.stampa_min,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.ministro_2,rpad('_',30,'_')),
                      rpad(nvl(mar.ministro_2,'_'),34,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',30,'_'),
                      rpad('_',34,'_')
              )
       ),
-- margine_trasmesso_ministro_1_2
       decode(mar.stampa_min,
         'S', mar.ministro_1||mar.ministro_2,
              rpad('_',41,'_')
       ),
-- margine_trasmesso
       decode(mar.stampa_min,
         'S', 'In data '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.data_tras,rpad('_',20,'_')),
                      rpad(nvl(mar.data_tras,'_'),25,'_')
              )||
              ' duemila'||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.anno_tras,rpad('_',15,'_')),
                      rpad(nvl(mar.anno_tras,'_'),15,'_')
              )||
              ' ho trasmesso notizia al ministro'||
              ' del culto di '||
              nvl(mar.ministro_1,rpad('_',20,'_'))||' '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.ministro_2,rpad('_',20,'_')),
                      rpad(nvl(mar.ministro_2,'_'),34,'_')
              )||
              ' dell''eseguita trascrizione dell'''||
              'atto controscritto con l''indicazione'||
              ' della data in cui essa e'''||
              ' stata effettuata.'
       ),
-- margine_trasmesso_ufficiale
       decode(mar.stampa_min,
         'S','L''UFFICIALE DELLO STATO CIVILE'
       ),
-- margine_trasmesso_firma
       decode(mar.stampa_min,
         'S', decode(mat.natura,
                'T', 'F.to: '||nvl(dpa.UFFICIALE_PROV,CMA.FIRMA),
                     rpad('_',30,'_')
              )
       ),
-- margine_trascritto_comune_1
       decode(mar.stampa_tr1,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.comune_tras_1,rpad('_',30,'_')),
                      rpad(nvl(mar.comune_tras_1,'_'),34,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',30,'_'),
                      rpad('_',34,'_'))
       ),
-- margine_trascritto_atto_1
       decode(mar.stampa_tr1,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(to_char(mar.atto_tras_1),rpad('_',4,'_')),
                      rpad(nvl(to_char(mar.atto_tras_1),'_'),6,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',4,'_'),
                      rpad('_',6,'_')
              )
       ),
-- margine_trascritto_parte_1
       decode(mar.stampa_tr1,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(decode(mar.parte_tras_1,'1','I','2','II',mar.parte_tras_1),rpad('_',4,'_')),
                      rpad(nvl(decode(mar.parte_tras_1,'1','I','2','II',mar.parte_tras_1),'_'),4,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',2,'_'),
                      rpad('_',4,'_')
              )
       ),
-- margine_trascritto_serie_1
       decode(mar.stampa_tr1,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.serie_tras_1,rpad('_',4,'_')),
                      rpad(nvl(mar.serie_tras_1,'_'),4,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',2,'_'),
                      rpad('_',4,'_')
              )
       ),
-- margine_trascritto_anno_1
       decode(mar.stampa_tr1,
         'S', rpad(nvl(mar.anno_tras_1,'_'),4,'_'),
              rpad('_',4,'_')
       ),
-- margine_trascritto_data_com_1
       decode(mar.stampa_tr1,
         'S', rpad(nvl(to_char(to_date(mar.data_comunicazione_1,'j'),'dd/mm/yyyy'),'_'),10,'_'),
              rpad('_',10,'_')
       ),
-- margine_trascritto_num_com_1
       decode(mar.stampa_tr1,
         'S', decode(mar.num_comunicazione_1,'','','al N. '||mar.num_comunicazione_1)
       ),
-- margine_trascritto_com_firma_1
       decode(mar.stampa_tr1,
         'S', nvl(mar.comune_firma_1,rpad('_',20,'_'))
       ),
-- margine_trascritto_data_1
       decode(mar.stampa_tr1,
         'S', nvl(to_char(to_date(mar.data_firma_1,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_trascritto_1
       decode(mar.stampa_tr1,
         'S', 'Il presente atto di matrimonio e'''||
              ' stato trascritto nei registri di'||
              ' Stato Civile del Comune di '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.comune_tras_1,rpad('_',30,'_')),
                      rpad(nvl(mar.comune_tras_1,'_'),34,'_'))||
              ' al N. '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(to_char(mar.atto_tras_1),rpad('_',6,'_')),
                      rpad(nvl(to_char(mar.atto_tras_1),'_'),6,'_')
              )||
              ' P. '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(decode(mar.parte_tras_1,'1','I','2','II',mar.parte_tras_1),rpad('_',2,'_')),
                      rpad(nvl(decode(mar.parte_tras_1,'1','I','2','II',mar.parte_tras_1),'_'),4,'_')
              )||
              ' S. '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.serie_tras_1,rpad('_',2,'_')),
                      rpad(nvl(mar.serie_tras_1,'_'),4,'_')
              )||
              ' anno '||rpad(nvl(mar.anno_tras_1,'_'),4,'_')||
              ' come da comunicazione del '||
              rpad(nvl(to_char(to_date(mar.data_comunicazione_1,'j'),'dd/mm/yyyy'),'_'),10,'_')||
              decode(mar.num_comunicazione_1,'','',' al N. '||mar.num_comunicazione_1)
       ),
-- margine_trascritto_li_data_1
       decode(mar.stampa_tr1,
         'S', ', li '||nvl(to_char(to_date(mar.data_firma_1,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_trascritto_ufficiale_1
       decode(mar.stampa_tr1,
         'S', 'L''UFFICIALE DELLO STATO CIVILE'
       ),
-- margine_trascritto_firma_1
       decode(mar.stampa_tr1, 
         'S', rpad('_',30,'_')
       ),
-- margine_trascritto_comune_2
       decode(mar.stampa_tr2,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.comune_tras_2,rpad('_',30,'_')),
                      rpad(nvl(mar.comune_tras_2,'_'),34,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',30,'_'),
                      rpad('_',34,'_')
              )
       ),
-- margine_trascritto_atto_2
       decode(mar.stampa_tr2,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(to_char(mar.atto_tras_2),rpad('_',4,'_')),
                      rpad(nvl(to_char(mar.atto_tras_2),'_'),6,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',4,'_'),
                      rpad('_',6,'_')
              )
       ),
-- margine_trascritto_parte_2
       decode(mar.stampa_tr2,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(decode(mar.parte_tras_2,'1','I','2','II',mar.parte_tras_2),rpad('_',2,'_')),
                      rpad(nvl(decode(mar.parte_tras_2,'1','I','2','II',mar.parte_tras_2),'_'),4,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',2,'_'),
                      rpad('_',4,'_')
              )
       ),
-- margine_trascritto_serie_2
       decode(mar.stampa_tr2,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.serie_tras_2,rpad('_',2,'_')),
                      rpad(nvl(mar.serie_tras_2,'_'),4,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',2,'_'),
                      rpad('_',4,'_')
              )
       ),
-- margine_trascritto_anno_2
       decode(mar.stampa_tr2,
         'S', rpad(nvl(mar.anno_tras_2,'_'),4,'_'),
              rpad('_',4,'_')
       ),
-- margine_trascritto_data_com_2
       decode(mar.stampa_tr2,
         'S', rpad(nvl(to_char(to_date(mar.data_comunicazione_2,'j'),'dd/mm/yyyy'),'_'),10,'_'),
              rpad('_',10,'_')
       ),
-- margine_trascritto_num_com_2
       decode(mar.stampa_tr2,
         'S', decode(mar.num_comunicazione_2,'','','al N. '||mar.num_comunicazione_2)
       ),
-- margine_trascritto_com_firma_2
       decode(mar.stampa_tr2,
         'S', nvl(mar.comune_firma_2,rpad('_',20,'_'))
       ),
-- margine_trascritto_data_2
       decode(mar.stampa_tr2,
         'S', nvl(to_char(to_date(mar.data_firma_2,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_trascritto_2
       decode(mar.stampa_tr2,'S',
         'Il presente atto di matrimonio e'''||
         ' stato trascritto nei registri di'||
         ' Stato Civile del Comune di '||
         decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
           'A4', nvl(mar.comune_tras_2,rpad('_',30,'_')),
                 rpad(nvl(mar.comune_tras_2,'_'),34,'_')
         )||
         ' al N. '||
         decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
           'A4', nvl(to_char(mar.atto_tras_2),rpad('_',4,'_')),
                 rpad(nvl(to_char(mar.atto_tras_2),'_'),6,'_')
         )||
         ' P. '||
         decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
           'A4', nvl(decode(mar.parte_tras_2,'1','I','2','II',mar.parte_tras_2),rpad('_',4,'_')),
                 rpad(nvl(decode(mar.parte_tras_2,'1','I','2','II',mar.parte_tras_2),'_'),4,'_')
         )||
         ' S. '||
         decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
           'A4', nvl(mar.serie_tras_2,rpad('_',2,'_')),
                 rpad(nvl(mar.serie_tras_2,'_'),4,'_')
         )||
         ' anno '||
         rpad(nvl(mar.anno_tras_2,'_'),4,'_')||
         ' come da comunicazione del '||
         rpad(nvl(to_char(to_date(mar.data_comunicazione_2,'j'),'dd/mm/yyyy'),'_'),10,'_')||
         decode(mar.num_comunicazione_2,'','',' al N. '||mar.num_comunicazione_2)
       ),
-- margine_trascritto_li_data_2
       decode(mar.stampa_tr2,
         'S', ', li '||nvl(to_char(to_date(mar.data_firma_1,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_trascritto_ufficiale_2
       decode(mar.stampa_tr2,
         'S', 'L''UFFICIALE DELLO STATO CIVILE'
       ),
-- margine_trascritto_firma_2
       decode(mar.stampa_tr2,
         'S', rpad('_',30,'_')
       ),
-- margine_convenzioni
       decode(mat.convenzioni,
         'SI', decode(mar.scelta_conv,
                 2, 'Con dichiarazione resa nell''atto'||
                    ' di matrimonio controscritto, gli'||
                    ' sposi hanno dichiarato di'||
                    ' scegliere la legge '||mar.legge_conv||
                    ' da applicare ai loro rapporti'||
                    ' patrimoniali ai sensi dell''art.30,'||
                    ' primo comma della legge 31 maggio'||
                    ' 1995, n.218.',
                 'Con dichiarazione resa nell''atto'||
                 ' di  matrimonio controscritto, gli'||
                 ' sposi hanno scelto il regime della'||
                 ' separazione dei beni.'
               )
       ),
-- margine_convenzioni_comune
       decode(mat.convenzioni,
         'SI', nvl(f_comune_al(mat.cod_pro_mat,mat.cod_com_mat,mat.data_mat),rpad('_',20,'_'))
       ),
-- margine_convenzioni_li_data
       decode(mat.convenzioni,
         'SI', ', li '||nvl(to_char(to_date(mat.data_convenzioni,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_convenzioni_ufficiale
       decode(mat.convenzioni,
         'SI', 'L''UFFICIALE DELLO STATO CIVILE'
       ),
-- margine_convenzioni_firma
       decode(mat.convenzioni,
         'SI', decode(mat.natura,
                 'T', 'F.to: '||nvl(dpa.UFFICIALE_PROV,CMA.FIRMA),
                      rpad('_',30,'_')
               )
       ),
-- margine_libretto
       decode(mar.stampa_lib,
         'S', 'Rilasciato libretto internazionale'||
              ' di famiglia n. '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.numero_lib,rpad('_',10,'_')),
                      rpad(nvl(mar.numero_lib,'_'),10,'_')
              )||
              ' in data '||
              rpad(nvl(to_char(to_date(mar.data_lib,'j'),'dd/mm/yyyy'),'_'),10,'_')||
               '.'
       ),
-- margine_libretto_li_data
       decode(mar.stampa_lib,
         'S', 'li '||nvl(to_char(to_date(mar.data_firma_lib,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_libretto_ufficiale
       decode(mar.stampa_lib,
         'S', 'L''UFFICIALE DELLO STATO CIVILE'
       ),
-- margine_libretto_firma
       decode(mar.stampa_lib,
         'S', decode(mat.natura,
                'T', 'F.to: '||nvl(dpa.UFFICIALE_PROV,CMA.FIRMA),
                     rpad('_',30,'_')
              )
       )
  FROM arcinp inp,
       civcta cta, civdta dta,
       anaana ana_2, anaana ana_1, civana ana, civsog sog_IT,
       civdpa dpa_prec, civmat mat_prec,
       civocc occ,
       civcma cma,
       civdfi dfi,
       civart art, civdma dma,
       civchi chi, civdoc doc, civrma rma,
       civtta tta, civtte tte, civspo spo, 
       civttr ttr, civtes tes,
       civdpa dpa, civmar mar, 
       civmat mat
 where inp.parametro        = 'ATTI_PRIMO'
   and cta.id           (+) = dta.id_civcta
   and dta.id           (+) = mat.id_civdta
   and ana_2.matricola  (+) = ana.matricola_2
   and ana_1.matricola  (+) = ana.matricola_1
   and ana.id_atto      (+) = mat.id_atto
   and sog_IT.id_atto        (+) = mat.id_atto
   and sog_IT.tipo_soggetto  (+) = 'IT'
   and dpa_prec.id_atto (+) = f_CIV_get_id_atto(spo.tipo_atto,spo.ufficio_mat,spo.anno_atto_mat,spo.parte_mat,spo.serie_mat,spo.atto_mat)
   and mat_prec.id_atto (+) = f_CIV_get_id_atto(spo.tipo_atto,spo.ufficio_mat,spo.anno_atto_mat,spo.parte_mat,spo.serie_mat,spo.atto_mat)
   and cma.id_atto   	(+) = mat.id_atto
   and dfi.id_atto   	(+) = mat.id_atto
   and art.id_atto 	(+) = mat.id_atto
   and dma.id_atto  (+) = mat.id_atto
   and chi.id_atto	(+) = mat.id_atto
   and doc.id_atto 	(+) = mat.id_atto
   and rma.id_atto 	(+) = mat.id_atto
   and ttr.id_atto	(+) = mat.id_atto
   and spo.id_atto	(+) = mat.id_atto
   and tta.id_atto  (+) = mat.id_atto
   and tte.id_atto  (+) = mat.id_atto
   and tes.id_atto	(+) = mat.id_atto
   and dpa.id_atto	(+) = mat.id_atto
   and mar.id_atto	(+) = mat.id_atto
   and occ.id_atto	(+) =  mat.id_atto
   and mat.cod_rec          in (0,3)
/
comment on table civwma_totale is 'Stato Civile - Variabili per composizione Atti di Matrimonio'
/
