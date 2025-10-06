--liquibase formatted sql
--changeset amonopoli:202303271036_2 runOnChange:true stripComments:false
delete anst33;

insert into anst33 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (1, 'della madre', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1);

insert into anst33 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (2, 'del padre', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2);

