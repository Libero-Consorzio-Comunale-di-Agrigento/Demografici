--liquibase formatted sql
--changeset amonopoli:202603021246_2 runOnChange:true stripComments:false
delete ansjsn_sezioni
 where servizio like 'R002%';

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35807, 'R002', -4, 'flagSemplificato', 0, 5, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35803, 'R002', -4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (610, 'R002', -4, 'idAnsc', 0, 20, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (611, 'R002', -4, 'richiedente', 0, 50, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (612, 'R002', -4, 'validoEstero', 0, 100, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (613, 'R002', -4, 'idEvento', 0, 110, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (614, 'R002', -4, 'intestatario', 0, 120, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (615, 'R002', -4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (616, 'R002', -4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36559, 'R002', -4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35802, 'R002', -4, 'idTipoUso', 0, 310, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (338, 'R002_1', -4, 'idAnsc', 0, 20, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (339, 'R002_1', -4, 'richiedente', 0, 50, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (340, 'R002_1', -4, 'idEvento', 0, 110, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (341, 'R002_1', -4, 'intestatario', 0, 120, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (342, 'R002_1', -4, 'idTipoCertificato', 0, 130, null, null, 'cercem_UCI_v_json', 'idRif', 'idTipoCertificato_1', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37135, 'R002_1_E', -4, 'flagSemplificato', 0, 8, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37136, 'R002_1_E', -4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37138, 'R002_1_E', -4, 'enteRichiedente', 0, 16, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37137, 'R002_1_E', -4, 'idAnsc', 0, 17, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37139, 'R002_1_E', -4, 'validoEstero', 0, 100, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37140, 'R002_1_E', -4, 'idEvento', 0, 110, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37141, 'R002_1_E', -4, 'intestatario', 0, 120, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37142, 'R002_1_E', -4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37143, 'R002_1_E', -4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37144, 'R002_1_E', -4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37145, 'R002_1_E', -4, 'idTipoUso', 0, 310, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37168, 'R002_1_S', -4, 'flagSemplificato', 0, 5, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37169, 'R002_1_S', -4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37170, 'R002_1_S', -4, 'idAnsc', 0, 20, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37171, 'R002_1_S', -4, 'richiedente', 0, 50, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37172, 'R002_1_S', -4, 'validoEstero', 0, 100, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37173, 'R002_1_S', -4, 'idEvento', 0, 110, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37174, 'R002_1_S', -4, 'intestatario', 0, 120, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37175, 'R002_1_S', -4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37176, 'R002_1_S', -4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37177, 'R002_1_S', -4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37178, 'R002_1_S', -4, 'idTipoUso', 0, 310, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (344, 'R002_2', -4, 'idAnsc', 0, 20, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (345, 'R002_2', -4, 'richiedente', 0, 50, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (346, 'R002_2', -4, 'idEvento', 0, 110, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (347, 'R002_2', -4, 'intestatario', 0, 120, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (348, 'R002_2', -4, 'idTipoCertificato', 0, 130, null, null, 'cercem_UCI_v_json', 'idRif', 'idTipoCertificato_2', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36562, 'R002_2', -4, 'parametriFirma', 0, 300, null, null, 'civuci_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37146, 'R002_2_E', -4, 'flagSemplificato', 0, 8, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37147, 'R002_2_E', -4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37149, 'R002_2_E', -4, 'enteRichiedente', 0, 16, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37148, 'R002_2_E', -4, 'idAnsc', 0, 17, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37150, 'R002_2_E', -4, 'validoEstero', 0, 100, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37151, 'R002_2_E', -4, 'idEvento', 0, 110, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37152, 'R002_2_E', -4, 'intestatario', 0, 120, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37153, 'R002_2_E', -4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37154, 'R002_2_E', -4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37155, 'R002_2_E', -4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37156, 'R002_2_E', -4, 'idTipoUso', 0, 310, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37179, 'R002_2_S', -4, 'flagSemplificato', 0, 5, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37180, 'R002_2_S', -4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37181, 'R002_2_S', -4, 'idAnsc', 0, 20, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37182, 'R002_2_S', -4, 'richiedente', 0, 50, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37183, 'R002_2_S', -4, 'validoEstero', 0, 100, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37184, 'R002_2_S', -4, 'idEvento', 0, 110, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37185, 'R002_2_S', -4, 'intestatario', 0, 120, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37186, 'R002_2_S', -4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37187, 'R002_2_S', -4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37188, 'R002_2_S', -4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37189, 'R002_2_S', -4, 'idTipoUso', 0, 310, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (350, 'R002_3', -4, 'idAnsc', 0, 20, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (351, 'R002_3', -4, 'richiedente', 0, 50, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (352, 'R002_3', -4, 'idEvento', 0, 110, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (353, 'R002_3', -4, 'intestatario', 0, 120, null, null, 'cercem_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (354, 'R002_3', -4, 'idTipoCertificato', 0, 130, null, null, 'cercem_UCI_v_json', 'idRif', 'idTipoCertificato_3', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36566, 'R002_3', -4, 'parametriFirma', 0, 300, null, null, 'civuci_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37157, 'R002_3_E', -4, 'flagSemplificato', 0, 8, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37158, 'R002_3_E', -4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37160, 'R002_3_E', -4, 'enteRichiedente', 0, 16, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37159, 'R002_3_E', -4, 'idAnsc', 0, 17, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37161, 'R002_3_E', -4, 'validoEstero', 0, 100, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37162, 'R002_3_E', -4, 'idEvento', 0, 110, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37163, 'R002_3_E', -4, 'intestatario', 0, 120, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37164, 'R002_3_E', -4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37165, 'R002_3_E', -4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37166, 'R002_3_E', -4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37167, 'R002_3_E', -4, 'idTipoUso', 0, 310, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37190, 'R002_3_S', -4, 'flagSemplificato', 0, 5, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37191, 'R002_3_S', -4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37192, 'R002_3_S', -4, 'idAnsc', 0, 20, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37193, 'R002_3_S', -4, 'richiedente', 0, 50, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37194, 'R002_3_S', -4, 'validoEstero', 0, 100, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37195, 'R002_3_S', -4, 'idEvento', 0, 110, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37196, 'R002_3_S', -4, 'intestatario', 0, 120, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37197, 'R002_3_S', -4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37198, 'R002_3_S', -4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37199, 'R002_3_S', -4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37200, 'R002_3_S', -4, 'idTipoUso', 0, 310, null, null, 'cerinc_UCI_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (445, 'R002_1', 1, 'idAnsc', 0, 20, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (446, 'R002_1', 1, 'richiedente', 0, 50, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (447, 'R002_1', 1, 'idEvento', 0, 110, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (448, 'R002_1', 1, 'intestatario', 0, 120, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (449, 'R002_1', 1, 'idTipoCertificato', 0, 130, null, null, 'cercem_CIT_v_json', 'idRif', 'idTipoCertificato_1', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (451, 'R002_2', 1, 'idAnsc', 0, 20, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (452, 'R002_2', 1, 'richiedente', 0, 50, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (453, 'R002_2', 1, 'idEvento', 0, 110, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (454, 'R002_2', 1, 'intestatario', 0, 120, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (455, 'R002_2', 1, 'idTipoCertificato', 0, 130, null, null, 'cercem_CIT_v_json', 'idRif', 'idTipoCertificato_2', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36563, 'R002_2', 1, 'parametriFirma', 0, 300, null, null, 'civcit_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (417, 'R002_3', 1, 'idAnsc', 0, 20, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (418, 'R002_3', 1, 'richiedente', 0, 50, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (419, 'R002_3', 1, 'idEvento', 0, 110, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (420, 'R002_3', 1, 'intestatario', 0, 120, null, null, 'cercem_CIT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (421, 'R002_3', 1, 'idTipoCertificato', 0, 130, null, null, 'cercem_CIT_v_json', 'idRif', 'idTipoCertificato_3', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36568, 'R002_3', 1, 'parametriFirma', 0, 300, null, null, 'civcit_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35804, 'R002', 2, 'flagSemplificato', 0, 5, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35794, 'R002', 2, 'usoMatrimonio', 0, 15, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (602, 'R002', 2, 'idAnsc', 0, 20, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (603, 'R002', 2, 'richiedente', 0, 50, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (608, 'R002', 2, 'validoEstero', 0, 100, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (604, 'R002', 2, 'idEvento', 0, 110, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (605, 'R002', 2, 'intestatario', 0, 120, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (607, 'R002', 2, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (606, 'R002', 2, 'idTipoCertificato', 0, 130, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36557, 'R002', 2, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35793, 'R002', 2, 'idTipoUso', 0, 310, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (127, 'R002_1', 2, 'idAnsc', 0, 20, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (140, 'R002_1', 2, 'richiedente', 0, 50, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (138, 'R002_1', 2, 'idEvento', 0, 110, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (139, 'R002_1', 2, 'intestatario', 0, 120, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (130, 'R002_1', 2, 'idTipoCertificato', 0, 130, null, null, 'cercem_NAS_v_json', 'idRif', 'idTipoCertificato_1', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37201, 'R002_1_E', 2, 'flagSemplificato', 0, 8, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37202, 'R002_1_E', 2, 'usoMatrimonio', 0, 15, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37204, 'R002_1_E', 2, 'enteRichiedente', 0, 16, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37203, 'R002_1_E', 2, 'idAnsc', 0, 17, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37205, 'R002_1_E', 2, 'validoEstero', 0, 100, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37206, 'R002_1_E', 2, 'idEvento', 0, 110, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37207, 'R002_1_E', 2, 'intestatario', 0, 120, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37208, 'R002_1_E', 2, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37209, 'R002_1_E', 2, 'idTipoCertificato', 0, 130, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37210, 'R002_1_E', 2, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37211, 'R002_1_E', 2, 'idTipoUso', 0, 310, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37234, 'R002_1_S', 2, 'flagSemplificato', 0, 5, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37235, 'R002_1_S', 2, 'usoMatrimonio', 0, 15, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37236, 'R002_1_S', 2, 'idAnsc', 0, 20, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37237, 'R002_1_S', 2, 'richiedente', 0, 50, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37238, 'R002_1_S', 2, 'validoEstero', 0, 100, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37239, 'R002_1_S', 2, 'idEvento', 0, 110, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37240, 'R002_1_S', 2, 'intestatario', 0, 120, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37241, 'R002_1_S', 2, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37242, 'R002_1_S', 2, 'idTipoCertificato', 0, 130, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37243, 'R002_1_S', 2, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37244, 'R002_1_S', 2, 'idTipoUso', 0, 310, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (133, 'R002_2', 2, 'idAnsc', 0, 20, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (136, 'R002_2', 2, 'richiedente', 0, 50, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (134, 'R002_2', 2, 'idEvento', 0, 110, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (135, 'R002_2', 2, 'intestatario', 0, 120, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (137, 'R002_2', 2, 'idTipoCertificato', 0, 130, null, null, 'cercem_NAS_v_json', 'idRif', 'idTipoCertificato_2', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36558, 'R002_2', 2, 'parametriFirma', 0, 300, null, null, 'civnas_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37212, 'R002_2_E', 2, 'flagSemplificato', 0, 8, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37213, 'R002_2_E', 2, 'usoMatrimonio', 0, 15, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37215, 'R002_2_E', 2, 'enteRichiedente', 0, 16, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37214, 'R002_2_E', 2, 'idAnsc', 0, 17, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37216, 'R002_2_E', 2, 'validoEstero', 0, 100, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37217, 'R002_2_E', 2, 'idEvento', 0, 110, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37218, 'R002_2_E', 2, 'intestatario', 0, 120, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37219, 'R002_2_E', 2, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37220, 'R002_2_E', 2, 'idTipoCertificato', 0, 130, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37221, 'R002_2_E', 2, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37222, 'R002_2_E', 2, 'idTipoUso', 0, 310, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37245, 'R002_2_S', 2, 'flagSemplificato', 0, 5, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37246, 'R002_2_S', 2, 'usoMatrimonio', 0, 15, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37247, 'R002_2_S', 2, 'idAnsc', 0, 20, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37248, 'R002_2_S', 2, 'richiedente', 0, 50, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37249, 'R002_2_S', 2, 'validoEstero', 0, 100, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37250, 'R002_2_S', 2, 'idEvento', 0, 110, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37251, 'R002_2_S', 2, 'intestatario', 0, 120, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37252, 'R002_2_S', 2, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37253, 'R002_2_S', 2, 'idTipoCertificato', 0, 130, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37254, 'R002_2_S', 2, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37255, 'R002_2_S', 2, 'idTipoUso', 0, 310, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (121, 'R002_3', 2, 'idAnsc', 0, 20, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (124, 'R002_3', 2, 'richiedente', 0, 50, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (123, 'R002_3', 2, 'idEvento', 0, 110, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (125, 'R002_3', 2, 'intestatario', 0, 120, null, null, 'cercem_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (122, 'R002_3', 2, 'idTipoCertificato', 0, 130, null, null, 'cercem_NAS_v_json', 'idRif', 'idTipoCertificato_3', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36567, 'R002_3', 2, 'parametriFirma', 0, 300, null, null, 'civnas_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37223, 'R002_3_E', 2, 'flagSemplificato', 0, 8, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37224, 'R002_3_E', 2, 'usoMatrimonio', 0, 15, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37226, 'R002_3_E', 2, 'enteRichiedente', 0, 16, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37225, 'R002_3_E', 2, 'idAnsc', 0, 17, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37227, 'R002_3_E', 2, 'validoEstero', 0, 100, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37228, 'R002_3_E', 2, 'idEvento', 0, 110, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37229, 'R002_3_E', 2, 'intestatario', 0, 120, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37230, 'R002_3_E', 2, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37231, 'R002_3_E', 2, 'idTipoCertificato', 0, 130, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37232, 'R002_3_E', 2, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37233, 'R002_3_E', 2, 'idTipoUso', 0, 310, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37256, 'R002_3_S', 2, 'flagSemplificato', 0, 5, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37257, 'R002_3_S', 2, 'usoMatrimonio', 0, 15, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37258, 'R002_3_S', 2, 'idAnsc', 0, 20, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37259, 'R002_3_S', 2, 'richiedente', 0, 50, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37260, 'R002_3_S', 2, 'validoEstero', 0, 100, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37261, 'R002_3_S', 2, 'idEvento', 0, 110, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37262, 'R002_3_S', 2, 'intestatario', 0, 120, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37263, 'R002_3_S', 2, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37264, 'R002_3_S', 2, 'idTipoCertificato', 0, 130, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37265, 'R002_3_S', 2, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37266, 'R002_3_S', 2, 'idTipoUso', 0, 310, null, null, 'cerinc_NAS_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35806, 'R002', 4, 'flagSemplificato', 0, 5, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35800, 'R002', 4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (618, 'R002', 4, 'idAnsc', 0, 20, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (619, 'R002', 4, 'richiedente', 0, 50, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (620, 'R002', 4, 'validoEstero', 0, 100, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (621, 'R002', 4, 'idEvento', 0, 110, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (622, 'R002', 4, 'intestatario', 0, 120, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (623, 'R002', 4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (624, 'R002', 4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36560, 'R002', 4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35799, 'R002', 4, 'idTipoUso', 0, 310, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (368, 'R002_1', 4, 'idAnsc', 0, 20, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (369, 'R002_1', 4, 'richiedente', 0, 50, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (370, 'R002_1', 4, 'idEvento', 0, 110, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (371, 'R002_1', 4, 'intestatario', 0, 120, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (372, 'R002_1', 4, 'idTipoCertificato', 0, 130, null, null, 'cercem_MAT_v_json', 'idRif', 'idTipoCertificato_1', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37267, 'R002_1_E', 4, 'flagSemplificato', 0, 8, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37268, 'R002_1_E', 4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37270, 'R002_1_E', 4, 'enteRichiedente', 0, 16, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37269, 'R002_1_E', 4, 'idAnsc', 0, 17, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37271, 'R002_1_E', 4, 'validoEstero', 0, 100, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37272, 'R002_1_E', 4, 'idEvento', 0, 110, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37273, 'R002_1_E', 4, 'intestatario', 0, 120, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37274, 'R002_1_E', 4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37275, 'R002_1_E', 4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37276, 'R002_1_E', 4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37277, 'R002_1_E', 4, 'idTipoUso', 0, 310, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37300, 'R002_1_S', 4, 'flagSemplificato', 0, 5, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37301, 'R002_1_S', 4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37302, 'R002_1_S', 4, 'idAnsc', 0, 20, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37303, 'R002_1_S', 4, 'richiedente', 0, 50, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37304, 'R002_1_S', 4, 'validoEstero', 0, 100, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37305, 'R002_1_S', 4, 'idEvento', 0, 110, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37306, 'R002_1_S', 4, 'intestatario', 0, 120, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37307, 'R002_1_S', 4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37308, 'R002_1_S', 4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37309, 'R002_1_S', 4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37310, 'R002_1_S', 4, 'idTipoUso', 0, 310, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (362, 'R002_2', 4, 'idAnsc', 0, 20, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (363, 'R002_2', 4, 'richiedente', 0, 50, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (364, 'R002_2', 4, 'idEvento', 0, 110, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (365, 'R002_2', 4, 'intestatario', 0, 120, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (366, 'R002_2', 4, 'idTipoCertificato', 0, 130, null, null, 'cercem_MAT_v_json', 'idRif', 'idTipoCertificato_2', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36564, 'R002_2', 4, 'parametriFirma', 0, 300, null, null, 'civmat_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37278, 'R002_2_E', 4, 'flagSemplificato', 0, 8, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37279, 'R002_2_E', 4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37281, 'R002_2_E', 4, 'enteRichiedente', 0, 16, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37280, 'R002_2_E', 4, 'idAnsc', 0, 17, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37282, 'R002_2_E', 4, 'validoEstero', 0, 100, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37283, 'R002_2_E', 4, 'idEvento', 0, 110, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37284, 'R002_2_E', 4, 'intestatario', 0, 120, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37285, 'R002_2_E', 4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37286, 'R002_2_E', 4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37287, 'R002_2_E', 4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37288, 'R002_2_E', 4, 'idTipoUso', 0, 310, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37311, 'R002_2_S', 4, 'flagSemplificato', 0, 5, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37312, 'R002_2_S', 4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37313, 'R002_2_S', 4, 'idAnsc', 0, 20, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37314, 'R002_2_S', 4, 'richiedente', 0, 50, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37315, 'R002_2_S', 4, 'validoEstero', 0, 100, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37316, 'R002_2_S', 4, 'idEvento', 0, 110, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37317, 'R002_2_S', 4, 'intestatario', 0, 120, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37318, 'R002_2_S', 4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37319, 'R002_2_S', 4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37320, 'R002_2_S', 4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37321, 'R002_2_S', 4, 'idTipoUso', 0, 310, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (356, 'R002_3', 4, 'idAnsc', 0, 20, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (357, 'R002_3', 4, 'richiedente', 0, 50, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (358, 'R002_3', 4, 'idEvento', 0, 110, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (359, 'R002_3', 4, 'intestatario', 0, 120, null, null, 'cercem_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (360, 'R002_3', 4, 'idTipoCertificato', 0, 130, null, null, 'cercem_MAT_v_json', 'idRif', 'idTipoCertificato_3', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36569, 'R002_3', 4, 'parametriFirma', 0, 300, null, null, 'civmat_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37289, 'R002_3_E', 4, 'flagSemplificato', 0, 8, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37290, 'R002_3_E', 4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37292, 'R002_3_E', 4, 'enteRichiedente', 0, 16, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37291, 'R002_3_E', 4, 'idAnsc', 0, 17, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37293, 'R002_3_E', 4, 'validoEstero', 0, 100, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37294, 'R002_3_E', 4, 'idEvento', 0, 110, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37295, 'R002_3_E', 4, 'intestatario', 0, 120, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37296, 'R002_3_E', 4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37297, 'R002_3_E', 4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37298, 'R002_3_E', 4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37299, 'R002_3_E', 4, 'idTipoUso', 0, 310, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37322, 'R002_3_S', 4, 'flagSemplificato', 0, 5, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37323, 'R002_3_S', 4, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37324, 'R002_3_S', 4, 'idAnsc', 0, 20, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37325, 'R002_3_S', 4, 'richiedente', 0, 50, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37326, 'R002_3_S', 4, 'validoEstero', 0, 100, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37327, 'R002_3_S', 4, 'idEvento', 0, 110, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37328, 'R002_3_S', 4, 'intestatario', 0, 120, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37329, 'R002_3_S', 4, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37330, 'R002_3_S', 4, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37331, 'R002_3_S', 4, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37332, 'R002_3_S', 4, 'idTipoUso', 0, 310, null, null, 'cerinc_MAT_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35805, 'R002', 5, 'flagSemplificato', 0, 5, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35797, 'R002', 5, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (626, 'R002', 5, 'idAnsc', 0, 20, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (627, 'R002', 5, 'richiedente', 0, 50, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (628, 'R002', 5, 'validoEstero', 0, 100, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (629, 'R002', 5, 'idEvento', 0, 110, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (630, 'R002', 5, 'intestatario', 0, 120, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (631, 'R002', 5, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (632, 'R002', 5, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36561, 'R002', 5, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (35796, 'R002', 5, 'idTipoUso', 0, 310, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (148, 'R002_1', 5, 'idAnsc', 0, 20, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (149, 'R002_1', 5, 'richiedente', 0, 50, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (150, 'R002_1', 5, 'idEvento', 0, 110, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (151, 'R002_1', 5, 'intestatario', 0, 120, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (152, 'R002_1', 5, 'idTipoCertificato', 0, 130, null, null, 'cercem_MOR_v_json', 'idRif', 'idTipoCertificato_1', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37333, 'R002_1_E', 5, 'flagSemplificato', 0, 8, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37334, 'R002_1_E', 5, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37336, 'R002_1_E', 5, 'enteRichiedente', 0, 16, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37335, 'R002_1_E', 5, 'idAnsc', 0, 17, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37337, 'R002_1_E', 5, 'validoEstero', 0, 100, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37338, 'R002_1_E', 5, 'idEvento', 0, 110, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37339, 'R002_1_E', 5, 'intestatario', 0, 120, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37340, 'R002_1_E', 5, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37341, 'R002_1_E', 5, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37342, 'R002_1_E', 5, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37343, 'R002_1_E', 5, 'idTipoUso', 0, 310, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37366, 'R002_1_S', 5, 'flagSemplificato', 0, 5, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37367, 'R002_1_S', 5, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37368, 'R002_1_S', 5, 'idAnsc', 0, 20, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37369, 'R002_1_S', 5, 'richiedente', 0, 50, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37370, 'R002_1_S', 5, 'validoEstero', 0, 100, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37371, 'R002_1_S', 5, 'idEvento', 0, 110, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37372, 'R002_1_S', 5, 'intestatario', 0, 120, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37373, 'R002_1_S', 5, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37374, 'R002_1_S', 5, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37375, 'R002_1_S', 5, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37376, 'R002_1_S', 5, 'idTipoUso', 0, 310, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (154, 'R002_2', 5, 'idAnsc', 0, 20, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (155, 'R002_2', 5, 'richiedente', 0, 50, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (156, 'R002_2', 5, 'idEvento', 0, 110, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (157, 'R002_2', 5, 'intestatario', 0, 120, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (158, 'R002_2', 5, 'idTipoCertificato', 0, 130, null, null, 'cercem_MOR_v_json', 'idRif', 'idTipoCertificato_2', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36565, 'R002_2', 5, 'parametriFirma', 0, 300, null, null, 'civmor_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37344, 'R002_2_E', 5, 'flagSemplificato', 0, 8, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37345, 'R002_2_E', 5, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37347, 'R002_2_E', 5, 'enteRichiedente', 0, 16, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37346, 'R002_2_E', 5, 'idAnsc', 0, 17, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37348, 'R002_2_E', 5, 'validoEstero', 0, 100, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37349, 'R002_2_E', 5, 'idEvento', 0, 110, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37350, 'R002_2_E', 5, 'intestatario', 0, 120, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37351, 'R002_2_E', 5, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37352, 'R002_2_E', 5, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37353, 'R002_2_E', 5, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37354, 'R002_2_E', 5, 'idTipoUso', 0, 310, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37377, 'R002_2_S', 5, 'flagSemplificato', 0, 5, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37378, 'R002_2_S', 5, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37379, 'R002_2_S', 5, 'idAnsc', 0, 20, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37380, 'R002_2_S', 5, 'richiedente', 0, 50, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37381, 'R002_2_S', 5, 'validoEstero', 0, 100, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37382, 'R002_2_S', 5, 'idEvento', 0, 110, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37383, 'R002_2_S', 5, 'intestatario', 0, 120, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37384, 'R002_2_S', 5, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37385, 'R002_2_S', 5, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37386, 'R002_2_S', 5, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37387, 'R002_2_S', 5, 'idTipoUso', 0, 310, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (160, 'R002_3', 5, 'idAnsc', 0, 20, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (161, 'R002_3', 5, 'richiedente', 0, 50, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (162, 'R002_3', 5, 'idEvento', 0, 110, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (163, 'R002_3', 5, 'intestatario', 0, 120, null, null, 'cercem_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (164, 'R002_3', 5, 'idTipoCertificato', 0, 130, null, null, 'cercem_MOR_v_json', 'idRif', 'idTipoCertificato_3', null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (36570, 'R002_3', 5, 'parametriFirma', 0, 300, null, null, 'civmor_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37355, 'R002_3_E', 5, 'flagSemplificato', 0, 8, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37356, 'R002_3_E', 5, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37358, 'R002_3_E', 5, 'enteRichiedente', 0, 16, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37357, 'R002_3_E', 5, 'idAnsc', 0, 17, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37359, 'R002_3_E', 5, 'validoEstero', 0, 100, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37360, 'R002_3_E', 5, 'idEvento', 0, 110, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37361, 'R002_3_E', 5, 'intestatario', 0, 120, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37362, 'R002_3_E', 5, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37363, 'R002_3_E', 5, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37364, 'R002_3_E', 5, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37365, 'R002_3_E', 5, 'idTipoUso', 0, 310, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37388, 'R002_3_S', 5, 'flagSemplificato', 0, 5, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37389, 'R002_3_S', 5, 'usoMatrimonio', 0, 15, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37390, 'R002_3_S', 5, 'idAnsc', 0, 20, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37391, 'R002_3_S', 5, 'richiedente', 0, 50, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37392, 'R002_3_S', 5, 'validoEstero', 0, 100, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37393, 'R002_3_S', 5, 'idEvento', 0, 110, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37394, 'R002_3_S', 5, 'intestatario', 0, 120, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37395, 'R002_3_S', 5, 'conPaternitaMaternita', 0, 125, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37396, 'R002_3_S', 5, 'idTipoCertificato', 0, 130, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37397, 'R002_3_S', 5, 'parametriFirma', 0, 300, null, null, 'cerinc_USC_v_json', 'idRif', null, 'S', null, null);

insert into ansjsn_sezioni (ID, SERVIZIO, TIPO_ATTO, SEZIONE, LIVELLO, SEQUENZA, ID_PADRE, FLAG_ARRAY, VISTA_DB, PARAMETRO_VISTA_DB, CAMPO_DB, FLAG_OTP_FIRMA, USECASES_ESCLUSI, USECASE)
values (37398, 'R002_3_S', 5, 'idTipoUso', 0, 310, null, null, 'cerinc_MOR_v_json', 'idRif', null, null, null, null);

