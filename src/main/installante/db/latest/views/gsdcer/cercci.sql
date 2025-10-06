--liquibase formatted sql
--changeset amonopoli:202301130940 runOnChange:true stripComments:false
create or replace view cercci 
	(ufficio,anno,atto,parte,serie,
         NUMERO_ATTO_ANSC,
	 acquisto_perdita,iscr_canc,
	 l_acquisto_la_perdita,
	 cognome_nome,cognome,nome,data_nascita,
	 ufficio_nascita,anno_atto_nascita,atto_nascita,parte_nascita,serie_nascita,
         NUMERO_ATTO_ANSC_NASCITA,
         comune_nascita,cap_comune_nascita,
         comune_atto_nascita,cap_comune_atto_nascita,
	 residenza,cap_residenza,indirizzo_ana,
	 data_cittadinanza,
         data_richiesta,data_giuramento,data_decorrenza,
         GIURAMENTO_UFFICIO, GIURAMENTO_ANNO, GIURAMENTO_ATTO, 
         GIURAMENTO_NUMERO_ATTO_ANSC,
         decreto_numero,decreto_data,decreto_data_notifica,decreto_firmato,
         comune_data,comune,data,
	 autorita_prov, autorita_prov_da, autorita_prov_in, comune_prov, autorita_prov_comune,
	 frazione_prov, autorita_prov_ufficio,nota_rif,anno_nota_rif,
	 data_nota_rif,ufficiale_prov,qualifica_prov,
	 protocollo_prov,anno_protocollo_prov,data_protocollo_prov,
         ente_straniero, comune_ente_straniero, stato_ente_straniero, data_atto_ente_straniero,
         tipo_atto_ente_straniero, estremi_atto_ente_straniero, 
         terminalista_atto,
	 flag_comune_estero_res,
         ID_ATTO, NUMERO_UNICO_COMUNALE)
AS
SELECT cit.ufficio,
       cit.anno,
       cit.atto,
       '0',
       ' ',
       f_CIV_numero_atto_ansc(cit.id_atto_ansc, cit.numero_unico),
       DECODE (natura,
                    'A', 'ACQUISTO',
                    'P', 'PERDITA',
                    '_______________'),
       DECODE (natura,
                    'A', 'dell''iscrizione',
                    'P', 'della cancellazione',
                    '_______________'),
       DECODE (natura,
                    'A', 'l''acquisto',
                    'P', 'la perdita',
                    '_______________'),
       decode(occ.atto, '', TRANSLATE (cit.cognome_nome, '/', ' '), occ.cognome||' '||occ.nome),
	   decode(occ.atto, '', cit.cognome, occ.cognome),
	   decode(occ.atto, '', cit.nome, occ.nome),
       decode(nvl(cit.flag_gg_imprecisato_nas,'N') || nvl(cit.flag_mm_imprecisato_nas,'N') || nvl(cit.flag_aa_imprecisato_nas,'N'), 
                'SSS', '00/00/0000',
                'SSN', '00/00/' || TO_CHAR (TO_DATE (cit.data_nas, 'j'), 'yyyy'),
                'SNN', '00/' || TO_CHAR (TO_DATE (cit.data_nas, 'j'), 'mm/yyyy'),
          DECODE (cit.anno_nas,'S','00/00/' || TO_CHAR (TO_DATE (cit.data_nas, 'j'), 'yyyy'), TO_CHAR (TO_DATE (cit.data_nas, 'j'), 'dd/mm/yyyy'))),
-- ufficio_nascita
      decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', mar.ufficio_nas),
-- anno_atto_nascita
      decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', mar.anno_nas),
-- atto_nascita
      decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', to_char(mar.atto_nas), mar.id_atto_ansc_nas),
-- parte_nascita
      decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', mar.parte_nas),
-- serie_nascita
      decode(f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas), '', mar.serie_nas),
-- numero_atto_ansc_nascita
      f_CIV_numero_atto_ansc(mar.id_atto_ansc_nas),
-- comune_nascita
       RTRIM (   nvl(a.descrizione_al1,a.descrizione)
                   || ' '
                   || f_provincia_stato (a.cod_provincia,
                                         a.cod_comune,
                                         a.sigla_provincia,
                                         'S',
                                         'S')),
-- cap_comune_nascita
       LPAD (a.cap, 5, '0'),
-- comune_atto_nascita
        decode(mar.cod_pro_atto_nas||mar.cod_com_atto_nas,'','',nvl(com_atto_nas.descrizione_al1,com_atto_nas.descrizione)),
-- cap_comune_atto_nascita
        decode(mar.cod_pro_atto_nas||mar.cod_com_atto_nas,'','',lpad(com_atto_nas.cap,5,'0')),
-- residenza
       RTRIM (   nvl(b.descrizione_al1,b.descrizione)
                   || ' '
                   || f_provincia_stato (b.cod_provincia,
                                         b.cod_comune,
                                         b.sigla_provincia,
                                         'S',
                                         'S')),
-- cap_residenza
       LPAD (b.cap, 5, '0'),
-- indirizzo_ana
       vie.denom_uff || fam.civico_esterno,
-- data_cittadinanza
       TO_CHAR (TO_DATE (data_cit, 'j'), 'dd/mm/yyyy'),
-- data_richiesta
       TO_CHAR (d_data_richiesta, 'dd/mm/yyyy'),
-- data_giuramento
       TO_CHAR (TO_DATE (data_cit, 'j'), 'dd/mm/yyyy'),
-- data_decorrenza
       TO_CHAR (d_data_decorrenza, 'dd/mm/yyyy'),
-- giuramento_ufficio
       decode(f_CIV_numero_atto_ansc(dpa.GIURAMENTO_ID_ATTO_ANSC), '', dpa.GIURAMENTO_UFFICIO), 
-- giuramento_anno
       decode(f_CIV_numero_atto_ansc(dpa.GIURAMENTO_ID_ATTO_ANSC), '', dpa.GIURAMENTO_ANNO), 
-- giuramento_atto
       decode(f_CIV_numero_atto_ansc(dpa.GIURAMENTO_ID_ATTO_ANSC), '', to_char(dpa.GIURAMENTO_ATTO), dpa.GIURAMENTO_ID_ATTO_ANSC),
-- giuramento_numero_atto_ansc
       f_CIV_numero_atto_ansc(dpa.GIURAMENTO_ID_ATTO_ANSC),
-- decreto_numero
       dpa.sentenza_numero,
-- decreto_data
       TO_CHAR (dpa.d_sentenza_data, 'dd/mm/yyyy'),
-- decreto_data_notifica
       TO_CHAR (dpa.d_sentenza_data_notifica, 'dd/mm/yyyy'),
-- decreto_firmato
       dpa.sentenza_tribunale,
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
       dpa.frazione_prov,-- nota rif.
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
-- terminalista_atto
       terminalista,
-- flag_comune_estero_res
       DECODE (SIGN (cit.cod_pro_res - 199), -1, TO_CHAR (NULL), 'S'),
-- id_atto
       cit.id_atto,
-- numero_unico_comunale
       f_CIV_numero_unico_comunale(cit.numero_unico)
  FROM arccom a, arccom b, arccom c,
       arccom com_atto_nas,
       arcvie vie, anafam fam, anaana ana, civana civ,
       civmar mar, civdpa dpa,
       civcit cit, civocc occ
 WHERE a.cod_comune      = cit.cod_com_nas
   AND a.cod_provincia   = cit.cod_pro_nas
   AND b.cod_comune      = cit.cod_com_res
   AND b.cod_provincia   = cit.cod_pro_res
   AND com_atto_nas.cod_comune    (+) = mar.cod_com_atto_nas
   AND com_atto_nas.cod_provincia (+) = mar.cod_pro_atto_nas
   AND (c.cod_provincia, c.cod_comune) = (SELECT   pro_cliente, com_cliente FROM menuditta)
   AND vie.cod_via   (+) = fam.cod_via
   AND fam.fascia    (+) = ana.fascia
   AND fam.cod_fam   (+) = ana.cod_fam
   AND ana.fascia    (+) = 1
   AND ana.matricola (+) = civ.matricola_1
   AND civ.id_atto   (+) = cit.id_atto
   AND mar.id_atto   (+) = cit.id_atto
   AND dpa.id_atto   (+) = cit.id_atto
   AND occ.id_atto   (+) = cit.id_atto
/
comment on table cercci is 'Stato Civile - Dati Atti di Cittadinanza per Comunicazioni'
/
