--liquibase formatted sql
--changeset amonopoli:202503251155_3 runOnChange:false stripComments:false
declare
w_aiuti_errore	number;
w_errori	number;

begin
  begin
    select 1 into w_aiuti_errore
      from a_aiuti_errore
     where rownum = 1
    ;
  exception
    when no_data_found then
         w_aiuti_errore := 0;
    when others then
         w_aiuti_errore := -1;
  end;

  if w_aiuti_errore = 0 then
--ALTER TABLE A_AIUTI_ERRORE DISABLE ALL TRIGGERS;
begin
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00001', 'I', 1, 'I dati forniti o comunque presenti sullo schermo identificano un', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00001', 'I', 2, 'elemento nella base informativa non gestito.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00003', 'I', 1, 'Sono presenti codici univoci duplicati nella tabella in gestione.', '1', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00003', 'I', 2, 'Essendo un errore che non si deve mai verificare, consultare l''elenco', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00003', 'I', 3, 'dei dati presenti nella tabella, verificare la duplicazione ed', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00003', 'I', 4, 'informare il responsabile dell''applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00004', 'I', 1, 'La funzione richiesta attraverso l''apposito tasto non e'' disponibile', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00004', 'I', 2, 'nel contesto attuale di elaborazione; la consultazione dell''elenco', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00004', 'I', 3, 'delle funzioni disponibili (richiedere la funzione di Show Keys) in-', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00004', 'I', 4, 'dica le sole funzioni abilitate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00005', 'I', 1, 'Non e'' prevista alcuna documentazione relativamente all''elemento', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00005', 'I', 2, 'richiesto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00006', 'I', 1, 'Non e'' prevista alcuna documentazione relativamente ai livelli di', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00006', 'I', 2, 'documentazione superiori a quello ultimo mostrato.', '1', 51);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00006', 'I', 3, 'I livelli di documentazione sono, partendo dal piu'' basso:', '1', 59);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00006', 'I', 4, '- documentazione a livello di campo dello schermo;', '1', 51);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00006', 'I', 5, '- documentazione a livello di formato video;', '1', 45);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00006', 'I', 6, '- documentazione a livello di scelta di menu''.', '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00007', 'I', 1, 'Durante l''elaborazione ultima effettuata non si sono verificati', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00007', 'I', 2, 'errori.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00008', 'I', 1, 'Per quanto riguarda l''ultima segnalazione rilevata, riguardante un', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00008', 'I', 2, 'errore procedurale o un avvertimento, non sono previste spiegazioni', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00008', 'I', 3, 'aggiuntive.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00009', 'I', 1, 'La procedura non prevede l''utilizzo della barra d''azione nel contesto', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00009', 'I', 2, 'in cui e'' stata effettuata la richiesta.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00010', 'I', 1, 'Durante l''operazione di QUERY, la valorizzazione contemporanea dei', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00010', 'I', 2, 'campi codice e relativa descrizione non e'' consentita; cancellare gli', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00010', 'I', 3, 'elementi di ricerca inseriti in uno dei due campi dello schermo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00011', 'I', 1, 'Non e'' prevista alcuna documentazione a livello di campo in relazione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00011', 'I', 2, 'all''elemento richiesto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00012', 'I', 1, 'Non e'' prevista alcuna documentazione a livello di formato video in', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00012', 'I', 2, 'relazione all''elemento richiesto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00013', 'I', 1, 'Non e'' prevista alcuna documentazione a livello di voce di menu in', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00013', 'I', 2, 'relazione all''elemento richiesto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00014', 'I', 1, 'Il valore digitato non e'' compreso fra i possibili valori validi per', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00014', 'I', 2, 'il campo; se disponibile usare la lista valori ( tasto LIST VALUE )', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00014', 'I', 3, 'od in alternativa l''apposita funzione inserita nella barra d''azione', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00014', 'I', 4, '( tasto ACTION BARR ).', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00015', 'I', 1, 'Si avverte l''operatore che, con riferimento all''elemento in gestione,', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00015', 'I', 2, 'sono presenti descrizioni in altri gruppi linguistici che non', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00015', 'I', 3, 'compaiono direttamente sullo schermo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00016', 'I', 1, 'Per poter operare correttamente la descrizione e'' un dato', '0', 58);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00016', 'I', 2, 'obbligatorio che deve essere presente in almeno una delle versioni', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00016', 'I', 3, 'linguistiche gestite.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00017', 'I', 1, 'La funzione richiesta attraverso l''apposito tasto non e'' disponibile', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00017', 'I', 2, 'nel contesto di elaborazione dell''elemento selezionato; la', '0', 59);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00017', 'I', 3, 'consultazione dell''elenco    delle funzioni disponibili (richiedere', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00017', 'I', 4, 'la funzione di Show Keys) in-  dica le sole funzioni abilitate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00018', 'I', 1, 'Al ritorno dalla barra d''azione il valore riportato da scelte operate', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00018', 'I', 2, 'su altre procedure non puo'' aggiornare il valore presente nel campo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00019', 'I', 1, 'Si avverte l''operatore che quello mostrato e'' l''ultimo elemento della', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00019', 'I', 2, 'lista.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00020', 'I', 1, 'L''operazione di inserimento di un nuovo elemento non e'' consentita.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00021', 'I', 1, 'L''operazione di cancellazione dell''elemento in gestione non e''', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00021', 'I', 2, 'consentita.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00022', 'I', 1, 'L''operazione di variazione dei dati dell''elemento in gestione non e''', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00022', 'I', 2, 'consentita.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00023', 'I', 1, 'Non possono essere effettuati aggiornamenti nel blocco dettagli', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00023', 'I', 2, 'quando mancano i riferimenti al blocco di testata.', '1', 51);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00023', 'I', 3, 'Abbandonare il blocco dettaglio, portarsi nel blocco testata e', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00023', 'I', 4, 'definire prima i dati di questo blocco.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00024', 'I', 1, 'Si avverte l''operatore che quello mostrato e'' il primo elemento della', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00024', 'I', 2, 'lista.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00027', 'I', 1, 'Prima di spostarsi su nuovi elementi bisogna confermare o meno i dati', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00027', 'I', 2, 'presenti nella testata aggiornandoli o rinunciando all''aggiornamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00028', 'I', 1, 'La funzione richiesta non viene abilitata quando la presentazione', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00028', 'I', 2, 'avviene in modalita'' di schermo ridotto; per poterla attivare', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00028', 'I', 3, 'modificare la modalita'' di presentazione ( tasto di RESIZE ) in modo', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00028', 'I', 4, 'da utilizzare tutto lo schermo e poi richiedere la funzione', '0', 60);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00028', 'I', 5, 'desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00030', 'I', 1, 'Si avverte l''operatore che ha richiesto la funzione di Prossimo', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00030', 'I', 2, 'Blocco che il blocco in cui attualmente e'' posizionato il cursore e''', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00030', 'I', 3, 'l''ultimo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00031', 'I', 1, 'Si avverte l''operatore che ha richiesto la funzione di Blocco', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00031', 'I', 2, 'Precedente  che il blocco in cui attualmente e'' posizionato il primo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00032', 'I', 1, 'Si avverte l''operatore che l''elaborazione si e'' conclusa regolarmente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00032', 'I', 2, 'senza errori.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00033', 'I', 1, 'Si avverte l''operatore che in questo momento non e'' possibile', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00033', 'I', 2, 'effettuare alcun tipo di prenotazione per l''elaborazione di procedure', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00033', 'I', 3, 'differite ( non gestite a video ) siano esse produttrici di stampe', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00033', 'I', 4, 'che di aggiornamento.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00033', 'I', 5, 'Contattare l''amministratore del sistema per ulteriori informazioni.', '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00034', 'I', 1, 'La cancellazione dell''elemento in gestione deve essere confermata in', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00034', 'I', 2, 'quanto con tale operazione verranno cancellati anche le occorrenze di', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00034', 'I', 3, 'altre entita'' alla prima collegate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00035', 'I', 1, 'Si avverte l''operatore che l''elaborazione si e'' conclusa regolarmente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00035', 'I', 2, 'ma sono stati rilevati errori non bloccanti che sono stati', '0', 59);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00035', 'I', 3, 'specificati nel rapporto della procedura.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 1, 'Si avverte l''operatore che l''elaborazione si e'' conclusa a causa di', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 2, 'errori bloccanti.', '1', 18);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 3, 'Questi possono essere rilevati nello schermo delle prenotazioni in', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 4, 'coda alla descrizione del testo diagnostico nel campo segnalazione', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 5, 'con la seguente forma:', '1', 23);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 6, '"Rilevati errori bloccanti di tipo sistemistico (nnn) VOCE_MENU step', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 7, 'mm"', '1', 5);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 8, 'dove (nnn) e'' un codice errore interno di ORACLE, VOCE_MENU e'' il', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00036', 'I', 9, 'codice della procedura ed mm e'' il numero del passo interrotto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00037', 'I', 1, 'Si avverte l''operatore che l''elaborazione non si e'' conclusa', '0', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00037', 'I', 2, 'regolarmente a causa di errori bloccanti che sono stati specificati', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00037', 'I', 3, 'nel rapporto della procedura.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00038', 'I', 1, 'L''operazione di ricerca nel blocco in gestione non e'' consentita.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00101', 'I', 1, 'Il codice della classe di stampa non e'' definito.', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00101', 'I', 2, 'Consultare le classi di stampa tramite la lista valori o la barra', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00101', 'I', 3, 'd''azione ed eventualmente inserire la definizione della classe', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00101', 'I', 4, 'desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00102', 'I', 1, 'Il codice della stampante non e'' definito.', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00102', 'I', 2, 'Consultare le stampanti di sistema tramite la lista valori o la barra', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00102', 'I', 3, 'd''azione ed eventualmente inserire la definizione della stampante', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00102', 'I', 4, 'desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00103', 'I', 1, 'I dati di predisposizione della stampante per una certa classe di', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00103', 'I', 2, 'stampa e'' gia'' definito ed identifica un''altra occorrenza.', '1', 59);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00103', 'I', 3, 'Interrogare le occorrenze delle classi abilitate per ogni stampante', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00103', 'I', 4, 'selezionando ed eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00104', 'I', 1, 'Esistono dati di predisposizione delle stampanti relativi', '0', 58);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00104', 'I', 2, 'all''informazione da cancellare.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00104', 'I', 3, 'Consultare la definizione delle predisposizione stampanti ed', '0', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00104', 'I', 4, 'eventualmente modificare o cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00105', 'I', 1, 'Il codice della stampante e'' gia'' definito ed identifica un''altra', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00105', 'I', 2, 'occorrenza.', '1', 12);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00105', 'I', 3, 'Interrogare le occorrenze delle stampanti selezionando ed', '0', 58);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00105', 'I', 4, 'eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00106', 'I', 1, 'Non sono presenti nel sistema stampati catalogate come utilizzo di', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00106', 'I', 2, 'tipo spooler (a disposizione di tutti gli utenti del sistema), ma', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00106', 'I', 3, 'soltanto stampanti di tipo hardcopy utilizzabili solamente dal', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00106', 'I', 4, 'terminale a cui sono collegate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00108', 'I', 1, 'Il codice della classe di stampa e'' gia'' definito ed identifica', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00108', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00108', 'I', 3, 'Interrogare le occorrenze delle classi di stampa selezionando ed', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00108', 'I', 4, 'eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00109', 'I', 1, 'Sono presenti codici univoci duplicati della classe di stampa.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00109', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00109', 'I', 3, 'l''elenco delle classi di stampa per verificare l''integrita'' dei dati', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00109', 'I', 4, 'ed informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00110', 'I', 1, 'Sono presenti codici univoci duplicati delle stampanti.', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00110', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00110', 'I', 3, 'l''elenco dei codici stampante per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00110', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00111', 'I', 1, 'Sono presenti codici univoci duplicati di stampante e classe di', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00111', 'I', 2, 'stampa.', '1', 8);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00111', 'I', 3, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00111', 'I', 4, 'l''elenco delle classi abilitate sulle singole stampanti per', '0', 60);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00111', 'I', 5, 'verificare l''integrita'' dei dati ed informare il responsabile di', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00111', 'I', 6, 'applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00113', 'I', 1, 'Il codice del gruppo di lavoro e'' gia'' definito ed identifica', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00113', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00113', 'I', 3, 'Interrogare le occorrenze dei gruppi di lavoro selezionando ed', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00113', 'I', 4, 'eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00114', 'I', 1, 'Il codice dell''errore e'' gia'' definito ed identifica un''altra', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00114', 'I', 2, 'occorrenza.', '1', 12);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00114', 'I', 3, 'Interrogare le occorrenze dei codici errore selezionando ed', '0', 60);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00114', 'I', 4, 'eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00115', 'I', 1, 'Sono presenti codici univoci duplicati delle voci di menu.', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00115', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00115', 'I', 3, 'l''elenco delle voci per verificare l''integrita'' dei dati ed', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00115', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00117', 'I', 1, 'Il codice della guida orizzontale e'' gia'' definito ed identifica', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00117', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00117', 'I', 3, 'Interrogare le occorrenze delle guide orizzontali selezionando ed', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00117', 'I', 4, 'eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00118', 'I', 1, 'Il codice della guida verticale e'' gia'' definito ed identifica', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00118', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00118', 'I', 3, 'Interrogare le occorrenze delle guide verticali selezionando ed', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00118', 'I', 4, 'eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00119', 'I', 1, 'Sono presenti codici univoci duplicati della guida orizzontale.', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00119', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00119', 'I', 3, 'l''elenco delle guide per verificare l''integrita'' dei dati ed', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00119', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00120', 'I', 1, 'Sono presenti codici univoci duplicati di voce menu'' e numero passo.', '1', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00120', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00120', 'I', 3, 'l''elenco dei passi procedurali per verificare l''integrita'' dei dati', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00120', 'I', 4, 'ed informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00121', 'I', 1, 'Il passo procedurale codice e'' gia'' definito ed identifica un''altra', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00121', 'I', 2, 'occorrenza.', '1', 12);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00121', 'I', 3, 'Interrogare le occorrenze dei passi procedurali selezionando ed', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00121', 'I', 4, 'eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00122', 'I', 1, 'Il codice della stampa non e'' definito.', '0', 60);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00122', 'I', 2, 'Consultare il catalogo delle stampe tramite la lista valori o la', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00122', 'I', 3, 'barra d''azione ed eventualmente inserire la definizione della stampa', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00122', 'I', 4, 'desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00123', 'I', 1, 'Sono presenti codici univoci duplicati di codice stampa.', '1', 57);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00123', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00123', 'I', 3, 'l''elenco dei codici stampa per verificare l''integrita'' dei dati ed', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00123', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00124', 'I', 1, 'Il codice della voce di menu'' utilizzata come voce di riferimento non', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00124', 'I', 2, 'e'' definito.', '1', 13);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00124', 'I', 3, 'Consultare l''elenco delle voci di menu tramite la lista valori o la', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00124', 'I', 4, 'barra d''azione ed eventualmente inserire la definizione della voce', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00124', 'I', 5, 'desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00125', 'I', 1, 'Il codice della voce di menu'' non e'' definito.', '1', 47);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00125', 'I', 2, 'Consultare l''elenco delle voci di menu tramite la lista valori o la', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00125', 'I', 3, 'barra d''azione ed eventualmente inserire la definizione della voce', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00125', 'I', 4, 'desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00126', 'I', 1, 'Il codice identificativo della guida verticale non e'' definito.', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00126', 'I', 2, 'Consultare le guide verticali tramite la lista valori o la barra', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00126', 'I', 3, 'd''azione ed eventualmente inserire la definizione della guida', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00126', 'I', 4, 'desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00127', 'I', 1, 'Sono presenti codici univoci duplicati della guida verticale.', '1', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00127', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00127', 'I', 3, 'l''elenco delle guide verticali per verificare l''integrita'' dei dati', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00127', 'I', 4, 'ed informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00128', 'I', 1, 'Esistono occorrenze di testi di aiuto relative all''informazione da', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00128', 'I', 2, 'cancellare.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00128', 'I', 3, 'Consultare la definizione dei testi di aiuto ed eventualmente', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00128', 'I', 4, 'modificare o cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00129', 'I', 1, 'Sono presenti codici di errore univoci duplicati.', '1', 50);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00129', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00129', 'I', 3, 'l''elenco dei codici errore per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00129', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00130', 'I', 1, 'Sono presenti testi di aiuto con progressivo di riga duplicato.', '1', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00130', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00130', 'I', 3, 'l''elenco dei testi di aiuto per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00130', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00131', 'I', 1, 'Esistono stampe prodotte in altri tempi relative all''informazione da', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00131', 'I', 2, 'cancellare.', '1', 12);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00131', 'I', 3, 'Consultare l''elenco delle stampe ed eventualmente cancellare le', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00131', 'I', 4, 'ricorrenze.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00132', 'I', 1, 'Esistono occorrenze di gruppo di lavoro relativi all''informazione da', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00132', 'I', 2, 'cancellare.', '1', 13);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00132', 'I', 3, 'Consultare la definizione dei gruppi di lavoro ed eventualmente', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00132', 'I', 4, 'modificare o cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00133', 'I', 1, 'Esistono occorrenze di stampe relative all''informazione da', '0', 59);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00133', 'I', 2, 'cancellare.', '1', 13);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00133', 'I', 3, 'Consultare l''elenco delle stampe ed eventualmente cancellare il', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00133', 'I', 4, 'collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00134', 'I', 1, 'Esistono occorrenze di stampe relative al passo procedurale variato.', '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00134', 'I', 2, 'Consultare l''elenco delle stampe ed eventualmente cancellare il', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00134', 'I', 3, 'collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00135', 'I', 1, 'Esistono occorrenze di prenotazioni precedentemente effettuate che', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00135', 'I', 2, 'utilizzano il parametro che si vuole cancellare.', '1', 49);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00135', 'I', 3, 'Consultare l''elenco prenotazioni relative alla voce di menu'' ed', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00135', 'I', 4, 'eventualmente cancellare le prenotazioni che stabiliscono il', '0', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00135', 'I', 5, 'collegamento con i parametri.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00136', 'I', 1, 'Sono presenti codici univoci duplicati nei parametri della voce di', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00136', 'I', 2, 'menu.', '1', 6);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00136', 'I', 3, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00136', 'I', 4, 'l''elenco dei parametri per verificare l''integrita'' dei dati ed', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00136', 'I', 5, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00137', 'I', 1, 'Il codice del parametro e'' gia'' definito per la voce di menu''', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00137', 'I', 2, 'selezionata ed identifica un''altra  occorrenza.', '1', 48);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00137', 'I', 3, 'Interrogare le occorrenze dei paametri selezionando ed eventualmente', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00137', 'I', 4, 'variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00138', 'I', 1, 'Il valore fornito per il parametro supera la lunghezza massima per', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00138', 'I', 2, 'esso consentita.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00139', 'I', 1, 'Si avverte l''operatore che la procedura in oggetto non prevede che', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00139', 'I', 2, 'siano forniti parametri di selezione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00140', 'I', 1, 'Il codice scelto per indicare lo stato della stampa risulta errato.', '1', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00140', 'I', 2, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00140', 'I', 3, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00141', 'I', 1, 'Non e'' possibile effettuare la prenotazione della procedura in', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00141', 'I', 2, 'oggetto perche'' risultano in gia'' prenotata od in fase di', '0', 58);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00141', 'I', 3, 'elaborazione una procedure della stessa area di tipo protetto.', '1', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00141', 'I', 4, 'Bisogna attendere la conclusione della procedura che blocca la', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00141', 'I', 5, 'concomitanza di prenotazione-esecuzione di due procedure protette.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00142', 'I', 1, 'Si avverte l''operatore che i parametri scelti dalla lista delle', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00142', 'I', 2, 'passate prenotazioni della srtessa procedura si riferiscono alla', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00142', 'I', 3, 'prenotazione di cui alla data segnalata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00143', 'I', 1, 'Non possono essere cancellate dall''elenco le prenotazioni che', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00143', 'I', 2, 'risultano gia'' in fase di elaborazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00144', 'I', 1, 'Si avverte l''operatore che sono presenti prenotazioni della stessa', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00144', 'I', 2, 'procedura in attesa di essere elaborate o in elaborazione in questo', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00144', 'I', 3, 'istante.', '1', 9);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00144', 'I', 4, 'Se non strettamente neccessario, sarebbe buona norma verificare la', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00144', 'I', 5, 'lista delle prenotazioni per evitare di effettuare inutili', '0', 59);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00144', 'I', 6, 'elaborazioni duplicate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00145', 'I', 1, 'Si avverte l''operatore che sono ancora presenti stampe del tipo di', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00145', 'I', 2, 'quelle che si vuole creare con la procedura in oggetto.', '1', 56);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00145', 'I', 3, 'Se non strettamente neccessario, sarebbe buona norma cancellare le', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00145', 'I', 4, 'stampe non piu'' attuali od in generale quelle che non servono piu''.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00146', 'I', 1, 'Il valore del parametro e'' un dato obbligatorio per la procedura che', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00146', 'I', 2, 'si vuole eseguire; senza tale valore non potra'' essere effettuata la', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00146', 'I', 3, 'prenotazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00147', 'I', 1, 'Il codice scelto per indicare l''obbligatorieta'' del parametro risulta', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00147', 'I', 2, 'errato.', '1', 8);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00147', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00147', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00148', 'I', 1, 'Il codice identificativo della stampa e'' gia'' definito ed identifica', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00148', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00148', 'I', 3, 'Interrogare le occorrenze dei codici identificativi nel catalogo', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00148', 'I', 4, 'delle stampedei selezionando ed eventualmente correggendo i dati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00149', 'I', 1, 'Il codice scelto per indicare la modalita'' di stampa risulta errato.', '1', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00149', 'I', 2, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00149', 'I', 3, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00150', 'I', 1, 'Il codice scelto per indicare il tipo di controllo verticale', '0', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00150', 'I', 2, 'utilizzato per l''emulazione risulta errato.', '1', 44);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00150', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00150', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00151', 'I', 1, 'Il codice identificativo del testo di aiuto e'' gia'' definito ed', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00151', 'I', 2, 'identifica un''altra  occorrenza.', '1', 33);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00151', 'I', 3, 'Interrogare le occorrenze dei codici identificativi dei testi di', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00151', 'I', 4, 'aiuto selezionando ed eventualmente correggendo i dati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00152', 'I', 1, 'Per i tipi oggetto ''F'' (Forms) ed ''M'' (Menu'') i campi modulo e blocco', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00152', 'I', 2, 'devono valere obbligatoriamente ''*''.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00153', 'I', 1, 'Per i tipi oggetto ''A'' (Forms) ed ''C'' (Menu'') il valore dei campi', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00153', 'I', 2, 'modulo e blocco deve obbligatoriamente essere diveso da ''*''.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00154', 'I', 1, 'Il codice scelto per indicare lo stato in cui si trova lo', '0', 58);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00154', 'I', 2, 'schedulatore risulta errato.', '1', 29);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00154', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00154', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00155', 'I', 1, 'Il codice scelto per indicare l''abilitazione alle prenotazioni delle', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00155', 'I', 2, 'procedure differite nel sistema risulta errato.', '1', 48);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00155', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00155', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00156', 'I', 1, 'La stampa non puo'' essere cancellata in quanto di proprieta'' di un', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00156', 'I', 2, 'altro utente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00157', 'I', 1, 'Le caratteristiche della stampa non consentono la sua riproduzione', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00157', 'I', 2, 'sulla stampante associata.', '1', 28);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00157', 'I', 3, 'Informare l''amministratore del sistema per verificare l''effettiva', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00157', 'I', 4, 'incompatibilita'' o la mancanza predisposizione della stampante.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00158', 'I', 1, 'Non e'' possibile modificare il codice presente in archivio con il', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00158', 'I', 2, 'codice scelto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00159', 'I', 1, 'Il codice scelto per indicare il formato del parametro risulta', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00159', 'I', 2, 'errato.', '1', 8);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00159', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00159', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00160', 'I', 1, 'Per i parametri di tipo data, il valore fornito deve essere lungo 10', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00160', 'I', 2, 'caratteri nella forms GG/MM/YYYY.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00161', 'I', 1, 'Il codice scelto per indicare il tipo oggetto da documetare risulta', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00161', 'I', 2, 'errato.', '1', 8);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00161', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00161', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00162', 'I', 1, 'I testi di aiuto relativi al tipo oggetto ''M'' (Menu) devono riferirsi', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00162', 'I', 2, 'ad una voce di menu'' gia'' catalogata.', '1', 38);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00162', 'I', 3, 'Inserire la nuova voce e quindi il relativo testo di aiuto.', '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00163', 'I', 1, 'La voce di riferimento serve ad abilitare l''uso della guida quando', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00163', 'I', 2, 'non si e'' abilitati alla voce di menu''; non puo'' quindi essere', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00163', 'I', 3, 'presente quando la voce di menu'' e'' assente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00164', 'I', 1, 'Nella definizione della guida orizzontale si puo'' citare in', '0', 60);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00164', 'I', 2, 'alternativa o la voce di menu'' da richiamare o l''identificativo della', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00164', 'I', 3, 'guida verticale a cui e'' demandata l''ulteriore scelta.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00165', 'I', 1, 'Nella definizione della guida orizzontale deve essere indicata o la', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00165', 'I', 2, 'voce di menu'' da richiamare o l''identificativo della guida verticale', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00165', 'I', 3, 'a cui e'' demandata l''ulteriore scelta.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00166', 'I', 1, 'Il codice scelto per indicare il tipo di formato del parametro', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00166', 'I', 2, 'risulta errato.', '1', 16);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00166', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00166', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00167', 'I', 1, 'La gestione dei passi procedurali e delle selezioni di procedura deve', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00167', 'I', 2, 'essere effettuata solamente sulle voci di menu'' che sono state', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00167', 'I', 3, 'dichiarate di tipo differito.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00168', 'I', 1, 'Si avverte l''operatore che attualmente non e'' associata al terminale', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00168', 'I', 2, 'nessuna stampante.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00169', 'I', 1, 'Non e'' possibile effettuare la cancellazione della prenotazione', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00169', 'I', 2, 'poiche'' sono ancora presenti stampe prodotte nella procedura che ha', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00169', 'I', 3, 'quel numero di prenotazione.', '1', 29);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00169', 'I', 4, 'Utilizzare la procedura di gestione delle stampe per cancellare', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00169', 'I', 5, 'prioritariamente le stampe prodotte.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00170', 'I', 1, 'Si avverte l''operatore che con l''elaborazione appena conclusa e''', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00170', 'I', 2, 'stata associata la stampante di cui in coda al messaggio.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00171', 'I', 1, 'Si avverte l''operatore che con l''operazione di interruzione stampante', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00171', 'I', 2, 'appena conclusa ha interrotto l''emissione di tutte le stampe in coda', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00171', 'I', 3, 'su di essa.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00172', 'I', 1, 'Nella riproduzione parziale di una stampa da pagina a pagina il', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00172', 'I', 2, 'numero della pagina finale non puo'' essere maggiore del numero di', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00172', 'I', 3, 'pagine totali della stampa.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00173', 'I', 1, 'Nella riproduzione parziale di una stampa da pagina a pagina il', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00173', 'I', 2, 'numero della pagina finale deve essere maggiore o eguale al numero', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00173', 'I', 3, 'della pagina iniziale.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00174', 'I', 1, 'Non sono disponibili dati relativi a precedenti prenotazioni della', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00174', 'I', 2, 'voce di menu''.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00175', 'I', 1, 'Non e'' possibile effettuare la prenotazione della procedura in', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00175', 'I', 2, 'oggetto perche'' risultano ancora presenti stampe protette che la', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00175', 'I', 3, 'procedura in oggetto andrebbe a duplicare.', '1', 43);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00175', 'I', 4, 'Bisogna effettuare la cancellazione delle stampe prima di procedere', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00175', 'I', 5, 'alla prenotazione delle procedura in oggetto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00176', 'I', 1, 'Sono presenti codici univoci duplicati di modalita'' di stampa.', '1', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00176', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00176', 'I', 3, 'l''elenco dei modi stampa per verificare l''integrita'' dei dati ed', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00176', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00177', 'I', 1, 'Il codice della modalita'' di stampa e'' gia'' definito ed identifica', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00177', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00177', 'I', 3, 'Interrogare le occorrenze delle modalita'' di stampa selezionando ed', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00177', 'I', 4, 'eventualmente correggendo il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00179', 'I', 1, 'Il codice modalita'' di stampa e'' gia'' definito ed identifica un''altra', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00179', 'I', 2, 'occorrenza.', '1', 12);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00179', 'I', 3, 'Interrogare le modalita'' di stampa sselezionando ed eventualmente', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00179', 'I', 4, 'correggendo le occorrenze desiderate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00180', 'I', 1, 'Il codice scelto per indicare la modalita'' di schedulazione da', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00180', 'I', 2, 'attivare nel sistema risulta errato.', '1', 37);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00180', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00180', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00183', 'I', 1, 'Il codice scelto per indicare il tipo di utilizzo della stampante', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00183', 'I', 2, 'risulta errato.', '1', 16);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00183', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00183', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00184', 'I', 1, 'Esistono definizioni di competenza sull''oggetto da cancellare.', '1', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00184', 'I', 2, 'Consultare la definizione delle competenze ed eventualmente', '0', 60);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00184', 'I', 3, 'modificare o cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00185', 'I', 1, 'Sono presenti codici univoci duplicati negli oggetti.', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00185', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00185', 'I', 3, 'l''elenco degli oggetti per verificare l''integrita'' dei dati ed', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00185', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00186', 'I', 1, 'Il codice della oggetto e'' gia'' definito ed identifica un''altra', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00186', 'I', 2, 'occorrenza.', '1', 12);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00186', 'I', 3, 'Interrogare le occorrenze degli oggetti selezionando ed eventualmente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00186', 'I', 4, 'variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00187', 'I', 1, 'Il codice del''istanza e'' gia'' definito ed identifica un''altra', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00187', 'I', 2, 'occorrenza.', '1', 12);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00187', 'I', 3, 'Interrogare le occorrenze delle istanze selezionando ed eventualmente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00187', 'I', 4, 'variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00189', 'I', 1, 'Il codice di competenza sull''oggetto e'' gia'' definito ed identifica', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00189', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00189', 'I', 3, 'Interrogare le occorrenze selezionando ed eventualmente variando il', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00189', 'I', 4, 'codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00192', 'I', 1, 'Il codice della funzione chiamata e'' gia'' definito ed identifica', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00192', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00192', 'I', 3, 'Interrogare le occorrenze delle funzioni selezionando ed', '0', 57);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00192', 'I', 4, 'eventualmente variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00196', 'I', 1, 'La definizione del margine per stampa e stampante e'' gia'' definito ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00196', 'I', 2, 'identifica un''altra  occorrenza.', '1', 33);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00196', 'I', 3, 'Interrogare le occorrenze selezionando ed eventualmente variando il', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00196', 'I', 4, 'codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00197', 'I', 1, 'Nella definizone dei singoli passi procedurali, per il tipo di', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00197', 'I', 2, 'interfaccia ''C'' si deve definire nel campo stringa il comando da', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00197', 'I', 3, 'eseguire; per tutti gli altri tipi il campo modulo deve contenere', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00197', 'I', 4, 'l''indicazione della procedura da eseguire.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00198', 'I', 1, 'Esistono definizioni di emulazione che utilizzano il modo stampa da', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00198', 'I', 2, 'cancellare.', '1', 13);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00198', 'I', 3, 'Consultare la definizione delle emulazioni stampante ed eventualmente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00198', 'I', 4, 'cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00200', 'I', 1, 'Il codice della modalita'' di stampa non e'' definito.', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00200', 'I', 2, 'Consultare le modalita'' di stampa tramite la lista valori e scegliere', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00200', 'I', 3, 'fra le modalita'' presenti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00201', 'I', 1, 'Sono presenti codici univoci duplicati di emulazionene.', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00201', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00201', 'I', 3, 'l''elenco delle emulazioni per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00201', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00203', 'I', 1, 'Il codice emulazione non e'' definito.', '1', 38);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00203', 'I', 2, 'Consultare i codici di emulazione tramite la lista valori o la barra', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00203', 'I', 3, 'd''azione ed eventualmente inserire la definizione dell''emulazione', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00203', 'I', 4, 'desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00205', 'I', 1, 'Per tale prenotazione la procedura e'' stata richiesta senza fornire', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00205', 'I', 2, 'alcun valore per i parametri di selezione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00206', 'I', 1, 'Il messaggio avverte solamente che la procedura non ha prodotto', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00206', 'I', 2, 'durante la sua elaborazione alcuna stampa; la situazione puo''', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00206', 'I', 3, 'verificarsi perche'' l''elaborazione, in base ai parametri forniti, non', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00206', 'I', 4, 'ha trovato nulla da stampare o perche la stessa procedura non prevede', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00206', 'I', 5, 'la produzione di stampe.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00207', 'I', 1, 'Esistono stampanti che utilizzano l''informazione che si vuole', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00207', 'I', 2, 'cancellare.', '1', 12);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00207', 'I', 3, 'Consultare la definizione delle stampanti ed eventualmente modificare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00207', 'I', 4, 'o cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00208', 'I', 1, 'Sono presenti regioni con codice duplicato.', '1', 44);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00208', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00208', 'I', 3, 'l''elenco delle regioni per verificare l''integrita'' dei dati ed', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00208', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00209', 'I', 1, 'Il codice identificativo della regione e'' gia'' definito ed identifica', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00209', 'I', 2, 'un''altra  occorrenza.', '1', 22);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00209', 'I', 3, 'Interrogare le occorrenze dei codici identificativi delle regioni', '1', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00209', 'I', 4, 'selezionando ed eventualmente correggendo i dati.', '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00210', 'I', 1, 'Sono presenti provincie con codice duplicato.', '1', 46);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00210', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00210', 'I', 3, 'l''elenco delle provincie per verificare l''integrita'' dei dati ed', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00210', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00211', 'I', 1, 'Il codice identificativo della provincia e'' gia'' definito ed', '0', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00211', 'I', 2, 'identifica un''altra  occorrenza.', '1', 33);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00211', 'I', 3, 'Interrogare le occorrenze dei codici identificativi delle provincie', '1', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00211', 'I', 4, 'selezionando ed eventualmente correggendo i dati.', '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00212', 'I', 1, 'Il codice regione non e'' definito.', '1', 35);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00212', 'I', 2, 'Consultare i codici regione tramite la lista valori o la barra', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00212', 'I', 3, 'd''azione ed eventualmente inserire la regione desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00213', 'I', 1, 'Sono presenti raggruppamenti stati con codice duplicato.', '1', 57);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00213', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00213', 'I', 3, 'l''elenco dei raggruppamenti stati per verificare l''integrita'' dei', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00213', 'I', 4, 'dati ed informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00214', 'I', 1, 'Sono presenti stati/territori con codice duplicato.', '1', 52);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00214', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00214', 'I', 3, 'l''elenco dei stati/territori per verificare l''integrita'' dei dati ed', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00214', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00215', 'I', 1, 'Sono presenti stati/territori con codice duplicato.', '1', 52);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00215', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00215', 'I', 3, 'l''elenco dei stati/territori per verificare l''integrita'' dei dati ed', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00215', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00216', 'I', 1, 'Il codice stato/territorio non e'' definito.', '1', 44);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00216', 'I', 2, 'Consultare i codici regione tramite la lista valori o la barra', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00216', 'I', 3, 'd''azione ed eventualmente inserire lo stato/territorio desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00217', 'I', 1, 'Il codice raggruppamento stato non e'' definito.', '1', 48);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00217', 'I', 2, 'Consultare i codici regione tramite la lista valori o la barra', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00217', 'I', 3, 'd''azione ed eventualmente inserire i raggruppamento desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00218', 'I', 1, 'Il codice identificativo dello stato/territorio e'' gia'' definito ed', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00218', 'I', 2, 'identifica un''altra occorrenza.', '1', 32);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00218', 'I', 3, 'Interrogare le occorrenze dei codici identificativi degli', '0', 58);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00218', 'I', 4, 'stati/territori selezionando ed eventualmente correggendo i dati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00219', 'I', 1, 'Sono presenti tipi consolato con codice duplicato.', '1', 51);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00219', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00219', 'I', 3, 'l''elenco dei tipi consolato per verificare l''integrita'' dei dati ed', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00219', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00220', 'I', 1, 'Il codice identificativo del tipo consolato e'' gia'' definito ed', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00220', 'I', 2, 'identifica un''altra occorrenza.', '1', 32);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00220', 'I', 3, 'Interrogare le occorrenze dei codici identificativi dei tipi', '0', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00220', 'I', 4, 'consolato selezionando ed eventualmente correggendo i dati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00221', 'I', 1, 'Sono presenti consolati con codice duplicato.', '1', 46);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00221', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00221', 'I', 3, 'l''elenco dei consolati per verificare l''integrita'' dei dati ed', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00221', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00222', 'I', 1, 'Il codice tipo consolato non e'' definito.', '1', 42);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00222', 'I', 2, 'Consultare i codici regione tramite la lista valori o la barra', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00222', 'I', 3, 'd''azione ed eventualmente inserire il tipo consolato desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00223', 'I', 1, 'Sono presenti comuni con codice duplicato.', '1', 43);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00223', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00223', 'I', 3, 'l''elenco dei comuni per verificare l''integrita'' dei dati ed informare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00223', 'I', 4, 'il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00224', 'I', 1, 'Il codice identificativo del comune e'' gia'' definito ed identifica', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00224', 'I', 2, 'un''altra occorrenza.', '1', 21);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00224', 'I', 3, 'Interrogare le occorrenze dei codici identificativi dei comuni', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00224', 'I', 4, 'selezionando ed eventualmente correggendo i dati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00225', 'I', 1, 'Il codice provincia non e'' definito.', '1', 37);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00225', 'I', 2, 'Consultare le provincie tramite la lista valori o la barra d''azione', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00225', 'I', 3, 'ed eventualmente inserire la provincia desiderata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00226', 'I', 1, 'Il codice comune non e'' definito.', '1', 34);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00226', 'I', 2, 'Consultare i codici comune tramite la lista valori o la barra', '0', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00226', 'I', 3, 'd''azione ed eventualmente inserire il comune desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00227', 'I', 1, 'Il codice consolato non e'' definito.', '1', 37);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00227', 'I', 2, 'Consultare i codici consolato tramite la lista valori o la barra', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00227', 'I', 3, 'd''azione ed eventualmente inserire il consolato desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00228', 'I', 1, 'Lo stato/territorio non e'' definito.', '1', 37);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00228', 'I', 2, 'Consultare i codici stato/territorio tramite la lista valori o la', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00228', 'I', 3, 'barra d''azione ed eventualmente inserire lo stato/territorio', '0', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00228', 'I', 4, 'desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00229', 'I', 1, 'E'' gia'' identificata un''altra occorrenza con lo stesso codice comune', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00229', 'I', 2, 'e la stessa data di validita''.', '1', 31);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00229', 'I', 3, NULL, '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00230', 'I', 1, 'Il codice scelto per indicare il parametro risulta errato.', '1', 59);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00230', 'I', 2, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00230', 'I', 3, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00231', 'I', 1, 'Sono presenti codici univoci duplicati dei parametri relativi alla', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00231', 'I', 2, 'voce di menu''.', '1', 15);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00231', 'I', 3, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00231', 'I', 4, 'l''elenco dei parametri per verificare l''integrita'' dei dati ed', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00231', 'I', 5, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00232', 'I', 1, 'Il codice scelto per indicare l''operatore risulta errato.', '1', 58);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00232', 'I', 2, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00232', 'I', 3, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00233', 'I', 1, 'Il codice scelto per indicare il tipo valore risulta errato.', '1', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00233', 'I', 2, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00233', 'I', 3, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00300', 'I', 1, 'Sono presenti codici univoci duplicati dei campi della vista.', '1', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00300', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00300', 'I', 3, 'l''elenco dei campi per la vista in questione per verificare', '0', 60);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00300', 'I', 4, 'l''integrita'' dei dati ed informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00301', 'I', 1, 'Sono presenti codici univoci duplicati della vista.', '1', 52);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00301', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00301', 'I', 3, 'l''elenco delle viste per verificare l''integrita'' dei dati ed', '0', 61);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00301', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00302', 'I', 1, 'Sono presenti codici univoci duplicati di elenco parametrico.', '1', 62);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00302', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00302', 'I', 3, 'l''elenco degli elenchi per verificare l''integrita'' dei dati ed', '0', 63);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00302', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00303', 'I', 1, 'Si possono definire come campi di rottura per raggruppamento solo le', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00303', 'I', 2, 'prime colonne dell''elenco a video.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00304', 'I', 1, 'Informa si e'' superato il numero di caratteri utili per la stampa di', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00304', 'I', 2, 'una riga. Quindi ogni elemento dell''elenco verra'' stampato su piu''', '0', 67);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00304', 'I', 3, 'righe.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00305', 'I', 1, 'E'' obbligatorio definire almeno una colonna per l''elenco.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00306', 'I', 1, 'La vista non e'' definito.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00307', 'I', 1, 'La colonna e'' gia'' definito ed identifica un''altra  occorrenza.', '1', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00307', 'I', 2, 'Interrogare le occorrenze delle colonne selezionando ed eventualmente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00307', 'I', 3, 'variando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00308', 'I', 1, 'E'' obbligatorio selezionare un elenco prima di passare al blocco', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00308', 'I', 2, 'successivo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00309', 'I', 1, 'Il campo della vista non e'' definito.', '1', 38);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00309', 'I', 2, NULL, '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00310', 'I', 1, 'Il codice scelto per indicare la posizione di stampa del testo nella', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00310', 'I', 2, 'riga risulta errato.', '1', 21);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00310', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00310', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00311', 'I', 1, 'Il codice scelto per indicare il numero di righe o la pagina da', '0', 64);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00311', 'I', 2, 'saltare prima della stampa di un nuovo raggruppamento risulta errato.', '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00311', 'I', 3, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00311', 'I', 4, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00312', 'I', 1, 'Il codice scelto per indicare il tipo di ordinamento risulta errato.', '1', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00312', 'I', 2, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00312', 'I', 3, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00314', 'I', 1, 'Sono presenti codici univoci duplicati dei parametri di selezione', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00314', 'I', 2, 'associati alla vista in questione.', '1', 35);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00314', 'I', 3, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00314', 'I', 4, 'l''elenco dei parametri per la vista per verificare l''integrita'' dei', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00314', 'I', 5, 'dati ed informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00315', 'I', 1, 'Il formato del valore risulta errato.', '1', 38);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00315', 'I', 2, 'Il formato corretto e'':', '1', 24);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00315', 'I', 3, '    1o estremo and 2o estremo        oppure', '1', 45);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00315', 'I', 4, '    1o estremo AND 2o estremo', '1', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00316', 'I', 1, 'Il codice scelto per indicare l''operatore logico risulta errato.', '1', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00316', 'I', 2, 'Utilizzare la funzione di Lista Valori per avere l''elenco dei codici', '0', 69);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00316', 'I', 3, 'consentiti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00338', 'I', 1, 'Il codice voce di menu'' e modulo segnalati rappresentano una', '0', 60);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A00338', 'I', 2, 'personalizzazione gia'' esistente, verificare i dati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05500', 'I', 1, 'Il valore del gruppo linguistico non e'' stato inserito', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05500', 'I', 10, 'correttamente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05500', 'I', 20, 'Utilizzare il Tasto lista Valori per elenco valori validi.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05501', 'I', 1, 'I valori previsti per abilitazione password sono', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05501', 'I', 2, '   S = abilitato al cambio password.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05501', 'I', 3, '   N = non abilitato al cambio password.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05502', 'I', 1, 'I valori validi per la statistica accessi sono :', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05502', 'I', 2, 'S = Sono registrati tutti gli accessi ai nodi ed alle foglie', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05502', 'I', 3, '    del menu dell''applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05502', 'I', 4, 'N = E'' registrato solamente il primo accesso al menu.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05710', 'I', 1, 'Per i parametri definiti non direttamente introducibili', '0', 56);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05710', 'I', 2, 'dall''operatore, il valore di default e'' obbligatorio.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05711', 'I', 1, 'La barra d''azione non puo'' essere richiamata per le selezioni di', '0', 65);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05711', 'I', 2, 'formato ''F'' dove e'' presente il valore di default e questo non e''', '0', 66);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A05711', 'I', 3, 'gestibile direttamente dall''utente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06010', 'I', 1, 'Il codice digitato non e'' relativo ad alcun gruppo di lavoro.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06010', 'I', 2, 'Interrogare i gruppi utilizzando la lista valori o il menu a barre', '0', 68);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06010', 'I', 3, 'ed eventualmente inserire l''occorrenza con il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06016', 'I', 10, 'Il codice del gruppo di lavoro e'' gia'' stato utilizzato per', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06016', 'I', 20, 'identificare un''altra occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06016', 'I', 30, 'Interrogare le occorrenze dei gruppi di lavoro selezionando il codice', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06016', 'I', 40, 'desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06017', 'I', 1, 'Sono presenti codici univoci duplicati nei gruppi di lavoro.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06017', 'I', 2, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06017', 'I', 3, 'l''elenco gruppi di lavoro per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06017', 'I', 4, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06020', 'I', 1, 'Il codice digitato non e'' relativo ad alcun utente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06020', 'I', 2, 'Interrogare gli utenti utilizzando la lista valori o il menu a barre', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06020', 'I', 3, 'ed eventualmente inserire l''occorrenza con il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06021', 'I', 10, 'Non e'' permesso modificare la password corrente dell''utente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06021', 'I', 20, 'con una password uguale.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06021', 'I', 30, 'Modificare con un altro valore la password o non modificarla', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06021', 'I', 40, 'affatto tenendo la corrente come password valida.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06022', 'I', 10, 'La password inserira non e'' corretta o non e'' relativa', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06022', 'I', 20, 'all''utente specificato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06022', 'I', 30, 'Provare ad inserire un ulteriore password per prevenire errori di', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06022', 'I', 40, 'battitura, nel caso l''errore di ripetesse informare l''amministratore', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06022', 'I', 50, 'di sistema.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06023', 'I', 10, 'La password inserita e'' valida ma e'' terminato il tempo di utilizzo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06023', 'I', 20, 'Chiedere all''amministratore di sistema un''altro valore valido', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06023', 'I', 30, 'di password o la conferma della precedente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06024', 'I', 10, 'L''utente utilizzato e'' disabilitato in quanto, sbagliando la password,', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06024', 'I', 20, 'sono stati gia'' eseguiti piu'' di cinque tentativi falliti.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06024', 'I', 30, 'Informare l''amministratore di sistema di azzerare i tentativi', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06024', 'I', 40, 'dell''utente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06025', 'I', 10, 'La password digitata e'' valida ma scadra'' tra poco.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06025', 'I', 20, 'Verificare la data di scadenza o modificare la password con il cambio', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06025', 'I', 30, 'password.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06026', 'I', 1, 'Il codice dell''utente e'' gia'' definito ed identifica un''altra', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06026', 'I', 2, 'occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06026', 'I', 3, 'Interrogare tutti gli utenti selezionando ed eventualmente', '0', 59);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06026', 'I', 4, 'correggendole occorrenze desiderate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06027', 'I', 10, 'Sono presenti codici univoci duplicati di utente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06027', 'I', 20, 'Essendo un errore che non si deve mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06027', 'I', 30, 'l''elenco utenti verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06027', 'I', 40, 'informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06028', 'I', 1, 'Esistono occorrenze di utente relative all''informazione da', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06028', 'I', 2, 'cancellare.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06028', 'I', 3, 'Consultare la definizione utenti ed eventualmente modificare o', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06028', 'I', 13, 'cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06030', 'I', 1, 'L''utente con cui ci si e'' collegati non e'' abilitato all''operazione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06030', 'I', 11, 'prescelta.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06030', 'I', 21, 'Collegarsi con un altro utente o chiedere all''amministratore di', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06030', 'I', 31, 'sistema l''autorizzazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06036', 'I', 10, 'Le chiavi che identificano i diritti di accesso sono gia'' stati', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06036', 'I', 20, 'utilizzati per un''altra occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06036', 'I', 30, 'Interrogare l''elenco diritti di accesso.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06040', 'I', 10, 'Non e'' stato inserito come istanza di ambiente, l''ente il gruppo', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06040', 'I', 20, 'linguistico e l''ambiente digitati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06040', 'I', 30, 'Consultare la definizione ambiente e le sue istanze utilizzando il', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06040', 'I', 40, 'menu a barre o la lista valori, eventualmente inserirle.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06046', 'I', 10, 'L''istanza di ambiente composta da ambiente-ente-gruppo linguistico', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06046', 'I', 20, 'identifica gia'' un''altra occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06046', 'I', 30, 'Interrogare tutte le istanze di ambiente verificando i dati del', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06046', 'I', 40, 'codice istanza desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06047', 'I', 10, 'Sono presenti codici univoci duplicati di istanze di ambiente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06047', 'I', 20, 'Essendo un errore che non si deve mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06047', 'I', 30, 'la definizione istanze di ambiente, verificare l''integrita'' dei dati', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06047', 'I', 40, 'ed informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06048', 'I', 10, 'Esistono occorrenze di Istanze di ambiente relative al dato da', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06048', 'I', 20, 'cancellare.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06048', 'I', 30, 'Consultare la definizione ambiente e relative istanze di ambiente,', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06048', 'I', 40, 'utilizzando la barra di azione ed eventualmente cancellare il dato', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06048', 'I', 50, 'o il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06050', 'I', 10, 'Il codice ruolo digitato non e'' presente nelle occorrenze di ruolo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06050', 'I', 30, 'Consultare la lista valori o, tramite la barra di azione, la', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06050', 'I', 40, 'definizione ruoli ed eventualmente scegliere o inserire il codice', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06050', 'I', 50, 'desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06056', 'I', 10, 'Il codice del ruolo e'' gia'' definito ed identifica un''altra', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06056', 'I', 20, 'occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06056', 'I', 30, 'Interrogare i ruoli selezionando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06057', 'I', 10, 'Sono presenti codici univoci duplicati del ruolo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06057', 'I', 20, 'Essendo un errore che non si deve mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06057', 'I', 30, 'la definizione ruoli per verificare l''integrita'' dei dati', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06057', 'I', 40, 'ed informare il responsabile di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06061', 'I', 1, 'Il codice ambiente digitato e'' presente nella definizione ambienti', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06061', 'I', 11, 'ma non e'' relativo all''applicazione richiesta.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06061', 'I', 21, 'Verificare la definizione ambienti tramite barra di azione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06066', 'I', 10, 'Il codice dell''applicazione e'' gia'' stata utilizzata ed identifica', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06066', 'I', 20, 'un''altra occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06066', 'I', 30, 'Interrogare le applicazioni selezionando il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06067', 'I', 10, 'Sono presenti codici univoci duplicati di applicazione.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06067', 'I', 20, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06067', 'I', 30, 'la definizione applicazione per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06067', 'I', 40, 'informare il responsabile di sistema.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06068', 'I', 10, 'Non e'' possibile cancellare questa occorrenza in quanto esistono delle', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06068', 'I', 20, 'applicazioni collegate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06068', 'I', 30, 'Consultare, anche tramite barra di azione, la definizione applicazioni', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06068', 'I', 40, 'ed eventualmente modificare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06080', 'I', 10, 'Il codice di ambiente non e'' stato inserito nella definizione ambienti', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06080', 'I', 30, 'Consultare la lista valori o, tramite la barra di azione, la', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06080', 'I', 40, 'definizione ambienti e scegliere o eventualmente inserire il dato', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06080', 'I', 50, 'desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06086', 'I', 10, 'Il codice dell''ambiente e'' gia'' stata utilizzato ed identifica', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06086', 'I', 20, 'un''altra occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06086', 'I', 30, 'Interrogare, con il codice desiderato, le occorrenze di ambiente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06087', 'I', 10, 'Sono presenti codici, univoci, di ambiente duplicati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06087', 'I', 20, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06087', 'I', 30, 'la definizione ambiente per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06087', 'I', 40, 'informare il responsabile di sistema.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06095', 'I', 10, 'L''acronimo digitato non e'' presente o non appartiene all''applicazione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06095', 'I', 20, 'corrente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06095', 'I', 30, 'Consultare l''albero del menu, eventualmente verificare se l''acronimo', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06095', 'I', 40, 'e'' presente ma non e'' abilitato l''accesso all''utente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06096', 'I', 10, 'Il codice per identificare un''informazione di voce di menu'' e'' gia''', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06096', 'I', 20, 'stato utilizzato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06096', 'I', 30, 'Interrogare l''occorrenza relativa al codice desiderato o modificare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06096', 'I', 40, 'il codice digitato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06097', 'I', 10, 'Sono presenti codici, univoci, di voci di menu duplicati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06097', 'I', 20, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06097', 'I', 30, 'l''elenco voci di menu per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06097', 'I', 40, 'informare il responsabile di sistema.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06098', 'I', 10, 'Collegati all''occorrenza che si vuola cancellare ci sono delle voci', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06098', 'I', 20, 'di menu.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06098', 'I', 30, 'Consultare, anche tramite barra di azione, la definizione voci di menu', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06098', 'I', 40, 'ed eventualmente modificarle o cancellarle.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06106', 'I', 10, 'Il percorso di menu che si vuole definire e'' gia'' stato costrito.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06106', 'I', 20, 'Consultare l''albero del menu ed eventualmente richiedere informazioni', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06106', 'I', 30, 'al responsabile di sistema.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06107', 'I', 10, 'Sono presenti codici registrazioni di menu duplicate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06107', 'I', 20, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06107', 'I', 30, 'la definizione del menu per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06107', 'I', 40, 'informare il responsabile di sistema.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06108', 'I', 10, 'Non e'' possibile cancellare l''occorrenza desiderata in quanto esiste', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06108', 'I', 20, 'un collegamento con il menu.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06108', 'I', 30, 'Consultare, anche tramite barra di azione, l''albero del menu ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06108', 'I', 40, 'eventualmente modificarlo o cancellarlo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06109', 'I', 10, 'Non e'' possibile cancellare questa occorrenza di menu in quanto', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06109', 'I', 20, 'sono presenti delle abilitazioni di ruolo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06109', 'I', 30, 'Verificare i ruoli abilitati utilizzando il tasto di prossimo blocco', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06109', 'I', 40, 'ed eventualmente eliminarli.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06110', 'I', 10, 'Non e'' previsto, per l''occorrenza, un numero identificativo di padre.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06110', 'I', 30, 'Verificare l''albero del menu e l''integrita'' dei dati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06112', 'I', 10, 'Non e'' possibile cancellare l''occorrenza di ramo o nodo in quanto', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06112', 'I', 20, 'esistono delle foglie o figli associati.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06112', 'I', 30, 'Verificare l''albero del menu ed eventualmente cancellare le foglie.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06120', 'I', 10, 'L''ente digitato non e'' presente come codice nella definizione ente.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06120', 'I', 40, 'Consultare l''elenco enti tramite la lista valori o il menu a barre,', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06120', 'I', 50, 'eventualmente inserire il codice desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06126', 'I', 10, 'Il codice ente e'' gia'' stato utilizzato per identificare un''altra', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06126', 'I', 20, 'occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06126', 'I', 30, 'Interrogare gli enti o eventualmente modificare il codice digitato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06127', 'I', 10, 'Sono presenti codici registrazioni di enti duplicate.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06127', 'I', 20, 'Essendo un errore che non si dovrebbe mai verificare consultare', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06127', 'I', 30, 'la definizione dell''ente per verificare l''integrita'' dei dati ed', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06127', 'I', 40, 'informare il responsabile di sistema.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06128', 'I', 10, 'Esistono degli enti collegati all''occorrenza che si vuole', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06128', 'I', 20, 'cancellare.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06128', 'I', 30, 'Consultare, anche tramite barra di azione, la definizione enti', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06128', 'I', 40, 'ed eventualmente modificare o cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 1, 'Il TIPO VOCE puo'' assumere i valori :', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 11, '     N = Nodo', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 21, '     F = Foglia', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 31, '     A = Altro', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 32, NULL, '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 41, 'Il TIPO INTERFACCIA assume i valori :', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 51, '     M = menu', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 61, '   F-Q = Forms', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 71, '   H-S = Host', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 81, '     D = Differita', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 91, NULL, '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 101, 'Sono ammessi i seguenti valori di congruenza tra tipo voce e tipo', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 111, 'interfaccia :', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 121, '     Tipo Voce                 Tipo Interfaccia', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 131, '     N (Nodo)                       M (Menu)', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 141, '     F (Foglia)                     F-Q, H-S, D', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06291', 'I', 151, '     A (Altro)                      F-Q', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06292', 'I', 10, 'Se il tipo voce assume il valore di N come nodo, obbligatoriamente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06292', 'I', 20, 'il tipo interfaccia deve essere definito M come Menu.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06292', 'I', 30, 'Occorre modificare il tipo voce o il tipo interfaccia secondo le', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06292', 'I', 40, 'esigenze.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06293', 'I', 10, 'Il codice di tipo interfaccia non e'' previsto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06293', 'I', 20, 'Utilizzare la lista valori per visualizzare e scegliere il tipo', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06293', 'I', 30, 'interfaccia desiderato.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06294', 'I', 10, 'Il tipo voce inserito non e'' previsto dall''applicazioe.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06294', 'I', 20, 'Occorre correggere il tipo voce utilizzando la lista valori validi.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06295', 'I', 10, 'Il valore digitato non e'' corretto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06295', 'I', 20, 'Consultare la lista valori per scegliere il tipo interfaccia valido.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06300', 'I', 1, 'Oltre che abilitare al ruolo il ramo prescelto, sono state abilitate', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06300', 'I', 11, 'anche tutte le sue foglie.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06300', 'I', 21, 'Per verificare occorre controllare le foglie tramite il percorso', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06300', 'I', 31, 'utilizzando il tasto di Nodo successivo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06301', 'I', 1, 'Sono state disabilitate al ruolo, oltre al ramo prescelto, le sue', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06301', 'I', 11, 'foglie.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06301', 'I', 21, 'Per verificare le abilitazione al percorso del ramo utilizzare il', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06301', 'I', 31, 'tasto di Nodo successivo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06302', 'I', 10, 'Il ramo del menu'' e'' gia'' stato abilitato per il ruolo prescelto.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06302', 'I', 20, 'Per abilitare automaticamente anche tutte le sue foglie occorre', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06302', 'I', 30, 'disabilitare e riabilitare il ramo, oppure agire direttamente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06302', 'I', 40, 'sul percorso a livello di foglia utilizzando il tasto di nodo', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06302', 'I', 50, 'successivo.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06303', 'I', 10, 'Non e'' possibile richiedere la funzione di nodo successivo su una', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A06303', 'I', 20, 'occorrenza di foglia del menu.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07008', 'I', 10, 'Non e'' possibile effettuare la cancellazione in quanto esistono delle', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07008', 'I', 20, 'voci di help collegate all''occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07008', 'I', 30, 'Consultare la definizione voci ed eventualmente modificare o', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07008', 'I', 40, 'cancellare il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07018', 'I', 10, 'Non e'' possibile effettuare la cancellazione in quanto esistono delle', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07018', 'I', 20, 'prenotazioni collegate all''occorrenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07018', 'I', 30, 'Richiedere all''amministratore di sistema la verifica ed eventualmente', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07018', 'I', 40, 'la cancellazione delle prenotazioni.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07028', 'I', 10, 'Non e'' possibile cancellare l''occorrenza desiderata in quanto esiste', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07028', 'I', 20, 'una definizione di passi procedurali collegata.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07028', 'I', 30, 'Occorre consultare, anche tramite barra di azione, la definizione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07028', 'I', 40, 'passi procedurali ed eventualmente modificare o cancellare il', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07028', 'I', 50, 'collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07038', 'I', 10, 'Non e'' possibile cancellare l''occorrenza desiderata in quanto esiste', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07038', 'I', 20, 'un collegamento alle guide verticali.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07038', 'I', 30, 'Occorre consultare, anche tramite barra di azione, la definizione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07038', 'I', 40, 'guide ed eventualmente modificarne il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07040', 'I', 10, 'Il codice di guida orizzontale non e'' presente nella definizione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07040', 'I', 20, 'guide.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07040', 'I', 30, 'Utilizzare la barra di azione per ricercare od inserire l''informazione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07040', 'I', 40, 'di guida orizzontale prescelta.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07048', 'I', 10, 'Non e'' possibile cancellare l''occorrenza desiderata in quanto esiste', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07048', 'I', 20, 'un collegamento delle guide orizzontali.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07048', 'I', 30, 'Occorre consultare, anche tramite barra di azione, la definizione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07048', 'I', 40, 'guide ed eventualmente modificarne il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07058', 'I', 10, 'Non e'' possibile cancellare l''occorrenza desiderata in quanto esiste', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07058', 'I', 20, 'un collegamento di dati di competenza.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07058', 'I', 30, 'Occorre consultare, anche tramite barra di azione, la definizione', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'A07058', 'I', 40, 'delle competenze ed eventualmente modificarne il collegamento.', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'AAA005', 'I', 1, 'dfwfe'' prevista alcuna documentazione relativamente all''elemento ri-', '0', 70);
INSERT INTO A_AIUTI_ERRORE ( ERRORE, GRUPPO_LING, NO_RIGA, TESTO, CR, LUNGHEZZA)
VALUES ( 'AAA005', 'I', 2, 'chiesto.', '0', 70);
end;
--ALTER TABLE A_AIUTI_ERRORE ENABLE ALL TRIGGERS;
  enf if;

  begin
    select 1 into w_errori
      from a_errori
     where rownum = 1
    ;
  exception
    when no_data_found then
         w_errori := 0;
    when others then
         w_errori := -1;
  end;

  if w_errori = 0 then
--ALTER TABLE A_ERRORI DISABLE ALL TRIGGERS;
begin
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00001', 'Registrazione non presente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00002', 'Registrazione gia'' presente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00003', 'Valore duplicato in tabella', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00004', 'Funzione non abilitata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00005', 'Testo di aiuto non disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00006', 'Non sono previsti livelli superiori di documentazione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00007', 'Non si sono verificati errori', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00008', 'Testo di aiuto sulla segnalazione non disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00009', 'Barra d''azione non disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00010', 'Ricerca contemporanea per codice e descrizione non ammessa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00011', 'Aiuto a livello di campo non disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00012', 'Aiuto a livello di formato video non disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00013', 'Aiuto a livello di voce di menu non disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00014', 'Valore errato, usare la LIST of VALUE per la scelta', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00015', 'Sono presenti descrizioni in altre lingue', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00016', 'Descrizione obbligatoria in almeno una delle versioni linguistiche', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00017', 'Funzione non abilitata sull''elemento selezionato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00018', 'Campo non aggiornabile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00019', 'Ultimo elemento disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00020', 'Inserimento non consentito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00021', 'Cancellazione non consentita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00022', 'Variazione non consentita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00023', 'L''informazione presente nel blocco di testata non e'' valida', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00024', 'Primo elemento disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00025', 'Descrizione gia'' presente nella lingua', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00026', 'Presenza anomala di piu'' descrizioni per la lingua', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00027', 'Impossibile muoversi dalla testata senza aggiornarla', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00028', 'Funzione non abilitata a schermo ridotto', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00029', 'Valori errati per la ricerca', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00030', 'Non esistono ulteriori blocchi di lavoro', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00031', 'Non esistono blocchi di lavoro precedenti', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00032', 'Fine Regolare', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00033', 'Abilitazione alle prenotazioni sospesa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00034', 'Confermare la cancellazione con <Cancella-record>', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00035', 'Verificare il rapporto di procedura', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00036', 'Rilevati errori bloccanti, contattare l''assistenza', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00037', 'Rilevate anomalie applicative, vedi rapporto di procedura', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00038', 'Ricerca non consentita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00039', 'Stampa eseguita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00040', 'Obbligatorio inserire una selezione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00101', 'Classe di stampa non gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00102', 'Identificativo stampante non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00103', 'Predisposizione stampante-classe gia'' gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00104', 'Esistono dati di predisposizione stampanti collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00105', 'Identificativo stampante gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00106', 'Non ci sono stampanti di tipo spooler da poter interrompere', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00108', 'Classe di stampa gia'' gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00109', 'Sono presenti valori duplicati di classe di stampa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00110', 'Sono presenti valori duplicati dell''identificativo stampante', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00111', 'Sono presenti valori duplicati di predisposizione stampanti', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00112', 'Codice sequenziale non catalogato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00113', 'Gruppo di lavoro gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00114', 'Codice errore gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00115', 'Sono presenti valori duplicati della voce di menu''', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00116', 'Sono presenti valori duplicati del codice sequenziale', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00117', 'Identificativo di guida orizzontale gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00118', 'Identificativo di guida verticale gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00119', 'Sono presenti valori duplicati della guida orizzontale', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00120', 'Sono presenti valori duplicati di passo procedurale', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00121', 'Passo procedurale gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00122', 'Codice stampa non catalogato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00123', 'Sono presenti valori duplicati di codice stampa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00124', 'Voce di riferimento non catalogata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00125', 'Voce di menu non catalogata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00126', 'Identificativo di guida verticale non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00127', 'Sono presenti valori duplicati della guida verticale', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00128', 'Esistono testi di aiuto collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00129', 'Sono presenti valori duplicati del codice errore', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00130', 'Sono presenti valori duplicati del progressivo di riga', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00131', 'Esistono stampe prodotte relative a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00132', 'Esistono gruppi di lavoro collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00133', 'Esistono codici stampa collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00134', 'Esistono stampe prodotte dal passo procedurale variato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00135', 'Esistono valori di parametro collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00136', 'Sono presenti valori duplicati del codice parametro', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00137', 'Parametro relativo alla voce di menu'' gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00138', 'Superata la lunghezza massima prevista per il parametro', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00139', 'La procedura non prevede parametri di selezione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00140', 'Valore non valido per lo stato della stampa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00141', 'Procedura protetta, presenti prenotazioni in attesa o elaborazione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00142', 'Prenotazione effettuata il', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00143', 'La procedura e'' gia'' in fase di esecuzione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00144', 'Presenti prenotazioni della stessa procedura in attesa o elaborazione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00145', 'Presenti stampe relative alla stessa procedura non ancora cancellate', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00146', 'Il parametro deve essere obbligatoriamente fornito :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00147', 'Indicatore di obbligatorieta'' non valido', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00148', 'Codice della stampa gia'' catalogato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00149', 'Valore non valido per la predisposizione Normale/Compresso', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00150', 'Valore non valido per il tipo di controllo verticale', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00151', 'Testo di aiuto gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00152', 'Modulo e blocco devono valere ''*'' per il tipo oggetto ''F'' ed ''M''', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00153', 'Modulo e blocco diversi da ''*'' per il tipo di oggetto ''A'' ed ''C''', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00154', 'Valore non valido per lo stato dello schedulatore', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00155', 'Valore non valido per l''abilitazione alle prenotazioni nel sistema', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00156', 'Stampa non cancellabile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00157', 'La stampa non e'' riproducibile sulla stampante', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00158', 'Non e'' possibile modificare lo stato con tale codice', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00159', 'Il formato del parametro risulta errato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00160', 'Il parametro di tipo data deve avere lunghezza di 10 caratteri', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00161', 'Valore non valido per il tipo oggetto da documentare', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00162', 'Voce di menu'' non catalogata per il tipo oggetto ''M''', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00163', 'La voce di riferimento e'' vietata se assente la voce di menu''', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00164', 'Voce di menu'' e guida verticale contemporaneamente presenti', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00165', 'Voce di menu'' e guida verticale contemporaneamente assenti', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00166', 'Valore non valido per il tipo formato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00167', 'La voce di menu'' selezionata deve essere di tipo differito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00168', 'Nessuna stampante associata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00169', 'Sono presenti stampe relative alla prenotazione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00170', 'E'' stata associata la stampante', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00171', 'Sono state interrotte le stampe sulla stampante', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00172', 'Il numero finale di pagina da stampare supera il totale delle pagine', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00173', 'Incongruenza fra il numero iniziale e finale di pagina da stampare', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00174', 'Non sono presenti precedenti prenotazioni della procedura', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00175', 'Stampe protette, presenti stampe relative a precedenti elaborazioni', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00176', 'Sono presenti valori duplicati di modalita'' di stampa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00177', 'Modalita'' di stampa gia'' gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00178', 'Sono presenti definizioni duplicate del modo di stampa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00179', 'Codice modalita'' di stampa non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00180', 'Valore non valido per il tipo di schedulazione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00183', 'Valore non valido per il tipo di utilizzo della stampante', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00184', 'Esistono definizioni di competenza collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00185', 'Valori duplicati per l''oggetto', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00186', 'Oggetto gia'' presente in archivio', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00187', 'Istanza di ambiente gia'' presente in archivio', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00189', 'Competenza gia'' presente in archivio', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00192', 'Funzione chiamata gia'' gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00196', 'Definizione margine gia'' presente in archivio', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00197', 'Incongruenza fra il tipo interfaccia ed i dati modulo e/o stringa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00198', 'Esistono emulazioni collegate al modo di stampa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00200', 'Modalita'' di stampa di annullamento non gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00201', 'Sono presenti valori duplicati di emulazione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00203', 'Emulazione non gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00205', 'La procedura non ha utilizzato alcun parametro di selezione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00206', 'La procedura non ha generato alcuna stampa', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00207', 'Esistono stampanti collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00208', 'Sono presenti valori duplicati di regione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00209', 'Regione gia'' gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00210', 'Sono presenti valori duplicati di provincia', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00211', 'Provincia gia'' gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00212', 'Regione non gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00213', 'Sono presenti valori duplicati di raggruppamento stati', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00214', 'Sono presenti valori duplicati di stato/territorio di appartenenza', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00215', 'Sono presenti valori duplicati di stato/territorio', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00216', 'Stato/territorio di appartenenza non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00217', 'Raggruppamento stati non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00218', 'Stato/territorio gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00219', 'Sono presenti valori duplicati di tipo consolato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00220', 'Tipo consolato gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00221', 'Sono presenti valori duplicati di consolato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00222', 'Tipo consolato non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00223', 'Sono presenti valori duplicati di comune', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00224', 'Comune gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00225', 'Provincia non gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00226', 'Comune non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00227', 'Consolato non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00228', 'Stato/territorio non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00229', 'Comune con uguale data validita'' gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00230', 'Valore non valido per parametro', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00231', 'Sono presenti valori duplicati per i parametri relativi alla voce menu''', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00232', 'Valore non valido per operatore', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00233', 'Valore non valido per tipo valore', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00234', 'Valore non valido per campo di ordinamento', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00235', 'Valore non valido per il tipo di dispositivo', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00236', 'Valore non valido per il tipo di shutdown', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00237', 'Valore non valido per la riattivazione dello schedulatore', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00250', 'Esiste nell''indice di aiuto un collegamento a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00300', 'Sono presenti valori duplicati di campi della vista', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00301', 'Sono presenti valori duplicati della vista', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00302', 'Sono presenti valori duplicati di elenco parametrico', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00303', 'I campi di rottura per raggruppamento devono essere i primi dell''elenco', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00304', 'Attenzione: ogni elemento estratto verra'' stampato su piu'' righe', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00305', 'Definire le colonne dell''elenco', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00306', 'Vista non catalogata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00307', 'Elenco gia'' presente per la voce di menu''', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00308', 'Selezionare un elenco', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00309', 'Campo della vista non catalogato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00310', 'Valore non valido per posizione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00311', 'Valore non valido per raggruppamento', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00312', 'Valore non valido per tipo ordinamento', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00313', 'Valore non valido per parametro', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00314', 'Sono presenti valori duplicati di parametro per la vista associata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00315', 'Il valore deve essere nel formato ".. . and ..."', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00316', 'Valore non valido per operatore logico', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00317', 'Funzione non abilitata in questo contesto', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00318', 'Nessuna condizione di estrazione utente salvata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00319', 'Campo non presente nella tabella campi della vista', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00320', 'Tabella o Vista inesistente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00321', 'Colonna inesistente nella tavola o nella vista', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00322', 'Non sono stati definiti campi per la vista', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00323', 'Non sono stati definiti campi per la vista', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00324', 'Formato importo definibile solo per Stampe', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00333', 'Valore non valido per gruppo', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00334', 'La definizione dei gruppi di condizioni e'' incongruente', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00335', 'Disallineamento sul sequence A_SELEZIONI', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00336', 'Disallineamento fra la tabella parametri e parametri_elenchi', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00337', 'Deve esistere almeno una colonna; altrimenti cancellare l''elenco.', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00338', 'Personalizzazione gia'' presente', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00339', 'Valore non valido per funzione di calcolo', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00340', 'Raggruppamento e funzione non si possono definire sulla stessa colonna', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00341', 'Sfondamento della lunghezza prevista per ordinamento o raggruppamento', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00342', 'Se e'' definita una funzione su colonna, le altre devono essere di raggr.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00343', 'La funzione di calcolo specificata e'' valida solo su colonna numerica', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00344', 'Valore non valido per la modalita'' di scarico FTP', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00345', 'Scegliere in alternativa lo scarico su PC o su device UNIX', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00346', 'Valore non valido per l''indicatore di stampa in compresso', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00347', 'Disallineamento sul sequence N_STAMPA', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00348', 'Per lo scarico su PC indicarare l''indirizzo dello stesso nella rete', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00349', 'La lunghezza totale della riga del sequenziale supera i 500 caratteri.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00350', 'I campi di tipo NUMBER possono essere riempiti solo con il carattere 0.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00351', 'Il formato puo'' essere definito solo per i campi di tipo DATA.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00352', 'Valore non valido per il formato della data.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00353', 'Non e'' possibile definire un riempimento per i campi di tipo DATA.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00354', 'La lunghezza di un campo di tipo DATA deve essere di 8 caratteri.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00400', 'Archivio sequenziale gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00401', 'Indicatore di carico/scarico non valido', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00402', 'Chiusura forzata, prenotazione chiusa dall''operatore', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00403', 'Disallineamento sulla tabella prenotazioni', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00404', 'Premere il tasto <Chiusura forzata> per confermare', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00405', 'Il numero della riga dell''etichetta deve essere progressivo', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00406', 'Il campo deve avere il formato "$val1$testo1$val2$testo2$testo_default$', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00407', 'In questo caso bisogna obbligatoriamente inserire il campo etichetta', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A00999', 'Obbligatorio inserire una selezione', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05500', 'Valore non valido per gruppo linguistico', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05501', 'Valore non valido per abilitazione password', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05502', 'Valore non valido per statistica accessi', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05503', 'Acronimo obbligatorio in almeno una delle versioni linguistiche', NULL, NULL, 'X');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05600', 'Numero di decimali permessi', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05601', 'Impossibile muoversi dalla descrizione senza aggiornarla', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05710', 'Valore di default obbligatorio per i parametri non introducibili', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05711', 'Barra d''azione non ammessa per questo formato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05720', 'Dominio selezioni non definito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05721', 'Valore del parametro errato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05725', 'Dominio gia'' codificato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05726', 'Passo Procedurale non definito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05727', 'Numero di Prenotazione :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A05728', 'Esistono parametri di selezioni collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06010', 'Gruppo di lavoro non gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06016', 'Gruppo di lavoro gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06017', 'Sono presenti gruppi di lavoro duplicati', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06020', 'Utente non definito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06021', 'Impossibile inserire password uguale alla precedente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06022', 'Password errata !!!', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06023', 'Password scaduta', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06024', 'Raggiunto il numero massimo di tentativi massimo :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06025', 'Password in scadenza, scadenza il', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06026', 'Utente gia'' codificato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06027', 'Sono presenti utenti duplicati', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06028', 'Esistono Utenti collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06030', 'Utente non abilitato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06036', 'Diritto di accesso gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06038', 'Esistono abilitazioni collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06040', 'Istanza di Ambiente non presente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06046', 'Istanza di Ambiente gia'' codificata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06047', 'Sono presenti istanze di ambiente duplicate', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06048', 'Esistono Istanze di Ambiente collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06050', 'Ruolo non codificato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06056', 'Ruolo gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06057', 'Sono presenti Ruoli duplicati', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06060', 'Applicazione non definita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06061', 'Ambiente non congruente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06066', 'Applicazione gia'' gestita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06067', 'Sono presenti Applicazioni duplicate', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06068', 'Esiste Applicazione collegata a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06072', 'Sessione disabilitata - Terminale :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06078', 'Esistono statistiche di accesso collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06080', 'Ambiente non presente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06086', 'Ambiente gia'' gestito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06087', 'Sono presenti Ambienti duplicati', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06090', 'Voce di Menu non presente o non disponibile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06094', 'Esistono personalizzazioni duplicate di :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06095', 'Acronimo non trovato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06096', 'Voce di Menu gia'' utilizzata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06097', 'Sono presenti Voci di Menu duplicate', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06098', 'Esistono Voci di Menu collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06099', 'Impossibile modificare tipo interfaccia, esistono passi procedurali', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06106', 'Menu gia'' costruito', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06107', 'Sono presenti registrazioni di Menu duplicate', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06108', 'Costruito il menu su', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06109', 'Esistono ruoli abilitati', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06110', 'Padre non previsto', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06112', 'Esistono figli collegati', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06120', 'Ente non previsto', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06126', 'Ente gia'' utilizzato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06127', 'Sono presenti Enti duplicati', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06128', 'Esistono Enti collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06291', 'Incongruenza tra tipo voce e tipo interfaccia', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06292', 'L''interfaccia deve essere di tipo menu (m)', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06293', 'Dati errati per tipo interfaccia', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06294', 'Valore non valido per tipo voce', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06295', 'Valore non valido per tipo interfaccia', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06300', 'Inserite abilitazione delle foglie del menu', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06301', 'Cancellate abilitazione delle foglie del menu', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06302', 'Per abilitare le foglie cancellare poi inserire', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A06303', 'Funzione non abilitata su una foglia', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A07008', 'Esistono voci di help collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A07018', 'Esistono prenotazioni collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A07028', 'Esistono passi procedurali collegati a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A07038', 'Esistono guide verticali collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A07040', 'Guida orizzontale non presente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A07048', 'Esistono guide orizzontali collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A07058', 'Esistono competenze collegate a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08000', 'Modulo assente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08001', 'Inizio Caricamento del Modulo :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08002', 'Eseguito Caricamento del Modulo :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08003', 'Caricamento errato :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08004', 'Inizio Cancellazione del Modulo :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08005', 'Eseguita Cancellazione del Modulo :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08006', 'Cancellazione errata :', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08300', 'Il campo verra'' stampato lungo 10 perche'' l''intestazione supera caratt.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08500', 'Comune non codificato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08501', 'Dati Anagrafici incompleti', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08502', 'Lista Valori solo con valore iniziale', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08503', 'Tipo anagrafico errato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08504', 'Sovrapposizione di periodi', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08505', 'Data inizio validita'' > data fine', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08506', 'Cittadinanza non codificata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08507', 'Gruppo linguistico non codificato', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08508', 'Data Nascita errata', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08509', 'Codice fiscale non corrisponde ai dati anagrafici', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08510', 'Assegnazione sequenza fallita', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08511', 'Esiste Anagrafica collegata a', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08512', 'Gia'' presente individuo con uguale codice fiscale', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08513', 'Cittadinanza gia'' presente', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08514', 'Esistono piu` comuni con questa denominazione, usare la LIST of VALUE.', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08516', 'Anagrafica non eliminabile', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08517', 'Codice non valido', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A08518', 'Soggetti con uguale denominazione sono gia'' presenti - ListValues -', NULL, NULL, NULL);
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99970', 'La licenza del prodotto non e'' valida!. Il Nome del Licenziatario non e''', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99971', 'Impossibile attivare prenotazioni con modifche in sospeso', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99972', 'Impossibile attivare il Wordprocessor', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99973', 'Definizione parametri valida per config. con scheduler server UNIX', NULL, NULL, 'I');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99974', 'Il database non e'' stato installato / aggiornato correttamente. Versione', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99975', 'Impossibile accedere ai log delle prenotazioni prodotte in versione 3', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99976', 'Impossibile accedere a stampe prodotte da applicativi in versione 3', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99977', 'Impossibile determinare l''istanza di ambiente', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99978', 'Impossibile eliminare la stampa dall''elenco', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99979', 'La stampa e'' riproducibile unicamente ', NULL, NULL, 'I');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99980', 'Impossibile eliminare il log', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99981', 'Ramo di menu` non disponibile', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99982', 'Lettura registri di configurazione fallita', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99983', 'Impossibile determinare i dati della fase selezionata', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99984', 'Navigazione diretta tra blocchi non consentita', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99985', 'Impossibile eliminare il file', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99986', 'Impossibile determinare la dislocazione associata all''ambiente', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99987', 'Errore in definizione delle voci del menu`', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99988', 'E'' stato rilevato un errore inoltrando la prenotazione allo schedulatore', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99989', 'Impossibile aggiornare lo stato della prenotazione', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99990', 'Impossibile eliminare la prenotazione', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99991', 'Impossibile attivare il browser', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99992', 'Barra d''azione gia` attivata da altra voce di menu`', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99993', 'Impossibile determinare guida verticale e voce menu`', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99994', 'Impossibile determinare la funzione da attivare', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99995', 'Barra non attivabile in modalita` ENTER-QUERY', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99996', 'Operazione ammessa unicamente da maschera di partenza', NULL, NULL, 'B');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99997', 'Errore in lettura registri per ricerca della stampante predefinita', NULL, NULL, 'S');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99998', 'Sono attive le impostazioni per la stampante', NULL, NULL, 'I');
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA)
VALUES ( 'A99999', 'Errore sullo schedulatore, prenotazione non soddisfatta!', NULL, NULL, 'B');
end;
--ALTER TABLE A_ERRORI ENABLE ALL TRIGGERS;
  end if;
end;
/
