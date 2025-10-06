--liquibase formatted sql
--changeset snocca:202304281111 runOnChange:true stripComments:false
delete ANSCU5;

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2101, 'Morte_001', 'Dichiarazione di morte: Decesso in abitazione o in luogo pubblico', 1, '', 'O1', '', '', '', 'Morte', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2102, 'Morte_002', 'Dichiarazione di morte: Decesso in ospedale o casa di cura', 2, 'B', 'O2B', '', 'NO', '', 'Morte', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2103, 'Morte_003', 'Dichiarazione di morte: Decesso in caso di morte violenta', 2, 'B', 'O2B', '', 'SI', '', 'Morte', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2104, 'Morte_004', 'Dichiarazione di morte: Decesso relativo a cadavere rinvenuto non identificato', 2, 'C', 'ATL', 'NO', '', '', 'Morte', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2212, 'Morte_006', 'Trascrizione di morte: Richiesta trascrizione atto di morte all''estero richiesto da privati con istanza scritta', 2, 'C', 'TEP', '', '', '', 'Trascr_Morte', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2213, 'Morte_007', 'Trascrizione di morte: Richiesta trascrizione atto di morte all''estero richiesto da pubblica autorita''', 2, 'C', 'TEA', '', '', '', 'Trascr_Morte', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2199, 'Morte_999', 'Caso d''uso di servizio dichiarazioni di morte', NULL, '', '', '', '', '', 'Morte', 'S', 'S', 0);

-- TRASCRIZIONI
--insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
--values (2222, 'Morte_009', 'Trascrizioni di sentenze estera di morte presunta o scomparsa o assenza richiesta da pubblica autorità', 2, 'C', 'TEA', '', '', '', 'Trascr_Morte', '', '', 0);

--insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
--values (2223, 'Morte_010', 'Trascrizioni di sentenze estera di morte presunta o scomparsa o assenza richiesta da privato', 2, 'C', 'TEP', '', '', '', 'Trascr_Morte', '', '', 0);

--insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC,
--FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19)
--values (2214, 'Morte_014', 'Trascrizione atto morte su richiesta dell''interessato per art. 19', 2, 'C', 'TEP', '', '', '', 'Trascr_Morte',
--'', '', 0, 'S');

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2299, 'Trascr_Morte_999', 'Caso d''uso di servizio trascrizioni di morte', NULL, '', '', '', '', '', 'Trascr_Morte', 'S', 'S', 0);

-- ANNOTAZIONI
insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2310, 'Morte_998_1', 'Caso d''uso di servizio annotazione comunicazione da altri comuni', NULL, '', 'COM', '', '', '', 'Annotazione', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2320, 'Morte_998_2', 'Caso d''uso di servizio annotazione comunicazione da altre amministrazioni', NULL, '', 'AMM', '', '', '', 'Annotazione', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2341, 'Morte_012', 'Annotazione per rettifica', NULL, '', 'RETREA', '', '', '', 'Annotazione', '', 'S', 0);

insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (2342, 'Morte_013', 'Annotazione per errore materiale', NULL, '', 'EMA', '', '', '', 'Annotazione', '', 'S', 0);

--https://github.com/italia/ansc/issues/505: metto il flag visibile a null
insert into ANSCU5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (20000000, 'Morte_xxx', 'Annotazione automatica', NULL, '', 'AUT', '', '', '', 'Annotazione', '', '', 0);

insert into anscu5 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, ESTREMI_DECESSO_NOTI, MORTE_VIOLENTA, TIPO_DOCUMENTO, TIPO_ATTO_ANSC, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19, FLAG_IN_VIAGGIO)
values (2211, 'Morte_005', 'Trascrizione di morte: Decesso durante il viaggio in treno o aereo o nave', 2, 'C', 'TEA', null, null, null, 'Trascr_Morte', null, 'S', 0, null, 'S');
