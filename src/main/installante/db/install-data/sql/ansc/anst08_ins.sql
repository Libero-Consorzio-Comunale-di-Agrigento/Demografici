--liquibase formatted sql
--changeset amonopoli:202305041035_0 runOnChange:true stripComments:false
delete anst08;

insert into anst08 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (1, 'Ricevuto', null, null, 1);

insert into anst08 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (2, 'In corso di verifica', null, null, 2);

insert into anst08 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (3, 'Inserito', null, null, 3);

insert into anst08 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (4, 'Rifiutato', null, null, 4);

insert into anst08 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
values (5, 'In elaborazione', null, null, 5);
