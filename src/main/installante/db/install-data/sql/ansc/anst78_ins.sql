--liquibase formatted sql
--changeset amonopoli:202305251745_2 runOnChange:true stripComments:false
delete anst78;

-- 13/09/2023 (AM): eliminato codice 'PF' con versione ansc 1.12.0)
--insert into anst78 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_ACCERTAMENTO_ADS)
--values (4, 'presenza figlio', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 4, 'PF');

insert into anst78 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_ACCERTAMENTO_ADS)
values (1, 'attestazione di nascita', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'AN');

insert into anst78 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_ACCERTAMENTO_ADS)
values (2, 'constatazione di avvenuto parto', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'CP');

insert into anst78 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_ACCERTAMENTO_ADS)
values (3, 'dichiarazione sostitutiva', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'DS');

