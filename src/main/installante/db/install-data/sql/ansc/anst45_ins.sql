--liquibase formatted sql
--changeset amonopoli:202307071535_2 runOnChange:true stripComments:false
delete anst45;

insert into anst45 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TEMPO_IMPIEGO_ADS)
values (1, 'ha assunto pubblico impiego', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'AO');

insert into anst45 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TEMPO_IMPIEGO_ADS)
values (2, 'assumerà pubblico impiego', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'AA');
