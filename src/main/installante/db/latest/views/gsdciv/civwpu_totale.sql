--liquibase formatted sql
--changeset snocca:202301021600 runAlways:true runOnChange:true stripComments:false
create or replace view civwpu_totale
 	(COD_REC, UFFICIO, ANNO, ATTO, PARTE, SERIE, NATURA,
  	 ANNO_OGGI, MESE_OGGI,GIORNO_OGGI, ORE_OGGI, MINUTI_OGGI,
	 DATA_PUBBLICAZIONE,
	 ANNO_PUBBLICAZIONE, MESE_PUBBLICAZIONE, GIORNO_PUBBLICAZIONE,
         COGNOME_NOME_SPOSO, COGNOME_SPOSO, NOME_SPOSO, DATA_NASCITA_SPOSO, 
	 ANNO_NASCITA_SPOSO, MESE_NASCITA_SPOSO, GIORNO_NASCITA_SPOSO,
	 ATTO_NASCITA_SPOSO, COMUNE_NASCITA_SPOSO, 
	 COMUNE_RESIDENZA_SPOSO,
	 NAZIONALITA_SPOSO, PROFESSIONE_SPOSO, STATO_CIVILE_SPOSO,
         COGNOME_NOME_SPOSA, COGNOME_SPOSA, NOME_SPOSA, DATA_NASCITA_SPOSA, 
	 ANNO_NASCITA_SPOSA, MESE_NASCITA_SPOSA, GIORNO_NASCITA_SPOSA,
	 ATTO_NASCITA_SPOSA, COMUNE_NASCITA_SPOSA, 
	 COMUNE_RESIDENZA_SPOSA,
	 NAZIONALITA_SPOSA, PROFESSIONE_SPOSA, STATO_CIVILE_SPOSA,
	 COMUNE_DATA,COMUNE,DATA,COMUNE_MATRIMONIO,
         autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	frazione_prov, autorita_prov_ufficio,nota_rif,anno_nota_rif,data_nota_rif,
	 ufficiale_prov,qualifica_prov,
	 protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
	 ufficiale_utente,
         COMUNE_ESTRATTO_SPOSO, DATA_ESTRATTO_SPOSO,
         COMUNE_CUMULATIVO_SPOSO, DATA_CUMULATIVO_SPOSO,
         COMUNE_ESTRATTO_SPOSA, DATA_ESTRATTO_SPOSA,
         COMUNE_CUMULATIVO_SPOSA, DATA_CUMULATIVO_SPOSA,
         PRESA_VISIONE_DOCUMENTI,
         COMUNE_AFFISSIONE_PUB_1, DA_DATA_AFFISSIONE_PUB_1, A_DATA_AFFISSIONE_PUB_1,
         COMUNE_AFFISSIONE_PUB_2, DA_DATA_AFFISSIONE_PUB_2, A_DATA_AFFISSIONE_PUB_2)
as
select pub.cod_rec, pub.ufficio, pub.anno, pub.atto, pub.parte, pub.serie, pub.natura,
-- anno_oggi
       f_CIV_campi_testata(3,pub.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'anno_oggi'),
-- mese_oggi
       f_CIV_campi_testata(3,pub.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'mese_oggi'),
-- giorno_oggi
       f_CIV_campi_testata(3,pub.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'giorno_oggi'),
-- ore_oggi
       f_CIV_campi_testata(3,pub.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ore_oggi'),
-- minuti_oggi
       f_CIV_campi_testata(3,pub.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'minuti_oggi'),
-- data_pubblicazione
       f_CIV_cifre_lettere('D',to_char(pub.d_data_pub,'dd/mm/yyyy'),inp.valore,'S'),
-- anno_pubblicazione
       f_CIV_cifre_lettere('A',to_char(pub.d_data_pub,'yyyy'),'','S'),
-- mese_pubblicazione
       f_CIV_cifre_lettere('M',to_char(pub.d_data_pub,'mm'),'','S'),
-- giorno_pubblicazione
       f_CIV_cifre_lettere('G',to_char(pub.d_data_pub,'dd'),inp.valore,'S'),
-- cognome_nome_sposo
       translate(pub.cognome_nome_m,'/',' '),
-- cognome_sposo
       pub.cognome_m,
-- nome_sposo
       pub.nome_m,
-- data_nascita_m
       f_CIV_cifre_lettere('D',to_char(pub.d_data_nas_m,'dd/mm/yyyy'),inp.valore,'S'),
-- anno_nascita_m
       f_CIV_cifre_lettere('A',to_char(pub.d_data_nas_m,'yyyy'),'','S'),
-- mese_nascita_m
       f_CIV_cifre_lettere('M',to_char(pub.d_data_nas_m,'mm'),'','S'),
-- giorno_nascita_m
       f_CIV_cifre_lettere('G',to_char(pub.d_data_nas_m,'dd'),inp.valore,'S'),
-- atto_nascita_m
       'Atto N. '||nvl(to_char(spo.atto_nas_m),'____')||
          ' P. '||decode(spo.parte_nas_m,'1','I','2','II',nvl(spo.parte_nas_m,'__'))||
          ' S. '||nvl(spo.serie_nas_m,'__')||
          ' - '||nvl(to_char(spo.anno_atto_nas_m),'____'),
-- comune_nascita_m
       f_comune_al(pub.cod_pro_nas_m,pub.cod_com_nas_m,pub.data_nas_m)||' '||
         f_provincia_stato_al(pub.cod_pro_nas_m,pub.cod_com_nas_m,null,'S','S',pub.data_nas_m),
-- comune_residenza_m
       f_comune_al(pub.cod_pro_res_m,pub.cod_com_res_m,pub.data_pub)||' '|| 
         f_provincia_stato_al(pub.cod_pro_res_m,pub.cod_com_res_m,'','S','S',pub.data_pub),
-- nazionalita_m
       nvl(lower(f_get_descrizione_DCI(pub.nazionalita_m,'')),rpad('...',20,'_')),
-- professione_m
       rpad('...',20,'_'),
-- stato_civile_m
       nvl(lower(f_get_descrizione_DSC(ana_1.stato_civile,ana_1.sesso,'','','')),'______'),
-- cognome_nome_sposa
       translate(pub.cognome_nome_f,'/',' '),
-- cognome_sposa
       pub.cognome_f,
-- nome_sposa
       pub.nome_f,
-- data_nascita_f
       f_CIV_cifre_lettere('D',to_char(pub.d_data_nas_f,'dd/mm/yyyy'),inp.valore,'S'),
-- anno_nascita_f
       f_CIV_cifre_lettere('A',to_char(pub.d_data_nas_f,'yyyy'),'','S'),
-- mese_nascita_f
       f_CIV_cifre_lettere('M',to_char(pub.d_data_nas_f,'mm'),'','S'),
-- giorno_nascita_f
       f_CIV_cifre_lettere('G',to_char(pub.d_data_nas_f,'dd'),inp.valore,'S'),
-- atto_nascita_f
       'Atto N. '||nvl(to_char(spo.atto_nas_f),'____')||
          ' P. '||decode(spo.parte_nas_f,'1','I','2','II',nvl(spo.parte_nas_f,'__'))||
          ' S. '||nvl(spo.serie_nas_f,'__')||
          ' - '||nvl(to_char(spo.anno_atto_nas_f),'____'),
-- comune_nascita_f
       f_comune_al(pub.cod_pro_nas_f,pub.cod_com_nas_f,pub.data_nas_f)||' '||
         f_provincia_stato_al(pub.cod_pro_nas_f,pub.cod_com_nas_f,null,'S','S',pub.data_nas_f),
-- comune_residenza_f
       f_comune_al(pub.cod_pro_res_f,pub.cod_com_res_f,pub.data_pub)||' '|| 
         f_provincia_stato_al(pub.cod_pro_res_f,pub.cod_com_res_f,'','S','S',pub.data_pub),
-- nazionalita_f
       nvl(lower(f_get_descrizione_DCI(pub.nazionalita_f,'')),rpad('...',20,'_')),
-- professione_f
       rpad('...',20,'_'),
-- stato_civile_f
       nvl(lower(f_get_descrizione_DSC(ana_2.stato_civile,ana_2.sesso,'','','')),'______'),
-- comune_data
       f_get_comune_cliente('DES_COM')||', '||to_char(sysdate,'dd/mm/yyyy'),
-- comune
       f_get_comune_cliente('DES_COMUNE'),
-- data
       to_char(sysdate,'dd/mm/yyyy'),
-- comune_matrimonio
       nvl(tes.comune_pub,
         f_comune_al(pub.cod_pro_mat,pub.cod_com_mat,pub.data_pub)||' '|| 
           f_provincia_stato_al(pub.cod_pro_mat,pub.cod_com_mat,'','S','S',pub.data_pub)),
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
-- ufficiale_utente
       nvl(f_CIV_campi_testata(3,pub.natura,cta.sigla,inp.valore,
                             dpa.d_data_atto_utente,dpa.ore_atto_utente,dpa.minuti_atto_utente,dpa.ufficiale_utente,dpa.qualifica_utente,
                             dpa.d_data_atto_orig,dpa.ore_atto_orig,dpa.minuti_atto_orig,dpa.cod_pro_atto_orig,dpa.cod_com_atto_orig,
                             dpa.ufficiale_prov,dpa.qualifica_prov,dpa.d_data_protocollo,'','','',
                             tes.anno_testata,tes.giorno,tes.mese,tes.ore,tes.minuti,tes.ubicazione,tes.ufficiale,tes.comune,tes.motivo,'','','',
                             ttr.anno_tr,ttr.giorno_tr,ttr.mese_tr,ttr.ore_tr,ttr.minuti_tr,ttr.ubicazione_tr,ttr.ufficiale_tr,ttr.comune_tr,ttr.motivo_tr,ttr.data_tr,ttr.comune_or,
                             '','','',
                             'ufficiale_utente'),rpad('...',30,'_')),
-- COMUNE_ESTRATTO_SPOSO
       f_comune_al(pdo.cod_pro_estratto_m,pdo.cod_com_estratto_m,'')||' '||
         f_provincia_stato_al(pdo.cod_pro_estratto_m,pdo.cod_com_estratto_m,'','S','S',''),
-- DATA_ESTRATTO_SPOSO
       to_char(pdo.d_data_estratto_m,'dd/mm/yyyy'),
-- COMUNE_CUMULATIVO_SPOSO
       f_comune_al(pdo.cod_pro_cumulativo_m,pdo.cod_com_cumulativo_m,'')||' '||
         f_provincia_stato_al(pdo.cod_pro_cumulativo_m,pdo.cod_com_cumulativo_m,'','S','S',''),
-- DATA_CUMULATIVO_SPOSO
       to_char(pdo.d_data_cumulativo_m,'dd/mm/yyyy'),
-- COMUNE_ESTRATTO_SPOSA
       f_comune_al(pdo.cod_pro_estratto_f,pdo.cod_com_estratto_f,'')||' '||
         f_provincia_stato_al(pdo.cod_pro_estratto_f,pdo.cod_com_estratto_f,'','S','S',''),
-- DATA_ESTRATTO_SPOSA
       to_char(pdo.d_data_estratto_f,'dd/mm/yyyy'),
-- COMUNE_CUMULATIVO_SPOSA
       f_comune_al(pdo.cod_pro_cumulativo_f,pdo.cod_com_cumulativo_f,'')||' '||
         f_provincia_stato_al(pdo.cod_pro_cumulativo_f,pdo.cod_com_cumulativo_f,'','S','S',''),
-- DATA_CUMULATIVO_SPOSA
       to_char(pdo.d_data_cumulativo_f,'dd/mm/yyyy'),
-- PRESA_VISIONE_DOCUMENTI
       nvl(rtrim(ltrim(
         decode(pdo.flag_documenti_prodotti,'','','prodottimi,')||
         decode(pdo.flag_documenti_acquisiti,'','',' da me acquisiti,')||
         decode(pdo.flag_documenti_presa_visione,'','',' di cui ho preso visione')),','),
        '[] prodottimi [] da me acquisiti [] di cui ho preso visione'),
-- COMUNE_AFFISSIONE_PUB_1
       f_comune_al(mar.cod_pro_aff_1,mar.cod_com_aff_1,'')||' '||
         f_provincia_stato_al(mar.cod_pro_aff_1,mar.cod_com_aff_1,'','S','S',''),
-- DA_DATA_AFFISSIONE_PUB_1
       to_char(mar.d_da_data_aff_1,'dd/mm/yyyy'),
-- A_DATA_AFFISSIONE_PUB_1
       to_char(mar.d_a_data_aff_1,'dd/mm/yyyy'),
-- COMUNE_AFFISSIONE_PUB_2
       f_comune_al(mar.cod_pro_aff_2,mar.cod_com_aff_2,'')||' '||
         f_provincia_stato_al(mar.cod_pro_aff_2,mar.cod_com_aff_2,'','S','S',''),
-- DA_DATA_AFFISSIONE_PUB_2
       to_char(mar.d_da_data_aff_2,'dd/mm/yyyy'),
-- A_DATA_AFFISSIONE_PUB_2
       to_char(mar.d_a_data_aff_2,'dd/mm/yyyy')
  from arcinp inp,
       civcta cta, civdta dta,
       anaana ana_1, anaana ana_2, civana ana, 
       civmar mar,
       civpdo pdo, civdpa dpa, 
       civtes tes, civttr ttr,
       civspo spo,
       civpub pub
 where inp.parametro       = 'ATTI_PRIMO'
   and cta.id          (+) = dta.id_civcta
   and dta.id          (+) = pub.id_civdta
   and ana_1.matricola (+) = ana.matricola_1
   and ana_2.matricola (+) = ana.matricola_2
   and ana.id_atto     (+) = pub.id_atto
   and mar.id_atto     (+) = pub.id_atto
   and pdo.id_atto     (+) = pub.id_atto
   and dpa.id_atto     (+) = pub.id_atto
   and tes.id_atto     (+) = pub.id_atto
   and ttr.id_atto     (+) = pub.id_atto
   and spo.id_atto     (+) = pub.id_atto
--
   and pub.cod_rec         in (0,3)
/
comment on table civwpu_totale is 'Stato Civile - Variabili per composizione Verbali di Pubblicazione'
/
