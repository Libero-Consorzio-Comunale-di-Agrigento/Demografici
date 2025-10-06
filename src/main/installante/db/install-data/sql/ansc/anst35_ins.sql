--liquibase formatted sql
--changeset snocca:202310091400_2 runOnChange:true stripComments:false
delete anst35;

insert into anst35 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_MANCATO_CONSENSO_ADS)
values (1, 'Non vuole essere nominata', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'NO');

insert into anst35 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_MANCATO_CONSENSO_ADS)
values (2, 'Non può essere nominata per difetto di età', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'DE');
