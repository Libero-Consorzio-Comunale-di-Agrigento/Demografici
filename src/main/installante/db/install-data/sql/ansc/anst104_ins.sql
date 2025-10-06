--liquibase formatted sql
--changeset amonopoli:202407171305_2 runOnChange:true stripComments:false
delete anst104;

insert into anst104 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_PROVVEDIMENTO_ADS)
values (1, 'Provvedimento', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'PR');

insert into anst104 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_PROVVEDIMENTO_ADS)
values (2, 'Convenzione di negoziazione assistita', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'NA');

insert into anst104 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_PROVVEDIMENTO_ADS)
values (3, 'Accordo che ha determinato la separazione', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'AC');
