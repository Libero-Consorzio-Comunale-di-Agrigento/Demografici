--liquibase formatted sql
--changeset amonopoli:202510021105_2 runOnChange:true stripComments:false
delete anst105;

insert into anst105 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (0, 'DIGITALE', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1);

insert into anst105 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (1, 'PEC', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2);
