--liquibase formatted sql
--changeset amonopoli:202309251000_2 runOnChange:true stripComments:false
delete anst20;

insert into anst20 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, ENTE_DOCUMENTO_ADS)
values (1, 'Ministero degli Interni', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 1);

insert into anst20 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, ENTE_DOCUMENTO_ADS)
values (2, 'Comune', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 2);
