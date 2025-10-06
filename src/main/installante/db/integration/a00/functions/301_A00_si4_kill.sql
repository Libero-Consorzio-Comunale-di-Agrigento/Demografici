--liquibase formatted sql
--changeset amonopoli:202503261014_1 runOnChange:false stripComments:false
CREATE OR REPLACE FUNCTION SI4_KILL(p_sid in number, p_serial in number) RETURN NUMBER IS
/******************************************************************************
 NOME:        SI4_KILL
 DESCRIZIONE: <Descrizione function>

 PARAMETRI:   p_<par1> <type> <Descrizione parametro 1>
              p_<par2> <type> <Descrizione parametro 2>.

 RITORNA:     <type> n : <Descrizione caso n>
                     m : <Descrizione caso m>

 ECCEZIONI:   nnnnn, <Descrizione eccezione>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    20/03/01 __     Prima emissione.
******************************************************************************/
errore NUMBER;
BEGIN
   errore := 0;
   begin
      si4.SQL_EXECUTE('alter system kill session '''||to_char(p_sid)||','||to_char(p_serial)||'''');
   EXCEPTION WHEN OTHERS THEN
        errore := 9999;
   end;
   RETURN errore;
END SI4_KILL;
/

