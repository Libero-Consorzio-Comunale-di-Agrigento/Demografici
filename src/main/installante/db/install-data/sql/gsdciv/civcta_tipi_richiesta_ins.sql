--liquibase formatted sql
--changeset amonopoli:202409181130_2 runOnChange:true stripComments:false
delete civcta_tipi_richiesta;

insert into civcta_tipi_richiesta (TIPO_ATTO, SIGLA_CATEGORIA, TIPO_RICHIESTA, DESCRIZIONE)
values (1, 'DAQ', 'DIC', 'Dichiarazione');

insert into civcta_tipi_richiesta (TIPO_ATTO, SIGLA_CATEGORIA, TIPO_RICHIESTA, DESCRIZIONE)
values (1, 'DAQ', 'TRA', 'Trascrizione');

insert into civcta_tipi_richiesta (TIPO_ATTO, SIGLA_CATEGORIA, TIPO_RICHIESTA, DESCRIZIONE)
values (1, 'TAM', 'TRA', 'Trascrizione');

insert into civcta_tipi_richiesta (TIPO_ATTO, SIGLA_CATEGORIA, TIPO_RICHIESTA, DESCRIZIONE)
values (2, 'ADO', 'ADO', 'Adozione');

insert into civcta_tipi_richiesta (TIPO_ATTO, SIGLA_CATEGORIA, TIPO_RICHIESTA, DESCRIZIONE)
values (2, 'ADO', 'REV', 'Revoca');
