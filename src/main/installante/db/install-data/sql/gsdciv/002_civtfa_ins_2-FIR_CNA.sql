--liquibase formatted sql
--changeset amonopoli:202305230915_2 runOnChange:true stripComments:false
insert into CIVTFA (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-CNA1', 1, null, 
       'Il Dichiarante F.to: <PATERNITA>'||chr(10)||
         'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||
         'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||
         'L''UFFICIALE DELLO STATO CIVILE ______________________________', 
       'Il Dichiarante F.to: <PATERNITA>'||chr(10)||
         'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||
         'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||
         'L''UFFICIALE DELLO STATO CIVILE ______________________________'
  from dual
 where not exists (select 1 from civtfa b
                    where b.formula = '2-FIR-CNA1')
/
insert into CIVTFA (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-CNA2', 1, null, 
       'I Dichiaranti F.to: <PATERNITA> e <MATERNITA>'||chr(10)||
         'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||
         'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||
         'L''UFFICIALE DELLO STATO CIVILE ______________________________', 
       'I Dichiaranti F.to: <PATERNITA> e <MATERNITA>'||chr(10)||
         'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||
         'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||
         'L''UFFICIALE DELLO STATO CIVILE ______________________________'
  from dual
 where not exists (select 1 from civtfa b
                    where b.formula = '2-FIR-CNA2')
/
insert into CIVTFA (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-CNA4', 1, null, 
       'Il Dichiarante F.to: <DICHIARANTE>'||chr(10)||
         'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||
         'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||
         'L''UFFICIALE DELLO STATO CIVILE ______________________________', 
       'Il Dichiarante F.to: <DICHIARANTE>'||chr(10)||
         'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||
         'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||
         'L''UFFICIALE DELLO STATO CIVILE ______________________________'
  from dual
 where not exists (select 1 from civtfa b
                    where b.formula = '2-FIR-CNA4')
/
insert into CIVTFA (FORMULA, RIGA, TESTO, TESTO_4000, TESTO_A3)
select '2-FIR-CNA3', 1, null, 
       'Il Dichiarante F.to: <MATERNITA>'||chr(10)||
         'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||
         'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||
         'L''UFFICIALE DELLO STATO CIVILE ______________________________', 
       'Il Dichiarante F.to: <MATERNITA>'||chr(10)||
         'Il Direttore Sanitario o suo delegato F.to <UFFICIALE_PROV>'||chr(10)||
         'Dopo di che, ho munito del mio visto ed inserito nel volume degli allegati a questo registro la richiesta di trascrizione e la copia del documento trascritto.'||chr(10)||
         'L''UFFICIALE DELLO STATO CIVILE ______________________________'
  from dual
 where not exists (select 1 from civtfa b
                    where b.formula = '2-FIR-CNA3')
/
