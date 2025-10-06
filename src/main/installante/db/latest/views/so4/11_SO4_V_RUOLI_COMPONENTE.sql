--liquibase formatted sql
--changeset snocca:202210190911 runOnChange:true
CREATE OR REPLACE FORCE VIEW SO4_V_RUOLI_COMPONENTE
(
   ID_RUOLO_COMPONENTE,
   ID_COMPONENTE,
   RUOLO,
   DAL,
   AL
)
AS
   SELECT id_ruolo_componente,
          id_componente,
          ruolo,
          dal,
          al
     FROM SO4_RUOLI_COMPONENTE
/
