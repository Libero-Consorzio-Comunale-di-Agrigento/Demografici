--liquibase formatted sql
--changeset amonopoli:202306261210_2 runOnChange:true stripComments:false
delete anst53;

insert into ANST53 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_DIVORZIO_ADS, TIPO_DIVORZIO_ALTRO_ADS)
values (1, 'Accordo di separazione', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'X', null);

insert into ANST53 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_DIVORZIO_ADS, TIPO_DIVORZIO_ALTRO_ADS)
values (2, 'Accordo di scioglimento del matrimonio', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'S', null);

insert into ANST53 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_DIVORZIO_ADS, TIPO_DIVORZIO_ALTRO_ADS)
values (3, 'Cessazione degli effetti civili', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'C', null);

insert into ANST53 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_DIVORZIO_ADS, TIPO_DIVORZIO_ALTRO_ADS)
values (4, 'Modifica delle condizioni di separazione', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 4, 'A', 'C');

insert into ANST53 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_DIVORZIO_ADS, TIPO_DIVORZIO_ALTRO_ADS)
values (5, 'Modifica delle condizioni di scioglimento/cessazione effetti civili', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 5, 'A', 'D');
