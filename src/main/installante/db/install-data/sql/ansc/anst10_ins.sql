--liquibase formatted sql
--changeset amonopoli:202305231030_2 runOnChange:true stripComments:false
delete anst10;

insert into anst10 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, VERSION)
values (1, 'PDF', null, null, 1, null);

insert into anst10 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, VERSION)
values (2, 'JPG', null, null, 2, null);

insert into anst10 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, VERSION)
values (3, 'TIF', null, null, 3, null);

insert into anst10 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, VERSION)
values (4, 'P7M', null, null, 4, null);
