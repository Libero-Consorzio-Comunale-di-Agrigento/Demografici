--liquibase formatted sql
--changeset snocca:202304171111 runOnChange:true stripComments:false
delete ANSCU2;

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11111000, 'Dic_Nasc_001', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal padre', 1, 'A', 'O1A', '', 'L', '', '', 'PD', 'PD',
'PDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11111100, 'Dic_Nasc_002', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal padre - bambino nato morto', 1, 'A', 'O1A', '', 'L', 'SI', '', 'PD', 'PD',
'PDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11111200, 'Dic_Nasc_003', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione nel matrimonio resa dal padre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'L', 'NO', '', 'PD', 'PD',
'PDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11112000, 'Dic_Nasc_004', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dalla madre', 1, 'A', 'O1A', '', 'L', '', '', 'MD', 'MD',
'MDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11112100, 'Dic_Nasc_005', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dalla madre - bambino nato morto', 1, 'A', 'O1A', '', 'L', 'SI', '', 'MD', 'MD',
'MDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11113000, 'Dic_Nasc_006', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal padre con presenza madre', 1, 'A', 'O1A', '', 'L', '', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11113100, 'Dic_Nasc_007', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal padre con presenza madre - bambino nato morto', 1, 'A', 'O1A', '', 'L', 'SI', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11114000, 'Dic_Nasc_008', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal procuratore del padre', 1, 'A', 'O1A', '', 'L', '', '', 'PP', 'PP',
'PPMD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11114100, 'Dic_Nasc_009', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal procuratore del padre - bambino nato morto', 1, 'A', 'O1A', '', 'L', 'SI', '', 'PP', 'PP',
'PPMD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11115000, 'Dic_Nasc_010', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dall''ostetrica o sanitario o altra persona che ha assistito al parto', 1, 'A', 'O1A', '', 'L', '', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11115100, 'Dic_Nasc_011', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dall''ostetrica o sanitario o altra persona che ha assistito al parto - bambino nato morto', 1, 'A', 'O1A', '', 'L', 'SI', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11121100, 'Dic_Nasc_012', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dal padre all''USC di bimbo nato morto', 1, 'B', 'O1B', '', 'L', 'SI', '', 'PD', 'PD',
'PDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11121200, 'Dic_Nasc_013', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dal padre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'L', 'NO', '', 'PD', 'PD',
'PDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11121000, 'Dic_Nasc_014', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa all''USC dal padre', 1, 'B', 'O1B', '', 'L', '', '', 'PD', 'PD',
'PDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11122000, 'Dic_Nasc_015', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa all''USC dalla madre', 1, 'B', 'O1B', '', 'L', '', '', 'MD', 'MD',
'MDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11123000, 'Dic_Nasc_016', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa all''USC dal padre con presenza madre', 1, 'B', 'O1B', '', 'L', '', '', 'PD', 'PDMD',
'PDMDIT','', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11124000, 'Dic_Nasc_017', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa all''USC dal procuratore del padre', 1, 'B', 'O1B', '', 'L', '', '', 'PP', 'PP',
'PPMD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11125000, 'Dic_Nasc_018', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa all''USC da ostetrica o altro sanitario che ha assistito al parto', 1, 'B', 'O1B', '', 'L', '', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11211004, 'Dic_Nasc_020', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal padre con il consenso della madre reso mediante atto notarile - filiazione fuori dal matrimonio', 1, 'A', 'O1A', '', 'C', '', '', 'PD', 'PD',
'PDIT','SI', '', 'CM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11211001, 'Dic_Nasc_019', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal padre senza il consenso della madre - filiazione fuori dal matrimonio', 1, 'A', 'O1A', '', 'C', '', '', 'PD', 'PD',
'PDIT','', '', 'SM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11211101, 'Dic_Nasc_021', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal padre senza il consenso della madre - bambino nato morto - filiazione fuori dal matrimonio', 1, 'A', 'O1A', '', 'C', 'SI', '', 'PD', 'PD',
'PDIT', '', '', 'SM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11211104, 'Dic_Nasc_022', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dal padre con consenso materno espresso con atto notarile di bimbo nato morto', 1, 'A', 'O1A', '', 'C', 'SI', '', 'PD', 'PD',
'PDIT', 'SI', '', 'CM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11211201, 'Dic_Nasc_023', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal padre senza il consenso della madre - bambino nato vivo e morto prima della dichiarazione di nascita - filiazione fuori dal matrimonio', 1, 'A', 'O1A', '', 'C', 'NO', '', 'PD', 'PD',
'PDIT', '', '', 'SM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11212002, 'Dic_Nasc_024', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dalla madre senza il consenso del padre - filiazione fuori dal matrimonio', 1, 'A', 'O1A', '', 'C', '', '', 'MD', 'MD',
'MDIT', '', '', 'SP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11212003, 'Dic_Nasc_025', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dalla madre con il consenso del padre reso mediante atto notarile - filiazione fuori dal matrimonio', 1, 'A', 'O1A', '', 'C', '', '', 'MD', 'MD',
'MDIT', 'SI', '', 'CP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11212102, 'Dic_Nasc_026', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dalla madre senza il consenso paterno di bimbo nato morto', 1, 'A', 'O1A', '', 'C', 'SI', '', 'MD', 'MD',
'MDIT', '', '', 'SP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11212103, 'Dic_Nasc_027', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dalla madre con consenso paterno espresso con atto notarile di bimbo nato morto', 1, 'A', 'O1A', '', 'C', 'SI', '', 'MD', 'MD',
'MDIT', 'SI', '', 'CP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11212202, 'Dic_Nasc_028', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dalla madre senza consenso paterno di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'C', 'NO', '', 'MD', 'MD',
'MDIT', '', '', 'SP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11212203, 'Dic_Nasc_029', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dalla madre con consenso paterno espresso con atto notarile di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'C', 'NO', '', 'MD', 'MD',
'MDIT', 'SI', '', 'CP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11213000, 'Dic_Nasc_030', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dal padre con presenza madre', 1, 'A', 'O1A', '', 'C', '', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11213100, 'Dic_Nasc_031', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dal padre con presenza madre di bimbo nato morto', 1, 'A', 'O1A', '', 'C', 'SI', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11213200, 'Dic_Nasc_032', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dal padre con presenza madre di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'C', 'NO', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11214000, 'Dic_Nasc_033', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal procuratore del padre - Filiazione fuori dal matrimonio con consenso della madre a essere nominata', 1, 'A', 'O1A', '', 'C', '', '', 'PP', 'PP',
'PPMD', 'SI', '', 'CM', 'Dic_Nasc', NULL, NULL, 'S', 0);

-- da test in applicativo e webapp risulta che debba essere obbligatoriamente passato l'atto notarile
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11214100, 'Dic_Nasc_034', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dal procuratore del padre di bimbo nato morto', 1, 'A', 'O1A', '', 'C', 'SI', '', 'PP', 'PP',
'PPMD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11214200, 'Dic_Nasc_035', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dal procuratore del padre di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'C', 'NO', '', 'PP', 'PP',
'PPMD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11216000, 'Dic_Nasc_114', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dalla madre con presenza padre', 1, 'A', 'O1A', '', 'C', '', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11221001, 'Dic_Nasc_036', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre senza il consenso materno', 1, 'B', 'O1B', '', 'C', '', '', 'PD', 'PD',
'PDIT', '', '', 'SM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11221004, 'Dic_Nasc_037', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre con il consenso materno espresso con atto notarile', 1, 'B', 'O1B', '', 'C', '', '', 'PD', 'PD',
'PDIT', 'SI', '', 'CM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11221101, 'Dic_Nasc_038', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre senza consenso materno di bimbo nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'PD', 'PD',
'PDIT', '', '', 'SM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11221104, 'Dic_Nasc_039', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre con consenso materno espresso con atto notarile di bimbo nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'PD', 'PD',
'PDIT', 'SI', '', 'CM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11221201, 'Dic_Nasc_040', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre senza consenso materno di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'C', 'NO', '', 'PD', 'PD',
'PDIT', '', '', 'SM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11221204, 'Dic_Nasc_041', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre con consenso materno espresso con atto notarile di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'C', 'NO', '', 'PD', 'PD',
'PDIT', 'SI', '', 'CM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11222002, 'Dic_Nasc_042', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre senza il consenso paterno', 1, 'B', 'O1B', '', 'C', '', '', 'MD', 'MD',
'MDIT', '', '', 'SP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11222003, 'Dic_Nasc_043', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre con il consenso paterno espresso con atto notarile', 1, 'B', 'O1B', '', 'C', '', '', 'MD', 'MD',
'MDIT', 'SI', '', 'CP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11222102, 'Dic_Nasc_044', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre senza il consenso paterno di bimbo nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'MD', 'MD',
'MDIT', '', '', 'SP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11222103, 'Dic_Nasc_045', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre con il consenso paterno di bimbo nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'MD', 'MD',
'MDIT', 'SI', '', 'CP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11222202, 'Dic_Nasc_046', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre senza il consenso paterno di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'C', 'NO', '', 'MD', 'MD',
'MDIT', '', '', 'SP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11222203, 'Dic_Nasc_047', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre con il consenso paterno di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'C', 'NO', '', 'MD', 'MD',
'MDIT', 'SI', '', 'CP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11223000, 'Dic_Nasc_048', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre con presenza madre', 1, 'B', 'O1B', '', 'C', '', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11223100, 'Dic_Nasc_049', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre con presenza madre di bimbo nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11223200, 'Dic_Nasc_050', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal padre con presenza madre di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'C', 'NO', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11224000, 'Dic_Nasc_051', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal procuratore del padre', 1, 'B', 'O1B', '', 'C', '', '', 'PP', 'PP',
'PPMD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11224100, 'Dic_Nasc_052', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal procuratore del padre di bimbo nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'PP', 'PP',
'PPMD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11224200, 'Dic_Nasc_053', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal procuratore del padre di bimbo nato vivo ma morto prima della dichiarazione', 1, 'B', 'O1B', '', 'C', 'NO', '', 'PP', 'PP',
'PPMD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11315000, 'Dic_Nasc_054', 'Dichiarazione nascita: Dichiarazione resa da ostetrica o altro - fuori matrimonio', 1, 'A', 'O1A', '', 'C', '', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11315100, 'Dic_Nasc_055', 'Dichiarazione nascita: Dichiarazione nei temini di filiazione fuori dal matrimonio resa all''USC da ostetrica o altro sanitario che ha assistito al parto - nato morto', 1, 'A', 'O1A', '', 'C', 'SI', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11315200, 'Dic_Nasc_056', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC da ostetrica o altro sanitario che ha assistito al parto - nato vivo ma morto prima della dichiarazione', 1, 'A', 'O1A', '', 'C', 'NO', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11325000, 'Dic_Nasc_057', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC da ostetrica o altro sanitario che ha assistito al parto - nato vivo', 1, 'B', 'O1B', '', 'C', '', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11325100, 'Dic_Nasc_058', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC da ostetrica o altro sanitario che ha assistito al parto - nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11325200, 'Dic_Nasc_059', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC da ostetrica o altro sanitario che ha assistito al parto - nato vivo ma morto prima della dichiarazione', 1, 'B', 'O1B', '', 'C', 'NO', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11411010, 'Dic_Nasc_060', 'Dichiarazione nascita: Dichiarazione fuori del matrimonio nei termini di legge resa dal padre, di bimbo riconosciuto da entrambi i genitori prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'PD', 'PD',
'PDIT', '', 'PDMD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11411024, 'Dic_Nasc_061', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio, nei termini di legge, resa dal padre con atto pubblico di consenso della madre, di bimbo riconosciuto dalla madre prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'PD', 'PD',
'PDIT', '', 'MD', 'CM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11412010, 'Dic_Nasc_062', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio nei termini di legge, resa dalla madre di bimbo riconosciuto prima della nascita da parte di entrambi i genitori', 1, 'A', 'O1A', '', 'C', '', '', 'MD', 'MD',
'MDIT', '', 'PDMD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_CONSENSO_2, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11412020, 'Dic_Nasc_063', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio nei termini di legge, resa dalla madre di bimbo riconosciuto dalla madre prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'MD', 'MD',
'MDIT', '', 'MD', NULL, NULL, 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11413020, 'Dic_Nasc_064', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio nei termini di legge resa dal padre con presenza madre di bimbo riconosciuto dalla madre prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'PD', 'PDMD',
'PDMDIT', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11415010, 'Dic_Nasc_065', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio nei termini di legge, resa dall''ostetrica o sanitario o altra persona che ha assistito al parto di bimbo riconosciuto da parte di entrambi i genitori prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'OS', 'OS',
'', '', 'PDMD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11415020, 'Dic_Nasc_066', 'Dichiarazione nascita: Dichiarazione di filiiazione fuori del matrimonio nei termini di legge resa dall''ostetrica o da sanitario o da altra persona che ha assistito al parto, di bimbo che e'' stato riconosciuto dalla madre prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'OS', 'OS',
'', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11414010, 'Dic_Nasc_067', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio, nei termini di legge, resa dal procuratore del padre, di bimbo riconosciuto da parte di entrambi i genitori prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'PP', 'PP',
'PPMD', '', 'PDMD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11414020, 'Dic_Nasc_068', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio, nei termini di legge, resa dal procuratore del padre, di bimbo riconosciuto da parte della madre prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'PP', 'PP',
'PPMD', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11421010, 'Dic_Nasc_069', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio,  resa dal padre, di bimbo riconosciuto da parte di entrambi i genitori prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'PD', 'PD',
'PDIT', '', 'PDMD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11421024, 'Dic_Nasc_070', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio, resa dal padre mediante atto pubblico di consenso della madre, di bimbo riconosciuto dalla madre prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'PD', 'PD',
'PDIT', '', 'MD', 'CM', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11422010, 'Dic_Nasc_071', 'Dichiarazione nascita: Dichiarazione tardiva, di filiazione fuori del matrimonio, resa dalla madre, di bimbo riconosciuto da parte di entrambi i genitori prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'MD', 'MD',
'MDIT', '', 'PDMD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11422020, 'Dic_Nasc_072', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio, resa dalla madre di bimbo riconosciuto dalla madre prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'MD', 'MD',
'MDIT', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11423020, 'Dic_Nasc_073', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio, resa dal padre con presenza madre di bimbo riconosciuto dalla madre prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'PD', 'PDMD',
'PDMDIT', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11425010, 'Dic_Nasc_074', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio, resa dall''ostetrica o sanitario o altra persona che ha assistito al parto di bimbo riconosciuto da parte di entrambi i genitori prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'OS', 'OS',
'', '', 'PDMD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11425020, 'Dic_Nasc_075', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio, resa dall''ostetrica o sanitario o altra persona che ha assistito al parto di bimbo riconosciuto dalla madre prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'OS', 'OS',
'', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11424020, 'Dic_Nasc_076', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio, resa dal procuratore del padre di bimbo riconosciuto dalla madre prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'PP', 'PP',
'PPMD', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11112200, 'Dic_Nasc_077', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione nel matrimonio resa dalla madre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'L', 'NO', '', 'MD', 'MD',
'MDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11113200, 'Dic_Nasc_078', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione nel matrimonio resa dal padre con presenza madre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'L', 'NO', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11114200, 'Dic_Nasc_079', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione nel matrimonio resa dal procuratore del padre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'L', 'NO', '', 'PP', 'PP',
'PPMD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11115200, 'Dic_Nasc_080', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione nel matrimonio resa da sanitario/ostetrica all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'L', 'NO', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11122100, 'Dic_Nasc_081', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dalla madre all''USC di filiazione di bimbo nato morto', 1, 'B', 'O1B', '', 'L', 'SI', '', 'MD', 'MD',
'MDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11123100, 'Dic_Nasc_082', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dal padre con presenza madre all''USC di filiazione di bimbo nato morto', 1, 'B', 'O1B', '', 'L', 'SI', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11124100, 'Dic_Nasc_083', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dal procuratore del padre all''USC di filiazione di bimbo nato morto', 1, 'B', 'O1B', '', 'L', 'SI', '', 'PP', 'PP',
'PPMD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11125100, 'Dic_Nasc_084', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa all''USC da ostetrica o altro sanitario di bimbo nato morto', 1, 'B', 'O1B', '', 'L', 'SI', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11122200, 'Dic_Nasc_085', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dalla madre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'L', 'NO', '', 'MD', 'MD',
'MDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11123200, 'Dic_Nasc_086', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dal padre con presenza madre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'L', 'NO', '', 'PD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11124200, 'Dic_Nasc_087', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dal procuratore del padre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'L', 'NO', '', 'PP', 'PP',
'PPMD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11125200, 'Dic_Nasc_088', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa da sanitario all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'L', 'NO', '', 'OS', 'OS',
'', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11116000, 'Dic_Nasc_089', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dalla madre con presenza padre', 1, 'A', 'O1A', '', 'L', '', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11116100, 'Dic_Nasc_090', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dalla madre con presenza padre - bambino nato morto', 1, 'A', 'O1A', '', 'L', 'SI', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11416020, 'Dic_Nasc_091', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio nei termini di legge resa dalla madre con presenza padre di bimbo riconosciuto dalla madre prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'MD', 'PDMD',
'PDMDIT', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11426020, 'Dic_Nasc_092', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio, resa dall madre con presenza padre di bimbo riconosciuto dalla madre prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'MD', 'PDMD',
'PDMDIT', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11116200, 'Dic_Nasc_093', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione nel matrimonio resa dalla madre con presenza padre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'L', 'NO', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11126100, 'Dic_Nasc_094', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dalla madre con presenza padre all''USC di filiazione di bimbo nato morto', 1, 'B', 'O1B', '', 'L', 'SI', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11126200, 'Dic_Nasc_095', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dalla madre con presenza padre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'L', 'NO', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11117000, 'Dic_Nasc_096', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal procuratore della madre', 1, 'A', 'O1A', '', 'L', '', '', 'PM', 'PM',
'PMPD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11117100, 'Dic_Nasc_097', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal procuratore della madre - bambino nato morto', 1, 'A', 'O1A', '', 'L', 'SI', '', 'PM', 'PM',
'PMPD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11127100, 'Dic_Nasc_098', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dal procuratore della madre all''USC di filiazione di bimbo nato morto', 1, 'B', 'O1B', '', 'L', 'SI', '', 'PM', 'PM',
'PMPD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11126000, 'Dic_Nasc_099', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa all''USC dalla madre con presenza padre', 1, 'B', 'O1B', '', 'L', '', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11216100, 'Dic_Nasc_100', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dalla madre con presenza padre di bimbo nato morto', 1, 'A', 'O1A', '', 'C', 'SI', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11216200, 'Dic_Nasc_101', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dalla madre con presenza padre di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'C', 'NO', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11226000, 'Dic_Nasc_102', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre con presenza padre', 1, 'B', 'O1B', '', 'C', '', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11226100, 'Dic_Nasc_103', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre con presenza padre di bimbo nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11226200, 'Dic_Nasc_104', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dalla madre con presenza padre di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'C', 'NO', '', 'MD', 'PDMD',
'PDMDIT', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11227000, 'Dic_Nasc_105', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal procuratore della madre con consenso del padre ad essere nominato', 1, 'B', 'O1B', '', 'C', '', '', 'PM', 'PM',
'PMPD', 'SI', '', 'CP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11227100, 'Dic_Nasc_106', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal procuratore della madre di bimbo nato morto', 1, 'B', 'O1B', '', 'C', 'SI', '', 'PM', 'PM',
'PMPD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11227200, 'Dic_Nasc_107', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori dal matrimonio resa all''USC dal procuratore della madre di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'C', 'NO', '', 'PM', 'PM',
'PMPD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11417010, 'Dic_Nasc_108', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio, nei termini di legge, resa da procuratore speciale della madre, di bimbo riconosciuto da parte di entrambi i genitori prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'PM', 'PM',
'PMPD', '', 'PDMD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11417020, 'Dic_Nasc_109', 'Dichiarazione nascita: Dichiarazione di filiazione fuori del matrimonio, nei termini di legge, resa dal procuratore della madre, di bimbo riconosciuto da parte della madre prima della nascita', 1, 'A', 'O1A', '', 'C', '', '', 'PM', 'PM',
'PMPD', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11117200, 'Dic_Nasc_110', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione nel matrimonio resa dal procuratore della madre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'L', 'NO', '', 'PM', 'PM',
'PMPD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11127200, 'Dic_Nasc_111', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa dal procuratore della madre all''USC di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'B', 'O1B', '', 'L', 'NO', '', 'PM', 'PM',
'PMPD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11217100, 'Dic_Nasc_112', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dal procuratore della madre di bimbo nato morto', 1, 'A', 'O1A', '', 'C', 'SI', '', 'PM', 'PM',
'PMPD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11217200, 'Dic_Nasc_113', 'Dichiarazione nascita: Dichiarazione nei termini di filiazione fuori dal matrimonio resa all''USC dal procuratore della madre di bimbo nato vivo ma morto prima della denuncia di nascita', 1, 'A', 'O1A', '', 'C', 'NO', '', 'PM', 'PM',
'PMPD', 'SI', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11127000, 'Dic_Nasc_115', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione nel matrimonio resa all''USC dal procuratore della madre', 1, 'B', 'O1B', '', 'L', '', '', 'PM', 'PM',
'PMPD', '', '', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11217000, 'Dic_Nasc_116', 'Dichiarazione nascita: Dichiarazione entro i 10 giorni - resa dal procuratore della madre - Filiazione fuori dal matrimonio con consenso del padre ad essere nominato', 1, 'A', 'O1A', '', 'C', '', '', 'PM', 'PM',
'PMPD', 'SI', '', 'CP', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11427020, 'Dic_Nasc_117', 'Dichiarazione nascita: Dichiarazione tardiva di filiazione fuori del matrimonio, resa dal procuratore della madre di bimbo riconosciuto dalla madre prima della nascita', 1, 'B', 'O1B', '', 'C', '', '', 'PM', 'PM',
'PMPD', '', 'MD', '', 'Dic_Nasc', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (11999999, 'Dic_Nasc_999', 'Caso d''uso di servizio dichiarazioni nascita', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL,
NULL, NULL, NULL, NULL, 'Dic_Nasc', NULL, 'S', 'S', 0);

-- TRASCRIZIONI
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (1311, 'Trascr_005', 'Trascrizione di nascita: Trascrizione di atto di nascita avvenuta all''estero su richiesta dell''autorita'' diplomatica o consolare', 2, 'B', 'TEA', '', '', '', '', '', '',
'', '', '', '', 'Trascr', 'NO', NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (1312, 'Trascr_006', 'Trascrizione di nascita: Trascrizione di atto di nascita avvenuta all estero su richiesta di chi ha interesse alla trascrizione', 2, 'B', 'TEP', '', '', '', '', '', '',
'', '', '', '', 'Trascr', 'NO', NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (1323, 'Trascr_009', 'Trascrizione di nascita: Trascrizione della sentenza straniera di dichiarazione giudiziale di paternita'' o maternita'' su richiesta dell''autorita'' diplomatica o consolare', 2, 'B', 'TEA', '', '', '', '', '', '',
'', '', '', '', 'Trascr', 'SI', NULL, NULL, 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_ATTO_ANSC, FLAG_VISIBILE, VERSION, MOTIVO_ADOZIONE)
values (1341, 'Trascr_013', 'Trascrizione di nascita: Trascrizione della sentenza di adozione di minore emessa dal Tribunale dei minori', 2, 'B', 'ADO', 'Trascr', 'S', 0, 1341);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_ATTO_ANSC, FLAG_VISIBILE, VERSION, MOTIVO_ADOZIONE)
values (1342, 'Trascr_014', 'Trascrizione di nascita: Trascrizione della sentenza di adozione di minore in casi particolari emessa dal Tribunale dei minori', 2, 'B', 'ADO', 'Trascr', 'S', 0, 1342);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_ATTO_ANSC, FLAG_VISIBILE, VERSION, MOTIVO_ADOZIONE)
values (1343, 'Trascr_015', 'Trascrizione di nascita: Trascrizione della sentenza di revoca della adozione di minore in casi particolari', 2, 'B', 'ADO', 'Trascr', 'S', 0, 1343);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_ATTO_ANSC, FLAG_VISIBILE, VERSION, MOTIVO_ADOZIONE)
values (1344, 'Trascr_016', 'Trascrizione di nascita: Trascrizione della sentenza di adozione di maggiorenne emessa dal Tribunale', 2, 'B', 'ADO', 'Trascr', 'S', 0, 1344);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_ATTO_ANSC, FLAG_VISIBILE, VERSION, MOTIVO_ADOZIONE)
values (1345, 'Trascr_017', 'Trascrizione di nascita: Trascrizione della sentenza di revoca della adozione di maggiorenne', 2, 'B', 'ADO', 'Trascr', 'S', 0, 1345);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_ATTO_ANSC, FLAG_VISIBILE, VERSION, MOTIVO_ADOZIONE)
values (1351, 'Trascr_018', 'Trascrizione di nascita: Trascrizione provvedimento straniero di adozione richiesta da un privato', 2, 'B', 'ADO', 'Trascr', 'S', 0, 1351);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (1314, 'Trascr_022', 'Trascrizione di nascita: Trascrizione atto di nascita resa alla direzione sanitaria', 2, 'B', 'CNA', '', '', '', '', '', '',
'', '', '', '', 'Trascr', NULL, NULL, 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (1322, 'Trascr_024', 'Trascrizione di nascita: Trascrizione della sentenza straniera di dichiarazione giudiziale di paternita'' richiesta dall''interessato', 2, 'B', 'TEP', '', '', '', '', '', '',
'', '', '', '', 'Trascr', 'SI', NULL, NULL, 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19)
values (1315, 'Trascr_027', 'Trascrizione atto nascita su richiesta dell''interessato per art. 19', 2, 'B', 'TEP', '', '', '', '', '', '',
'', '', '', '', 'Trascr', 'NO', NULL, 'S', 0, 'S');

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (1399, 'Trascr_999', 'Caso d''uso di servizio trascrizioni nascita', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL,
NULL, '', '', '', 'Trascr', NULL, 'S', 'S', 0);

-- RICONOSCIMENTO PRE-NATALE
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12211312, 'Rico_001', 'Riconoscimento paterno di nascituro gia'' riconosciuto dalla madre', 2, 'B', 'RPN', '', NULL, '', '', 'PD', 'PD',
'PDIT', '', '', '', 'Rico', NULL, '', 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12212300, 'Rico_002', 'Riconoscimento materno di nascituro', 2, 'B', 'RPN', '', NULL, '', '', 'MD', 'MD',
'MDIT', '', '', '', 'Rico', NULL, '', 'S', 0);

-- Modificato nei rilasci successivi
--insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
--TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
--values (12214300, 'Rico_003', 'Riconoscimento di nascituro da parte di entrambi i genitori', 2, 'B', 'RPN', '', '', '', '', 'PDMD', 'PDMD',
--'', '', '', '', 'Rico', '', '', 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12214300, 'Rico_003', 'Riconoscimento di nascituro da parte del padre con presenza della madre', 2, 'B', 'RPN', '', NULL, '', '', 'PD', 'EN',
'PDMDIT', '', '', '', 'Rico', NULL, '', 'S', 0);

-- POST NASCITA
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12221122, 'Rico_004', 'Riconoscimento paterno di figlio ultraquattordicenne gia'' riconosciuto dalla madre', 2, 'B', 'RIC', '', NULL, '', 'SQ', 'PD', 'PD',
'EN', '', '', '', 'Rico', NULL, '', 'S', 0);

-- POST NASCITA
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12221212, 'Rico_006', 'Riconoscimento paterno di figlio infraquattordicenne gia'' riconosciuto dalla madre', 2, 'B', 'RIC', '', NULL, '', 'IQ', 'PD', 'PD',
'EN', '', '', '', 'Rico', NULL, '', 'S', 0);

-- POST NASCITA
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12222121, 'Rico_007', 'Riconoscimento materno di figlio ultraquattordicenne gia'' riconsciuto dal padre', 2, 'B', 'RIC', '', NULL, '', 'SQ', 'MD', 'MD',
'EN', '', '', '', 'Rico', NULL, '', 'S', 0);

-- POST NASCITA
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12222231, 'Rico_010', 'Riconoscimento materno di figlio infraquattordicenne gia'' riconosciuto dal padre', 2, 'B', 'RIC', '', NULL, '', 'IQ', 'MD', 'MD',
'EN', '', '', '', 'Rico', NULL, '', 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12216300, 'Rico_016', 'Riconoscimento di nascituro da parte della madre con presenza del padre', 2, 'B', 'RPN', '', NULL, '', '', 'MD', 'EN',
'PDMDIT', '', '', '', 'Rico', NULL, '', 'S', 0);

-- POST NASCITA
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12221422, 'Rico_019', 'Riconoscimento paterno di figlio maggiorenne gia'' riconosciuto dalla madre', 2, 'B', 'RIC', '', NULL, '', 'MG', 'PD', 'PD',
'EN', '', '', '', 'Rico', NULL, '', 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12999999, 'Rico_999', 'Caso d''uso di servizio riconoscimenti', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL,
NULL, '', '', '', 'Rico', NULL, 'S', 'S', 0);

-- ANNOTAZIONI
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (14400000, 'Dic_Nasc_998_1', 'Caso d''uso di servizio annotazione comunicazione da altri comuni', NULL, NULL, 'COM', NULL, NULL, NULL, '', NULL, NULL,
NULL, '', '', '', 'Annotazione', NULL, '', 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (14500000, 'Dic_Nasc_998_2', 'Caso d''uso di servizio  annotazione comunicazione da altre amministrazioni', NULL, NULL, 'AMMAMDAMSAMA', NULL, NULL, NULL, '', NULL, NULL,
NULL, '', '', '', 'Annotazione', NULL, '', 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (14630000, 'Dic_Nasc_118', 'Annotazione per rettifica', NULL, NULL, 'RETREA', NULL, NULL, NULL, '', NULL, NULL,
NULL, '', '', '', 'Annotazione', NULL, '', 'S', 0);

insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (14640000, 'Dic_Nasc_119', 'Annotazione per errore materiale', NULL, NULL, 'EMA', NULL, NULL, NULL, '', NULL, NULL,
NULL, '', '', '', 'Annotazione', NULL, '', 'S', 0);

--https://github.com/italia/ansc/issues/505: metto il flag visibile a null
insert into ANSCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (10000000, 'Dic_Nasc_xxx', 'Annotazione automatica', NULL, NULL, 'AUT', NULL, NULL, NULL, '', NULL, NULL,
NULL, '', '', '', 'Annotazione', NULL, '', '', 0);

insert into ansCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (12323100, 'Rico_013', 'Riconoscimento: Assenso al riconoscimento da parte del figlio ultraquattordicenne', 2, 'B', 'RIC', null, null, null, null, 'AL', 'AL',
null, null, null, null, 'Rico', null, null, 'S', 0);

insert into ansCU2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION)
values (1361, 'Trascr_001', 'Trascrizione di nascita: Formazione dell''atto di nascita su autorizzazione tribunale in caso di omessa denuncia', 2, 'B', 'ODN', null, null, null, null, null, null,
null, null, null, null, 'Trascr', null, null, 'S', 0);

insert into anscu2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE,
TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19, MOTIVO_ADOZIONE, TIPO_CONSENSO_2, FLAG_IN_VIAGGIO)
values (1313, 'Trascr_007', 'Trascrizione di nascita: Trascrizione dichiarazione di nascita avvenuta durante un viaggio in mare, aereo, treno', 2, 'B', 'TEA', null, null, null, null, null, null,
null, null, null, null, 'Trascr', null, null, 'S', 0, null, null, null, 'S');

insert into anscu2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE, TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19, MOTIVO_ADOZIONE, TIPO_CONSENSO_2, FLAG_IN_VIAGGIO, FLAG_FIGLIO_DI_IGNOTI)
values (12221123, 'Rico_005', 'Riconoscimento paterno di figlio di ignoti ultraquattordicenne', 2, 'B', 'RIC', null, null, null, 'SQ', 'PD', 'PD', null, null, null, null, 'Rico', null, null, 'S', 0, null, null, null, null, 'S');

insert into anscu2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE, TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19, MOTIVO_ADOZIONE, TIPO_CONSENSO_2, FLAG_IN_VIAGGIO, FLAG_FIGLIO_DI_IGNOTI)
values (12221203, 'Rico_020', 'Riconoscimento paterno di figlio di ignoti infraquattordicenne', 2, 'B', 'RIC', null, null, null, 'IQ', 'PD', 'PD', null, null, null, null, 'Rico', null, null, 'S', 0, null, null, null, null, 'S');

insert into anscu2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE, TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19, MOTIVO_ADOZIONE, TIPO_CONSENSO_2, FLAG_IN_VIAGGIO, FLAG_FIGLIO_DI_IGNOTI)
values (12222123, 'Rico_008', 'Riconoscimento materno di figlio di ignoti ultraquattordicenne', 2, 'B', 'RIC', null, null, null, 'SQ', 'MD', 'MD', null, null, null, null, 'Rico', null, null, 'S', 0, null, null, null, null, 'S');

insert into anscu2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE, TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19, MOTIVO_ADOZIONE, TIPO_CONSENSO_2, FLAG_IN_VIAGGIO, FLAG_FIGLIO_DI_IGNOTI)
values (12222203, 'Rico_009', 'Riconoscimento materno di figlio di ignoti infraquattordicenne', 2, 'B', 'RIC', null, null, null, 'IQ', 'MD', 'MD', null, null, null, null, 'Rico', null, null, 'S', 0, null, null, null, null, 'S');

insert into anscu2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE, TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19, MOTIVO_ADOZIONE, TIPO_CONSENSO_2, FLAG_IN_VIAGGIO, FLAG_FIGLIO_DI_IGNOTI)
values (12224123, 'Rico_011', 'Riconoscimento di figlio di ignoti ultraquattordicenne da parte del padre con presenza della madre', 2, 'B', 'RIC', null, null, null, 'SQ', 'PD', 'EN', null, null, null, null, 'Rico', null, null, 'S', 0, null, null, null, null, 'S');

insert into anscu2 (ID, CODICE_ANSC, DESCRIZIONE, PARTE, SERIE, SIGLA_CATEGORIA, TIPO_DOCUMENTO, TIPO_FILIAZIONE, NATO_MORTO, FASCIA_ETA_FIGLIO, TIPO_DICHIARANTE, TIPO_COMPARENTE, TIPO_COMPARENTE_ALTRO_SOGGETTO, ATTO_NOTARILE, TIPO_RICONOSCIMENTO, TIPO_CONSENSO, TIPO_ATTO_ANSC, DICHIARAZIONE_GIUDIZIALE, FLAG_SERVIZIO, FLAG_VISIBILE, VERSION, FLAG_EX_ART19, MOTIVO_ADOZIONE, TIPO_CONSENSO_2, FLAG_IN_VIAGGIO, FLAG_FIGLIO_DI_IGNOTI)
values (12226123, 'Rico_017', 'Riconoscimento di figlio di ignoti ultraquattordicenne da parte della madre con presenza padre', 2, 'B', 'RIC', null, null, null, 'SQ', 'MD', 'EN', null, null, null, null, 'Rico', null, null, 'S', 0, null, null, null, null, 'S');
