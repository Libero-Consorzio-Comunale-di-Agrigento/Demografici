--liquibase formatted sql
--changeset amonopoli:202603031306_1 runOnChange:true stripComments:false
delete ansjsn_sezioni
 where servizio = 'R005_C';

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36314, 'R005_C', null, 'criteriRicercaSoggetto', 0, 20, null, null, 'dual', null, null, null, null, null);
