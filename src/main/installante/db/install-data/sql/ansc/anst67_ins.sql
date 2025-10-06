--liquibase formatted sql
--changeset amonopoli:202307121015 runOnChange:true stripComments:false
delete anst67;

insert into anst67 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (1, 'in qualità di Sindaco', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1);

insert into anst67 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (2, 'per delega ricevuta', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2);

insert into anst67 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (3, 'in sostituzione del Sindaco', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3);
