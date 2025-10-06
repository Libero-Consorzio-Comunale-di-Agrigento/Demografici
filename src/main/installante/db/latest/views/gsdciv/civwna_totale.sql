--liquibase formatted sql
--changeset amonopoli:202301301620 runAlways:true runOnChange:true stripComments:false
create or replace view civwna_totale
       (cod_rec, ufficio, anno, atto, parte, serie, natura, 
        NUMEO_ATTO_ANSC,
        UFFICIO_ORIG, ANNO_ORIG, ATTO_ORIG, PARTE_ORIG, SERIE_ORIG,
        NUMERO_ATTO_ANSC_ORIG,
  	ANNO_OGGI, MESE_OGGI, GIORNO_OGGI, ORE_OGGI, MINUTI_OGGI,
        COGNOME_NOME, 
	cognome, nome,
	SECONDO_NOME, TERZO_NOME,
        sesso, nato_morto,
        NAT_OA, DATA_NASCITA_GGMMAAAA, DATA_NASCITA,
        giorno_nascita, mese_nascita, anno_nascita,
        ore_nascita, minuti_nascita,       
        ORE, MINUTI, 
        COMUNE_NASCITA,
        COMUNE_RESIDENZA,
  	PATERNITA, COGNOME_PADRE, NOME_PADRE, DATA_NASCITA_PT, 
	ANNO_NASCITA_PT, MESE_NASCITA_PT, GIORNO_NASCITA_PT,
	COMUNE_NASCITA_PT, COMUNE_RESIDENZA_PT, 
	NAZIONALITA_PT, PROFESSIONE_PT, TITOLO_STUDIO_PT,
        MATERNITA, COGNOME_MADRE, NOME_MADRE, DATA_NASCITA_MT, 
	ANNO_NASCITA_MT, MESE_NASCITA_MT, GIORNO_NASCITA_MT,
	COMUNE_NASCITA_MT, COMUNE_RESIDENZA_MT, 
	NAZIONALITA_MT, PROFESSIONE_MT, TITOLO_STUDIO_MT,
	COGNOME_INTERPRETE, NOME_INTERPRETE, COMUNE_NASCITA_INTERPRETE, COMUNE_RESIDENZA_INTERPRETE, DATA_NASCITA_INTERPRETE,
        COGNOME_RICHIEDENTE, NOME_RICHIEDENTE, COMUNE_NASCITA_RICHIEDENTE, COMUNE_RESIDENZA_RICHIEDENTE, DATA_NASCITA_RICHIEDENTE,
	COMUNE_DATA, COMUNE,DATA,
        autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	frazione_prov, autorita_prov_ufficio, nota_rif, anno_nota_rif, data_nota_rif,
	ufficiale_prov, qualifica_prov,
	protocollo_prov, anno_protocollo_prov, data_protocollo_prov,
	ente_straniero, comune_ente_straniero, stato_ente_straniero, data_atto_ente_straniero,
	tipo_atto_ente_straniero, estremi_atto_ente_straniero,
	atto_notarile, comune_atto_notarile, data_atto_notarile, estremi_doc_atto_notarile,
        centro_nascita,comune_centro_nascita,
        numero_dich_centro_nascita,anno_dich_centro_nascita,
        data_richiesta_centro_nascita,
        addetto_centro_nascita,qualifica_centro_nascita,
        data_dich_centro_nascita,ore_dich_centro_nascita,minuti_dich_centro_nascita,
	ufficiale_utente,
        nel, luogo_nascita_riga1, luogo_nascita_riga2,
        nel_luogo_nascita, luogo_nascita,
        parto_plurimo_ordinale, parto_plurimo_altri_gemelli,
        parto_plurimo_atti_succ, parto_plurimo_atti_prec,
        AUTORITA_ATTO_ORIGINALE, DATA_ATTO_ORIGINALE_GGMMAAAA,
        DATA_ATTO_ORIGINALE, ANNO_ATTO_ORIGINALE, MESE_ATTO_ORIGINALE,
	GIORNO_ATTO_ORIGINALE, ORE_ATTO_ORIGINALE, MINUTI_ATTO_ORIGINALE,
	filiazione_riga1, filiazione_riga2, filiazione_riga3,
	filiazione_riga4, filiazione_riga5, filiazione_riga6,
	filiazione_riga7, filiazione_riga8, filiazione_riga9,
	filiazione_riga10, filiazione_riga11,
	presentazione_sesso, presentazione_non, presentazione_presentato,
	presentazione_riga1, presentazione_riga2,
	presentazione_il_la, presentazione_da_il_nome, presentazione_nome,
	presentazione_riga3, presentazione_riga4, presentazione_riga5,
	presentazione_riga6, presentazione_riga7, presentazione_riga8,
	presentazione_riga9, presentazione_riga10, presentazione_riga11, presentazione_riga12,
	chiusura_riga1, chiusura_riga2, chiusura_riga3, chiusura_riga4, chiusura_firma,
	testata_anno, testata_giorno, testata_mese, testata_ore, testata_minuti,
	testata_ubicazione, testata_ufficiale, testata_comune, testata_motivo,
	dichiarante_comparso, dichiarante, dichiarante_cognome, dichiarante_nome, 
	dichiarante_sesso, dichiarante_nato,
	dichiarante_com_nas, dichiarante_data_nas,
	dichiarante_prof, dichiarante_residenza, dichiarante_il, dichiarante_la,
	dichiarante_riga1, dichiarante_riga2, dichiarante_riga3,
	dichiarante_riga4, dichiarante_riga5_null, dichiarante_riga5,
	dichiarante_riga6, dichiarante_riga7, dichiarante_comprensione, dichiarante_motivo_impedimento,
	RICONOSCIMENTO_PRE_ANNO_1, RICONOSCIMENTO_PRE_ATTO_1, RICONOSCIMENTO_PRE_PARTE_1,
	RICONOSCIMENTO_PRE_SERIE_1, RICONOSCIMENTO_PRE_UFFICIO_1, RICONOSCIMENTO_PRE_DATA_1,
	RICONOSCIMENTO_PRE_COMUNE_1, RICONOSCIMENTO_PRE_PROVINCIA_1,
        RICONOSCIM_PRE_NUM_ATTO_ANSC_1,
	RICONOSCIMENTO_PRE_ANNO_2, RICONOSCIMENTO_PRE_ATTO_2, RICONOSCIMENTO_PRE_PARTE_2,
	RICONOSCIMENTO_PRE_SERIE_2, RICONOSCIMENTO_PRE_UFFICIO_2, RICONOSCIMENTO_PRE_DATA_2,
	RICONOSCIMENTO_PRE_COMUNE_2, RICONOSCIMENTO_PRE_PROVINCIA_2,
        RICONOSCIM_PRE_NUM_ATTO_ANSC_2,
	trascrizione_anno, trascrizione_giorno, trascrizione_mese, trascrizione_ore,
	trascrizione_minuti, trascrizione_ufficiale,
	trascrizione_comune, trascrizione_motivo, trascrizione_data,
	trascrizione_comune_atto_orig,
	margine_sentenza_tribunale_1,  margine_sentenza_tribunale_2,
	margine_sentenza_data, margine_sentenza_anno,
	margine_sentenza_atto_tras, margine_sentenza_anno_tras,
	margine_sentenza_e_stato, margine_sentenza_data_firma,
	margine_sentenza, margine_sentenza_li_data,
	margine_sentenza_ufficiale, margine_sentenza_firma,
	margine_trascrizione_comune,
	margine_trascrizione_atto, margine_trascrizione_parte,
	margine_trascrizione_serie, margine_trascrizione_anno_atto,
	margine_trascrizione_data_com, margine_trascrizione_data,
	margine_trascrizione, margine_trascrizione_li_data,
	margine_trascrizione_ufficiale, margine_trascrizione_firma,
	concepito_da_mesi,
	certificato_rilasciato,
	certificato_data
       )
AS
SELECT nas.cod_rec, nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie, nas.natura,
       f_CIV_numero_atto_ansc(nas.id_atto_ansc),
-- estremi atto originale
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.ufficio_orig),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.anno_orig), 
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', to_char(dpa.atto_orig), dpa.id_atto_ansc_orig),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', decode(dpa.parte_orig,'',to_char(null),1,'I',2,'II')),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.serie_orig),
       f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig),
-- anno_oggi
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'anno_oggi'),
-- mese_oggi
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'mese_oggi'),
-- giorno_oggi
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'giorno_oggi'),
-- ore_oggi
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'ore_oggi'),
-- minuti_oggi
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'minuti_oggi'),
-- cognome_nome
       decode(occ.atto,'', translate(nas.cognome_nome,'/',' '), occ.cognome||' '||occ.nome),
-- cognome
       decode(occ.atto,'', nas.cognome, occ.cognome),
-- nome
       decode(occ.atto,'', nas.nome, occ.nome),
-- secondo_nome
       nas.secondo_nome,
-- terzo_nome
       nas.terzo_nome,
-- sesso
       decode(occ.atto,'', decode(nas.sesso,'M','maschile','F','femminile','non conosciuto'), occ.sesso),
-- nato_morto
       decode(occ.atto,'', decode(nas.nato_morto,'','','NATO MORTO'), occ.nato_morto),
-- nat_oa
       decode(nas.sesso,'M','nato','F','nata','nato/a'),
-- data_nascita_GGMMYYYY
       decode(nas.anno_nas,'S', to_char(to_date(nas.data_nas,'j'),'yyyy'),
         decode(nas.flag_GG_imprecisato,'S','00',to_char(to_date(nas.data_nas,'j'),'dd'))||'/'||
         decode(nas.flag_MM_imprecisato,'S','00',to_char(to_date(nas.data_nas,'j'),'mm'))||'/'||
         decode(nas.flag_AA_imprecisato,'S','0000',to_char(to_date(nas.data_nas,'j'),'yyyy'))
       ),
-- data_nascita
       decode(nas.anno_nas,'S', f_CIV_cifre_lettere('A',to_char(to_date(nas.data_nas,'j'),'yyyy'),'',''),
         decode(nas.flag_GG_imprecisato,'S','',f_CIV_cifre_lettere('G',to_char(to_date(nas.data_nas,'j'),'dd'),inp.valore,'')||' ')||
         decode(nas.flag_MM_imprecisato,'S','',f_CIV_cifre_lettere('M',to_char(to_date(nas.data_nas,'j'),'mm'),'','')||' ')||
         decode(nas.flag_AA_imprecisato,'S','imprecisata',f_CIV_cifre_lettere('A',to_char(to_date(nas.data_nas,'j'),'yyyy'),'','')||' ')
       ),
-- giorno_nascita
       upper(decode(nas.flag_gg_imprecisato, 'S', 'imprecisato',
               f_CIV_cifre_lettere('G', to_char(nas.d_data_nas, 'dd'), inp.valore, '')
             )),
-- mese_nascita
       upper(decode(nas.flag_mm_imprecisato, 'S', 'imprecisato',
               f_CIV_cifre_lettere('M', to_char(nas.d_data_nas, 'mm'),'','')
             )),
-- anno_nascita
       upper(decode(nas.flag_aa_imprecisato, 'S', 'imprecisato',
               f_CIV_cifre_lettere('A', to_char(nas.d_data_nas,'yyyy'),'', '')
             )),
-- ora_nascita
       upper(decode(nas.flag_hh_imprecisato, 'S', 'imprecisate', f_CIV_cifre_lettere('h', to_char(nas.ore),'', 'S'))),
-- minuti_nascita
       upper(decode(nas.flag_mi_imprecisato, 'S', 'imprecisati', f_CIV_cifre_lettere('m', to_char(nas.minuti),'', 'S'))),
-- ore
       decode(nas.flag_HH_imprecisato,'S','imprecisata',f_CIV_cifre_lettere('h',nvl(nas.ore,0),'','')),
-- minuti
       decode(nas.flag_MI_imprecisato,'S','imprecisati',f_CIV_cifre_lettere('m',nvl(nas.minuti,0),'','')),
-- comune_nascita
       nvl(rtrim(f_comune_al(nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas)||' '||
                 f_provincia_stato_al(nas.cod_pro_nas,nas.cod_com_nas,'','S','S',nas.data_nas)),
           rpad('...',30,'_')
       ),
-- comune_residenza
       nvl(rtrim(f_comune_al(nas.cod_pro_res,nas.cod_com_res,nas.data_nas)||' '||
                 f_provincia_stato_al(nas.cod_pro_res,nas.cod_com_res,'','S','S',nas.data_nas)),
           rpad('...',30,'_')
       ),
-- paternita
       nvl(decode(instr(nas.paternita,'/'),0,
          decode(nas.paternita,'',to_char(null),
            substr(nas.cognome_nome,1,instr(nas.cognome_nome,'/')-1)||' '||nas.paternita),
          translate(nas.paternita,'/',' ')),rpad('...',15,'_')
       ),
-- cognome_padre
       decode(nas.paternita,'','',
         decode(instr(nas.paternita,'/'),
           0,substr(nas.cognome_nome,1,instr(nas.cognome_nome,'/')-1),
             substr(nas.paternita,1, instr(nas.paternita,'/')-1))
       ),
-- nome_padre
       decode(nas.paternita,'','',
         decode(instr(nas.paternita,'/'),
           0,nas.paternita,
             substr(nas.paternita,instr(nas.paternita,'/')+1))
       ),
-- data_nascita_pt
       nvl(f_CIV_cifre_lettere('D',to_char(nas.d_data_nas_pd,'dd/mm/yyyy'),inp.valore,'S'),rpad('...',10,'_')),
-- anno_nascita_pt
       nvl(f_CIV_cifre_lettere('A',to_char(nas.d_data_nas_pd,'yyyy'),'','S'),rpad('...',5,'_')),
-- mese_nascita_pt
       nvl(f_CIV_cifre_lettere('M',to_char(nas.d_data_nas_pd,'mm'),'','S'),rpad('...',10,'_')),
-- giorno_nascita_pt
       nvl(f_CIV_cifre_lettere('G',to_char(nas.d_data_nas_pd,'dd'),inp.valore,'S'),rpad('...',15,'_')),
-- comune_nascita_pt
       nvl(rtrim(f_comune_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,to_char(nas.d_data_nas_pd,'j'))||' '||
                 f_provincia_stato_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,'','S','S',to_char(nas.d_data_nas_pd,'j'))),
           rpad('...',30,'_')
       ),
-- comune_residenza_pt
       nvl(rtrim(f_comune_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,nas.data_nas)||' '||
                 f_provincia_stato_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,'','S','S',nas.data_nas)),
           rpad('...',30,'_')
       ),
-- nazionalita_pt
       nvl(lower(f_get_descrizione_DCI(nas.nazionalita_pd,'M')),rpad('...',20,'_')),
-- professione_pt
       rpad('...',20,'_'),
-- titolo_studio_pt
       rpad('...',20,'_'),
-- maternita
       nvl(translate(nas.maternita,'/',' '),rpad('...',30,'_')),
-- cognome_madre
       substr(nas.maternita,1, instr(nas.maternita,'/')-1),
-- nome_madre
       substr(nas.maternita,instr(nas.maternita,'/')+1),
-- data_nascita_mt
       nvl(f_CIV_cifre_lettere('D',to_char(nas.d_data_nas_md,'dd/mm/yyyy'),inp.valore,'S'),rpad('...',10,'_')),
-- anno_nascita_mt
       nvl(f_CIV_cifre_lettere('A',to_char(nas.d_data_nas_md,'yyyy'),'','S'),rpad('...',5,'_')),
-- mese_nascita_mt
       nvl(f_CIV_cifre_lettere('M',to_char(nas.d_data_nas_md,'mm'),'','S'),rpad('...',10,'_')),
-- giorno_nascita_mt
       nvl(f_CIV_cifre_lettere('G',to_char(nas.d_data_nas_md,'dd'),inp.valore,'S'),rpad('...',15,'_')),
-- comune_nascita_mt
       nvl(rtrim(f_comune_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,to_char(nas.d_data_nas_md,'j'))||' '||
                 f_provincia_stato_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,'','S','S',to_char(nas.d_data_nas_md,'j'))),
           rpad('...',30,'_')
       ),
-- comune_residenza_mt
       nvl(rtrim(f_comune_al(nas.cod_pro_res_md,nas.cod_com_res_md,nas.data_nas)||' '||
                 f_provincia_stato_al(nas.cod_pro_res_md,nas.cod_com_res_md,'','S','S',nas.data_nas)),
           rpad('...',30,'_')
       ),
-- nazionalita_mt
       nvl(lower(f_get_descrizione_DCI(nas.nazionalita_md,'F')),rpad('...',20,'_')),
-- professione_mt
       rpad('...',20,'_'),
-- titolo_studio_mt
       rpad('...',20,'_'),
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
       nvl(rtrim(f_comune_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,to_char(nas.d_data_nas,'j'))||' '||
                 f_provincia_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,null,'S','S',to_char(nas.d_data_nas,'j'))),
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
         nvl(rtrim(f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,nas.data_nas)||
                     decode(sign(dpa.cod_pro_res_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,null,'S','S',nas.data_nas))),
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
-- atto_notarile
	dpa.atto_notarile_ente,
-- comune_atto_notarile
	rtrim(f_comune_al(dpa.atto_notarile_cod_pro, dpa.atto_notarile_cod_com, '')||' '||
             f_provincia_stato_al(dpa.atto_notarile_cod_pro, dpa.atto_notarile_cod_com,'','S','S','')),
-- data_atto_notarile
	to_char(dpa.d_atto_notarile_data_doc,'dd/mm/yyyy'),
-- estremi_doc_atto_notarile
	dpa.atto_notarile_estremi_doc,
-- centro_nascita
       dpa.autorita_prov,
-- comune_centro_nascita
       dpa.comune_prov,
-- numero_dich_centro_nascita
       dpa.nota_rif,
-- anno_dich_centro_nascita
       dpa.anno_nota_rif,
-- data_richiesta_centro_nascita
       TO_CHAR (TO_DATE (dpa.data_nota_rif, 'j'), 'dd/mm/yyyy'),
-- addetto_centro_nascita
       dpa.ufficiale_prov,
-- qualifica_centro_nascita
       decode(dpa.tipo_addetto_dichiarazione_cna,'AD','Addetto Delegato','DS','Direttore Sanitario'),
-- data_dich_centro_nascita
       TO_CHAR (TO_DATE (dpa.data_atto_orig, 'j'), 'dd/mm/yyyy'),
-- ore_dich_centro_nascita
       dpa.ore_atto_orig,
-- minuti_dich_centro_nascita
       dpa.minuti_atto_orig,
-- ufficiale_utente
       nvl(f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'ufficiale_utente'),rpad('...',30,'_')),
-- nel
       decode(dpa.luogo_nas, '', dna.nel,  dpa.nel_nas),
-- luogo_nascita_riga_1
       decode(dpa.luogo_nas, '', dna.luogo_nas, dpa.luogo_nas),
-- luogo_nascita_riga_2
       decode(dpa.luogo_nas, '', dna.luogo_nas2, ''),
-- nel_luogo_nascita
       'nel'||dpa.nel_nas||' '||nvl(dpa.luogo_nas,rpad('...',30,'_')),
-- luogo_nascita
       nvl(dpa.luogo_nas, rpad('...',30,'_')),
-- parto_plurimo_ordinale
       f_CIV_parto_plurimo_ordinale(nas.parto_plurimo_num_gemello,nas.parto_plurimo_tot_gemelli),
-- parto_plurimo_altri_gemelli
       f_CIV_cifre_lettere('U',nas.parto_plurimo_tot_gemelli-1,'S','S'),
-- parto_plurimo_atti_succ
       f_CIV_parto_plurimo_atti(nas.atto,nas.parto_plurimo_num_gemello,nas.parto_plurimo_tot_gemelli,'succ',nas.id_atto),
-- parto_plurimo_atti_prec
       f_CIV_parto_plurimo_atti(nas.atto,nas.parto_plurimo_num_gemello,nas.parto_plurimo_tot_gemelli,'prec',nas.id_atto),
-- autorita_atto_orig
       dpa.autorita_atto_orig,
-- data_atto_orig
       nvl(to_char(to_date(dpa.data_atto_orig,'j'),'dd/mm/yyyy'),rpad('...',10,'_')),
-- data_atto_originale
       f_CIV_cifre_lettere('D',to_char(to_date(dpa.data_atto_orig,'j'),'dd/mm/yyyy'),'',''),
-- anno_atto_originale
       f_CIV_cifre_lettere('A',to_char(to_date(dpa.data_atto_orig,'j'),'yyyy'),'',''),
-- mese_atto_originale
       f_CIV_cifre_lettere('M',to_char(to_date(dpa.data_atto_orig,'j'),'mm'),'',''),
-- giorno_atto_originale
       f_CIV_cifre_lettere('G',to_char(to_date(dpa.data_atto_orig,'j'),'dd'),inp.valore,''),
-- ore_atto_originale
       f_CIV_cifre_lettere('h',dpa.ore_atto_orig,'',''),
-- minuti_atto_originale
       f_CIV_cifre_lettere('m',dpa.minuti_atto_orig,'',''),
-- filiazione_...
       decode(dpa.luogo_nas, '', dna.riga1),
       decode(dpa.luogo_nas, '', dna.riga2),
       decode(dpa.luogo_nas, '', dna.riga3),
       decode(dpa.luogo_nas, '', dna.riga4),
       decode(dpa.luogo_nas, '', dna.riga5),
       decode(dpa.luogo_nas, '', dna.riga6),
       decode(dpa.luogo_nas, '', dna.riga7),
       decode(dpa.luogo_nas, '', dna.riga8),
       decode(dpa.luogo_nas, '', dna.riga9),
       decode(dpa.luogo_nas, '', dna.riga10),
       decode(dpa.luogo_nas, '', dna.riga11),
-- presentazione_...
       decode(nas.sesso, 'M', 'maschile', 'F', 'femminile', 'non noto'),  					-- presentazione_sesso
       decode(nvl(dpa.tipo_accertamento,'AN'), 'PF', to_char(null), 'non'),					-- presentazione_non
       'mi viene presentato'||
         decode(nvl(dpa.tipo_accertamento,'AN'), 'PF', to_char(null), ', ma della cui nascita io mi sono'),	-- presentazione_presentato
       decode(nvl(dpa.tipo_accertamento,'AN'), 'PF', to_char(null), 'accertato mediante ')||
         decode(nvl(dpa.tipo_accertamento,'AN'), 
           'AN', 'attestazione di nascita', 
           'CP', 'constatazione di avvenuto parto', 
           'DS', 'dichiarazione sostitutiva'),									-- presentazione_riga1
       to_char(null),												-- presentazione_riga2
       decode(dpa.tipo_dichiarante,'', pre.il_la,		
         decode(dpa.tipo_dichiarante,
           'PD', 'il dichiarante',
           'MD', 'la dichiarante',
           'AL', decode(dpa.sesso_dic, 'M', 'il dichiarante', 'F', 'la dichiarante', pre.il_la)
          )
       ),													-- presentazione_il_la
       'd'||nvl(pre.da,'à')||
         ' i'||nvl(pre.il, decode(secondo_nome||terzo_nome,'','l'))||
         ' nom'||nvl(pre.nome_i, decode(secondo_nome||terzo_nome,'','e','i'))||
         ' di',				-- presentazione_da_il_nome
       nvl(pre.nome, nas.nome||
                     decode(nas.secondo_nome, NULL, '', ', '|| nas.secondo_nome) ||
                     decode(nas.terzo_nome, NULL, '', ', '|| nas.terzo_nome)),			-- presentazione_nome
       decode(dpa.tipo_dichiarante,'', pre.riga3),						-- presentazione_riga3
       decode(dpa.tipo_dichiarante,'', pre.riga4),						-- presentazione_riga4
       decode(dpa.tipo_dichiarante,'', pre.riga5),						-- presentazione_riga5
       decode(dpa.tipo_dichiarante,'', pre.riga6),						-- presentazione_riga6
       decode(dpa.tipo_dichiarante,'', pre.riga7),						-- presentazione_riga7
       decode(dpa.tipo_dichiarante,'', pre.riga8),						-- presentazione_riga8
       decode(dpa.tipo_dichiarante,'', pre.riga9),						-- presentazione_riga9
       decode(dpa.tipo_dichiarante,'', pre.riga10),						-- presentazione_riga10
       decode(dpa.tipo_dichiarante,'', pre.riga11),						-- presentazione_riga11
       decode(dpa.tipo_dichiarante,'', pre.riga12),						-- presentazione_riga12
-- chiusura_...
       chi.riga1,
       chi.riga2,
       chi.riga3,
       chi.riga4,
       decode(dpa.ufficiale_prov,'',chi.firma,dpa.ufficiale_prov),
-- testata_...
-- testata_anno
       decode(trunc(nvl(to_char(dpa.d_data_atto_orig,'yyyy'),to_char(dpa.d_data_atto_utente,'yyyy'))/100),
           '',decode(sign(50 - nvl(f_CIV_lettere_cifre(tes.anno_testata),0)),-1,'millenovecento','duemila'),
         '18','milleottocento',
         '19','millenovecento',
         '20','duemila',
         '21','duemilacento')||
         f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             '','','','','','','','','','','',
                             'anno_testata'),
-- testata_giorno
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'giorno'),
-- testata_mese
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'mese'),
-- testata_ore
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'ore'),
-- testata_minuti
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'minuti'),
-- testata_ubicazione
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'ubicazione'),
-- testata_ufficiale
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'ufficiale'),
-- testata_comune
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'comune'),
-- testata_motivo
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,'','','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             '','','','','','','','','','','',
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'motivo'),
-- dichiarante_...
       decode(dpa.tipo_dichiarante,'', decode(dpa.sesso_dic,'M','o','F','a', dic.comparso),
         decode(dpa.tipo_dichiarante,
           'PD', 'o',
           'MD', 'a',
           'AL', decode(dpa.sesso_dic,'M','o','F','a', dic.comparso),
           'IN', decode(nas.sesso,'M','o','F','a', dic.comparso),
           'EN', 'i',
           'AM', '',
           'OS', decode(sog_OS.sesso,'M','o','F','a',dic.comparso),
           'PP', decode(sog_PP.sesso,'M','o','F','a',dic.comparso),
           'PM', decode(sog_PM.sesso,'M','o','F','a',dic.comparso)
         )
       ),
       decode(dpa.tipo_dichiarante,'', decode(dpa.cognome_dic, '',translate(dic.dic_1,'/',' '), dpa.cognome_dic||' '||dpa.nome_dic),
         decode(dpa.tipo_dichiarante,
           'PD', decode(nas.paternita, '', dic.dic_1, nas.cognome_pd||' '||nas.nome_pd),
           'MD', decode(nas.maternita, '', dic.dic_1, nas.cognome_md||' '||nas.nome_md),
           'AL', decode(dpa.cognome_dic, '', dic.dic_1, dpa.cognome_dic||' '||dpa.nome_dic),
           'IN', decode(nas.cognome_nome, '', dic.dic_1, nas.cognome||' '||nas.nome),
           'EN', decode(nas.paternita, '', dic.dic_1, nas.cognome_pd||' '||nas.nome_pd),
           'AM', decode(dpa.autorita_prov, '', dic.dic_1, dpa.autorita_prov||' '||dpa.comune_prov)
         )
       ),
	   decode(dpa.tipo_dichiarante,
               'OS', sog_OS.cognome,
               'PP', sog_PP.cognome,
               'PM', sog_PM.cognome,
               dpa.cognome_dic),
	   decode(dpa.tipo_dichiarante,
               'OS', sog_OS.nome,
               'PP', sog_PP.nome,
               'PM', sog_PM.nome,
               dpa.nome_dic),
	   decode(dpa.tipo_dichiarante,
               'OS', decode(sog_OS.sesso,'M','maschile','F','femminile','non conosciuto'),
               'PP', decode(sog_PP.sesso,'M','maschile','F','femminile','non conosciuto'),
               'PM', decode(sog_PM.sesso,'M','maschile','F','femminile','non conosciuto'),
	           decode(dpa.sesso_dic,'M','maschile','F','femminile','non conosciuto')),
       decode(dpa.tipo_dichiarante,'', decode(dpa.sesso_dic,'M','o','F','a', dic.nato_1),       
         decode(dpa.tipo_dichiarante,
           'PD', 'o',
           'MD', 'a',
           'AL', decode(dpa.sesso_dic,'M','o','F','a', dic.nato_1),
           'IN', decode(nas.sesso,'M','o','F','a', dic.nato_1),
           'EN', 'i',
           'AM', '',
           'OS', decode(sog_OS.sesso,'M','o','F','a',dic.nato_1),
           'PP', decode(sog_PP.sesso,'M','o','F','a',dic.nato_1),
           'PM', decode(sog_PM.sesso,'M','o','F','a',dic.nato_1)
         )
       ),
  -- dichiarante_com_nas
       decode(dpa.tipo_dichiarante,'', decode(dpa.cognome_dic, '', dic.com_nas_1, f_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,to_char(dpa.d_data_nas_dic,'j'))||
                                                                                    decode(sign(dpa.cod_pro_nas_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,null,'S','S',to_char(dpa.d_data_nas_dic,'j')))
                                             ),
         decode(dpa.tipo_dichiarante,
           'PD', f_comune_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,to_char(nas.d_data_nas_pd,'j'))||
                   decode(sign(nas.cod_pro_nas_pd-200),1,' '||f_provincia_stato_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,null,'S','S',to_char(nas.d_data_nas_pd,'j'))),
           'MD', f_comune_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,to_char(nas.d_data_nas_md,'j'))||
                   decode(sign(nas.cod_pro_nas_md-200),1,' '||f_provincia_stato_al(nas.cod_pro_nas_md,nas.cod_com_nas_md,null,'S','S',to_char(nas.d_data_nas_md,'j'))),
           'AL', f_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,to_char(dpa.d_data_nas_dic,'j'))||
                   decode(sign(dpa.cod_pro_nas_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,null,'S','S',to_char(dpa.d_data_nas_dic,'j'))),
           'IN', f_comune_al(nas.cod_pro_nas,nas.cod_com_nas,to_char(nas.d_data_nas,'j'))||
                   decode(sign(nas.cod_pro_nas-200),1,' '||f_provincia_stato_al(nas.cod_pro_nas,nas.cod_com_nas,null,'S','S',to_char(nas.d_data_nas,'j'))),
           'EN', dic.com_nas_1, f_comune_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,to_char(nas.d_data_nas_pd,'j'))||
                                  decode(sign(nas.cod_pro_nas_pd-200),1,' '||f_provincia_stato_al(nas.cod_pro_nas_pd,nas.cod_com_nas_pd,null,'S','S',to_char(nas.d_data_nas_pd,'j'))),
           'AM', '',
           'OS', f_comune_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,to_char(sog_OS.d_data_nas,'j'))||
                   decode(sign(sog_OS.cod_pro_nas-200),1,' '||f_provincia_stato_al(sog_OS.cod_pro_nas,sog_OS.cod_com_nas,null,'S','S',to_char(sog_OS.d_data_nas,'j'))),
           'PP', f_comune_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,to_char(sog_PP.d_data_nas,'j'))||
                   decode(sign(sog_PP.cod_pro_nas-200),1,' '||f_provincia_stato_al(sog_PP.cod_pro_nas,sog_PP.cod_com_nas,null,'S','S',to_char(sog_PP.d_data_nas,'j'))),
           'PM', f_comune_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,to_char(sog_PM.d_data_nas,'j'))||
                   decode(sign(sog_PM.cod_pro_nas-200),1,' '||f_provincia_stato_al(sog_PM.cod_pro_nas,sog_PM.cod_com_nas,null,'S','S',to_char(sog_PM.d_data_nas,'j')))
         )
       ),
       decode(dpa.tipo_dichiarante,'', decode(dpa.cognome_dic, '', dic.data_nas_1, f_CIV_cifre_lettere('D',to_char(dpa.d_data_nas_dic,'dd/mm/yyyy'),inp.valore,'S')),
         decode(dpa.tipo_dichiarante,
           'PD', f_CIV_cifre_lettere('D',to_char(nas.d_data_nas_pd,'dd/mm/yyyy'),inp.valore,'S'),
           'MD', f_CIV_cifre_lettere('D',to_char(nas.d_data_nas_md,'dd/mm/yyyy'),inp.valore,'S'),
           'AL', f_CIV_cifre_lettere('D',to_char(dpa.d_data_nas_dic,'dd/mm/yyyy'),inp.valore,'S'),
           'IN', f_CIV_cifre_lettere('D',to_char(nas.d_data_nas,'dd/mm/yyyy'),inp.valore,'S'),
           'EN', f_CIV_cifre_lettere('D',to_char(nas.d_data_nas_pd,'dd/mm/yyyy'),inp.valore,'S'),
           'AM', '',
           'OS', f_CIV_cifre_lettere('D',to_char(sog_OS.d_data_nas,'dd/mm/yyyy'),inp.valore,'S'),
           'PP', f_CIV_cifre_lettere('D',to_char(sog_PP.d_data_nas,'dd/mm/yyyy'),inp.valore,'S'),
           'PM', f_CIV_cifre_lettere('D',to_char(sog_PM.d_data_nas,'dd/mm/yyyy'),inp.valore,'S')
         )
       ),
       decode(dpa.tipo_dichiarante,'', dic.prof_1),
  -- dichiarante_residenza
       decode(dpa.tipo_dichiarante,'', decode(dpa.cognome_dic, '', dic.residenza_1, f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,nas.data_nas)||
                                                                                      decode(sign(dpa.cod_pro_res_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,null,'S','S',nas.data_nas))
                                             ),
         decode(dpa.tipo_dichiarante,
           'PD', f_comune_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,nas.data_nas)||
                   decode(sign(nas.cod_pro_res_pd-200),1,' '||f_provincia_stato_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,null,'S','S',nas.data_nas)),
           'MD', f_comune_al(nas.cod_pro_res_md,nas.cod_com_res_md,nas.data_nas)||
                   decode(sign(nas.cod_pro_res_md-200),1,' '||f_provincia_stato_al(nas.cod_pro_res_md,nas.cod_com_res_md,null,'S','S',nas.data_nas)),
           'AL', f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,nas.data_nas)||
                   decode(sign(dpa.cod_pro_res_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,null,'S','S',nas.data_nas)),
           'IN', f_comune_al(nas.cod_pro_res,nas.cod_com_res,nas.data_nas)||
                   decode(sign(nas.cod_pro_res-200),1,' '||f_provincia_stato_al(nas.cod_pro_res,nas.cod_com_res,null,'S','S',nas.data_nas)),
           'EN', f_comune_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,nas.data_nas)||
                   decode(sign(nas.cod_pro_res_pd-200),1,' '||f_provincia_stato_al(nas.cod_pro_res_pd,nas.cod_com_res_pd,null,'S','S',nas.data_nas)),
           'AM', '',
           'OS', f_comune_al(sog_OS.cod_pro_res,sog_OS.cod_com_res,nas.data_nas)||
                   decode(sign(sog_OS.cod_pro_res-200),1,' '||f_provincia_stato_al(sog_OS.cod_pro_res,sog_OS.cod_com_res,null,'S','S',nas.data_nas)),
           'PP', f_comune_al(sog_PP.cod_pro_res,sog_PP.cod_com_res,nas.data_nas)||
                   decode(sign(sog_PP.cod_pro_res-200),1,' '||f_provincia_stato_al(sog_PP.cod_pro_res,sog_PP.cod_com_res,null,'S','S',nas.data_nas)),
           'PM', f_comune_al(sog_PM.cod_pro_res,sog_PM.cod_com_res,nas.data_nas)||
                   decode(sign(sog_PM.cod_pro_res-200),1,' '||f_provincia_stato_al(sog_PM.cod_pro_res,sog_PM.cod_com_res,null,'S','S',nas.data_nas))
         )
       ),
       decode(dpa.tipo_dichiarante,'', decode(dpa.cognome_dic, '', dic.il, decode(dpa.sesso_dic,'M','i')),
         decode(dpa.tipo_dichiarante,
           'PD', 'i',
           'AL', decode(dpa.sesso_dic,'M','i'),
           'IN', decode(nas.sesso,'M','i'),
		   'OS', decode(sog_OS.sesso,'M','i'),
		   'PP', decode(sog_PP.sesso,'M','i'),
		   'PM', decode(sog_PM.sesso,'M','i')
         )
       ),
       decode(dpa.tipo_dichiarante,'', decode(dpa.cognome_dic, '', dic.la, decode(dpa.sesso_dic,'F','a')),
         decode(dpa.tipo_dichiarante,
           'MD', 'a',
           'AL', decode(dpa.sesso_dic,'F','a'),
           'IN', decode(nas.sesso,'F','a'),
           'OS', decode(sog_OS.sesso,'F','a'),
           'PP', decode(sog_PP.sesso,'F','a'),
           'PM', decode(sog_PM.sesso,'F','a')
         )
       ),
       decode(dpa.tipo_dichiarante,'', dic.riga1),
       decode(dpa.tipo_dichiarante,'', dic.riga2),
       decode(dpa.tipo_dichiarante,'', dic.riga3),
       decode(dpa.tipo_dichiarante,'', dic.riga4),
       decode(dpa.tipo_dichiarante,'', dic.riga5),
       decode(dpa.tipo_dichiarante,'', dic.riga5),
       decode(dpa.tipo_dichiarante,'', dic.riga6),
       decode(dpa.tipo_dichiarante,'', dic.riga7),
-- dichiarante_comprensione
       f_CIV_comprensione(dpa.comprensione_dic,decode(dpa.tipo_dichiarante,'PD', 'M','MD','F','AL',dpa.sesso_dic,'IN',nas.sesso)),
-- motivo_impedimento_dichiarante
       decode(dpa.comprensione_dic, '', null, dpa.motivo_impedimento_dic),
-- RICONOSCIMENTO_1
       decode(nas.tipo_riconoscimento, '', '', dpa.riconoscimento_pre_anno_1), 
       decode(nas.tipo_riconoscimento, '', '', 
         decode(f_CIV_numero_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1), '', to_char(dpa.riconoscimento_pre_atto_1), dpa.riconoscim_pre_id_atto_ansc_1)), 
       decode(nas.tipo_riconoscimento, '', '', dpa.riconoscimento_pre_parte_1), 
       decode(nas.tipo_riconoscimento, '', '', dpa.riconoscimento_pre_serie_1), 
       decode(nas.tipo_riconoscimento, '', '', dpa.riconoscimento_pre_ufficio_1), 
       decode(nas.tipo_riconoscimento, '', '', to_char(dpa.d_riconoscimento_pre_data_1,'yyyy-mm-dd')), 
  -- RICONOSCIMENTO_PRE_COMUNE_1
       decode(nas.tipo_riconoscimento, '', '', f_comune_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, to_char(dpa.d_riconoscimento_pre_data_1,'j'))), 
  -- RICONOSCIMENTO_PRE_PROVINCIA_1
       decode(nas.tipo_riconoscimento, '', '', f_provincia_stato_al(dpa.riconoscimento_pre_cod_pro_1, dpa.riconoscimento_pre_cod_com_1, '','S','S', to_char(dpa.d_riconoscimento_pre_data_1,'j'))),
       decode(nas.tipo_riconoscimento, '', '', f_CIV_numero_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_1)), 
-- RICONOSCIMENTO_2
       decode(nas.tipo_riconoscimento, 'PDMD', dpa.riconoscimento_pre_anno_2), 
       decode(nas.tipo_riconoscimento, 'PDMD', 
         decode(f_CIV_numero_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_2), '', to_char(dpa.riconoscimento_pre_atto_2), dpa.riconoscim_pre_id_atto_ansc_2)), 
       decode(nas.tipo_riconoscimento, 'PDMD', dpa.riconoscimento_pre_parte_2), 
       decode(nas.tipo_riconoscimento, 'PDMD', dpa.riconoscimento_pre_serie_2), 
       decode(nas.tipo_riconoscimento, 'PDMD', dpa.riconoscimento_pre_ufficio_2), 
       decode(nas.tipo_riconoscimento, 'PDMD', to_char(dpa.d_riconoscimento_pre_data_2,'yyyy-mm-dd')), 
  -- RICONOSCIMENTO_PRE_COMUNE_2
       decode(nas.tipo_riconoscimento, 'PDMD', f_comune_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2, to_char(dpa.d_riconoscimento_pre_data_2,'j'))), 
  -- RICONOSCIMENTO_PRE_PROVINCIA_2
       decode(nas.tipo_riconoscimento, 'PDMD', f_provincia_stato_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2, '', 'S', 'S', to_char(dpa.d_riconoscimento_pre_data_2,'j'))),
       decode(nas.tipo_riconoscimento, 'PDMD', f_CIV_numero_atto_ansc(dpa.riconoscim_pre_id_atto_ansc_2)), 
-- trascrizione_...
       decode(trunc(to_char(dpa.d_data_atto_utente,'yyyy')/100),
           '',decode(sign(50 - nvl(f_CIV_lettere_cifre(ttr.anno_tr),0)),-1,'millenovecento','duemila'),
         '18','milleottocento',
         '19','millenovecento',
         '20','duemila',
         '21','duemilacento')||
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'anno_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'giorno_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'mese_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'ore_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'minuti_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'ufficiale_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'comune_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'motivo_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'data_tr'),
       f_CIV_campi_testata(2,nas.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas,
                             'comune_or'),
-- margine_sentenza_...
-- margine_sentenza_tribunale_1
       nvl(decode(mar.stampa_sen,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(mar.tribunale_1,rpad('_',40,'_')),
                          rpad(nvl(mar.tribunale_1,'_'),40,'_')
                  )
           ),
           rpad('_',40,'_')
       ),
-- margine_sentenza_tribunale_2
       nvl(decode(mar.stampa_sen,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(mar.tribunale_2,rpad('_',40,'_')),
                          rpad(nvl(mar.tribunale_2,'_'),40,'_')
                   )
           ),
           rpad('_',40,'_')
       ),
-- margine_sentenza_data
       nvl(decode(mar.stampa_sen,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(mar.data_sen,rpad('_',10,'_')),
                          rpad(nvl(mar.data_sen,'_'),20,'_')
                  )
           ),
            decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
             'A4', rpad('_',10,'_'),
                   rpad('_',20,'_')
            )
       ),
-- margine_sentenza_anno
       nvl(decode(mar.stampa_sen,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(decode(mar.anno_sen,'','','duemila'||mar.anno_sen),rpad('_',20,'_')),
                          rpad(nvl(decode(mar.anno_sen,'','','duemila'||mar.anno_sen),'_'),40,'_')
                   )
            ),
            decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
              'A4', rpad('_',20,'_'),
                    rpad('_',40,'_')
            )
       ),
-- margine_sentenza_atto_tras
       nvl(decode(mar.stampa_sen,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(to_char(mar.atto_tras_sen),rpad('_',4,'_')),
                          rpad(nvl(to_char(mar.atto_tras_sen),'_'),6,'_'))
                  ),
           decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
             'A4', rpad('_',4,'_'),
                   rpad('_',6,'_')
           )
       ),
-- margine_sentenza_anno_tras
       nvl(decode(mar.stampa_sen,
             'S', rpad(nvl(mar.anno_atto_tras_sen,'_'),4,'_')),
           rpad('_',4,'_')
       ),
-- margine_sentenza_e_stato
       nvl(decode(mar.stampa_sen,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(mar.e_stato,rpad('_',12,'_')),
                          rpad(nvl(mar.e_stato,'_'),12,'_')
                  )
           ),
           rpad('_',12,'_')
       ),
-- margine_sentenza_data_firma
       nvl(decode(mar.stampa_sen,
             'S', nvl(to_char(to_date(mar.data_firma_sen,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
           ),
           rpad('_',10,'_')
       ),
-- margine_sentenza
       decode(mar.stampa_sen,
         'S', 'Con sentenza del Tribunale di '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.tribunale_1||' '||mar.tribunale_2,rpad('_',40,'_')),
                      rpad(nvl(mar.tribunale_1,'_'),40,'_')||' '||rpad(nvl(mar.tribunale_2,'_'),40,'_')
              )||
              ' in data '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.data_sen,rpad('_',20,'_')),
                      rpad(nvl(mar.data_sen,'_'),20,'_')
              )||' '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(decode(mar.anno_sen,'','','duemila'||mar.anno_sen),rpad('_',20,'_')),
                      rpad(nvl(decode(mar.anno_sen,'','','duemila'||mar.anno_sen),'_'),40,'_')
              )||
              ' trascritta nei registri di nascita di questo Comune'||
              ' al N. '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(to_char(mar.atto_tras_sen),rpad('_',4,'_')),
                      rpad(nvl(to_char(mar.atto_tras_sen),'_'),6,'_')
              )||
              ' P.  II  Serie  B,  dell''anno '||
              rpad(nvl(mar.anno_atto_tras_sen,'_'),4,'_')||
              ' il presente atto '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.e_stato,rpad('_',12,'_')),
                      rpad(nvl(mar.e_stato,'_'),12,'_')
              )||
              ' dichiarato valido.'
       ),
-- margine_sentenza_li_data
       decode(mar.stampa_sen,
         'S', 'li '||nvl(to_char(to_date(mar.data_firma_sen,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_sentenza_ufficiale
       decode(mar.stampa_sen,
         'S', 'L''UFFICIALE DELLO STATO CIVILE'
       ),
-- margine_sentenza_firma
       decode(mar.stampa_sen,
         'S', decode(nas.natura,
                'O', rpad('_',30,'_'),
                     'F.to: '||nvl(dpa.ufficiale_prov,rpad('.',24,'.'))
              )
       ),
-- margine_trascrizione_...
-- margine_trascrizione_comune
       nvl(decode(mar.stampa_tr1,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(mar.comune_tras_1,rpad('_',40,'_')),
                          rpad(nvl(mar.comune_tras_1,'_'),40,'_')
                  )
           ),
           rpad('_',40,'_')
       ),
-- margine_trascrizione_atto
       nvl(decode(mar.stampa_tr1,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(to_char(mar.atto_tras_1),rpad('_',6,'_')),
                          rpad(nvl(to_char(mar.atto_tras_1),'_'),6,'_')
                  )
           ),
           rpad('_',6,'_')
       ),
-- margine_trascrizione_parte
       nvl(decode(mar.stampa_tr1,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                    'A4', nvl(decode(mar.parte_tras_1,'1','I','2','II',mar.parte_tras_1),rpad('_',4,'_')),
                          rpad(nvl(decode(mar.parte_tras_1,'1','I','2','II',mar.parte_tras_1),'_'),4,'_')
                  )
           ),
           rpad('_',4,'_')
       ),
-- margine_trascrizione_serie
       nvl(decode(mar.stampa_tr1,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                     'A4', nvl(mar.serie_tras_1,rpad('_',4,'_')),
                           rpad(nvl(mar.serie_tras_1,'_'),4,'_')
                 )
           ),
           rpad('_',4,'_')
       ),
-- margine_trascrizione_anno_atto
       nvl(decode(mar.stampa_tr1,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                     'A4', nvl(mar.anno_tras_1,rpad('_',4,'_')),
                           rpad(nvl(mar.anno_tras_1,'_'),4,'_')
                  )
           ),
           rpad('_',4,'_')
       ),
-- margine_trascrizione_data_com
       nvl(decode(mar.stampa_tr1,
             'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                     'A4', nvl(to_char(to_date(mar.data_comunicazione_1,'j'),'dd/mm/yyyy'),rpad('_',15,'_')),
                           rpad(nvl(to_char(to_date(mar.data_comunicazione_1,'j'),'dd/mm/yyyy'),'_'),15,'_')
                  )
           ),
           decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                     'A4', rpad('_',10,'_'),
                           rpad('_',15,'_')
           )
       ),
-- margine_trascrizione_data
       nvl(decode(mar.stampa_tr1,
             'S', nvl(to_char(to_date(mar.data_firma_1,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))),
           rpad('_',10,'_')
       ),
-- margine_trascrizione
       decode(mar.stampa_tr1,
         'S', 'Il presente atto di nascita e'' stato trascritto nei registri'||
              ' dello Stato Civile del Comune di '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.comune_tras_1,rpad('_',40,'_')),
                      rpad(nvl(mar.comune_tras_1,'_'),40,'_')
              )||
              ' al N. '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(to_char(mar.atto_tras_1),rpad('_',4,'_')),
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
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(to_char(to_date(mar.data_comunicazione_1,'j'),'dd/mm/yyyy'),rpad('_',10,'_')),
                      rpad(nvl(to_char(to_date(mar.data_comunicazione_1,'j'),'dd/mm/yyyy'),'_'),15,'_')
              )
       ),
-- margine_trascrizione_li_data
       decode(mar.stampa_tr1,
         'S', 'li '||nvl(to_char(to_date(mar.data_firma_1,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_trascrizione_ufficiale
       decode(mar.stampa_tr1,
         'S', 'L''UFFICIALE DELLO STATO CIVILE'
       ),
-- margine_trascrizione_firma
       decode(mar.stampa_tr1,
         'S', rpad('_',30,'_')
       ),
-- concepito_da_mesi
       decode(cta.sigla,
         'RPN', nas.concepito_da_mesi, ''
       ),
-- certificato_rilasciato
       decode(cta.sigla,
         'RPN', dpa.autorita_atto_orig, ''
       ),
-- certificato_data
       decode(cta.sigla,
         'RPN', nvl(to_char(to_date(dpa.data_atto_orig,'j'),'dd/mm/yyyy'),rpad('...',10,'_')), ''
       )
  FROM arcinp inp,
       civcta cta, civdta dta,
       civocc occ, civsog sog_IT, civsog sog_OS, civsog sog_PP, civsog sog_PM,
       civchi chi, civpre pre, civdna dna,
       civdic dic, civtes tes,
       civttr ttr,
       civdpa dpa, civmar mar,
       civnas nas
 WHERE inp.parametro        = 'ATTI_PRIMO'
   and cta.id      	(+) = dta.id_civcta
   and dta.id      	(+) = nas.id_civdta
   and sog_IT.id_atto        (+) = nas.id_atto
   and sog_IT.tipo_soggetto  (+) = 'IT'
   and sog_OS.id_atto        (+) = nas.id_atto
   and sog_OS.tipo_soggetto  (+) = 'OS'
   and sog_PP.id_atto        (+) = nas.id_atto
   and sog_PP.tipo_soggetto  (+) = 'PP'
   and sog_PM.id_atto        (+) = nas.id_atto
   and sog_PM.tipo_soggetto  (+) = 'PM'
   and chi.id_atto 	(+) = nas.id_atto
   and pre.id_atto 	(+) = nas.id_atto
   and dna.id_atto 	(+) = nas.id_atto
   and dic.id_atto 	(+) = nas.id_atto
   and tes.id_atto 	(+) = nas.id_atto
   and ttr.id_atto 	(+) = nas.id_atto
   and dpa.id_atto	(+) = nas.id_atto
   and mar.id_atto	(+) = nas.id_atto
--       
   and occ.id_atto	(+) = nas.id_atto
   and nas.cod_rec	    in (0,3)
/
comment on table civwna_totale is 'Stato Civile - Variabili per composizione Atti di Nascita'
/
