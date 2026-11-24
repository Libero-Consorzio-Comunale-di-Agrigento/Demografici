--liquibase formatted sql
--changeset amonopoli:202305051040 runAlways:true runOnChange:true stripComments:false
create or replace view cercpu
	(ufficio,anno,atto,parte,parte_edit,serie,serie_edit,
	 cognome_nome_sposo,cognome_sposo,nome_sposo,
         nato,
         data_nascita_sposo,comune_nascita_sposo,cap_comune_nascita_sposo,
	 residenza_sposo,cap_residenza_sposo,indirizzo_ana_sposo,
	 cognome_nome_sposa,cognome_sposa,nome_sposa,
         nata,
         data_nascita_sposa,comune_nascita_sposa,cap_comune_nascita_sposa,
	 residenza_sposa,cap_residenza_sposa,indirizzo_ana_sposa,
	 data_pubblicazioni,comune_data,comune,data,
	 anno_testata,giorno,mese,ore,minuti,ufficiale,
	 comune_matrimonio,
	 stato_civile_sposo,professione_sposo,cittadinanza_sposo,
	 stato_civile_sposa,professione_sposa,cittadinanza_sposa,
	 atto_nascita_sposo,parte_nascita_sposo,serie_nascita_sposo,
	 anno_atto_nascita_sposo,atto_nascita_sposo_edit,
         comune_atto_nascita_sposo,
	 atto_nascita_sposa,parte_nascita_sposa,serie_nascita_sposa,
	 anno_atto_nascita_sposa,atto_nascita_sposa_edit,
         comune_atto_nascita_sposa,
	 comune_affissione,da_data_affissione,a_data_affissione,
	 giorni_affissione,
	 comune_affissione_2,da_data_affissione_2,a_data_affissione_2,
	 data_rilascio,stat_oa,rilasciat_oa,certificato,
	 articolo,legge,
	 riga_documenti_1,riga_documenti_2,riga_documenti_3,
	 riga_documenti_4,riga_documenti_5,riga_documenti_6,
	 riga_documenti_7,riga_documenti_8,riga_documenti_9,
	 riga_documenti_10,riga_documenti_11,riga_documenti_12,
	 riga_documenti_13,riga_documenti_14,riga_documenti_15,
         autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	 frazione_prov, autorita_prov_ufficio,nota_rif,anno_nota_rif,data_nota_rif,
	 ufficiale_prov,qualifica_prov,
	 protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
         terminalista_atto)
as
select pub.ufficio,pub.anno,pub.atto,pub.parte,
       decode(pub.parte,1,'I',2,'II'),pub.serie,
       decode(pub.serie,'','','Serie '||pub.serie),
       translate(cognome_nome_m,'/',' '),
       substr(cognome_nome_m,1,instr(cognome_nome_m,'/')-1),
       substr(cognome_nome_m,instr(cognome_nome_m,'/')+1),
       'nato',
-- data_nascita_sposo
       decode(anno_nas_m,'S','00/00/'||TO_CHAR (TO_DATE (data_nas_m, 'j'), 'yyyy'),
       to_char(to_date(data_nas_m,'j'),'dd/mm/yyyy')),
-- comune_nascita_sposo
--    a.descrizione||decode(a.sigla_provincia,'','',' ('||a.sigla_provincia||')'),
    rtrim(nvl(a.descrizione_al1,a.descrizione)||' '||
            substr(f_provincia_stato(a.cod_provincia,a.cod_comune,a.sigla_provincia,'S','S'),1,100)),
-- cap_comune_nascita_sposo
    lpad(a.cap,5,'0'),
-- residenza_sposo
--    b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),
    rtrim(nvl(b.descrizione_al1,b.descrizione)||' '||
            substr(f_provincia_stato(b.cod_provincia,b.cod_comune,b.sigla_provincia,'S','S'),1,100)),
-- cap_residenza_sposo
    lpad(b.cap,5,'0'),
-- indirizzo_ana_sposo
     vie_m.denom_uff||fam_m.civico_esterno,
-- cognome_nome_sposa
       translate(cognome_nome_f,'/',' '),
       substr(cognome_nome_f,1,instr(cognome_nome_f,'/')-1),
       substr(cognome_nome_f,instr(cognome_nome_f,'/')+1),
       'nata',
       decode(anno_nas_f,'S','00/00/'||TO_CHAR (TO_DATE (data_nas_f,'j'), 'yyyy'),
       to_char(to_date(data_nas_f,'j'),'dd/mm/yyyy')),
--    c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')'),
    rtrim(nvl(c.descrizione_al1,c.descrizione)||' '||
            substr(f_provincia_stato(c.cod_provincia,c.cod_comune,c.sigla_provincia,'S','S'),1,100)),
-- cap_comune_nascita_sposa
    lpad(c.cap,5,'0'),
-- residenza_sposa
--    d.descrizione||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')'),
    rtrim(nvl(d.descrizione_al1,d.descrizione)||' '||
            substr(f_provincia_stato(d.cod_provincia,d.cod_comune,d.sigla_provincia,'S','S'),1,100)),
-- cap_residenza_sposa
    lpad(d.cap,5,'0'),
-- indirizzo_ana_sposa
     vie_f.denom_uff||fam_f.civico_esterno,
-- data_pubblicazioni
       to_char(to_date(data_pub,'j'),'dd/mm/yyyy'),
       e.descrizione||' '||to_char(sysdate,'dd/mm/yyyy'),
       e.descrizione,to_char(sysdate,'dd/mm/yyyy'),
--       decode(natura,'O',nvl(anno_testata,'_____________________'),
--                      nvl(anno_tr,'_____________________')),
    to_char(sysdate,'yyyy'),
--       decode(natura,'O',nvl(giorno,'_______________'),
--                         nvl(giorno_tr,'_______________')),
    to_char(sysdate,'dd'),
--       decode(natura,'O',nvl(mese,'_________________'),
--                         nvl(mese_tr,'_________________')),
    decode(to_char(sysdate,'mm'),
      '01','gennaio',
      '02','febbraio',
      '03','marzo',
      '04','aprile',
      '05','maggio',
      '06','giugno',
      '07','luglio',
      '08','agosto',
      '09','settembre',
      '10','ottobre',
      '11','novembre',
      '12','dicembre'),
--       decode(natura,'O',nvl(ore,'_______'),
--             nvl(ore_tr,'_______')),
    to_char(sysdate,'hh24'),
--       decode(natura,'O',decode(minuti,'','e minuti _______',
--                                          'e minuti '||minuti),
--             decode(minuti_tr,'','e minuti _______',
--                                             'e minuti '||minuti_tr)),
    'e minuti '||to_char(sysdate,'mi'),
       decode(natura,'O',nvl(ufficiale,
                         '_________________________________________'),
                 nvl(ufficiale_tr,
             '_________________________________________')),
-- comune matrimonio
       nvl(comune_pub,nvl(nvl(m.descrizione_al1,m.descrizione),'___________________________')),
-- stato_civile_sposo
--       nvl(stato_civile_m,'_________________________'),
       nvl(lower(f_get_descrizione_DSC(ana_m.stato_civile,ana_m.sesso,'','','')),'_________________________'),
       nvl(prof_m,'_________________________'),
-- cittadinanza_sposo
       nvl(cittadinanza_m,nvl(mdci.descrizione,'_________________________')),
-- stato_civile_sposa
--       nvl(stato_civile_f,'_________________________'),
       nvl(lower(f_get_descrizione_DSC(ana_f.stato_civile,ana_f.sesso,'','','')),'_________________________'),
       nvl(prof_f,'_________________________'),
-- cittadinanza_sposa
       nvl(cittadinanza_f,nvl(fdci.descrizione,'_________________________')),
-- atto_nascita_sposo
       nvl(to_char(atto_nas_m),'____'),
-- parte_nascita_sposo
       nvl(parte_nas_m,'____'),
-- serie_nascita_sposo
       nvl(serie_nas_m,'____'),
-- anno_atto_nascita_sposo
       nvl(to_char(anno_atto_nas_m),'____'),
-- atto_nascita_sposo_edit
     decode(spo.atto_nas_m,'',to_char(null),
       'atto N. '||spo.atto_nas_m||' p.'||spo.parte_nas_m||
       decode(spo.serie_nas_m,'',to_char(null),' s.'||spo.serie_nas_m)||
       decode(spo.anno_atto_nas_m,'',to_char(null),' / '||spo.anno_atto_nas_m)),
-- comune_atto_nascita_sposo
     DECODE (spo.com_atto_nas_m,'', TO_CHAR (NULL),spo.com_atto_nas_m),
-- atto_nascita_sposa
       nvl(to_char(atto_nas_f),'____'),
-- parte_nascita_sposa
       nvl(parte_nas_f,'____'),
-- serie_nascita_sposa
       nvl(serie_nas_f,'____'),
-- anno_atto_nascita_sposa
       nvl(to_char(anno_atto_nas_f),'____'),
-- atto_nascita_sposa_edit
     decode(spo.atto_nas_f,'',to_char(null),
       'atto N. '||spo.atto_nas_f||' p.'||spo.parte_nas_f||
       decode(spo.serie_nas_f,'',to_char(null),' s.'||spo.serie_nas_f)||
       decode(spo.anno_atto_nas_f,'',to_char(null),' / '||spo.anno_atto_nas_f)),
-- comune_atto_nascita_sposa
     DECODE (spo.com_atto_nas_f,'', TO_CHAR (NULL),spo.com_atto_nas_f),
-- comune_affissione
    mar.comune_aff_1,
-- da_data_affissione
    to_char(to_date(mar.da_data_aff_1,'j'),'dd/mm/yyyy'),
-- a_data_affissione
    to_char(to_date(mar.a_data_aff_1,'j'),'dd/mm/yyyy'),
-- giorni_affissione
    nvl(mar.giorni_aff_2,8),
-- comune_affissione_2
    mar.comune_aff_2,
-- da_data_affissione_2
    to_char(to_date(mar.da_data_aff_2,'j'),'dd/mm/yyyy'),
-- a_data_affissione_1
    to_char(to_date(mar.a_data_aff_2,'j'),'dd/mm/yyyy'),
-- data_rilascio
       decode(mar.data_ril,'','\ \ \ \ \ \ \ \ ',
       lpad(ecl.chiave,2,0)||'/'||
       decode(upper(rtrim(substr(mar.data_ril,(instr(mar.data_ril,' ') + 1)))),
          'GENNAIO','01',
          'FEBBRAIO','02',
          'MARZO','03',
          'APRILE','04',
          'MAGGIO','05',
          'GIUGNO','06',
          'LUGLIO','07',
          'AGOSTO','08',
          'SETTEMBRE','09',
          'OTTOBRE','10',
          'NOVEMBRE','11',
          'DICEMBRE','12','')||'/'||lpad(fcl.chiave,2,0)),
-- stat_oa
     'stat'||mar.stato,'rilasciat'||mar.rilasciato,
     mar.certificato,mar.articolo,mar.legge,
     nvl(pdo.riga1,rpad('_',70,'_')),nvl(pdo.riga2,rpad('_',70,'_')),
     nvl(pdo.riga3,rpad('_',70,'_')),nvl(pdo.riga4,rpad('_',70,'_')),
     nvl(pdo.riga5,rpad('_',70,'_')),nvl(pdo.riga6,rpad('_',70,'_')),
     nvl(pdo.riga7,rpad('_',70,'_')),nvl(pdo.riga8,rpad('_',70,'_')),
     nvl(pdo.riga9,rpad('_',70,'_')),nvl(pdo.riga10,rpad('_',70,'_')),
     nvl(pdo.riga11,rpad('_',70,'_')),nvl(pdo.riga12,rpad('_',70,'_')),
     nvl(pdo.riga13,rpad('_',70,'_')),nvl(pdo.riga14,rpad('_',70,'_')),
     pdo.riga15,
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
-- terminalista_atto
         pub.terminalista
  from arccom a,arccom b,arccom c,arccom d,arccom e,arccom m,
       cilet ecl,cilet fcl,
     arcvie vie_m,arcvie vie_f,
     anafam fam_m,anafam fam_f,
     anaana ana_m,anaana ana_f,civana ana,
       civpdo pdo,civspo spo,civtes tes,civttr ttr,civmar mar,
     civdpa dpa,civpub pub,anadci mdci, anadci fdci
 where m.cod_provincia (+)     = pub.cod_pro_mat
   and m.cod_comune    (+)       = pub.cod_com_mat
   and vie_m.cod_via    (+)        = fam_m.cod_via
   and fam_m.fascia    (+)        = ana_m.fascia
   and fam_m.cod_fam    (+)        = ana_m.cod_fam
   and ana_m.fascia    (+)        = 1
   and ana_m.matricola    (+)        = ana.matricola_1
   and vie_f.cod_via    (+)        = fam_f.cod_via
   and fam_f.fascia    (+)        = ana_f.fascia
   and fam_f.cod_fam    (+)        = ana_f.cod_fam
   and ana_f.fascia    (+)        = 1
   and ana_f.matricola    (+)        = ana.matricola_2
   and ana.ufficio    (+)        = pub.ufficio
   and ana.anno        (+)        = pub.anno
   and ana.atto        (+)        = pub.atto
   and ana.parte        (+)        = pub.parte
   and nvl(ana.serie(+),' ')      = nvl(pub.serie,' ')
   and ana.tipo_atto    (+)         = 3
   and mdci.cod_ci   (+)      = pub.nazionalita_m
   and fdci.cod_ci   (+)    = pub.nazionalita_f
   and dpa.tipo_atto (+)    = 3
   and nvl(dpa.serie(+),' ')     = nvl(pub.serie,' ')
   and dpa.parte     (+)        = pub.parte
   and dpa.atto     (+)        = pub.atto
   and dpa.anno     (+)        = pub.anno
   and dpa.ufficio     (+)    = pub.ufficio
   and tes.parte     (+)         = spo.parte
   and nvl(tes.serie(+),' ')    = nvl(spo.serie,' ')
   and tes.atto     (+)         = spo.atto
   and tes.anno     (+)        = spo.anno
   and tes.ufficio      (+)    = spo.ufficio
   and tes.tipo_atto     (+)    = 3
   and nvl(ttr.serie(+),' ')     = nvl(spo.serie,' ')
   and ttr.parte     (+)        = spo.parte
   and ttr.atto     (+)        = spo.atto
   and ttr.anno     (+)        = spo.anno
   and ttr.ufficio     (+)    = spo.ufficio
   and ttr.tipo_atto     (+)    = 3
   and nvl(pdo.serie(+),' ')     = nvl(pub.serie,' ')
   and pdo.parte     (+)        = pub.parte
   and pdo.atto     (+)        = pub.atto
   and pdo.anno     (+)        = pub.anno
   and pdo.ufficio     (+)    = pub.ufficio
   and nvl(spo.serie(+),' ')     = nvl(pub.serie,' ')
   and spo.parte     (+)        = pub.parte
   and spo.atto     (+)        = pub.atto
   and spo.anno     (+)        = pub.anno
   and spo.ufficio     (+)    = pub.ufficio
   and spo.tipo_atto     (+)    = 3
   and ecl.lettere (+)        = decode(upper(substr(mar.data_ril,1,
                         instr(mar.data_ril,' ')-1)),
                         'UNO','UN',
                         upper(substr(mar.data_ril,1,
                         instr(mar.data_ril,' ')-1)))
   and ecl.tipo    (+)        = 'U'
   and nvl(fcl.lettere(+),' ')  = decode(upper(nvl(mar.anno_ril,' ')),
                     'UNO','UN',
                      upper(nvl(mar.anno_ril,' ')))
   and fcl.tipo    (+)        = 'U'
   and nvl(mar.serie(+),' ')         = nvl(pub.serie,' ')
   and mar.parte     (+)        = pub.parte
   and mar.atto     (+)        = pub.atto
   and mar.anno     (+)        = pub.anno
   and mar.ufficio     (+)        = pub.ufficio
   and mar.tipo_atto     (+)        = 3
   and a.cod_comune                       = pub.cod_com_nas_m
   and a.cod_provincia                    = pub.cod_pro_nas_m
   and b.cod_comune     (+)               = pub.cod_com_res_m
   and b.cod_provincia  (+)               = pub.cod_pro_res_m
   and c.cod_comune                       = pub.cod_com_nas_f
   and c.cod_provincia                    = pub.cod_pro_nas_f
   and d.cod_comune     (+)               = pub.cod_com_res_f
   and d.cod_provincia  (+)               = pub.cod_pro_res_f
   and (e.cod_provincia,e.cod_comune)     =
     (select pro_cliente,com_cliente from menuditta)
   and pub.cod_rec                  in (0,3)
/
comment on table cercpu is 'Stato Civile - Dati Verbali di Pubblicazione per Comunicazioni (view)'
/
