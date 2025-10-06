--liquibase formatted sql
--changeset amonopoli:202503240925_1 runOnChange:true stripComments:false
CREATE OR REPLACE PACKAGE SI4V2
/******************************************************************************
 NOME:        SI4
 DESCRIZIONE: Procedure per l'attribuzione dei diritti ad User specifico
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    07/06/2001 PM     Prima emissione
******************************************************************************/
IS
  /******************************************************************************
   NOME:        GRANT_TO
   DESCRIZIONE: Attribuisce diritti di visione degli oggetti di Menu ad altri User Oracle
   ARGOMENTI:   utente varchr2 <User Oracle cui attribuire i diritti>
   ECCEZIONI:   20901 - Errore istruzione
   ANNOTAZIONI: -
   REVISIONI:
   Rev. Data       Autore Descrizione
   ---- ---------- ------ ------------------------------------------------------
   0    07/06/2001 PM     Prima emissione
   1    06/08/2001 PM     Eliminata EURO
   2    10/08/2001 PM     Eliminata MENUUTEIMP ed aggiunto REGISTRO
  ******************************************************************************/
  procedure grant_to
  (utente  varchar2
  );
END;
/
