--liquibase formatted sql
--changeset amonopoli:202211181645 stripComments:false runOnChange:true

-- prompt 0-CHI-AVV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-AVV', 1, '', 'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro le note di trasmissione dei predetti avvocati e la copia del documento trascritto.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-AVV')
;
-- prompt 0-CHI-FCC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-FCC', 1, '', 'A tal fine mi hanno prodotto e;o acquisito i seguenti documenti:_____  che muniti del mio visto, allego al presente verbale.)'||chr(10)||'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me, i testimoni e il segretario comunale, lo sottoscrivono'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-FCC')
;
-- prompt 0-CHI-O1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-O1', 1, '', 'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me ed i testimoni, lo sottoscrivono', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-O1')
;
-- prompt 0-CHI-PDV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-PDV', 1, '', 'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me, i testimoni ed il segretario comunale, lo sottoscrivono', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-PDV')
;
-- prompt 0-CHI-PV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-PV1', 1, '', 'Il presente verbale viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-PV1')
;
-- prompt 0-CHI-PV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-PV2', 1, '', 'Il presente verbale viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-PV2')
;
-- prompt 0-CHI-PV3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-PV3', 1, '', 'Il presente verbale viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-PV3')
;
-- prompt 0-CHI-T2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-T2', 1, '', 'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me ed i testimoni, lo sottoscrivono', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-T2')
;
-- prompt 0-CHI-UAC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-UAC', 1, '', 'Il presente atto viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-UAC')
;
-- prompt 0-CHI-UCN
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-UCN', 1, '', 'Il presente verbale viene letto ai dichiaranti i quali, insieme con me lo sottoscrivono', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-UCN')
;
-- prompt 0-CHI-UCO
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-UCO', 1, '', 'Il presente atto viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-UCO')
;
-- prompt 0-CHI-UPD
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CHI-UPD', 1, '', 'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me ed i testimoni, lo sottoscrivono', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CHI-UPD')
;
-- prompt 0-CON-PAT
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-CON-PAT', 1, '', '-', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-CON-PAT')
;
-- prompt 0-DOC-UAC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-DOC-UAC', 1, '', 'A tal fine mi hanno prodotto i seguenti documenti:____che muniti del mio visto, inserisco nel volume degli allegati a questo registro.'||chr(10)||'Ho invitato le parti a comparire nuovamente davanti a questo Ufficio per la conferma dell''accordo nel giorno <CONFERMA_DATA> e li ho informati che la mancata comparizione equivale a mancata conferma dell''accordo.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-DOC-UAC')
;
-- prompt 0-FIR
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-FIR', 1, '', '____________________L''UFFICIALE DELLO STATO CIVILE', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-FIR')
;
-- prompt 0-FIR-AVV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-FIR-AVV', 1, '', 'F.to <COGNOME_NOME_1>'||chr(10)||'F.to <COGNOME_NOME_2>'||chr(10)||'Avvocato: F.to <AVVOCATO_1>'||chr(10)||'Avvocato: F.to <AVVOCATO_2>'||chr(10)||'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-FIR-AVV')
;
-- prompt 0-FIR-DIV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-FIR-DIV1', 1, '', '______________________________'||chr(10)||'______________________________'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-FIR-DIV1')
;
-- prompt 0-FIR-DIV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-FIR-DIV2', 1, '', '______________________________'||chr(10)||'______________________________'||chr(10)||'Avvocato _____________________ Avvocato _____________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-FIR-DIV2')
;
-- prompt 0-FIR-PV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-FIR-PV1', 1, '', '____________________L''UFFICIALE DELLO STATO CIVILE', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-FIR-PV1')
;
-- prompt 0-FIR-PV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-FIR-PV2', 1, '', '____________________L''UFFICIALE DELLO STATO CIVILE', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-FIR-PV2')
;
-- prompt 0-FIR-PV3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-FIR-PV3', 1, '', '____________________L''UFFICIALE DELLO STATO CIVILE', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-FIR-PV3')
;
-- prompt 0-MAR-CON
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-MAR-CON', 1, '', '<MARGINE_CONVENZIONI>'||chr(10)||'<MARGINE_CONVENZIONI_COMUNE> <MARGINE_CONVENZIONI_LI_DATA>'||chr(10)||'<MARGINE_CONVENZIONI_UFFICIALE> <MARGINE_CONVENZIONI_FIRMA>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-MAR-CON')
;
-- prompt 0-MAR-CO1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-MAR-CO1', 1, '', '<MARGINE_COGNOME_1>'||chr(10)||'<MARGINE_COGNOME_1_LI_DATA> <MARGINE_COGNOME_1_UFFICIALE> <MARGINE_COGNOME_1_FIRMA>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-MAR-CO1')
;
-- prompt 0-MAR-CO2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-MAR-CO2', 1, '', '<MARGINE_COGNOME_2>'||chr(10)||'<MARGINE_COGNOME_2_LI_DATA> <MARGINE_COGNOME_2_UFFICIALE> <MARGINE_COGNOME_2_FIRMA>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-MAR-CO2')
;
-- prompt 0-PDO
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-PDO', 1, '', 'I documenti <PRESA_VISIONE_DOCUMENTI> sono:'||chr(10)||'per una parte:'||chr(10)||'<RIGA_ESTRATTO_1>'||chr(10)||'<RIGA_CUMULATIVO_1>'||chr(10)||'per l''altra parte:'||chr(10)||'<RIGA_ESTRATTO_2>'||chr(10)||'<RIGA_CUMULATIVO_2>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-PDO')
;
-- prompt 0-PDO-NP
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-PDO-NP', 1, '', '-', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-PDO-NP')
;
-- prompt 0-PDO-PVC1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-PDO-PVC1', 1, '', 'che, muniti del mio visto, allego al presente verbale.'||chr(10)||'Ho invitato le parti a comparire nuovamente davanti a questo Ufficio per rendere la dichiarazione costitutiva dell''unione civile nel giorno <DATA_UNIONE_VERBALE> e li ho informati che la mancata comparizione, senza giustificato motivo, di uno di loro o di entrambi equivale a rinuncia.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-PDO-PVC1')
;
-- prompt 0-PDO-PVC2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-PDO-PVC2', 1, '', 'Ho invitato le parti a comparire nuovamente davanti a questo Ufficio per rendere la dichiarazione costitutiva dell''unione civile nel giorno <DATA_UNIONE_VERBALE> e li ho informati che la mancata comparizione, senza giustificato motivo, di uno di loro o di entrambi equivale a rinuncia.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-PDO-PVC2')
;
-- prompt 0-PDO-PVNP
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-PDO-PVNP', 1, '', '', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-PDO-PVNP')
;
-- prompt 0-PDO-PV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-PDO-PV1', 1, '', 'A tal fine mi hanno formulato richiesta di rendere la dichiarazione costitutiva dell''unione civile e hanno prodotto i seguenti documenti:'||chr(10)||'per una parte:'||chr(10)||'<RIGA_ESTRATTO_1>'||chr(10)||'<RIGA_CUMULATIVO_1>'||chr(10)||'per l''altra parte:'||chr(10)||'<RIGA_ESTRATTO_2>'||chr(10)||'<RIGA_CUMULATIVO_2>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-PDO-PV1')
;
-- prompt 0-PDO-PV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-PDO-PV2', 1, '', '........ (indicare la causa ostativa, tra quelle previste dalla legge) e di essere stati autorizzati all''unione civile con decreto del Tribunale di <SENTENZA_TRIBUNALE>, emesso il <SENTENZA_DATA> ai sensi dell''articolo 87, quarto comma, del codice civile.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-PDO-PV2')
;
-- prompt 0-PDO-PV3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-PDO-PV3', 1, '', 'A tal fine mi hanno formulato richiesta di rendere la dichiarazione costitutiva dell''unione civile e hanno prodotto i seguenti documenti:'||chr(10)||'per una parte:'||chr(10)||'<RIGA_ESTRATTO_1>'||chr(10)||'<RIGA_CUMULATIVO_1>'||chr(10)||'per l''altra parte:'||chr(10)||'<RIGA_ESTRATTO_2>'||chr(10)||'<RIGA_CUMULATIVO_2>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-PDO-PV3')
;
-- prompt 0-RIC-PV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RIC-PV1', 1, '', '<COGNOME_1> <NOME_1>'||chr(10)||'<NAT_OA_1> il <DATA_NASCITA_1>'||chr(10)||'a <COMUNE_NASCITA_1>'||chr(10)||'residente in <COMUNE_RESIDENZA_1>'||chr(10)||'<CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'E'||chr(10)||'<COGNOME_2> <NOME_2>'||chr(10)||'<NAT_OA_2> il <DATA_NASCITA_2>'||chr(10)||'a <COMUNE_NASCITA_2>'||chr(10)||'residente in <COMUNE_RESIDENZA_2>'||chr(10)||'<CITTADIN_OA_2>  <NAZIONALITA_2>'||chr(10)||'i quali mi dichiarano:'||chr(10)||'- di non avere vincoli matrimoniali o di unioni civile tra persone dello stesso sesso;'||chr(10)||'- di non essere interdetti per infermita'' di mente, neppure per sentenza non passata in giudicato;'||chr(10)||'- di non essere sottoposti a procedimento di interdizione in virtu'' del promovimento della relativa istanza;'||chr(10)||'- di non essere tra loro ascendenti o discendenti in linea retta;'||chr(10)||'- di non essere tra loro fratelli o sorelle germani, consanguinei o uterini;'||chr(10)||'- di non essere tra loro zio e nipote o zia e nipote;'||chr(10)||'- di non essere tra loro affini in linea retta, neppure per matrimonio dichiarato nullo o sciolto o per il quale e'' stata pronunziata la cessazione degli effetti civili;'||chr(10)||'- di non essere tra loro affini in linea collaterale in secondo grado;'||chr(10)||'- di non essere tra loro adottanti, adottati ne'' loro discendenti;'||chr(10)||'- di non essere figli adottivi della stessa persona;'||chr(10)||'- di non essere tra loro adottato e figlio dell''adottante;'||chr(10)||'- di non essere tra loro adottato e coniuge dell''adottante ne'' adottante e coniuge dell''adottato;'||chr(10)||'- di non essere stati condannati per sentenza definitiva per omicidio consumato o tentato nei confronti di chi sia stato coniugato o unito civilmente con uno di loro;'||chr(10)||'- di non essere stati condannati per sentenza non definitiva per omicidio consumato o tentato nei confronti di chi sia stato coniugato o unito civilmente con uno di loro, ne'' di essere stati sottoposti a rinvio a giudizio o a misura cautelare per uno di tali delitti;'||chr(10)||'- di voler costituire, mediante dichiarazione di fronte all''ufficiale dello stato civile, l''unione civile tra di loro.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RIC-PV1')
;
-- prompt 0-RIC-PV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RIC-PV2', 1, '', '<COGNOME_1> <NOME_1>'||chr(10)||'<NAT_OA_1> il <DATA_NASCITA_1>'||chr(10)||'a <COMUNE_NASCITA_1>'||chr(10)||'residente in <COMUNE_RESIDENZA_1>'||chr(10)||'<CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'E'||chr(10)||'<COGNOME_2> <NOME_2>'||chr(10)||'<NAT_OA_2> il <DATA_NASCITA_2>'||chr(10)||'a <COMUNE_NASCITA_2>'||chr(10)||'residente in <COMUNE_RESIDENZA_2>'||chr(10)||'<CITTADIN_OA_2>  <NAZIONALITA_2>'||chr(10)||'i quali, nel presentare la richiesta di rendere la dichiarazione costitutiva dell''unione civile ai sensi dell''articolo 1, comma 2, della legge 20 maggio 2016, n. 76, mi dichiarano di essere nella seguente condizione'||chr(10)||'tra quelle di cui all''artico 1, comma 4, della legge 20 maggio 2016, n. 76:'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RIC-PV2')
;
-- prompt 0-RIC-PV3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RIC-PV3', 1, '', '1) il (la) detto (a) <COGNOME_1> <NOME_1>'||chr(10)||'<NAT_OA_1> il <DATA_NASCITA_1>'||chr(10)||'a <COMUNE_NASCITA_1>'||chr(10)||'<CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'residente in <COMUNE_RESIDENZA_1>'||chr(10)||'2) <COGNOME_2> <NOME_2>'||chr(10)||'<NAT_OA_2> il <DATA_NASCITA_2>'||chr(10)||'a <COMUNE_NASCITA_2>'||chr(10)||'<CITTADIN_OA_2>  <NAZIONALITA_2>'||chr(10)||'residente in <COMUNE_RESIDENZA_2>'||chr(10)||''||chr(10)||'I quali mi hanno chiesto di ricevere la richiesta di rendere la dichiarazione costitutiva dell''unione civile e mi dichiarano:'||chr(10)||'- di non avere vincoli matrimoniali o di unioni civile tra persone dello stesso sesso;'||chr(10)||'- di non essere interdetti per infermita'' di mente, neppure per sentenza non passata in giudicato;'||chr(10)||'- di non essere sottoposti a procedimento di interdizione in virtu'' del promovimento della relativa istanza;'||chr(10)||'- di non essere tra loro ascendenti o discendenti in linea retta;'||chr(10)||'- di non essere tra loro fratelli o sorelle germani, consanguinei o uterini;'||chr(10)||'- di non essere tra loro zio e nipote o zia e nipote;'||chr(10)||'- di non essere tra loro affini in linea retta, neppure per matrimonio dichiarato nullo o sciolto o per il quale è stata pronunziata la cessazione degli effetti civili;'||chr(10)||'- di non essere tra loro affini in linea collaterale in secondo grado;'||chr(10)||'- di non essere tra loro adottanti, adottati ne'' loro discendenti;'||chr(10)||'- di non essere figli adottivi della stessa persona;'||chr(10)||'- di non essere tra loro adottato e figlio dell''adottante;'||chr(10)||'- di non essere tra loro adottato e coniuge dell''adottante ne'' adottante e coniuge dell''adottato;'||chr(10)||'- di non essere stati condannati per sentenza definitiva per omicidio consumato o tentato nei confronti di chi sia stato coniugato o unito civilmente con uno di loro;'||chr(10)||'- di non essere stati condannati per sentenza non definitiva per omicidio consumato o tentato nei confronti di chi sia stato coniugato o unito civilmente con uno di loro, ne'' di essere stati sottoposti a rinvio a giudizio o a misura cautelare per uno di tali delitti;'||chr(10)||'- di voler costituire, mediante dichiarazione di fronte all''ufficiale dello stato civile, l''unione civile tra di loro.'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RIC-PV3')
;
-- prompt 0-RMA-UAC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RMA-UAC', 1, '', 'i quali mi dichiarano:'||chr(10)||'- di aver costituito l''unione civile tra loro in data <UCI_PREC_DATA> in <UCI_PREC_COMUNE>, dinanzi all''Ufficiale dello Stato Civile, di cui all''atto iscritto;trascritto nel registro delle unioni civili del Comune di <UCI_PREC_COMUNE_ATTO> (n. <UCI_PREC_ESTREMI_ATTO>);'||chr(10)||'- di essere;non essere parti in giudizio pendente, concernente lo scioglimento dell''unione civile tra gli stessi;'||chr(10)||'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||'- di volere lo scioglimento dell''unione civile tra loro.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RMA-UAC')
;
-- prompt 0-RMA-UCO
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RMA-UCO', 1, '', 'di volere confermare l''accordo di scioglimento dell''unione civile, concluso innanzi a questo ufficio in data <DATA_ACCORDO> di cui all''atto iscritto al n. <ACCORDO_ESTREMI_ATTO>.'||chr(10)||'A tal fine ho acquisito copia integrale dell''atto n. <ACCORDO_ESTREMI_ATTO> che, munito del mio visto, inserisco nel volume degli allegati a questo registro.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RMA-UCO')
;
-- prompt 0-RUC-FCC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RUC-FCC', 1, '', 'i quali mi hanno chiesto di ricevere la dichiarazione costitutiva dell''unione civile tra loro; a questo effetto e'' pervenuta dall''Ufficiale dello stato civile del Comune di_______, ove e'' stata presentata la richiesta di costituzione in data _______, la delega di cui all''articolo 70-quater del D.P.R. 3 novembre 2000, n. 396, fattami in data _______; allo stesso effetto <COGNOME_1> <NOME_1> e <COGNOME_2> <NOME_2>mi hanno prodotto (e;o acquisito e;o ho visionato) i documenti sotto descritti:'||chr(10)||'____________________'||chr(10)||'____________________'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RUC-FCC')
;
-- prompt 0-RUC-O1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RUC-O1', 1, '', 'i quali mi hanno reso la dichiarazione di voler costituire l''unione civile tra di loro e, a questo effetto, mi hanno presentato i documenti sotto descritti che, muniti del mio visto, inserisco nel volume degli allegati a questo registro, insieme con quelli già prodotti all''atto della richiesta di costituzione. Dall''esame di tutti gli anzidetti documenti risultandomi nulla ostare alla costituzione dell''unione, ho letto alle persone da unire civilmente i commi 11 e 12 dell''articolo 1 della legge 20 maggio 2016, n. 76, quindi ho domandato a ciascuna delle due persone da unire civilmente se intende unirsi civilmente con l''altro, ed avendomi ciascuno risposto affermativamente a piena intelligenza anche dei testimoni sottoindicati, ho dichiarato che e'' costituita l''unione civile tra i medesimi. ', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RUC-O1')
;
-- prompt 0-RUC-PDV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RUC-PDV', 1, '', 'i quali mi hanno chiesto di ricevere la dichiarazione costitutiva dell''unione civile tra loro; a questo effetto e'' pervenuta dall''Ufficiale dello stato civile del Comune di_______, ove e'' stata presentata la richiesta di costituzione in data _______, la delega di cui all''articolo 70-quater del D.P.R. 3 novembre 2000, n. 396, fattami in data _______; allo stesso effetto <COGNOME_1> <NOME_1> e <COGNOME_2> <NOME_2>mi hanno prodotto (e;o acquisito e;o ho visionato) i documenti sotto descritti:'||chr(10)||'____________________'||chr(10)||'____________________'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RUC-PDV')
;
-- prompt 0-RUC-T2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-RUC-T2', 1, '', 'i quali mi hanno chiesto di ricevere la dichiarazione costitutiva dell''unione civile tra loro; a questo effetto e'' pervenuta dall''Ufficiale dello stato civile del Comune di_______, ove e'' stata presentata la richiesta di costituzione in data _______, la delega di cui all''articolo 70-quater del D.P.R. 3 novembre 2000, n. 396, fattami in data _______; allo stesso effetto <COGNOME_1> <NOME_1> e <COGNOME_2> <NOME_2>mi hanno prodotto (e;o acquisito e;o ho visionato) i documenti sotto descritti:'||chr(10)||'____________________'||chr(10)||'____________________'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-RUC-T2')
;
-- prompt 0-SPO
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-SPO', 1, '', '<COGNOME_1> <NOME_1>'||chr(10)||'<NAT_OA_1> il <DATA_NASCITA_1> a <COMUNE_NASCITA_1>'||chr(10)||'<CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'residente in <COMUNE_RESIDENZA_1>'||chr(10)||'e'||chr(10)||'<COGNOME_2> <NOME_2>'||chr(10)||'<NAT_OA_2> il <DATA_NASCITA_2>'||chr(10)||'a <COMUNE_NASCITA_2>'||chr(10)||'<CITTADIN_OA_2> <NAZIONALITA_2>'||chr(10)||'residente in <COMUNE_RESIDENZA_2>'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-SPO')
;
-- prompt 0-SPO-DIV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-SPO-DIV1', 1, '', '<COGNOME_1> <NOME_1> '||chr(10)||'  <NAT_OA_1> in <COMUNE_NASCITA_1> <DATA_NASCITA_1>'||chr(10)||'  <CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'  residente in <COMUNE_RESIDENZA_1> '||chr(10)||'E'||chr(10)||'<COGNOME_2> <NOME_2> '||chr(10)||'  <NAT_OA_2> in <COMUNE_NASCITA_2> <DATA_NASCITA_2>'||chr(10)||'  <CITTADIN_OA_2> <NAZIONALITA_2>'||chr(10)||'  residente in <COMUNE_RESIDENZA_2> ', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-SPO-DIV1')
;
-- prompt 0-SPO-DIV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-SPO-DIV2', 1, '', '<COGNOME_1> <NOME_1> '||chr(10)||'  <NAT_OA_1> in <COMUNE_NASCITA_1> <DATA_NASCITA_1>'||chr(10)||'  <CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'  residente in <COMUNE_RESIDENZA_1> '||chr(10)||'  con l''assistenza dell''avvocato <AVVOCATO_1>'||chr(10)||'E'||chr(10)||'<COGNOME_2> <NOME_2> '||chr(10)||'  <NAT_OA_2> in <COMUNE_NASCITA_2> <DATA_NASCITA_2>'||chr(10)||'  <CITTADIN_OA_2> <NAZIONALITA_2>'||chr(10)||'  residente in <COMUNE_RESIDENZA_2> '||chr(10)||'  con l''assistenza dell''avvocato <AVVOCATO_2>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-SPO-DIV2')
;
-- prompt 0-TES-AVV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-AVV', 1, '', '______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-AVV')
;
-- prompt 0-TES-FCC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-FCC', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno <ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, in questo luogo <LUOGO_FUORI_CASA>, avendo <IMPOSSIBILITA_NOMINATIVO> comprovato con certificato del <IMPOSSIBILITA_CERTIFICATO> in data <IMPOSSIBILITA_DATA_CERTIFICATO> che per _____________ egli (ella) si trova nell''impossibilita'' di recarsi alla Casa comunale per costituire unione civile con <IMPOSSIBILITA_ALTRO_CONTRAENTE>, io  <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA mi sono qui trasferito insieme con il segretario comunale ed ho trovato:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-FCC')
;
-- prompt 0-TES-O1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-O1', 1, '', 'L''anno duemila<ANNO_OGGI> addi'' <GIORNO_OGGI> del mese di <MESE_OGGI>  alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, nella casa comunale di <COMUNE> in una sala aperta al pubblico.'||chr(10)||'Avanti a me, <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA, vestito in forma ufficiale, sono personalmente comparsi'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-O1')
;
-- prompt 0-TES-PDV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-PDV', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, io <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA, in quanto richiesto, mi sono trasferito con il segretario comunale ___________  in questo luogo _________________ posto in _______ al numero civico _____, ove ho trovato', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-PDV')
;
-- prompt 0-TES-PV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-PV1', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me, <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono comparsi', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-PV1')
;
-- prompt 0-TES-PV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-PV2', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me, <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono personalmente comparsi', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-PV2')
;
-- prompt 0-TES-PV3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-PV3', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, in questo luogo <LUOGO_FUORI_CASA>, avendo <IMPOSSIBILITA_NOMINATIVO> comprovato con certificato del <IMPOSSIBILITA_CERTIFICATO> in data <IMPOSSIBILITA_DATA_CERTIFICATO> che per _____________ che viene allegato agli atti, il medesimo;la medesima si trova nell''impossibilita'' di recarsi alla Casa comunale per presentare la richiesta di rendere la dichiarazione costitutiva dell''unione civile con <IMPOSSIBILITA_ALTRO_CONTRAENTE>, io  <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA mi sono qui trasferito ed ho trovato:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-PV3')
;
-- prompt 0-TES-T2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-T2', 1, '', 'L''anno duemila<ANNO_ATTO_ORIGINALE> addi'' <GIORNO_ATTO_ORIGINALE> del mese di <MESE_ATTO_ORIGINALE>  alle ore <ORE_ATTO_ORIGINALE> e minuti <MINUTI_ATTO_ORIGINALE>, nella casa comunale di <COMUNE_PROV> in una sala aperta al pubblico.Avanti a me, <UFFICIALE_PROV> Ufficiale dello Stato Civile del Comune di <COMUNE_PROV> PER DELEGA AVUTA, vestito in forma ufficiale, sono personalmente comparsi', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-T2')
;
-- prompt 0-TES-UAC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-UAC', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me <UFFICIALE_UTENTE>, Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono comparsi gli uniti civilmente:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-UAC')
;
-- prompt 0-TES-UCN
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-UCN', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me, <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono personalmente comparsi i coniugi', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-UCN')
;
-- prompt 0-TES-UCO
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-UCO', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me <UFFICIALE_UTENTE>, Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono comparsi gli uniti civilmente:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-UCO')
;
-- prompt 0-TES-UPD
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TES-UPD', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me  <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA, sono personalmente comparsi:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TES-UPD')
;
-- prompt 0-TTE
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TTE', 1, '', 'A quest''atto sono stati presenti quali testimoni:'||chr(10)||'<TESTIMONI_COGNOME_NOME_1>'||chr(10)||'<TESTIMONI_NATO_1> a <TESTIMONI_COMUNE_NAS_1>'||chr(10)||'il <TESTIMONI_DATA_NAS_1>'||chr(10)||'Residente a <TESTIMONI_RESIDENZA_1>'||chr(10)||'<TESTIMONI_CITTADINO_1> <TESTIMONI_NAZIONALITA_1>'||chr(10)||'<TESTIMONI_COGNOME_NOME_2>'||chr(10)||'<TESTIMONI_NATO_2> a <TESTIMONI_COMUNE_NAS_2>'||chr(10)||'il <TESTIMONI_DATA_NAS_2>'||chr(10)||'Residente a <TESTIMONI_RESIDENZA_2>'||chr(10)||'<TESTIMONI_CITTADINO_2> <TESTIMONI_NAZIONALITA_2>'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TTE')
;
-- prompt 0-TTR-AVV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TTR-AVV', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI> io sottoscritto <UFFICIALE_UTENTE>, Ufficiale dello stato civile del Comune di <COMUNE> per delega avuta, avendo ricevuto in data <DATA_NOTA_RIF> (prot. del Comune di <COMUNE> n. <PROTOCOLLO_PROV> del <DATA_PROTOCOLLO_PROV>) dall''avvocato '||chr(10)||'<AVVOCATO_1> con studio in <SEDE_AVVOCATO_1> , quale avvocato di <COGNOME_1> <NOME_1>'||chr(10)||'<AVVOCATO_2> con studio in <SEDE_AVVOCATO_2> , quale avvocato di <COGNOME_2> <NOME_2>,'||chr(10)||'la copia autenticata dell''accordo raggiunto a seguito di negoziazione assistita di scioglimento dell''unione civile concluso ai sensi dell''art.12, D.L. 12 settembre 2014, n. 132, convertito, con modificazione, dalla legge 10 novembre 2014, n. 162, munito delle certificazioni relative all''autografia delle firme ed alla conformita'' dello stesso alle norme imperative e all''ordine pubblico, nonche'' corredato del seguente provvedimento dell''autorita'' giudiziaria: ______________________________.'||chr(10)||'Aderendo a tale richiesta, provvedo alla trascrizione del documento, come segue:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TTR-AVV')
;
-- prompt 0-TTR-T2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '0-TTR-T2', 1, '', 'L''anno duemila<ANNO_OGGI> addi'' <GIORNO_OGGI> del mese di <MESE_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI> nella Casa comunale '||chr(10)||'Io <UFFICIALE_UTENTE>, Ufficiale dello Stato Civile di <COMUNE>, per delega avuta, avendo ricevuto dall''Ufficiale dello Stato Civile del Comune di <COMUNE_PROV> copia di verbale di trascrizione di atto di unione civile, trascrivo per intero la copia stessa, che e'' del tenore seguente:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '0-TTR-T2')
;
-- prompt 2-CHI-CNA1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-CHI-CNA1', 1, '', 'Il presente atto viene letto all''intervenuto, il quale, insieme con me lo sottoscrive.'||chr(10)||'<COMUNE_NASCITA>, <DATA_ATTO_ORIGINALE_GGMMAAAA>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-CHI-CNA1')
;
-- prompt 2-CHI-CNA2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-CHI-CNA2', 1, '', 'Il presente atto viene letto agli intervenuti, i quali tutti, insieme con me, lo sottoscrivono.'||chr(10)||'<COMUNE_NASCITA>, <DATA_ATTO_ORIGINALE_GGMMAAAA>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-CHI-CNA2')
;
-- prompt 2-CIR-PAR
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-CIR-PAR', 1, '', '-', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-CIR-PAR')
;
-- prompt 2-DIC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-DIC', 1, '', 'è compars<DICHIARANTE_COMPARSO> <DICHIARANTE> nat<DICHIARANTE_NATO> in <DICHIARANTE_COM_NAS> lì <DICHIARANTE_DATA_NAS> (3) <DICHIARANTE_PROF>, residente in <DICHIARANTE_RESIDENZA> <DICHIARANTE_IL>l<DICHIARANTE_LA> quale (4)', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-DIC')
;
-- prompt 2-DIC-CNA1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-DIC-CNA1', 1, '', 'è comparso <PATERNITA> nato in <COMUNE_NASCITA_PT> il <DATA_NASCITA_PT>, cittadino <NAZIONALITA_PT> residente in <COMUNE_RESIDENZA_PT> il quale, nella sua veste di padre dichiara quanto segue:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-DIC-CNA1')
;
-- prompt 2-DIC-CNA2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-DIC-CNA2', 1, '', 'e'' comparsa <MATERNITA> nata in <COMUNE_NASCITA_MT> il <DATA_NASCITA_MT>, cittadina <NAZIONALITA_MT> residente in <COMUNE_RESIDENZA_MT> la quale, nella sua veste di madre dichiara quanto segue:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-DIC-CNA2')
;
-- prompt 2-DIC-CNA3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-DIC-CNA3', 1, '', 'è compars<DICHIARANTE_COMPARSO> <DICHIARANTE> nat<DICHIARANTE_NATO> in <DICHIARANTE_COM_NAS> il <DICHIARANTE_DATA_NAS>, cittadina ... residente in <DICHIARANTE_RESIDENZA>, <DICHIARANTE_IL>l<DICHIARANTE_LA> quale, nella sua veste di madre dichiara quanto segue:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-DIC-CNA3')
;
-- prompt 2-DIC-CNA4
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-DIC-CNA4', 1, '', 'sono comparsi <PATERNITA> nato in <COMUNE_NASCITA_PT> il <DATA_NASCITA_PT>, cittadino <NAZIONALITA_PT>, residente in <COMUNE_RESIDENZA_PT>, e la signora <MATERNITA> nata in <COMUNE_NASCITA_MT>, il <DATA_NASCITA_MT>, cittadina <NAZIONALITA_MT>, residente in <COMUNE_RESIDENZA_MT>, i quali, nella loro veste di genitori naturali, dichiarano quanto segue:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-DIC-CNA4')
;
-- prompt 2-DNA
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-DNA', 1, '', 'alla presenza dei testimoni:'||chr(10)||'mi ha dichiarato quanto segue:'||chr(10)||'   Il giorno <GIORNO_NASCITA> del mese di <MESE_NASCITA> dell''anno <ANNO_NASCITA>, alle ore <ORE_NASCITA> e minuti <MINUTI_NASCITA> nel<NEL> (4bis) <LUOGO_NASCITA_RIGA1> <LUOGO_NASCITA_RIGA2> da (5)', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-DNA')
;
-- prompt 2-DNA-CNA
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-DNA-CNA', 1, '', 'Il giorno <GIORNO_NASCITA> del mese di <MESE_NASCITA> dell''anno <ANNO_NASCITA> alle ore <ORE> e minuti <MINUTI> in questo centro di nascita e'' nato un bambino di sesso <SESSO> al quale viene dato il nome di <NOME>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-DNA-CNA')
;
-- prompt 2-FIL-CNA1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIL-CNA1', 1, '', 'Detto bambino, la cui nascita e'' comprovata dall''allegata attestazione di nascita, e'' nato dall''unione dei dichiaranti non parenti ne'' affini nei gradi che ostano al riconoscimento ai sensi dell''art. 251 c.c.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-FIL-CNA1')
;
-- prompt 2-FIL-CNA2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIL-CNA2', 1, '', 'Detto bambino, la cui nascita e'' comprovata dall''allegata attestazione di nascita, e'' nato dalla signora <MATERNITA> nata in <COMUNE_NASCITA_MT>, il <DATA_NASCITA_MT>, cittadina <NAZIONALITA_MT>, residente in <COMUNE_RESIDENZA_MT>, coniugata con il signor <PATERNITA> nato in <COMUNE_NASCITA_PT> il <DATA_NASCITA_PT>, cittadino <NAZIONALITA_PT>, residente in <COMUNE_RESIDENZA_PT>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-FIL-CNA2')
;
-- prompt 2-FIR-CNA1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-CNA1', 1, '', 'Il Dichiarante F.to: <PATERNITA>'||chr(10)||'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-FIR-CNA1')
;
-- prompt 2-FIR-CNA2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-CNA2', 1, '', 'I Dichiaranti F.to: <PATERNITA> e <MATERNITA>'||chr(10)||'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-FIR-CNA2')
;
-- prompt 2-FIR-1A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-1A', 1, '', 'L''UFFICIALE DELLO STATO CIVILE '||chr(10)||'______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-FIR-1A')
;
-- prompt 2-FIR-1B
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-1B', 1, '', 'L''UFFICIALE DELLO STATO CIVILE '||chr(10)||'______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-FIR-1B')
;
-- prompt 2-FIR-2A-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-2A-1', 1, '', 'f.to <DICHIARANTE>'||chr(10)||' L''UFFICIALE DELLO STATO CIVILE f.to: <CHIUSURA_FIRMA>'||chr(10)||'Eseguita la trascrizione, ho munito del mio visto ed inserito la copia suddetta nel volume degli allegati a questo registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-FIR-2A-1')
;
-- prompt 2-FIR-2A-2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-2A-2', 1, '', 'f.to <PATERNITA>'||chr(10)||'f.to <MATERNITA>'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE f.to: <UFFICIALE_PROV>'||chr(10)||'Eseguita la trascrizione, ho munito del mio visto ed inserito la copia suddetta nel volume degli allegati a questo registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-FIR-2A-2')
;
-- prompt 2-MAR-SEN
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-MAR-SEN', 1, '', 'Con sentenza del Tribunale di <MARGINE_SENTENZA_TRIBUNALE_1> <MARGINE_SENTENZA_TRIBUNALE_2> in data <MARGINE_SENTENZA_DATA>'||chr(10)||'<MARGINE_SENTENZA_ANNO> trascritta nei registri di nascita di questo Comune al N. <MARGINE_SENTENZA_ATTO_TRAS> P.II Serie B, dell''anno <MARGINE_SENTENZA_ANNO_TRAS> il presente atto <MARGINE_SENTENZA_E_STATO> dichiarato valido.'||chr(10)||'li <MARGINE_SENTENZA_DATA_FIRMA> '||chr(10)||'L''UFFICIALE DELLO STATO CIVILE '||chr(10)||'______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-MAR-SEN')
;
-- prompt 2-MAR-TR1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-MAR-TR1', 1, '', 'Il presente atto di nascita è stato trascritto nei registri di Stato Civile del Comune di <MARGINE_TRASCRIZIONE_COMUNE> al N. <MARGINE_TRASCRIZIONE_ATTO> P. <MARGINE_TRASCRIZIONE_PARTE> S. <MARGINE_TRASCRIZIONE_SERIE> Anno <MARGINE_TRASCRIZIONE_ANNO_ATTO> come da comunicazione del <MARGINE_TRASCRIZIONE_DATA_COM>'||chr(10)||'   li <MARGINE_TRASCRIZIONE_DATA> '||chr(10)||'   L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'   ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-MAR-TR1')
;
-- prompt 2-PRE
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-PRE', 1, '', 'è nato un bambino di sesso <PRESENTAZIONE_SESSO>'||chr(10)||'   A detto bambino che (6) <PRESENTAZIONE_NON> <PRESENTAZIONE_PRESENTATO> <PRESENTAZIONE_RIGA1> <PRESENTAZIONE_RIGA2> '||chr(10)||'(7) <PRESENTAZIONE_IL_LA> <PRESENTAZIONE_DA_IL_NOME> <PRESENTAZIONE_NOME> <PRESENTAZIONE_RIGA3>'||chr(10)||'(8) <PRESENTAZIONE_RIGA4>'||chr(10)||'(9)', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-PRE')
;
-- prompt 2-TES
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-TES', 1, '', 'L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> nel (1) <TESTATA_UBICAZIONE>'||chr(10)||'   Avanti a me, <TESTATA_UFFICIALE>, Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, (2) <TESTATA_MOTIVO>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-TES')
;
-- prompt 2-TES-CNA1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-TES-CNA1', 1, '', 'ATTO DI DICHIARAZIONE DI NASCITA'||chr(10)||'Atto Numero <NOTA_RIF>/<ANNO_NOTA_RIF> del Registro'||chr(10)||'L''anno <anno_atto_originale> addi <giorno_atto_originale> del mese di <mese_atto_originale> alle ore <ore_atto_originale> e minuti <minuti_atto_originale>'||chr(10)||'presso <luogo_nascita> sito nel Comune di <COMUNE_NASCITA>'||chr(10)||'Innanzi al sottoscritto addetto alla Direzione Sanitaria, a cio'' espressamente autorizzato dal Direttore Sanitario con delega conservata in atti:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-TES-CNA1')
;
-- prompt 2-TES-CNA2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-TES-CNA2', 1, '', 'ATTO DI DICHIARAZIONE DI NASCITA'||chr(10)||'Atto Numero <NOTA_RIF>/<ANNO_NOTA_RIF> del Registro'||chr(10)||'L''anno <anno_atto_originale> addi <giorno_atto_originale> del mese di <mese_atto_originale> alle ore <ore_atto_originale> e minuti <minuti_atto_originale>'||chr(10)||'presso <luogo_nascita> sito nel Comune di <COMUNE_NASCITA> '||chr(10)||'Innanzi al sottoscritto Direttore Medico <UFFICIALE_PROV>:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-TES-CNA2')
;
-- prompt 2-TTR
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-TTR', 1, '', 'L''anno <TRASCRIZIONE_ANNO> addì <TRASCRIZIONE_GIORNO> del mese di <TRASCRIZIONE_MESE> alle ore <TRASCRIZIONE_ORE> e minuti <TRASCRIZIONE_MINUTI> nella Casa Comunale. '||chr(10)||'   Io <TRASCRIZIONE_UFFICIALE>, Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE>, (1) <TRASCRIZIONE_MOTIVO> avendo ricevuto in data <TRASCRIZIONE_DATA>'||chr(10)||'dall''Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE_ATTO_ORIG>  copia di atto di nascita, trascrivo per intero la copia stessa, che è del tenore seguente: ', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-TTR')
;
-- prompt 2-TTR-CNA
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-TTR-CNA', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>'||chr(10)||'Io sottoscritto <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE_RESIDENZA> ho ricevuto da <AUTORITA_PROV> di <COMUNE_PROV> la richiesta in data <DATA_NOTA_RIF> di trascrivere l''attestazione di nascita di <COGNOME_NOME> <NAT_OA> a <COMUNE_NASCITA> il <DATA_NASCITA> di cui mi ha trasmesso copia.'||chr(10)||'Aderendo a tale richiesta provvedo alla trascrizione per intero del documento, come segue:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '2-TTR-CNA')
;
-- prompt 3-CHI-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-CHI-1', 1, '', 'Il presente atto viene letto agli intervenuti, i quali tutti, insieme con me, lo sottoscrivono.'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-CHI-1')
;
-- prompt 3-CHI-2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-CHI-2', 1, '', 'Il presente atto viene letto all''intervenuto, il quale, insieme con me, lo sottoscrive.'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-CHI-2')
;
-- prompt 3-CHI-3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-CHI-3', 1, '', 'Il presente atto viene letto all''intervenuta, la quale, insieme con me, lo sottoscrive.'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-CHI-3')
;
-- prompt 3-CHI-4
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-CHI-4', 1, '', 'Il presente atto viene letto all''intervenuto, il quale, insieme con me, lo sottoscrive.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-CHI-4')
;
-- prompt 3-FIR-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-FIR-1', 1, '', 'IL DICHIARANTE ______________________________'||chr(10)||''||chr(10)||'LA DICHIARANTE ______________________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-FIR-1')
;
-- prompt 3-FIR-2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-FIR-2', 1, '', 'IL DICHIARANTE ______________________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-FIR-2')
;
-- prompt 3-FIR-3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-FIR-3', 1, '', 'LA DICHIARANTE ______________________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-FIR-3')
;
-- prompt 3-FIR-4
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-FIR-4', 1, '', 'IL DICHIARANTE ______________________________L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-FIR-4')
;
-- prompt 3-PDO
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-PDO', 1, '', 'Esaminati i documenti <PRESA_VISIONE_DOCUMENTI> do'' atto dell''insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_MATRIMONIO>.'||chr(10)||'I documenti sono:'||chr(10)||'Per lo sposo: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSO> il <DATA_ESTRATTO_SPOSO>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSO> il <DATA_CUMULATIVO_SPOSO>.'||chr(10)||'Per la sposa: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSA> il <DATA_ESTRATTO_SPOSA>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSA> il <DATA_CUMULATIVO_SPOSA>.'||chr(10)||''||chr(10)||''||chr(10)||'Detti documenti, muniti del mio visto, inserisco come allegati al presente processo verbale.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-PDO')
;
-- prompt 3-PDO-NP
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-PDO-NP', 1, '', '', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-PDO-NP')
;
-- prompt 3-PDO-OME
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-PDO-OME', 1, '', 'Le dichiarazioni rese dagli sposi trovano conferma nei documenti <PRESA_VISIONE_DOCUMENTI> che sono:'||chr(10)||'Per lo sposo: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSO> il <DATA_ESTRATTO_SPOSO>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSO> il <DATA_CUMULATIVO_SPOSO>.'||chr(10)||'Per la sposa: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSA> il <DATA_ESTRATTO_SPOSA>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSA> il <DATA_CUMULATIVO_SPOSA>.'||chr(10)||'(... decreto di autorizzazione all''omissione delle pubblicazioni)', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-PDO-OME')
;
-- prompt 3-SPO-OME1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-OME1', 1, '', '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile <STATO_CIVILE_SPOSO>'||chr(10)||'E'||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile <STATO_CIVILE_SPOSA>'||chr(10)||' '||chr(10)||'i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti a'||chr(10)||''||chr(10)||'essi intendono contrarre senza la pubblicazione, della quale hanno ottenuto l''autorizzazione alla omissione, mi dichiarano che non esiste fra essi impedimento di parentela, affinita'', adozione o affiliazione, a termine dell''art. 87 del codice civile, ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-OME1')
;
-- prompt 3-SPO-OME2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-OME2', 1, '', '<cognome_nome_sposo> nato a <comune_nascita_sposo> il <data_nascita_sposo> cittadinanza <nazionalita_sposo> residente a <COMUNE_RESIDENZA_SPOSO> stato civile <STATO_CIVILE_SPOSO> E <cognome_nome_sposa> nata a <comune_nascita_sposa> il <data_nascita_sposa> cittadinanza <nazionalita_sposa> residente a <COMUNE_RESIDENZA_SPOSA> stato civile <STATO_CIVILE_SPOSA> i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti a essi intendono contrarre senza la pubblicazione, della quale hanno ottenuto l''autorizzazione alla omissione, mi dichiarano che non esiste fra essi impedimento di parentela, affinita'', adozione o affiliazione, a termine dell''art. 87 del codice civile, ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-OME2')
;
-- prompt 3-SPO-OME3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-OME3', 1, '', '<cognome_nome_sposo> nato a <comune_nascita_sposo> il <data_nascita_sposo> cittadinanza <nazionalita_sposo> residente a <COMUNE_RESIDENZA_SPOSO> stato civile <STATO_CIVILE_SPOSO> E <cognome_nome_sposa> nata a <comune_nascita_sposa> il <data_nascita_sposa> cittadinanza <nazionalita_sposa> residente a <COMUNE_RESIDENZA_SPOSA> stato civile <STATO_CIVILE_SPOSA> i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti a essi intendono contrarre senza la pubblicazione, della quale hanno ottenuto l''autorizzazione alla omissione, mi dichiarano che non esiste fra essi impedimento di parentela, affinita'', adozione o affiliazione, a termine dell''art. 87 del codice civile, ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-OME3')
;
-- prompt 3-SPO-OME4
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-OME4', 1, '', '(... indicare le generalita'' del procuratore)'||chr(10)||'come procuratore speciale di:'||chr(10)||'<cognome_nome_sposo> nato a <comune_nascita_sposo> il <data_nascita_sposo> cittadinanza <nazionalita_sposo> residente a <COMUNE_RESIDENZA_SPOSO> stato civile <STATO_CIVILE_SPOSO> E <cognome_nome_sposa> nata a <comune_nascita_sposa> il <data_nascita_sposa> cittadinanza <nazionalita_sposa> residente a <COMUNE_RESIDENZA_SPOSA> stato civile <STATO_CIVILE_SPOSA>'||chr(10)||'secondo quanto risulta da '||chr(10)||'(... indicare i dati della procura),'||chr(10)||'i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti a'||chr(10)||'gli stessi rappresentati intendono contrarre senza la pubblicazione, della quale hanno ottenuto l''autorizzazione alla omissione, mi dichiarano che non esiste fra gli sposi impedimento di parentela, affinita'', adozione o affiliazione, a termine dell''art. 87 del codice civile ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-OME4')
;
-- prompt 3-SPO-STR
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-STR', 1, '', '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile:'||chr(10)||' [] celibe'||chr(10)||' [] gia'' coniugato con'||chr(10)||'    il ___________ a'||chr(10)||' [] vedovo di'||chr(10)||'    deceduta il __________ a'||chr(10)||'_________________________________E'||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile:'||chr(10)||' [] nubile'||chr(10)||' [] gia'' coniugata con'||chr(10)||'    il ___________ a'||chr(10)||' [] vedova di'||chr(10)||'    deceduto il __________ a'||chr(10)||''||chr(10)||'i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti a'||chr(10)||''||chr(10)||'essi intendono contrarre senza la pubblicazione, da cui sono esenti in quanto cittadini stranieri non domiciliati ne'' residenti in Italia mi dichiarano che non esistono fra essi impedimenti di parentela, affinita'', adozione o affiliazione, a termini dell''art. 87, numeri 1, 2 e 4 del codice civile,ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-STR')
;
-- prompt 3-SPO-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-1', 1, '', '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile <STATO_CIVILE_SPOSO>'||chr(10)||'E'||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile <STATO_CIVILE_SPOSA>'||chr(10)||' '||chr(10)||'Davanti a me, sono comparsi a fare tale richiesta gli stessi sposi suindicati.'||chr(10)||'I richiedenti mi hanno altresi'' dichiarato di essere gli sposi di stato libero e che non osta al loro matrimonio alcun impedimento di parentela, di affinita'', di adozione e di affiliazione ai sensi dell''art. 87 del codice civile, ne'' che gli sposi hanno contratto fra loro precedente matrimonio, ne'' che alcuno di essi si trova nelle condizioni indicate negli artt. 85 e 88 del codice civile, ne'' che risulta sussistere altro impedimento stabilito dalla legge.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-1')
;
-- prompt 3-SPO-2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-2', 1, '', '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||'residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile <STATO_CIVILE_SPOSO> '||chr(10)||'E '||chr(10)||'<cognome_nome_sposa> '||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile <STATO_CIVILE_SPOSA> '||chr(10)||'Davanti a me, e'' comparso a fare tale richiesta lo sposo sopraindicato in nome ed anche per averne avuto incarico dalla sposa, come risulta da (... indicare i dati essenziali della procura) che munita del mio visto allego al presente processo verbale.'||chr(10)||'Il richiedente mi ha altresi'' dichiarato di essere gli sposi di stato libero e che non osta al loro matrimonio alcun impedimento di parentela, di affinita'', di adozione e di affiliazione ai sensi dell''art. 87 del codice civile, ne'' che gli sposi hanno contratto fra loro precedente matrimonio, ne'' che alcuno di essi si trova nelle condizioni indicate negli artt. 85 e 88 del codice civile, ne'' che risulta sussistere altro impedimento stabilito dalla legge.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-2')
;
-- prompt 3-SPO-3
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-3', 1, '', '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile <STATO_CIVILE_SPOSO> '||chr(10)||'E '||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile <STATO_CIVILE_SPOSA> '||chr(10)||'Davanti a me, e'' comparsa a fare tale richiesta la sposa sopraindicata in nome ed anche per averne avuto incarico dallo sposo, come risulta da (... indicare i dati essenziali della procura) che munita del mio visto allego al presente processo verbale.'||chr(10)||'Il richiedente mi ha altresi'' dichiarato di essere gli sposi di stato libero e che non osta al loro matrimonio alcun impedimento di parentela, di affinita'', di adozione e di affiliazione ai sensi dell''art. 87 del codice civile, ne'' che gli sposi hanno contratto fra loro precedente matrimonio, ne'' che alcuno di essi si trova nelle condizioni indicate negli artt. 85 e 88 del codice civile, ne'' che risulta sussistere altro impedimento stabilito dalla legge.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-3')
;
-- prompt 3-SPO-4
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-SPO-4', 1, '', '<cognome_nome_sposo> nato a <comune_nascita_sposo> il <data_nascita_sposo> cittadinanza <nazionalita_sposo> residente a <COMUNE_RESIDENZA_SPOSO> stato civile <STATO_CIVILE_SPOSO> E <cognome_nome_sposa> nata a <comune_nascita_sposa> il <data_nascita_sposa> cittadinanza <nazionalita_sposa> residente a <COMUNE_RESIDENZA_SPOSA> stato civile <STATO_CIVILE_SPOSA> Davanti a me, e'' comparso a fare tale richiesta'||chr(10)||'(... indicare le generalita'' del procuratore)'||chr(10)||'come procuratore speciale degli sposi, come risulta da'||chr(10)||'(... indicare i dati essenziali della procura)'||chr(10)||'che munita del mio visto allego al presente processo verbale.'||chr(10)||'Il richiedente mi ha altresi'' dichiarato di essere gli sposi di stato libero e che non osta al loro matrimonio alcun impedimento di parentela, di affinita'', di adozione e di affiliazione ai sensi dell''art. 87 del codice civile, ne'' che gli sposi hanno contratto fra loro precedente matrimonio, ne'' che alcuno di essi si trova nelle condizioni indicate negli artt. 85 e 88 del codice civile, ne'' che risulta sussistere altro impedimento stabilito dalla legge.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-SPO-4')
;
-- prompt 3-TES
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-TES', 1, '', '(Art. 96 del C.C. e artt. 50 e 51 del D.P.R. 3 novembre 2000, n. 396) '||chr(10)||''||chr(10)||'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e minuti <minuti_oggi> '||chr(10)||'io sottoscritto <ufficiale_utente> Ufficiale dello stato civile del Comune di <comune>, per delegazione avuta, sono stato richiesto di procedere alla pubblicazione del matrimonio che dinanzi all''ufficiale di stato civile ; al parroco della chiesa di ... intendono fra loro contrarre:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-TES')
;
-- prompt 3-TES-OME
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-TES-OME', 1, '', '(Art.100, comma 2 del C.C., art.58 del D.P.R. 3 novembre 2000, n.396) '||chr(10)||''||chr(10)||'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e minuti <minuti_oggi> '||chr(10)||'avanti a me <ufficiale_utente> Ufficiale dello stato civile del Comune di <comune>, per delegazione avuta, e'' comparso ; sono comparsi :', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-TES-OME')
;
-- prompt 3-TES-STR
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-TES-STR', 1, '', '(Art. 116, ultimo comma del codice civile) '||chr(10)||''||chr(10)||'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e minuti <minuti_oggi> '||chr(10)||'avanti a me <ufficiale_utente> Ufficiale dello stato civile del Comune di <comune>, per delegazione avuta, sono comparsi ', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '3-TES-STR')
;
-- prompt 4-ART
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-ART', 1, '', 'Agli sposi è stata data lettura degli articoli 143, 144 e 147 del Codice Civile da (10): <ARTICOLI_MINISTRO_RIGA1> <ARTICOLI_MINISTRO_RIGA2> davanti al quale il matrimonio è stato celebrato.'||chr(10)||'Io sottoscritto Ufficiale dello Stato Civile, ho constatato che la pubblicazione (11) <PUBBLICAZIONE_NON> fu eseguita (12):', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-ART')
;
-- prompt 4-CON-PAT
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-CON-PAT', 1, '', '-', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-CON-PAT')
;
-- prompt 4-DMA
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-DMA', 1, '', 'L''anno <DATI_MATRIMONIO_ANNO> addì <DATI_MATRIMONIO_GIORNO> del mese di <DATI_MATRIMONIO_MESE> alle ore <DATI_MATRIMONIO_ORE> e minuti <DATI_MATRIMONIO_MINUTI> '||chr(10)||'in (3) <DATI_MATRIMONIO_COMUNE> nel<DATI_MATRIMONIO_NEL> (4) <DATI_MATRIMONIO_LUOGO> sono stati uniti in matrimonio, secondo il rito (5) <DATI_MATRIMONIO_RITO_RIGA1> <DATI_MATRIMONIO_RITO_RIGA2> <DATI_MATRIMONIO_RITO_RIGA3>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-DMA')
;
-- prompt 4-DOC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-DOC', 1, '', 'I<DOCUMENTI_IL> document<DOCUMENTI_DOCUMENTO> presentat<DOCUMENTI_PRESENTATO> (6)', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-DOC')
;
-- prompt 4-DOC-UAC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-DOC-UAC', 1, '', 'A tal fine ho acquisito i seguenti documenti: copia integrale dell''atto di matrimonio, copia integrale degli atti di nascita, decreto di omologazione della separazione consensuale e le dichiarazioni da parte di entrambi i coniugi di voler pervenire alla cessazione degli effetti civili del matrimonio, che muniti del mio visto, inserisco nel volume degli allegati a questo registro.'||chr(10)||'Ho invitato le parti a comparire nuovamente davanti a questo Ufficio per la conferma dell''accordo nel giorno <CONFERMA_DATA> e li ho informati che la mancata comparizione equivale a mancata conferma dell''accordo.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-DOC-UAC')
;
-- prompt 4-FIR-AVV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-FIR-AVV', 1, '', '<COMUNE_ACCORDO_DIVORZIO>, <DATA_ACCORDO_DIVORZIO_GGMMAAAA>'||chr(10)||'Sposa: F.to <COGNOME_NOME_SPOSA>'||chr(10)||'Sposo: F.to <COGNOME_NOME_SPOSO>'||chr(10)||'Avvocato: F.to <AVVOCATO_SPOSA>'||chr(10)||'Avvocato: F.to <AVVOCATO_SPOSO>'||chr(10)||'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-FIR-AVV')
;
-- prompt 4-FIR-DIV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-FIR-DIV1', 1, '', 'Sposo ______________________________ Sposa ______________________________L''UFFICIALE DELLO STATO CIVILE __________________________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-FIR-DIV1')
;
-- prompt 4-FIR-DIV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-FIR-DIV2', 1, '', 'Sposo ______________________________ Sposa ______________________________'||chr(10)||'Avvocato Sposo _____________________ Avvocato Sposa _____________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-FIR-DIV2')
;
-- prompt 4-FIR-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-FIR-1', 1, '', 'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-FIR-1')
;
-- prompt 4-FIR-2A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-FIR-2A', 1, '', 'Dato atto di quanto sopra ho eseguito in data odierna la trascrizione dell''atto di matrimonio e, dopo averli muniti del mio visto, inserisco l''atto medesimo e i documenti acquisiti nel volume degli allegati al presente registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'______________________________'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-FIR-2A')
;
-- prompt 4-FIR-2B
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-FIR-2B', 1, '', 'Dato atto di quanto sopra, ho eseguito in data odierna la trascrizione dell''atto di matrimonio e, dopo averli muniti del mio visto, inserisco l''atto medesimo e i documenti acquisiti nel volume degli allegati al presente registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE f.to <CITT_MATRIMONIO_FIRMA>'||chr(10)||'Eseguita la trascrizione, ho munito del mio visto ed inserito la copia suddetta nel volume degli allegati.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE '||chr(10)||'___________________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-FIR-2B')
;
-- prompt 4-FIR-2C
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-FIR-2C', 1, '', 'Sposo ______________________________ Sposa ______________________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-FIR-2C')
;
-- prompt 4-MAR-CON
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-MAR-CON', 1, '', '<MARGINE_CONVENZIONI>'||chr(10)||'<MARGINE_CONVENZIONI_COMUNE> <MARGINE_CONVENZIONI_LI_DATA>'||chr(10)||'<MARGINE_CONVENZIONI_UFFICIALE>'||chr(10)||'<MARGINE_CONVENZIONI_FIRMA>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-MAR-CON')
;
-- prompt 4-MAR-LIB
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-MAR-LIB', 1, '', '<MARGINE_LIBRETTO>'||chr(10)||'<MARGINE_LIBRETTO_LI_DATA>'||chr(10)||'<MARGINE_LIBRETTO_UFFICIALE>'||chr(10)||'<MARGINE_LIBRETTO_FIRMA>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-MAR-LIB')
;
-- prompt 4-MAR-MIN
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-MAR-MIN', 1, '', 'In data <MARGINE_TRAMSESSO_DATA> duemila<MARGINE_TRASMESSO_ANNO> ho trasmesso notizia al ministro del culto di (14) <MARGINE_TRASMESSO_MINISTRO_1_2> dell''eseguita trascrizione dell''atto controscritto con l''indicazione della data in cui essa e'' stata effettuata.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-MAR-MIN')
;
-- prompt 4-MAR-TR1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-MAR-TR1', 1, '', 'Il presente atto di matrimonio e'' stato altresi'' trascritto nei registri di Stato Civile del Comune di <MARGINE_TRASCRITTO_COMUNE_1> al N. <MARGINE_TRASCRITTO_ATTO_1> P. <MARGINE_TRASCRITTO_PARTE_1> S. <MARGINE_TRASCRITTO_SERIE_1> Anno <MARGINE_TRASCRITTO_ANNO_1> come da comunicazione del <MARGINE_TRASCRITTO_DATA_COM_1> <MARGINE_TRASCRITTO_NUM_COM_1> <MARGINE_TRASCRITTO_COM_FIRMA_1>, li <MARGINE_TRASCRITTO_DATA_1>'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-MAR-TR1')
;
-- prompt 4-MAR-TR2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-MAR-TR2', 1, '', 'Il presente atto di matrimonio e'' stato altresi'' trascritto nei registri di Stato Civile del Comune di <MARGINE_TRASCRITTO_COMUNE_2> al N. <MARGINE_TRASCRITTO_ATTO_2> P. <MARGINE_TRASCRITTO_PARTE_2> S. <MARGINE_TRASCRITTO_SERIE_2> Anno <MARGINE_TRASCRITTO_ANNO_2> come da comunicazione del <MARGINE_TRASCRITTO_DATA_COM_2> <MARGINE_TRASCRITTO_NUM_COM_2> <MARGINE_TRASCRITTO_COM_FIRMA_2>, li <MARGINE_TRASCRITTO_DATA_2>'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-MAR-TR2')
;
-- prompt 4-RMA
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-RMA', 1, '', 'i quali mi hanno richiesto di unirli in matrimonio e a questo effetto mi hanno presentato i<RICHIESTA_IL> document<RICHIESTA_DOCUMENTO> sotto descritt<RICHIESTA_DESCRITTO> che, munit<RICHIESTA_MUNITO> del mio visto, inserisco nel volume degli allegati a questo registro, insieme con quelli già prodotti all''atto della richiesta della pubblicazione. Dall''esame di tutti gli anzidetti documenti risultandomi nulla ostare alla celebrazione del matrimonio, ho letto agli sposi gli articoli 143, 144 e 147 del Codice Civile, quindi ho domandato allo sposo se intende di prendere in moglie la qui presente (3) <RICHIESTA_COGNOME_NOME_SPOSA> e a questa se intende di prendere in marito il qui presente (2) <RICHIESTA_COGNOME_NOME_SPOSO> ; ed avendomi ciascuno risposto affermativamente a piena intelligenza anche dei testimoni sottoindicati, ho dichiarato che i medesimi sono uniti in matrimonio. '||chr(10)||'A quest''atto sono stati presenti quali testimoni:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-RMA')
;
-- prompt 4-RMA-UAC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-RMA-UAC', 1, '', '- di avere contratto matrimonio in data <MATRIMONIO_PREC_DATA> in <MATRIMONIO_PREC_COMUNE>, dinanzi a <MATRIMONIO_PREC_DINANZI>, di cui all''atto trascritto nei registri dello stato civile del Comune di <MATRIMONIO_PREC_COMUNE_ATTO> (n. <MATRIMONIO_PREC_ESTREMI_ATTO>);'||chr(10)||'- di non essere parti in giudizio pendente, concernente la <TIPO_DIVORZIO> tra gli stessi;'||chr(10)||'- di essere legalmente separati a seguito di:'||chr(10)||'Ricorso per separazione consensuale depositato in Cancelleria presso il Tribunale di ...__________ in data ...__________;'||chr(10)||'e di trovarsi in uno dei casi di cui all''articolo 3, primo comma, numero2), lettera b), legge 10 dicembre 1970, n. 898;'||chr(10)||'- di non essere genitori di figli minori;'||chr(10)||'- di non essere genitori di figli maggiorenni incapaci;'||chr(10)||'- di non essere genitori di figli maggiorenni portatori di handicap grave ai sensi dell''articolo3, comma 3, della legge 5 febbraio 1992, n. 104;'||chr(10)||'- di non essere genitori di figli maggiorenni economicamente non autosufficienti;'||chr(10)||'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||'- di volere la cessazione degli effetti civili del matrimonio', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-RMA-UAC')
;
-- prompt 4-RMA-UCO
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-RMA-UCO', 1, '', 'di volere confermare l''accordo di <TIPO_DIVORZIO>, concluso innanzi a questo ufficio in data <ACCORDO_DATA> di cui all''atto iscritto al n. <ACCORDO_ESTREMI_ATTO>.'||chr(10)||'A tal fine ho acquisito copia integrale dell''atto n. <ACCORDO_ESTREMI_ATTO> che, munito del mio visto, inserisco nel volume degli allegati a questo registro.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-RMA-UCO')
;
-- prompt 4-SPO-DIV1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-SPO-DIV1', 1, '', '<COGNOME_SPOSO> <NOME_SPOSO> '||chr(10)||'  nato in <COMUNE_NASCITA_SPOSO> <DATA_NASCITA_SPOSO>'||chr(10)||'  cittadinanza <NAZIONALITA_SPOSO>'||chr(10)||'  residente in <COMUNE_RESIDENZA_SPOSO> '||chr(10)||'E'||chr(10)||'<COGNOME_SPOSA> <NOME_SPOSA> '||chr(10)||'  nato in <COMUNE_NASCITA_SPOSA> <DATA_NASCITA_SPOSA>'||chr(10)||'  cittadinanza <NAZIONALITA_SPOSA>'||chr(10)||'  residente in <COMUNE_RESIDENZA_SPOSA> '||chr(10)||'i quali mi dichiarano:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-SPO-DIV1')
;
-- prompt 4-SPO-DIV2
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-SPO-DIV2', 1, '', '<COGNOME_SPOSO> <NOME_SPOSO> '||chr(10)||'  nato in <COMUNE_NASCITA_SPOSO> <DATA_NASCITA_SPOSO>'||chr(10)||'  cittadinanza <NAZIONALITA_SPOSO>'||chr(10)||'  residente in <COMUNE_RESIDENZA_SPOSO> '||chr(10)||'  con l''assistenza dell''avvocato <AVVOCATO_SPOSO>'||chr(10)||'E'||chr(10)||'<COGNOME_SPOSA> <NOME_SPOSA> '||chr(10)||'  nato in <COMUNE_NASCITA_SPOSA> <DATA_NASCITA_SPOSA>'||chr(10)||'  cittadinanza <NAZIONALITA_SPOSA>'||chr(10)||'  residente in <COMUNE_RESIDENZA_SPOSA> '||chr(10)||'  con l''assistenza dell''avvocato <AVVOCATO_SPOSA> '||chr(10)||'i quali mi dichiarano:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-SPO-DIV2')
;
-- prompt 4-SPO-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-SPO-1', 1, '', '(2) <SPOSI_COGNOME_M> <SPOSI_NOME_M>'||chr(10)||'  nato in <SPOSI_COMUNE_NAS_M>'||chr(10)||'  li <SPOSI_DATA_NAS_M_RIGA1> <SPOSI_DATA_NAS_F_RIGA2>'||chr(10)||'  N. <SPOSI_ATTO_NAS_M> P. <SPOSI_PARTE_NAS_M> S. <SPOSI_SERIE_NAS_M>'||chr(10)||'  <SPOSI_STATO_CIVILE_M>'||chr(10)||'  (4) <SPOSI_PROFESSIONE_M>'||chr(10)||'  residente in <SPOSI_RESIDENZA_M>'||chr(10)||'  (5) cittadinanza <SPOSI_CITTADINANZA_M>'||chr(10)||'(3) <SPOSI_COGNOME_F> <SPOSI_NOME_F>'||chr(10)||'  nata in <SPOSI_COMUNE_NAS_F>'||chr(10)||'  li <SPOSI_DATA_NAS_F_RIGA1> <SPOSI_DATA_NAS_F_RIGA2>'||chr(10)||'  N. <SPOSI_ATTO_NAS_F> P. <SPOSI_PARTE_NAS_F> S. <SPOSI_SERIE_NAS_F> '||chr(10)||'  <SPOSI_STATO_CIVILE_F>  '||chr(10)||'  (4) <SPOSI_PROFESSIONE_F>'||chr(10)||'  residente in <SPOSI_RESIDENZA_F>'||chr(10)||'  (5) cittadinanza <SPOSI_CITTADINANZA_F>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-SPO-1')
;
-- prompt 4-SPO-2A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-SPO-2A', 1, '', '(6) <SPOSI_COGNOME_M> <SPOSI_NOME_M>'||chr(10)||'  nato in <SPOSI_COMUNE_NAS_M> '||chr(10)||'  li <SPOSI_DATA_NAS_M_RIGA1> <SPOSI_DATA_NAS_M_RIGA2>'||chr(10)||'  Atto N. <SPOSI_ATTO_NAS_M> P. <SPOSI_PARTE_NAS_M> S. <SPOSI_SERIE_NAS_M> '||chr(10)||'  (8) <SPOSI_PROFESSIONE_M> '||chr(10)||'  residente in <SPOSI_RESIDENZA_M> '||chr(10)||'  (9) cittadino <SPOSI_CITTADINANZA_M> '||chr(10)||'(7) <SPOSI_COGNOME_F> <SPOSI_NOME_F>'||chr(10)||'  nata in <SPOSI_COMUNE_NAS_F> '||chr(10)||'  li <SPOSI_DATA_NAS_F_RIGA1> <SPOSI_DATA_NAS_F_RIGA2>'||chr(10)||'  Atto N. <SPOSI_ATTO_NAS_F> P. <SPOSI_PARTE_NAS_F> S. <SPOSI_SERIE_NAS_F> '||chr(10)||'  (8) <SPOSI_PROFESSIONE_F>'||chr(10)||'  residente in <SPOSI_RESIDENZA_F> '||chr(10)||'  (9) cittadina <SPOSI_CITTADINANZA_F>'||chr(10)||'', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-SPO-2A')
;
-- prompt 4-SPO-2B
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-SPO-2B', 1, '', '<SPOSI_COGNOME_M> <SPOSI_NOME_M> '||chr(10)||'  nato in <SPOSI_COMUNE_NAS_M> <SPOSI_DATA_NAS_M_RIGA1> <SPOSI_DATA_NAS_M_RIGA2>'||chr(10)||'  Atto N. <SPOSI_ATTO_NAS_M> P. <SPOSI_PARTE_NAS_M> S. <SPOSI_SERIE_NAS_F>   '||chr(10)||'  <SPOSI_STATO_CIVILE_M> '||chr(10)||'  <SPOSI_PROFESSIONE_M> '||chr(10)||'  residente in <SPOSI_RESIDENZA_M> '||chr(10)||'  cittadinanza <SPOSI_CITTADINANZA_M>'||chr(10)||'<SPOSI_COGNOME_F> <SPOSI_NOME_F> '||chr(10)||'  nata in <SPOSI_COMUNE_NAS_F> <SPOSI_DATA_NAS_F_RIGA1> <SPOSI_DATA_NAS_M_RIGA2>'||chr(10)||'  Atto N. <SPOSI_ATTO_NAS_F> P. <SPOSI_PARTE_NAS_F> S. <SPOSI_SERIE_NAS_F> '||chr(10)||'  <SPOSI_STATO_CIVILE_F> '||chr(10)||'  <SPOSI_PROFESSIONE_F> '||chr(10)||'  residente in <SPOSI_RESIDENZA_F> '||chr(10)||'  cittadinanza <SPOSI_CITTADINANZA_F>  ', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-SPO-2B')
;
-- prompt 4-TES-AVV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-TES-AVV', 1, '', 'ACCORDO DI <TIPO_DIVORZIO> EX ART. 6, COMMA 2, PRIMA PARTE DEL D.L. 132;2014, CONVERTITO IN LEGGE CON MODIFICHE DALLA L. 10 NOVEMBRE 2014, N. 162.'||chr(10)||'Premesso che'||chr(10)||'- i coniugi <COGNOME_NOME_SPOSO>, nato in <COMUNE_NASCITA_SPOSO> il <DATA_NASCITA_SPOSO> e <COGNOME_NOME_SPOSA>, nata in <COMUNE_NASCITA_SPOSA> il <DATA_NASCITA_SPOSA> hanno contratto matrimonio il <DATA_MATRIMONIO_PREC> a <COMUNE_MATRIMONIO_prec>: atto n. <ESTREMI_ATTO_MATRIMONIO_PREC>;'||chr(10)||'(caso SEPARAZIONE)'||chr(10)||'- tra gli stessi sono sorti insanabili divergenze tali da rendere impossibile la prosecuzione della convivenza;'||chr(10)||'(caso DIVORZIO)'||chr(10)||'- con decreto in data ...__________ il Tribunale di ...__________ ha omologato la separazione personale dei coniugi;'||chr(10)||'- sono stati avvertiti dagli avvocati della possibilita'' di ricorso alla mediazione familiare, ma nonostante il tentativo esperito di riconciliazione, le parti hanno raggiunto il seguente:'||chr(10)||'ACCORDO di <TIPO_DIVORZIO>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-TES-AVV')
;
-- prompt 4-TES-UAC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-TES-UAC', 1, '', 'Oggi <TESTATA_GIORNO> del mese di <TESTATA_MESE> dell''anno <TESTATA_ANNO> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> avanti a me <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, per delega avuta, sono comparsi i coniugi:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-TES-UAC')
;
-- prompt 4-TES-UCO
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-TES-UCO', 1, '', 'Oggi <TESTATA_GIORNO> del mese di <TESTATA_MESE> dell''anno <TESTATA_ANNO> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> nel giorno stabilito per la conferma dell''accordo di <TIPO_DIVORZIO>, di cui all''atto iscritto al N. <ACCORDO_ESTREMI_ATTO>, avanti a me <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, per delega avuta, sono comparsi:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-TES-UCO')
;
-- prompt 4-TES-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-TES-1', 1, '', 'L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI>, nella Casa comunale in una sala aperta al pubblico.'||chr(10)||'Avanti a me <TESTATA_UFFICIALE>, Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE> (1) <TESTATA_MOTIVO> vestito in forma ufficiale, sono personalmente comparsi:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-TES-1')
;
-- prompt 4-TES-2A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-TES-2A', 1, '', 'L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> nella Casa Comunale.'||chr(10)||'Io, <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE> (1) <TESTATA_MOTIVO> ho ricevuto da (2): <TESTATA_MINISTRO> <TESTATA_QUALITA_RIGA1>'||chr(10)||'<TESTATA_QUALITA_RIGA2> l''originale di atto di matrimonio, da cui risulta quanto appresso:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-TES-2A')
;
-- prompt 4-TTE
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-TTE', 1, '', '<TESTIMONI_COGNOME_NOME_1> nat<TESTIMONI_NATO_1> <TESTIMONI_COMUNE_NAS_1> lì <TESTIMONI_DATA_NAS_1> (4) <TESTIMONI_PROFESSIONE_1>, residente in <TESTIMONI_RESIDENZA_1> e <TESTIMONI_COGNOME_NOME_2> nat<TESTIMONI_NATO_2> <TESTIMONI_COMUNE_NAS_2> lì <TESTIMONI_DATA_NAS_2> (4) <TESTIMONI_PROFESSIONE_2>, residente in <TESTIMONI_RESIDENZA_2>.', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-TTE')
;
-- prompt 4-TTR-AVV
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-TTR-AVV', 1, '', 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI> io sottoscritto <UFFICIALE_UTENTE>, Ufficiale dello stato civile del Comune di <COMUNE> per delega avuta, avendo ricevuto in data <DATA_NOTA_RIF> (prot. del Comune di <COMUNE> n. <PROTOCOLLO_PROV> del <DATA_PROTOCOLLO_PROV>) dall''avvocato '||chr(10)||'<AVVOCATO_SPOSO> con studio in <SEDE_AVVOCATO_SPOSO> , quale avvocato di <COGNOME_SPOSO> <NOME_SPOSO>'||chr(10)||'<AVVOCATO_SPOSA> con studio in <SEDE_AVVOCATO_SPOSA> , quale avvocato di <COGNOME_SPOSA> <NOME_SPOSA>'||chr(10)||', la copia autenticata dell''accordo raggiunto a seguito di convenzione di negoziazione assistita di <TIPO_DIVORZIO> sottoscritto il <DATA_ACCORDO_DIVORZIO> , munito delle certificazioni relative all''autografia delle firme ed alla conformitÃ  dello stesso alle norme imperative e all''ordine pubblico, nonche'' corredato del seguente provvedimento dell''autorita'' giudiziaria: nulla osta (oppure: autorizzazione) del Procuratore della Repubblica presso il Tribunale di ...__________ n. R.G._____;_____ , emesso in data _____________ , depositato in Cancelleria in data _____________ .'||chr(10)||'Aderendo a tale richiesta, provvedo alla trascrizione del documento, come segue:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-TTR-AVV')
;
-- prompt 4-TTR-2B
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-TTR-2B', 1, '', 'L''anno <TRASCRIZIONE_ANNO> addi'' <TRASCRIZIONE_GIORNO> del mese di <TRASCRIZIONE_MESE> alle ore <TRASCRIZIONE_ORE> e minuti <TRASCRIZIONE_MINUTI> nella Casa comunale '||chr(10)||'Io <TRASCRIZIONE_UFFICIALE>, Ufficiale dello Stato Civile di <TRASCRIZIONE_COMUNE>, (1) <TRASCRIZIONE_MOTIVO>, avendo ricevuto dall''Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE_ORIG> copia di verbale di trascrizione di atto di matrimonio, trascrivo per intero la copia stessa, che e'' del tenore seguente:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '4-TTR-2B')
;
-- prompt 5-DIC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-DIC', 1, '', '(2) è compars<DICHIARANTE_COMPARSO> <DICHIARANTE> nat<DICHIARANTE_NATO> <DICHIARANTE_COM_NAS> li <DICHIARANTE_DATA_NAS> (3) <DICHIARANTE_PROF> residente in <DICHIARANTE_RESIDENZA> <DICHIARANTE_IL_QUALE> quale mi ha dichiarato quanto segue:  ', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-DIC')
;
-- prompt 5-DMO-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-DMO-1', 1, '', 'Il giorno <DATI_MORTE_GIORNO> del mese di <DATI_MORTE_MESE> dell''anno <DATI_MORTE_ANNO> alle ore <DATI_MORTE_ORE> e minuti <DATI_MORTE_MINUTI> nel (3-bis) <DATI_MORTE_LUOGO_RIGA1> <DATI_MORTE_LUOGO_RIGA2> è mort<DATI_MORTE_MORT_OA> (4) <DATI_MORTE_DEFUNTO> (5) <DATI_MORTE_CITTADINANZA> residente in <DATI_MORTE_RESIDENZA> (3) <DATI_MORTE_PROF>, nat<DATI_MORTE_NATO> <DATI_MORTE_COM_NAS> li <DATI_MORTE_DATA_NAS>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-DMO-1')
;
-- prompt 5-DMO-2A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-DMO-2A', 1, '', 'Il giorno <DATI_MORTE_GIORNO> del mese di <DATI_MORTE_MESE> dell''anno <DATI_MORTE_ANNO> alle ore <DATI_MORTE_ORE> e minuti <DATI_MORTE_MINUTI> nel <DATI_MORTE_LUOGO_RIGA1> <DATI_MORTE_LUOGO_RIGA2> è mort<DATI_MORTE_MORT_OA> <DATI_MORTE_DEFUNTO> <DATI_MORTE_CITTADINANZA> residente in <DATI_MORTE_RESIDENZA> <DATI_MORTE_PROF>, nat<DATI_MORTE_NATO> <DATI_MORTE_COM_NAS> li <DATI_MORTE_DATA_NAS>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-DMO-2A')
;
-- prompt 5-DMO-2B
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-DMO-2B', 1, '', 'Il giorno <DATI_MORTE_GIORNO> del mese di <DATI_MORTE_MESE> dell''anno <DATI_MORTE_ANNO> alle ore <DATI_MORTE_ORE> e minuti <DATI_MORTE_MINUTI> (4) in <DATI_MORTE_LUOGO_RIGA1> <DATI_MORTE_LUOGO_RIGA2> è mort<DATI_MORTE_MORT_OA> (5) <DATI_MORTE_DEFUNTO> (6) <DATI_MORTE_CITTADINANZA> residente in <DATI_MORTE_RESIDENZA> (7) <DATI_MORTE_PROF>, nat<DATI_MORTE_NATO> <DATI_MORTE_COM_NAS> li <DATI_MORTE_DATA_NAS>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-DMO-2B')
;
-- prompt 5-DMO-2BB
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-DMO-2BB', 1, '', 'Il giorno <DATI_MORTE_GIORNO> del mese di <DATI_MORTE_MESE> dell''anno <DATI_MORTE_ANNO> alle ore <DATI_MORTE_ORE> e minuti <DATI_MORTE_MINUTI> in <DATI_MORTE_LUOGO_RIGA1> <DATI_MORTE_LUOGO_RIGA2> è mort<DATI_MORTE_MORT_OA> <DATI_MORTE_DEFUNTO> <DATI_MORTE_CITTADINANZA> residente in <DATI_MORTE_RESIDENZA> <DATI_MORTE_PROF>, nat<DATI_MORTE_NATO> <DATI_MORTE_COM_NAS> li <DATI_MORTE_DATA_NAS>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-DMO-2BB')
;
-- prompt 5-FIR-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-FIR-1', 1, '', 'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-FIR-1')
;
-- prompt 5-FIR-2A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-FIR-2A', 1, '', 'f.to <DICHIARANTE>'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE f.to: <CHIUSURA_FIRMA> '||chr(10)||'Eseguita la trascrizione, ho munito del mio visto ed inserito la copia suddetta nel volume degli allegati a questo registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-FIR-2A')
;
-- prompt 5-FIR-2B
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-FIR-2B', 1, '', 'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-FIR-2B')
;
-- prompt 5-FIR-2BB
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-FIR-2BB', 1, '', 'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-FIR-2BB')
;
-- prompt 5-FIR-2C
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-FIR-2C', 1, '', 'L''UFFICIALE DELLO STATO CIVILE ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-FIR-2C')
;
-- prompt 5-GMO-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-GMO-1', 1, '', 'figli<GENITORI_FIGLIO> di (6) <GENITORI_PADRE> (3) <GENITORI_PROF_PADRE> residente in <GENITORI_RESIDENZA_PADRE>'||chr(10)||'e di (7) <GENITORI_MADRE> (3) <GENITORI_PROF_MADRE> residente in <GENITORI_RESIDENZA_MADRE>'||chr(10)||'e che era (8) <GENITORI_STATO_CIV_RIGA1> <GENITORI_STATO_CIV_RIGA2>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-GMO-1')
;
-- prompt 5-GMO-2A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-GMO-2A', 1, '', 'figli<GENITORI_FIGLIO> di <GENITORI_PADRE> <GENITORI_PROF_PADRE> residente in <GENITORI_RESIDENZA_PADRE>'||chr(10)||'e di <GENITORI_MADRE> <GENITORI_PROF_MADRE> residente in <GENITORI_RESIDENZA_MADRE>'||chr(10)||'e che era <GENITORI_STATO_CIV_RIGA1> <GENITORI_STATO_CIV_RIGA2>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-GMO-2A')
;
-- prompt 5-GMO-2B
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-GMO-2B', 1, '', 'figli<GENITORI_FIGLIO> di (8) <GENITORI_PADRE> (7) <GENITORI_PROF_PADRE> residente in <GENITORI_RESIDENZA_PADRE>'||chr(10)||'e di (9) <GENITORI_MADRE> (7) <GENITORI_PROF_MADRE> residente in <GENITORI_RESIDENZA_MADRE>'||chr(10)||'e che era (10) <GENITORI_STATO_CIV_RIGA1> <GENITORI_STATO_CIV_RIGA2>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-GMO-2B')
;
-- prompt 5-GMO-2BB
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-GMO-2BB', 1, '', 'figli<GENITORI_FIGLIO> di <GENITORI_PADRE> <GENITORI_PROF_PADRE> residente in <GENITORI_RESIDENZA_PADRE>'||chr(10)||'e di <GENITORI_MADRE> <GENITORI_PROF_MADRE> residente in <GENITORI_RESIDENZA_MADRE>'||chr(10)||'e che era <GENITORI_STATO_CIV_RIGA1> <GENITORI_STATO_CIV_RIGA2>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-GMO-2BB')
;
-- prompt 5-MAR-NAS
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-MAR-NAS', 1, '', 'L''atto di nascita del di contro è iscritto nei registri di Stato Civile del Comune di: <MARGINE_NASCITA_COMUNE> al N. <MARGINE_NASCITA_ATTO> P. <MARGINE_NASCITA_PARTE> S. <MARGINE_NASCITA_SERIE> Uff. <MARGINE_NASCITA_UFFICIO> Anno <MARGINE_NASCITA_ANNO>'||chr(10)||'  li <MARGINE_NASCITA_DATA>'||chr(10)||'  L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'  ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-MAR-NAS')
;
-- prompt 5-MAR-TR1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-MAR-TR1', 1, '', 'Il presente atto di morte è stato trascritto nei registri di Stato Civile del Comune di <MARGINE_TRASCRIZIONE_COMUNE> al N. <MARGINE_TRASCRIZIONE_ATTO> P. <MARGINE_TRASCRIZIONE_PARTE> S. <MARGINE_TRASCRIZIONE_SERIE> Anno <MARGINE_TRASCRIZIONE_ANNO_ATTO> come da comunicazione del <MARGINE_TRASCRIZIONE_DATA_COM>   li <MARGINE_TRASCRIZIONE_DATA>    L''UFFICIALE DELLO STATO CIVILE   ______________________________', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-MAR-TR1')
;
-- prompt 5-TES-1
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-TES-1', 1, '', 'L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> nella Casa comunale.'||chr(10)||'Avanti a me, <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, (1) <TRASCRIZIONE_MOTIVO>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-TES-1')
;
-- prompt 5-TES-2A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-TES-2A', 1, '', 'L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> nella Casa comunale.'||chr(10)||'Avanti a me, <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, <TRASCRIZIONE_MOTIVO>', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-TES-2A')
;
-- prompt 5-TES-2B
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-TES-2B', 1, '', 'L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> nella Casa comunale.'||chr(10)||'Io <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, (1) <TESTATA_MOTIVO> avendo ricevuto dal (2) <TESTATA_RICEVUTO> (3) un <TESTATA_DOCUMENTO> con la data <TESTATA_DATA_DOC> che munit<TESTATA_MUNITO> del mio visto, inserisco nel volume degli allegati a questo registro, dò atto che:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-TES-2B')
;
-- prompt 5-TES-2BB
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-TES-2BB', 1, '', 'L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> nella Casa comunale.'||chr(10)||'Io <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, <TESTATA_MOTIVO> avendo ricevuto dal <TESTATA_RICEVUTO> un <TESTATA_DOCUMENTO> con la data <TESTATA_DATA_DOC> che munit<TESTATA_MUNITO> del mio visto, inserisco nel volume degli allegati a questo registro, dò atto che:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-TES-2BB')
;
-- prompt 5-TTR-2A
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-TTR-2A', 1, '', 'L''anno <TRASCRIZIONE_ANNO> addì <TRASCRIZIONE_GIORNO> del mese di <TRASCRIZIONE_MESE> alle ore <TRASCRIZIONE_ORE> e minuti <TRASCRIZIONE_MINUTI> nella Casa comunale.'||chr(10)||'Io <TRASCRIZIONE_UFFICIALE>, Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE>, (1) <TRASCRIZIONE_MOTIVO> avendo ricevuto dall''Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE_ORIG> copia di atto di morte, trascrivo per intero la copia stessa che è del tenore seguente:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-TTR-2A')
;
-- prompt 5-TTR-2BB
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '5-TTR-2BB', 1, '', 'L''anno <TRASCRIZIONE_ANNO> addì <TRASCRIZIONE_GIORNO> del mese di <TRASCRIZIONE_MESE> alle ore <TRASCRIZIONE_ORE> e minuti <TRASCRIZIONE_MINUTI> nella Casa comunale.'||chr(10)||'Io <TRASCRIZIONE_UFFICIALE>, Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE>, (1) <TRASCRIZIONE_MOTIVO> avendo ricevuto dall''Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE_ORIG> copia di atto di morte, trascrivo per intero la copia stessa che è del tenore seguente:', ''
  from dual
 where not exists (select 1 from civtfa b where formula = '5-TTR-2BB')
;
-- prompt 0-CHI-AVV
update civtfa
   set testo_a3 = 'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro le note di trasmissione dei predetti avvocati e la copia del documento trascritto.'
 where formula = '0-CHI-AVV'
   and testo_a3      is null
;
-- prompt 0-CHI-FCC
update civtfa
   set testo_a3 = 'A tal fine mi hanno prodotto e;o acquisito i seguenti documenti:_____  che muniti del mio visto, allego al presente verbale.)'||chr(10)||'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me, i testimoni e il segretario comunale, lo sottoscrivono'||chr(10)||' '
 where formula = '0-CHI-FCC'
   and testo_a3      is null
;
-- prompt 0-CHI-O1
update civtfa
   set testo_a3 = 'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me ed i testimoni, lo sottoscrivono'
 where formula = '0-CHI-O1'
   and testo_a3      is null
;
-- prompt 0-CHI-PDV
update civtfa
   set testo_a3 = 'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me, i testimoni ed il segretario comunale, lo sottoscrivono'
 where formula = '0-CHI-PDV'
   and testo_a3      is null
;
-- prompt 0-CHI-PV1
update civtfa
   set testo_a3 = 'Il presente verbale viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.'
 where formula = '0-CHI-PV1'
   and testo_a3      is null
;
-- prompt 0-CHI-PV2
update civtfa
   set testo_a3 = 'Il presente verbale viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.'
 where formula = '0-CHI-PV2'
   and testo_a3      is null
;
-- prompt 0-CHI-PV3
update civtfa
   set testo_a3 = 'Il presente verbale viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.'
 where formula = '0-CHI-PV3'
   and testo_a3      is null
;
-- prompt 0-CHI-T2
update civtfa
   set testo_a3 = 'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me ed i testimoni, lo sottoscrivono'
 where formula = '0-CHI-T2'
   and testo_a3      is null
;
-- prompt 0-CHI-UAC
update civtfa
   set testo_a3 = 'Il presente atto viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.'
 where formula = '0-CHI-UAC'
   and testo_a3      is null
;
-- prompt 0-CHI-UCN
update civtfa
   set testo_a3 = 'Il presente verbale viene letto ai dichiaranti i quali, insieme con me lo sottoscrivono'
 where formula = '0-CHI-UCN'
   and testo_a3      is null
;
-- prompt 0-CHI-UCO
update civtfa
   set testo_a3 = 'Il presente atto viene letto ai dichiaranti i quali, insieme con me, lo sottoscrivono.'
 where formula = '0-CHI-UCO'
   and testo_a3      is null
;
-- prompt 0-CHI-UPD
update civtfa
   set testo_a3 = 'Il presente atto, al quale allego il verbale della richiesta, viene letto ai dichiaranti i quali, insieme con me ed i testimoni, lo sottoscrivono'
 where formula = '0-CHI-UPD'
   and testo_a3      is null
;
-- prompt 0-CON-PAT
update civtfa
   set testo_a3 = '-'
 where formula = '0-CON-PAT'
   and testo_a3      is null
;
-- prompt 0-DOC-UAC
update civtfa
   set testo_a3 = 'A tal fine mi hanno prodotto i seguenti documenti:____che muniti del mio visto, inserisco nel volume degli allegati a questo registro.'||chr(10)||'Ho invitato le parti a comparire nuovamente davanti a questo Ufficio per la conferma dell''accordo nel giorno <CONFERMA_DATA> e li ho informati che la mancata comparizione equivale a mancata conferma dell''accordo.'
 where formula = '0-DOC-UAC'
   and testo_a3      is null
;
-- prompt 0-FIR
update civtfa
   set testo_a3 = '____________________L''UFFICIALE DELLO STATO CIVILE'
 where formula = '0-FIR'
   and testo_a3      is null
;
-- prompt 0-FIR-AVV
update civtfa
   set testo_a3 = 'F.to <COGNOME_NOME_1>'||chr(10)||'F.to <COGNOME_NOME_2>'||chr(10)||'Avvocato: F.to <AVVOCATO_1>'||chr(10)||'Avvocato: F.to <AVVOCATO_2>'||chr(10)||'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________'
 where formula = '0-FIR-AVV'
   and testo_a3      is null
;
-- prompt 0-FIR-DIV1
update civtfa
   set testo_a3 = '______________________________ ______________________________L''UFFICIALE DELLO STATO CIVILE__________________________________________'
 where formula = '0-FIR-DIV1'
   and testo_a3      is null
;
-- prompt 0-FIR-DIV2
update civtfa
   set testo_a3 = '______________________________ '||chr(10)||'______________________________'||chr(10)||'Avvocato _____________________ '||chr(10)||'Avvocato _____________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________'
 where formula = '0-FIR-DIV2'
   and testo_a3      is null
;
-- prompt 0-FIR-PV1
update civtfa
   set testo_a3 = '____________________L''UFFICIALE DELLO STATO CIVILE'
 where formula = '0-FIR-PV1'
   and testo_a3      is null
;
-- prompt 0-FIR-PV2
update civtfa
   set testo_a3 = '____________________L''UFFICIALE DELLO STATO CIVILE'
 where formula = '0-FIR-PV2'
   and testo_a3      is null
;
-- prompt 0-FIR-PV3
update civtfa
   set testo_a3 = '____________________L''UFFICIALE DELLO STATO CIVILE'
 where formula = '0-FIR-PV3'
   and testo_a3      is null
;
-- prompt 0-MAR-CON
update civtfa
   set testo_a3 = '<MARGINE_CONVENZIONI>'||chr(10)||'<MARGINE_CONVENZIONI_COMUNE> <MARGINE_CONVENZIONI_LI_DATA>'||chr(10)||'<MARGINE_CONVENZIONI_UFFICIALE> <MARGINE_CONVENZIONI_FIRMA>'
 where formula = '0-MAR-CON'
   and testo_a3      is null
;
-- prompt 0-MAR-CO1
update civtfa
   set testo_a3 = '<MARGINE_COGNOME_1>'||chr(10)||'<MARGINE_COGNOME_1_LI_DATA> <MARGINE_COGNOME_1_UFFICIALE> <MARGINE_COGNOME_1_FIRMA>'
 where formula = '0-MAR-CO1'
   and testo_a3      is null
;
-- prompt 0-MAR-CO2
update civtfa
   set testo_a3 = '<MARGINE_COGNOME_2>'||chr(10)||'<MARGINE_COGNOME_2_LI_DATA> <MARGINE_COGNOME_2_UFFICIALE> <MARGINE_COGNOME_2_FIRMA>'
 where formula = '0-MAR-CO2'
   and testo_a3      is null
;
-- prompt 0-PDO
update civtfa
   set testo_a3 = 'I documenti <PRESA_VISIONE_DOCUMENTI> sono:'||chr(10)||'per una parte:'||chr(10)||'<RIGA_ESTRATTO_1>'||chr(10)||'<RIGA_CUMULATIVO_1>'||chr(10)||'per l''altra parte:'||chr(10)||'<RIGA_ESTRATTO_2>'||chr(10)||'<RIGA_CUMULATIVO_2>'
 where formula = '0-PDO'
   and testo_a3      is null
;
-- prompt 0-PDO-NP
update civtfa
   set testo_a3 = '-'
 where formula = '0-PDO-NP'
   and testo_a3      is null
;
-- prompt 0-PDO-PVC1
update civtfa
   set testo_a3 = 'che, muniti del mio visto, allego al presente verbale.'||chr(10)||'Ho invitato le parti a comparire nuovamente davanti a questo Ufficio per rendere la dichiarazione costitutiva dell''unione civile nel giorno <DATA_UNIONE_VERBALE> e li ho informati che la mancata comparizione, senza giustificato motivo, di uno di loro o di entrambi equivale a rinuncia.'
 where formula = '0-PDO-PVC1'
   and testo_a3      is null
;
-- prompt 0-PDO-PVC2
update civtfa
   set testo_a3 = 'Ho invitato le parti a comparire nuovamente davanti a questo Ufficio per rendere la dichiarazione costitutiva dell''unione civile nel giorno <DATA_UNIONE_VERBALE> e li ho informati che la mancata comparizione, senza giustificato motivo, di uno di loro o di entrambi equivale a rinuncia.'
 where formula = '0-PDO-PVC2'
   and testo_a3      is null
;
-- prompt 0-PDO-PVNP
update civtfa
   set testo_a3 = '-'
 where formula = '0-PDO-PVNP'
   and testo_a3      is null
;
-- prompt 0-PDO-PV1
update civtfa
   set testo_a3 = 'A tal fine mi hanno formulato richiesta di rendere la dichiarazione costitutiva dell''unione civile e hanno prodotto i seguenti documenti:'||chr(10)||'per una parte:'||chr(10)||'<RIGA_ESTRATTO_1>'||chr(10)||'<RIGA_CUMULATIVO_1>'||chr(10)||'per l''altra parte:'||chr(10)||'<RIGA_ESTRATTO_2>'||chr(10)||'<RIGA_CUMULATIVO_2>'
 where formula = '0-PDO-PV1'
   and testo_a3      is null
;
-- prompt 0-PDO-PV2
update civtfa
   set testo_a3 = '........ (indicare la causa ostativa, tra quelle previste dalla legge) e di essere stati autorizzati all''unione civile con decreto del Tribunale di <AUTORITA_PROV>, emesso il <DATA_NOTA_RIF> ai sensi dell''articolo 87, quarto comma, del codice civile.'
 where formula = '0-PDO-PV2'
   and testo_a3      is null
;
-- prompt 0-PDO-PV3
update civtfa
   set testo_a3 = 'A tal fine mi hanno formulato richiesta di rendere la dichiarazione costitutiva dell''unione civile e hanno prodotto i seguenti documenti:'||chr(10)||'per una parte:'||chr(10)||'<RIGA_ESTRATTO_1>'||chr(10)||'<RIGA_CUMULATIVO_1>'||chr(10)||'per l''altra parte:'||chr(10)||'<RIGA_ESTRATTO_2>'||chr(10)||'<RIGA_CUMULATIVO_2>'
 where formula = '0-PDO-PV3'
   and testo_a3      is null
;
-- prompt 0-RIC-PV1
update civtfa
   set testo_a3 = '<COGNOME_1> <NOME_1>'||chr(10)||'<NAT_OA_1> il <DATA_NASCITA_1>'||chr(10)||'a <COMUNE_NASCITA_1>'||chr(10)||'residente in <COMUNE_RESIDENZA_1>'||chr(10)||'<CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'E'||chr(10)||'<COGNOME_2> <NOME_2>'||chr(10)||'<NAT_OA_2> il <DATA_NASCITA_2>'||chr(10)||'a <COMUNE_NASCITA_2>'||chr(10)||'residente in <COMUNE_RESIDENZA_2>'||chr(10)||'<CITTADIN_OA_2>  <NAZIONALITA_2>'||chr(10)||'i quali, nel presentare la richiesta di rendere la dichiarazione costitutiva dell''unione civile ai sensi dell''articolo 1, comma 2, della legge 20 maggio 2016, n. 76, mi dichiarano di essere nella seguente condizione'||chr(10)||'tra quelle di cui all''artico 1, comma 4, della legge 20 maggio 2016, n. 76:'||chr(10)||''
 where formula = '0-RIC-PV1'
   and testo_a3      is null
;
-- prompt 0-RIC-PV2
update civtfa
   set testo_a3 = '<COGNOME_1> <NOME_1>'||chr(10)||'<NAT_OA_1> il <DATA_NASCITA_1>'||chr(10)||'a <COMUNE_NASCITA_1>'||chr(10)||'residente in <COMUNE_RESIDENZA_1>'||chr(10)||'<CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'E'||chr(10)||'<COGNOME_2> <NOME_2>'||chr(10)||'<NAT_OA_2> il <DATA_NASCITA_2>'||chr(10)||'a <COMUNE_NASCITA_2>'||chr(10)||'residente in <COMUNE_RESIDENZA_2>'||chr(10)||'<CITTADIN_OA_2>  <NAZIONALITA_2>'||chr(10)||'i quali, nel presentare la richiesta di rendere la dichiarazione costitutiva dell''unione civile ai sensi dell''articolo 1, comma 2, della legge 20 maggio 2016, n. 76, mi dichiarano di essere nella seguente condizione'||chr(10)||'tra quelle di cui all''artico 1, comma 4, della legge 20 maggio 2016, n. 76:'||chr(10)||''
 where formula = '0-RIC-PV2'
   and testo_a3      is null
;
-- prompt 0-RIC-PV3
update civtfa
   set testo_a3 = '1) il (la) detto (a) <COGNOME_1> <NOME_1>'||chr(10)||'<NAT_OA_1> il <DATA_NASCITA_1>'||chr(10)||'a <COMUNE_NASCITA_1>'||chr(10)||'<CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'residente in <COMUNE_RESIDENZA_1>'||chr(10)||'2) <COGNOME_2> <NOME_2>'||chr(10)||'<NAT_OA_2> il <DATA_NASCITA_2>'||chr(10)||'a <COMUNE_NASCITA_2>'||chr(10)||'<CITTADIN_OA_2>  <NAZIONALITA_2>'||chr(10)||'residente in <COMUNE_RESIDENZA_2>'||chr(10)||''||chr(10)||'I quali mi hanno chiesto di ricevere la richiesta di rendere la dichiarazione costitutiva dell''unione civile e mi dichiarano:'||chr(10)||'- di non avere vincoli matrimoniali o di unioni civile tra persone dello stesso sesso;'||chr(10)||'- di non essere interdetti per infermita'' di mente, neppure per sentenza non passata in giudicato;'||chr(10)||'- di non essere sottoposti a procedimento di interdizione in virtu'' del promovimento della relativa istanza;'||chr(10)||'- di non essere tra loro ascendenti o discendenti in linea retta;'||chr(10)||'- di non essere tra loro fratelli o sorelle germani, consanguinei o uterini;'||chr(10)||'- di non essere tra loro zio e nipote o zia e nipote;'||chr(10)||'- di non essere tra loro affini in linea retta, neppure per matrimonio dichiarato nullo o sciolto o per il quale è stata pronunziata la cessazione degli effetti civili;'||chr(10)||'- di non essere tra loro affini in linea collaterale in secondo grado;'||chr(10)||'- di non essere tra loro adottanti, adottati ne'' loro discendenti;'||chr(10)||'- di non essere figli adottivi della stessa persona;'||chr(10)||'- di non essere tra loro adottato e figlio dell''adottante;'||chr(10)||'- di non essere tra loro adottato e coniuge dell''adottante ne'' adottante e coniuge dell''adottato;'||chr(10)||'- di non essere stati condannati per sentenza definitiva per omicidio consumato o tentato nei confronti di chi sia stato coniugato o unito civilmente con uno di loro;'||chr(10)||'- di non essere stati condannati per sentenza non definitiva per omicidio consumato o tentato nei confronti di chi sia stato coniugato o unito civilmente con uno di loro, ne'' di essere stati sottoposti a rinvio a giudizio o a misura cautelare per uno di tali delitti;'||chr(10)||'- di voler costituire, mediante dichiarazione di fronte all''ufficiale dello stato civile, l''unione civile tra di loro.'||chr(10)||''
 where formula = '0-RIC-PV3'
   and testo_a3      is null
;
-- prompt 0-RMA-UAC
update civtfa
   set testo_a3 = 'i quali mi dichiarano:'||chr(10)||'- di aver costituito l''unione civile tra loro in data <UCI_PREC_DATA> in <UCI_PREC_COMUNE>, dinanzi all''Ufficiale dello Stato Civile, di cui all''atto iscritto;trascritto nel registro delle unioni civili del Comune di <UCI_PREC_COMUNE_ATTO> (n. <UCI_PREC_ESTREMI_ATTO>);'||chr(10)||'- di essere;non essere parti in giudizio pendente, concernente lo scioglimento dell''unione civile tra gli stessi;'||chr(10)||'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||'- di volere lo scioglimento dell''unione civile tra loro.'
 where formula = '0-RMA-UAC'
   and testo_a3      is null
;
-- prompt 0-RMA-UCO
update civtfa
   set testo_a3 = 'di volere confermare l''accordo di <DIVORZIO_TIPO>, concluso innanzi a questo ufficio in data <DATA_ACCORDO> di cui all''atto iscritto al n. <ACCORDO_ESTREMI_ATTO>.'||chr(10)||'A tal fine ho acquisito copia integrale dell''atto n. <ACCORDO_ESTREMI_ATTO> che, munito del mio visto, inserisco nel volume degli allegati a questo registro.'
 where formula = '0-RMA-UCO'
   and testo_a3      is null
;
-- prompt 0-RUC-FCC
update civtfa
   set testo_a3 = 'i quali mi hanno chiesto di ricevere la dichiarazione costitutiva dell''unione civile tra loro; a questo effetto e'' pervenuta dall''Ufficiale dello stato civile del Comune di_______, ove e'' stata presentata la richiesta di costituzione in data _______, la delega di cui all''articolo 70-quater del D.P.R. 3 novembre 2000, n. 396, fattami in data _______; allo stesso effetto <COGNOME_1> <NOME_1> e <COGNOME_2> <NOME_2>mi hanno prodotto (e;o acquisito e;o ho visionato) i documenti sotto descritti:'||chr(10)||'____________________'||chr(10)||'____________________'||chr(10)||''
 where formula = '0-RUC-FCC'
   and testo_a3      is null
;
-- prompt 0-RUC-O1
update civtfa
   set testo_a3 = 'i quali mi hanno reso la dichiarazione di voler costituire l''unione civile tra di loro e, a questo effetto, mi hanno presentato i documenti sotto descritti che, muniti del mio visto, inserisco nel volume degli allegati a questo registro, insieme con quelli già prodotti all''atto della richiesta di costituzione. Dall''esame di tutti gli anzidetti documenti risultandomi nulla ostare alla costituzione dell''unione, ho letto alle persone da unire civilmente i commi 11 e 12 dell''articolo 1 della legge 20 maggio 2016, n. 76, quindi ho domandato a ciascuna delle due persone da unire civilmente se intende unirsi civilmente con l''altro, ed avendomi ciascuno risposto affermativamente a piena intelligenza anche dei testimoni sottoindicati, ho dichiarato che e'' costituita l''unione civile tra i medesimi. '
 where formula = '0-RUC-O1'
   and testo_a3      is null
;
-- prompt 0-RUC-PDV
update civtfa
   set testo_a3 = 'i quali mi hanno chiesto di ricevere la dichiarazione costitutiva dell''unione civile tra loro; a questo effetto e'' pervenuta dall''Ufficiale dello stato civile del Comune di_______, ove e'' stata presentata la richiesta di costituzione in data _______, la delega di cui all''articolo 70-quater del D.P.R. 3 novembre 2000, n. 396, fattami in data _______; allo stesso effetto <COGNOME_1> <NOME_1> e <COGNOME_2> <NOME_2>mi hanno prodotto (e;o acquisito e;o ho visionato) i documenti sotto descritti:'||chr(10)||'____________________'||chr(10)||'____________________'||chr(10)||''
 where formula = '0-RUC-PDV'
   and testo_a3      is null
;
-- prompt 0-RUC-T2
update civtfa
   set testo_a3 = 'i quali mi hanno chiesto di ricevere la dichiarazione costitutiva dell''unione civile tra loro; a questo effetto e'' pervenuta dall''Ufficiale dello stato civile del Comune di_______, ove e'' stata presentata la richiesta di costituzione in data _______, la delega di cui all''articolo 70-quater del D.P.R. 3 novembre 2000, n. 396, fattami in data _______; allo stesso effetto <COGNOME_1> <NOME_1> e <COGNOME_2> <NOME_2>mi hanno prodotto (e;o acquisito e;o ho visionato) i documenti sotto descritti:'||chr(10)||'____________________'||chr(10)||'____________________'||chr(10)||''
 where formula = '0-RUC-T2'
   and testo_a3      is null
;
-- prompt 0-SPO
update civtfa
   set testo_a3 = '<COGNOME_1> <NOME_1>'||chr(10)||'<NAT_OA_1> il <DATA_NASCITA_1> a <COMUNE_NASCITA_1>'||chr(10)||'<CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'residente in <COMUNE_RESIDENZA_1>'||chr(10)||'e'||chr(10)||'<COGNOME_2> <NOME_2>'||chr(10)||'<NAT_OA_2> il <DATA_NASCITA_2>'||chr(10)||'a <COMUNE_NASCITA_2>'||chr(10)||'<CITTADIN_OA_2> <NAZIONALITA_2>'||chr(10)||'residente in <COMUNE_RESIDENZA_2>'||chr(10)||''
 where formula = '0-SPO'
   and testo_a3      is null
;
-- prompt 0-SPO-DIV1
update civtfa
   set testo_a3 = '<COGNOME_1> <NOME_1> '||chr(10)||'  <NAT_OA_1> in <COMUNE_NASCITA_1> <DATA_NASCITA_1>'||chr(10)||'  <CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'  residente in <COMUNE_RESIDENZA_1> '||chr(10)||'E'||chr(10)||'<COGNOME_2> <NOME_2> '||chr(10)||'  <NAT_OA_2> in <COMUNE_NASCITA_2> <DATA_NASCITA_2>'||chr(10)||'  <CITTADIN_OA_2> <NAZIONALITA_2>'||chr(10)||'  residente in <COMUNE_RESIDENZA_2> '||chr(10)||''
 where formula = '0-SPO-DIV1'
   and testo_a3      is null
;
-- prompt 0-SPO-DIV2
update civtfa
   set testo_a3 = '<COGNOME_1> <NOME_1> '||chr(10)||'  <NAT_OA_1> in <COMUNE_NASCITA_1> <DATA_NASCITA_1>'||chr(10)||'  <CITTADIN_OA_1> <NAZIONALITA_1>'||chr(10)||'  residente in <COMUNE_RESIDENZA_1> '||chr(10)||'  con l''assistenza dell''avvocato <AVVOCATO_1>'||chr(10)||'E'||chr(10)||'<COGNOME_2> <NOME_2> '||chr(10)||'  <NAT_OA_2> in <COMUNE_NASCITA_2> <DATA_NASCITA_2>'||chr(10)||'  <CITTADIN_OA_2> <NAZIONALITA_2>'||chr(10)||'  residente in <COMUNE_RESIDENZA_2> '||chr(10)||'  con l''assistenza dell''avvocato <AVVOCATO_2>'
 where formula = '0-SPO-DIV2'
   and testo_a3      is null
;
-- prompt 0-TES-AVV
update civtfa
   set testo_a3 = '______________________________'
 where formula = '0-TES-AVV'
   and testo_a3      is null
;
-- prompt 0-TES-FCC
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno <ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, in questo luogo _________________ posto in _______ al numero civico _____, avendo ________________ comprovato con certificato del ___ in data ___ che per _____________ egli (ella) si trova nell''impossibilità di recarsi alla Casa comunale per costituire unione civile con __________, io  <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA mi sono qui trasferito insieme con il segretario comunale ed ho trovato:'
 where formula = '0-TES-FCC'
   and testo_a3      is null
;
-- prompt 0-TES-O1
update civtfa
   set testo_a3 = 'L''anno duemila<ANNO_OGGI> addi'' <GIORNO_OGGI> del mese di <MESE_OGGI>  alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, nella casa comunale di <COMUNE> in una sala aperta al pubblico.'||chr(10)||'Avanti a me, <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA, vestito in forma ufficiale, sono personalmente comparsi'||chr(10)||''
 where formula = '0-TES-O1'
   and testo_a3      is null
;
-- prompt 0-TES-PDV
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, io <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA, in quanto richiesto, mi sono trasferito con il segretario comunale ___________  in questo luogo _________________ posto in _______ al numero civico _____, ove ho trovato'
 where formula = '0-TES-PDV'
   and testo_a3      is null
;
-- prompt 0-TES-PV1
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me, <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono comparsi'
 where formula = '0-TES-PV1'
   and testo_a3      is null
;
-- prompt 0-TES-PV2
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me, <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono personalmente comparsi'
 where formula = '0-TES-PV2'
   and testo_a3      is null
;
-- prompt 0-TES-PV3
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, in questo luogo _________________ posto in _______ al numero civico _____, avendo ________________ comprovato con certificato del ___ in data ___ che per _____________ che viene allegato agli atti, il medesimo;la medesima si trova nell''impossibilità di recarsi alla Casa comunale per presentare la richiesta di rendere la dichiarazione costitutiva dell''unione civile con __________, io  <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA mi sono qui trasferito ed ho trovato:'
 where formula = '0-TES-PV3'
   and testo_a3      is null
;
-- prompt 0-TES-T2
update civtfa
   set testo_a3 = 'L''anno duemila<ANNO_ATTO_ORIGINALE> addi'' <GIORNO_ATTO_ORIGINALE> del mese di <MESE_ATTO_ORIGINALE>  alle ore <ORE_ATTO_ORIGINALE> e minuti <MINUTI_ATTO_ORIGINALE>, nella casa comunale di <COMUNE_PROV> in una sala aperta al pubblico.Avanti a me, <UFFICIALE_PROV> Ufficiale dello Stato Civile del Comune di <COMUNE_PROV> PER DELEGA AVUTA, vestito in forma ufficiale, sono personalmente comparsi'
 where formula = '0-TES-T2'
   and testo_a3      is null
;
-- prompt 0-TES-UAC
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me <UFFICIALE_UTENTE>, Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono comparsi gli uniti civilmente:'
 where formula = '0-TES-UAC'
   and testo_a3      is null
;
-- prompt 0-TES-UCN
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me, <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono personalmente comparsi i coniugi'
 where formula = '0-TES-UCN'
   and testo_a3      is null
;
-- prompt 0-TES-UCO
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me <UFFICIALE_UTENTE>, Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA sono comparsi gli uniti civilmente:'
 where formula = '0-TES-UCO'
   and testo_a3      is null
;
-- prompt 0-TES-UPD
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>, avanti a me  <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE> PER DELEGA AVUTA, sono personalmente comparsi:'
 where formula = '0-TES-UPD'
   and testo_a3      is null
;
-- prompt 0-TTE
update civtfa
   set testo_a3 = 'A quest''atto sono stati presenti quali testimoni:'||chr(10)||'<TESTIMONI_COGNOME_NOME_1>'||chr(10)||'<TESTIMONI_NATO_1> a <TESTIMONI_COMUNE_NAS_1>'||chr(10)||'il <TESTIMONI_DATA_NAS_1>'||chr(10)||'Residente a <TESTIMONI_RESIDENZA_1>'||chr(10)||'<TESTIMONI_CITTADINO_1> <TESTIMONI_NAZIONALITA_1>'||chr(10)||'<TESTIMONI_COGNOME_NOME_2>'||chr(10)||'<TESTIMONI_NATO_2> a <TESTIMONI_COMUNE_NAS_2>'||chr(10)||'il <TESTIMONI_DATA_NAS_2>'||chr(10)||'Residente a <TESTIMONI_RESIDENZA_2>'||chr(10)||'<TESTIMONI_CITTADINO_2> <TESTIMONI_NAZIONALITA_2>'||chr(10)||''
 where formula = '0-TTE'
   and testo_a3      is null
;
-- prompt 0-TTR-AVV
update civtfa
   set testo_a3 = '   Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI> io sottoscritto <UFFICIALE_UTENTE>, Ufficiale dello stato civile del Comune di <COMUNE> per delega avuta, avendo ricevuto in data <DATA_NOTA_RIF> (prot. del Comune di <COMUNE> n. <PROTOCOLLO_PROV> del <DATA_PROTOCOLLO_PROV>) dall''avvocato '||chr(10)||'<AVVOCATO_1> con studio in <SEDE_AVVOCATO_1> , quale avvocato di <COGNOME_1> <NOME_1>'||chr(10)||'<AVVOCATO_2> con studio in <SEDE_AVVOCATO_2> , quale avvocato di <COGNOME_2> <NOME_2>,'||chr(10)||'la copia autenticata dell''accordo raggiunto a seguito di negoziazione assistita di scioglimento dell''unione civile concluso ai sensi dell''art.12, D.L. 12 settembre 2014, n. 132, convertito, con modificazione, dalla legge 10 novembre 2014, n. 162, munito delle certificazioni relative all''autografia delle firme ed alla conformita'' dello stesso alle norme imperative e all''ordine pubblico, nonche'' corredato del seguente provvedimento dell''autorita'' giudiziaria: ______________________________.'||chr(10)||'Aderendo a tale richiesta, provvedo alla trascrizione del documento, come segue:'
 where formula = '0-TTR-AVV'
   and testo_a3      is null
;
-- prompt 0-TTR-T2
update civtfa
   set testo_a3 = 'L''anno duemila<ANNO_OGGI> addi'' <GIORNO_OGGI> del mese di <MESE_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI> nella Casa comunale '||chr(10)||'Io <UFFICIALE_UTENTE>, Ufficiale dello Stato Civile di <COMUNE>, per delega avuta, avendo ricevuto dall''Ufficiale dello Stato Civile del Comune di <COMUNE_PROV> copia di verbale di trascrizione di atto di unione civile, trascrivo per intero la copia stessa, che e'' del tenore seguente:'
 where formula = '0-TTR-T2'
   and testo_a3      is null
;
-- prompt 2-CHI-CNA1
update civtfa
   set testo_a3 = 'Il presente atto viene letto all''intervenuto, il quale, insieme con me lo sottoscrive.'||chr(10)||'<COMUNE_NASCITA>, <DATA_ATTO_ORIGINALE_GGMMAAAA>'
 where formula = '2-CHI-CNA1'
   and testo_a3      is null
;
-- prompt 2-CHI-CNA2
update civtfa
   set testo_a3 = 'Il presente atto viene letto agli intervenuti, i quali tutti, insieme con me, lo sottoscrivono.'||chr(10)||'<COMUNE_NASCITA>, <DATA_ATTO_ORIGINALE_GGMMAAAA>'
 where formula = '2-CHI-CNA2'
   and testo_a3      is null
;
-- prompt 2-CIR-PAR
update civtfa
   set testo_a3 = '-'
 where formula = '2-CIR-PAR'
   and testo_a3      is null
;
-- prompt 2-DIC
update civtfa
   set testo_a3 = 'è compars<DICHIARANTE_COMPARSO> <DICHIARANTE> nat<DICHIARANTE_NATO> in <DICHIARANTE_COM_NAS> lì <DICHIARANTE_DATA_NAS>'||chr(10)||'(3) <DICHIARANTE_PROF>, residente in <DICHIARANTE_RESIDENZA> '||chr(10)||'<DICHIARANTE_IL>l<DICHIARANTE_LA> quale (4)'||chr(10)||''
 where formula = '2-DIC'
   and testo_a3      is null
;
-- prompt 2-DIC-CNA1
update civtfa
   set testo_a3 = 'è comparso <PATERNITA> nato in <COMUNE_NASCITA_PT> il <DATA_NASCITA_PT>, cittadino <NAZIONALITA_PT> residente in <COMUNE_RESIDENZA_PT> '||chr(10)||'il quale, nella sua veste di padre dichiara quanto segue:'
 where formula = '2-DIC-CNA1'
   and testo_a3      is null
;
-- prompt 2-DIC-CNA2
update civtfa
   set testo_a3 = 'è comparsa <MATERNITA> nato in <COMUNE_NASCITA_MT> il <DATA_NASCITA_MT>, cittadina <NAZIONALITA_MT> residente in <COMUNE_RESIDENZA_MT> '||chr(10)||'la quale, nella sua veste di madre dichiara quanto segue:'
 where formula = '2-DIC-CNA2'
   and testo_a3      is null
;
-- prompt 2-DIC-CNA3
update civtfa
   set testo_a3 = 'è compars<DICHIARANTE_COMPARSO> <DICHIARANTE> nat<DICHIARANTE_NATO> in <DICHIARANTE_COM_NAS> il <DICHIARANTE_DATA_NAS>, cittadina ... residente in <DICHIARANTE_RESIDENZA>, <DICHIARANTE_IL>l<DICHIARANTE_LA> quale, nella sua veste di madre dichiara quanto segue:'
 where formula = '2-DIC-CNA3'
   and testo_a3      is null
;
-- prompt 2-DIC-CNA4
update civtfa
   set testo_a3 = 'sono comparsi'||chr(10)||'<PATERNITA> nato in <COMUNE_NASCITA_PT> il <DATA_NASCITA_PT>, cittadino <NAZIONALITA_PT>, residente in <COMUNE_RESIDENZA_PT>, di professione <PROFESSIONE_PT>, titolo di studio <TITOLO_STUDIO_PT> e la signora <MATERNITA> nata in <COMUNE_NASCITA_MT>, il <DATA_NASCITA_MT>, cittadina <NAZIONALITA_MT>, residente in <COMUNE_RESIDENZA_MT>, di professione <PROFESSIONE_MT>, titolo di studio <TITOLO_STUDIO_MT>,'||chr(10)||'i quali, nella loro veste di genitori naturali, dichiarano quanto segue:'
 where formula = '2-DIC-CNA4'
   and testo_a3      is null
;
-- prompt 2-DNA
update civtfa
   set testo_a3 = 'alla presenza dei testimoni:'||chr(10)||''||chr(10)||' '||chr(10)||'mi ha dichiarato quanto segue:'||chr(10)||'   Il giorno <GIORNO_NASCITA> del mese di <MESE_NASCITA> dell''anno <ANNO_NASCITA>, '||chr(10)||'alle ore <ORE_NASCITA> e minuti <MINUTI_NASCITA> '||chr(10)||'nel<NEL> (4bis) <LUOGO_NASCITA_RIGA1>'||chr(10)||'<LUOGO_NASCITA_RIGA2> '||chr(10)||'da (5) '
 where formula = '2-DNA'
   and testo_a3      is null
;
-- prompt 2-DNA-CNA
update civtfa
   set testo_a3 = 'Il giorno <GIORNO_NASCITA> del mese di <MESE_NASCITA> dell''anno duemila<ANNO_NASCITA> alle ore <ORE> e minuti <MINUTI> in questo centro di nascita è nato un bambino di sesso <SESSO> al quale viene dato il nome di <NOME>'
 where formula = '2-DNA-CNA'
   and testo_a3      is null
;
-- prompt 2-FIL-CNA1
update civtfa
   set testo_a3 = 'Detto bambino, la cui nascita e'' comprovata dall''allegata attestazione di nascita, e'' nato dall''unione dei dichiaranti non parenti ne'' affini nei gradi che ostano al riconoscimento ai sensi dell''art. 251 c.c.'
 where formula = '2-FIL-CNA1'
   and testo_a3      is null
;
-- prompt 2-FIL-CNA2
update civtfa
   set testo_a3 = 'Detto bambino, la cui nascita e'' comprovata dall''allegata attestazione di nascita, e'' nato dalla signora <MATERNITA> nata in <COMUNE_NASCITA_MT>, il <DATA_NASCITA_MT>, cittadina <NAZIONALITA_MT>, residente in <COMUNE_RESIDENZA_MT>, coniugata con il signor '||chr(10)||'<PATERNITA> nato in <COMUNE_NASCITA_PT> il <DATA_NASCITA_PT>, cittadino <NAZIONALITA_PT>, residente in <COMUNE_RESIDENZA_PT>'
 where formula = '2-FIL-CNA2'
   and testo_a3      is null
;
-- prompt 2-FIR-CNA1
update civtfa
   set testo_a3 = 'Il Dichiarante F.to: <PATERNITA>'||chr(10)||'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '2-FIR-CNA1'
   and testo_a3      is null
;
-- prompt 2-FIR-CNA2
update civtfa
   set testo_a3 = 'I Dichiaranti F.to: <PATERNITA> e <MATERNITA>'||chr(10)||'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '2-FIR-CNA2'
   and testo_a3      is null
;
-- prompt 2-FIR-1A
update civtfa
   set testo_a3 = '------------------ L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '2-FIR-1A'
   and testo_a3      is null
;
-- prompt 2-FIR-1B
update civtfa
   set testo_a3 = '------------------ L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '2-FIR-1B'
   and testo_a3      is null
;
-- prompt 2-FIR-2A-1
update civtfa
   set testo_a3 = 'f.to <DICHIARANTE>'||chr(10)||' L''UFFICIALE DELLO STATO CIVILE f.to: <CHIUSURA_FIRMA>»'||chr(10)||'Eseguita la trascrizione, ho munito del mio visto ed inserito la copia suddetta nel volume degli allegati a questo registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '2-FIR-2A-1'
   and testo_a3      is null
;
-- prompt 2-FIR-2A-2
update civtfa
   set testo_a3 = 'f.to <PATERNITA>'||chr(10)||'f.to <MATERNITA>'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE f.to: <UFFICIALE_PROV>'||chr(10)||'Eseguita la trascrizione, ho munito del mio visto ed inserito la copia suddetta nel volume degli allegati a questo registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '2-FIR-2A-2'
   and testo_a3      is null
;
-- prompt 2-MAR-SEN
update civtfa
   set testo_a3 = '  Con sentenza del Tribunale di <MARGINE_SENTENZA_TRIBUNALE_1> <MARGINE_SENTENZA_TRIBUNALE_2> in data <MARGINE_SENTENZA_DATA>'||chr(10)||'<MARGINE_SENTENZA_ANNO> trascritta nei registri di nascita di questo Comune al N. <MARGINE_SENTENZA_ATTO_TRAS> P.II Serie B, dell''anno <MARGINE_SENTENZA_ANNO_TRAS> il presente atto <MARGINE_SENTENZA_E_STATO> dichiarato valido.'||chr(10)||''||chr(10)||'   li <MARGINE_SENTENZA_DATA_FIRMA>'||chr(10)||''||chr(10)||'          L''UFFICIALE DELLO STATO CIVILE'||chr(10)||''||chr(10)||'          ______________________________'
 where formula = '2-MAR-SEN'
   and testo_a3      is null
;
-- prompt 2-MAR-TR1
update civtfa
   set testo_a3 = '   Il presente atto di nascita è stato trascritto nei registri di Stato Civile del Comune di <MARGINE_TRASCRIZIONE_COMUNE> al N. <MARGINE_TRASCRIZIONE_ATTO> P. <MARGINE_TRASCRIZIONE_PARTE> S. <MARGINE_TRASCRIZIONE_SERIE> Anno <MARGINE_TRASCRIZIONE_ANNO_ATTO> come da comunicazione del <MARGINE_TRASCRIZIONE_DATA_COM>'||chr(10)||''||chr(10)||'   li <MARGINE_TRASCRIZIONE_DATA>'||chr(10)||''||chr(10)||'          L''UFFICIALE DELLO STATO CIVILE'||chr(10)||''||chr(10)||'          ______________________________'
 where formula = '2-MAR-TR1'
   and testo_a3      is null
;
-- prompt 2-PRE
update civtfa
   set testo_a3 = ' è nato un bambino di sesso <PRESENTAZIONE_SESSO>'||chr(10)||'   A detto bambino che (6) <PRESENTAZIONE_NON> <PRESENTAZIONE_PRESENTATO> <PRESENTAZIONE_RIGA1>'||chr(10)||'<PRESENTAZIONE_RIGA2> '||chr(10)||'(7) <PRESENTAZIONE_IL_LA> <PRESENTAZIONE_DA_IL_NOME> <PRESENTAZIONE_NOME>'||chr(10)||'<PRESENTAZIONE_RIGA3>'||chr(10)||'(8) <PRESENTAZIONE_RIGA4>'||chr(10)||'(9)'||chr(10)||''
 where formula = '2-PRE'
   and testo_a3      is null
;
-- prompt 2-TES
update civtfa
   set testo_a3 = '   L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> del mese di <TESTATA_MESE> '||chr(10)||'alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> '||chr(10)||'nel (1) <TESTATA_UBICAZIONE>'||chr(10)||'   Avanti a me, <TESTATA_UFFICIALE>, Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, (2) <TESTATA_MOTIVO>'
 where formula = '2-TES'
   and testo_a3      is null
;
-- prompt 2-TES-CNA1
update civtfa
   set testo_a3 = 'ATTO DI DICHIARAZIONE DI NASCITA'||chr(10)||'Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF> del Registro'||chr(10)||'L''anno <anno_atto_originale> addi <giorno_atto_originale> del mese di <mese_atto_originale> alle ore <ore_atto_originale> e minuti <minuti_atto_originale>'||chr(10)||'presso <luogo_nascita>'||chr(10)||'sito nel Comune di <COMUNE_NASCITA>'||chr(10)||'Innanzi al sottoscritto addetto alla Direzione Sanitaria, a cio'' espressamente autorizzato dal Direttore Sanitario con delega conservata in atti:'
 where formula = '2-TES-CNA1'
   and testo_a3      is null
;
-- prompt 2-TES-CNA2
update civtfa
   set testo_a3 = 'ATTO DI DICHIARAZIONE DI NASCITA'||chr(10)||'Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF> del Registro'||chr(10)||'L''anno <anno_atto_originale> addi <giorno_atto_originale> del mese di <mese_atto_originale> alle ore <ore_atto_originale> e minuti <minuti_atto_originale>'||chr(10)||'presso <luogo_nascita>'||chr(10)||'sito nel Comune di <COMUNE_NASCITA>'||chr(10)||'Innanzi al sottoscritto Direttore Medico <UFFICIALE_PROV>:'
 where formula = '2-TES-CNA2'
   and testo_a3      is null
;
-- prompt 2-TTR
update civtfa
   set testo_a3 = '   L''anno <TRASCRIZIONE_ANNO> addì <TRASCRIZIONE_GIORNO> del mese di <TRASCRIZIONE_MESE>'||chr(10)||'alle ore <TRASCRIZIONE_ORE> e minuti <TRASCRIZIONE_MINUTI> '||chr(10)||'nella Casa Comunale. '||chr(10)||'   Io <TRASCRIZIONE_UFFICIALE>, '||chr(10)||'Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE>,'||chr(10)||'(1) <TRASCRIZIONE_MOTIVO> '||chr(10)||'avendo ricevuto in data <TRASCRIZIONE_DATA>'||chr(10)||'dall''Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE_ATTO_ORIG> '||chr(10)||'copia di atto di nascita, trascrivo per intero la copia stessa, che è del tenore seguente:'
 where formula = '2-TTR'
   and testo_a3      is null
;
-- prompt 2-TTR-CNA
update civtfa
   set testo_a3 = 'Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI>'||chr(10)||'Io sottoscritto <UFFICIALE_UTENTE> Ufficiale dello Stato Civile del Comune di <COMUNE_RESIDENZA> ho ricevuto da <AUTORITA_PROV> di <COMUNE_PROV> la richiesta in data <DATA_NOTA_RIF> di trascrivere l''attestazione di nascita di <COGNOME_NOME> <NAT_OA> a <COMUNE_NASCITA> il <DATA_NASCITA> di cui mi ha trasmesso copia.'||chr(10)||'Aderendo a tale richiesta provvedo alla trascrizione per intero del documento, come segue:'
 where formula = '2-TTR-CNA'
   and testo_a3      is null
;
-- prompt 3-CHI-1
update civtfa
   set testo_a3 = 'Il presente atto viene letto agli intervenuti, i quali tutti, insieme con me, lo sottoscrivono.'||chr(10)||''
 where formula = '3-CHI-1'
   and testo_a3      is null
;
-- prompt 3-CHI-2
update civtfa
   set testo_a3 = 'Il presente atto viene letto all''intervenuto, il quale, insieme con me, lo sottoscrive.'||chr(10)||''
 where formula = '3-CHI-2'
   and testo_a3      is null
;
-- prompt 3-CHI-3
update civtfa
   set testo_a3 = 'Il presente atto viene letto all''intervenuta, la quale, insieme con me, lo sottoscrive.'||chr(10)||''
 where formula = '3-CHI-3'
   and testo_a3      is null
;
-- prompt 3-CHI-4
update civtfa
   set testo_a3 = 'Il presente atto viene letto all''intervenuto, il quale, insieme con me, lo sottoscrive.'
 where formula = '3-CHI-4'
   and testo_a3      is null
;
-- prompt 3-FIR-1
update civtfa
   set testo_a3 = 'IL DICHIARANTE ______________________________'||chr(10)||''||chr(10)||'LA DICHIARANTE ______________________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '3-FIR-1'
   and testo_a3      is null
;
-- prompt 3-FIR-2
update civtfa
   set testo_a3 = 'IL DICHIARANTE ______________________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '3-FIR-2'
   and testo_a3      is null
;
-- prompt 3-FIR-3
update civtfa
   set testo_a3 = 'LA DICHIARANTE ______________________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '3-FIR-3'
   and testo_a3      is null
;
-- prompt 3-FIR-4
update civtfa
   set testo_a3 = 'IL DICHIARANTE ______________________________L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '3-FIR-4'
   and testo_a3      is null
;
-- prompt 3-PDO
update civtfa
   set testo_a3 = 'Esaminati i documenti <PRESA_VISIONE_DOCUMENTI> do'' atto dell''insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_MATRIMONIO>.'||chr(10)||'I documenti sono:'||chr(10)||'Per lo sposo: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSO> il <DATA_ESTRATTO_SPOSO>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSO> il <DATA_CUMULATIVO_SPOSO>.'||chr(10)||'Per la sposa: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSA> il <DATA_ESTRATTO_SPOSA>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSA> il <DATA_CUMULATIVO_SPOSA>.'||chr(10)||''||chr(10)||''||chr(10)||'Detti documenti, muniti del mio visto, inserisco come allegati al presente processo verbale.'
 where formula = '3-PDO'
   and testo_a3      is null
;
-- prompt 3-PDO-NP
update civtfa
   set testo_a3 = '-'
 where formula = '3-PDO-NP'
   and testo_a3      is null
;
-- prompt 3-PDO-OME
update civtfa
   set testo_a3 = 'Le dichiarazioni rese dagli sposi trovano conferma nei documenti <PRESA_VISIONE_DOCUMENTI> che sono:'||chr(10)||'Per lo sposo: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSO> il <DATA_ESTRATTO_SPOSO>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSO> il <DATA_CUMULATIVO_SPOSO>.'||chr(10)||'Per la sposa: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSA> il <DATA_ESTRATTO_SPOSA>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSA> il <DATA_CUMULATIVO_SPOSA>.'||chr(10)||'(... decreto di autorizzazione all''omissione delle pubblicazioni)'
 where formula = '3-PDO-OME'
   and testo_a3      is null
;
-- prompt 3-SPO-OME1
update civtfa
   set testo_a3 = '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile <STATO_CIVILE_SPOSO>'||chr(10)||'E'||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile <STATO_CIVILE_SPOSA>'||chr(10)||' '||chr(10)||'i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti a'||chr(10)||''||chr(10)||'essi intendono contrarre senza la pubblicazione, della quale hanno ottenuto l''autorizzazione alla omissione, mi dichiarano che non esiste fra essi impedimento di parentela, affinita'', adozione o affiliazione, a termine dell''art. 87 del codice civile, ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.'
 where formula = '3-SPO-OME1'
   and testo_a3      is null
;
-- prompt 3-SPO-OME2
update civtfa
   set testo_a3 = '<cognome_nome_sposo> nato a <comune_nascita_sposo> il <data_nascita_sposo> cittadinanza <nazionalita_sposo> residente a <COMUNE_RESIDENZA_SPOSO> stato civile <STATO_CIVILE_SPOSO>E<cognome_nome_sposa> nata a <comune_nascita_sposa> il <data_nascita_sposa> cittadinanza <nazionalita_sposa> residente a <COMUNE_RESIDENZA_SPOSA> stato civile <STATO_CIVILE_SPOSA> i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti aessi intendono contrarre senza la pubblicazione, della quale hanno ottenuto l''autorizzazione alla omissione, mi dichiarano che non esiste fra essi impedimento di parentela, affinita'', adozione o affiliazione, a termine dell''art. 87 del codice civile, ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.'
 where formula = '3-SPO-OME2'
   and testo_a3      is null
;
-- prompt 3-SPO-OME3
update civtfa
   set testo_a3 = '<cognome_nome_sposo> nato a <comune_nascita_sposo> il <data_nascita_sposo> cittadinanza <nazionalita_sposo> residente a <COMUNE_RESIDENZA_SPOSO> stato civile <STATO_CIVILE_SPOSO>E<cognome_nome_sposa> nata a <comune_nascita_sposa> il <data_nascita_sposa> cittadinanza <nazionalita_sposa> residente a <COMUNE_RESIDENZA_SPOSA> stato civile <STATO_CIVILE_SPOSA> i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti aessi intendono contrarre senza la pubblicazione, della quale hanno ottenuto l''autorizzazione alla omissione, mi dichiarano che non esiste fra essi impedimento di parentela, affinita'', adozione o affiliazione, a termine dell''art. 87 del codice civile, ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.'
 where formula = '3-SPO-OME3'
   and testo_a3      is null
;
-- prompt 3-SPO-OME4
update civtfa
   set testo_a3 = '(... indicare le generalita'' del procuratore)'||chr(10)||'come procuratore speciale di:'||chr(10)||'<cognome_nome_sposo> nato a <comune_nascita_sposo> il <data_nascita_sposo> cittadinanza <nazionalita_sposo> residente a <COMUNE_RESIDENZA_SPOSO> stato civile <STATO_CIVILE_SPOSO> E <cognome_nome_sposa> nata a <comune_nascita_sposa> il <data_nascita_sposa> cittadinanza <nazionalita_sposa> residente a <COMUNE_RESIDENZA_SPOSA> stato civile <STATO_CIVILE_SPOSA>'||chr(10)||'secondo quanto risulta da '||chr(10)||'(... indicare i dati della procura),'||chr(10)||'i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti a'||chr(10)||'gli stessi rappresentati intendono contrarre senza la pubblicazione, della quale hanno ottenuto l''autorizzazione alla omissione, mi dichiarano che non esiste fra gli sposi impedimento di parentela, affinita'', adozione o affiliazione, a termine dell''art. 87 del codice civile ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.'
 where formula = '3-SPO-OME4'
   and testo_a3      is null
;
-- prompt 3-SPO-STR
update civtfa
   set testo_a3 = '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile:'||chr(10)||' [] celibe'||chr(10)||' [] gia'' coniugato con'||chr(10)||'    il ___________ a'||chr(10)||' [] vedovo di'||chr(10)||'    deceduta il __________ a'||chr(10)||'_________________________________E'||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile:'||chr(10)||' [] nubile'||chr(10)||' [] gia'' coniugata con'||chr(10)||'    il ___________ a'||chr(10)||' [] vedova di'||chr(10)||'    deceduto il __________ a'||chr(10)||''||chr(10)||'i quali, per la celebrazione del matrimonio che nel Comune di <COMUNE_MATRIMONIO> avanti a'||chr(10)||''||chr(10)||'essi intendono contrarre senza la pubblicazione, da cui sono esenti in quanto cittadini stranieri non domiciliati ne'' residenti in Italia mi dichiarano che non esistono fra essi impedimenti di parentela, affinita'', adozione o affiliazione, a termini dell''art. 87, numeri 1, 2 e 4 del codice civile,ne'' sussistono altri impedimenti ai sensi degli artt. 85, 86 e 88 dello stesso codice.'
 where formula = '3-SPO-STR'
   and testo_a3      is null
;
-- prompt 3-SPO-1
update civtfa
   set testo_a3 = '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile <STATO_CIVILE_SPOSO>'||chr(10)||'E'||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile <STATO_CIVILE_SPOSA>'||chr(10)||' '||chr(10)||'Davanti a me, sono comparsi a fare tale richiesta gli stessi sposi suindicati.'||chr(10)||'I richiedenti mi hanno altresi'' dichiarato di essere gli sposi di stato libero e che non osta al loro matrimonio alcun impedimento di parentela, di affinita'', di adozione e di affiliazione ai sensi dell''art. 87 del codice civile, ne'' che gli sposi hanno contratto fra loro precedente matrimonio, ne'' che alcuno di essi si trova nelle condizioni indicate negli artt. 85 e 88 del codice civile, ne'' che risulta sussistere altro impedimento stabilito dalla legge.'
 where formula = '3-SPO-1'
   and testo_a3      is null
;
-- prompt 3-SPO-2
update civtfa
   set testo_a3 = '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile <STATO_CIVILE_SPOSO>'||chr(10)||'E'||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile <STATO_CIVILE_SPOSA>'||chr(10)||' '||chr(10)||'Davanti a me, e'' comparso a fare tale richiesta lo sposo sopraindicato in nome ed anche per averne avuto incarico dalla sposa, come risulta da (... indicare i dati essenziali della procura)'||chr(10)||''||chr(10)||'che munita del mio visto allego al presente processo verbale.'||chr(10)||'Il richiedente mi ha altresi'' dichiarato di essere gli sposi di stato libero e che non osta al loro matrimonio alcun impedimento di parentela, di affinita'', di adozione e di affiliazione ai sensi dell''art. 87 del codice civile, ne'' che gli sposi hanno contratto fra loro precedente matrimonio, ne'' che alcuno di essi si trova nelle condizioni indicate negli artt. 85 e 88 del codice civile, ne'' che risulta sussistere altro impedimento stabilito dalla legge.'
 where formula = '3-SPO-2'
   and testo_a3      is null
;
-- prompt 3-SPO-3
update civtfa
   set testo_a3 = '<cognome_nome_sposo>'||chr(10)||' nato a <comune_nascita_sposo> il <data_nascita_sposo>'||chr(10)||' cittadinanza <nazionalita_sposo>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSO>'||chr(10)||' stato civile <STATO_CIVILE_SPOSO>'||chr(10)||'E'||chr(10)||'<cognome_nome_sposa>'||chr(10)||' nata a <comune_nascita_sposa> il <data_nascita_sposa>'||chr(10)||' cittadinanza <nazionalita_sposa>'||chr(10)||' residente a <COMUNE_RESIDENZA_SPOSA>'||chr(10)||' stato civile <STATO_CIVILE_SPOSA>'||chr(10)||' '||chr(10)||'Davanti a me, e'' comparsa a fare tale richiesta la sposa sopraindicata in nome ed anche per averne avuto incarico dallo sposo, come risulta da (... indicare i dati essenziali della procura)'||chr(10)||''||chr(10)||'che munita del mio visto allego al presente processo verbale.'||chr(10)||'Il richiedente mi ha altresi'' dichiarato di essere gli sposi di stato libero e che non osta al loro matrimonio alcun impedimento di parentela, di affinita'', di adozione e di affiliazione ai sensi dell''art. 87 del codice civile, ne'' che gli sposi hanno contratto fra loro precedente matrimonio, ne'' che alcuno di essi si trova nelle condizioni indicate negli artt. 85 e 88 del codice civile, ne'' che risulta sussistere altro impedimento stabilito dalla legge.'
 where formula = '3-SPO-3'
   and testo_a3      is null
;
-- prompt 3-SPO-4
update civtfa
   set testo_a3 = '<cognome_nome_sposo> nato a <comune_nascita_sposo> il <data_nascita_sposo> cittadinanza <nazionalita_sposo> residente a <COMUNE_RESIDENZA_SPOSO> stato civile <STATO_CIVILE_SPOSO> E <cognome_nome_sposa> nata a <comune_nascita_sposa> il <data_nascita_sposa> cittadinanza <nazionalita_sposa> residente a <COMUNE_RESIDENZA_SPOSA> stato civile <STATO_CIVILE_SPOSA> Davanti a me, e'' comparso a fare tale richiesta'||chr(10)||'(... indicare le generalita'' del procuratore)'||chr(10)||'come procuratore speciale degli sposi, come risulta da'||chr(10)||'(... indicare i dati essenziali della procura)'||chr(10)||'che munita del mio visto allego al presente processo verbale.'||chr(10)||'Il richiedente mi ha altresi'' dichiarato di essere gli sposi di stato libero e che non osta al loro matrimonio alcun impedimento di parentela, di affinita'', di adozione e di affiliazione ai sensi dell''art. 87 del codice civile, ne'' che gli sposi hanno contratto fra loro precedente matrimonio, ne'' che alcuno di essi si trova nelle condizioni indicate negli artt. 85 e 88 del codice civile, ne'' che risulta sussistere altro impedimento stabilito dalla legge.'
 where formula = '3-SPO-4'
   and testo_a3      is null
;
-- prompt 3-TES
update civtfa
   set testo_a3 = '(Art. 96 del C.C. e artt. 50 e 51 del D.P.R. 3 novembre 2000, n. 396)'||chr(10)||'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e minuti <minuti_oggi>'||chr(10)||'io sottoscritto <ufficiale_utente> del Comune di <comune>, per delegazione avuta, sono stato richiesto di procedere alla pubblicazione del matrimonio che dinanzi all''ufficiale di stato civile ; al parroco della chiesa di ... intendono fra loro contrarre:'
 where formula = '3-TES'
   and testo_a3      is null
;
-- prompt 3-TES-OME
update civtfa
   set testo_a3 = '(Art.100, comma 2 del C.C., art.58 del D.P.R. 3 novembre 2000, n.396) '||chr(10)||''||chr(10)||'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e minuti <minuti_oggi> '||chr(10)||'avanti a me <ufficiale_utente> Ufficiale dello stato civile del Comune di <comune>, per delegazione avuta, e'' comparso ; sono comparsi :'
 where formula = '3-TES-OME'
   and testo_a3      is null
;
-- prompt 3-TES-STR
update civtfa
   set testo_a3 = '(Art. 116, ultimo comma del codice civile)'||chr(10)||''||chr(10)||'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e minuti <minuti_oggi>'||chr(10)||'avanti a me <ufficiale_utente> del Comune di <comune>, per delegazione avuta, sono comparsi'||chr(10)||''
 where formula = '3-TES-STR'
   and testo_a3      is null
;
-- prompt 4-ART
update civtfa
   set testo_a3 = 'Agli sposi è stata data lettura degli articoli 143, 144 e 147 del Codice Civile da (10): <ARTICOLI_MINISTRO_RIGA1> '||chr(10)||'<ARTICOLI_MINISTRO_RIGA2>'||chr(10)||'davanti al quale il matrimonio è stato celebrato.'||chr(10)||'Io sottoscritto Ufficiale dello Stato Civile, ho constatato che la pubblicazione (11) <PUBBLICAZIONE_NON> fu eseguita (12):'
 where formula = '4-ART'
   and testo_a3      is null
;
-- prompt 4-CON-PAT
update civtfa
   set testo_a3 = '-'
 where formula = '4-CON-PAT'
   and testo_a3      is null
;
-- prompt 4-DMA
update civtfa
   set testo_a3 = 'L''anno <DATI_MATRIMONIO_ANNO> addì <DATI_MATRIMONIO_GIORNO>'||chr(10)||'del mese di <DATI_MATRIMONIO_MESE> alle ore <DATI_MATRIMONIO_ORE> e minuti <DATI_MATRIMONIO_MINUTI> '||chr(10)||'in (3) <DATI_MATRIMONIO_COMUNE> '||chr(10)||'nel<DATI_MATRIMONIO_NEL> (4) <DATI_MATRIMONIO_LUOGO> '||chr(10)||' '||chr(10)||'sono stati uniti in matrimonio, secondo il rito (5) <DATI_MATRIMONIO_RITO_RIGA1>'||chr(10)||'<DATI_MATRIMONIO_RITO_RIGA2>'||chr(10)||'<DATI_MATRIMONIO_RITO_RIGA3>'
 where formula = '4-DMA'
   and testo_a3      is null
;
-- prompt 4-DOC
update civtfa
   set testo_a3 = 'I<DOCUMENTI_IL> document<DOCUMENTI_DOCUMENTO> presentat<DOCUMENTI_PRESENTATO> (6)'
 where formula = '4-DOC'
   and testo_a3      is null
;
-- prompt 4-DOC-UAC
update civtfa
   set testo_a3 = 'A tal fine ho acquisito i seguenti documenti: copia integrale dell''atto di matrimonio, copia integrale degli atti di nascita, decreto di omologazione della separazione consensuale e le dichiarazioni da parte di entrambi i coniugi di voler pervenire alla cessazione degli effetti civili del matrimonio, che muniti del mio visto, inserisco nel volume degli allegati a questo registro.'||chr(10)||'Ho invitato le parti a comparire nuovamente davanti a questo Ufficio pe la conferma dell''accordo nel giorno <CONFERMA_DATA> e li ho informati che la mancata comparizione equivale a mancata conferma dell''accordo.'
 where formula = '4-DOC-UAC'
   and testo_a3      is null
;
-- prompt 4-FIR-AVV
update civtfa
   set testo_a3 = '<COMUNE_ACCORDO_DIVORZIO>, <DATA_ACCORDO_DIVORZIO_GGMMAAAA>'||chr(10)||'Sposa: F.to <COGNOME_NOME_SPOSA>'||chr(10)||'Sposo: F.to <COGNOME_NOME_SPOSO>'||chr(10)||'Avvocato: F.to <AVVOCATO_SPOSA>'||chr(10)||'Avvocato: F.to <AVVOCATO_SPOSO>'||chr(10)||'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________'
 where formula = '4-FIR-AVV'
   and testo_a3      is null
;
-- prompt 4-FIR-DIV1
update civtfa
   set testo_a3 = 'Sposo ______________________________ Sposa ______________________________L''UFFICIALE DELLO STATO CIVILE__________________________________________'
 where formula = '4-FIR-DIV1'
   and testo_a3      is null
;
-- prompt 4-FIR-DIV2
update civtfa
   set testo_a3 = 'Sposo ______________________________ '||chr(10)||'Sposa ______________________________'||chr(10)||'Avvocato Sposo _____________________ '||chr(10)||'Avvocato Sposa _____________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE __________________________________________'
 where formula = '4-FIR-DIV2'
   and testo_a3      is null
;
-- prompt 4-FIR-1
update civtfa
   set testo_a3 = '------------------ L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '4-FIR-1'
   and testo_a3      is null
;
-- prompt 4-FIR-2A
update civtfa
   set testo_a3 = 'Dato atto di quanto sopra ho eseguito in data odierna la trascrizione dell''atto di matrimonio e, dopo averli muniti del mio visto, inserisco l''atto medesimo e i documenti acquisiti nel volume degli allegati al presente registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'______________________________'||chr(10)||''
 where formula = '4-FIR-2A'
   and testo_a3      is null
;
-- prompt 4-FIR-2B
update civtfa
   set testo_a3 = '   Dato atto di quanto sopra, ho eseguito in data odierna la trascrizione dell''atto di matrimonio e, dopo averli muniti del mio visto, inserisco l''atto medesimo e i documenti acquisiti nel volume degli allegati al presente registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE f.to <CITT_MATRIMONIO_FIRMA>>>'||chr(10)||'Eseguita la trascrizione, ho munito del mio visto ed inserito la copia suddetta nel volume degli allegati.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ___________________________________'
 where formula = '4-FIR-2B'
   and testo_a3      is null
;
-- prompt 4-FIR-2C
update civtfa
   set testo_a3 = 'Sposo ______________________________ Sposa ______________________________'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'__________________________________________'
 where formula = '4-FIR-2C'
   and testo_a3      is null
;
-- prompt 4-MAR-CON
update civtfa
   set testo_a3 = '<MARGINE_CONVENZIONI>'||chr(10)||''||chr(10)||'<MARGINE_CONVENZIONI_COMUNE> <MARGINE_CONVENZIONI_LI_DATA>'||chr(10)||''||chr(10)||'   <MARGINE_CONVENZIONI_UFFICIALE>'||chr(10)||''||chr(10)||'   <MARGINE_CONVENZIONI_FIRMA>'
 where formula = '4-MAR-CON'
   and testo_a3      is null
;
-- prompt 4-MAR-LIB
update civtfa
   set testo_a3 = '<MARGINE_LIBRETTO>'||chr(10)||''||chr(10)||'<MARGINE_LIBRETTO_LI_DATA>'||chr(10)||''||chr(10)||'   <MARGINE_LIBRETTO_UFFICIALE>'||chr(10)||''||chr(10)||'   <MARGINE_LIBRETTO_FIRMA>'
 where formula = '4-MAR-LIB'
   and testo_a3      is null
;
-- prompt 4-MAR-MIN
update civtfa
   set testo_a3 = 'In data <MARGINE_TRAMSESSO_DATA> duemila<MARGINE_TRASMESSO_ANNO> ho trasmesso notizia al ministro del culto di (14) <MARGINE_TRASMESSO_MINISTRO_1> <MARGINE_TRASMESSO_MINISTRO_2>'||chr(10)||'dell''eseguita trascrizione dell''atto controscritto con l''indicazione della data in cui essa è stata effettuata.'||chr(10)||''||chr(10)||'   L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'  '||chr(10)||'   ______________________________'||chr(10)||''
 where formula = '4-MAR-MIN'
   and testo_a3      is null
;
-- prompt 4-MAR-TR1
update civtfa
   set testo_a3 = '   Il presente atto di matrimonio è stato altresì trascritto nei registri di Stato Civile del Comune di <MARGINE_TRASCRITTO_COMUNE_1>'||chr(10)||'al N. <MARGINE_TRASCRITTO_ATTO_1> P. <MARGINE_TRASCRITTO_PARTE_1> S. <MARGINE_TRASCRITTO_SERIE_1> Anno <MARGINE_TRASCRITTO_ANNO_1> come da comunicazione del <MARGINE_TRASCRITTO_DATA_COM_1> <MARGINE_TRASCRITTO_NUM_COM_1>'||chr(10)||''||chr(10)||'<MARGINE_TRASCRITTO_COM_FIRMA_1>, li <MARGINE_TRASCRITTO_DATA_1>'||chr(10)||''||chr(10)||'   L''UFFICIALE DELLO STATO CIVILE'||chr(10)||''||chr(10)||'   ______________________________'
 where formula = '4-MAR-TR1'
   and testo_a3      is null
;
-- prompt 4-MAR-TR2
update civtfa
   set testo_a3 = '   Il presente atto di matrimonio è stato altresì trascritto nei registri di Stato Civile del Comune di <MARGINE_TRASCRITTO_COMUNE_2>'||chr(10)||'al N. <MARGINE_TRASCRITTO_ATTO_2> P. <MARGINE_TRASCRITTO_PARTE_2> S. <MARGINE_TRASCRITTO_SERIE_2> Anno <MARGINE_TRASCRITTO_ANNO_2> come da comunicazione del <MARGINE_TRASCRITTO_DATA_COM_2> <MARGINE_TRASCRITTO_NUM_COM_2>'||chr(10)||''||chr(10)||'<MARGINE_TRASCRITTO_COM_FIRMA_2>, li <MARGINE_TRASCRITTO_DATA_2>'||chr(10)||''||chr(10)||'   L''UFFICIALE DELLO STATO CIVILE'||chr(10)||''||chr(10)||'   ______________________________'
 where formula = '4-MAR-TR2'
   and testo_a3      is null
;
-- prompt 4-RMA
update civtfa
   set testo_a3 = 'i quali mi hanno richiesto di unirli in matrimonio e a questo effetto mi hanno presentato i<RICHIESTA_IL> document<RICHIESTA_DOCUMENTO> sotto descritt<RICHIESTA_DESCRITTO> che, munit<RICHIESTA_MUNITO> del mio visto, inserisco nel volume degli allegati a questo registro, insieme con quelli già prodotti all''atto della richiesta della pubblicazione. Dall''esame di tutti gli anzidetti documenti risultandomi nulla ostare alla celebrazione del matrimonio, ho letto agli sposi gli articoli 143, 144 e 147 del Codice Civile, quindi ho domandato allo sposo se intende di prendere in moglie la qui presente '||chr(10)||'(3) <RICHIESTA_COGNOME_NOME_SPOSA>  '||chr(10)||'e a questa se intende di prendere in marito il qui presente '||chr(10)||'(2) <RICHIESTA_COGNOME_NOME_SPOSO> ; '||chr(10)||'ed avendomi ciascuno risposto affermativamente a piena intelligenza anche dei testimoni sottoindicati, ho dichiarato che i medesimi sono uniti in matrimonio. A quest''atto sono stati presenti quali testimoni:'
 where formula = '4-RMA'
   and testo_a3      is null
;
-- prompt 4-RMA-UAC
update civtfa
   set testo_a3 = '- di avere contratto matrimonio in data <MATRIMONIO_PREC_DATA> in <MATRIMONIO_PREC_COMUNE>, dinanzi a <MATRIMONIO_PREC_DINANZI>, di cui all''atto trascritto nei registri dello stato civile del Comune di <MATRIMONIO_PREC_COMUNE_ATTO> (n. <MATRIMONIO_PREC_ESTREMI_ATTO>);'||chr(10)||'- di non essere parti in giudizio pendente, concernente la <TIPO_DIVORZIO> tra gli stessi;'||chr(10)||'- di essere legalmente separati a seguito di:'||chr(10)||'Ricorso per separazione consensuale depositato in Cancelleria presso il Tribunale di Ravenna in data ...__________;'||chr(10)||'e di trovarsi in uno dei casi di cui all''articolo 3, primo comma, numero2), lettera b), legge 10 dicembre 1970, n. 898;'||chr(10)||'- di non essere genitori di figli minori;'||chr(10)||'- di non essere genitori di figli maggiorenni incapaci;'||chr(10)||'- di non essere genitori di figli maggiorenni poortatori di handicap grave ai sensi dell''articolo3, comma 3, della legge 5 febbraio 1992, n. 104;'||chr(10)||'- di non essere genitori di figli maggiorenni economicamente non autosufficienti;'||chr(10)||'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||'- di volere la cessazione degli effetti civili del matrimonio'
 where formula = '4-RMA-UAC'
   and testo_a3      is null
;
-- prompt 4-RMA-UCO
update civtfa
   set testo_a3 = 'di volere confermare l''accordo di <DIVORZIO_TIPO>, concluso innanzi a questo ufficio in data <ACCORDO_DATA> di cui all''atto iscritto al n. <ACCORDO_ESTREMI_ATTO>.'||chr(10)||'A tal fine ho acquisito copia integrale dell''atto n. <ACCORDO_ESTREMI_ATTO> che, munito del mio visto, inserisco nel volume degli allegati a questo registro.'
 where formula = '4-RMA-UCO'
   and testo_a3      is null
;
-- prompt 4-SPO-DIV1
update civtfa
   set testo_a3 = '<COGNOME_SPOSO> <NOME_SPOSO> '||chr(10)||'  nato in <COMUNE_NASCITA_SPOSO> <DATA_NASCITA_SPOSO>'||chr(10)||'  cittadinanza <NAZIONALITA_SPOSO>'||chr(10)||'  residente in <COMUNE_RESIDENZA_SPOSO> '||chr(10)||'E'||chr(10)||'<COGNOME_SPOSA> <NOME_SPOSA> '||chr(10)||'  nato in <COMUNE_NASCITA_SPOSA> <DATA_NASCITA_SPOSA>'||chr(10)||'  cittadinanza <NAZIONALITA_SPOSA>'||chr(10)||'  residente in <COMUNE_RESIDENZA_SPOSA> '||chr(10)||''
 where formula = '4-SPO-DIV1'
   and testo_a3      is null
;
-- prompt 4-SPO-DIV2
update civtfa
   set testo_a3 = '<COGNOME_SPOSO> <NOME_SPOSO> '||chr(10)||'  nato in <COMUNE_NASCITA_SPOSO> <DATA_NASCITA_SPOSO>'||chr(10)||'  cittadinanza <NAZIONALITA_SPOSO>'||chr(10)||'  residente in <COMUNE_RESIDENZA_SPOSO> '||chr(10)||'  con l''assistenza dell''avvocato <AVVOCATO_SPOSO>'||chr(10)||'E'||chr(10)||'<COGNOME_SPOSA> <NOME_SPOSA> '||chr(10)||'  nato in <COMUNE_NASCITA_SPOSA> <DATA_NASCITA_SPOSA>'||chr(10)||'  cittadinanza <NAZIONALITA_SPOSA>'||chr(10)||'  residente in <COMUNE_RESIDENZA_SPOSA> '||chr(10)||'  con l''assistenza dell''avvocato <AVVOCATO_SPOSA>'
 where formula = '4-SPO-DIV2'
   and testo_a3      is null
;
-- prompt 4-SPO-1
update civtfa
   set testo_a3 = '(2) <SPOSI_COGNOME_M> - (3) <SPOSI_COGNOME_F>'||chr(10)||'<SPOSI_NOME_M> - <SPOSI_NOME_F>'||chr(10)||'nato in <SPOSI_COMUNE_NAS_M> - nata in <SPOSI_COMUNE_NAS_F>'||chr(10)||'li <SPOSI_DATA_NAS_M_RIGA1> - li <SPOSI_DATA_NAS_F_RIGA1>'||chr(10)||'<SPOSI_DATA_NAS_M_RIGA2> - <SPOSI_DATA_NAS_F_RIGA2>'||chr(10)||'N. <SPOSI_ATTO_NAS_M> P. <SPOSI_PARTE_NAS_M> S. <SPOSI_SERIE_NAS_M> - N. <SPOSI_ATTO_NAS_F> P. <SPOSI_PARTE_NAS_F> S. <SPOSI_SERIE_NAS_F> '||chr(10)||'<SPOSI_STATO_CIVILE_M> - <SPOSI_STATO_CIVILE_F>  '||chr(10)||'(4) <SPOSI_PROFESSIONE_M> - (4) <SPOSI_PROFESSIONE_F>'||chr(10)||'residente in <SPOSI_RESIDENZA_M> - residente in <SPOSI_RESIDENZA_F>'||chr(10)||'(5) cittadinanza <SPOSI_CITTADINANZA_M> - (5) cittadinanza <SPOSI_CITTADINANZA_F>'
 where formula = '4-SPO-1'
   and testo_a3      is null
;
-- prompt 4-SPO-2A
update civtfa
   set testo_a3 = '(6) <SPOSI_COGNOME_M> - (7) <SPOSI_COGNOME_F>  '||chr(10)||'<SPOSI_NOME_M> - <SPOSI_NOME_F>'||chr(10)||'nato in <SPOSI_COMUNE_NAS_M> - nata in <SPOSI_COMUNE_NAS_F> '||chr(10)||'li <SPOSI_DATA_NAS_M_RIGA1> - li <SPOSI_DATA_NAS_F_RIGA1>  '||chr(10)||'<SPOSI_DATA_NAS_M_RIGA2> - <SPOSI_DATA_NAS_F_RIGA2> '||chr(10)||'Atto N. <SPOSI_ATTO_NAS_M> P. <SPOSI_PARTE_NAS_M> S. <SPOSI_SERIE_NAS_M> - Atto N. <SPOSI_ATTO_NAS_F> P. <SPOSI_PARTE_NAS_F> S. <SPOSI_SERIE_NAS_F> '||chr(10)||'(8) <SPOSI_PROFESSIONE_M> - (8) <SPOSI_PROFESSIONE_F> '||chr(10)||'residente in <SPOSI_RESIDENZA_M> - residente in <SPOSI_RESIDENZA_F> '||chr(10)||'(9) cittadino <SPOSI_CITTADINANZA_M> - (9) cittadina <SPOSI_CITTADINANZA_F>'
 where formula = '4-SPO-2A'
   and testo_a3      is null
;
-- prompt 4-SPO-2B
update civtfa
   set testo_a3 = '<SPOSI_COGNOME_M> - <SPOSI_COGNOME_F> '||chr(10)||'<SPOSI_NOME_M> - <SPOSI_NOME_F> '||chr(10)||'nato in <SPOSI_COMUNE_NAS_M> - nata in <SPOSI_COMUNE_NAS_F> '||chr(10)||'li <SPOSI_DATA_NAS_M_RIGA1> - li <SPOSI_DATA_NAS_F_RIGA1>'||chr(10)||'<SPOSI_DATA_NAS_M_RIGA2> - <SPOSI_DATA_NAS_F_RIGA2>'||chr(10)||'Atto N. <SPOSI_ATTO_NAS_M> P. <SPOSI_PARTE_NAS_M> S. <SPOSI_SERIE_NAS_F> -  Atto N. <SPOSI_ATTO_NAS_F> P. <SPOSI_PARTE_NAS_F> S. <SPOSI_SERIE_NAS_F> '||chr(10)||'<SPOSI_STATO_CIVILE_M> - <SPOSI_STATO_CIVILE_F> '||chr(10)||'<SPOSI_PROFESSIONE_M> - <SPOSI_PROFESSIONE_F> '||chr(10)||'residente in <SPOSI_RESIDENZA_M> - residente in <SPOSI_RESIDENZA_F> '||chr(10)||'cittadinanza <SPOSI_CITTADINANZA_M> - cittadinanza <SPOSI_CITTADINANZA_F> '
 where formula = '4-SPO-2B'
   and testo_a3      is null
;
-- prompt 4-TES-AVV
update civtfa
   set testo_a3 = 'ACCORDO DI <TIPO_DIVORZIO> EX ART. 6, COMMA 2, PRIMA PARTE DEL D.L. 132;2014, CONVERTITO IN LEGGE CON MODIFICHE DALLA L. 10 NOVEMBRE 2014, N. 162.'||chr(10)||'Premesso che'||chr(10)||'- i coniugi <COGNOME_NOME_SPOSO>, nato in <COMUNE_NASCITA_SPOSO> il <DATA_NASCITA_SPOSO> e <COGNOME_NOME_SPOSA>, nata in <COMUNE_NASCITA_SPOSA> il <DATA_NASCITA_SPOSA> hanno contratto matrimonio il <DATA_MATRIMONIO_PREC> a <COMUNE_MATRIMONIO_prec>: atto n. <ESTREMI_ATTO_MATRIMONIO_PREC>;'||chr(10)||'(caso SEPARAZIONE)'||chr(10)||'- tra gli stessi sono sorti insanabili divergenze tali da rendere impossibile la prosecuzione della convivenza;'||chr(10)||'(caso DIVORZIO)'||chr(10)||'- con decreto in data ...__________ il Tribunale di ...__________ ha omologato la separazione personale dei coniugi;'||chr(10)||'- sono stati avvertiti dagli avvocati della possibilita'' di ricorso alla mediazione familiare, ma nonostante il tentativo esperito di riconciliazione, le parti hanno raggiunto il seguente:'||chr(10)||'ACCORDO di <TIPO_DIVORZIO>'
 where formula = '4-TES-AVV'
   and testo_a3      is null
;
-- prompt 4-TES-UAC
update civtfa
   set testo_a3 = '   Oggi <TESTATA_GIORNO> del mese di <TESTATA_MESE> dell''anno <TESTATA_ANNO> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> avanti a me <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, per delega avuta, sono comparsi i coniugi:'
 where formula = '4-TES-UAC'
   and testo_a3      is null
;
-- prompt 4-TES-UCO
update civtfa
   set testo_a3 = '   Oggi <TESTATA_GIORNO> del mese di <TESTATA_MESE> dell''anno <TESTATA_ANNO> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> nel giorno stabilito per la conferma dell''accordo di <DIVORZIO_TIPO>, di cui all''atto iscritto al N. <ACCORDO_ESTREMI_ATTO>, avanti a me <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, per delega avuta, sono comparsi:'
 where formula = '4-TES-UCO'
   and testo_a3      is null
;
-- prompt 4-TES-1
update civtfa
   set testo_a3 = '   L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO> '||chr(10)||'del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI>,'||chr(10)||'nella Casa comunale in una sala aperta al pubblico.'||chr(10)||'   Avanti a me <TESTATA_UFFICIALE>, '||chr(10)||'Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE> '||chr(10)||'(1) <TESTATA_MOTIVO>'||chr(10)||'vestito in forma ufficiale, sono personalmente comparsi:'
 where formula = '4-TES-1'
   and testo_a3      is null
;
-- prompt 4-TES-2A
update civtfa
   set testo_a3 = '   L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO>'||chr(10)||'del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> '||chr(10)||'nella Casa Comunale.'||chr(10)||'   Io, <TESTATA_UFFICIALE> '||chr(10)||'Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE> '||chr(10)||'(1) <TESTATA_MOTIVO> '||chr(10)||'ho ricevuto da (2): <TESTATA_MINISTRO>'||chr(10)||'<TESTATA_QUALITA_RIGA1>'||chr(10)||'<TESTATA_QUALITA_RIGA2>'||chr(10)||'l''originale di atto di matrimonio, da cui risulta quanto appresso:'
 where formula = '4-TES-2A'
   and testo_a3      is null
;
-- prompt 4-TTE
update civtfa
   set testo_a3 = '<TESTIMONI_COGNOME_NOME_1>'||chr(10)||'nat<TESTIMONI_NATO_1> <TESTIMONI_COMUNE_NAS_1> '||chr(10)||'lì <TESTIMONI_DATA_NAS_1> (4) <TESTIMONI_PROFESSIONE_1>, '||chr(10)||'residente in <TESTIMONI_RESIDENZA_1>'||chr(10)||'e'||chr(10)||'<TESTIMONI_COGNOME_NOME_2>'||chr(10)||'nat<TESTIMONI_NATO_2> <TESTIMONI_COMUNE_NAS_2> '||chr(10)||'lì <TESTIMONI_DATA_NAS_2> (4) <TESTIMONI_PROFESSIONE_2>, '||chr(10)||'residente in <TESTIMONI_RESIDENZA_2>.'
 where formula = '4-TTE'
   and testo_a3      is null
;
-- prompt 4-TTR-AVV
update civtfa
   set testo_a3 = '   Oggi <GIORNO_OGGI> del mese di <MESE_OGGI> dell''anno duemila<ANNO_OGGI> alle ore <ORE_OGGI> e minuti <MINUTI_OGGI> io sottoscritta <UFFICIALE_UTENTE>, Ufficiale dello stato civile del Comune di <COMUNE> per delega avuta, avendo ricevuto in data <DATA_NOTA_RIF> (prot. del Comune di <COMUNE> n. <PROTOCOLLO_PROV> del <DATA_PROTOCOLLO_PROV>) dall''avvocato '||chr(10)||'<AVVOCATO_SPOSO> con studio in <SEDE_AVVOCATO_SPOSO> , quale avvocato di <COGNOME_SPOSO> <NOME_SPOSO>'||chr(10)||'<AVVOCATO_SPOSA> con studio in <SEDE_AVVOCATO_SPOSA> , quale avvocato di <COGNOME_SPOSA> <NOME_SPOSA>'||chr(10)||', la copia autenticata dell''accordo raggiunto a seguito di convenzione di negoziazione assistita di <TIPO_DIVORZIO> sottoscritto il <DATA_ACCORDO_DIVORZIO> , munito delle certificazioni relative all''autografia delle firme ed alla conformità dello stesso alle norme imperative e all''ordine pubblico, nonche'' corredato del seguente provvedimento dell''autorita'' giudiziaria: nulla osta (oppure: autorizzazione) del Procuratore della Repubblica presso il Tribunale di Ravenna n. R.G._____;_____ , emesso in data _____________ , depositato in Cancelleria in data _____________ .'||chr(10)||'Aderendo a tale richiesta, provvedo alla trascrizione del documento, come segue:'
 where formula = '4-TTR-AVV'
   and testo_a3      is null
;
-- prompt 4-TTR-2B
update civtfa
   set testo_a3 = '   L''anno <TRASCRIZIONE_ANNO> addì <TRASCRIZIONE_GIORNO>'||chr(10)||'del mese di <TRASCRIZIONE_MESE> alle ore <TRASCRIZIONE_ORE> e minuti <TRASCRIZIONE_MINUTI>'||chr(10)||'nella Casa comunale.'||chr(10)||'   Io <TRASCRIZIONE_UFFICIALE>, '||chr(10)||'Ufficiale dello Stato Civile di <TRASCRIZIONE_COMUNE>, '||chr(10)||'(1) <TRASCRIZIONE_MOTIVO> '||chr(10)||'avendo ricevuto dall''Ufficiale dello Stato Civile del Comune di:'||chr(10)||'<TRASCRIZIONE_COMUNE_ORIG>'||chr(10)||'copia di verbale di trascrizione di atto di matrimonio, trascrivo per intero la copia stessa, che è del tenore seguente:'
 where formula = '4-TTR-2B'
   and testo_a3      is null
;
-- prompt 5-DIC
update civtfa
   set testo_a3 = '(2) è compars<DICHIARANTE_COMPARSO> <DICHIARANTE> '||chr(10)||'nat<DICHIARANTE_NATO> <DICHIARANTE_COM_NAS> '||chr(10)||'li <DICHIARANTE_DATA_NAS> '||chr(10)||'(3) <DICHIARANTE_PROF>'||chr(10)||'residente in <DICHIARANTE_RESIDENZA> <DICHIARANTE_IL_QUALE> quale, alla presenza dei testimoni:'||chr(10)||'nat'||chr(10)||'li'||chr(10)||'(3)'||chr(10)||'residente in'||chr(10)||'e '||chr(10)||'nat'||chr(10)||'li'||chr(10)||'(3)'||chr(10)||'residente in'||chr(10)||'mi ha dichiarato quanto segue: '
 where formula = '5-DIC'
   and testo_a3      is null
;
-- prompt 5-DMO-1
update civtfa
   set testo_a3 = 'Il giorno <DATI_MORTE_GIORNO>'||chr(10)||'del mese di <DATI_MORTE_MESE> dell''anno <DATI_MORTE_ANNO>'||chr(10)||'alle ore <DATI_MORTE_ORE> e minuti <DATI_MORTE_MINUTI>'||chr(10)||'nel (3-bis) <DATI_MORTE_LUOGO_RIGA1> '||chr(10)||'<DATI_MORTE_LUOGO_RIGA2>'||chr(10)||'è mort<DATI_MORTE_MORT_OA> (4) <DATI_MORTE_DEFUNTO>'||chr(10)||'(5) <DATI_MORTE_CITTADINANZA>'||chr(10)||'residente in <DATI_MORTE_RESIDENZA> '||chr(10)||'(3) <DATI_MORTE_PROF>, '||chr(10)||'nat<DATI_MORTE_NATO> <DATI_MORTE_COM_NAS>'||chr(10)||'li <DATI_MORTE_DATA_NAS>'
 where formula = '5-DMO-1'
   and testo_a3      is null
;
-- prompt 5-DMO-2A
update civtfa
   set testo_a3 = 'Il giorno <DATI_MORTE_GIORNO>'||chr(10)||'del mese di <DATI_MORTE_MESE> dell''anno <DATI_MORTE_ANNO>'||chr(10)||'alle ore <DATI_MORTE_ORE> e minuti <DATI_MORTE_MINUTI>'||chr(10)||'nel <DATI_MORTE_LUOGO_RIGA1> '||chr(10)||'<DATI_MORTE_LUOGO_RIGA2>'||chr(10)||'è mort<DATI_MORTE_MORT_OA> <DATI_MORTE_DEFUNTO>'||chr(10)||'<DATI_MORTE_CITTADINANZA>'||chr(10)||'residente in <DATI_MORTE_RESIDENZA> '||chr(10)||'<DATI_MORTE_PROF>, '||chr(10)||'nat<DATI_MORTE_NATO> <DATI_MORTE_COM_NAS>'||chr(10)||'li <DATI_MORTE_DATA_NAS>'
 where formula = '5-DMO-2A'
   and testo_a3      is null
;
-- prompt 5-DMO-2B
update civtfa
   set testo_a3 = 'Il giorno <DATI_MORTE_GIORNO> del mese di <DATI_MORTE_MESE> '||chr(10)||'dell''anno <DATI_MORTE_ANNO> alle ore <DATI_MORTE_ORE> '||chr(10)||'e minuti <DATI_MORTE_MINUTI>'||chr(10)||'(4) in <DATI_MORTE_LUOGO_RIGA1> '||chr(10)||'<DATI_MORTE_LUOGO_RIGA2>'||chr(10)||'è mort<DATI_MORTE_MORT_OA> (5) <DATI_MORTE_DEFUNTO>'||chr(10)||'(6) <DATI_MORTE_CITTADINANZA>'||chr(10)||'residente in <DATI_MORTE_RESIDENZA> '||chr(10)||'(7) <DATI_MORTE_PROF>, '||chr(10)||'nat<DATI_MORTE_NATO> <DATI_MORTE_COM_NAS>'||chr(10)||'li <DATI_MORTE_DATA_NAS>'
 where formula = '5-DMO-2B'
   and testo_a3      is null
;
-- prompt 5-DMO-2BB
update civtfa
   set testo_a3 = 'Il giorno <DATI_MORTE_GIORNO> del mese di <DATI_MORTE_MESE> '||chr(10)||'dell''anno <DATI_MORTE_ANNO> alle ore <DATI_MORTE_ORE> '||chr(10)||'e minuti <DATI_MORTE_MINUTI>'||chr(10)||'in <DATI_MORTE_LUOGO_RIGA1> '||chr(10)||'<DATI_MORTE_LUOGO_RIGA2>'||chr(10)||'è mort<DATI_MORTE_MORT_OA> <DATI_MORTE_DEFUNTO>'||chr(10)||'<DATI_MORTE_CITTADINANZA>'||chr(10)||'residente in <DATI_MORTE_RESIDENZA> '||chr(10)||'<DATI_MORTE_PROF>, '||chr(10)||'nat<DATI_MORTE_NATO> <DATI_MORTE_COM_NAS>'||chr(10)||'li <DATI_MORTE_DATA_NAS>'
 where formula = '5-DMO-2BB'
   and testo_a3      is null
;
-- prompt 5-FIR-1
update civtfa
   set testo_a3 = '------------------ L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '5-FIR-1'
   and testo_a3      is null
;
-- prompt 5-FIR-2A
update civtfa
   set testo_a3 = 'f.to <DICHIARANTE>'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE f.to: <CHIUSURA_FIRMA> '||chr(10)||'Eseguita la trascrizione, ho munito del mio visto ed inserito la copia suddetta nel volume degli allegati a questo registro.'||chr(10)||'L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '5-FIR-2A'
   and testo_a3      is null
;
-- prompt 5-FIR-2B
update civtfa
   set testo_a3 = '------------------ L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '5-FIR-2B'
   and testo_a3      is null
;
-- prompt 5-FIR-2BB
update civtfa
   set testo_a3 = '------------------ L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '5-FIR-2BB'
   and testo_a3      is null
;
-- prompt 5-FIR-2C
update civtfa
   set testo_a3 = '------------------ L''UFFICIALE DELLO STATO CIVILE ______________________________'
 where formula = '5-FIR-2C'
   and testo_a3      is null
;
-- prompt 5-GMO-1
update civtfa
   set testo_a3 = 'figli<GENITORI_FIGLIO> di (6) <GENITORI_PADRE>'||chr(10)||'(3) <GENITORI_PROF_PADRE>'||chr(10)||'residente in <GENITORI_RESIDENZA_PADRE>'||chr(10)||'e di (7) <GENITORI_MADRE> '||chr(10)||'(3) <GENITORI_PROF_MADRE>'||chr(10)||'residente in <GENITORI_RESIDENZA_MADRE>'||chr(10)||'e che era (8) <GENITORI_STATO_CIV_RIGA1>'||chr(10)||'<GENITORI_STATO_CIV_RIGA2>'
 where formula = '5-GMO-1'
   and testo_a3      is null
;
-- prompt 5-GMO-2A
update civtfa
   set testo_a3 = 'figli<GENITORI_FIGLIO> di <GENITORI_PADRE>'||chr(10)||'<GENITORI_PROF_PADRE>'||chr(10)||'residente in <GENITORI_RESIDENZA_PADRE>'||chr(10)||'e di <GENITORI_MADRE> '||chr(10)||'<GENITORI_PROF_MADRE>'||chr(10)||'residente in <GENITORI_RESIDENZA_MADRE>'||chr(10)||'e che era <GENITORI_STATO_CIV_RIGA1>'
 where formula = '5-GMO-2A'
   and testo_a3      is null
;
-- prompt 5-GMO-2B
update civtfa
   set testo_a3 = 'figli<GENITORI_FIGLIO> di (8) <GENITORI_PADRE>'||chr(10)||'(7) <GENITORI_PROF_PADRE>'||chr(10)||'residente in <GENITORI_RESIDENZA_PADRE>'||chr(10)||'e di (9) <GENITORI_MADRE> '||chr(10)||'(7) <GENITORI_PROF_MADRE>'||chr(10)||'residente in <GENITORI_RESIDENZA_MADRE>'||chr(10)||'e che era (10) <GENITORI_STATO_CIV_RIGA1> <GENITORI_STATO_CIV_RIGA2>'
 where formula = '5-GMO-2B'
   and testo_a3      is null
;
-- prompt 5-GMO-2BB
update civtfa
   set testo_a3 = 'figli<GENITORI_FIGLIO> di <GENITORI_PADRE>'||chr(10)||'<GENITORI_PROF_PADRE>'||chr(10)||'residente in <GENITORI_RESIDENZA_PADRE>'||chr(10)||'e di <GENITORI_MADRE> '||chr(10)||'<GENITORI_PROF_MADRE>'||chr(10)||'residente in <GENITORI_RESIDENZA_MADRE>'||chr(10)||'e che era <GENITORI_STATO_CIV_RIGA1>'
 where formula = '5-GMO-2BB'
   and testo_a3      is null
;
-- prompt 5-MAR-NAS
update civtfa
   set testo_a3 = '   L''atto di nascita del di contro è iscritto nei registri di Stato Civile del Comune di:'||chr(10)||'<MARGINE_NASCITA_COMUNE>'||chr(10)||'al N. <MARGINE_NASCITA_ATTO> P. <MARGINE_NASCITA_PARTE> S. <MARGINE_NASCITA_SERIE> Uff. <MARGINE_NASCITA_UFFICIO> Anno <MARGINE_NASCITA_ANNO>'||chr(10)||''||chr(10)||'li <MARGINE_NASCITA_DATA>'||chr(10)||''||chr(10)||'L''UFFICIALE DELLO STATO CIVILE'||chr(10)||'______________________________'||chr(10)||''
 where formula = '5-MAR-NAS'
   and testo_a3      is null
;
-- prompt 5-MAR-TR1
update civtfa
   set testo_a3 = '   Il presente atto di morte è stato trascritto nei registri di Stato Civile del Comune di <MARGINE_TRASCRIZIONE_COMUNE> al N. <MARGINE_TRASCRIZIONE_ATTO> P. <MARGINE_TRASCRIZIONE_PARTE> S. <MARGINE_TRASCRIZIONE_SERIE> Anno <MARGINE_TRASCRIZIONE_ANNO_ATTO> come da comunicazione del <MARGINE_TRASCRIZIONE_DATA_COM>   li <MARGINE_TRASCRIZIONE_DATA>          L''UFFICIALE DELLO STATO CIVILE          ______________________________'
 where formula = '5-MAR-TR1'
   and testo_a3      is null
;
-- prompt 5-TES-1
update civtfa
   set testo_a3 = '   L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO>'||chr(10)||'del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI>'||chr(10)||'nella Casa comunale.'||chr(10)||'Avanti a me, <TESTATA_UFFICIALE> Ufficiale'||chr(10)||'dello Stato Civile del Comune di <TESTATA_COMUNE>, '||chr(10)||'(1) <TRASCRIZIONE_MOTIVO>'
 where formula = '5-TES-1'
   and testo_a3      is null
;
-- prompt 5-TES-2A
update civtfa
   set testo_a3 = '   L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO>'||chr(10)||'del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI>'||chr(10)||'nella Casa comunale.'||chr(10)||'Avanti a me, <TESTATA_UFFICIALE> Ufficiale'||chr(10)||'dello Stato Civile del Comune di <TESTATA_COMUNE>, '||chr(10)||'<TRASCRIZIONE_MOTIVO>'
 where formula = '5-TES-2A'
   and testo_a3      is null
;
-- prompt 5-TES-2B
update civtfa
   set testo_a3 = '   L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO>'||chr(10)||'del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> '||chr(10)||'nella Casa comunale.'||chr(10)||'   Io <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, '||chr(10)||'(1) <TESTATA_MOTIVO> avendo ricevuto '||chr(10)||'dal (2) <TESTATA_RICEVUTO>'||chr(10)||'(3) un <TESTATA_DOCUMENTO>'||chr(10)||'con la data <TESTATA_DATA_DOC> '||chr(10)||'che munit<TESTATA_MUNITO> del mio visto, inserisco nel volume degli allegati a questo registro, dò atto che:'
 where formula = '5-TES-2B'
   and testo_a3      is null
;
-- prompt 5-TES-2BB
update civtfa
   set testo_a3 = '   L''anno <TESTATA_ANNO> addì <TESTATA_GIORNO>'||chr(10)||'del mese di <TESTATA_MESE> alle ore <TESTATA_ORE> e minuti <TESTATA_MINUTI> '||chr(10)||'nella Casa comunale.'||chr(10)||'   Io <TESTATA_UFFICIALE> Ufficiale dello Stato Civile del Comune di <TESTATA_COMUNE>, '||chr(10)||'<TESTATA_MOTIVO> avendo ricevuto '||chr(10)||'dal <TESTATA_RICEVUTO>'||chr(10)||'un <TESTATA_DOCUMENTO>'||chr(10)||'con la data <TESTATA_DATA_DOC> '||chr(10)||'che munit<TESTATA_MUNITO> del mio visto, inserisco nel volume degli allegati a questo registro, dò atto che:'
 where formula = '5-TES-2BB'
   and testo_a3      is null
;
-- prompt 5-TTR-2A
update civtfa
   set testo_a3 = '   L''anno <TRASCRIZIONE_ANNO> addì <TRASCRIZIONE_GIORNO> '||chr(10)||'del mese di <TRASCRIZIONE_MESE> alle ore <TRASCRIZIONE_ORE> e minuti <TRASCRIZIONE_MINUTI> '||chr(10)||'nella Casa comunale.'||chr(10)||'   Io <TRASCRIZIONE_UFFICIALE>, Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE>, '||chr(10)||'(1) <TRASCRIZIONE_MOTIVO> avendo ricevuto dall''Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE_ORIG> '||chr(10)||'copia di atto di morte, trascrivo per intero la copia stessa che è del tenore seguente:'
 where formula = '5-TTR-2A'
   and testo_a3      is null
;
-- prompt 5-TTR-2BB
update civtfa
   set testo_a3 = '   L''anno <TRASCRIZIONE_ANNO> addì <TRASCRIZIONE_GIORNO> '||chr(10)||'del mese di <TRASCRIZIONE_MESE> alle ore <TRASCRIZIONE_ORE> e minuti <TRASCRIZIONE_MINUTI> '||chr(10)||'nella Casa comunale.'||chr(10)||'   Io <TRASCRIZIONE_UFFICIALE>, Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE>, '||chr(10)||'(1) <TRASCRIZIONE_MOTIVO> avendo ricevuto dall''Ufficiale dello Stato Civile del Comune di <TRASCRIZIONE_COMUNE_ORIG> '||chr(10)||'copia di atto di morte, trascrivo per intero la copia stessa che è del tenore seguente:'
 where formula = '5-TTR-2BB'
   and testo_a3      is null
;
-- prompt 4-RMA-UACC
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-RMA-UACC', 1, '',
'- di avere contratto matrimonio in data <MATRIMONIO_PREC_DATA> in <MATRIMONIO_PREC_COMUNE>, dinanzi a <MATRIMONIO_PREC_DINANZI>, di cui all''atto trascritto nei registri dello stato civile del Comune di <MATRIMONIO_PREC_COMUNE_ATTO> (n. <MATRIMONIO_PREC_ESTREMI_ATTO>);'||chr(10)||
'- di essere;non essere parti in giudizio pendente, concernente la <TIPO_DIVORZIO> tra gli stessi (in caso affermativo, indicare l''autorita'' giudiziaria...);'||chr(10)||
'- di essere legalmente separati a seguito di... (indicare il provvedimento;la convenzione di negoziazione assistita;l''accordo cha ha determinato la separazione, con tutti i dati per identificarlo...) e di trovarsi in uno dei casi di cui all''articolo 3, primo comma, numero 2), lettera b), legge 10 dicembre 1970, n. 898;'||chr(10)||
'- di non essere genitori di figli minori;'||chr(10)||
'- di non essere genitori di figli maggiorenni incapaci;'||chr(10)||
'- di non essere genitori di figli maggiorenni portatori di handicap grave ai sensi dell''articolo 3, comma 3, della legge 5 febbraio 1992, n.104;'||chr(10)||
'- di non essere genitori di figli maggiorenni economicamente non autosufficienti;'||chr(10)||
'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||
'- di volere la cessazione degli effetti civili del matrimonio',
'- di avere contratto matrimonio in data <MATRIMONIO_PREC_DATA> in <MATRIMONIO_PREC_COMUNE>, dinanzi a <MATRIMONIO_PREC_DINANZI>, di cui all''atto trascritto nei registri dello stato civile del Comune di <MATRIMONIO_PREC_COMUNE_ATTO> (n. <MATRIMONIO_PREC_ESTREMI_ATTO>);'||chr(10)||
'- di essere;non essere parti in giudizio pendente, concernente la <TIPO_DIVORZIO> tra gli stessi (in caso affermativo, indicare l''autorita'' giudiziaria...);'||chr(10)||
'- di essere legalmente separati a seguito di... (indicare il provvedimento;la convenzione di negoziazione assistita;l''accordo cha ha determinato la separazione, con tutti i dati per identificarlo...) e di trovarsi in uno dei casi di cui all''articolo 3, primo comma, numero 2), lettera b), legge 10 dicembre 1970, n. 898;'||chr(10)||
'- di non essere genitori di figli minori;'||chr(10)||
'- di non essere genitori di figli maggiorenni incapaci;'||chr(10)||
'- di non essere genitori di figli maggiorenni portatori di handicap grave ai sensi dell''articolo 3, comma 3, della legge 5 febbraio 1992, n.104;'||chr(10)||
'- di non essere genitori di figli maggiorenni economicamente non autosufficienti;'||chr(10)||
'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||
'- di volere la cessazione degli effetti civili del matrimonio.'
  from dual
 where not exists (select 1 from civtfa b where formula = '4-RMA-UACC' and riga = 1)
;
-- prompt 4-RMA-UACS
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-RMA-UACS', 1, '',
'- di avere contratto matrimonio in data <MATRIMONIO_PREC_DATA> in <MATRIMONIO_PREC_COMUNE>, dinanzi a <MATRIMONIO_PREC_DINANZI>, di cui all''atto trascritto nei registri dello stato civile del Comune di <MATRIMONIO_PREC_COMUNE_ATTO> (n. <MATRIMONIO_PREC_ESTREMI_ATTO>);'||chr(10)||
'- di essere;non essere parti in giudizio pendente, concernente lo <TIPO_DIVORZIO> tra gli stessi (in caso affermativo, indicare l''autorita'' giudiziaria...);'||chr(10)||
'- di essere legalmente separati a seguito di... (indicare il provvedimento;la convenzione di negoziazione assistita;l''accordo cha ha determinato la separazione, con tutti i dati per identificarlo...) e di trovarsi in uno dei casi di cui all''articolo 3, primo comma, numero 2), lettera b), legge 10 dicembre 1970, n. 898;'||chr(10)||
'- di non essere genitori di figli minori;'||chr(10)||
'- di non essere genitori di figli maggiorenni incapaci;'||chr(10)||
'- di non essere genitori di figli maggiorenni portatori di handicap grave ai sensi dell''articolo 3, comma 3, della legge 5 febbraio 1992, n.104;'||chr(10)||
'- di non essere genitori di figli maggiorenni economicamente non autosufficienti;'||chr(10)||
'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||
'- di volere lo scioglimento del matrimonio',
'- di avere contratto matrimonio in data <MATRIMONIO_PREC_DATA> in <MATRIMONIO_PREC_COMUNE>, dinanzi a <MATRIMONIO_PREC_DINANZI>, di cui all''atto trascritto nei registri dello stato civile del Comune di <MATRIMONIO_PREC_COMUNE_ATTO> (n. <MATRIMONIO_PREC_ESTREMI_ATTO>);'||chr(10)||
'- di essere;non essere parti in giudizio pendente, concernente la <TIPO_DIVORZIO> tra gli stessi (in caso affermativo, indicare l''autorita'' giudiziaria...);'||chr(10)||
'- di essere legalmente separati a seguito di... (indicare il provvedimento;la convenzione di negoziazione assistita;l''accordo cha ha determinato la separazione, con tutti i dati per identificarlo...) e di trovarsi in uno dei casi di cui all''articolo 3, primo comma, numero 2), lettera b), legge 10 dicembre 1970, n. 898;'||chr(10)||
'- di non essere genitori di figli minori;'||chr(10)||
'- di non essere genitori di figli maggiorenni incapaci;'||chr(10)||
'- di non essere genitori di figli maggiorenni portatori di handicap grave ai sensi dell''articolo 3, comma 3, della legge 5 febbraio 1992, n.104;'||chr(10)||
'- di non essere genitori di figli maggiorenni economicamente non autosufficienti;'||chr(10)||
'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||
'- di volere lo scioglimento del matrimonio.'
  from dual
 where not exists (select 1 from civtfa b where formula = '4-RMA-UACS' and riga = 1)
;
-- prompt 4-RMA-UACX
insert into civtfa (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '4-RMA-UACX', 1, '',
'- di avere contratto matrimonio in data <DATA_MATRIMONIO_PREC>   in <MATRIMONIO_PREC_COMUNE>, dinanzi a <MATRIMONIO_PREC_DINANZI>, di cui all''atto trascritto nei registri dello stato civile del Comune di <MATRIMONIO_PREC_COMUNE_ATTO> (n. <MATRIMONIO_PREC_ESTREMI_ATTO>);'||chr(10)||
'- di essere;non essere parti in giudizio pendente, concernente la separazione personale tra gli stessi (in caso affermativo, indicare l''autorita'' giudiziaria);'||chr(10)||
'- di non essere genitori di figli minori;'||chr(10)||
'- di non essere genitori di figli maggiorenni incapaci;'||chr(10)||
'- di non essere genitori di figli maggiorenni portatori di handicap grave ai sensi dell''articolo 3, comma 3, della legge 5 febbraio 1992, n.104;'||chr(10)||
'- di non essere genitori di figli maggiorenni economicamente non autosufficienti;'||chr(10)||
'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||
'- di volersi separare consensualmente',
'- di avere contratto matrimonio in data <DATA_MATRIMONIO_PREC>   in <MATRIMONIO_PREC_COMUNE>, dinanzi a <MATRIMONIO_PREC_DINANZI>, di cui all''atto trascritto nei registri dello stato civile del Comune di <MATRIMONIO_PREC_COMUNE_ATTO> (n. <MATRIMONIO_PREC_ESTREMI_ATTO>);'||chr(10)||
'- di essere;non essere parti in giudizio pendente, concernente la separazione personale tra gli stessi (in caso affermativo, indicare l''autorita'' giudiziaria);'||chr(10)||
'- di non essere genitori di figli minori;'||chr(10)||
'- di non essere genitori di figli maggiorenni incapaci;'||chr(10)||
'- di non essere genitori di figli maggiorenni portatori di handicap grave ai sensi dell''articolo 3, comma 3, della legge 5 febbraio 1992, n.104;'||chr(10)||
'- di non essere genitori di figli maggiorenni economicamente non autosufficienti;'||chr(10)||
'- di non concordare tra di loro alcun patto di trasferimento patrimoniale;'||chr(10)||
'- di volersi separare consensualmente;'
  from dual
 where not exists (select 1 from civtfa b where formula = '4-RMA-UACX' and riga = 1)
;
-- 16/05/2024 (AM)
insert into CIVTFA (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '3-PDO-DUE', 1, null, 
       'Esaminati i documenti <PRESA_VISIONE_DOCUMENTI> do'' atto dell''insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_AFFISSIONE_PUB_1> e in <COMUNE_AFFISSIONE_PUB_2>.'||chr(10)||
         'I documenti sono:'||chr(10)||
         'Per lo sposo: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSO> il <DATA_ESTRATTO_SPOSO>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSO> il <DATA_CUMULATIVO_SPOSO>.'||chr(10)||
         'Per la sposa: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSA> il <DATA_ESTRATTO_SPOSA>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSA> il <DATA_CUMULATIVO_SPOSA>.'||chr(10)||
         chr(10)||
         'Detti documenti, muniti del mio visto, inserisco come allegati al presente processo verbale.', 
       ''
  from dual
 where not exists (select 1 from civtfa b
                    where b.formula = '3-PDO-DUE')
;
UPDATE CIVTFA
   SET TESTO_A3 =
       'Esaminati i documenti <PRESA_VISIONE_DOCUMENTI> do'' atto dell''insussistenza di impedimenti alla pubblicazione, che questa, si fara'' in <COMUNE_AFFISSIONE_PUB_1> e in <COMUNE_AFFISSIONE_PUB_2>.'||chr(10)||
         'I documenti sono:'||chr(10)||
         'Per lo sposo: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSO> il <DATA_ESTRATTO_SPOSO>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSO> il <DATA_CUMULATIVO_SPOSO>.'||chr(10)||
         'Per la sposa: l''estratto e la copia integrale dell''atto di nascita rilasciati dal Comune di <COMUNE_ESTRATTO_SPOSA> il <DATA_ESTRATTO_SPOSA>, il certificato contestuale di residenza, cittadinanza, stato libero rilasciato dal Comune di <COMUNE_CUMULATIVO_SPOSA> il <DATA_CUMULATIVO_SPOSA>.'||chr(10)||
         chr(10)||
         'Detti documenti, muniti del mio visto, inserisco come allegati al presente processo verbale.'
 where formula  = '3-PDO-DUE'
   and testo_a3 is null
;
