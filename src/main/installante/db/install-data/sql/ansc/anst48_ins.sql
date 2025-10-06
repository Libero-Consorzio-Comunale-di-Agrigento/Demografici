--liquibase formatted sql
--changeset amonopoli:202306151025_2 runOnChange:true stripComments:false
delete anst48;

insert into anst48 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, IMPEDIMENTO_MAT_ADS)
values (0, 'Nessun impedimento', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 0, 'I0');

insert into anst48 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, IMPEDIMENTO_MAT_ADS)
values (1, 'Impedimento della parentela', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'I1');

insert into anst48 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, IMPEDIMENTO_MAT_ADS)
values (2, 'Impedimento di affinità', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'I2');

insert into anst48 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, IMPEDIMENTO_MAT_ADS)
values (3, 'Impedimento di affiliazione', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'I3');
