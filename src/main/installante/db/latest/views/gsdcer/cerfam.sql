--liquibase formatted sql
--changeset amonopoli:202501281130_0 runOnChange:true stripComments:false
create or replace view cerfam
	(cognome_nome, paternita, maternita, 
	 residenza_fam,
	 nat_oa, data_nascita, comune_nascita,
	 comune_atto_nascita, atto_nascita,
	 stato_civile, coniugat_oa, cognome_nome_coniuge,
	 estremi_mat_ved, atto_mat_ved,
	 titolo_studio, professione, cittadinanza, codice_fiscale,
	 estremi_ultimo_evento, pratica_ultimo_evento,
	 matricola, fascia, cod_fam, rapporto_parentela, sequenza_par,
	 indirizzo_fam, indirizzo_fam_int,
	 data_inizio_fam, data_fine_fam, data_nas,
	 rapporto_par,tipo_fam,
         numero_di,data_di,comune_di,scadenza_di,natura_di,
         numero_ds,data_ds,comune_ds,scadenza_ds,natura_ds,
         data_ricomparsa,comune_ricomparsa,pratica_ricomparsa
)
AS 
SELECT                                                   
-- cognome_nome
         REPLACE (ana.cognome_nome, '/', ' '),
-- paternita
         'pt. ' || REPLACE (ana.paternita, '/', ' '),
-- maternita
         'mt. ' || REPLACE (ana.maternita, '/', ' '),
-- residenza_fam
         DECODE (ana.fascia,1,'Residente a '|| a.descrizione||' '||
                                  f_provincia_stato (a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S')
                                  ||' '|| DECODE (ana.stato,1,'dalla nascita','dal '||
                                                 TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'),'dd/mm/yyyy')),2,
                       DECODE (ana.stato,50,'Decedut' || DECODE (ana.sesso, 'M', 'o', 'a') || ' il ',
                                         51,'Emigrat' || DECODE (ana.sesso, 'M', 'o', 'a') || ' il ',
                                         53,'Irreperibile dal ','Cancellat'|| DECODE (ana.sesso, 'M', 'o', 'a')||
                                                                 ' dall''A.P.R. il ')
                       || TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')||
                          DECODE (ana.stato, 50, ' a ', 51, ' a ', '')|| 
                       DECODE (ana.stato,50,e.descrizione||' '|| 
                                        f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S'),
                                         51,f.descrizione|| ' '||
                                        f_provincia_stato (f.cod_provincia,f.cod_comune,f.sigla_provincia,'S','S')),
                               3,'Iscritto all''A.I.R.E. '|| 'dal '|| TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               4, DECODE (ana.stato, 50,'Decedut' || DECODE (ana.sesso, 'M', 'o', 'a') || ' il ',
                                                     53,'Irreperibile dal ',
                                                        'Cancellat'|| DECODE (ana.sesso, 'M', 'o', 'a')||' dall''A.I.R.E. il ')               || TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
                       || DECODE (ana.stato, 50, ' a ', '')|| 
                       DECODE (ana.stato,50,e.descrizione|| ' '|| 
                                 f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S'))),
-- nat_oa
         DECODE (ana.sesso, 'M', 'nato', 'nata'),
-- data_nascita
         DECODE (ana.anno_nas,
           'S', '00/00/' || TO_CHAR (TO_DATE (ana.data_nas, 'j'), 'yyyy'),
                TO_CHAR (TO_DATE (ana.data_nas, 'j'), 'dd/mm/yyyy') ),
-- comune_nascita
         b.descrizione|| ' '||f_provincia_stato_CER (b.cod_provincia, b.cod_comune,b.sigla_provincia,'S','S',ana.data_nas),
-- comune_atto_nascita
         DECODE (b1.descrizione,'', '',
           '- '||b1.descrizione|| ' '||f_provincia_stato_CER (b1.cod_provincia,b1.cod_comune,b1.sigla_provincia,'S','S',ana.data_nas)),
-- atto_nascita
         decode(ana.atto_nas_digitale,'',
           'atto N. '|| TO_CHAR (ana.atto_nas)|| 
             ' p. '|| DECODE (ana.parte_nas,1,'I',2,'II')|| 
             DECODE (ana.serie_nas, '', '', ' s. ' || ana.serie_nas)|| 
             DECODE (ana.ufficio_nas,0, '','', '',' uff. ' || TO_CHAR (ana.ufficio_nas))|| 
             ' / '|| TO_CHAR (ana.anno_atto_nas),
           'atto N. '|| ana.atto_nas_digitale),
-- stato_civile
         dsc.descrizione_cer,
-- coniugat_oa
         DECODE (ana.stato_civile,
           'CN', DECODE (ana.sesso, 'M', 'coniugato', 'coniugata'),
           'UC', DECODE (ana.sesso, 'M', 'unito civilmente', 'unita civilmente'),
                 ''),
-- cognome_nome_coniuge
         DECODE (ana.stato_civile, 
          'CN', REPLACE (ana.cognome_nome_cn, '/', ' '),
          'VE', REPLACE (ana.cognome_nome_cn, '/', ' '),
          'UC', REPLACE (ana.cognome_nome_cn, '/', ' '),
          'VU', REPLACE (ana.cognome_nome_cn, '/', ' '),
                ''),
-- estremi_mat_ved
         DECODE (ana.stato_civile,
           'CN', 'il '||DECODE (ana.anno_mat,'S','00/00/'||TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'yyyy'),
                              TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'dd/mm/yyyy'))|| 
                    ' a '||c.descrizione||' '||f_provincia_stato (c.cod_provincia, c.cod_comune,c.sigla_provincia,'S','S'),
           'VE', 'dal '||TO_CHAR (TO_DATE (ana.data_ved, 'j'), 'dd/mm/yyyy')|| 
                    ' a '||d.descrizione||' '|| f_provincia_stato (d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S'),
           'UC', 'il '||DECODE (ana.anno_mat,'S','00/00/'||TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'yyyy'),
                              TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'dd/mm/yyyy'))|| 
                    ' a '||c.descrizione||' '||f_provincia_stato (c.cod_provincia, c.cod_comune,c.sigla_provincia,'S','S'),
           'VU', 'dal '||TO_CHAR (TO_DATE (ana.data_ved, 'j'), 'dd/mm/yyyy')|| 
                    ' a '||d.descrizione||' '|| f_provincia_stato (d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S'),
                 '' ),
-- atto_mat_ved
         DECODE (ana.stato_civile,
           'CN', decode(ana.atto_mat_digitale,'',
                   'atto N. '|| TO_CHAR (ana.atto_mat)|| 
                     DECODE (ana.parte_mat,1,' p. I',2,' p. II')|| 
                     DECODE (ana.serie_mat, '', '', ' s. ' || ana.serie_mat)|| 
                     DECODE (ana.ufficio_mat,0, '','', '',' uff. ' || TO_CHAR (ana.ufficio_mat))|| 
                     DECODE (ana.anno_atto_mat,'', '',' / ' || TO_CHAR (ana.anno_atto_mat)),
                   'atto N. '|| ana.atto_mat_digitale),
           'VE', decode(ana.atto_ved_digitale,'',
                   'atto N. ' || TO_CHAR (ana.atto_ved)|| 
                     DECODE (ana.parte_ved,1,' p. I',2,' p. II')|| 
                     DECODE (ana.serie_ved, '', '', ' s. ' || ana.serie_ved)|| 
                     DECODE (ana.ufficio_ved,0, '','', '',' uff. ' || TO_CHAR (ana.ufficio_ved))|| 
                     DECODE (ana.anno_atto_ved,'', '',' / ' || TO_CHAR (ana.anno_atto_ved)),
                   'atto N. ' || ana.atto_ved_digitale),
           'UC', decode(ana.atto_mat_digitale,'',
                   'atto N. '|| TO_CHAR (ana.atto_mat)|| 
                     DECODE (ana.parte_mat,1,' p. I',2,' p. II')|| 
                     DECODE (ana.serie_mat, '', '', ' s. ' || ana.serie_mat)|| 
                     DECODE (ana.ufficio_mat,0, '','', '',' uff. ' || TO_CHAR (ana.ufficio_mat))|| 
                     DECODE (ana.anno_atto_mat,'', '',' / ' || TO_CHAR (ana.anno_atto_mat)), 
                   'atto N. '|| ana.atto_mat_digitale),
           'VU', decode(ana.atto_ved_digitale,'',
                   'atto N. ' || TO_CHAR (ana.atto_ved)|| 
                     DECODE (ana.parte_ved,1,' p. I',2,' p. II')|| 
                     DECODE (ana.serie_ved, '', '', ' s. ' || ana.serie_ved)|| 
                     DECODE (ana.ufficio_ved,0, '','', '',' uff. ' || TO_CHAR (ana.ufficio_ved))|| 
                     DECODE (ana.anno_atto_ved,'', '',' / ' || TO_CHAR (ana.anno_atto_ved)),
                   'atto N. ' || ana.atto_ved_digitale)
                 ),
-- titolo_studio
         dts.descrizione,
-- professione
         dpr.descrizione,
-- cittadinanza
         dci.descrizione,
-- cod_fiscale
         DECODE ( ana.cod_fiscale,'',TO_CHAR (NULL),DECODE (ana.cf_calcolato, '', ana.cod_fiscale, TO_CHAR (NULL))),
-- estremi_ultimo_evento
         DECODE (g.cod_provincia,0,g.descrizione,
                      DECODE(ana.stato,1,'Residente a '
                         || DECODE (ana.fascia,1, a.descrizione,3,g.descrizione
                                || ' '|| f_provincia_stato (g.cod_provincia,g.cod_comune, g.sigla_provincia,'S','S'),
                             '')
                  || ' dalla nascita',2,DECODE (ana.sesso,'M', 'Immigrato il ','F', 'Immigrata il ',''),
                  3,DECODE (ana.sesso,'M', 'Reimmigrato il ','F', 'Reimmigrata il ',''),
                  4,DECODE (ana.sesso,'M', 'Reimmigrato il ','F', 'Reimmigrata il ',''),
                  5,DECODE (ana.sesso,'M', 'Iscritto d''ufficio il ','F', 'Iscritta d''ufficio il ',''),
                  6,DECODE (ana.sesso,'M', 'Iscritto d''ufficio A.I.R.E. il ','F', 'Iscritta d''ufficio A.I.R.E. il ',''),
                  7,DECODE (ana.sesso,'M', 'Trasferito A.I.R.E. il ','F', 'Trasferita A.I.R.E. il ',''),
                  8,DECODE (ana.sesso,'M','Iscritto A.I.R.E. per Acquisto cittadinanza italiana il ',
                     'F','Iscritto A.I.R.E. per Acquisto cittadinanza italiana il ',''),
                  52,DECODE (ana.sesso,'M', 'Emigrato all''A.I.R.E. il ','F', 'Emigrata all''A.I.R.E. il ',''),
                  50,DECODE (ana.sesso,'M', 'Deceduto il ','F', 'Deceduta il ',''),
                  51,DECODE (ana.sesso, 'M', 'Emigrato il ','F', 'Emigrata il ',''),
                  53,'Irreperibile '|| DECODE (eve.cod_variazione, 'C', 'al Censimento ', '')|| 'dal ',
                  54,'Irreperibile dal ',
                  55,DECODE (ana.sesso,'M', 'Rimpatriato il ','F', 'Rimpatriata il ',''),
                  56,'Trasferimento A.I.R.E. il ',
                  9,DECODE (ana.sesso,'M','Reiscritto'
                                || DECODE (ana.fascia, 3, ' A.I.R.E. ', ' ')
                                || 'da Irreperibilita'' il ',
                                'F','Reiscritta'
                                || DECODE (ana.fascia, 3, ' A.I.R.E. ', ' ')
                                || 'da Irreperibilita'' il ','' ),
                  58,DECODE (ana.sesso,'M', 'Cancellato per Doppia Iscrizione il ',
                          'F', 'Cancellato per Doppia Iscrizione il ',''),
                  59, DECODE (ana.sesso,'M', 'Cancellato d''Ufficio il ',
                          'F', 'Cancellato d''Ufficio il ',''),
                  60,DECODE (ana.sesso,'M','Cancellato per Mancato Rinnovo del Permesso di Soggiorno il ',
                     'F','Cancellato per Mancato Rinnovo del Permesso di Soggiorno il ',''),
                  10,DECODE (ana.sesso,'M','Iscritto A.I.R.E. per Residenza all''Estero il ',
                          'F','Iscritta A.I.R.E. per Residenza all''Estero il ',''),'')
                     || DECODE (ana.stato,2,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' da ',
                               3,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' da ',
                               4,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' da ',
                               5,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               6,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               7,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' da ',
                               8,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               52,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' a ',
                               50,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' a ',
                               51,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' a ',
                               53,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               54,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               55,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' a ',
                               56,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')|| ' all''A.I.R.E. di ',
                               9,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')||' ',
                               58,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               59,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               60,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
                               10,TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),' ')
               || DECODE (ana.stato,50,DECODE (e.descrizione,'', '',e.descrizione
                                  || ' '|| f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S')),
                          DECODE (f.descrizione,'', '', f.descrizione|| ' '
                                  || f_provincia_stato (f.cod_provincia, f.cod_comune,f.sigla_provincia,'S','S')))),
-- pratica_ultimo_evento
         DECODE (ana.stato,
           50, decode(ana.atto_mor_digitale,'',
                 DECODE (ana.atto_mor,'','','atto N. '|| TO_CHAR (ana.atto_mor)|| 
                   DECODE (ana.parte_mor,1,' p. I',2,' p. II')|| 
                   DECODE (ana.serie_mor, '', '', ' s. ' || ana.serie_mor)|| 
                   DECODE (ana.ufficio_mor,'', '',' uff. ' || TO_CHAR (ana.ufficio_mor))|| 
                   ' / '|| TO_CHAR (ana.anno_atto_mor)),
                 'atto N. '|| ana.atto_mor_digitale),
            DECODE (eve.pratica,'','','Pratica N. '||TO_CHAR (eve.pratica)|| '/'|| TO_CHAR (eve.anno_pratica))),
-- matricola
         ana.matricola,
-- fascia
         ana.fascia,
-- cod_fam
         ana.cod_fam,
-- rapporto_parentela
         drp.descrizione,
-- sequenza_par
         drp.sequenza,
-- indirizzo_fam
         'abitante in '
            || DECODE (ana.fascia, 1,vie.denom_uff || fam.civico_esterno
                                    || DECODE (UPPER (RTRIM (inp.valore)),'N', '',fam.civico_interno),
                                   2,vie_11.denom_uff || eve_11.civico_esterno
                                    || DECODE (UPPER (RTRIM (inp.valore)),'N', '',eve_11.civico_interno),
                                   3,fam.via_aire,4,eve_13.via_aire) indirizzo_fam,
-- indirizzo_fam_int
         'abitante in '|| 
           DECODE (ana.fascia,
             1, vie.denom_uff || fam.civico_esterno || fam.civico_interno,
             2, vie_11.denom_uff|| eve_11.civico_esterno|| eve_11.civico_interno,
             3, fam.via_aire,
             4, eve_13.via_aire) indirizzo_fam,
-- data_inizio_fam
         ana.data_inizio_fam,
-- data_fine_fam
         DECODE (ana.fascia,
           1, TO_NUMBER (TO_CHAR (SYSDATE, 'j')),
           3, TO_NUMBER (TO_CHAR (SYSDATE, 'j')),NULL) data_fine_fam,
-- data_nas : per order by
         ana.data_nas,
-- rapporto_par
         ana.rapporto_par,
-- tipo_fam
         fam.tipo_fam,
-- numero_di 
         wdi.numero_di,
-- data_di
         to_char(to_date(wdi.data_emissione_di,'j'),'dd/mm/yyyy'),
-- comune_di
         h.descrizione|| ' '|| f_provincia_stato (h.cod_provincia, h.cod_comune, h.sigla_provincia,'S','S'),
-- scadenza_di
         to_char(to_date(wdi.data_scadenza_di,'j'),'dd/mm/yyyy'),
-- natura_di 
         wdi.natura_di,
-- numero_ds
         str.numero_ds,
-- data_ds
         to_char(to_date(str.data_emissione_ds,'j'),'dd/mm/yyyy'),
-- comune_ds
         l.descrizione|| ' '|| f_provincia_stato (l.cod_provincia,l.cod_comune,l.sigla_provincia,'S','S'),
-- scadenza_ds
         to_char(to_date(str.data_scadenza_ds,'j'),'dd/mm/yyyy'),
-- natura_ds
         str.natura_ds,
-- data_ricomparsa
         decode(eve.data_ric, '', '',
           decode(ana.sesso, 'M', 'ricomparso il ', 'ricomparsa il ')||TO_CHAR (TO_DATE (eve.data_ric, 'j'), 'dd/mm/yyyy')),
-- comune_ricomparsa
         DECODE (t.descrizione,'', '',
           'a '||RTRIM (t.descrizione|| ' '|| f_provincia_stato (t.cod_provincia,t.cod_comune,t.sigla_provincia,'S','S'))),
-- pratica_ricomparsa
         DECODE (eve.pratica_ric, '', '','Pratica N. '|| eve.pratica_ric||'/'|| eve.anno_pratica_ric)
  FROM arcinp inp,
       arccom a,
       arccom b,
       arccom b1,
       arccom c,
       arccom d,
       arccom e,
       arccom f,
       arccom g,
       arccom h,
       arccom l,
       arccom t,
       arcvie vie,
       arcvie vie_11,
       anadci dci,
       anadsc dsc,
       anadrp drp,
       anadts dts,
       anadpr dpr,
       anaeve eve_11,
       anaeve eve_13,
       anawdi wdi,
       anastr str,
       anafam fam,
       anaeve eve,
       anaana ana
 WHERE inp.parametro = 'INTERNO'
   AND (a.cod_provincia, a.cod_comune) = (SELECT   pro_cliente, com_cliente FROM menuditta)
   AND b.cod_provincia(+) = ana.cod_pro_nas
   AND b.cod_comune(+) = ana.cod_com_nas
   AND b1.cod_provincia(+) = ana.cod_pro_atto_nas
   AND b1.cod_comune(+) = ana.cod_com_atto_nas
   AND c.cod_provincia(+) = ana.cod_pro_mat
   AND c.cod_comune(+) = ana.cod_com_mat
   AND d.cod_provincia(+) = ana.cod_pro_ved
   AND d.cod_comune(+) = ana.cod_com_ved
   AND e.cod_provincia(+) = ana.cod_pro_mor
   AND e.cod_comune(+) = ana.cod_com_mor
   AND f.cod_provincia(+) = eve.cod_pro_eve
   AND f.cod_comune(+) = eve.cod_com_eve
   AND g.cod_provincia(+) = fam.cod_pro_aire
   AND g.cod_comune(+) = fam.cod_com_aire
   AND h.cod_provincia(+) = wdi.cod_pro_ente_di
   AND h.cod_comune(+) = wdi.cod_com_ente_di
   AND l.cod_provincia(+) = str.cod_pro_ente_ds
   AND l.cod_comune(+) = str.cod_com_ente_ds
   AND t.cod_provincia(+) = eve.cod_pro_ric
   AND t.cod_comune(+) = eve.cod_com_ric
   AND vie_11.cod_via(+) = eve_11.cod_via
   AND vie.cod_via(+) = fam.cod_via
   AND fam.cod_fam(+) = ana.cod_fam
   AND fam.fascia(+) = ana.fascia
   AND dpr.cod_pr(+) = ana.cod_prof
   AND dpr.sesso(+) = ana.sesso
   AND dts.cod_ts(+) = ana.titolo_studio
   AND dci.cod_ci(+) = ana.nazionalita
   AND dsc.cod_sc(+) = ana.stato_civile
   AND dsc.sesso(+) = ana.sesso
   AND drp.cod_rp(+) = ana.rapporto_par
   AND drp.sesso(+) = ana.sesso
   AND wdi.matricola(+) = ana.matricola
   AND str.matricola(+) = ana.matricola
   AND eve_11.data_eve(+) = ana.data_ult_eve - 1
   AND eve_11.cod_mov(+) = 11
   AND eve_11.matricola(+) = ana.matricola
   AND eve_13.data_eve(+) = ana.data_ult_eve - 1
   AND eve_13.cod_mov(+) = 13
   AND eve_13.matricola(+) = ana.matricola
   AND eve.cod_mov(+) = ana.fascia
   AND eve.cod_eve(+) = ana.stato
   AND eve.data_eve(+) = ana.data_ult_eve
   AND eve.matricola(+) = ana.matricola
   AND ana.fascia + 0 IN (1, 2, 3, 4)
UNION
SELECT                                                      
-- cognome_nome
       REPLACE (ana.cognome_nome, '/', ' '),
-- paternita
       'pt. ' || REPLACE (paternita, '/', ' '),
-- maternita
       'mt. ' || REPLACE (maternita, '/', ' '),
-- residenza_fam
       DECODE (ana.fascia,1,'Residente a '||a.descrizione||' '|| 
                                 f_provincia_stato (a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S')||' '|| 
				 DECODE (ana.stato,1,'dalla nascita','dal '|| TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'),'dd/mm/yyyy')),
              		       2,DECODE (ana.stato,50,'Decedut' || DECODE (ana.sesso, 'M', 'o', 'a') || ' il ',
                  				   51, 'Emigrat' || DECODE (ana.sesso, 'M', 'o', 'a') || ' il ',
                  				   53,'Irreperibile dal ',
                     				'Cancellat'|| DECODE (ana.sesso, 'M', 'o', 'a')|| ' dall''A.P.R. il ')
               || TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
               || DECODE (ana.stato, 50, ' a ', 51, ' a ', '')
               || DECODE (ana.stato,50,e.descrizione|| ' '|| 
				f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S'),
                          51,f.descrizione|| ' '|| f_provincia_stato (f.cod_provincia,f.cod_comune,f.sigla_provincia,'S','S')),
               		  3,'Iscritto all''A.I.R.E. '|| 'dal '|| TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy'),
               		  4,DECODE (ana.stato,50,'Decedut' || DECODE (ana.sesso, 'M', 'o', 'a') || ' il ',
                  			      53,'Irreperibile dal ',
                     				'Cancellat'|| DECODE (ana.sesso, 'M', 'o', 'a')|| ' dall''A.I.R.E. il ')
               || TO_CHAR (TO_DATE (ana.data_ult_eve, 'j'), 'dd/mm/yyyy')
               || DECODE (ana.stato, 50, ' a ', '')
               || DECODE (ana.stato,50,e.descrizione|| ' '|| f_provincia_stato (e.cod_provincia,e.cod_comune,e.sigla_provincia,'S','S'))),
-- nat_oa
       DECODE (ana.sesso, 'M', 'nato', 'nata'),
-- data_nascita
       DECODE (anno_nas,
         'S', '00/00/' || TO_CHAR (TO_DATE (ana.data_nas, 'j'), 'yyyy'),
              TO_CHAR (TO_DATE (ana.data_nas, 'j'), 'dd/mm/yyyy')),
-- comune_nascita
       b.descrizione|| ' '|| f_provincia_stato (b.cod_provincia,b.cod_comune,b.sigla_provincia,'S','S'),
-- comune_atto_nascita
       DECODE (b1.descrizione, '', '',
         '- '|| b1.descrizione|| ' '|| f_provincia_stato (b1.cod_provincia,b1.cod_comune,b1.sigla_provincia,'S','S')),
-- atto_nascita
       decode(ana.atto_nas_digitale,'',
         'atto N. '|| TO_CHAR (ana.atto_nas)|| 
           ' p. '|| DECODE (ana.parte_nas,1,'I',2,'II')|| 
           DECODE (ana.serie_nas, '', '', ' s. ' || ana.serie_nas)|| 
           DECODE (ana.ufficio_nas, 0, '', '', '', ' uff. ' || TO_CHAR (ana.ufficio_nas))|| 
           ' / '|| TO_CHAR (ana.anno_atto_nas),
         'atto N. '|| ana.atto_nas_digitale),
-- stato_civile
       dsc.descrizione_cer,
-- coniugat_oa
       DECODE (ana.stato_civile,
         'CN', DECODE (ana.sesso, 'M', 'coniugato', 'coniugata'),
         'UC', DECODE (ana.sesso, 'M', 'unito civilmente', 'unita civilmente'),
                    ''),
-- cognome_nome_coniuge
         DECODE (ana.stato_civile,
           'CN', REPLACE (ana.cognome_nome_cn, '/', ' '),
           'VE', REPLACE (ana.cognome_nome_cn, '/', ' '),
           'UC', REPLACE (ana.cognome_nome_cn, '/', ' '),
           'VU', REPLACE (ana.cognome_nome_cn, '/', ' '),
                    ''),
-- estremi_mat_ved
         DECODE (ana.stato_civile,
           'CN', 'il '||DECODE (ana.anno_mat,
                          'S', '00/00/'||TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'yyyy'),
                               TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'dd/mm/yyyy'))|| 
                 ' a '||c.descrizione||' '||f_provincia_stato (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'),
           'VE', 'dal '||TO_CHAR (TO_DATE (ana.data_ved, 'j'), 'dd/mm/yyyy')|| 
                 ' a '||d.descrizione||' '||f_provincia_stato (d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S'),
           'UC', 'il '||DECODE (ana.anno_mat,
                          'S', '00/00/'||TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'yyyy'),
                               TO_CHAR (TO_DATE (ana.data_mat, 'j'), 'dd/mm/yyyy'))|| 
                 ' a '||c.descrizione||' '||f_provincia_stato (c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'),
           'VU', 'dal '||TO_CHAR (TO_DATE (ana.data_ved, 'j'), 'dd/mm/yyyy')|| 
                 ' a '||d.descrizione||' '||f_provincia_stato (d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S'),
                 ''),
-- atto_mat_ved
         DECODE (ana.stato_civile,
           'CN', decode(ana.atto_mat_digitale,'',
                   'atto N. '||TO_CHAR (ana.atto_mat)|| 
                     DECODE (ana.parte_mat, 1, ' p. I', 2, ' p. II')||DECODE (ana.serie_mat, '', '', ' s. ' || ana.serie_mat)|| 
                     DECODE (ana.ufficio_mat, 0, '', '', '', ' uff. ' || TO_CHAR (ana.ufficio_mat))|| 
                     DECODE (ana.anno_atto_mat, '', '', ' / ' || TO_CHAR (ana.anno_atto_mat)),
                   'atto N. '||ana.atto_mat_digitale),
           'VE', decode(ana.atto_ved_digitale,'',
                   'atto N. '||TO_CHAR (ana.atto_ved)|| 
                     DECODE (ana.parte_ved, 1, ' p. I', 2, ' p. II')|| 
                     DECODE (ana.serie_ved, '', '', ' s. ' || ana.serie_ved)|| 
                     DECODE (ana.ufficio_ved, 0, '', '', '', ' uff. ' || TO_CHAR (ana.ufficio_ved))|| 
                     DECODE (ana.anno_atto_ved, '', '', ' / ' || TO_CHAR (ana.anno_atto_ved)),
                   'atto N. '||ana.atto_ved_digitale),
           'UC', decode(ana.atto_mat_digitale,'',
                   'atto N. '||TO_CHAR (ana.atto_mat)|| 
                     DECODE (ana.parte_mat, 1, ' p. I', 2, ' p. II')||DECODE (ana.serie_mat, '', '', ' s. ' || ana.serie_mat)|| 
                     DECODE (ana.ufficio_mat, 0, '', '', '', ' uff. ' || TO_CHAR (ana.ufficio_mat))|| 
                     DECODE (ana.anno_atto_mat, '', '', ' / ' || TO_CHAR (ana.anno_atto_mat)),
                   'atto N. '||ana.atto_mat_digitale),
           'VU', decode(ana.atto_ved_digitale,'',
                   'atto N. '||TO_CHAR (ana.atto_ved)|| 
                     DECODE (ana.parte_ved, 1, ' p. I', 2, ' p. II')|| 
                     DECODE (ana.serie_ved, '', '', ' s. ' || ana.serie_ved)|| 
                     DECODE (ana.ufficio_ved, 0, '', '', '', ' uff. ' || TO_CHAR (ana.ufficio_ved))|| 
                     DECODE (ana.anno_atto_ved, '', '', ' / ' || TO_CHAR (ana.anno_atto_ved)),
                   'atto N. '||ana.atto_ved_digitale)
                 ),
-- titolo_studio
         dts.descrizione,
-- professione
         dpr.descrizione,
-- cittadinanza
         dci.descrizione,
-- cod_fiscale
         DECODE (ana.cod_fiscale, '', TO_CHAR (NULL), DECODE (ana.cf_calcolato, '', ana.cod_fiscale, TO_CHAR (NULL))),
-- estremi_ultimo_evento
         TO_CHAR (NULL),
-- pratica_ultimo_evento
         TO_CHAR (NULL),
-- matricola
         ana.matricola,
-- fascia
         DECODE (eve_f.cod_mov, 10, 1, 3) fascia,
-- cod_fam
         eve_f.cod_fam,
-- rapporto_parentela
         drp.descrizione,
-- sequenza_par
         drp.sequenza,
-- indirizzo_fam
         TO_CHAR (NULL) indirizzo_fam,
-- indirizzo_fam_int
         TO_CHAR (NULL) indirizzo_fam_int,
-- data_inizio_fam
         eve_f.data_inizio,
-- data_fine_fam
         eve_f.data_eve,
-- data_nas : per order by
         ana.data_nas,
-- rapporto_par
         eve_f.rapporto_par,
-- tipo_fam
         DECODE (eve_f.rapporto_par, 'CC', 1, 'IC', 1, TO_NUMBER (NULL)),
-- numero_di 
         wdi.numero_di,
-- data_di
         to_char(to_date(wdi.data_emissione_di,'j'),'dd/mm/yyyy'),
-- comune_di
         g.descrizione||' '||f_provincia_stato (g.cod_provincia,g.cod_comune,g.sigla_provincia,'S','S'),
-- scadenza_di
         to_char(to_date(wdi.data_scadenza_di,'j'),'dd/mm/yyyy'),
-- natura_di 
         wdi.natura_di,
-- numero_ds
         str.numero_ds,
-- data_ds
         to_char(to_date(str.data_emissione_ds,'j'),'dd/mm/yyyy'),
-- comune_ds
         l.descrizione||' '||f_provincia_stato (l.cod_provincia,l.cod_comune,l.sigla_provincia,'S','S'),
-- scadenza_ds
         to_char(to_date(str.data_scadenza_ds,'j'),'dd/mm/yyyy'),
-- natura_ds
         str.natura_ds,
-- data_ricomparsa
         decode(eve.data_ric, '', '',
           decode(ana.sesso,'M', 'ricomparso il ', 'ricomparsa il ')||TO_CHAR (TO_DATE (eve.data_ric, 'j'), 'dd/mm/yyyy')),
-- comune_ricomparsa
         DECODE (t.descrizione, '', '',
           'a '||RTRIM (t.descrizione|| ' '||f_provincia_stato (t.cod_provincia,t.cod_comune,t.sigla_provincia,'S','S'))),
-- pratica_ricomparsa
         DECODE (eve.pratica_ric,'','','Pratica N. '|| eve.pratica_ric||'/'|| eve.anno_pratica_ric)
  FROM arccom a,
       arccom b,
       arccom b1,
       arccom c,
       arccom d,
       arccom e,
       arccom f,
       arccom g,
       arccom l,
       arccom t,
       anadci dci,
       anadsc dsc,
       anadrp drp,
       anadts dts,
       anadpr dpr,
       anawdi wdi,
       anastr str,
       anaeve eve,
       anaana ana,
       anaeve eve_f
 WHERE (a.cod_provincia, a.cod_comune) = (SELECT   pro_cliente, com_cliente FROM menuditta)
   AND b.cod_provincia(+) = ana.cod_pro_nas
   AND b.cod_comune(+) = ana.cod_com_nas
   AND b1.cod_provincia(+) = ana.cod_pro_atto_nas
   AND b1.cod_comune(+) = ana.cod_com_atto_nas
   AND c.cod_provincia(+) = ana.cod_pro_mat
   AND c.cod_comune(+) = ana.cod_com_mat
   AND d.cod_provincia(+) = ana.cod_pro_ved
   AND d.cod_comune(+) = ana.cod_com_ved
   AND e.cod_provincia(+) = ana.cod_pro_mor
   AND e.cod_comune(+) = ana.cod_com_mor
   AND f.cod_provincia(+) = eve.cod_pro_eve
   AND f.cod_comune(+) = eve.cod_com_eve
   AND g.cod_provincia(+) = wdi.cod_pro_ente_di
   AND g.cod_comune(+) = wdi.cod_com_ente_di
   AND l.cod_provincia(+) = str.cod_pro_ente_ds
   AND l.cod_comune(+) = str.cod_com_ente_ds
   AND t.cod_provincia(+) = eve.cod_pro_ric
   AND t.cod_comune(+) = eve.cod_com_ric
   AND dpr.cod_pr(+) = ana.cod_prof
   AND dpr.sesso(+) = ana.sesso
   AND dts.cod_ts(+) = ana.titolo_studio
   AND dci.cod_ci(+) = ana.nazionalita
   AND dsc.cod_sc(+) = ana.stato_civile
   AND dsc.sesso(+) = ana.sesso
   AND dpr.cod_pr(+) = ana.cod_prof
   AND dpr.sesso(+) = ana.sesso
   AND drp.cod_rp = eve_f.rapporto_par
   AND drp.sesso = ana.sesso
   AND eve.cod_mov(+) = ana.fascia
   AND eve.cod_eve(+) = ana.stato
   AND eve.data_eve(+) = ana.data_ult_eve
   AND eve.matricola(+) = ana.matricola
   AND wdi.matricola(+) = ana.matricola
   AND str.matricola(+) = ana.matricola
   AND ana.matricola = eve_f.matricola
   AND eve_f.data_eve IS NOT NULL
   AND eve_f.data_inizio IS NOT NULL
   AND eve_f.cod_mov IN (10, 12)
/
comment on table cerfam is 'Certificazione - Dati Famiglia per Certificazione (view)'
/
