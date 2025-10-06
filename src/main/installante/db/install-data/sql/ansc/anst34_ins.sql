--liquibase formatted sql
--changeset amonopoli:202309061615_2 runOnChange:true stripComments:false
delete anst34;

insert into anst34 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, QUALIFICA_ADS)
values (1, 'medico', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'ME');

insert into anst34 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, QUALIFICA_ADS)
values (2, 'ostetrica', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'OS');

insert into anst34 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, QUALIFICA_ADS)
values (3, 'altro', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'AL');
