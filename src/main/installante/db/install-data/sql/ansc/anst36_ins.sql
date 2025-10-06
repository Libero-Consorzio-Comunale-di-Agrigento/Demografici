--liquibase formatted sql
--changeset amonopoli:202307061645_2 runOnChange:true stripComments:false
delete anst36;

insert into anst36 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, PRESENTAZIONE_DOCUMENTI_ADS)
values (1, 'Dati prodotti', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'PR');

insert into anst36 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, PRESENTAZIONE_DOCUMENTI_ADS)
values (2, 'Dati non prodotti perchè già acquisiti', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'AC');

insert into anst36 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, PRESENTAZIONE_DOCUMENTI_ADS)
values (3, 'Dati visionati', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'VI');
