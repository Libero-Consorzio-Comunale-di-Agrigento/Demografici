--liquibase formatted sql
--changeset amonopoli:202305191705_2 runOnChange:true stripComments:false
delete anst61;

insert into anst61 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (1, 'Celibe/Nubile', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1);

insert into anst61 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (2, 'Coniugato', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2);

insert into anst61 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (3, 'Vedovo', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3);

insert into anst61 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (4, 'Divorziato', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 4);

insert into anst61 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (6, 'Unito civilmente', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 6);

insert into anst61 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (7, 'Stato libero a seguito di decesso della parte unita civilmente', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 7);

insert into anst61 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (8, 'Stato libero a seguito di scioglimento dell''unione', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 8);

insert into anst61 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (9, 'Non classificabile/ignoto/n.c', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 9);
