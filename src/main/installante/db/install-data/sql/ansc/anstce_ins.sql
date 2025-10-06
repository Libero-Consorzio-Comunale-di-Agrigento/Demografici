--liquibase formatted sql
--changeset snocca:202311201155 runOnChange:true stripComments:false
delete anstce;

insert into anstce (ERROR_CODE, HTTP_CODE, DESC_CODE, DESCRIZIONE, FLAG_OTP_USER, FLAG_GESTITO)
values ('404003', '404', '', 'Codice OTP non trovato per l''utente', 'S', '');

insert into anstce (ERROR_CODE, HTTP_CODE, DESC_CODE, DESCRIZIONE, FLAG_OTP_USER, FLAG_GESTITO)
values ('406002', '406', 'OTP_CODE_EXPIRED', 'Codice OTP scaduto', 'S', '');

insert into anstce (ERROR_CODE, HTTP_CODE, DESC_CODE, DESCRIZIONE, FLAG_OTP_USER, FLAG_GESTITO)
values ('406001', '406', 'OTP_CODE_NOT_VALID', 'Codice OTP non valido', 'S', '');

