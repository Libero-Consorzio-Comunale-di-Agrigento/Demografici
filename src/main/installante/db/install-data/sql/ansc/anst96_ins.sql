--liquibase formatted sql
--changeset amonopoli:202310121240_2 runOnChange:true stripComments:false
delete anst96;

insert into anst96 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, MOTIVO_RECUPERO_ADS)
values (1, 'Indisponibilita'' del sistema gestionale', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'M1');

insert into anst96 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, MOTIVO_RECUPERO_ADS)
values (2, 'Atto formato fuori da casa comunale', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'M2');

insert into anst96 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, MOTIVO_RECUPERO_ADS)
values (3, 'Caso d''uso non previsto nel sistema centrale', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'M3');

insert into anst96 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, MOTIVO_RECUPERO_ADS)
values (4, 'Indisponibilita'' del sistema centrale', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 4, 'M4');

insert into anst96 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, MOTIVO_RECUPERO_ADS)
values (101, 'ALTRO', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 5, 'MX');
