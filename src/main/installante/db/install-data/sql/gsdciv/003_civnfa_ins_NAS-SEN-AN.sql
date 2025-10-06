--liquibase formatted sql
--changeset amonopoli:202406181655_3 runOnChange:true stripComments:false
delete civnfa
 where formula = 'NAS-SEN-AN';

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-SEN-AN', 1, 'sede del tribunale', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-SEN-AN', 2, 'data della sentenza', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-SEN-AN', 3, 'atto con cui è stata trascritta la sentenza', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-SEN-AN', 4, 'anno dell''atto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-SEN-AN', 5, 'non', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-SEN-AN', 6, null, null, null, '<COMUNE_DATA>', null, null, null);
