--liquibase formatted sql
--changeset amonopoli:202410030945 runOnChange:true stripComments:false
update civdfa
   set descrizione = 'FIRME DECESSO (PARTE 1)'
 where tipo_atto   = 5
   and formula     = '5-FIR-1'
   and descrizione = 'FIRME MATRIMONIO (PARTE 1)'
/
update civdfa
   set descrizione = 'FIRME DECESSO (PARTE 2 SERIE A)'
 where tipo_atto   = 5
   and formula     = '5-FIR-2A'
   and descrizione = 'FIRME MATRIMONIO (PARTE 2 SERIE A)'
/
update civdfa
   set descrizione = 'FIRME DECESSO (PARTE 2 SERIE B)'
 where tipo_atto   = 5
   and formula     = '5-FIR-2B'
   and descrizione = 'FIRME MATRIMONIO (PARTE 2 SERIE B)'
/
update civdfa
   set descrizione = 'FIRME DECESSO (PARTE 2 SERIE BIS)'
 where tipo_atto   = 5
   and formula     = '5-FIR-2BB'
   and descrizione = 'FIRME MATRIMONIO (PARTE 2 SERIE BIS)'
/
update civdfa
   set descrizione = 'FIRME DECESSO (PARTE 2 SERIE C)'
 where tipo_atto   = 5
   and formula     = '5-FIR-2C'
   and descrizione = 'FIRME MATRIMONIO (PARTE 2 SERIE C)'
/
