--liquibase formatted sql
--changeset snocca:202309270934_2 runOnChange:true stripComments:false
delete anst37;

insert into anst37 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_ASSENSO_ADS)
values (1, 'Orale', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'OR');

insert into anst37 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_ASSENSO_ADS)
values (2, 'Reso dinnanzi ad altro ufficiale', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'UF');
