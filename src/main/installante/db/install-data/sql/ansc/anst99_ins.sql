--liquibase formatted sql
--changeset snocca:202310031400_2 runOnChange:true stripComments:false
delete anst99;

insert into anst99 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_PROVVEDIMENTO_ADS)
values (1, 'nulla osta del Procuratore della Repubblica', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 1, 'NO');

insert into anst99 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_PROVVEDIMENTO_ADS)
values (2, 'autorizzazione del Procuratore della Repubblica', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 2, 'AP');

insert into anst99 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO, TIPO_PROVVEDIMENTO_ADS)
values (3, 'provvedimento del Presidente del Tribunale', '2000-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 3, 'PT');

