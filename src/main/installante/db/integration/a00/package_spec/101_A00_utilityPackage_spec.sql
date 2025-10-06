--liquibase formatted sql
--changeset amonopoli:202503261001_1 runOnChange:false stripComments:false
create or replace package UtilityPackage
/******************************************************************************
 NOME:        UtilityPackage
 DESCRIZIONE: Contiene oggetti di utilita generale.
 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  ----------------------------------------------------
 1    23/01/2001  MF      Inserimento commento.
******************************************************************************/
AS
   procedure Compile_All;

END UtilityPackage;
/* End Package: UtilityPackage */
/
