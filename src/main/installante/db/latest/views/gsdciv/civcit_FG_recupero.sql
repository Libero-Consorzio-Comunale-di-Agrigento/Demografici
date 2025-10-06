--liquibase formatted sql
--changeset ftravaglini:202307171540 runAlways:true runOnChange:true stripComments:false
CREATE OR REPLACE VIEW civcit_fg_recupero
AS
SELECT cit.ID_ATTO,
       CIT.UFFICIO, CIT.ANNO, CIT.ATTO, CIT.NATURA, CIT.DATA_CIT,
       ANA_FG.MATRICOLA, ANA_FG.COGNOME_NOME, 
       ANA_FG.DATA_NAS, ANA_FG.ANNO_NAS, ANA_FG.COD_PRO_NAS, ANA_FG.COD_COM_NAS, ana_fg.sesso,
       ana_fg.paternita, ana_fg.maternita, ana_fg.nazionalita, ana_fg.rapporto_par, ana_fg.sequenza_par,
       M.COD_PROVINCIA COD_PRO_RES, M.COD_COMUNE COD_COM_RES,
       civ_fg.UFFICIO ufficio_fg, civ_fg.ANNO anno_fg, civ_fg.ATTO atto_fg,
       CIT.d_DATA_CIT,
       to_date(ANA_FG.DATA_NAS,'j') d_data_nas,
       f_get_descrizione_DCI(ana_fg.nazionalita,ana_fg.sesso) des_nazionalita,
       f_get_descrizione_DRP(ana_fg.rapporto_par,ana_fg.sesso) des_rapporto_par,
-- id_civdta
       (select min(d.id) from civcta c, civdta d where d.tipo_atto = 1 and d.id_civcta = c.id and c.sigla = 'ASM') id_civdta
  FROM arccom m
     , CIVANA CIV_fg
     , ANAANA ANA_FG
     , ANAANA ANA
     , CIVANA_recupero CIV
     , CIVCIT CIT
 WHERE (m.cod_provincia, m.cod_comune) = 
       (select pro_cliente, com_cliente from menuditta)
   and civ_fg.matricola_1 (+) = ana_fg.matricola
   and civ_fg.tipo_atto   (+) = 1
   and add_months(to_date(ana_fg.data_nas,'j'),216) > trunc(sysdate)
   and ana_FG.MATRICOLA    != ANA.MATRICOLA
   and ana_FG.nazionalita  != 'I'
   and ana_FG.RAPPORTO_PAR = 'FG'
   and ana_FG.COD_FAM      = ANA.COD_FAM
   and ana_FG.FASCIA       = ANA.FASCIA
   and ana.rapporto_par    = 'CF'
   and ana.FASCIA          = 1
   and ana.MATRICOLA       = CIV.MATRICOLA_1
   and civ.TIPO_ATTO       = 1
   and civ.ANNO            = CIT.ANNO
   and civ.ATTO            = CIT.ATTO
   and cit.NATURA          = 'A'
UNION
SELECT CIT.ID_ATTO,
       CIT.UFFICIO, CIT.ANNO, CIT.ATTO, CIT.NATURA, CIT.DATA_CIT,
       ANA_FG.MATRICOLA, ANA_FG.COGNOME_NOME, 
       ANA_FG.DATA_NAS, ANA_FG.ANNO_NAS, ANA_FG.COD_PRO_NAS, ANA_FG.COD_COM_NAS, ana_fg.sesso,
       ana_fg.paternita, ana_fg.maternita, ana_fg.nazionalita, ana_fg.rapporto_par, ana_fg.sequenza_par,
       M.COD_PROVINCIA COD_PRO_RES, M.COD_COMUNE COD_COM_RES,
       civ_fg.UFFICIO ufficio_fg, civ_fg.ANNO anno_fg, civ_fg.ATTO atto_fg,
       CIT.d_DATA_CIT,
       to_date(ANA_FG.DATA_NAS,'j') d_data_nas,
       f_get_descrizione_DCI(ana_fg.nazionalita,ana_fg.sesso) des_nazionalita,
       f_get_descrizione_DRP(ana_fg.rapporto_par,ana_fg.sesso) des_rapporto_par,
-- id_civdta
       (select min(d.id) from civcta c, civdta d where d.tipo_atto = 1 and d.id_civcta = c.id and c.sigla = 'ASM') id_civdta
  FROM arccom m
     , CIVANA CIV_fg
     , ANAANA ANA_FG
     , ANAANA ANA
     , CIVANA_recupero CIV
     , CIVCIT CIT
 WHERE (m.cod_provincia, m.cod_comune) = 
       (select pro_cliente, com_cliente from menuditta)
   and civ_fg.matricola_1 (+) = ana_fg.matricola
   and civ_fg.tipo_atto   (+) = 1
   and add_months(to_date(ana_fg.data_nas,'j'),216) > trunc(sysdate)
   and ana_FG.MATRICOLA    != ANA.MATRICOLA
   and ana_FG.nazionalita  != 'I'
   and ana_FG.RAPPORTO_PAR != 'FG'
   and ana_FG.COD_FAM      = ANA.COD_FAM
   and ana_FG.FASCIA       = ANA.FASCIA
   and ana.rapporto_par    != 'CF'
   and ana.FASCIA          = 1
   and ana.MATRICOLA       = CIV.MATRICOLA_1
   and civ.TIPO_ATTO       = 1
   and civ.ANNO            = CIT.ANNO
   and civ.ATTO            = CIT.ATTO
   and cit.NATURA          = 'A'
/
COMMENT ON TABLE "CIVCIT_FG_RECUPERO"  IS 'Stato Civile - Atti Di Cittadinanza - Figli (backup)'
/
