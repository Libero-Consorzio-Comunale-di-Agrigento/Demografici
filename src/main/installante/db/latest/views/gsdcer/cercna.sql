--liquibase formatted sql
--changeset amonopoli:202301251555 runOnChange:true stripComments:false
create or replace view cercna 
       (ufficio,anno,atto,parte,parte_edit,serie,serie_edit,
        NUMERO_ATTO_ANSC,
        ufficio_orig,anno_orig,atto_orig,parte_orig,
        parte_orig_edit,serie_orig,serie_orig_edit,
        NUMERO_ATTO_ANSC_ORIG,
        comune_atto,
        cognome_nome,cognome,nome,codice_fiscale,
        secondo_nome,terzo_nome,sesso,sesso_m_f,nat_oa,
        data_nascita,
        giorno_nascita,giorno_nascita_lettere,
        mese_nascita,
        anno_nascita,anno_nascita_lettere,
        comune_nascita,cap_comune_nascita,
        ore,ore_lettere,minuti,minuti_lettere,
        e_minuti,e_minuti_lettere,
        del_luogo_nascita,del_luogo_nascita_trunc,
        luogo_nascita,luogo_nascita_trunc,
        paternita,paternita_solo_nome,cognome_padre,nome_padre,
        indirizzo_ana_pat,data_nas_pat,
        maternita,maternita_solo_nome,cognome_madre,nome_madre,
        indirizzo_ana_mat,data_nas_mat,
        residenza,cap_residenza,comune_data,comune,data,
        autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	    frazione_prov, autorita_prov_ufficio,
        nota_rif,anno_nota_rif,data_nota_rif,
        ufficiale_prov,qualifica_prov,
        protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
        ente_straniero, comune_ente_straniero, stato_ente_straniero, data_atto_ente_straniero,
        tipo_atto_ente_straniero, estremi_atto_ente_straniero, 
        atto_notarile,comune_atto_notarile,data_atto_notarile,estremi_doc_atto_notarile,
        centro_nascita,comune_centro_nascita,
        numero_dich_centro_nascita,anno_dich_centro_nascita,
        data_richiesta_centro_nascita,
        addetto_centro_nascita,qualifica_centro_nascita,
        data_dich_centro_nascita,ore_dich_centro_nascita,minuti_dich_centro_nascita,
        terminalista_atto,
        flag_comune_estero_res,
        ID_ATTO, NUMERO_UNICO_COMUNALE)
AS
SELECT       
-- ufficio
       nas.ufficio,
-- anno
       nas.anno,
-- atto
       nas.atto,
-- parte
       nas.parte,
-- parte_edit
       DECODE (nas.parte,1,'I',2,'II'),
-- serie
       nas.serie,
-- serie_edit
       DECODE (nas.serie, '', '', 'Serie ' || nas.serie),
-- numero_atto_ansc
       f_CIV_numero_atto_ansc(nas.id_atto_ansc, nas.numero_unico),
-- ufficio_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         DECODE (dpa.ufficio_orig, '', 
           DECODE (ana.ufficio_orig, '', '__', ana.ufficio_orig), 
           dpa.ufficio_orig)),
-- anno_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         DECODE (dpa.anno_orig, '',  
           DECODE (ana.anno_orig, '', '____', ana.anno_orig), 
           dpa.anno_orig)),
-- atto_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '',  
         DECODE (dpa.atto_orig, '', 
           DECODE (ana.atto_orig, '', '____', ana.atto_orig), 
           dpa.atto_orig),
         dpa.id_atto_ansc_orig),
-- parte_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
         DECODE (dpa.parte_orig, '', 
           DECODE (ana.parte_orig, '', '__', ana.parte_orig), 
           dpa.parte_orig)),
-- parte_orig_edit
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '',  
         DECODE (dpa.parte_orig,'',  
           DECODE (ana.parte_orig,'', '__',DECODE (ana.parte_orig,1,'I',2,'II')),
           DECODE (dpa.parte_orig,1,'I',2,'II'))), 
-- serie_orig
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '',  
         DECODE (dpa.serie_orig, '', 
           DECODE (ana.serie_orig, '', '__', ana.serie_orig),
            dpa.serie_orig)),
-- serie_orig_edit
       decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '',  
         DECODE (dpa.serie_orig, '', 
           DECODE (ana.serie_orig, '', '__', 'Serie ' || ana.serie_orig),
           'Serie ' || dpa.serie_orig)),
-- numero_atto_ansc_orig
       f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig),
-- comune_atto
       f_CER_comune_atto_civ(2,nas.ufficio,nas.anno,nas.parte,nas.serie,nas.natura),
-- cognome_nome
       REPLACE (nas.cognome_nome, '/', ' '),
-- cognome
       SUBSTR (nas.cognome_nome, 1, INSTR (nas.cognome_nome, '/') - 1),
-- nome
       SUBSTR (nas.cognome_nome, INSTR (nas.cognome_nome, '/') + 1),
-- codice_fiscale
       nas.cod_fiscale,
-- secondo_nome
       DECODE (secondo_nome, '', '', 'Secondo nome : ' || secondo_nome),
-- terzo_nome
       DECODE (terzo_nome, '', '', 'Terzo   nome : ' || terzo_nome),
-- sesso
       DECODE (nas.sesso, 'M', 'maschile', 'femminile'),
-- sesso_m_f
       nas.sesso,
-- nat_oa
       DECODE (nas.sesso,'M', DECODE (nato_morto, 'SI', 'nato morto', 'nato'),
       DECODE (nato_morto, 'SI', 'nata morta', 'nata')),
-- data_nascita
       decode(nvl(nas.flag_gg_imprecisato,'N') || nvl(nas.flag_mm_imprecisato,'N') || nvl(nas.flag_aa_imprecisato,'N'), 
                'SSS', '00/00/0000',
                'SSN', '00/00/' || TO_CHAR (TO_DATE (nas.data_nas, 'j'), 'yyyy'),
                'SNN', '00/' || TO_CHAR (TO_DATE (nas.data_nas, 'j'), 'mm/yyyy'),
          DECODE (nas.anno_nas,'S','00/00/' || TO_CHAR (TO_DATE (nas.data_nas, 'j'), 'yyyy'), TO_CHAR (TO_DATE (nas.data_nas, 'j'), 'dd/mm/yyyy'))),
-- giorno_nascita
       upper(
         decode(nas.flag_gg_imprecisato, 'S', 'imprecisato',
           DECODE (nvl(nas.flag_gg_imprecisato,nas.anno_nas),'S', '00',TO_CHAR (TO_DATE (nas.data_nas, 'j'), 'dd')
           )
         )
       ),
-- giorno_nascita_lettere
       upper(
         decode(nas.flag_gg_imprecisato, 'S', 'imprecisato',
           DECODE (nvl(nas.flag_gg_imprecisato,nas.anno_nas),'S','',
             f_CIV_cifre_lettere('G', to_char(nas.d_data_nas, 'dd'), inp.valore, '')
           )
         )
       ),
-- mese_nascita
       upper(
         decode(nas.flag_mm_imprecisato, 'S', 'imprecisato',
           DECODE (nvl(nas.flag_mm_imprecisato,nas.anno_nas),'S','',
             f_CIV_cifre_lettere('M', to_char(nas.d_data_nas, 'mm'),'','')
           )
         )
       ),
-- anno_nascita
       TO_CHAR (TO_DATE (nas.data_nas, 'j'), 'yyyy'),
-- anno_nascita_lettere
       upper(
         decode(nas.flag_aa_imprecisato, 'S', 'imprecisato',
           f_CIV_cifre_lettere('A', to_char(nas.d_data_nas,'yyyy'),'', '')
         )
       ), 
-- comune_nascita
       RTRIM (
         f_comune_al(a.cod_provincia,a.cod_comune,nas.data_nas)||' '||
         f_provincia_stato_cer(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',nas.data_nas)),
-- cap_comune_nascita
       LPAD (a.cap, 5, '0'),
-- ore
       decode(nas.flag_HH_imprecisato,'S','imprecisata',nas.ore),
-- ore_lettere
       decode(nas.flag_HH_imprecisato,'S','imprecisata',f_CIV_cifre_lettere('h',nvl(nas.ore,0),'','')),
-- minuti
       decode(nas.flag_MI_imprecisato,'S','imprecisati',nas.minuti),
-- minuti_lettere
       decode(nas.flag_MI_imprecisato,'S','imprecisati',f_CIV_cifre_lettere('m',nvl(nas.minuti,0),'','')),
-- e_minuti
       decode(nas.flag_MI_imprecisato,'S','e minuti imprecisati',
         DECODE (minuti, '', '', 'e minuti ' || nas.minuti)),
-- e_minuti_lettere
       decode(nas.flag_MI_imprecisato,'S','e minuti imprecisati',
         DECODE (minuti,'','','e minuti '||
         decode(nas.flag_MI_imprecisato,'S','imprecisati',f_CIV_cifre_lettere('m',nvl(nas.minuti,0),'','')))),
-- del_luogo_nascita
       DECODE (dna.luogo_nas,'', 'del ' || dpa.nel_nas || dpa.luogo_nas,
         'del ' || dna.nel || dna.luogo_nas),
-- del_luogo_nascita_trunc
       DECODE (dna.luogo_nas,'','del '||dpa.nel_nas|| 
                                DECODE (INSTR (dpa.luogo_nas, '-'),0,dpa.luogo_nas,
                                SUBSTR (dpa.luogo_nas,1,INSTR (dpa.luogo_nas, '-') - 1)),
         'del ' || dna.nel||DECODE(INSTR (dna.luogo_nas, '-'),0,dna.luogo_nas,
         SUBSTR (dna.luogo_nas,1,INSTR (dna.luogo_nas, '-') - 1))),
-- luogo_nascita
       DECODE (dna.luogo_nas, '', dpa.luogo_nas, dna.luogo_nas),
-- luogo_nascita_trunc
       DECODE (dna.luogo_nas,'',DECODE(INSTR (dpa.luogo_nas, '-'),0,dpa.luogo_nas,
                                SUBSTR (dpa.luogo_nas, 1, INSTR (dpa.luogo_nas, '-') - 1)),
         DECODE (INSTR (dna.luogo_nas, '-'),0,dna.luogo_nas,
         SUBSTR (dna.luogo_nas, 1, INSTR (dna.luogo_nas, '-') - 1))),
-- paternita
       'pt. ' || REPLACE (nas.paternita, '/', ' '),
-- paternita_solo_nome
       REPLACE (nas.paternita, '/', ' '),
-- cognome_padre
       DECODE (nas.paternita,'','',DECODE (INSTR (nas.paternita, '/'),0,
         SUBSTR (nas.cognome_nome,1,INSTR (nas.cognome_nome, '/') - 1),
         SUBSTR (nas.paternita, 1, INSTR (nas.paternita, '/') - 1))),
-- nome_padre
       DECODE (nas.paternita,'','',DECODE (INSTR (nas.paternita, '/'),0,nas.paternita,
         SUBSTR (nas.paternita, INSTR (nas.paternita, '/') + 1))),
-- indirizzo_ana_pat
       vie_p.denom_uff || fam_p.civico_esterno,
-- data_nas_pat
       DECODE (ana_p.anno_nas,'',TO_CHAR (TO_DATE (ana_p.data_nas, 'j'), 'dd/mm/yyyy'),
         '00/00/' || TO_CHAR (TO_DATE (ana_p.data_nas, 'j'), 'yyyy')),
-- maternita
       'mt. ' || REPLACE (nas.maternita, '/',' '),
-- maternita_solo_nome
       REPLACE (nas.maternita, '/',' '),
-- cognome_madre
       SUBSTR (nas.maternita, 1, INSTR (nas.maternita, '/') - 1),
-- nome_madre
       SUBSTR (nas.maternita, INSTR (nas.maternita, '/') + 1),
-- indirizzo_ana_mat
       vie_m.denom_uff || fam_m.civico_esterno,
-- data_nas_pat
       DECODE(ana_m.anno_nas,'',TO_CHAR (TO_DATE (ana_m.data_nas, 'j'), 'dd/mm/yyyy'),
         '00/00/' || TO_CHAR (TO_DATE (ana_m.data_nas, 'j'), 'yyyy')),
-- residenza
       RTRIM (
         f_comune_al (b.cod_provincia,b.cod_comune,nas.data_nas)||' '||
         f_provincia_stato_al (b.cod_provincia,b.cod_comune,b.sigla_provincia,'S','S',nas.data_nas)),
-- cap_residenza
       LPAD (b.cap, 5, '0'),
-- comune_data
       c.descrizione || ' ' || TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- comune
       c.descrizione,
-- data
       TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
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
       TO_CHAR (TO_DATE (dpa.data_nota_rif, 'j'), 'dd/mm/yyyy'),
-- ufficiale_prov
       dpa.ufficiale_prov,
-- qualifica_prov
       dpa.qualifica_prov,
-- protocollo_prov
       dpa.protocollo,
-- anno_protocollo_prov
       dpa.anno_protocollo,
-- data_protocollo_prov
       TO_CHAR (TO_DATE (dpa.data_protocollo, 'j'), 'dd/mm/yyyy'),
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
-- terminalista_atto
       terminalista,
-- flag_comune_estero_res
       DECODE (SIGN (nas.cod_pro_nas - 199), -1, TO_CHAR (NULL), 'S'),
-- id_atto
       nas.id_atto,
-- numero_unico
       f_CIV_numero_unico_comunale(nas.numero_unico)
  FROM arccom a,arccom b,arccom c,arcinp inp,
       arcvie vie_m,arcvie vie_p,anafam fam_m,
       anafam fam_p,anaana ana_m,anaana ana_p,
       civdpa dpa,civdna dna,civana ana,civnas nas
 WHERE a.cod_comune    (+) = nas.cod_com_nas
   AND a.cod_provincia (+) = nas.cod_pro_nas
   AND b.cod_comune    (+) = nas.cod_com_res
   AND b.cod_provincia (+) = nas.cod_pro_res
   AND (c.cod_provincia, c.cod_comune) =
       (SELECT   pro_cliente, com_cliente FROM menuditta)
   AND inp.parametro       = 'ATTI_PRIMO'
   AND vie_p.cod_via   (+) = fam_p.cod_via
   AND fam_p.fascia    (+) = ana_p.fascia
   AND fam_p.cod_fam   (+) = ana_p.cod_fam
   AND ana_p.fascia    (+) = 1
   AND ana_p.matricola (+) = ana.matricola_1
   AND vie_m.cod_via   (+) = fam_m.cod_via
   AND fam_m.fascia    (+) = ana_m.fascia
   AND fam_m.cod_fam   (+) = ana_m.cod_fam
   AND ana_m.fascia    (+) = 1
   AND ana_m.matricola (+) = ana.matricola_2
   AND dpa.id_atto     (+) = nas.id_atto
   AND dna.id_atto     (+) = nas.id_atto
   AND ana.id_atto     (+) = nas.id_atto
   AND nas.cod_rec         IN (0, 3)
/
comment on table cercna is 'Stato Civile - Dati Atti di Nascita per Comunicazioni (view)'
/
