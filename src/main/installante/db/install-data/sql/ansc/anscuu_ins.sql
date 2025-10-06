--liquibase formatted sql
--changeset snocca:202306071740_2 runOnChange:true stripComments:false
delete ANSCUU;

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (411111, 'UnCiv_001', 'Dichiarazione: Unione civile nella casa comunale', 1, '', 'O1', '', 'UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (411211, 'UnCiv_002', 'Dichiarazione: Unione civile fuori dalla casa comunale', 2, '', 'FCC', '', 'UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (411212, 'UnCiv_003', 'Dichiarazione: Unione civile fuori dalla casa comunale in imminente pericolo di vita', 2, '', 'PDV', '', 'UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (412111, 'UnCiv_004', 'Dichiarazione: Unione civile con delega di altro Comune nella casa comunale', 2, '', 'UPD', '', 'UnCiv', '', '', 'S', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (412211, 'UnCiv_005', 'Dichiarazione: Unione civile con delega di altro Comune fuori dalla casa comunale', 2, '', 'UPD', '', 'UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (419999, 'UnCiv_999', 'Caso d''uso di servizio unioni civili', NULL, '', '', '', 'UnCiv', '', '', '', 'S', 'S', 0);

-- TRASCRIZIONI
insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (431000, 'Trascr_UnCiv_001', 'Trascrizione unione civile dall''estero - richiesta di trascrizione da parte dell''interessato', 2, '', 'TEP', '', 'Trascr_UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (432000, 'Trascr_UnCiv_002', 'Trascrizione unione civile dall''estero - richiesta di trascrizione da parte del Consolato/Ambasciata', 2, '', 'TEA', '', 'Trascr_UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO,
FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19)
values (436000, 'Trascr_UnCiv_005', 'Trascrizione atto unione civile su richiesta dell''interessato per art. 19', 2, '', 'TEP', '', 'Trascr_UnCiv', '', '',
'', '', 'S', 0, 'S');

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (439999, 'Trascr_UnCiv_999', 'Caso d''uso di servizio trascrizioni unioni civili', NULL, '', '', '', 'Trascr_UnCiv', '', '', '', 'S', 'S', 0);

-- SCIOGLIMENTI
insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (441000, 'Sciogl_UnCiv_001', 'Manifestazione congiunta di volonta'' di scioglimento dell''unione civile tra persone dello stesso sesso', 2, '', 'DVS', 'CI', 'Sciogl_UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (442000, 'Sciogl_UnCiv_002', 'Manifestazione di volonta'' di scioglimento dell''unione civile tra persone dello stesso sesso di una sola parte', 2, '', 'DVS', 'C1C2', 'Sciogl_UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (443000, 'Sciogl_UnCiv_003', 'Accordo di scioglimento degli uniti civilmente', 2, '', 'UAC', '', 'Sciogl_UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (444000, 'Sciogl_UnCiv_004', 'Conferma dell''accordo di scioglimento dell''unione civile tra persone dello stesso sesso', 2, '', 'UCO', '', 'Sciogl_UnCiv', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (445000, 'Sciogl_UnCiv_005', 'Mancata conferma dell''accordo di scioglimento dell''unione civile', 2, '', 'UAL', '', 'Sciogl_UnCiv', '', 'M', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (449999, 'Sciogl_UnCiv_999', 'Caso d''uso di servizio scioglimenti', NULL, '', '', '', 'Sciogl_UnCiv', '', '', '', 'S', 'S', 0);

-- ANNOTAZIONI
insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (456999, 'UnCiv_998_1', 'Caso d''uso di servizio annotazione comunicazione da altri comuni', NULL, '', 'COM', '', 'Annotazione', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (457999, 'UnCiv_998_2', 'Caso d''uso di servizio annotazione comunicazione da altre amministrazioni', NULL, '', 'AMMAMSAMA', '', 'Annotazione', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (458699, 'UnCiv_007', 'Annotazione per rettifica', NULL, '', 'RETREA', '', 'Annotazione', '', '', '', '', 'S', 0);

insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (458799, 'UnCiv_008', 'Annotazione per errore materiale', NULL, '', 'EMA', '', 'Annotazione', '', '', '', '', 'S', 0);

--https://github.com/italia/ansc/issues/505: metto il flag visibile a null
insert into ANSCUU (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DICHIARANTE, TIPO_ATTO_ANSC, TIPO_DIVORZIO, TIPO_DIVORZIO_ALTRO, FLAG_CASA_COMUNALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (40000000, 'UnCiv_xxx', 'Annotazione automatica', NULL, '', 'AUT', '', 'Annotazione', '', '', '', '', '', 0);
