--liquibase formatted sql
--changeset amonopoli:202303130845_2 runOnChange:true stripComments:false
create or replace view cercuc
	(ufficio,anno,atto,parte,parte_edit,serie,serie_edit,natura,
         NUMERO_ATTO_ANSC,
	 ufficio_orig,anno_orig,atto_orig,parte_orig,parte_orig_edit,
	 serie_orig,serie_orig_edit,
         NUMERO_ATTO_ANSC_ORIG,
         comune_atto,
	 cognome_nome_1,cognome_1,nome_1,
	 codice_fiscale_1,nat_oa_il_1,data_nascita_1,
	 comune_nascita_1,cap_comune_nascita_1,
	 tribunale_nascita_1,
	 atto_nascita_1,parte_nascita_1,serie_nascita_1,
	 anno_atto_nascita_1,
         numero_atto_ansc_nascita_1,
	 atto_nascita_1_edit,comune_atto_nascita_1,cap_comune_atto_nascita_1,
         cittadin_oa_1,nazionalita_1,
	 residenza_1,cap_residenza_1,indirizzo_ana_1,
	 cognome_nome_2,cognome_2,nome_2,
	 codice_fiscale_2,nat_oa_il_2,data_nascita_2,
	 comune_nascita_2,cap_comune_nascita_2,
	 tribunale_nascita_2,
	 atto_nascita_2,parte_nascita_2,serie_nascita_2,
	 anno_atto_nascita_2,
         numero_atto_ansc_nascita_2,
	 atto_nascita_2_edit,comune_atto_nascita_2,cap_comune_atto_nascita_2,
         cittadin_oa_2,nazionalita_2,
	 residenza_2,cap_residenza_2,indirizzo_ana_2,
	 data_unione,
	 giorno_unione,giorno_unione_lettere,
	 mese_unione,
	 anno_unione,anno_unione_lettere,
	 comune_unione,cap_comune_unione,
	 ufficio_unione, anno_atto_unione, atto_unione, parte_unione, serie_unione,
         numero_atto_ansc_unione,
	 comune_atto_unione,cap_comune_atto_unione,
         data_conferma_scioglimento,data_accordo_scioglimento,
	 comune_data,comune,data,
	 convenzioni,
         testimone_1,
         nat_oa_il_testimone_1, comune_nas_testimone_1,
         data_nas_testimone_1, residenza_testimone_1,
         cittadin_oa_testimone_1, nazionalita_testimone_1,
         testimone_2,
         nat_oa_il_testimone_2, comune_nas_testimone_2,
         data_nas_testimone_2, residenza_testimone_2,
         cittadin_oa_testimone_2, nazionalita_testimone_2,
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
SELECT uci.ufficio,uci.anno, uci.atto,uci.parte,
        DECODE (uci.parte,1,'I',2, 'II'), uci.serie,
        DECODE (uci.serie, '', '', 'Serie ' || uci.serie),
        uci.natura,
        f_CIV_numero_atto_ansc(uci.id_atto_ansc,uci.numero_unico),
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
          DECODE (dpa.serie_orig,'',
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
        f_CER_comune_atto_civ(-4,uci.ufficio,uci.anno,uci.parte,uci.serie,uci.natura),
-- cognome_nome_1
        REPLACE (uci.cognome_nome_m, '/', ' '),
-- cognome_1
        SUBSTR (uci.cognome_Nome_m,1, INSTR (uci.cognome_nome_m, '/') - 1),
-- nome_1
        SUBSTR (uci.cognome_Nome_m, INSTR (uci.cognome_nome_m, '/') + 1),
-- codice_fiscale_1
        uci.cod_fiscale_m,
-- nat_oa_il_1
        DECODE (uci.anni_m, '', decode(uci.sesso_m,'M','nato il','nata il'), ''),
-- data_nascita_1
        DECODE (uci.anni_m,'',decode(anno_nas_m,'S','00/00/'||TO_CHAR (TO_DATE (uci.data_nas_m, 'j'), 'yyyy'),
                TO_CHAR (TO_DATE (uci.data_nas_m, 'j'), 'dd/mm/yyyy')),'di anni ' || uci.anni_m || ' nato'),
-- comune_nascita_1
        RTRIM (nvl(a.descrizione_al1,a.descrizione)||' '||
               f_provincia_stato_cer(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S',uci.data_nas_m)),
-- cap_comune_nascita_1
        LPAD (a.cap, 5, '0'),
-- tribunale_nascita_1
        nvl(a_trib.descrizione_al1,a_trib.descrizione),
-- atto_nascita_1
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          NVL (TO_CHAR (spo.atto_nas_m), '_____'),
          spo.id_atto_ansc_nas_m),
-- parte_nascita_1
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          DECODE (spo.atto_nas_m,'', NVL (spo.parte_nas_m, '_____'),spo.parte_nas_m)),
-- serie_nascita_1
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          DECODE (spo.serie_nas_m,'', DECODE (spo.atto_nas_m, '', '__', ''),spo.serie_nas_m)),
-- anno_atto_nascita_1
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          DECODE (spo.anno_atto_nas_m,'', DECODE (spo.atto_nas_m, '', '____', ''),spo.anno_atto_nas_m)),
-- numero_atto_ansc_nascita_1
        f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m),
-- atto_nascita_1_edit
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_m), '',
          DECODE(spo.atto_nas_m,'',TO_CHAR (NULL),'atto N. ' || spo.atto_nas_m || ' p.' || spo.parte_nas_m
                    ||DECODE (spo.serie_nas_m,'', TO_CHAR (NULL),' s.' || spo.serie_nas_m)
                    ||DECODE (spo.anno_atto_nas_m,'', TO_CHAR (NULL),' / ' || spo.anno_atto_nas_m)),
          'atto N. '||spo.id_atto_ansc_nas_m),
-- comune_atto_nascita_1
        nvl(nvl(com_atto_nas_1.descrizione_al1,com_atto_nas_1.descrizione),spo.com_atto_nas_m),
-- comune_atto_nascita_1
        lpad(com_atto_nas_1.cap,5,'0'),
-- cittadin_oa_1
	decode(uci.sesso_m,'M','cittadino','F','cittadina'),
-- nazionalita_1
	nvl(decode(uci.sesso_m,'M',dci_1.descrizione_m,'F',dci_1.descrizione_f),dci_1.descrizione),
-- residenza_1
        RTRIM (nvl(b.descrizione_al1,b.descrizione)||' '||
                 f_provincia_stato(b.cod_provincia,b.cod_comune,b.sigla_provincia,'S','S')),
-- cap_residenza_1
        LPAD (b.cap, 5, '0'),
-- indirizzo_ana_1
        vie_1.denom_uff || fam_1.civico_esterno,
-- cognome_nome_2
        REPLACE (uci.cognome_nome_f, '/', ' '),
-- cognome_2
        SUBSTR (uci.cognome_Nome_f,1,INSTR (uci.cognome_nome_f, '/') - 1),
-- nome_2
        SUBSTR (uci.cognome_Nome_f, INSTR (uci.cognome_nome_f, '/') + 1),
-- codice_fiscale_2
        uci.cod_fiscale_f,
-- nat_oa_il_2
        DECODE (uci.anni_f, '', decode(uci.sesso_f,'M','nato il','nata il'), ''),
-- data_nascita_2
        DECODE (uci.anni_f,'',decode(anno_nas_f,'S','00/00/'||TO_CHAR (TO_DATE (uci.data_nas_f, 'j'), 'yyyy'),
               TO_CHAR (TO_DATE (uci.data_nas_f, 'j'), 'dd/mm/yyyy')),'di anni ' || uci.anni_f || ' nata'),
-- comune_nascita_2
        RTRIM (nvl(c.descrizione_al1,c.descrizione)||' '||
                f_provincia_stato_cer (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S',uci.data_nas_f)),
-- cap_comune_nascita_2
        LPAD (c.cap, 5, '0'),
-- tribunale_nascita_2
        nvl(c_trib.descrizione_al1,c_trib.descrizione),
-- atto_nascita_2
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '',
          NVL (TO_CHAR (spo.atto_nas_f), '_____'),
          spo.id_atto_ansc_nas_f),
-- parte_nascita_2
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '',
          DECODE (spo.atto_nas_f,'', NVL (spo.parte_nas_f, '_____'),spo.parte_nas_f)),
-- serie_nascita_2
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '',
          DECODE (spo.serie_nas_f,'', DECODE (spo.atto_nas_f, '', '__', ''),spo.serie_nas_f)),
-- anno_atto_nascita_2
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '',
          DECODE (spo.anno_atto_nas_f,'', DECODE (spo.atto_nas_f, '', '____', ''),spo.anno_atto_nas_f)),
-- numero_atto_ansc_nascita_2
        f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f),
-- atto_nascita_2_edit
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_nas_f), '',
          DECODE (spo.atto_nas_f,'',TO_CHAR (NULL),'atto N. ' || spo.atto_nas_f || ' p.' || spo.parte_nas_f
                ||DECODE(spo.serie_nas_f,'', TO_CHAR (NULL),' s.' || spo.serie_nas_f)
                ||DECODE(spo.anno_atto_nas_f,'', TO_CHAR (NULL),' / ' || spo.anno_atto_nas_f)),
          'atto N. '||spo.id_atto_ansc_nas_f),
-- comune_atto_nascita_2
        nvl(nvl(com_atto_nas_2.descrizione_al1,com_atto_nas_2.descrizione),spo.com_atto_nas_f),
-- cap_comune_atto_nascita_2
        lpad(com_atto_nas_2.cap,5,'0'),
-- cittadin_oa_2
	decode(uci.sesso_f,'M','cittadino','F','cittadina'),
-- nazionalita_2
	nvl(decode(uci.sesso_f,'M',dci_2.descrizione_m,'F',dci_2.descrizione_f),dci_2.descrizione),
-- residenza_2
        RTRIM (nvl(d.descrizione_al1,d.descrizione)||' '||
                    f_provincia_stato(d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S')),
-- cap_residenza_2
        LPAD (d.cap, 5, '0'),
-- indirizzo_ana_2
        vie_2.denom_uff || fam_2.civico_esterno,
-- data_unione
        TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'dd/mm/yyyy'),
-- giorno_unione
        TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'dd'),
-- giorno_unione_lettere
            UPPER(DECODE (cl_c.lettere,'UN',decode(upper(inp.valore),'S','PRIMO','UNO'),cl_c.lettere)),
-- mese_unione
        DECODE (TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'mm'),
                            1,'GENNAIO',2,'FEBBRAIO',3,'MARZO',
                            4,'APRILE',5,'MAGGIO',6, 'GIUGNO',
                            7, 'LUGLIO',8, 'AGOSTO',9, 'SETTEMBRE',
                            10, 'OTTOBRE',11, 'NOVEMBRE','DICEMBRE'),
-- anno_unione
        TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'yyyy'),
-- anno_unione_lettere
        UPPER(DECODE (SUBSTR (TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'yyyy'),1,2),
                        18,'milleottocent',19,'millenovecent',20,'duemila','')
         || DECODE (SUBSTR (TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'yyyy'),1,2),
                        20,'',DECODE (SUBSTR (TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'yyyy'),3,1),
                         8,'','o'))
         || LOWER (DECODE (cl_d.lettere, 'UN', 'UNO', cl_d.lettere))),
-- comune_unione
        RTRIM (nvl(e.descrizione_al1,e.descrizione)||' '||
                 f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S')),
-- cap_comune_unione
        LPAD (e.cap, 5, '0'),
-- ufficio_unione
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', spo.ufficio_mat),
-- anno_atto_unione
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', spo.anno_atto_mat),
-- atto_unione
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', to_char(spo.atto_mat), spo.id_atto_ansc_mat),
-- parte_unione
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', spo.parte_mat),
-- serie_unione
        decode(f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat), '', spo.serie_mat),
-- numero_atto_ansc_unione
        f_CIV_numero_atto_ansc(spo.id_atto_ansc_mat),
-- comune_atto_unione
        RTRIM (NVL (com_atto_uci.descrizione_al1, com_atto_uci.descrizione)||' '||
               f_provincia_stato (com_atto_uci.cod_provincia,com_atto_uci.cod_comune,com_atto_uci.sigla_provincia,'S','S')),
-- cap_comune_atto_unione
        LPAD (com_atto_uci.cap, 5, '0'),
-- data_conferma_scioglimento
        decode(cta.sigla,
          'UCO', to_char(uci.d_data_mat, 'dd/mm/yyyy'),
          'AVV', to_char(uci.d_data_mat, 'dd/mm/yyyy'),
          'TRI', to_char(uci.d_data_mat, 'dd/mm/yyyy'),
          'EST', to_char(uci.d_data_mat, 'dd/mm/yyyy'),
          'ANN', to_char(uci.d_data_mat, 'dd/mm/yyyy'),
                 to_char(dpa.d_conferma_data, 'dd/mm/yyyy')),
-- data_accordo_scioglimento
        decode(cta.sigla,
          'UAC', to_char(uci.d_data_mat, 'dd/mm/yyyy'),
                 to_char(dpa.d_accordo_data, 'dd/mm/yyyy')),
-- comune_data
        f.descrizione || ' ' || TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- comune
        f.descrizione,
-- data
        TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- convenzioni
        convenzioni,
-- testimone_..._1
  -- testimone_1
       decode(tta.atto,'', translate(nvl(test_1,'-'),'/',' '),
         tta.cognome_1||' '||tta.nome_1),
  -- nat_oa_il_testimone_1
       decode(tta.atto,'', decode(tte.nato_1,'','-','nat'||tte.nato_1||' il'),
         decode(tta.sesso_1,'M','nato','F','nata')||' il'),
  -- comune_nas_testimone_1
       decode(tta.atto,'', decode(tte.com_nas_1,'','-',tte.com_nas_1),
         f_comune_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,to_char(tta.d_data_nas_1,'j'))||' '||
         f_provincia_stato_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,'','S','S',to_char(tta.d_data_nas_1,'j'))),
  -- data_nas_testimone_1
       decode(tta.atto,'', to_char(to_date(tte.data_nas_1_j,'j'),'dd/mm/yyyy'),
         to_char(tta.d_data_nas_1,'dd/mm/yyyy')),
  -- residenza_testimone_1
       decode(tta.atto,'', nvl(tte.residenza_1,'-'),
         f_comune_al(tta.cod_pro_res_1,tta.cod_com_res_1,'')||' '||
         f_provincia_stato_al(tta.cod_pro_res_1,tta.cod_com_res_1,'','S','S','')),
  -- cittadin_oa_testimone_1
       decode(tta.atto,'', decode(tte.cittadino_1,'','-','cittadin'||tte.cittadino_1),
         decode(tta.sesso_1,'M','cittadino','F','cittadina')),
  -- nazionalita_testimone_1
       decode(tta.atto,'', nvl(tte.nazionalita_1,'-'),
         decode(tta.nazionalita_1, '','-', nvl(decode(tta.sesso_1,'M',dci_t1.descrizione_m,'F',dci_t1.descrizione_f),dci_t1.descrizione))),
-- testimone_..._2
  -- testimone_2
       decode(tta.atto,'', translate(nvl(test_2,'-'),'/',' '),
         tta.cognome_2||' '||tta.nome_2),
  -- nat_oa_il_testimone_2
       decode(tta.atto,'', decode(tte.nato_2,'','-','nat'||tte.nato_2||' il'),
         decode(tta.sesso_2,'M','nato','F','nata')||' il'),
  -- comune_nas_testimone_2
       decode(tta.atto,'', decode(tte.com_nas_2,'','-',tte.com_nas_2),
         f_comune_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,to_char(tta.d_data_nas_2,'j'))||' '||
         f_provincia_stato_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,'','S','S',to_char(tta.d_data_nas_2,'j'))),
  -- data_nas_testimone_2
       decode(tta.atto,'', to_char(to_date(tte.data_nas_2_j,'j'),'dd/mm/yyyy'),
         to_char(tta.d_data_nas_2,'dd/mm/yyyy')),
  -- residenza_testimone_2
       decode(tta.atto,'', nvl(tte.residenza_2,'-'),
         f_comune_al(tta.cod_pro_res_2,tta.cod_com_res_2,'')||' '||
         f_provincia_stato_al(tta.cod_pro_res_2,tta.cod_com_res_2,'','S','S','')),
  -- cittadin_oa_testimone_2
       decode(tta.atto,'', decode(tte.cittadino_2,'','-','cittadin'||tte.cittadino_2),
         decode(tta.sesso_1,'M','cittadino','F','cittadina')),
  -- nazionalita_testimone_2
       decode(tta.atto,'', nvl(tte.nazionalita_2,'-'),
         decode(tta.nazionalita_2, '','-', nvl(decode(tta.sesso_2,'M',dci_t2.descrizione_m,'F',dci_t2.descrizione_f),dci_t2.descrizione))),
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
        uci.terminalista,
-- flag_comune_estero_res_m
        DECODE (SIGN (nvl(uci.cod_pro_res_m,0) - 199), -1, TO_CHAR (NULL), 'S'),
-- flag_comune_estero_res_f
        DECODE (SIGN (nvl(uci.cod_pro_res_F,0) - 199), -1, TO_CHAR (NULL), 'S'),
-- id_atto
       uci.id_atto,
-- numero_unico
       f_CIV_numero_unico_comunale(uci.numero_unico)
  FROM arcinp inp,
       cilet cl_c, cilet cl_d,
       arccom a, arccom b, arccom c, arccom d, arccom e, arccom f, arccom com_atto_uci,
       arccom a_trib, arccom c_trib,
       arccom com_atto_nas_1, arccom com_atto_nas_2,
       arcvie vie_1, arcvie vie_2,
       anafam fam_1, anafam fam_2,
       anaana ana_1, anaana ana_2,
       anadci dci_1, anadci dci_2,
       anadci dci_t1, anadci dci_t2,
       civcta cta, civdta dta,
       civdpa dpa, civspo spo, civtte tte, civtta tta,
       civana ana, civuci uci
 WHERE cl_c.chiave (+)          = TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'dd')
   AND cl_c.tipo   (+)          = 'U'
   AND cl_d.chiave (+)          = TO_CHAR (TO_DATE (uci.data_mat, 'j'), 'yy')
   AND cl_d.tipo   (+)          = 'U'
   and inp.parametro            = 'ATTI_PRIMO'
   AND com_atto_nas_1.cod_comune    (+) = spo.cod_com_atto_nas_m
   AND com_atto_nas_1.cod_provincia (+) = spo.cod_pro_atto_nas_m
   AND com_atto_nas_2.cod_comune    (+) = spo.cod_com_atto_nas_f
   AND com_atto_nas_2.cod_provincia (+) = spo.cod_pro_atto_nas_f
   AND a.cod_comune         (+) = uci.cod_com_nas_m
   AND a.cod_provincia      (+) = uci.cod_pro_nas_m
   AND a_trib.cod_comune    (+) = SUBSTR (LPAD (a.tribunale, 6, '0'), 4, 3)
   AND a_trib.cod_provincia (+) = SUBSTR (LPAD (a.tribunale, 6, '0'), 1, 3)
   AND b.cod_comune    (+)      = uci.cod_com_res_m
   AND b.cod_provincia (+)      = uci.cod_pro_res_m
   AND c.cod_comune         (+) = uci.cod_com_nas_f
   AND c.cod_provincia      (+) = uci.cod_pro_nas_f
   AND c_trib.cod_comune    (+) = SUBSTR (LPAD (c.tribunale, 6, '0'), 4, 3)
   AND c_trib.cod_provincia (+) = SUBSTR (LPAD (c.tribunale, 6, '0'), 1, 3)
   AND d.cod_comune    (+)    = uci.cod_com_res_f
   AND d.cod_provincia (+)    = uci.cod_pro_res_f
   AND e.cod_comune    (+)    = uci.cod_com_mat
   AND e.cod_provincia (+)    = uci.cod_pro_mat
   AND com_atto_uci.cod_provincia (+) = spo.cod_pro_atto_mat
   AND com_atto_uci.cod_comune    (+) = spo.cod_com_atto_mat
   AND (f.cod_provincia, f.cod_comune) = (SELECT   pro_cliente, com_cliente FROM menuditta)
   AND vie_1.cod_via   (+)    = fam_1.cod_via
   AND fam_1.fascia    (+)    = ana_1.fascia
   AND fam_1.cod_fam   (+)    = ana_1.cod_fam
   AND ana_1.fascia    (+)    = 1
   AND ana_1.matricola (+)    = ana.matricola_1
   AND vie_2.cod_via   (+)    = fam_2.cod_via
   AND fam_2.fascia    (+)    = ana_2.fascia
   AND fam_2.cod_fam   (+)    = ana_2.cod_fam
   AND ana_2.fascia    (+)    = 1
   AND ana_2.matricola (+)    = ana.matricola_2
   and dci_1.cod_ci    (+)    = uci.nazionalita_m
   and dci_2.cod_ci    (+)    = uci.nazionalita_f
   and tte.id_atto (+)     = uci.id_atto
   and tta.id_atto     (+) = uci.id_atto
   and dci_t1.cod_ci   (+) = tta.nazionalita_1
   and dci_t2.cod_ci   (+) = tta.nazionalita_2
   and cta.id          (+) = dta.id_civcta
   and dta.id          (+) = uci.id_civdta
   AND dpa.id_atto(+)      = uci.id_atto
   AND spo.id_atto(+)      = uci.id_atto
   AND ana.id_atto(+)      = uci.id_atto
   AND uci.cod_rec           IN (0, 3)
/
comment on table cercuc is 'Stato Civile - Dati Atti di Unione Civile per Comunicazioni'
/
