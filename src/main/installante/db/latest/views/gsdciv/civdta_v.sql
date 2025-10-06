--liquibase formatted sql
--changeset amonopoli:202303171210 runOnChange:true stripComments:false
create or replace view civdta_v
AS
--
--	Decodifica NATURA
--	. 'O' - Originale
--	. 'T' - Trascritto
--	. 'D' - Diversi
--	. 'N' - Annullato
--	. 'A' - Acquisto 	   (solo per TIPO_ATTO = '1' - Atti di Cittadinanza)
--	. 'P' - Perdita  	   (solo per TIPO_ATTO = '1' - Atti di Cittadinanza)
--      . 'V' - processo Verbale   (solo per TIPO_ATTO = '-4' - Atti di Unione Civile)
--      . '1' / 'O' - uci CONIUGI  (solo per TIPO_ATTO = '-4' - Atti di Unione Civile)
--
--	Decodifica TIPO_DIVORZIO
--        . 'C' - Cessazione
--        . 'S' - Scioglimento
--        . 'X' - Separazione
--
select dta.TIPO_ATTO
     , dta.PARTE
     , dta.SERIE
     , dta.DESCRIZIONE
     , dta.NATURA natura
     , dta.COD_MI
     , dta.SEQUENZA
     , dta.NOTE
     , dta.FLAG_WEGO
     , dta.QUERY_WEGO
     , dta.TYPE_WEGO
     , dta.ID
     , dta.NUM_COLONNE
     , dta.NUM_RIGHE
     , dta.FLAG_DIMENSIONI_FISSE
     , dta.ID_CIVCTA
     , dta.ID_CIVDMI
--     , f_CIV_tipo_divorzio_DTA(dta.tipo_atto,dta.natura) tipo_divorzio
     , dta.flag_divorzio
     , dta.flag_pregresso
     , dta.tipo_divorzio
     , dta.tipo_divorzio_altro
     , decode(dta.tipo_atto,
          1, decode(dta.NATURA, 'A','A', 'P','P', 'N','N', 'D'),
         -4, decode(dta.NATURA, 'O','O', 'T','T', 'N','N', 'V','V', '1','O', 'D'),
             decode(dta.NATURA, 'O','O', 'T','T', 'N','N', 'D')) natura_decode
     , dta.id_civddo_cia
     , dta.flag_dismesso
     , dta.flag_ansc
  from civdta dta
/
comment on table civdta_v is 'Stato Civile - Tipi di Atto (view)'
/
