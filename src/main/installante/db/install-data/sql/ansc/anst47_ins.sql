--liquibase formatted sql
--changeset amonopoli:202306151020_2 runOnChange:true stripComments:false
delete anst47;

insert into anst47 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, DIFETTO_ETA_ADS)
values (1, 'Nessun difetto d''età', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'D1');

insert into anst47 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, DIFETTO_ETA_ADS)
values (2, 'Difetto d''età dello sposo', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'D2');

insert into anst47 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, DIFETTO_ETA_ADS)
values (3, 'Difetto d''età della sposa', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'D3');

insert into anst47 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, DIFETTO_ETA_ADS)
values (4, 'Difetto d''età di entrambi', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 4, 'D4');
