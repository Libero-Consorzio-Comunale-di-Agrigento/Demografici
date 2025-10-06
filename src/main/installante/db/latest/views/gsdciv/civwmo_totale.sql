--liquibase formatted sql
--changeset snocca:202301051057 runAlways:true runOnChange:true stripComments:false
create or replace view civwmo_totale
       (cod_rec, ufficio, anno, atto, parte, serie, natura,
        numero_atto_ansc,
        UFFICIO_ORIG, ANNO_ORIG, ATTO_ORIG, PARTE_ORIG, SERIE_ORIG,
        numero_atto_ansc_orig,
        ANNO_OGGI, MESE_OGGI, GIORNO_OGGI, ORE_OGGI, MINUTI_OGGI, 
        DECEDUT_OA, MORT_OA, 
        DATA_MORTE, ANNO_MORTE, MESE_MORTE, GIORNO_MORTE,
        ORE, MINUTI, COMUNE_MORTE,
        COGNOME_NOME, 
        cognome, nome,
        SESSO,
        NAT_OA, DATA_NASCITA, ANNO_NASCITA, MESE_NASCITA, GIORNO_NASCITA,
        ATTO_NASCITA, COMUNE_NASCITA, COMUNE_RESIDENZA,
        NAZIONALITA, PROFESSIONE, 
        STATO_CIVILE, 
        COGNOME_NOME_CONIUGE, COGNOME_CONIUGE, NOME_CONIUGE,
	sesso_cn, comune_residenza_cn, comune_nascita_cn,
	nazionalita_cn, data_nascita_cn,
        FIGLI_OA, 
        PATERNITA, COGNOME_PADRE, NOME_PADRE,
        MATERNITA, COGNOME_MADRE, NOME_MADRE,
        COGNOME_INTERPRETE, NOME_INTERPRETE, COMUNE_NASCITA_INTERPRETE, COMUNE_RESIDENZA_INTERPRETE, DATA_NASCITA_INTERPRETE,
        COGNOME_RICHIEDENTE, NOME_RICHIEDENTE, COMUNE_NASCITA_RICHIEDENTE, COMUNE_RESIDENZA_RICHIEDENTE, DATA_NASCITA_RICHIEDENTE,
        COMUNE_DATA,COMUNE,DATA,
        autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	frazione_prov, autorita_prov_ufficio, nota_rif, anno_nota_rif, data_nota_rif,
	ufficiale_prov, qualifica_prov,
        protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
	ente_straniero, comune_ente_straniero, stato_ente_straniero, data_atto_ente_straniero,
	tipo_atto_ente_straniero, estremi_atto_ente_straniero, 
        ufficiale_utente,
        ricevuto,nel_luogo_morte,luogo_morte_1,luogo_morte_2,
        DATA_ATTO_ORIGINALE, ANNO_ATTO_ORIGINALE, MESE_ATTO_ORIGINALE, 
        GIORNO_ATTO_ORIGINALE, ORE_ATTO_ORIGINALE, MINUTI_ATTO_ORIGINALE,
        dichiarante_comparso,dichiarante,dichiarante_cognome, dichiarante_nome, dichiarante_sesso,
        dichiarante_nato,dichiarante_com_nas,dichiarante_data_nas,          
        dichiarante_prof,dichiarante_residenza,dichiarante_il_quale, 
        dichiarante_comprensione, dichiarante_motivo_impedimento,
        chiusura_riga1,chiusura_riga2,chiusura_riga3,chiusura_firma,
        testata_anno,testata_giorno,testata_mese,testata_ore,testata_minuti,                             
        testata_ufficiale,testata_comune,testata_motivo,
        testata_ricevuto,testata_documento,testata_data_doc,testata_munito,                                                 
        dati_morte_giorno,dati_morte_mese,dati_morte_anno,
        dati_morte_ore,dati_morte_minuti,            
        dati_morte_nel,dati_morte_luogo_riga1,dati_morte_luogo_riga2,
        dati_morte_mort_oa,dati_morte_defunto,          
        dati_morte_cittadinanza,dati_morte_prof,dati_morte_residenza,	
        dati_morte_nato,dati_morte_com_nas,dati_morte_data_nas,
        genitori_figlio, 
        genitori_padre, genitori_prof_padre, genitori_residenza_padre,
        genitori_madre, genitori_prof_madre, genitori_residenza_madre,        
        genitori_stato_civ_riga1, genitori_stato_civ_riga2,
        genitori_stato_civ_riga3, genitori_stato_civ_riga4,
        genitori_firma, 
        trascrizione_anno,trascrizione_giorno,trascrizione_mese,
        trascrizione_ore,trascrizione_minuti,
        trascrizione_ufficiale,trascrizione_comune,trascrizione_motivo,
        trascrizione_comune_orig,
        margine_nascita_comune,margine_nascita_atto,margine_nascita_parte,
        margine_nascita_serie,margine_nascita_ufficio,margine_nascita_anno,
        margine_nascita_data,
        margine_nascita,margine_nascita_li_data,
        margine_nascita_ufficiale,margine_nascita_firma,
        margine_trascrizione_comune,
        margine_trascrizione_atto,margine_trascrizione_parte,
        margine_trascrizione_serie,margine_trascrizione_anno_atto,
        margine_trascrizione_data_com,margine_trascrizione_data,
        margine_trascrizione,margine_trascrizione_li_data,
        margine_trascrizione_ufficiale,margine_trascrizione_firma
       )
AS
SELECT mor.cod_rec, mor.ufficio, mor.anno, mor.atto, mor.parte, mor.serie, mor.natura,
       f_CIV_numero_atto_ansc(mor.id_atto_ansc),
-- estremi atto originale
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.ufficio_orig), 
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', to_char(dpa.anno_orig), f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig)), 
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.atto_orig),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', decode(dpa.parte_orig,'',to_char(null),1,'I',2,'II')),
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', dpa.serie_orig),
       f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig),
-- anno_oggi
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'anno_oggi'),
-- mese_oggi
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'mese_oggi'),
-- giorno_oggi
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'giorno_oggi'),
-- ore_oggi
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ore_oggi'),
-- minuti_oggi
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'minuti_oggi'),
-- decedut_oa
	   decode(mor.des_evento_mor, null, upper(decode(mor.sesso,'M','deceduto','F','deceduta','deceduto/a')), mor.des_evento_mor),  
-- mort_oa
       decode(mor.des_evento_mor, null, decode(mor.sesso,'M','morto','F','morta','morto/a'), mor.des_evento_mor),
-- data_morte
       decode(mor.des_data_mor, null,
         decode(mor.flag_gg_imprecisato,'S','giorno IMPRECISATO del mese di ',
           f_CIV_cifre_lettere('G',to_char(to_date(mor.data_mor,'j'),'dd'),inp.valore,'')
         )
         ||' '||
         decode(mor.flag_mm_imprecisato,'S','IMPRECISATO dell''anno',
           f_CIV_cifre_lettere('M',to_char(to_date(mor.data_mor,'j'),'mm'),'','')
         )
         ||' '||
         decode(mor.flag_aa_imprecisato,'S','IMPRECISATO',
           f_CIV_cifre_lettere('A',to_char(to_date(mor.data_mor,'j'),'yyyy'),'','')
         ),
         mor.des_data_mor),
-- anno_morte
       decode(mor.des_data_mor, null,   
         decode(mor.flag_aa_imprecisato,'S','IMPRECISATO',
           f_CIV_cifre_lettere('A',to_char(to_date(mor.data_mor,'j'),'yyyy'),'','')
         )),
-- mese_morte
       decode(mor.des_data_mor, null,
         decode(mor.flag_mm_imprecisato,'S','IMPRECISATO',
           f_CIV_cifre_lettere('M',to_char(to_date(mor.data_mor,'j'),'mm'),'','')
         )),
-- giorno_morte
       decode(mor.des_data_mor, null,
         decode(mor.flag_gg_imprecisato,'S','IMPRECISATO',
           f_CIV_cifre_lettere('G',to_char(to_date(mor.data_mor,'j'),'dd'),inp.valore,'')
         ),
         mor.des_data_mor),
-- ore
       decode(mor.des_ore_minuti_mor, null, 
         decode(mor.flag_hh_imprecisato,'S','IMPRECISATE',
           f_CIV_cifre_lettere('h', to_char(mor.ore),'', '')
         ),
         mor.des_ore_minuti_mor),
-- minuti
       decode(mor.des_ore_minuti_mor, null, 
         decode(mor.flag_mi_imprecisato,'S','IMPRECISATI',
           f_CIV_cifre_lettere('m', to_char(mor.minuti),'', '')
         )),
-- comune_morte
       f_comune_al(mor.cod_pro_mor,mor.cod_com_mor,mor.data_mor)||' '||
         f_provincia_stato_al(mor.cod_pro_mor,mor.cod_com_mor,null,'S','S',mor.data_mor),
-- cognome_nome
       decode(occ.atto,'', translate(mor.cognome_nome,'/',' '), occ.cognome||' '||occ.nome),
-- cognome
       decode(occ.atto,'', mor.cognome, occ.cognome),
-- nome
       decode(occ.atto,'', mor.nome, occ.nome),
-- sesso
       decode(mor.sesso,'M','maschile','F','femminile','non conosciuto'),
-- nat_oa
       decode(mor.sesso,'M','nato','F','nata','nato/a'),
-- data_nascita
       decode(mor.data_nas,'',
         decode(mor.anni,'','','di anni '||f_CIV_cifre_lettere('U',mor.anni,'','')),
         decode(mor.anno_nas,'S', f_CIV_cifre_lettere('A',to_char(to_date(mor.data_nas,'j'),'yyyy'),'',''),
           decode(mor.flag_GG_imprecisato_nas,'S','',f_CIV_cifre_lettere('G',to_char(to_date(mor.data_nas,'j'),'dd'),inp.valore,'S')||' ')||
           decode(mor.flag_MM_imprecisato_nas,'S','',f_CIV_cifre_lettere('M',to_char(to_date(mor.data_nas,'j'),'mm'),'','S')||' ')||
           decode(mor.flag_AA_imprecisato_nas,'S','imprecisata',f_CIV_cifre_lettere('A',to_char(to_date(mor.data_nas,'j'),'yyyy'),'','S')||' ')
         )
       ),
-- anno_nascita
       decode(mor.flag_AA_imprecisato_nas,'S','imprecisata',f_CIV_cifre_lettere('A',to_char(to_date(mor.data_nas,'j'),'yyyy'),'','S')),
-- mese_nascita
       decode(mor.flag_MM_imprecisato_nas,'S','imprecisato',f_CIV_cifre_lettere('M',to_char(to_date(mor.data_nas,'j'),'mm'),'','S')),
-- giorno_nascita
       decode(mor.flag_GG_imprecisato_nas,'S','imprecisato',f_CIV_cifre_lettere('G',to_char(to_date(mor.data_nas,'j'),'dd'),inp.valore,'S')),
-- atto_nascita
       decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '',
         'Atto N. '||decode(mar.atto_nas,'','_____',to_char(mar.atto_nas))||
           ' P. '||decode(mar.parte_nas,'1','I','2','II',nvl(mar.parte_nas,'___'))||
           ' S. '||nvl(mar.serie_nas,'___')||
           ' - '||nvl(mar.anno_nas,'_____'),
         'Atto N. '||mar.id_atto_ansc_nas),
-- comune_nascita
       nvl(rtrim(f_comune_al(mor.cod_pro_nas,mor.cod_com_nas,mor.data_nas)||' '||
                 f_provincia_stato_al(mor.cod_pro_nas,mor.cod_com_nas,null,'S','S',mor.data_nas)),
           rpad('...',30,'_')
       ),
-- comune_residenza
       nvl(rtrim(f_comune_al(mor.cod_pro_res,mor.cod_com_res,mor.data_mor)||' '||
                 f_provincia_stato_al(mor.cod_pro_res,mor.cod_com_res,null,'S','S',mor.data_mor)),
           rpad('...',30,'_')
       ),
-- nazionalita
       decode(mor.sesso,
         'M', 'cittadino '||nvl(lower(f_get_descrizione_DCI(mor.nazionalita,'M')),rpad('...',20,'_')),
         'F', 'cittadina '||nvl(lower(f_get_descrizione_DCI(mor.nazionalita,'F')),rpad('...',20,'_')),
              'cittadinanza '||nvl(lower(f_get_descrizione_DCI(mor.nazionalita,'')),rpad('...',20,'_'))
       ),
-- professione
       rpad('...',20,'_'),
-- stato_civile
       nvl(f_get_descrizione_DSC(mor.stato_civile,mor.sesso,'','','S'),rpad('...',20,'_')),
-- cognome_nome_coniuge    
       translate(mor.cognome_nome_cn,'/',' '),
-- cognome_coniuge
       mor.cognome_cn,
-- nome_coniuge
       mor.nome_cn,
-- sesso_cn
       decode(mor.sesso_cn,'M','maschile','F','femminile','non conosciuto'),
-- comune_residenza_cn
       rtrim(f_comune_al(mor.cod_pro_res_cn, mor.cod_com_res_cn, '')||' '||
             f_provincia_stato_al(mor.cod_pro_res_cn, mor.cod_com_res_cn,'','S','S','')),
-- comune_nascita_cn
       rtrim(f_comune_al(mor.cod_pro_nas_cn, mor.cod_com_nas_cn, '')||' '||
             f_provincia_stato_al(mor.cod_pro_nas_cn, mor.cod_com_nas_cn,'','S','S','')),
-- nazionalita_cn
       decode(mor.sesso_cn,
         'M', 'cittadino '||nvl(lower(f_get_descrizione_DCI(mor.nazionalita_cn,'M')),rpad('...',20,'_')),
         'F', 'cittadina '||nvl(lower(f_get_descrizione_DCI(mor.nazionalita_cn,'F')),rpad('...',20,'_')),
              'cittadinanza '||nvl(lower(f_get_descrizione_DCI(mor.nazionalita_cn,'')),rpad('...',20,'_'))
	),
-- data_nascita_cn
       f_CIV_cifre_lettere('D',to_char(mor.d_data_nas_cn,'dd/mm/yyyy'),inp.valore,'S'),
-- figli_oa
       decode(mor.sesso,'M','figlio','F','figlia','figlio/a'),
-- paternita
       translate(mor.paternita,'/',' '),
-- cognome_pd
       mor.cognome_pd,
-- nome_pd
       mor.nome_pd,
-- maternita
       translate(mor.maternita,'/',' '),
-- cognome_md
       mor.cognome_md,
-- nome_md
       mor.nome_md,
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
       nvl(rtrim(f_comune_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,to_char(mor.d_data_mor,'j'))||' '||
                 f_provincia_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,null,'S','S',to_char(mor.d_data_mor,'j'))),
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
         nvl(rtrim(f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.data_mor)||
                     decode(sign(dpa.cod_pro_res_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,null,'S','S',mor.data_mor))),
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
       nvl(f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ufficiale_utente'),rpad('...',30,'_')),
-- ricevuto
       nvl(dpa.ricevuto,rpad('...',30,'_')),
-- nel_luogo_morte
       'nel'||dpa.nel_mor||' '||nvl(dpa.luogo_mor_1,rpad('...',30,'_')),
-- luogo_morte_1
        nvl(dpa.luogo_mor_1,rpad('...',30,'_')),
-- luogo_morte_2
        nvl(dpa.luogo_mor_2,rpad('...',30,'_')),
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
-- dichiarante_...
       decode(dpa.sesso_dic,'M','o','F','a', dic.comparso),
       decode(dpa.cognome_dic, '',dic.dic_1, dpa.cognome_dic||' '||dpa.nome_dic),
	   dpa.cognome_dic,
	   dpa.nome_dic,
	   decode(dpa.sesso_dic,'M','maschile','F','femminile','non conosciuto'),
       decode(dpa.sesso_dic,'M','o','F','a', dic.nato_1),
  -- dichiarante_com_nas
       'in '||decode(dpa.cod_pro_nas_dic, '', dic.com_nas_1, f_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,to_char(dpa.d_data_nas_dic,'j'))||
                                                               decode(sign(dpa.cod_pro_nas_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,null,'S','S',to_char(dpa.d_data_nas_dic,'j')))
                    ),
       decode(dpa.d_data_nas_dic, '', dic.data_nas_1, 
         f_CIV_cifre_lettere('D',to_char(dpa.d_data_nas_dic,'dd/mm/yyyy'),inp.valore,'S')),
       to_char(null),  
  -- dichiarante_residenza
       decode(dpa.cod_pro_res_dic, '', dic.residenza_1, f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,mor.data_mor)||
                                                          decode(sign(dpa.cod_pro_res_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,null,'S','S',mor.data_mor))
             ),
       decode(dpa.sesso_dic,'M','il','F','la'),
-- dichiarante_comprensione
       f_CIV_comprensione(dpa.comprensione_dic, dpa.sesso_dic),
-- motivo_impedimento_dichiarante
       decode(dpa.comprensione_dic, '', null, dpa.motivo_impedimento_dic),
-- chiusura_...
       chi.riga1, 
       chi.riga2, 
       chi.riga3,
       decode(dpa.ufficiale_prov,'',chi.firma,dpa.ufficiale_prov),
-- testata_...
       decode(trunc(nvl(to_char(dpa.d_data_atto_orig,'yyyy'),to_char(dpa.d_data_atto_utente,'yyyy'))/100),
           '',decode(sign(50 - nvl(f_CIV_lettere_cifre(tes.anno_testata),0)),-1,'millenovecento','duemila'),
         '18','milleottocento',
         '19','millenovecento',
         '20','duemila',
         '21','duemilacento')||
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'anno_testata'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'giorno'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'mese'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'ore'), 
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'minuti'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'ufficiale'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'comune'), 
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'motivo'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'ricevuto'), 
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'documento'), 
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'data_doc'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,tes.ricevuto,tes.documento,tes.data_doc,
                             '','','','','','','','','','','',
                             '','','',
                             'munito'),
-- dati_morte_...
       decode(mor.flag_gg_imprecisato,'S','IMPRECISATO',
         f_CIV_cifre_lettere('G',to_char(to_date(mor.data_mor,'j'),'dd'),inp.valore,'')
       ),
       decode(mor.flag_mm_imprecisato,'S','IMPRECISATO',
         f_CIV_cifre_lettere('M',to_char(to_date(mor.data_mor,'j'),'mm'),'','')
       ),
       decode(mor.flag_aa_imprecisato,'S','IMPRECISATO',
         f_CIV_cifre_lettere('A',to_char(to_date(mor.data_mor,'j'),'yyyy'),'','')
       ),
       decode(mor.flag_hh_imprecisato,'S','IMPRECISATE',
         f_CIV_cifre_lettere('h', to_char(mor.ore),'', '')
       ),
       decode(mor.flag_mi_imprecisato,'S','IMPRECISATI',
         f_CIV_cifre_lettere('m', to_char(mor.minuti),'', '')
       ),
       DECODE(dpa.luogo_mor_1, null, dmo.nel, dpa.nel_mor),
       DECODE(dpa.luogo_mor_1, null, dmo.luogo_mor_1, dpa.luogo_mor_1),
       DECODE(dpa.luogo_mor_1, null, dmo.luogo_mor_2, to_char(null)),
       DECODE(mor.sesso, 'M', 'o', 'F', 'a'),
       mor.cognome||' '||mor.nome,
       DECODE(mor.sesso, '', 'cittadinanza', 'M', 'cittadino ', 'F', 'cittadina ')||
         f_get_descrizione_DCI(mor.nazionalita,mor.sesso),
       to_char(null),
  -- dati_morte_residenza
       f_comune_al(mor.cod_pro_res,mor.cod_com_res,mor.data_mor)||
         decode(sign(mor.cod_pro_res-200),1,' '||f_provincia_stato_al(mor.cod_pro_res,mor.cod_com_res,null,'S','S',mor.data_mor)),
       DECODE(mor.sesso, 'M', 'o', 'F', 'a'),
  -- dati_morte_com_nas
       'in '||f_comune_al(mor.cod_pro_nas,mor.cod_com_nas,mor.data_nas)||
                decode(sign(mor.cod_pro_nas-200),1,' '||f_provincia_stato_al(mor.cod_pro_nas,mor.cod_com_nas,null,'S','S',mor.data_nas)),
       decode(mor.flag_GG_imprecisato_nas,'S','',f_CIV_cifre_lettere('G',to_char(to_date(mor.data_nas,'j'),'dd'),inp.valore,'')||' ')||
       decode(mor.flag_MM_imprecisato_nas,'S','',f_CIV_cifre_lettere('M',to_char(to_date(mor.data_nas,'j'),'mm'),'','')||' ')||
       decode(mor.flag_AA_imprecisato_nas,'S','imprecisata',f_CIV_cifre_lettere('A',to_char(to_date(mor.data_nas,'j'),'yyyy'),'','')||' '),
-- genitori_...
       to_char(null), 
       to_char(null), to_char(null), to_char(null), 
       to_char(null), to_char(null), to_char(null), 
       lower(f_get_descrizione_dsc(mor.stato_civile,mor.sesso,'','','S')),
       mor.cognome_cn||' '||mor.nome_cn,
       to_char(null), to_char(null), 
       to_char(null), 
-- trascrizione_...
       decode(trunc(to_char(dpa.d_data_atto_utente,'yyyy')/100),
           '',decode(sign(50 - nvl(f_CIV_lettere_cifre(ttr.anno_tr),0)),-1,'millenovecento','duemila'),
         '18','milleottocento',
         '19','millenovecento',
         '20','duemila',
         '21','duemilacento')||
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'anno_tr'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'giorno_tr'), 
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'mese_tr'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ore_tr'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'minuti_tr'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ufficiale_tr'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'comune_tr'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'motivo_tr'),
       f_CIV_campi_testata(5,mor.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,dpa.ricevuto,dpa.documento_tes,dpa.d_data_documento_tes,
                             '','','','','','','','','','','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'comune_or'),
-- margine_nascita_...
-- margine_nascita_comune
       decode(mar.stampa_nas,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(comune_nas,rpad('_',30,'_')),
                      rpad(nvl(comune_nas,'_'),40,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',30,'_'),
                      rpad('_',40,'_')
              )
       ),
-- margine_nascita_atto
       decode(mar.stampa_nas,
         'S', decode(mar.id_atto_ansc_nas,'',
                decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                  'A4', nvl(to_char(atto_nas),rpad('_',4,'_')),
                        rpad(nvl(to_char(atto_nas),'_'),6,'_')
                ),
               mar.id_atto_ansc_nas
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',4,'_'),
                      rpad('_',6,'_')
              )
       ),                    
-- margine_nascita_parte
       decode(mar.stampa_nas,
         'S', decode(mar.id_atto_ansc_nas,'',
                decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                  'A4', nvl(decode(mar.parte_nas,'1','I','2','II',mar.parte_nas),rpad('_',2,'_')),
                        rpad(nvl(decode(mar.parte_nas,'1','I','2','II',mar.parte_nas),'_'),4,'_')
                )
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',2,'_'),
                      rpad('_',4,'_')
              )
       ),        
-- margine_nascita_serie
       decode(mar.stampa_nas,
         'S', decode(mar.id_atto_ansc_nas,'',
                decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                  'A4', nvl(mar.serie_nas,rpad('_',2,'_')),
                        rpad(nvl(mar.serie_nas,'_'),4,'_')
                )
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',2,'_'), 
                      rpad('_',4,'_')
              )
       ),
-- margine_nascita_ufficio
       decode(mar.stampa_nas,
         'S', decode(mar.id_atto_ansc_nas,'',
                decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                  'A4', nvl(mar.ufficio_nas,rpad('_',2,'_')),
                        rpad(nvl(mar.ufficio_nas,'_'),4,'_')
                )
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',2,'_'), 
                     rpad('_',4,'_')
              )
       ),
-- margine_nascita_anno
       decode(mar.stampa_nas,
         'S', decode(mar.id_atto_ansc_nas,'',
                rpad(nvl(mar.anno_nas,'_'),4,'_')
              ),
              rpad('_',4,'_')
       ),
-- margine_nascita_data
       decode(mar.stampa_nas,
         'S', nvl(to_char(to_date(mar.data_nas,'j'),'dd/mm/yyyy'),rpad('_',10,'_')),
              rpad('_',10,'_')
       ),
-- margine_nascita
       decode(mar.stampa_nas,
         'S', 'L''atto di nascita del di contro e'''||
              decode(mar.id_atto_ansc_nas,'',
                ' iscritto nei registri dello Stato Civile del Comune di: ',
                ' presente nell''Archivio Nazionale informatizzato dei registri dello Stato Civile del Comune di: ')||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.COMUNE_NAS,rpad('_',30,'_')),
                      rpad(nvl(mar.COMUNE_NAS,'_'),40,'_'))||
              ' al N. '||
              decode(mar.id_atto_ansc_nas,'',
                decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                  'A4', nvl(to_char(mar.atto_nas),rpad('_',4,'_')),
                        rpad(nvl(to_char(mar.atto_nas),'_'),6,'_')
                )||
                ' P.'||
                decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                  'A4', nvl(mar.parte_nas,rpad('_',2,'_')),
                        rpad(nvl(mar.parte_nas,'_'),4,'_')
                )||
                ' S.'||
                decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                  'A4', nvl(mar.serie_nas,rpad('_',2,'_')),
                        rpad(nvl(mar.serie_nas,'_'),4,'_')
                )||
                ' Uff.'||
                decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                  'A4', nvl(mar.ufficio_nas,rpad('_',2,'_')),
                        rpad(nvl(mar.ufficio_nas,'_'),4,'_')
                )||
                ' anno '||
                rpad(nvl(mar.anno_nas,'_'),4,'_'),
               mar.id_atto_ansc_nas)
       ),
-- margine_nascita_li_data
       decode(mar.stampa_nas,
         'S', 'li '||nvl(to_char(to_date(mar.data_nas,'j'),'dd/mm/yyyy'),rpad('_',10,'_'))
       ),
-- margine_nascita_ufficiale
       decode(mar.stampa_nas,
         'S', 'L''UFFICIALE DELLO STATO CIVILE'
       ),
-- margine_nascita_firma
       decode(mar.stampa_nas,
         'S', decode(mor.natura,
                'O', rpad('_',30,'_'),
                     'F.to: '||nvl(nvl(dpa.ufficiale_prov,gmo.firma),rpad('.',24,'.'))
              )
       ),
-- margine_trascrizione_...
-- margine_trascrizione_comune
       decode(mar.stampa_tr1,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.comune_tras_1,rpad('_',30,'_')),	
                      rpad(nvl(mar.comune_tras_1,'_'),40,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',30,'_'),
                      rpad('_',40,'_')
              )
       ),
-- margine_trascrizione_atto
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
-- margine_trascrizione_parte
       decode(mar.stampa_tr1,
         'S', decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(decode(mar.parte_tras_1,'1','I','2','II',mar.parte_tras_1),rpad('_',2,'_')),
                      rpad(nvl(decode(mar.parte_tras_1,'1','I','2','II',mar.parte_tras_1),'_'),4,'_')
              ),
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', rpad('_',2,'_'), 
                      rpad('_',4,'_')
              )
       ),
-- margine_trascrizione_serie
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
-- margine_trascrizione_anno_atto
       decode(mar.stampa_tr1,
         'S', rpad(nvl(mar.anno_tras_1,'_'),4,'_'),
              rpad('_',4,'_')
       ),
-- margine_trascrizione_data_com
       decode(mar.stampa_tr1,
         'S', rpad(nvl(to_char(to_date(mar.data_comunicazione_1,'j'),'dd/mm/yyyy'),'_'),15,'_'),
              rpad('_',15,'_')
       ),
-- margine_trascrizione_data
       decode(mar.stampa_tr1,
         'S', nvl(to_char(to_date(mar.data_firma_1,'j'),'dd/mm/yyyy'),rpad('_',10,'_')),
              rpad('_',10,'_')
       ),
-- margine_trascrizione
       decode(mar.stampa_tr1,
         'S', 'Il presente atto di morte e'''||
              ' stato trascritto nei registri'||
              ' dello Stato Civile del Comune di '||
              decode(nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'A4'),
                'A4', nvl(mar.comune_tras_1,rpad('_',30,'_')),
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
              ' anno '||
              rpad(nvl(mar.anno_tras_1,'_'),4,'_')||
              ' come da comunicazione in data '||
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
       )
  FROM arcinp inp,
       civcta cta, civsog sog_IT, civdta dta,
       civocc occ,
       civchi chi, civdic dic,
       civgmo gmo, civdmo dmo, civtes tes,
       civttr ttr,
       civdpa dpa, civmar mar,
       civmor mor
 where inp.parametro        = 'ATTI_PRIMO'
   and cta.id      	(+) = dta.id_civcta
   and sog_IT.id_atto        (+) = mor.id_atto
   and sog_IT.tipo_soggetto  (+) = 'IT'
   and dta.id      	(+) = mor.id_civdta
   and chi.id_atto	(+) = mor.id_atto
   and dic.id_atto	(+) = mor.id_atto
   and gmo.id_atto	(+) = mor.id_atto
   and dmo.id_atto	(+) = mor.id_atto
   and tes.id_atto	(+) = mor.id_atto
   and ttr.id_atto	(+) = mor.id_atto
   and dpa.id_atto	(+) = mor.id_atto
   and mar.id_atto	(+) = mor.id_atto
   and occ.id_atto	(+) = mor.id_atto
   and mor.cod_rec	    in (0,3)  
/
comment on table civwmo_totale is 'Stato Civile - Variabili per composizione Atti di Morte'
/