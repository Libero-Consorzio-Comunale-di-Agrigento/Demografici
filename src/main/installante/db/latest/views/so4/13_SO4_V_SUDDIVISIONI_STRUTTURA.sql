--liquibase formatted sql
--changeset snocca:202210190913 runOnChange:true
CREATE OR REPLACE FORCE VIEW SO4_V_SUDDIVISIONI_STRUTTURA
(
   ID_SUDDIVISIONE,
   OTTICA,
   CODICE,
   DESCRIZIONE,
   ABBREVIAZIONE,
   ORDINAMENTO
)
AS
   SELECT id_suddivisione,
          ottica,
          suddivisione AS codice,
          descrizione,
          des_abb AS abbreviazione,
          ordinamento
     FROM SO4_SUDDIVISIONI_STRUTTURA
/
