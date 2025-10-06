--liquibase formatted sql
--changeset amonopoli:202309201030_2 runOnChange:true stripComments:false
delete anst12;

insert into anst12 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_CONSENSO_ADS)
values (1, 'Consenso contestuale all''evento', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'EV');

insert into anst12 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_CONSENSO_ADS)
values (2, 'Consenso reso anteriormente davanti all''USC', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'AU');

insert into anst12 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_CONSENSO_ADS)
values (3, 'Consenso reso anteriormente davanti ad altro Pubblico Ufficiale', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'AA');

insert into anst12 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_CONSENSO_ADS)
values (4, 'Sentenza del tribunale dopo rifiuto consenso materno', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 4, 'SR');
