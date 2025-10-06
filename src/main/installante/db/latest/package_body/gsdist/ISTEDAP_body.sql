--liquibase formatted sql
--changeset amonopoli:202503211225_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ISTEDAP is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
/******************************************************************************
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/07/2003 __     Prima emissione. Da conversione
******************************************************************************/
p_prenotazione number;
p_passo        number;
P_pagina 	   number :=1;
P_riga   	   number :=0;
BEGIN
p_prenotazione := prenotazione;
p_passo        := passo;
null;
END MAIN;
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
--
-- 'V1.0 del 29/07/2003'  AM  Prima emissione
-- 'V2.0 del 15/10/2013'  AM  Adeguamenti 2013
-- 'V2.1 del 21/12/2016'  AM  Adeguamenti 2016 - Unioni Civili
-- 'V2.2 del 21/09/2017'  AM  Adeguamenti 2017 - Nuovi tracciati
--
   RETURN 'V2.2 del 21/09/2017';
END VERSIONE;
END ISTEDAP;
/
