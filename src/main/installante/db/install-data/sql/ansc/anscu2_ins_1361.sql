--liquibase formatted sql
--changeset dfiloni:202607310810 runOnChange:true stripComments:false
alter table anscu2 disable all triggers
/
UPDATE anscu2
SET FLAG_FIGLIO_DI_IGNOTI = 'S', DESCRIZIONE = 'Formazione atto di nascita su autorizzazione tribunale (art. 32 e art 95)'
WHERE ID = 1361
/
alter table anscu2 enable all triggers
/