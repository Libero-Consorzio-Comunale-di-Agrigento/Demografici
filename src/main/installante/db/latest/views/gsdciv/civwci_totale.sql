--liquibase formatted sql
--changeset snocca:202322021601 runAlways:true runOnChange:true stripComments:false
create or replace view civwci_totale
       (COD_REC, UFFICIO, ANNO, ATTO, NATURA, 
        NUMERO_ATTO_ANSC,
        ANNO_OGGI, MESE_OGGI, GIORNO_OGGI, ORE_OGGI, MINUTI_OGGI,
        DATA_ATTO, DATA_GIURAMENTO, DATA_RICHIESTA, DATA_DECORRENZA,
        ANNO_ATTO, MESE_ATTO, GIORNO_ATTO,
        COGNOME_NOME, COGNOME, NOME, SESSO,
        DATA_NASCITA, ANNO_NASCITA, MESE_NASCITA, GIORNO_NASCITA,
        ATTO_NASCITA, 
        NUMERO_ATTO_ANSC_NASCITA, 
        COMUNE_NASCITA, COMUNE_RESIDENZA,
        PROFESSIONE, NAZIONALITA,
        STATO_CIVILE, COGNOME_NOME_CONIUGE, COGNOME_CONIUGE, NOME_CONIUGE,
        PATERNITA, COGNOME_PADRE, NOME_PADRE, COMUNE_NASCITA_PADRE, COMUNE_RESIDENZA_PADRE, DATA_NASCITA_PADRE,
        MATERNITA, COGNOME_MADRE, NOME_MADRE, COMUNE_NASCITA_MADRE, COMUNE_RESIDENZA_MADRE, DATA_NASCITA_MADRE,
        COGNOME_ASCENDENTE, NOME_ASCENDENTE, COMUNE_NASCITA_ASCENDENTE, COMUNE_RESIDENZA_ASCENDENTE, DATA_NASCITA_ASCENDENTE, GRADO_PARENTELA_ASCENDENTE, 
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
        COMUNE_RICONOSCIMENTO_MADRE, PROVINCIA_RICONOSCIMENTO_MADRE, 
        ATTO_RICONOSCIMENTO_MADRE, ANNO_RICONOSCIMENTO_MADRE, 
        DATA_RICONOSCIMENTO_MADRE,
        COMUNE_RICONOSCIMENTO_PADRE, PROVINCIA_RICONOSCIMENTO_PADRE, 
        ATTO_RICONOSCIMENTO_PADRE, ANNO_RICONOSCIMENTO_PADRE, 
        DATA_RICONOSCIMENTO_PADRE,
        GIURAMENTO_UFFICIO, GIURAMENTO_ANNO, GIURAMENTO_ATTO, 
        GIURAMENTO_NUMERO_ATTO_ANSC,
        DECRETO_NUMERO, DECRETO_DATA, DECRETO_DATA_NOTIFICA, DECRETO_FIRMATO
       )
AS
select cit.cod_rec, cit.ufficio, cit.anno, cit.atto, cit.natura, 
       f_CIV_numero_atto_ansc(cit.id_atto_ansc),
-- anno_oggi
       f_CIV_campi_testata(1,cit.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             '','','','','','','','','','','',
                             '','','',
                             'anno_oggi'),
-- mese_oggi
       f_CIV_campi_testata(1,cit.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             '','','','','','','','','','','',
                             '','','',
                             'mese_oggi'),
-- giorno_oggi
       f_CIV_campi_testata(1,cit.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             '','','','','','','','','','','',
                             '','','',
                             'giorno_oggi'),
-- ore_oggi
       f_CIV_campi_testata(1,cit.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             '','','','','','','','','','','',
                             '','','',
                             'ore_oggi'),
-- minuti_oggi
       f_CIV_campi_testata(1,cit.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             '','','','','','','','','','','','',
                             '','','','','','','','','','','',
                             '','','',
                             'minuti_oggi'),
-- data_atto
       f_CIV_cifre_lettere('D',to_char(cit.d_data_cit,'dd/mm/yyyy'),inp.valore,'S'),
-- data_giuramento
       f_CIV_cifre_lettere('D',to_char(cit.d_data_cit,'dd/mm/yyyy'),inp.valore,'S'),
-- data_richiesta
       f_CIV_cifre_lettere('D',to_char(cit.d_data_richiesta,'dd/mm/yyyy'),inp.valore,'S'),
-- data_decorrenza
       f_CIV_cifre_lettere('D',to_char(cit.d_data_decorrenza,'dd/mm/yyyy'),inp.valore,'S'),
-- anno_atto
       f_CIV_cifre_lettere('A',to_char(to_date(cit.data_cit,'j'),'yyyy'),'',''),
-- mese_atto
       f_CIV_cifre_lettere('M',to_char(to_date(cit.data_cit,'j'),'mm'),'',''),
-- giorno_atto
       f_CIV_cifre_lettere('G',to_char(to_date(cit.data_cit,'j'),'dd'),inp.valore,''),
-- cognome_nome
       decode(occ.atto,'', translate(cit.cognome_nome,'/',' '), occ.cognome||' '||occ.nome),
-- cognome
       decode(occ.atto,'', cit.cognome, occ.cognome),
-- nome
       decode(occ.atto,'', cit.nome, occ.nome),
-- sesso
       nvl(cit.sesso,aana.sesso),
-- data_nascita
       decode(cit.anno_nas,'S', f_CIV_cifre_lettere('A',to_char(to_date(cit.data_nas,'j'),'yyyy'),'',''),
         decode(cit.flag_GG_imprecisato,'S','',f_CIV_cifre_lettere('G',to_char(to_date(cit.data_nas,'j'),'dd'),inp.valore,'')||' ')||
         decode(cit.flag_MM_imprecisato,'S','',f_CIV_cifre_lettere('M',to_char(to_date(cit.data_nas,'j'),'mm'),'','')||' ')||
         decode(cit.flag_AA_imprecisato,'S','imprecisata',f_CIV_cifre_lettere('A',to_char(to_date(cit.data_nas,'j'),'yyyy'),'','')||' ')
       ),
-- anno_nascita
       upper(decode(cit.flag_aa_imprecisato, 'S', 'imprecisato',
               f_CIV_cifre_lettere('A', to_char(cit.d_data_nas,'yyyy'),'', '')
             )), 
-- mese_nascita
       upper(decode(cit.flag_mm_imprecisato, 'S', 'imprecisato',
               f_CIV_cifre_lettere('M', to_char(cit.d_data_nas, 'mm'),'','')
             )), 
-- giorno_nascita
       upper(decode(cit.flag_gg_imprecisato, 'S', 'imprecisato',
               f_CIV_cifre_lettere('G', to_char(cit.d_data_nas, 'dd'), f_valore_inp('ATTI_PRIMO',1,1,'X','S'), '')
             )),
-- atto_nascita
       decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '',
         'Atto N. '||decode(mar.atto_nas,'','_____',to_char(mar.atto_nas))||
           ' P. '||decode(mar.parte_nas,'1','I','2','II',nvl(mar.parte_nas,'__'))||
           ' S. '||nvl(mar.serie_nas,'___')||
           ' - '||nvl(mar.anno_nas,'____'),
         'Atto N. '||mar.id_atto_ansc_nas),
-- numero_atto_ansc_nascita
       f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas),
-- comune_nascita
       nvl(rtrim(f_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.data_nas)||' '||
                 f_provincia_stato_al(cit.cod_pro_nas,cit.cod_com_nas,null,'S','S',cit.data_nas)),
           lpad('...',30,'_')
       ),
-- comune_residenza
       nvl(rtrim(f_comune_al(cit.cod_pro_res,cit.cod_com_res,cit.data_cit)||' '||
                 f_provincia_stato_al(cit.cod_pro_res,cit.cod_com_res,null,'S','S',cit.data_cit)),
           lpad('...',30,'_')
       ),
-- professione
       rpad('...',20,'_'),
-- nazionalita
       nvl(f_get_descrizione_DCI(cit.nazionalita,cit.sesso),rpad('...',20,'_')),
-- stato_civile
       lower(adsc.descrizione),
-- cognome_nome_cn    
       translate(aana.cognome_nome_cn,'/',' '),
-- cognome_cn
       f_cognome(aana.cognome_nome_cn),
-- nome_cn
       f_nome(aana.cognome_nome_cn),
-- paternita
       decode(sog_PD.cognome||sog_PD.nome, '', translate(aana.paternita,'/',' '), sog_PD.cognome||' '||sog_PD.nome), 
-- cognome_pd
       decode(sog_PD.cognome||sog_PD.nome, '', f_cognome_pd(aana.matricola_pd, aana.paternita, aana.cognome_nome), sog_PD.cognome),
-- nome_pd
       decode(sog_PD.cognome||sog_PD.nome, '', f_nome_pd(aana.matricola_pd, aana.paternita, aana.cognome_nome), sog_PD.nome),
-- comune_nascita_pd
       nvl(rtrim(f_comune_al(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,to_char(sog_PD.d_data_nas,'j'))||' '||
                 f_provincia_stato_al(sog_PD.cod_pro_nas,sog_PD.cod_com_nas,null,'S','S',to_char(sog_PD.d_data_nas,'j'))),
           lpad('...',30,'_')
       ),
-- comune_residenza_pd
       nvl(rtrim(f_comune_al(sog_PD.cod_pro_res,sog_PD.cod_com_res,cit.data_cit)||' '||
                 f_provincia_stato_al(sog_PD.cod_pro_res,sog_PD.cod_com_res,null,'S','S',cit.data_cit)),
           lpad('...',30,'_')
       ),
-- data_nascita_pd
       f_CIV_cifre_lettere('G',to_char(sog_PD.d_data_nas,'dd'),inp.valore,'')||' '||
             f_CIV_cifre_lettere('M',to_char(sog_PD.d_data_nas,'mm'),'','')||' '||
             f_CIV_cifre_lettere('A',to_char(sog_PD.d_data_nas,'yyyy'),'',''),
-- maternita
       decode(sog_MD.cognome||sog_MD.nome, '', translate(aana.maternita,'/',' '), sog_MD.cognome||' '||sog_MD.nome),
-- cognome_md
       decode(sog_MD.cognome||sog_MD.nome, '', f_cognome_md(aana.matricola_md, aana.maternita), sog_MD.cognome),
-- nome_md
       decode(sog_MD.cognome||sog_MD.nome, '', f_nome_md(aana.matricola_md, aana.maternita), sog_MD.nome),
-- comune_nascita_md
       nvl(rtrim(f_comune_al(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,to_char(sog_MD.d_data_nas,'j'))||' '||
                 f_provincia_stato_al(sog_MD.cod_pro_nas,sog_MD.cod_com_nas,null,'S','S',to_char(sog_MD.d_data_nas,'j'))),
           lpad('...',30,'_')
       ),
-- comune_residenza_md
       nvl(rtrim(f_comune_al(sog_MD.cod_pro_res,sog_MD.cod_com_res,cit.data_cit)||' '||
                 f_provincia_stato_al(sog_MD.cod_pro_res,sog_MD.cod_com_res,null,'S','S',cit.data_cit)),
           lpad('...',30,'_')
       ),
-- data_nascita_md
       f_CIV_cifre_lettere('G',to_char(sog_MD.d_data_nas,'dd'),inp.valore,'')||' '||
             f_CIV_cifre_lettere('M',to_char(sog_MD.d_data_nas,'mm'),'','')||' '||
             f_CIV_cifre_lettere('A',to_char(sog_MD.d_data_nas,'yyyy'),'',''),
-- cognome_as
       sog_AS.cognome,
-- nome_as
       sog_AS.nome,
-- comune_nascita_as
       nvl(rtrim(f_comune_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,to_char(sog_AS.d_data_nas,'j'))||' '||
                 f_provincia_stato_al(sog_AS.cod_pro_nas,sog_AS.cod_com_nas,null,'S','S',to_char(sog_AS.d_data_nas,'j'))),
           lpad('...',30,'_')
       ),
-- comune_residenza_as
       nvl(rtrim(f_comune_al(sog_AS.cod_pro_res,sog_AS.cod_com_res,cit.data_cit)||' '||
                 f_provincia_stato_al(sog_AS.cod_pro_res,sog_AS.cod_com_res,null,'S','S',cit.data_cit)),
           lpad('...',30,'_')
       ),
-- data_nascita_as
       f_CIV_cifre_lettere('G',to_char(sog_AS.d_data_nas,'dd'),inp.valore,'')||' '||
             f_CIV_cifre_lettere('M',to_char(sog_AS.d_data_nas,'mm'),'','')||' '||
             f_CIV_cifre_lettere('A',to_char(sog_AS.d_data_nas,'yyyy'),'',''),
-- grado_parentela_as
       f_CIV_grado_parentela_asc(sog_AS.grado_parentela),
-- cognome_it
       sog_IT.cognome,
-- nome_it
       sog_IT.nome,
-- comune_nascita_it
       nvl(rtrim(f_comune_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,to_char(sog_IT.d_data_nas,'j'))||' '||
                 f_provincia_stato_al(sog_IT.cod_pro_nas,sog_IT.cod_com_nas,null,'S','S',to_char(sog_IT.d_data_nas,'j'))),
           lpad('...',30,'_')
       ),
-- comune_residenza_it
       nvl(rtrim(f_comune_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,cit.data_cit)||' '||
                 f_provincia_stato_al(sog_IT.cod_pro_res,sog_IT.cod_com_res,null,'S','S',cit.data_cit)),
           lpad('...',30,'_')
       ),
-- data_nascita_it
       f_CIV_cifre_lettere('G',to_char(sog_IT.d_data_nas,'dd'),inp.valore,'')||' '||
             f_CIV_cifre_lettere('M',to_char(sog_IT.d_data_nas,'mm'),'','')||' '||
             f_CIV_cifre_lettere('A',to_char(sog_IT.d_data_nas,'yyyy'),'',''),
-- cognome_richiedente
       dpa.cognome_dic,
-- nome_richiedente
       dpa.nome_dic,
-- comune_nascita_richiedente
       nvl(rtrim(f_comune_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,to_char(dpa.d_data_nas_dic,'j'))||
                     decode(sign(dpa.cod_pro_nas_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_nas_dic,dpa.cod_com_nas_dic,null,'S','S',to_char(dpa.d_data_nas_dic,'j')))),
             lpad('...',30,'_')),
-- comune_residenza_richiedente
       nvl(rtrim(f_comune_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,cit.data_cit)||
                     decode(sign(dpa.cod_pro_res_dic-200),1,' '||f_provincia_stato_al(dpa.cod_pro_res_dic,dpa.cod_com_res_dic,null,'S','S',cit.data_cit))),
             lpad('...',30,'_')),
-- data_nascita_richiedente
       f_CIV_cifre_lettere('D',to_char(dpa.d_data_nas_dic,'dd/mm/yyyy'),inp.valore,'S'),
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
       nvl(dpa.ufficiale_utente,rpad('...',30,'_')),
-- comune_riconoscimento_md
       f_comune_al(dpa.riconoscimento_pre_cod_com_1, dpa.riconoscimento_pre_cod_com_1, ''),
-- provincia_riconoscimento_md
       f_provincia_stato_al(dpa.riconoscimento_pre_cod_com_1, dpa.riconoscimento_pre_cod_com_1,'','S','S',''),
-- atto_riconoscimento_md
       decode(f_CIV_numero_atto_ansc(dpa.RICONOSCIM_PRE_ID_ATTO_ANSC_1), '', to_char(dpa.riconoscimento_pre_atto_1), dpa.RICONOSCIM_PRE_ID_ATTO_ANSC_1),
-- anno_riconoscimento_md
       decode(f_CIV_numero_atto_ansc(dpa.RICONOSCIM_PRE_ID_ATTO_ANSC_1), '', dpa.riconoscimento_pre_anno_1),
-- data_riconoscimento_md
       f_CIV_cifre_lettere('G',to_char(dpa.d_riconoscimento_pre_data_1,'dd'),inp.valore,'')||' '||
             f_CIV_cifre_lettere('M',to_char(dpa.d_riconoscimento_pre_data_1,'mm'),'','')||' '||
             f_CIV_cifre_lettere('A',to_char(dpa.d_riconoscimento_pre_data_1,'yyyy'),'',''),
-- comune_riconoscimento_pd
       f_comune_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2, ''),
-- provincia_riconoscimento_pd
       f_provincia_stato_al(dpa.riconoscimento_pre_cod_pro_2, dpa.riconoscimento_pre_cod_com_2,'','S','S',''),
-- atto_riconoscimento_pd
       decode(f_CIV_numero_atto_ansc(dpa.RICONOSCIM_PRE_ID_ATTO_ANSC_2), '', to_char(dpa.riconoscimento_pre_atto_2), dpa.RICONOSCIM_PRE_ID_ATTO_ANSC_2),
-- anno_riconoscimento_pd 
       decode(f_CIV_numero_atto_ansc(dpa.RICONOSCIM_PRE_ID_ATTO_ANSC_2), '', dpa.riconoscimento_pre_anno_2),
-- data_riconoscimento_pd
       f_CIV_cifre_lettere('G',to_char(dpa.d_riconoscimento_pre_data_2,'dd'),inp.valore,'')||' '||
             f_CIV_cifre_lettere('M',to_char(dpa.d_riconoscimento_pre_data_2,'mm'),'','')||' '||
             f_CIV_cifre_lettere('A',to_char(dpa.d_riconoscimento_pre_data_2,'yyyy'),'',''),
-- giuramento_ufficio
       decode(f_CIV_numero_atto_ansc(dpa.GIURAMENTO_ID_ATTO_ANSC), '', dpa.GIURAMENTO_UFFICIO), 
-- giuramento_anno
       decode(f_CIV_numero_atto_ansc(dpa.GIURAMENTO_ID_ATTO_ANSC), '', dpa.GIURAMENTO_ANNO), 
-- giuramento_atto
       decode(f_CIV_numero_atto_ansc(dpa.GIURAMENTO_ID_ATTO_ANSC), '', to_char(dpa.GIURAMENTO_ATTO), dpa.GIURAMENTO_ID_ATTO_ANSC),
-- giuramento_numero_atto_ansc
       f_CIV_numero_atto_ansc(dpa.GIURAMENTO_ID_ATTO_ANSC),
-- decreto_numero
       dpa.SENTENZA_NUMERO, 
-- decreto_data
       decode(dpa.d_SENTENZA_DATA,'',to_char(null),
         to_char(dpa.d_SENTENZA_DATA,'dd')||' '||
         f_CIV_cifre_lettere('M',to_char(dpa.d_SENTENZA_DATA,'mm'),'','S')||' '||
         to_char(dpa.d_SENTENZA_DATA,'yyyy')), 
-- decreto_data_notifica
       decode(dpa.D_SENTENZA_DATA_NOTIFICA,'',to_char(null),
         to_char(dpa.D_SENTENZA_DATA_NOTIFICA,'dd')||' '||
         f_CIV_cifre_lettere('M',to_char(dpa.D_SENTENZA_DATA_NOTIFICA,'mm'),'','S')||' '||
         to_char(dpa.D_SENTENZA_DATA_NOTIFICA,'yyyy')),
-- decreto_firmato
       dpa.SENTENZA_TRIBUNALE
  from arcinp inp,
       civcta cta, civdta dta,
       anadci adci, anadsc adsc, anaana aana, 
       civmar mar, civsog sog_PD, civsog sog_MD, civsog sog_AS, civsog sog_IT,
       civocc occ, civdpa dpa, civana ana, 
       civcit cit
 where inp.parametro = 'ATTI_PRIMO'
   and cta.id      	(+) = dta.id_civcta
   and sog_PD.id_atto        (+) = cit.id_atto
   and sog_PD.tipo_soggetto  (+) = 'PD'
   and sog_MD.id_atto        (+) = cit.id_atto
   and sog_MD.tipo_soggetto  (+) = 'MD'
   and sog_IT.id_atto        (+) = cit.id_atto
   and sog_IT.tipo_soggetto  (+) = 'IT'
   and sog_AS.id_atto        (+) = cit.id_atto
   and sog_AS.tipo_soggetto  (+) = 'AS'
   and dta.id      	(+) = cit.id_civdta
   and adci.cod_ci      (+) = aana.nazionalita
   and adsc.cod_sc      (+) = aana.stato_civile
   and adsc.sesso       (+) = aana.sesso
   and aana.matricola	(+) = ana.matricola_1
   and mar.id_atto      (+) = cit.id_atto
   and dpa.id_atto      (+) = cit.id_atto
   and occ.id_atto      (+) = cit.id_atto
   and ana.id_atto      (+) = cit.id_atto
/
comment on table civwci_totale is 'Stato Civile - Variabili per composizione Atti di Cittadinanza'
/
