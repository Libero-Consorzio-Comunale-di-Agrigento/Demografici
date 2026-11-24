--liquibase formatted sql
--changeset amonopoli:202305110940 runOnChange:true stripComments:false
create or replace view cercma 
	(ufficio,anno,atto,parte,parte_edit,serie,serie_edit,
         NUMERO_ATTO_ANSC,
	 ufficio_orig,anno_orig,atto_orig,parte_orig,parte_orig_edit,
	 serie_orig,serie_orig_edit,
         NUMERO_ATTO_ANSC_ORIG,
         comune_atto,
	 cognome_nome_sposo,cognome_sposo,nome_sposo,
	 codice_fiscale_sposo,nato_il,data_nascita_sposo,
	 comune_nascita_sposo,cap_comune_nascita_sposo,
	 tribunale_nascita_sposo,
	 atto_nascita_sposo,parte_nascita_sposo,serie_nascita_sposo,
	 anno_atto_nascita_sposo,
         NUMERO_ATTO_ANSC_NASCITA_SPOSO,
	 atto_nascita_sposo_edit,
         comune_atto_nascita_sposo,cap_comune_atto_nascita_sposo,
         nazionalita_sposo,
	 residenza_sposo,cap_residenza_sposo,indirizzo_ana_sposo,
	 cognome_nome_sposa,cognome_sposa,nome_sposa,
	 codice_fiscale_sposa,nata_il,data_nascita_sposa,
	 comune_nascita_sposa,cap_comune_nascita_sposa,
	 tribunale_nascita_sposa,
	 atto_nascita_sposa,parte_nascita_sposa,serie_nascita_sposa,
	 anno_atto_nascita_sposa,
         NUMERO_ATTO_ANSC_NASCITA_SPOSA,
	 atto_nascita_sposa_edit,
         comune_atto_nascita_sposa,cap_comune_atto_nascita_sposa,
         nazionalita_sposa,
	 residenza_sposa,cap_residenza_sposa,indirizzo_ana_sposa,
	 data_matrimonio,
	 giorno_matrimonio,giorno_matrimonio_lettere,
	 mese_matrimonio,
	 anno_matrimonio,anno_matrimonio_lettere,
	 comune_matrimonio,cap_comune_matrimonio,
	 ufficio_matrimonio, anno_atto_matrimonio, atto_matrimonio, parte_matrimonio, serie_matrimonio,
         NUMERO_ATTO_ANSC_MATRIMONIO,
	 comune_atto_matrimonio,cap_comune_atto_matrimonio,
	 rito,
         data_riconciliazione,data_conferma_divorzio,data_accordo_divorzio,
         comune_data,comune,data,
	 convenzioni,
	 autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	 frazione_prov, autorita_prov_ufficio,nota_rif,anno_nota_rif,data_nota_rif,
	 ufficiale_prov,qualifica_prov,
	 protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
         ente_straniero, comune_ente_straniero, stato_ente_straniero, data_atto_ente_straniero,
         tipo_atto_ente_straniero, estremi_atto_ente_straniero, 
         terminalista_atto,
	 flag_comune_estero_res_m,flag_comune_estero_res_f,
         ID_ATTO, NUMERO_UNICO_COMUNALE)
as
SELECT mat.ufficio,mat.anno, mat.atto,mat.parte,
        DECODE (mat.parte,1,'I',2, 'II'), mat.serie,
        DECODE (mat.serie, '', '', 'Serie ' || mat.serie),
        f_CIV_numero_atto_ansc(mat.id_atto_ansc,mat.numero_unico),
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
          DECODE (dpa.serie_orig, 
            DECODE (ana.serie_orig,'', DECODE (ana.atto_orig, '', '__', ''),ana.serie_orig),
            dpa.serie_orig)),
-- serie_orig_edit
        decode(f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig), '', 
          DECODE (dpa.serie_orig,'', 
            DECODE (ana.serie_orig,'', DECODE (ana.atto_orig, '', 'Serie __', ''),'Serie ' || ana.serie_orig),
            'Serie ' || dpa.serie_orig)),
-- numero_atto_ansc_orig
        f_CIV_numero_atto_ansc(dpa.id_atto_ansc_orig),
-- comune_atto
        f_CER_comune_atto_civ(4,mat.ufficio,mat.anno,mat.parte,mat.serie,mat.natura),
-- cognome_nome_sposo
        REPLACE (mat.cognome_nome_m, '/', ' '),
-- cognome_sposo
        SUBSTR (mat.cognome_Nome_m,1, INSTR (mat.cognome_nome_m, '/') - 1),
-- nome_sposo
        SUBSTR (mat.cognome_Nome_m, INSTR (mat.cognome_nome_m, '/') + 1),
-- codice_fiscale_sposo
        mat.cod_fiscale_m,
-- nato_il
        DECODE (mat.anni_m, '', 'nato il', ''),
-- data_nascita_sposo
        DECODE (mat.anni_m,'',decode(anno_nas_m,'S','00/00/'||TO_CHAR (TO_DATE (mat.data_nas_m, 'j'), 'yyyy'),
                TO_CHAR (TO_DATE (mat.data_nas_m, 'j'), 'dd/mm/yyyy')),'di anni ' || mat.anni_m || ' nato'),
-- comune_nascita_sposo
        RTRIM (NVL (a.descrizione_al1, a.descrizione)||' '||
               f_provincia_stato_cer(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',mat.data_nas_m)),
-- cap_comune_nascita_sposo
        LPAD (a.cap, 5, '0'),
-- tribunale_nascita_sposo
        nvl(a_trib.descrizione_al1,a_trib.descrizione), 
-- atto_nascita_sposo
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          NVL (TO_CHAR (spo.atto_nas_m), '_____'),
          spo.id_atto_ansc_nas_m),
-- parte_nascita_sposo
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          DECODE (spo.atto_nas_m,'', NVL (spo.parte_nas_m, '_____'),spo.parte_nas_m)),
-- serie_nascita_sposo
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          DECODE (spo.serie_nas_m,'', DECODE (spo.atto_nas_m, '', '__', ''),spo.serie_nas_m)),
-- anno_atto_nascita_sposo
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          DECODE (spo.anno_atto_nas_m,'', DECODE (spo.atto_nas_m, '', '____', ''),spo.anno_atto_nas_m)),
-- numero_atto_ansc_nascita_sposo
        f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m),
-- atto_nascita_sposo_edit
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          DECODE(spo.atto_nas_m,'',TO_CHAR (NULL),'atto N. ' || spo.atto_nas_m || ' p.' || spo.parte_nas_m
                    ||DECODE (spo.serie_nas_m,'', TO_CHAR (NULL),' s.' || spo.serie_nas_m)
                    ||DECODE (spo.anno_atto_nas_m,'', TO_CHAR (NULL),' / ' || spo.anno_atto_nas_m)),
          'atto N. '||spo.id_atto_ansc_nas_m),
-- comune_atto_nascita_sposo
        decode(spo.cod_pro_atto_nas_m||spo.cod_com_atto_nas_m,'',spo.com_atto_nas_m,nvl(com_atto_nas_m.descrizione_al1,com_atto_nas_m.descrizione)),
-- cap_comune_atto_nascita_sposo
        decode(spo.cod_pro_atto_nas_m||spo.cod_com_atto_nas_m,'','',lpad(com_atto_nas_m.cap,5,'0')),
-- nazionalita_sposo
        nvl(dci_m.descrizione_m,dci_m.descrizione),
-- residenza_sposo
        RTRIM (nvl(b.descrizione_al1,b.descrizione)||' '||
                 f_provincia_stato(b.cod_provincia,b.cod_comune,b.sigla_provincia,'S','S')),
-- cap_residenza_sposo
        LPAD (b.cap, 5, '0'),
-- indirizzo_ana_sposo
        vie_m.denom_uff || fam_m.civico_esterno,
-- cognome_nome_sposa
        REPLACE (mat.cognome_nome_f, '/', ' '),
-- cognome_sposa
        SUBSTR (mat.cognome_Nome_f,1,INSTR (mat.cognome_nome_f, '/') - 1),
-- nome_sposa
        SUBSTR (mat.cognome_Nome_f, INSTR (mat.cognome_nome_f, '/') + 1),
-- codice_fiscale_sposa
        mat.cod_fiscale_f,
-- nata_il
        DECODE (mat.anni_f, '', 'nata il', ''),
-- data_nascita_sposa
        DECODE (mat.anni_f,'',decode(anno_nas_f,'S','00/00/'||TO_CHAR (TO_DATE (mat.data_nas_f, 'j'), 'yyyy'),
               TO_CHAR (TO_DATE (mat.data_nas_f, 'j'), 'dd/mm/yyyy')),'di anni ' || mat.anni_f || ' nata'),
-- comune_nascita_sposa
        RTRIM (NVL (c.descrizione_al1, c.descrizione)||' '||
                f_provincia_stato_cer (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S',mat.data_nas_f)),
-- cap_comune_nascita_sposa
        LPAD (c.cap, 5, '0'),
-- tribunale_nascita_sposa
        nvl(c_trib.descrizione_al1,c_trib.descrizione), 
-- atto_nascita_sposa
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', 
          NVL (TO_CHAR (spo.atto_nas_f), '_____'),
          spo.id_atto_ansc_nas_f),
-- parte_nascita_sposa
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', 
          DECODE (spo.atto_nas_f,'', NVL (spo.parte_nas_f, '_____'),spo.parte_nas_f)),
-- serie_nascita_sposa
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', 
          DECODE (spo.serie_nas_f,'', DECODE (spo.atto_nas_f, '', '__', ''),spo.serie_nas_f)),
-- anno_atto_nascita_sposa
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', 
          DECODE (spo.anno_atto_nas_f,'', DECODE (spo.atto_nas_f, '', '____', ''),spo.anno_atto_nas_f)),
-- numero_atto_ansc_nascita_sposa
        f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f),
-- atto_nascita_sposa_edit
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '', 
          DECODE (spo.atto_nas_f,'',TO_CHAR (NULL),'atto N. ' || spo.atto_nas_f || ' p.' || spo.parte_nas_f
                ||DECODE(spo.serie_nas_f,'', TO_CHAR (NULL),' s.' || spo.serie_nas_f)
                ||DECODE(spo.anno_atto_nas_f,'', TO_CHAR (NULL),' / ' || spo.anno_atto_nas_f)),
          'atto N. '||spo.id_atto_ansc_nas_f),
-- comune_atto_nascita_sposa
        decode(spo.cod_pro_atto_nas_f||spo.cod_com_atto_nas_f,'',spo.com_atto_nas_f,nvl(com_atto_nas_f.descrizione_al1,com_atto_nas_f.descrizione)),
-- cap_comune_atto_nascita_sposa
        decode(spo.cod_pro_atto_nas_f||spo.cod_com_atto_nas_f,'',spo.com_atto_nas_f,lpad(com_atto_nas_f.cap,5,'0')),
-- nazionalita_sposa
        nvl(dci_f.descrizione_f,dci_f.descrizione),
-- residenza_sposa
        RTRIM (nvl(d.descrizione_al1,d.descrizione)||' '||
                    f_provincia_stato(d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S')),
-- cap_residenza_sposa
        LPAD (d.cap, 5, '0'),
-- indirizzo_ana_sposa
        vie_f.denom_uff || fam_f.civico_esterno,
-- data_matrimonio
        TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'dd/mm/yyyy'),
-- giorno_matrimonio
        TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'dd'),
-- giorno_matrimonio_lettere
            UPPER(DECODE (cl_c.lettere,'UN',decode(upper(inp.valore),'S','PRIMO','UNO'),cl_c.lettere)),
-- mese_matrimonio
        DECODE (TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'mm'),
                            1,'GENNAIO',2,'FEBBRAIO',3,'MARZO',
                            4,'APRILE',5,'MAGGIO',6, 'GIUGNO',
                            7, 'LUGLIO',8, 'AGOSTO',9, 'SETTEMBRE',
                            10, 'OTTOBRE',11, 'NOVEMBRE','DICEMBRE'),
-- anno_matrimonio
        TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'yyyy'),
-- anno_matrimonio_lettere
        UPPER(DECODE (SUBSTR (TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'yyyy'),1,2),
                        18,'milleottocent',19,'millenovecent',20,'duemila','')
         || DECODE (SUBSTR (TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'yyyy'),1,2),
                        20,'',DECODE (SUBSTR (TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'yyyy'),3,1),
                         8,'','o'))
         || LOWER (DECODE (cl_d.lettere, 'UN', 'UNO', cl_d.lettere))),
-- comune_matrimonio
        RTRIM (NVL (e.descrizione_al1, e.descrizione)||' '||
               f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S')),
-- cap_comune_matrimonio
        LPAD (e.cap, 5, '0'),
-- ufficio_matrimonio
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', spo.ufficio_mat),
-- anno_atto_matrimonio 
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', spo.anno_atto_mat),
-- atto_matrimonio
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', to_char(spo.atto_mat), spo.id_atto_ansc_mat),
-- parte_matrimonio
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', spo.parte_mat),
-- serie_matrimonio
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', spo.serie_mat),
-- numero_atto_ansc_matrimonio
        f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat),
-- comune_atto_matrimonio
        RTRIM (NVL (com_atto_mat.descrizione_al1, com_atto_mat.descrizione)||' '||
               f_provincia_stato (com_atto_mat.cod_provincia,com_atto_mat.cod_comune,com_atto_mat.sigla_provincia,'S','S')),
-- cap_comune_atto_matrimonio
        LPAD (com_atto_mat.cap, 5, '0'),
-- rito
        decode(dma.rito1||dma.rito2||dma.rito3,null,'__________',dma.rito1||
        decode(dma.rito2,null,'',decode(dma.rito1,null,'',' ')||dma.rito2)||
        decode(dma.rito3,null,'',decode(dma.rito1||rito2,null,'',' ')||dma.rito3)),
-- data_riconciliazione
        decode(cta.sigla, 
          'RCN', TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'dd/mm/yyyy')),
-- data_conferma_divorzio
        decode(cta.sigla, 
          'UCO', to_char(mat.d_data_mat,'dd/mm/yyyy'),
          'AVV', to_char(mat.d_data_mat,'dd/mm/yyyy'),
          'TRI', to_char(mat.d_data_mat, 'dd/mm/yyyy'),
          'EST', to_char(mat.d_data_mat, 'dd/mm/yyyy'),
                 to_char(dpa.d_conferma_data,'dd/mm/yyyy')),
-- data_accordo_divorzio
        decode(cta.sigla, 
          'UAC', to_char(mat.d_data_mat,'dd/mm/yyyy'),
                 to_char(dpa.d_accordo_data,'dd/mm/yyyy')),
-- comune_data
        f.descrizione || ' ' || TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- comune
        f.descrizione,
-- data
        TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- convenzioni
        convenzioni,
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
-- quallifica_prov
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
-- terminalista_atto
        mat.terminalista,
-- flag_comune_estero_res_m
        DECODE (SIGN (nvl(mat.cod_pro_res_m,0) - 199), -1, TO_CHAR (NULL), 'S'),
-- flag_comune_estero_res_f
        DECODE (SIGN (nvl(mat.cod_pro_res_F,0) - 199), -1, TO_CHAR (NULL), 'S'),
-- id_atto
        mat.id_atto,
-- numero_unico
       f_CIV_numero_unico_comunale(mat.numero_unico)
  FROM arcinp inp,
       cilet cl_c, cilet cl_d,
       arccom a, arccom b, arccom c, arccom d, arccom e, arccom f, arccom com_atto_mat,
       arccom com_atto_nas_m, arccom com_atto_nas_f,
       arccom a_trib, arccom c_trib, 
       arcvie vie_m, arcvie vie_f,
       anafam fam_m, anafam fam_f,
       anaana ana_m, anaana ana_f,
       anadci dci_m, anadci dci_f,
       civcta cta, civdta dta,
       civdma dma, civdpa dpa, civspo spo,
       civana ana, civmat mat
 WHERE cl_c.chiave          (+) = TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'dd')
   AND cl_c.tipo            (+) = 'U'
   AND cl_d.chiave          (+) = TO_CHAR (TO_DATE (mat.data_mat, 'j'), 'yy')
   AND cl_d.tipo            (+) = 'U'
   and inp.parametro            = 'ATTI_PRIMO'
   AND a.cod_comune         (+) = mat.cod_com_nas_m
   AND a.cod_provincia      (+) = mat.cod_pro_nas_m
   AND a_trib.cod_comune    (+) = SUBSTR (LPAD (a.tribunale, 6, '0'), 4, 3)
   AND a_trib.cod_provincia (+) = SUBSTR (LPAD (a.tribunale, 6, '0'), 1, 3)
   AND b.cod_comune         (+) = mat.cod_com_res_m
   AND b.cod_provincia      (+) = mat.cod_pro_res_m
   AND c.cod_comune         (+) = mat.cod_com_nas_f
   AND c.cod_provincia      (+) = mat.cod_pro_nas_f
   AND c_trib.cod_comune    (+) = SUBSTR (LPAD (c.tribunale, 6, '0'), 4, 3)
   AND c_trib.cod_provincia (+) = SUBSTR (LPAD (c.tribunale, 6, '0'), 1, 3)
   AND d.cod_comune         (+) = mat.cod_com_res_f
   AND d.cod_provincia      (+) = mat.cod_pro_res_f
   AND e.cod_comune         (+) = mat.cod_com_mat
   AND e.cod_provincia      (+) = mat.cod_pro_mat
   AND com_atto_mat.cod_provincia (+) = spo.cod_pro_atto_mat
   AND com_atto_mat.cod_comune    (+) = spo.cod_com_atto_mat
   AND com_atto_nas_m.cod_provincia (+) = spo.cod_pro_atto_nas_m
   AND com_atto_nas_m.cod_comune    (+) = spo.cod_com_atto_nas_m
   AND com_atto_nas_f.cod_provincia (+) = spo.cod_pro_atto_nas_f
   AND com_atto_nas_f.cod_comune    (+) = spo.cod_com_atto_nas_f
   AND (f.cod_provincia, f.cod_comune) = (SELECT   pro_cliente, com_cliente FROM menuditta)
   AND vie_m.cod_via        (+) = fam_m.cod_via
   AND fam_m.fascia         (+) = ana_m.fascia
   AND fam_m.cod_fam        (+) = ana_m.cod_fam
   AND ana_m.fascia         (+) = 1
   AND ana_m.matricola      (+) = ana.matricola_1
   AND vie_f.cod_via        (+) = fam_f.cod_via
   AND fam_f.fascia         (+) = ana_f.fascia
   AND fam_f.cod_fam        (+) = ana_f.cod_fam
   AND ana_f.fascia         (+) = 1
   AND ana_f.matricola      (+) = ana.matricola_2
   AND dci_m.cod_ci         (+) = mat.nazionalita_m
   AND dci_f.cod_ci         (+) = mat.nazionalita_f
   and cta.id               (+) = dta.id_civcta
   and dta.id               (+) = mat.id_civdta
   AND dpa.id_atto          (+) = mat.id_atto
   AND spo.id_atto          (+) = mat.id_atto
   AND dma.id_atto          (+) = mat.id_atto
   AND ana.id_atto          (+) = mat.id_atto
   AND mat.cod_rec              IN (0,3)
/
comment on table cercma is 'Stato Civile - Dati Atti di Matrimonio per Comunicazioni'
/
