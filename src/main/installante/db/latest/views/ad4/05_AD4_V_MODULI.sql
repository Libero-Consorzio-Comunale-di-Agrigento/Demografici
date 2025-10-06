--liquibase formatted sql
--changeset snocca:202210181651 runOnChange:true
CREATE OR REPLACE FORCE VIEW AD4_V_MODULI
(
   MODULO,
   DESCRIZIONE,
   PROGETTO,
   NOTE
)
AS
   SELECT modulo,
          descrizione,
          progetto,
          note
     FROM AD4_MODULI
/
