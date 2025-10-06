--liquibase formatted sql
--changeset amonopoli:202310201610_1 runOnChange:true stripComments:false
delete anpt13
 where codice in ('S1','S2','S6','S7');

-- ANSC 
-- idTipoCertificato: 1 - Certificato Semplice . 2 - Estratto per riassunto . 3 Estratto integrale
-- flagSemplificato : Indica se il certificato estratto per copia integrale deve essere semplificato ossia senza metadati
--
-- ANPT13
-- S1	Stato Civile - Certificato Semplice
-- S2	Stato Civile - Estratto per Riassunto
-- S3	Stato Civile - Estratto per Copia Integrale
-- S4	Stato Civile - Estratto per Copia Integrale (semplificato)
-- S6	Stato Civile - Certificato Semplice con PT/MD
-- S7	Stato Civile - Estratto per Riassunto con PT/MD

insert into anpt13 (CODICE, DESCRIZIONE, LISTA_TIPI_CERTIFICATO, FLAG_ELE, FLAG_CIV)
values ('S1', 'Stato Civile - Certificato Semplice', null, null, 'S');

insert into anpt13 (CODICE, DESCRIZIONE, LISTA_TIPI_CERTIFICATO, FLAG_ELE, FLAG_CIV)
values ('S2', 'Stato Civile - Estratto per Riassunto', null, null, 'S');

insert into anpt13 (CODICE, DESCRIZIONE, LISTA_TIPI_CERTIFICATO, FLAG_ELE, FLAG_CIV)
values ('S6', 'Stato Civile - Certificato Semplice con PT/MD', null, null, 'S');

insert into anpt13 (CODICE, DESCRIZIONE, LISTA_TIPI_CERTIFICATO, FLAG_ELE, FLAG_CIV)
values ('S7', 'Stato Civile - Estratto per Riassunto con PT/MD', null, null, 'S');

delete anpt13
 where codice in ('S3','S4');

insert into anpt13 (CODICE, DESCRIZIONE, LISTA_TIPI_CERTIFICATO, FLAG_ELE, FLAG_CIV)
values ('S3', 'Stato Civile - Estratto per Copia Integrale (con metaDati)', null, null, 'S');

insert into anpt13 (CODICE, DESCRIZIONE, LISTA_TIPI_CERTIFICATO, FLAG_ELE, FLAG_CIV)
values ('S4', 'Stato Civile - Estratto per Copia Integrale (senza metaDati)', null, null, 'S');
