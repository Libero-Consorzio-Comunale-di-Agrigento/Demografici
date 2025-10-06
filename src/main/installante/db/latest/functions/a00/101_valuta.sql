--liquibase formatted sql
--changeset amonopoli:202503260906_1 runOnChange:false stripComments:false
CREATE OR REPLACE FUNCTION VALUTA RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VALUTA
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
 0    18/05/2001 __     Prima emissione.
******************************************************************************/
BEGIN
   RETURN 'L';
END VALUTA;
/
