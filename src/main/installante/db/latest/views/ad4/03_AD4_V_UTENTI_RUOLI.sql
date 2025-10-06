--liquibase formatted sql
--changeset snocca:202210181649 runOnChange:true
CREATE OR REPLACE FORCE VIEW AD4_V_UTENTI_RUOLI
(
   UTENTE,
   RUOLO,
   ISTANZA
)
AS
   SELECT utente, modulo || '_' || ruolo ruolo, istanza
     FROM AD4_DIRITTI_ACCESSO
/



