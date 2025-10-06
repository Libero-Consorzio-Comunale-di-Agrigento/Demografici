--liquibase formatted sql
--changeset snocca:202304171112 runOnChange:true stripComments:false
delete ANSCU1;

-- TRASCRIZIONI
insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (52111, 'Citt_001', 'Trascrizione: Acquisto alla nascita per iure soli: figlio di genitori che non trasmettono la cittadinanza italiana',
'DAQ', 52111, '', 'Trascr_Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (52141, 'Citt_002', 'Trascrizione: Figlio minore riconosciuto da cittadino italiano',
'DAQ', 52141, '', 'Trascr_Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (52143, 'Citt_004', 'Trascrizione: Figlio minore di chi ha acquista la cittadinanza italiana',
'DAQ', 52143, '', 'Trascr_Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (52122, 'Citt_012', 'Trascrizione: Straniero nato in Italia che vi abbia risieduto legalmente senza interruzioni fino alla maggiore eta'' ',
'DAQ', 52122, '', 'Trascr_Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (52123, 'Citt_014', 'Trascrizione: Straniero riconosciuto durante la maggiore eta'' da cittadino italiano',
'DAQ', 52123, '', 'Trascr_Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (52153, 'Citt_045', 'Trascrizione: Trascrizione del decreto per matrimonio-unione civile-naturalizzazione-presentazione cittadino',
'DAQ', 52153, '', 'Trascr_Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (52154, 'Citt_046', 'Trascrizione: Trascrizione del decreto per matrimonio-unione civile-naturalizzazione-da consolato',
'DAQ', 52154, '', 'Trascr_Citt', NULL, 'S', 0);

-- DICHIARAZIONI
insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (51101, 'Citt_005', 'Dichiarazione: Straniero o apolide, del quale il padre o la madre o uno dei ascendenti in linea retta di secondo grado sono stati cittadini per nascita: acquisto mediante prestazione del servizio militare per lo Stato italiano',
'DAQ', 51101, '', 'Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (51103, 'Citt_011', 'Dichiarazione: Straniero nato in Italia che vi abbia risieduto legalmente senza interruzioni fino alla maggiore eta''',
'DAQ', 51103, '', 'Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (51108, 'Citt_007', 'Dichiarazione: Straniero o dell''apolide, del quale il padre o la madre o uno degli ascendenti in linea retta di secondo grado sono stati cittadini per nascita: acquisto assunzione di pubblico impiego alle dipendenze dello Stato',
'DAQ', 51108, '', 'Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (51102, 'Citt_009', 'Dichiarazione: Straniero o dall''apolide, del quale il padre o la madre o uno degli ascendenti in linea retta di secondo grado sono stati cittadini per nascita, il quale, al raggiungimento della maggiore eta'', risiede legalmente da almeno due anni nel territorio della Repubblica',
'DAQ', 51102, '', 'Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (51104, 'Citt_013', 'Dichiarazione: Straniero riconosciuto durante la maggiore eta'' da cittadino italiano',
'DAQ', 51104, '', 'Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (51106, 'Citt_043', 'Dichiarazione: Prestazione di giuramento a seguito di decreto abile',
'GIU', '', 'IN', 'Citt', NULL, 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (51999, 'Citt_999', 'Caso d''uso di servizio dichiarazioni di cittadinanza',
'', '', '', 'Citt', 'S', 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (52999, 'Trascr_Citt_999', 'Caso d''uso di servizio trascrizioni di cittadinanza',
'', '', '', 'Trascr_Citt', 'S', 'S', 0);

-- ANNOTAZIONI
insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (53599, 'Citt_998_1', 'Caso d''uso di servizio annotazione comunicazione da altri comuni',
'COM', '', '', 'Annotazione', '', 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (53699, 'Citt_998_2', 'Caso d''uso di servizio annotazione comunicazione da altre amministrazioni',
'AMM', '', '', 'Annotazione', '', 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (53719, 'Citt_047', 'Annotazione per rettifica',
'RETREA', '', '', 'Annotazione', '', 'S', 0);

insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (53729, 'Citt_048', 'Annotazione per errore materiale',
'EMA', '', '', 'Annotazione', '', 'S', 0);

--https://github.com/italia/ansc/issues/505: metto il flag visibile a null
insert into ANSCU1 (ID, CODICE_ANSC, DESCRIZIONE,
SIGLA_CATEGORIA, MOTIVO_CITTADINANZA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (50000000, 'Citt_xxx', 'Annotazione automatica',
'AUT', '', '', 'Annotazione', '', '', 0);