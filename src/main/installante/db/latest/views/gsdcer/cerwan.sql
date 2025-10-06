--liquibase formatted sql
--changeset amonopoli:202504141210 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW CERWAN
(MATRICOLA, COGNOME_NOME, COGNOME, NOME, COGNOME_NOME_ELE, COGNOME_ELE, NOME_ELE,
 SESSO, STATO_CIVILE, STATO_CIVILE_CDI, STAMPA_STATO_CIVILE_CDI,
 NAT_OA, CITTADINO_ITALIANO, CITTADINANZA, INIZIO_CITTADINANZA,
 PATERNITA, MATERNITA,
 INDIRIZZO, INDIRIZZO_INT, INIZIO_INDIRIZZO, RESIDENZA, INIZIO_RESIDENZA,
 VIA_AIRE, COMUNE_AIRE, STATO_AIRE, ZIPCODE, PROVINCIA_CONTEA, PRESSO,
 TIPO_CONSOLATO, INDIRIZZO_CONSOLATO, SEDE_CONSOLATO,
 TITOLO_STUDIO, PROFESSIONE, PROFESSIONE_CDI,
 DATA_NASCITA, COMUNE_NASCITA, COMUNE_ATTO_NASCITA, CAP_COMUNE_ATTO_NASCITA, ATTO_NASCITA,
 CONIUGAT_OA, COGNOME_NOME_CONIUGE, COGNOME_CONIUGE, NOME_CONIUGE,
 COGNOME_NOME_CONIUGE_CN, COGNOME_CONIUGE_CN, NOME_CONIUGE_CN,
 ESTREMI_NASCITA_CONIUGE, ESTREMI_NASCITA_CONIUGE_CN, ATTO_NASCITA_CONIUGE,
 INDIRIZZO_CONIUGE, RESIDENZA_CONIUGE, INIZIO_RESIDENZA_CONIUGE, DATA_MORTE_CONIUGE,
 ESTREMI_MAT_VED, ATTO_MAT_VED,
 DATA_MATRIMONIO, COMUNE_MATRIMONIO, COMUNE_ATTO_MATRIMONIO, CAP_COMUNE_ATTO_MATRIMONIO, ATTO_MATRIMONIO,
 DATA_VEDOVANZA, COMUNE_VEDOVANZA, COMUNE_ATTO_VEDOVANZA, CAP_COMUNE_ATTO_VEDOVANZA, ATTO_VEDOVANZA,
 COGNOME_NOME_CV, COGNOME_CV, NOME_CV,
 ESTREMI_NASCITA_CV, ATTO_NASCITA_CV, CODICE_FISCALE_CV,
 DATA_INIZIO_CDF, COMUNE_INIZIO_CDF, PRATICA_INIZIO_CDF,
 DATA_FINE_CDF, COMUNE_FINE_CDF, PRATICA_FINE_CDF,
 CONTRATTO_CONVIVENZA,
 DECEDUT_OA, MORT_OA,
 DATA_MORTE, COMUNE_MORTE, COMUNE_ATTO_MORTE, CAP_COMUNE_ATTO_MORTE, ATTO_MORTE,
 CODICE_FISCALE, CODICE_FISCALE_VALIDATO,
 CODICE_FAMIGLIA,
 ANNO_CENSIMENTO, SEZIONE_CENSIMENTO, FOGLIO_CENSIMENTO, QUESTIONARIO_CENSIMENTO,
 INTESTATARIO_CONVIVENZA,
 ESTREMI_ULTIMO_EVENTO, PRATICA_ULTIMO_EVENTO, DATA_ULTIMO_EVENTO,
 DATA_RICOMPARSA, COMUNE_RICOMPARSA, PRATICA_RICOMPARSA,
 INDIRIZZO_PRECEDENTE,
 ISCRITT_OA, INCORS_OA, SOTTOSCRITT_OA,
 DIRITTI_POLITICI, SEZIONE, SEDE_SEZIONE, INDIRIZZO_SEZIONE, PROGR_LISTA_GENERALE, PROGR_LISTA_SEZIONALE,
 TESSERA_ELETTORALE, DATA_TESSERA_ELETTORALE,
 INDIRIZZO_ELE, FASCICOLO_ELE, VERBALE_ELE, DATA_VERBALE_ELE,
 ISCRIZIONE_AIRE,
 CLASSE_LEVA, NUMERO_LISTA, MATRICOLA_LEVA, DISTRETTO_LEVA,
 FERMA, ARMA, CORPO, FORZA_1, FORZA_2, FORZA_3, GRADO,
 COMUNE_LEVA, DATA_ARRUOLAMENTO, DATA_CHIAMATA, DATA_CONGEDO, ESITO_LEVA,
 NUMERO_CARTA, DATA_CARTA, COMUNE_CARTA, SCADENZA_CARTA, NATURA_CARTA,
 ATTO_NASCITA_CDI, PARTE_NASCITA_CDI, SERIE_NASCITA_CDI, UFFICIO_NASCITA_CDI,
 RESIDENZA_CDI, INDIRIZZO_CDI, STATURA_CDI, CAPELLI_CDI, OCCHI_CDI,
 SEGNI_1_CDI, SEGNI_2_CDI, SEGNI_3_CDI, ESPATRIO_1_CDI, ESPATRIO_2_CDI,
 NUMERO_LIBRETTO_LAVORO, DATA_LIBRETTO_LAVORO, COMUNE_LIBRETTO_LAVORO,
 NUMERO_PATENTE, NATURA_PATENTE, DATA_PATENTE, COMUNE_PATENTE, CATEGORIA_PATENTE,
 NUMERO_PERMESSO, NATURA_PERMESSO, DATA_PERMESSO, COMUNE_PERMESSO, SCADENZA_PERMESSO,
 NUMERO_CARTA_SOGGIORNO, NATURA_CARTA_SOGGIORNO, DATA_CARTA_SOGGIORNO, COMUNE_CARTA_SOGGIORNO, SCADENZA_CARTA_SOGGIORNO,
 NUMERO_ATTESTATO_U1, NATURA_ATTESTATO_U1, DATA_ATTESTATO_U1, COMUNE_ATTESTATO_U1, SCADENZA_ATTESTATO_U1,
 NUMERO_ATTESTATO_U2, NATURA_ATTESTATO_U2, DATA_ATTESTATO_U2, COMUNE_ATTESTATO_U2, SCADENZA_ATTESTATO_U2,
 NUMERO_CIE, NATURA_CIE, DATA_CIE, COMUNE_CIE, SCADENZA_CIE,
 NUMERO_CI_CIE, NATURA_CI_CIE, DATA_CI_CIE, COMUNE_CI_CIE, SCADENZA_CI_CIE,
 CAP_COMUNE_RESIDENZA, COMUNE_DATA, COMUNE, DATA, PROVINCIA,
 CAP_COMUNE_NASCITA, CAP_COMUNE_ULT_EVE, CAP_COMUNE_MORTE,
 FAMIGLIA_CONVIVENZA, DENOMINAZIONE_CONVIVENZA,
 FASCIA, COD_FAM, COD_RP, RAPPORTO_PARENTELA, SEQUENZA_PAR, INIZIO_FAMIGLIA,
 NUMERO_CARTA_CONIUGE, NATURA_CARTA_CONIUGE, DATA_CARTA_CONIUGE, COMUNE_CARTA_CONIUGE, SCADENZA_CARTA_CONIUGE,
 NUMERO_CIE_CONIUGE, NATURA_CIE_CONIUGE, DATA_CIE_CONIUGE, COMUNE_CIE_CONIUGE, SCADENZA_CIE_CONIUGE,
 NUMERO_CI_CIE_CONIUGE, NATURA_CI_CIE_CONIUGE, DATA_CI_CIE_CONIUGE, COMUNE_CI_CIE_CONIUGE, SCADENZA_CI_CIE_CONIUGE,
 DATA_INIZIO_TEMP, DATA_FINE_TEMP, COMUNE_TEMP, INDIRIZZO_TEMP
)
AS
   SELECT   ana.matricola,
-- cognome_nome
--    translate(ana.cognome_nome,'/',' '),
            REPLACE (ana.cognome_nome, '/', '   '),
-- cognome
            SUBSTR (ana.cognome_nome, 1, INSTR (ana.cognome_nome, '/') - 1),
-- nome
            SUBSTR (ana.cognome_nome, INSTR (ana.cognome_nome, '/') + 1),
-- cognome_nome_ele
            DECODE (ele.stato, 'E', REPLACE (ele.cognome_nome, '/', '   '),
              DECODE (ela_b.stato, 'E', REPLACE (ela_b.cognome_nome, '/', '   '),
                DECODE (ela_c.stato, 'E', REPLACE (ela_c.cognome_nome, '/', '   '),
                  DECODE (ela_e.stato, 'E', REPLACE (ela_e.cognome_nome, '/', '   '),
                    DECODE (ela_t.stato, 'E', REPLACE (ela_t.cognome_nome, '/', '   '),
                      DECODE (ela_v.stato, 'E', REPLACE (ela_v.cognome_nome, '/', '   '),
                         DECODE (ela_f.stato, 'E', REPLACE (ela_f.cognome_nome, '/', '   '),
                           REPLACE (ele.cognome_nome, '/', '   ')))))))),
--            || DECODE ( DECODE (ele.stato, 'E', ele.sesso,
--                          DECODE (ela_b.stato, 'E', ela_b.sesso,
--                            DECODE (ela_c.stato, 'E', ela_c.sesso,
--                              DECODE (ela_e.stato, 'E', ela_e.sesso,
--                                DECODE (ela_t.stato, 'E', ela_t.sesso,
--                                  DECODE (ela_t.stato, 'E', ela_t.sesso,
--                                    DECODE (ela_f.stato, 'E', ela_f.sesso,
--                                      ele.sesso))))))),
--                  'M', ' ',
--                  'F', DECODE (ana.stato_civile,
--                         'CN', ' in '|| SUBSTR (ana.cognome_nome_cn,1,INSTR (ana.cognome_nome_cn, '/') - 1),
--                         'VE', ' Ved. '|| SUBSTR (ana.cognome_nome_cn,1,INSTR (ana.cognome_nome_cn, '/') - 1)),
--                               ' '),
-- cognome_ele
            DECODE (ele.stato, 'E', SUBSTR (ele.cognome_nome,1,INSTR (ele.cognome_nome, '/') - 1),
              DECODE (ela_b.stato, 'E', SUBSTR (ela_b.cognome_nome,1,INSTR (ela_b.cognome_nome, '/') - 1),
                DECODE (ela_c.stato, 'E', SUBSTR (ela_c.cognome_nome,1,INSTR (ela_c.cognome_nome, '/') - 1),
                  DECODE (ela_e.stato, 'E', SUBSTR (ela_e.cognome_nome,1,INSTR (ela_e.cognome_nome, '/') - 1),
                    DECODE (ela_t.stato, 'E', SUBSTR (ela_t.cognome_nome,1,INSTR (ela_t.cognome_nome, '/') - 1),
                      DECODE (ela_v.stato, 'E', SUBSTR (ela_v.cognome_nome,1,INSTR (ela_v.cognome_nome, '/') - 1),
                        DECODE (ela_v.stato, 'E', SUBSTR (ela_f.cognome_nome,1,INSTR (ela_f.cognome_nome, '/') - 1),
                          SUBSTR (ele.cognome_nome,1,INSTR (ele.cognome_nome, '/') - 1)))))))),
--            || DECODE ( DECODE (ele.stato, 'E', ele.sesso,
--                          DECODE (ela_b.stato, 'E', ela_b.sesso,
--                            DECODE (ela_c.stato, 'E', ela_c.sesso,
--                              DECODE (ela_e.stato, 'E', ela_e.sesso,
--                                DECODE (ela_t.stato, 'E', ela_t.sesso,
--                                  DECODE (ela_t.stato, 'E', ela_t.sesso,
--                                    DECODE (ela_f.stato, 'E', ela_f.sesso,
--                                      ele.sesso))))))),
--                 'M', ' ',
--                 'F', DECODE (ana.stato_civile,
--                        'CN', ' in '|| SUBSTR (ana.cognome_nome_cn,1,INSTR (ana.cognome_nome_cn, '/') - 1),
--                        'VE', ' Ved. '|| SUBSTR (ana.cognome_nome_cn,1,INSTR (ana.cognome_nome_cn, '/') - 1)),
--                              ' '),
-- nome_ele
            DECODE (ele.stato, 'E', SUBSTR (ele.cognome_nome,INSTR (ele.cognome_nome, '/') + 1),
              DECODE (ela_b.stato, 'E', SUBSTR (ela_b.cognome_nome,INSTR (ela_b.cognome_nome, '/') + 1),
                DECODE (ela_c.stato, 'E', SUBSTR (ela_c.cognome_nome,INSTR (ela_c.cognome_nome, '/') + 1),
                  DECODE (ela_e.stato, 'E', SUBSTR (ela_c.cognome_nome,INSTR (ela_c.cognome_nome, '/') + 1),
                    DECODE (ela_t.stato, 'E', SUBSTR (ela_t.cognome_nome,INSTR (ela_t.cognome_nome, '/') + 1),
                      DECODE (ela_v.stato, 'E', SUBSTR (ela_v.cognome_nome,INSTR (ela_v.cognome_nome, '/') + 1),
                        DECODE (ela_f.stato, 'E', SUBSTR (ela_f.cognome_nome,INSTR (ela_f.cognome_nome, '/') + 1),
                          SUBSTR (ele.cognome_nome,INSTR (ele.cognome_nome, '/') + 1)))))))),
-- sesso
            DECODE (ana.sesso, 'M', 'maschile', 'femminile'),
-- stato_civile
            dsc.descrizione_cer,
-- stato_civile_cdi
            dsc.descrizione_cdi,
-- stampa_stato_civile_cdi
            dcn.stampa_sc,
-- nat_oa
            DECODE (ana.sesso, 'M', 'nato', 'nata'),
-- cittadino_italiano
            DECODE (
               ana.nazionalita,
               'I',
               DECODE (ana.sesso,
                       'M', 'CITTADINO ITALIANO',
                       'CITTADINA ITALIANA'),
               ''
            ),
-- cittadinanza
            dci.descrizione,
-- inizio_cittadinanza
            DECODE (
               ana.data_inizio_naz,
               NULL,
               '',
               'dal '
               || TO_CHAR (TO_DATE (ana.data_inizio_naz, 'j'), 'dd/mm/yyyy')
            ),
-- paternita
            'pt. ' || REPLACE (ana.paternita, '/', '   '),
-- maternita
            'mt. ' || REPLACE (ana.maternita, '/', '   '),
-- indirizzo
            DECODE (
               fam.fascia,
               6,
               fam.via_res,
               DECODE (
                  fam.cod_via,
                  '',
                  DECODE (fam.via_aire, '', '', fam.via_aire),
                  DECODE (
                     vie.denom_uff,
                     '',
                     '',
                     vie.denom_uff || fam.civico_esterno
                     || DECODE (UPPER (inp.valore),
                                'N', '',
                                fam.civico_interno)
                  )
               )
            ),
-- indirizzo_int
            DECODE (
               fam.cod_via,
               '',
               DECODE (fam.via_aire, '', '', fam.via_aire),
               DECODE (
                  vie.denom_uff,
                  '',
                  '',
                     vie.denom_uff
                  || fam.civico_esterno
                  || fam.civico_interno
               )
            ),
-- inizio_indirizzo
            DECODE (
               ana.fascia,
               1,
               DECODE (
                  ana.data_inizio_res,
                  ana.data_nas,
                  'dalla nascita',
                  'dal '
                  || TO_CHAR (TO_DATE (ana.data_inizio_res, 'j'),
                              'dd/mm/yyyy')
               ),
               3,
               'dal '
               || TO_CHAR (TO_DATE (ana.data_inizio_res, 'j'), 'dd/mm/yyyy'),
               ''
            ),
-- residenza
            DECODE (ana.fascia,
                    6, nvl(a1.descrizione_al1,a1.descrizione),
                    3, nvl(h.descrizione_al1,h.descrizione),
                    4, nvl(h.descrizione_al1,h.descrizione),
                       nvl(a.descrizione_al1,a.descrizione)),
-- inizio_residenza
            DECODE (
               ana.fascia,
               1,
               DECODE (
                  ana.stato,
                  1,
                  'dalla nascita',
                  'dal '
                  || TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
               ),
               3,
               'dal '
               || TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
               ''
            ),
-- via_aire
            fam.via_aire,
-- comune_aire
--       h.descrizione||decode(h.sigla_provincia,'','',' ('||h.sigla_provincia||')'),
            RTRIM (   nvl(h.descrizione_al1,h.descrizione)
                   || ' '
                   || f_provincia_stato (h.cod_provincia,
                                         h.cod_comune,
                                         h.sigla_provincia,
                                         'S',
                                         'S')),
-- stato_aire
            DECODE (fam.cod_pro_aire, 199, '', 999, '', q.descrizione),
-- zipcode
            fam.zipcode,
-- provincia_contea
            fam.provincia_contea,
-- presso
            fam.presso,
-- tipo_consolato
            adco.descrizione,
-- indirizzo_consolato
            con.indirizzo,
-- sede_consolato
            con.sede,
-- titolo_studio
            dts.descrizione,
-- professione
            DECODE (
               ana.pensionato,
               1,
               NVL (dpr.descrizione,
                    DECODE (ana.sesso, 'M', 'PENSIONATO', 'PENSIONATA')),
               dpr.descrizione
            ),
-- professione_cdi
            dcn.professione,
-- data_nascita
            DECODE (
               ana.anno_nas,
               'S',
               '00/00/' || TO_CHAR (TO_DATE (ana.data_nas, 'j'), 'yyyy'),
               TO_CHAR (TO_DATE (ana.data_nas, 'j'), 'dd/mm/yyyy')
            ),
-- comune_nascita
--         b.descrizione||' ('||b.sigla_provincia||')',
            RTRIM (   nvl(b.descrizione_al1,b.descrizione)
                   || ' '
                   || f_provincia_stato_CER (b.cod_provincia,
                                             b.cod_comune,
                                             b.sigla_provincia,
                                             'S',
                                             'S',
                                             ana.data_nas)),
-- comune_atto_nascita
            DECODE (
               nvl(b1.descrizione_al1,b1.descrizione),
               '',
               '',
               '- ' || nvl(b1.descrizione_al1,b1.descrizione) ||f_provincia_stato_CER (b1.cod_provincia,
                                             b1.cod_comune,
                                             b1.sigla_provincia,
                                             'S',
                                             'S',
                                             ana.data_nas)
            ),
-- cap_comune_atto_nascita
            lpad(b1.cap,5,'0'),
   -- atto_nascita
       decode(ana.atto_nas_digitale,'',
               'atto N. '
            || ana.atto_nas
            || DECODE (ana.parte_nas,
                       1,
                       ' p. I',
                       2,
                       ' p. II')
            || DECODE (ana.serie_nas, '', '', ' s. ' || ana.serie_nas)
            || DECODE (ana.ufficio_nas,
                       0, '',
                       '', '',
                       ' uff. ' || ana.ufficio_nas)
            || DECODE (ana.anno_atto_nas,
                       '', '',
                       ' / ' || ana.anno_atto_nas),
               'atto digitale N. '||ana.atto_nas_digitale),
-- coniugat_oa
            decode(ana.stato_civile,
              'CN', DECODE (ana.sesso, 'M', 'coniugato', 'coniugata'),
              'UC', DECODE (ana.sesso, 'M', 'unito civilmente', 'unita civilmente'),
              ''),
-- cognome_nome_coniuge
            case
              when ana.stato_civile in ('CN','VE','UC','VU') then
                   REPLACE (ana.cognome_nome_cn, '/', '   ')
            end,
-- cognome_coniuge
            case
              when ana.stato_civile in ('CN','VE','UC','VU') then
                   SUBSTR (ana.cognome_nome_cn, 1, INSTR (ana.cognome_nome_cn, '/') - 1)
            end,
-- nome_coniuge
            case
              when ana.stato_civile in ('CN','VE','UC','VU') then
                   SUBSTR (ana.cognome_nome_cn, INSTR (ana.cognome_nome_cn, '/') + 1)
            end,
-- cognome_nome_coniuge_cn
            case
              when ana.stato_civile in ('CN','UC') then
                   REPLACE (ana.cognome_nome_cn, '/', '   ')
            end,
-- cognome_coniuge_cn
            case
              when ana.stato_civile in ('CN','UC') then
                   SUBSTR (ana.cognome_nome_cn, 1, INSTR (ana.cognome_nome_cn, '/') - 1)
            end,
-- nome_coniuge_cn
            case
              when ana.stato_civile in ('CN','UC') then
                   SUBSTR (ana.cognome_nome_cn, INSTR (ana.cognome_nome_cn, '/') + 1)
            end,
-- estremi_nascita_coniuge
            DECODE (ana_cn.matricola, '', '',
               case
                 when ana.stato_civile in ('CN','VE','UC','VU') then
                      DECODE (ana_cn.sesso, 'M', 'nato il ', 'nata il ')||
                      DECODE (ana_cn.anno_nas, 'S', '00/00/'|| TO_CHAR (TO_DATE (ana_cn.data_nas, 'j'), 'yyyy'),
                        TO_CHAR (TO_DATE (ana_cn.data_nas, 'j'), 'dd/mm/yyyy'))||
                      ' a '||RTRIM(nvl(com_nas_cn.descrizione_al1,com_nas_cn.descrizione)||
                      ' '||f_provincia_stato_CER (com_nas_cn.cod_provincia,com_nas_cn.cod_comune,com_nas_Cn.sigla_provincia,'S','S',ana_cn.data_nas))
               end),
-- estremi_nascita_coniuge_cn
            DECODE (ana_cn.fascia, 1,
               case
                 when ana.stato_civile in ('CN','UC') then
                      DECODE (ana_cn.sesso, 'M', 'nato il ', 'nata il ')||
                      DECODE (ana_cn.anno_nas,'S','00/00/'||TO_CHAR (TO_DATE (ana_cn.data_nas, 'j'), 'yyyy'),
                        TO_CHAR (TO_DATE (ana_cn.data_nas, 'j'), 'dd/mm/yyyy'))||
                      ' a '||RTRIM(nvl(com_nas_cn.descrizione_al1,com_nas_cn.descrizione)||
                      ' '||f_provincia_stato_CER (com_nas_cn.cod_provincia,com_nas_cn.cod_comune,com_nas_cn.sigla_provincia,'S','S',ana_cn.data_nas))
               end),
-- atto_nascita_coniuge
            DECODE (ana_cn.matricola, '', '',
               case
                 when ana.stato_civile in ('CN','VE','UC','VU') then
                      decode(ana_cn.atto_nas_digitale,'',
                        'atto N. '||ana_cn.atto_nas||
                          DECODE (ana_cn.parte_nas,1,' p. I',2,' p. II')||
                          DECODE (ana_cn.serie_nas,'', '',' s. ' || ana_cn.serie_nas)||
                          DECODE (ana_cn.ufficio_nas,0, '','', '',' uff. ' || ana_cn.ufficio_nas)||
                          DECODE (ana_cn.anno_atto_nas,'', '',' / ' || ana_cn.anno_atto_nas),
                        'atto digitale N. '||ana_cn.atto_nas_digitale)
               end),
-- indirizzo_coniuge
            DECODE (ana_cn.fascia, 1, 'abitante in '|| vie_cn.denom_uff|| fam_cn.civico_esterno|| DECODE (UPPER (inp.valore), 'N', '', fam_cn.civico_interno)),
-- residenza_coniuge
            DECODE (ana_cn.fascia, 1, 'Residente a ' || nvl(a.descrizione_al1,a.descrizione), ''),
-- inizio_residenza_coniuge
            DECODE (ana_cn.fascia, 1,
              DECODE (ana_cn.stato, '', '', 1, 'dalla nascita', 'dal '|| TO_CHAR (TO_DATE (ana_cn.data_ult_eve, 'j'), 'dd/mm/yyyy'))),
-- data_morte_coniuge
            DECODE (ana.data_ved, '', '', 'il ' || TO_CHAR (TO_DATE (ana.data_ved, 'j'), 'dd/mm/yyyy')),
-- estremi_mat_ved
            case
              when ana.stato_civile in ('CN','UC') then
                   'il '||DECODE (ana.anno_mat,'S','00/00/'|| TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'yyyy'),
                            TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'dd/mm/yyyy'))||
                   ' a '||RTRIM(nvl(c.descrizione_al1,c.descrizione)||
                   ' '||f_provincia_stato (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'))
              when ana.stato_civile in ('VE','VU') then
                    'dal '||TO_CHAR (TO_DATE (ana.data_ved, 'j'), 'dd/mm/yyyy')||
                    ' a '||RTRIM(nvl(d.descrizione_al1,d.descrizione)||
                    ' '||f_provincia_stato (d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S'))
            end,
-- atto_mat_ved
            case
              when ana.stato_civile in ('CN','UC') then
                   decode(ana.atto_mat_digitale,'',
                     'atto N. '|| ana.atto_mat||
                       DECODE (ana.parte_mat,1,' p. I',2,' p. II')||
                       DECODE (ana.serie_mat, '', '', ' s. ' || ana.serie_mat)||
                       DECODE (ana.ufficio_mat,0, '','', '',' uff. ' || ana.ufficio_mat)||
                       DECODE (ana.anno_atto_mat,'', '',' / ' || ana.anno_atto_mat),
                     'atto digitale N. '|| ana.atto_mat_digitale)
              when ana.stato_civile in ('VE','VU') then
                   decode(ana.atto_ved_digitale,'',
                     'atto N. '|| ana.atto_ved||
                       DECODE (ana.parte_ved,1,' p. I',2,' p. II')||
                       DECODE (ana.serie_ved, '', '', ' s. ' || ana.serie_ved)||
                       DECODE (ana.ufficio_ved,0, '','', '',' uff. ' || ana.ufficio_ved)||
                       DECODE (ana.anno_atto_ved,'', '',' / ' || ana.anno_atto_ved),
                     'atto digitale N. '|| ana.atto_ved_digitale)
            end,
-- data_matrimonio
            DECODE (ana.data_mat,'','',
              'il '||DECODE (ana.anno_mat,'S','00/00/'|| TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'yyyy'),
                       TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'dd/mm/yyyy'))),
-- comune_matrimonio
            DECODE (c.descrizione,
                    '', '',
                    'a '
                    || --  c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')')),
                      RTRIM (   nvl(c.descrizione_al1,c.descrizione)
                             || ' '
                             || f_provincia_stato (c.cod_provincia,
                                                   c.cod_comune,
                                                   c.sigla_provincia,
                                                   'S',
                                                   'S'))),
-- comune_atto_matrimonio
            DECODE (c1.descrizione, '', '',
              nvl(c1.descrizione_al1,c1.descrizione) || ' (' || c1.sigla_provincia || ')'),
-- cap_comune_atto_matrimonio
            lpad(c1.cap,5,'0'),
-- atto_matrimonio
             DECODE (nvl(ana.atto_mat_digitale,ana.atto_mat), '', '',
               decode(ana.atto_mat_digitale,'',
                 'atto N. ' || ana.atto_mat||
                    DECODE(ana.parte_mat,1,' p. I',2,' p. II')||
                    DECODE (ana.serie_mat, '', '', ' s. ' || ana.serie_mat)||
                    DECODE (ana.ufficio_mat,0, '','', '',' uff. ' || ana.ufficio_mat)||
                    DECODE (ana.anno_atto_mat,'', '',' / ' || ana.anno_atto_mat),
                 'atto digitale N. ' || ana.atto_mat_digitale)),
-- data_vedovanza
            DECODE (ana.data_ved, '', '',
              'dal ' || TO_CHAR (TO_DATE (ana.data_ved, 'j'), 'dd/mm/yyyy')),
-- comune_vedovanza
            DECODE (d.descrizione, '', '',
              'a '||RTRIM(nvl(d.descrizione_al1,d.descrizione)||
              ' '||f_provincia_stato (d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S'))),
-- comune_atto_vedovanza
            DECODE (d1.descrizione, '', '',
              nvl(d1.descrizione_al1,d1.descrizione) || ' (' || d1.sigla_provincia || ')'),
-- cap_comune_atto_vedovanza,
            lpad(d1.cap,5,'0'),
-- atto_vedovanza
            DECODE (nvl(ana.atto_ved_digitale,ana.atto_ved), '', '',
              decode(ana.atto_ved_digitale,'',
                'atto N. ' || ana.atto_ved||
                  DECODE (ana.parte_ved,1,' p. I',2,' p. II')||
                  DECODE (ana.serie_ved, '', '', ' s. ' || ana.serie_ved)||
                  DECODE (ana.ufficio_ved,0, '','', '',' uff. ' || ana.ufficio_ved)||
                  DECODE (ana.anno_atto_ved, '', '',' / ' || ana.anno_atto_ved),
                'atto digitale N. ' || ana.atto_ved_digitale)),
-- cognome_nome_cv
            replace(ana_cv.cognome_nome, '/', '   '),
-- cognome_cv
            SUBSTR(ana_cv.cognome_nome, 1, INSTR(ana_cv.cognome_nome,'/') - 1),
-- nome_cv
            SUBSTR(ana_cv.cognome_nome, INSTR(ana_cv.cognome_nome,'/') + 1),
-- estremi_nascita_cv
            DECODE(ana_cv.matricola, '', '',
              DECODE(ana_cv.sesso, 'M', 'nato il ', 'nata il ')||
              DECODE(ana_cv.anno_nas, 'S', '00/00/'||TO_CHAR (TO_DATE (ana_cv.data_nas, 'j'), 'yyyy'),
                                           TO_CHAR (TO_DATE (ana_cv.data_nas, 'j'), 'dd/mm/yyyy'))||
              ' a '||RTRIM (nvl(com_nas_cv.descrizione_al1,com_nas_cv.descrizione)||' '||
                            f_provincia_stato_CER (com_nas_cv.cod_provincia,com_nas_cv.cod_comune,com_nas_cv.sigla_provincia,'S','S',ana_cv.data_nas))),
-- atto_nascita_cv
            DECODE(ana_cv.matricola, '', '',
                decode(ana_cv.atto_nas_digitale,'',
                  DECODE(ana_cv.atto_nas, '', '','atto N. '||ana_cv.atto_nas)||
                    DECODE(ana_cv.parte_nas, 1, ' p. I', 2, ' p. II')||
                    DECODE(ana_cv.serie_nas, '', '',' s. '||ana_cv.serie_nas)||
                    DECODE(ana_cv.ufficio_nas, 0, '', '', '', ' uff. '||ana_cv.ufficio_nas)||
                    DECODE(ana_cv.anno_atto_nas, '', '', ' / '||ana_cv.anno_atto_nas),
                  'atto digitale N. '||ana_cv.atto_nas_digitale)),
-- codice_fiscale_cv
            ana_cv.cod_fiscale,
-- data_inizio_cdf
            TO_CHAR(TO_DATE(cdf.data_inizio, 'j'), 'dd/mm/yyyy'),
-- comune_inizio_cdf
            DECODE(com_ini_cdf.descrizione, '', '',
              nvl(com_ini_cdf.descrizione_al1,com_ini_cdf.descrizione)||' ('||com_ini_cdf.sigla_provincia||')'),
-- pratica_inizio_cdf
              cdf.pratica_inizio||decode(cdf.anno_pratica_inizio,'','','/'||cdf.anno_pratica_inizio),
-- data_fine_Cdf
            TO_CHAR(TO_DATE(cdf.data_fine, 'j'), 'dd/mm/yyyy'),
-- comune_fine_cdf
            DECODE(com_fin_cdf.descrizione, '', '',
              nvl(com_fin_cdf.descrizione_al1,com_fin_cdf.descrizione)||' ('||com_fin_cdf.sigla_provincia||')'),
-- pratica_fine_cdf
            cdf.pratica_fine||decode(cdf.anno_pratica_fine,'','','/'||cdf.anno_pratica_fine),
-- contratto_convivenza
            decode(f_flag_CDF(ana.matricola), '', '', f_CDF_contratto_convivenza(ana.matricola)),
-- decedut_oa
            DECODE (ana.stato,
                    50, DECODE (ana.sesso, 'M', 'deceduto', 'deceduta'),
                    ''),
-- mort_oa
            DECODE (ana.stato,
                    50, DECODE (ana.sesso, 'M', 'morto', 'morta'),
                    ''),
-- data_morte
            DECODE (
               ana.data_mor,
               '',
               '',
               'il ' || TO_CHAR (TO_DATE (ana.data_mor, 'j'), 'dd/mm/yyyy')
            ),
-- comune_morte
            DECODE (f.descrizione,
                    '', '',
                    'a '
                    || --  f.descrizione||decode(f.sigla_provincia,'','',' ('||f.sigla_provincia||')')),
                      RTRIM (   nvl(f.descrizione_al1,f.descrizione)
                             || ' '
                             || f_provincia_stato (f.cod_provincia,
                                                   f.cod_comune,
                                                   f.sigla_provincia,
                                                   'S',
                                                   'S'))),
-- comune_atto_morte
            DECODE (f1.descrizione,
                    '', '',
                    nvl(f1.descrizione_al1,f1.descrizione) || ' (' || f1.sigla_provincia || ')'),
-- cap_comune_atto_morte
            lpad(f1.cap,5,'0'),
-- atto_morte
       decode(ana.atto_mor_digitale,'',
         DECODE (ana.atto_mor, '', '', 'atto N. ' || ana.atto_mor)
            || DECODE (ana.parte_mor,
                       1,
                       ' p. I',
                       2,
                       ' p. II')
            || DECODE (ana.serie_mor, '', '', ' s. ' || ana.serie_mor)
            || DECODE (ana.ufficio_mor,
                       0, '',
                       '', '',
                       ' uff. ' || ana.ufficio_mor)
            || DECODE (ana.anno_atto_mor,
                       '', '',
                       ' / ' || ana.anno_atto_mor),
         'atto digitale N. '||ana.atto_mor_digitale),
-- codice_fiscale
            DECODE (
               ana.cod_fiscale,
               NULL,
               '',
               ana.cod_fiscale
               || DECODE (ana.cf_calcolato,
                          'S', ' (non validato)',
                          ' (validato)')
            ),
-- codice_fiscale_validato
            DECODE (ana.cf_calcolato, 'S', TO_CHAR (NULL), ana.cod_fiscale),
            ana.cod_fam,
-- anno_censimento
            ana.anno_cens,
-- sezione_censimento
            ana.sezione_cens,
-- foglio_censimento
            ana.foglio_cens,
-- questionario_censimento
            ana.questionario_cens,
-- intestatario_convivenza
            NVL (fam.convivenza, fam.intestatario),
-- estremi_ultimo_evento
            DECODE (
               g.cod_provincia,
               0,
               nvl(g.descrizione_al1,g.descrizione),
               DECODE (
                  ana.stato,
                  1,
                  'Residente a '
                  || DECODE (ana.fascia,
                             1, nvl(a.descrizione_al1,a.descrizione),
                             3, nvl(h.descrizione_al1,h.descrizione),
                             '')
                  || ' dalla nascita',
                  2,
                  DECODE (ana.sesso,
                          'M', 'Immigrato il ',
                          'F', 'Immigrata il ',
                          ''),
                  3,
                  DECODE (ana.sesso,
                          'M', 'Reimmigrato il ',
                          'F', 'Reimmigrata il ',
                          ''),
                  4,
                  DECODE (ana.sesso,
                          'M', 'Reimmigrato il ',
                          'F', 'Reimmigrata il ',
                          ''),
                  5,
                  DECODE (ana.sesso,
                          'M', 'Iscritto d''ufficio il ',
                          'F', 'Iscritta d''ufficio il ',
                          ''),
                  6,
                  DECODE (ana.sesso,
                          'M', 'Iscritto d''ufficio A.I.R.E. il ',
                          'F', 'Iscritta d''ufficio A.I.R.E. il ',
                          ''),
                  7,
                  DECODE (ana.sesso,
                          'M', 'Trasferito A.I.R.E. il ',
                          'F', 'Trasferita A.I.R.E. il ',
                          ''),
                  8,
                  DECODE (ana.sesso,
                          'M', 'Acquisto cittadinanza italiana il ',
                          'F', 'Acquisto cittadinanza italiana il ',
                          ''),
                  52,
                  DECODE (ana.sesso,
                          'M', 'Emigrato all''A.I.R.E. il ',
                          'F', 'Emigrata all''A.I.R.E. il ',
                          ''),
                  50,
                  DECODE (ana.sesso,
                          'M', 'Deceduto il ',
                          'F', 'Deceduta il ',
                          ''),
                  51,
                  DECODE (ana.sesso,
                          'M', 'Emigrato il ',
                          'F', 'Emigrata il ',
                          ''),
                  53,
                     'Irreperibile '
                  || DECODE (eve.cod_variazione, 'C', 'al Censimento ', '')
                  || 'dal ',
                  54,
                  'Irreperibile dal ',
                  55,
                  DECODE (ana.sesso,
                          'M', 'Rimpatriato il ',
                          'F', 'Rimpatriata il ',
                          ''),
                  56,
                  'Trasferimento A.I.R.E. il ',
                  9,
                  DECODE (
                     ana.sesso,
                     'M',
                        'Reiscritto'
                     || DECODE (ana.fascia, 3, ' A.I.R.E. ', ' ')
                     || 'da Irreperibilita'' '
                     || DECODE (
                           nvl(g.descrizione_al1,g.descrizione),
                           '',
                           '',
                           'di '
                           || --               g.descrizione||' ('||g.sigla_provincia||') ')||
                             RTRIM (   nvl(g.descrizione_al1,g.descrizione)
                                    || ' '
                                    || f_provincia_stato (g.cod_provincia,
                                                          g.cod_comune,
                                                          g.sigla_provincia,
                                                          'S',
                                                          'S'))
                        )
                     || 'il ',
                     'F',
                        'Reiscritta'
                     || DECODE (ana.fascia, 3, ' A.I.R.E. ', ' ')
                     || 'da Irreperibilita'' '
                     || DECODE (
                           g.descrizione,
                           '',
                           '',
                           'di '
                           || --               g.descrizione||' ('||g.sigla_provincia||') ')||
                             RTRIM (   nvl(g.descrizione_al1,g.descrizione)
                                    || ' '
                                    || f_provincia_stato (g.cod_provincia,
                                                          g.cod_comune,
                                                          g.sigla_provincia,
                                                          'S',
                                                          'S'))
                        )
                     || 'il ',
                     ''
                  ),
                  58,
                  DECODE (ana.sesso,
                          'M', 'Cancellato per Doppia Iscrizione il ',
                          'F', 'Cancellata per Doppia Iscrizione il ',
                          ''),
                  59,
                  DECODE (ana.sesso,
                          'M', 'Cancellato d''Ufficio il ',
                          'F', 'Cancellata d''Ufficio il ',
                          ''),
                  10,
                  DECODE (ana.sesso,
                          'M',
                          'Iscritto A.I.R.E. per Residenza all''Estero il ',
                          'F',
                          'Iscritta A.I.R.E. per Residenza all''Estero il ',
                          ''),
                  11,
                  DECODE (
                     ana.sesso,
                     'M',
                     'Reiscritto da cancellazione per mancato rinnovo del Permesso di Soggiorno il ',
                     'F',
                     'Reiscritta da cancellazione per mancato rinnovo del Permesso di Soggiorno il ',
                     ''
                  ),
                  60,
                  DECODE (
                     ana.sesso,
                     'M',
                     'Cancellato per mancato rinnovo del Permesso di Soggiorno il ',
                     'F',
                     'Cancellata per mancato rinnovo del Permesso di Soggiorno il ',
                     ''
                  ),
                  61,
                  DECODE (
                     ana.sesso,
                     'M',
                     'Cancellato per Trasferimento in altro Comune Italiano il ',
                     'F',
                     'Cancellata per Trasferimento in altro Comune Italiano il ',
                     ''
                  ),
                  17,
                  'Iscrizione Preliminare il ',
                  ''
               )
               || DECODE (
                     ana.stato,
                     2,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' da ',
                     3,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' da ',
                     4,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' da ',
                     5,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     6,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     7,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' da ',
                     8,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     52,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' a ',
                     50,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' a ',
                     51,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' a ',
                     53,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     54,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     55,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' a ',
                     56,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' all''A.I.R.E. di ',
                     9,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     58,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     59,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     10,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     11,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                     || ' ',
                     60,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     61,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                     17,
                     TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' ',
                     ' '
                  )
               || DECODE (
                     ana.stato,
                     9,
                     TO_CHAR (NULL),
                     50,
                     DECODE (f.descrizione,
                             '', '',
                 --             f.descrizione||decode(f.sigla_provincia,'','',' ('||f.sigla_provincia||')')),
                             RTRIM (   nvl(f.descrizione_al1,f.descrizione)
                                    || ' '
                                    || f_provincia_stato (f.cod_provincia,
                                                          f.cod_comune,
                                                          f.sigla_provincia,
                                                          'S',
                                                          'S'))),
                     DECODE (g.descrizione,
                             '', '',
                 --             g.descrizione||decode(g.sigla_provincia,'','',' ('||g.sigla_provincia||')')))),
                             RTRIM (   nvl(g.descrizione_al1,g.descrizione)
                                    || ' '
                                    || f_provincia_stato (g.cod_provincia,
                                                          g.cod_comune,
                                                          g.sigla_provincia,
                                                          'S',
                                                          'S')))
                  )
            ),
-- pratica_ultimo_evento
       DECODE(ana.stato,
         50, decode(ana.atto_mor_digitale,'',
               DECODE(ana.atto_mor,'','','atto N. '||ana.atto_mor||
                 DECODE(ana.parte_mor,1,' p. I',2,' p. II')||
                 DECODE(ana.serie_mor,'', '',' s. ' || ana.serie_mor)||
                 DECODE(ana.ufficio_mor,'', '',' uff. ' || ana.ufficio_mor)||' / '||ana.anno_atto_mor),
               'atto digitale N. '||ana.atto_mor_digitale),
             DECODE(eve.pratica,'','','Pratica N. ' || eve.pratica || '/' || eve.anno_pratica)),
-- data_ultimo_evento
            TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
-- data_ricomparsa
            decode(eve.data_ric,null,'',decode(ana.sesso,'M','ricomparso il ','ricomparsa il ')||
                                                TO_CHAR (TO_DATE (eve.data_ric, 'j'), 'dd/mm/yyyy')),
-- comune_ricomparsa
            DECODE (p.descrizione,
                    '', '',
                    'a '||RTRIM (   nvl(p.descrizione_al1,p.descrizione)
                           || ' '
                           || f_provincia_stato (p.cod_provincia,
                                                 p.cod_comune,
                                                 p.sigla_provincia,
                                                 'S',
                                                 'S'))),
-- pratica_ricomparsa
            DECODE (
               eve.pratica_ric,
               '',
               '',
                  'Pratica N. '
               || eve.pratica_ric
               || '/'
               || eve.anno_pratica_ric
            ),
-- indirizzo_precedente
            DECODE (
               eve_11.cod_via,
               '',
               '',
                  vie_11.denom_uff
               || eve_11.civico_esterno
               || DECODE (UPPER (inp.valore), 'N', '', eve_11.civico_interno)
            ),
-- iscritto_oa
            DECODE (ana.sesso, 'M', 'iscritto', 'iscritta'),
-- incorso_oa
            DECODE (ana.sesso, 'M', 'incorso', 'incorsa'),
-- sottoscritt_oa
            DECODE (ana.sesso, 'M', 'Il sottoscritto', 'La sottoscritta'),
-- diritti_politici
            DECODE (ele.stato, 'E', 'di godere dei diritti politici',
              DECODE (ela_b.stato,'E', 'di godere dei diritti politici',
                DECODE (ela_c.stato, 'E', 'di godere dei diritti politici',
                  DECODE (ela_e.stato, 'E', 'di godere dei diritti politici',
                    DECODE (ela_t.stato, 'E', 'di godere dei diritti politici',
                      DECODE (ela_v.stato, 'E', 'di godere dei diritti politici',
                        DECODE (ela_f.stato, 'E', 'di godere dei diritti politici'))))))),
-- sezione
--            ele.sezione,
            nvl(DECODE (ele.stato, 'E', ele.sezione,
                  DECODE (ela_b.stato,'E', ela_b.sezione,
                    DECODE (ela_c.stato, 'E', ela_c.sezione,
                      DECODE (ela_e.stato, 'E', ela_e.sezione,
                        DECODE (ela_t.stato, 'E', ela_t.sezione,
                          DECODE (ela_v.stato, 'E', ela_v.sezione,
                            DECODE (ela_f.stato, 'E', ela_f.sezione))))))),
                ele.sezione),
-- sede_sezione
-- dlr.descrizione
            nvl(DECODE (ele.stato, 'E', dlr.descrizione,
                  DECODE (ela_b.stato,'E', dlr_b.descrizione,
                    DECODE (ela_c.stato, 'E', dlr_c.descrizione,
                      DECODE (ela_e.stato, 'E', dlr_e.descrizione,
                        DECODE (ela_t.stato, 'E', dlr_t.descrizione,
                          DECODE (ela_v.stato, 'E', dlr_v.descrizione,
                            DECODE (ela_f.stato, 'E', dlr_f.descrizione))))))),
                dlr.descrizione),
-- indirizzo_sezione
--            dlr.indirizzo,
            nvl(DECODE (ele.stato, 'E', dlr.indirizzo,
                  DECODE (ela_b.stato,'E', dlr_b.indirizzo,
                    DECODE (ela_c.stato, 'E', dlr_c.indirizzo,
                      DECODE (ela_e.stato, 'E', dlr_e.indirizzo,
                        DECODE (ela_t.stato, 'E', dlr_t.indirizzo,
                          DECODE (ela_v.stato, 'E', dlr_v.indirizzo,
                            DECODE (ela_f.stato, 'E', dlr_f.indirizzo))))))),
                dlr.indirizzo),
-- progr_lista_generale
            nvl(DECODE (ele.stato, 'E', TO_CHAR (ele.progr_lista_gen),
              DECODE (ela_b.stato, 'E', ela_b.progr_lista_gen || ' (' || dtl_b.descrizione || ') ')
              || DECODE (ela_c.stato, 'E', ela_c.progr_lista_gen|| ' ('|| dtl_c.descrizione|| ') ')
              || DECODE (ela_e.stato, 'E', ela_e.progr_lista_gen|| ' ('|| dtl_e.descrizione|| ') ')
              || DECODE (ela_t.stato, 'E', ela_t.progr_lista_gen|| ' ('|| dtl_t.descrizione|| ') ')
              || DECODE (ela_v.stato, 'E', ela_v.progr_lista_gen|| ' ('|| dtl_v.descrizione|| ') ')
              || DECODE (ela_f.stato, 'E', ela_f.progr_lista_gen|| ' ('|| dtl_f.descrizione|| ') ')),
             TO_CHAR (ele.progr_lista_gen)),
-- progr_lista_sezionale
--            ele.progr_lista_sez,
            nvl(DECODE (ele.stato, 'E', TO_CHAR (ele.progr_lista_sez),
              DECODE (ela_b.stato, 'E', ela_b.progr_lista_sez || ' (' || dtl_b.descrizione || ') ')
              || DECODE (ela_c.stato, 'E', ela_c.progr_lista_sez|| ' ('|| dtl_c.descrizione|| ') ')
              || DECODE (ela_e.stato, 'E', ela_e.progr_lista_sez|| ' ('|| dtl_e.descrizione|| ') ')
              || DECODE (ela_t.stato, 'E', ela_t.progr_lista_sez|| ' ('|| dtl_t.descrizione|| ') ')
              || DECODE (ela_v.stato, 'E', ela_v.progr_lista_sez|| ' ('|| dtl_v.descrizione|| ') ')
              || DECODE (ela_f.stato, 'E', ela_f.progr_lista_sez|| ' ('|| dtl_f.descrizione|| ') ')),
            TO_CHAR (ele.progr_lista_sez)),
-- tessera_elettorale
--            ele.tessera_ele,
            tee.tessera,
-- data_tessera_elettorale
--            TO_CHAR (TO_DATE (ele.data_tessera_ele, 'j'), 'dd/mm/yyyy'),
            TO_CHAR (TO_DATE (tee.data_tessera, 'j'), 'dd/mm/yyyy'),
-- indirizzo_ele
            DECODE (
               vie_ele.denom_uff,
               '',
               '',
               vie_ele.denom_uff || ele.civico_esterno_ele
               || DECODE (UPPER (inp.valore),
                          'N', '',
                          ele.civico_interno_ele)
            ),
-- fascicolo_ele ele.fascicolo,
            nvl(DECODE (ele.stato,'E',TO_CHAR (ele.fascicolo),
                  DECODE (ela_b.stato,'E',ela_b.fascicolo|| ' (' || dtl_b.descrizione || ') ')
                  || DECODE (ela_c.stato,'E',ela_c.fascicolo|| ' (' || dtl_c.descrizione || ') ')
                  || DECODE (ela_e.stato,'E',ela_e.fascicolo|| ' (' || dtl_e.descrizione || ') ')
                  || DECODE (ela_t.stato,'E',ela_t.fascicolo|| ' (' || dtl_t.descrizione || ') ')
                  || DECODE (ela_v.stato,'E',ela_v.fascicolo|| ' (' || dtl_v.descrizione || ') ')
                  || DECODE (ela_f.stato,'E',ela_f.fascicolo|| ' (' || dtl_f.descrizione || ') ')),
               TO_CHAR (ele.fascicolo)),
-- verbale_ele  dsr.verbale,
            nvl(DECODE (ele.stato,'E',TO_CHAR (dsr.verbale),
                  DECODE (ela_b.stato,'E',dsr_b.verbale,
                    DECODE (ela_c.stato,'E',dsr_c.verbale,
                      DECODE (ela_e.stato,'E',dsr_e.verbale,
                        DECODE (ela_t.stato,'E',dsr_t.verbale,
                          DECODE (ela_v.stato,'E',dsr_v.verbale,
                            DECODE (ela_f.stato,'E',dsr_f.verbale))))))),
                TO_CHAR (dsr.verbale)),
-- data_verbale_ele TO_CHAR (TO_DATE (dsr.data_verbale, 'j'), 'dd/mm/yyyy'),
            TO_CHAR (TO_DATE (
            nvl(DECODE (ele.stato,'E',TO_CHAR (dsr.data_verbale),
                  DECODE (ela_b.stato,'E',dsr_b.data_verbale,
                    DECODE (ela_c.stato,'E',dsr_c.data_verbale,
                      DECODE (ela_e.stato,'E',dsr_e.data_verbale,
                        DECODE (ela_t.stato,'E',dsr_t.data_verbale,
                          DECODE (ela_v.stato,'E',dsr_v.data_verbale,
                            DECODE (ela_f.stato,'E',dsr_f.data_verbale))))))),
                TO_CHAR (dsr.data_verbale)) , 'j'), 'dd/mm/yyyy'),
-- iscrizione_aire
            DECODE (
               ana.stato,
               1,
               'Trascrizione atto di nascita',
               6,
               'Iscrizione d''Ufficio A.I.R.E.',
               7,
               'Trasferimento dall''A.I.R.E. del Comune di '
               || DECODE (g.descrizione,
                          '', '',
              --     g.descrizione||decode(g.sigla_provincia,'','',' ('||g.sigla_provincia||')')),
                          RTRIM (   nvl(g.descrizione_al1,g.descrizione)
                                 || ' '
                                 || f_provincia_stato (g.cod_provincia,
                                                       g.cod_comune,
                                                       g.sigla_provincia,
                                                       'S',
                                                       'S'))),
               8,
               'Acquisto cittadinanza italiana',
               9,
               'Iscrizione da irreperibilita''',
               10,
               'Residenza all''estero',
               52,
               'Trasferimento all''estero',
               ''
            ),
            ruo.classe,
            ruo.numero_lista,
            ruo.matricola_mil,
--        l.descrizione||decode(l.sigla_provincia,'','',' ('||l.sigla_provincia||')'),
            RTRIM (   l.descrizione
                   || ' '
                   || f_provincia_stato (l.cod_provincia,
                                         l.cod_comune,
                                         l.sigla_provincia,
                                         'S',
                                         'S')),
            DECODE (
               ruo.data_chi,
               '',
               '',
               'dal ' || TO_CHAR (TO_DATE (ruo.data_chi, 'j'), 'dd/mm/yyyy')
            )
            || DECODE (
                  ruo.data_con,
                  '',
                  '',
                  ' al '
                  || TO_CHAR (TO_DATE (ruo.data_con, 'j'), 'dd/mm/yyyy')
               ),
            dar.descrizione,
            dco.descrizione,
            SUBSTR (ruo.forza, 1, 50),
            SUBSTR (ruo.forza, 51, 50),
            SUBSTR (ruo.forza, 101, 50),
            dgr.descrizione,
---       i.descrizione||decode(i.sigla_provincia,'','',' ('||i.sigla_provincia||')'),
            RTRIM (   i.descrizione
                   || ' '
                   || f_provincia_stato (i.cod_provincia,
                                         i.cod_comune,
                                         i.sigla_provincia,
                                         'S',
                                         'S')),
            TO_CHAR (TO_DATE (ruo.data_arr, 'j'), 'dd/mm/yyyy'),
            TO_CHAR (TO_DATE (ruo.data_chi, 'j'), 'dd/mm/yyyy'),
            TO_CHAR (TO_DATE (ruo.data_con, 'j'), 'dd/mm/yyyy'),
            des.descrizione,
-- Carta di Identita'
-- numero_carta
            doc_CI.numero,
-- data_carta
            TO_CHAR (TO_DATE (doc_CI.data_emissione, 'j'), 'dd/mm/yyyy'),
-- comune_carta
--         m.descrizione||decode(m.sigla_provincia,'','',' ('||m.sigla_provincia||')'),
            RTRIM (   m.descrizione
                   || ' '
                   || f_provincia_stato (m.cod_provincia,
                                         m.cod_comune,
                                         m.sigla_provincia,
                                         'S',
                                         'S')),
-- scadenza_carta
            TO_CHAR (TO_DATE (doc_CI.data_scadenza, 'j'), 'dd/mm/yyyy'),
-- natura_carta
            doc_CI.natura_documento,
-- atto_nascita_cdi
            ana.atto_nas,
-- parte_nascita_cdi
            DECODE (ana.parte_nas,
                    1,
                    'I',
                    2,
                    'II'),
-- serie_nascita_cdi
            ana.serie_nas,
-- ufficio_nascita_cdi
            ana.ufficio_nas,
-- residenza_cdi
            DECODE (ana.fascia,
                    6, nvl(a1.descrizione_al1,a1.descrizione),
                    3, nvl(h.descrizione_al1,h.descrizione),
                    1, nvl(a.descrizione_al1,a.descrizione),
                    nvl(com_dcn.descrizione_al1,com_dcn.descrizione)),
-- indirizzo_cdi
            DECODE (
               fam.fascia,
               6,
               fam.via_res,
               3,
               fam.via_aire,
               1,
                  vie.denom_uff
               || fam.civico_esterno
               || DECODE (UPPER (inp.valore), 'N', '', fam.civico_interno),
               dcn.indirizzo_emi
            ),
-- statura_cdi
            dcn.statura,
-- capelli_cdi
            dcn.capelli,
-- occhi_cdi
            dcn.occhi,
-- segni_1_cdi
            NVL (dcn.segni_1, '-------------'),
-- segni_2_cdi
            dcn.segni_2,
-- segni_3_cdi
            dcn.segni_3,
-- espatrio_1_cdi
            DECODE (doc_CI.espatrio, 'S', '', 'NON VALIDA'),
-- espatrio_2_cdi
            DECODE (doc_CI.espatrio, 'S', '', 'PER L''ESTERO'),
-- Libretto di Lavoro
-- numero_libretto_lavoro
            doc_LL.numero,
-- data_libretto_lavoro
            TO_CHAR (TO_DATE (doc_LL.data_emissione, 'j'), 'dd/mm/yyyy'),
-- comune_libretto_lavoro
            n.descrizione
            || DECODE (n.sigla_provincia,
                       '', '',
                       ' (' || n.sigla_provincia || ')'),
-- Patente
-- numero_patente
            doc_PT.numero,
-- natura_patente
            DECODE (doc_PT.natura_documento,
                    'O', 'Originale',
                    'D', 'Duplicato',
                    'A', 'Annullato',
                    ''),
-- data_patente
            TO_CHAR (TO_DATE (doc_PT.data_emissione, 'j'), 'dd/mm/yyyy'),
-- comune_patente
            o.descrizione
            || DECODE (o.sigla_provincia,
                       '', '',
                       ' (' || o.sigla_provincia || ')'),
-- categoria_patente
            dca.descrizione,
-- Permesso di Soggiorno
            doc_PS.numero,
            DECODE (doc_PS.natura_documento,
                    'O', 'Originale',
                    'D', 'Duplicato',
                    'A', 'Annullato',
                    ''),
            TO_CHAR (TO_DATE (doc_PS.data_emissione, 'j'), 'dd/mm/yyyy'),
            r.descrizione
            || DECODE (r.sigla_provincia,
                       '', '',
                       ' (' || r.sigla_provincia || ')'),
            DECODE (
               doc_PS.flag_scadenza_illimitata,
               'S',
               'illimitata',
               TO_CHAR (TO_DATE (doc_PS.data_scadenza, 'j'), 'dd/mm/yyyy')
            ),
-- Carta di Soggiorno
            doc_CS.numero,
            DECODE (doc_CS.natura_documento,
                    'O', 'Originale',
                    'D', 'Duplicato',
                    'A', 'Annullato',
                    ''),
            TO_CHAR (TO_DATE (doc_CS.data_emissione, 'j'), 'dd/mm/yyyy'),
            s.descrizione
            || DECODE (s.sigla_provincia,
                       '', '',
                       ' (' || s.sigla_provincia || ')'),
            DECODE (
               doc_CS.flag_scadenza_illimitata,
               'S',
               'illimitata',
               TO_CHAR (TO_DATE (doc_CS.data_scadenza, 'j'), 'dd/mm/yyyy')
            ),
-- Attestazione Regolarit  Soggiorno (U1)
            doc_U1.numero,
            DECODE (doc_U1.natura_documento,
                    'O', 'Originale',
                    'D', 'Duplicato',
                    'A', 'Annullato',
                    ''),
            TO_CHAR (TO_DATE (doc_U1.data_emissione, 'j'), 'dd/mm/yyyy'),
            x.descrizione
            || DECODE (x.sigla_provincia,
                       '', '',
                       ' (' || x.sigla_provincia || ')'),
            DECODE (
               doc_U1.flag_scadenza_illimitata,
               'S',
               'illimitata',
               TO_CHAR (TO_DATE (doc_U1.data_scadenza, 'j'), 'dd/mm/yyyy')
            ),
-- Attestazione Soggiorno Permanente (U2)
            doc_U2.numero,
            DECODE (doc_U2.natura_documento,
                    'O', 'Originale',
                    'D', 'Duplicato',
                    'A', 'Annullato',
                    ''),
            TO_CHAR (TO_DATE (doc_U2.data_emissione, 'j'), 'dd/mm/yyyy'),
            y.descrizione
            || DECODE (y.sigla_provincia,
                       '', '',
                       ' (' || y.sigla_provincia || ')'),
            DECODE (
               doc_U2.flag_scadenza_illimitata,
               'S',
               'illimitata',
               TO_CHAR (TO_DATE (doc_U2.data_scadenza, 'j'), 'dd/mm/yyyy')
            ),
-- Carta di Identita Elettronica
-- numero_CIE
            doc_CE.numero,
-- natura_CIE
            DECODE (doc_CE.natura_documento,
                    'O', 'Originale',
                    'D', 'Duplicato',
                    'A', 'Annullato',
                    ''),
-- data_CIE
            TO_CHAR (TO_DATE (doc_CE.data_emissione, 'j'), 'dd/mm/yyyy'),
-- comune_CIE
            nvl(t.descrizione_al1,t.descrizione)
            || DECODE (t.sigla_provincia,
                       '', '',
                       ' (' || t.sigla_provincia || ')'),
-- scadenza_CIE
            TO_CHAR (TO_DATE (doc_CE.data_scadenza, 'j'), 'dd/mm/yyyy'),
-- Dato piu' recente tra CI e CE
-- numero_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI.data_emissione, 0)
                    - NVL (doc_CE.data_emissione, 0)),
               0,
               doc_CI.numero,
               1,
               doc_CI.numero,
               -1,
               doc_CE.numero
            ),
-- natura_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI.data_emissione, 0)
                    - NVL (doc_CE.data_emissione, 0)),
               0,
               DECODE (doc_CI.natura_documento,
                       'O', 'Originale',
                       'D', 'Duplicato',
                       'A', 'Annullato',
                       ''),
               1,
               DECODE (doc_CI.natura_documento,
                       'O', 'Originale',
                       'D', 'Duplicato',
                       'A', 'Annullato',
                       ''),
               -1,
               DECODE (doc_CE.natura_documento,
                       'O', 'Originale',
                       'D', 'Duplicato',
                       'A', 'Annullato',
                       '')
            ),
-- data_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI.data_emissione, 0)
                    - NVL (doc_CE.data_emissione, 0)),
               0,
               TO_CHAR (TO_DATE (doc_CI.data_emissione, 'j'), 'dd/mm/yyyy'),
               1,
               TO_CHAR (TO_DATE (doc_CI.data_emissione, 'j'), 'dd/mm/yyyy'),
               -1,
               TO_CHAR (TO_DATE (doc_CE.data_emissione, 'j'), 'dd/mm/yyyy')
            ),
-- comune_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI.data_emissione, 0)
                    - NVL (doc_CE.data_emissione, 0)),
               0,
               nvl(m.descrizione_al1,m.descrizione)
               || DECODE (m.sigla_provincia,
                          '', '',
                          ' (' || m.sigla_provincia || ')'),
               1,
               nvl(m.descrizione_al1,m.descrizione)
               || DECODE (m.sigla_provincia,
                          '', '',
                          ' (' || m.sigla_provincia || ')'),
               -1,
               nvl(t.descrizione_al1,t.descrizione)
               || DECODE (t.sigla_provincia,
                          '', '',
                          ' (' || t.sigla_provincia || ')')
            ),
-- scadenza_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI.data_scadenza, 0)
                    - NVL (doc_CE.data_scadenza, 0)),
               0,
               TO_CHAR (TO_DATE (doc_CI.data_scadenza, 'j'), 'dd/mm/yyyy'),
               1,
               TO_CHAR (TO_DATE (doc_CI.data_scadenza, 'j'), 'dd/mm/yyyy'),
               -1,
               TO_CHAR (TO_DATE (doc_CE.data_scadenza, 'j'), 'dd/mm/yyyy')
            ),
--
            DECODE (
               ana.fascia,
               6,
               a1.cap || ' ' || nvl(a1.descrizione_al1,a1.descrizione)
               || DECODE (a1.sigla_provincia,
                          '', '',
                          ' (' || a1.sigla_provincia || ')'),
               3,
               fam.zipcode || ' ' || nvl(h.descrizione_al1,h.descrizione)
               || DECODE (h.sigla_provincia,
                          '', '',
                          ' (' || h.sigla_provincia || ')'),
               4,
               fam.zipcode || ' ' || nvl(h.descrizione_al1,h.descrizione)
               || DECODE (h.sigla_provincia,
                          '', '',
                          ' (' || h.sigla_provincia || ')'),
               NVL (
                  RTRIM (
                     SUBSTR (f_unita_territoriale (99,
                                                   fam.cod_via,
                                                   fam.num_civ,
                                                   fam.suffisso), 25, 30)
                  ),
                  a.cap || ' ' || nvl(a.descrizione_al1,a.descrizione)
                  || DECODE (a.sigla_provincia,
                             '', '',
                             ' (' || a.sigla_provincia || ')')
               )
            ),
-- comune_data
            nvl(a.descrizione_al1,a.descrizione) || ' ' || TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- comune
            nvl(a.descrizione_al1,a.descrizione),
-- data
            TO_CHAR (SYSDATE, 'dd/mm/yyyy'),
-- provincia
            pro.descrizione,
            b.cap || ' ' || nvl(b.descrizione_al1,b.descrizione)
            || DECODE (b.sigla_provincia,
                       '', '',
                       ' (' || b.sigla_provincia || ')'),
            g.cap || ' ' || nvl(g.descrizione_al1,g.descrizione)
            || DECODE (g.sigla_provincia,
                       '', '',
                       ' (' || g.sigla_provincia || ')'),
            f.cap || ' ' || nvl(f.descrizione_al1,f.descrizione)
            || DECODE (f.sigla_provincia,
                       '', '',
                       ' (' || f.sigla_provincia || ')'),
-- famiglia_convivenza
            DECODE (fam.tipo_fam, NULL, 'famiglia', 'convivenza'),
-- denominazione_convivenza
            DECODE (fam.tipo_fam,
                    NULL, TO_CHAR (NULL),
                    'Convivenza: ' || fam.convivenza),
-- fascia
            ana.fascia,
-- cod_fam,
            ana.cod_fam,
-- cod_rp,
            ana.rapporto_par,
-- rapporto_parentela
            drp.descrizione,
-- sequenza_par
            ana.sequenza_par,
-- inizio_famiglia
            DECODE (
               ana.fascia,
               1,
               DECODE (
                  ana.data_inizio_fam,
                  ana.data_nas,
                  'dalla nascita',
                  'dal '
                  || TO_CHAR (TO_DATE (ana.data_inizio_fam, 'j'),
                              'dd/mm/yyyy')
               ),
               3,
               'dal '
               || TO_CHAR (TO_DATE (ana.data_inizio_fam, 'j'), 'dd/mm/yyyy'),
               ''
            ),
-- Carta di Identita'Coniuge
-- numero_carta_coniuge
            doc_CI_cn.numero,
-- natura_carta_conuige
            DECODE (doc_CI_cn.natura_documento,
                    'O', 'Originale',
                    'D', 'Duplicato',
                    'A', 'Annullato',
                    ''),
-- data_carta_coniuge
            TO_CHAR (TO_DATE (doc_CI_cn.data_emissione, 'j'), 'dd/mm/yyyy'),
-- comune_carta_coniuge
            u.descrizione
            || DECODE (u.sigla_provincia,
                       '', '',
                       ' (' || u.sigla_provincia || ')'),
-- scadenza_carta_coniuge
            TO_CHAR (TO_DATE (doc_CI_cn.data_scadenza, 'j'), 'dd/mm/yyyy'),
-- Carta di Identita Elettronica Coniuge
-- numero_CIE
            doc_CE_cn.numero,
-- natura_CIe_coniuge
            DECODE (doc_CE_cn.natura_documento,
                    'O', 'Originale',
                    'D', 'Duplicato',
                    'A', 'Annullato',
                    ''),
-- data_CIE
            TO_CHAR (TO_DATE (doc_CE_cn.data_emissione, 'j'), 'dd/mm/yyyy'),
-- comune_CIE
            v.descrizione
            || DECODE (v.sigla_provincia,
                       '', '',
                       ' (' || v.sigla_provincia || ')'),
-- scadenza_CIE
            TO_CHAR (TO_DATE (doc_CE_cn.data_scadenza, 'j'), 'dd/mm/yyyy'),
-- Dato piu' recente tra CI e CE
-- numero_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI_cn.data_emissione, 0)
                    - NVL (doc_CE_cn.data_emissione, 0)),
               0,
               doc_CI_cn.numero,
               1,
               doc_CI_cn.numero,
               -1,
               doc_CE_cn.numero
            ),
-- natura_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI_cn.data_emissione, 0)
                    - NVL (doc_CE_cn.data_emissione, 0)),
               0,
               DECODE (doc_CI_cn.natura_documento,
                       'O', 'Originale',
                       'D', 'Duplicato',
                       'A', 'Annullato',
                       ''),
               1,
               DECODE (doc_CI_cn.natura_documento,
                       'O', 'Originale',
                       'D', 'Duplicato',
                       'A', 'Annullato',
                       ''),
               -1,
               DECODE (doc_CE_cn.natura_documento,
                       'O', 'Originale',
                       'D', 'Duplicato',
                       'A', 'Annullato',
                       '')
            ),
-- data_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI_cn.data_emissione, 0)
                    - NVL (doc_CE_cn.data_emissione, 0)),
               0,
               TO_CHAR (TO_DATE (doc_CI_cn.data_emissione, 'j'),
                        'dd/mm/yyyy'),
               1,
               TO_CHAR (TO_DATE (doc_CI_cn.data_emissione, 'j'),
                        'dd/mm/yyyy'),
               -1,
               TO_CHAR (TO_DATE (doc_CE_cn.data_emissione, 'j'),
                        'dd/mm/yyyy')
            ),
-- comune_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI_cn.data_emissione, 0)
                    - NVL (doc_CE_cn.data_emissione, 0)),
               0,
               u.descrizione
               || DECODE (u.sigla_provincia,
                          '', '',
                          ' (' || u.sigla_provincia || ')'),
               1,
               u.descrizione
               || DECODE (u.sigla_provincia,
                          '', '',
                          ' (' || u.sigla_provincia || ')'),
               -1,
               v.descrizione
               || DECODE (v.sigla_provincia,
                          '', '',
                          ' (' || v.sigla_provincia || ')')
            ),
-- scadenza_CI_CIE
            DECODE (
               SIGN(NVL (doc_CI_cn.data_scadenza, 0)
                    - NVL (doc_CE_cn.data_scadenza, 0)),
               0,
               TO_CHAR (TO_DATE (doc_CI_cn.data_scadenza, 'j'), 'dd/mm/yyyy'),
               1,
               TO_CHAR (TO_DATE (doc_CI_cn.data_scadenza, 'j'), 'dd/mm/yyyy'),
               -1,
               TO_CHAR (TO_DATE (doc_CE_cn.data_scadenza, 'j'), 'dd/mm/yyyy')
            ),
-- data_inizio_temp
            TO_CHAR (TO_DATE (spt.data_iscrizione, 'j'), 'dd/mm/yyyy'),
-- data_fine_temp
            TO_CHAR (TO_DATE (spt.data_cancellazione, 'j'), 'dd/mm/yyyy'),
-- comune_temp
            nvl(z.descrizione_al1,z.descrizione),
-- indirizzo_temp
            decode(spt.domicilio_temp, '',
              vie_temp.denom_uff||spt.civico_esterno_temp||spt.civico_interno_temp,
              spt.domicilio_temp)
     FROM   arcinp inp,
            anadca dca,
            anadsc dsc,
            anadci dci,
            anadts dts,
            anadpr dpr,
            anadrp drp,
            arcvie vie,
            anafam fam,
            levruo ruo,
            levdar dar,
            levdco dco,
            levdes des,
            levdgr dgr,
            anadcn dcn,
            anadoc doc_CI,
            anadoc doc_LL,
            anadoc doc_PT,
            anadoc doc_PS,
            anadoc doc_CS,
            anadoc doc_CE,
            anadoc doc_CI_cn,
            anadoc doc_CE_cn,
            anadoc doc_U1,
            anadoc doc_U2,
            arcvie vie_cn,
            arcvie vie_ele,
            arcvie vie_11,
            anafam fam_cn,
            arcvie vie_temp,
            arcpro pro,
            arccom com_nas_cv,
            arccom com_ini_cdf,
            arccom com_fin_cdf,
            arccom a,
            arccom a1,
            arccom b,
            arccom b1,
            arccom c1,
            arccom d1,
            arccom f1,
            arccom c,
            arccom d,
            arccom com_nas_cn,
            arccom f,
            arccom g,
            arccom h,
            arccom i,
            arccom l,
            arccom m,
            arccom n,
            arccom o,
            arccom p,
            arccom q,
            arccom r,
            arccom s,
            arccom t,
            arccom u,
            arccom v,
            arccom z,
            arccom x,
            arccom y,
            arccom com_aire,
            arccon con,
            arcdco adco,
            arccom com_dcn,
            eletee tee,
            eledtl dtl_b,
            eledtl dtl_c,
            eledtl dtl_e,
            eledtl dtl_t,
            eledtl dtl_v,
            eledtl dtl_f,
            eleela ela_b,
            eleela ela_c,
            eleela ela_e,
            eleela ela_t,
            eleela ela_v,
            eleela ela_f,
            eledsr dsr,
	    eledsr dsr_b,
            eledsr dsr_c,
            eledsr dsr_e,
            eledsr dsr_t,
            eledsr dsr_v,
            eledsr dsr_f,
            eledse dse,
            eledse dse_b,
            eledse dse_c,
            eledse dse_e,
            eledse dse_t,
            eledse dse_v,
            eledse dse_f,
            eledlr dlr,
            eledlr dlr_b,
            eledlr dlr_c,
            eledlr dlr_e,
            eledlr dlr_t,
            eledlr dlr_v,
            eledlr dlr_f,
            eleana ele,
            anaspt spt,
            anacdf cdf,
            anaeve eve_11,
            anaeve eve,
            anaana ana_cv,
            anaana ana_cn,
            anaana ana
    WHERE       inp.parametro(+) = 'INTERNO'
--
            AND com_ini_cdf.cod_comune         (+) = cdf.cod_com_inizio
            AND com_ini_cdf.cod_provincia      (+) = cdf.cod_pro_inizio
            AND com_fin_cdf.cod_comune         (+) = cdf.cod_com_fine
            AND com_fin_cdf.cod_provincia      (+) = cdf.cod_pro_fine
            AND com_nas_cv.cod_comune          (+) = ana_cv.cod_com_nas
            AND com_nas_cv.cod_provincia       (+) = ana_cv.cod_pro_nas
            AND ana_cv.matricola               (+) = cdf.matricola_cv
            AND cdf.stato_cdf                  (+) = 'I'
            AND cdf.matricola                  (+) = ana.matricola
--
            AND com_nas_cn.cod_comune          (+) = ana_cn.cod_com_nas
            AND com_nas_cn.cod_provincia       (+) = ana_cn.cod_pro_nas
            AND vie_cn.cod_via                 (+) = fam_cn.cod_via
            AND fam_cn.cod_fam                 (+) = ana_cn.cod_fam
            AND fam_cn.fascia                  (+) = ana_cn.fascia
            AND ana_cn.matricola               (+) = ana.matricola_cn
--
            AND vie_11.cod_via(+) = eve_11.cod_via
            AND eve_11.data_eve(+) = NVL(ana.data_inizio_res, ana.data_ult_eve) - 1
            AND eve_11.cod_mov(+) = 11
            AND eve_11.matricola(+) = ana.matricola
            AND vie_ele.cod_via(+) = ele.cod_via_ele
            AND h.cod_comune(+) = fam.cod_com_aire
            AND h.cod_provincia(+) = fam.cod_pro_aire
            AND q.cod_comune(+) = 0
            AND q.cod_provincia(+) = fam.cod_pro_aire
            AND vie.cod_via(+) = fam.cod_via
            AND fam.cod_fam(+) = ana.cod_fam
            AND fam.fascia(+) = ana.fascia
            AND dts.cod_ts(+) = ana.titolo_studio
            AND drp.sesso(+) = ana.sesso
            AND drp.cod_rp(+) = ana.rapporto_par
            AND dpr.sesso(+) = ana.sesso
            AND dpr.cod_pr(+) = ana.cod_prof
            AND dsc.cod_sc = ana.stato_civile
            AND dsc.sesso = ana.sesso
            AND dci.cod_ci(+) = ana.nazionalita
            AND ruo.matricola(+) = ana.matricola
            AND dar.cod_ar(+) = ruo.arma
            AND dco.cod_co(+) = ruo.corpo
            AND dgr.cod_gr(+) = ruo.grado
            AND des.cod_es(+) = ruo.esito
            AND pro.cod_provincia = a.cod_provincia
            AND (a.cod_provincia, a.cod_comune) =
                  (SELECT   pro_cliente, com_cliente FROM menuditta)
            AND a1.cod_comune(+) = fam.cod_com_res
            AND a1.cod_provincia(+) = fam.cod_pro_res
            AND b.cod_comune = ana.cod_com_nas
            AND b.cod_provincia = ana.cod_pro_nas
            AND b1.cod_comune(+) = ana.cod_com_atto_nas
            AND b1.cod_provincia(+) = ana.cod_pro_atto_nas
            AND c.cod_comune(+) = ana.cod_com_mat
            AND c.cod_provincia(+) = ana.cod_pro_mat
            AND c1.cod_comune(+) = ana.cod_com_atto_mat
            AND c1.cod_provincia(+) = ana.cod_pro_atto_mat
            AND d.cod_comune(+) = ana.cod_com_ved
            AND d.cod_provincia(+) = ana.cod_pro_ved
            AND d1.cod_comune(+) = ana.cod_com_atto_ved
            AND d1.cod_provincia(+) = ana.cod_pro_atto_ved
            AND f.cod_comune(+) = ana.cod_com_mor
            AND f.cod_provincia(+) = ana.cod_pro_mor
            AND f1.cod_comune(+) = ana.cod_com_atto_mor
            AND f1.cod_provincia(+) = ana.cod_pro_atto_mor
            AND p.cod_comune(+) = eve.cod_com_ric
            AND p.cod_provincia(+) = eve.cod_pro_ric
            AND g.cod_comune(+) = eve.cod_com_eve
            AND g.cod_provincia(+) = eve.cod_pro_eve
            AND i.cod_comune(+) = ruo.cod_com_lev
            AND i.cod_provincia(+) = ruo.cod_pro_lev
            AND l.cod_comune(+) = ruo.cod_com_dis
            AND l.cod_provincia(+) = ruo.cod_pro_dis
            AND fam.cod_pro_aire = com_aire.cod_provincia(+)
            AND fam.cod_com_aire = com_aire.cod_comune(+)
            AND com_aire.cod_consolato = con.cod_consolato(+)
            AND com_aire.tipo_consolato = con.tipo_consolato(+)
            AND con.stato(+) =
                  NVL (com_aire.cod_territorio, com_aire.cod_provincia)
            AND adco.tipo_consolato(+) = con.tipo_consolato
            AND com_dcn.cod_provincia(+) = dcn.cod_pro_res_emi
            AND com_dcn.cod_comune(+) = dcn.cod_com_res_emi
            AND dcn.matricola(+) = doc_CI.matricola
            AND m.cod_comune(+) = doc_CI.cod_com_ente
            AND m.cod_provincia(+) = doc_CI.cod_pro_ente
            AND doc_CI.matricola(+) = ana.matricola
            AND doc_CI.tipo_documento(+) = 'CI'
            AND doc_CI.progr_documento(+) = 1
            AND doc_CI.natura_documento(+) != 'A'
            AND u.cod_comune(+) = doc_CI_cn.cod_com_ente
            AND u.cod_provincia(+) = doc_CI_cn.cod_pro_ente
            AND doc_CI_cn.matricola(+) = ana.matricola_cn
            AND doc_CI_cn.tipo_documento(+) = 'CI'
            AND doc_CI_cn.progr_documento(+) = 1
            AND doc_CI_cn.natura_documento(+) != 'A'
            AND t.cod_comune(+) = doc_CE.cod_com_ente
            AND t.cod_provincia(+) = doc_CE.cod_pro_ente
            AND doc_CE.matricola(+) = ana.matricola
            AND doc_CE.tipo_documento(+) = 'CE'
            AND doc_CE.progr_documento(+) = 1
            AND doc_CE.natura_documento(+) != 'A'
            AND v.cod_comune(+) = doc_CE_cn.cod_com_ente
            AND v.cod_provincia(+) = doc_CE_cn.cod_pro_ente
            AND doc_CE_cn.matricola(+) = ana.matricola_cn
            AND doc_CE_cn.tipo_documento(+) = 'CE'
            AND doc_CE_cn.progr_documento(+) = 1
            AND doc_CE_cn.natura_documento(+) != 'A'
            AND n.cod_comune(+) = doc_LL.cod_com_ente
            AND n.cod_provincia(+) = doc_LL.cod_pro_ente
            AND doc_LL.matricola(+) = ana.matricola
            AND doc_LL.tipo_documento(+) = 'LL'
            AND doc_LL.progr_documento(+) = 1
            AND doc_LL.natura_documento(+) != 'A'
            AND dca.cod_ca(+) = doc_PT.categoria
            AND o.cod_comune(+) = doc_PT.cod_com_ente
            AND o.cod_provincia(+) = doc_PT.cod_pro_ente
            AND doc_PT.matricola(+) = ana.matricola
            AND doc_PT.tipo_documento(+) = 'PT'
            AND doc_PT.progr_documento(+) = 1
            AND doc_PT.natura_documento(+) != 'A'
            AND r.cod_comune(+) = doc_PS.cod_com_ente
            AND r.cod_provincia(+) = doc_PS.cod_pro_ente
            AND doc_PS.matricola(+) = ana.matricola
            AND doc_PS.tipo_documento(+) = 'PS'
            AND doc_PS.progr_documento(+) = 1
            AND doc_PS.natura_documento(+) != 'A'
            AND s.cod_comune(+) = doc_CS.cod_com_ente
            AND s.cod_provincia(+) = doc_CS.cod_pro_ente
            AND doc_CS.matricola(+) = ana.matricola
            AND doc_CS.tipo_documento(+) = 'CS'
            AND doc_CS.progr_documento(+) = 1
            AND doc_CS.natura_documento(+) != 'A'
            AND x.cod_comune(+) = doc_U1.cod_com_ente
            AND x.cod_provincia(+) = doc_U1.cod_pro_ente
            AND doc_U1.matricola(+) = ana.matricola
            AND doc_U1.tipo_documento(+) = 'U1'
            AND doc_U1.progr_documento(+) = 1
            AND doc_U1.natura_documento(+) != 'A'
            AND y.cod_comune(+) = doc_U2.cod_com_ente
            AND y.cod_provincia(+) = doc_U2.cod_pro_ente
            AND doc_U2.matricola(+) = ana.matricola
            AND doc_U2.tipo_documento(+) = 'U2'
            AND doc_U2.progr_documento(+) = 1
            AND doc_U2.natura_documento(+) != 'A'
            AND z.cod_comune(+) = spt.cod_com_temp
            AND z.cod_provincia(+) = spt.cod_pro_temp
            AND vie_temp.cod_via(+) = spt.cod_via_temp
            AND spt.matricola(+) = ana.matricola
            AND tee.matricola	(+)	= ana.matricola
            AND tee.progressivo	(+)	= 1
            AND tee.natura	(+)	!= 'A'
            AND dtl_f.cod_tl(+) = ela_f.tipo_lista
            AND ela_f.tipo_lista(+) = 'F'
            AND ela_f.matricola(+) = ana.matricola
            AND dtl_v.cod_tl(+) = ela_v.tipo_lista
            AND ela_v.tipo_lista(+) = 'V'
            AND ela_v.matricola(+) = ana.matricola
            AND dtl_t.cod_tl(+) = ela_t.tipo_lista
            AND ela_t.tipo_lista(+) = 'T'
            AND ela_t.matricola(+) = ana.matricola
            AND dtl_e.cod_tl(+) = ela_e.tipo_lista
            AND ela_e.tipo_lista(+) = 'E'
            AND ela_e.matricola(+) = ana.matricola
            AND dtl_c.cod_tl(+) = ela_c.tipo_lista
            AND ela_c.tipo_lista(+) = 'C'
            AND ela_c.matricola(+) = ana.matricola
            AND dtl_b.cod_tl(+) = ela_b.tipo_lista
            AND ela_b.tipo_lista(+) = 'B'
            AND ela_b.matricola(+) = ana.matricola
            AND dsr.anno(+) = ele.anno
            AND dsr.revisione(+) = ele.revisione
            AND dsr.progr_revisione(+) = ele.progr_revisione
            AND dsr_f.anno(+) = ela_f.anno
            AND dsr_f.revisione(+) = ela_f.revisione
            AND dsr_f.progr_revisione(+) = ela_f.progr_revisione
            AND dsr_v.anno(+) = ela_v.anno
            AND dsr_v.revisione(+) = ela_v.revisione
            AND dsr_v.progr_revisione(+) = ela_v.progr_revisione
            AND dsr_t.anno(+) = ela_t.anno
            AND dsr_t.revisione(+) = ela_t.revisione
            AND dsr_t.progr_revisione(+) = ela_t.progr_revisione
            AND dsr_e.anno(+) = ela_e.anno
            AND dsr_e.revisione(+) = ela_e.revisione
            AND dsr_e.progr_revisione(+) = ela_e.progr_revisione
            AND dsr_c.anno(+) = ela_c.anno
            AND dsr_c.revisione(+) = ela_c.revisione
            AND dsr_c.progr_revisione(+) = ela_c.progr_revisione
            AND dsr_b.anno(+) = ela_b.anno
            AND dsr_b.revisione(+) = ela_b.revisione
            AND dsr_b.progr_revisione(+) = ela_b.progr_revisione
            AND dlr_f.cod_lr(+) = dse_f.luogo_riunione
            AND dse_f.sezione(+) = ela_f.sezione
            AND dlr_v.cod_lr(+) = dse_v.luogo_riunione
            AND dse_v.sezione(+) = ela_v.sezione
            AND dlr_t.cod_lr(+) = dse_t.luogo_riunione
            AND dse_t.sezione(+) = ela_t.sezione
            AND dlr_e.cod_lr(+) = dse_e.luogo_riunione
            AND dse_e.sezione(+) = ela_e.sezione
            AND dlr_c.cod_lr(+) = dse_c.luogo_riunione
            AND dse_c.sezione(+) = ela_c.sezione
            AND dlr_b.cod_lr(+) = dse_b.luogo_riunione
            AND dse_b.sezione(+) = ela_b.sezione
            AND dlr.cod_lr(+) = dse.luogo_riunione
            AND dse.sezione(+) = ele.sezione
            AND ele.matricola(+) = ana.matricola
            AND eve.data_eve(+) = ana.data_ult_eve
            AND eve.cod_eve(+) = ana.stato
            AND eve.cod_mov(+) = ana.fascia
            AND eve.matricola(+) = ana.matricola
/
comment on table cerwan is 'Certificazione - Dati per campi di stampa unione (view)'
/
