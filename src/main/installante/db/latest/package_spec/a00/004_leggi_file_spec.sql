--liquibase formatted sql
--changeset amonopoli:202503260904_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE LEGGI_FILE IS
   id_file utl_file.file_type;
   procedure apri_file(dir_file varchar2, nome_file varchar2, file_mode varchar2);
   function leggi_riga return varchar2;
   procedure chiudi_file;
   function conta_righe(dir_file varchar2, nome_file varchar2) return number;
/******************************************************************************
   NAME:       leggi_file
   PURPOSE:    To calculate the desired information.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        15/09/99             1. Created this package.
   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:
   CALLED BY:
   CALLS:
   EXAMPLE USE:     NUMBER := leggi_file.MyFuncName(Number);
                    leggi_file.MyProcName(Number, Varchar2);
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
******************************************************************************/
END LEGGI_FILE;
/
