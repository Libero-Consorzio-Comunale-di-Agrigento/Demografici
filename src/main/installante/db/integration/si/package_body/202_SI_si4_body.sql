--liquibase formatted sql
--changeset amonopoli:202503240920_2 runOnChange:true stripComments:false
CREATE OR REPLACE PACKAGE BODY SI4 IS
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 ECCEZIONI:   --
 ANNOTAZIONI: --
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/06/2001 MM     Creazione.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 05/03/2002';
END VERSIONE;
PROCEDURE SQL_EXECUTE( p_stringa varchar2 ) IS
/******************************************************************************
 NOME:        SQL_EXECUTE
 DESCRIZIONE: Esegue lo statement passato.
 ARGOMENTI:   p_stringa varchar2 statement sql da eseguire
 ECCEZIONI:
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    25/01/2001 SN     Inserito commento.
******************************************************************************/
cursor_name    INTEGER;
rows_processed INTEGER;
BEGIN
   cursor_name   := dbms_sql.open_cursor;
   dbms_sql.parse(cursor_name,p_stringa,dbms_sql.native);
   rows_processed:= dbms_sql.execute(cursor_name);
   dbms_sql.close_cursor(cursor_name);
EXCEPTION
   WHEN OTHERS THEN
      dbms_sql.close_cursor(cursor_name);
      raise;
END SQL_EXECUTE;
PROCEDURE VIEW_MODIFY ( nome_vista varchar2
                      , testo      varchar2
                      , operatore  varchar2
                      ) IS
/******************************************************************************
 NOME:        VIEW_MODIFY
 DESCRIZIONE: Modifica il testo della vista in base all'operatore indicato
              usando il testo specificato.
 ARGOMENTI:   nome_vista varchar2 vista da modificare
              testo      varchar2 codice da inserire nella vista
              operatore  varchar2 create,replace,union, intersect o minus
 ECCEZIONI:   -20999, con messaggio che specifica l'errore verificatosi.
 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0               SN     Prima emissione.
 1    25/01/2001 SN     Inserito commento.
******************************************************************************/
v_testo     varchar2(32000);
d_v_testo   varchar2(32000);
d_testo     varchar2(32000);
d_pos       number;
parte       boolean;
cursor_name integer;
BEGIN
   if operatore is null or upper(operatore) = 'REPLACE' then
      v_testo := 'create or replace view ' || nome_vista ||' as ' || testo;
   elsif upper(operatore) = 'CREATE' then
      v_testo := 'create view ' || nome_vista ||' as ' || testo;
   elsif upper(operatore) in ('MINUS', 'INTERSECT','UNION') then
        /* operatore per legame con la vista preesistente*/
     << estrazione_testo >>
     begin
       select text
         into v_testo
         from user_views
        where view_name = upper(nome_vista);
       d_v_testo := upper(translate(v_testo,'a '||chr(10)||chr(13),'a'));
       d_testo := upper(translate(testo,'a '||chr(10)||chr(13),'a'));
       d_pos := instr(d_v_testo,d_testo);
       if d_pos  = 0 then
         /* il testo non esisteva gia' */
         v_testo := 'create or replace view ' || nome_vista||' as ' || v_testo;
         v_testo := v_testo || ' ' || operatore || ' ' || testo;
       else /*esisteva ma controllo che non sia una sottoparte */
         parte := FALSE;
         while d_pos != 0 and parte = FALSE loop /* finche' non trovo piu' occorrenze */
           if substr(d_v_testo,d_pos + length(d_testo),5)
             in ('UNION','MINUS')  OR
             substr(d_v_testo,d_pos + length(d_testo),9)
             = 'INTERSECT' OR
              substr(d_v_testo,d_pos + length(d_testo),1) is null
             then
               parte := TRUE;
           else
             d_pos := instr(d_v_testo,d_testo,d_pos + length(d_testo));
           end if;
         end loop;
       end if;
       if parte = FALSE then
         /* NON e' sottoparte */
         v_testo := 'create or replace view ' || nome_vista||' as ' || v_testo;
         v_testo := v_testo || ' ' || operatore || ' ' || testo;
       end if;
     exception
      when no_data_found then
        if upper(operatore) = 'UNION' then
          /* creo comunque la vista */
      v_testo := 'create view ' || nome_vista ||' as ' || testo;
        else /* operatore Intersect o Minus e vista esistente */
       raise_application_error(-20999,'Vista '|| nome_vista ||' inesistente, operatore ' || operatore || ' non valido');
        end if;
     end estrazione_testo;
   else /* operatore non valido */
     raise_application_error(-20999,'Operatore ' || operatore || ' non valido');
   end if;
   cursor_name:= DBMS_SQL.OPEN_CURSOR;
   DBMS_SQL.PARSE(cursor_name, v_testo, DBMS_SQL.native);
   DBMS_SQL.CLOSE_CURSOR(cursor_name);
EXCEPTION
   WHEN OTHERS THEN
      dbms_sql.close_cursor(cursor_name);
      raise;
END VIEW_MODIFY;
FUNCTION NEXT_ID ( table_name varchar2
                 , column_id varchar2 default 'ID'
                 , new_id integer default null
                 , locked number default 1
                 ) RETURN INTEGER IS
/******************************************************************************
 NOME:        NEXT_ID
 DESCRIZIONE: Genera numerazioni progressive sulla table come valore max + 1
              della colonna indicata.
 PARAMETRI:   table_name varchar2          tabella da numerare
              column_id  varchar2 default 'ID' colonna con numerazione
              new_id     integer  default null numerazione proposta
              locked     number   default 1    per impedire modifiche simultanee
 RITORNA:     INTEGER valore con cui effettuare la prossima numerazione.
 ECCEZIONI:   -20999, Valore proposto per numerazione > massimo attuale
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0               MM     Prima emissione.
 1    25/01/2001 SN     Inserito commento.
******************************************************************************/
   cursor_name    INTEGER;
   rows_processed INTEGER;
   sql_next_val   VARCHAR2(32000);
   next_id        INTEGER;
   lock_table     VARCHAR2(2000);
BEGIN
   sql_next_val := 'select nvl(max(' || column_id || '),0)+ 1 ' ||
                  '  from ' || table_name ;
   if locked = 1 then
      -- Modificato il 22/01/2001
     -- nonostante il lock exclusivo le select sulla tabella sono consentite
       lock_table := 'lock table ' || table_name || ' in exclusive mode';
     SI4.SQL_EXECUTE(lock_table);
   end if;
   BEGIN
      cursor_name   := dbms_sql.open_cursor;
      dbms_sql.parse(cursor_name,sql_next_val,dbms_sql.native);
      dbms_sql.define_column(cursor_name, 1, next_id);
      rows_processed:= dbms_sql.execute(cursor_name);
      if dbms_sql.fetch_rows(cursor_name)>0 then
        dbms_sql.column_value(cursor_name, 1, next_id);
      else
        raise_application_error(-20999,'Impossibile numerare');
      end if;
      dbms_sql.close_cursor(cursor_name);
      EXCEPTION
      WHEN OTHERS THEN
         dbms_sql.close_cursor(cursor_name);
         raise;
   END;
   if (new_id is not null) then
      if (new_id > next_id) then
         raise_application_error(-20999, 'Progressivo numerazione ' || to_char(new_id) || ' non attribuibile');
      else
         next_id := new_id;
      end if;
   end if;
   return next_id;
END NEXT_ID;
PROCEDURE GET_ACCESSO_UTENTE ( p_utente IN OUT varchar2, p_note_utente IN OUT varchar2
                             , p_modulo IN OUT varchar2, p_note_modulo IN OUT varchar2
                             , p_istanza IN OUT varchar2, p_note_istanza IN OUT varchar2
                             , p_note_accesso IN OUT varchar2
                             , p_ente IN OUT varchar2, p_note_ente IN OUT varchar2
                             , p_progetto IN OUT varchar2, p_note_progetto IN OUT varchar2
                             , p_ambiente IN OUT varchar2) IS
/******************************************************************************
 NOME:        GET_ACCESSO_UTENTE
 DESCRIZIONE: Restituisce i valori di tutte le variabili di ambiente (sono riempite in fase di connessione ai singoli applicativi).
 ARGOMENTI:   p_utente  varchar2         codice utente di applicazione
              p_note_utente varchar2     note relative ad utente di applicazione
              p_modulo varchar2          codice modulo di connessione
              p_note_modulo varchar2     note relative a modulo di connessione
              p_istanza varchar2         codice istanza di connessione
              p_note_istanza varchar2    note relative a istanza di connessione
              p_note_accesso varchar2    note relative a diritto di accesso di connessione
              p_ente varchar2            codice ente associato all'istanza di connessione
              p_note_ente varchar2       note relative ad ente di connessione
              p_progetto varchar2        codice progetto di connessione
              p_note_progetto varchar2   note relative a progetto di connessione
              p_ambiente varchar2        codice ambiente di connessione (SI, A00, AD4)
 ECCEZIONI:   --
 ANNOTAZIONI: --
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/06/2001 MM     Creazione.
******************************************************************************/
BEGIN
   p_utente       := UTENTE;
   p_note_utente  := NOTE_UTENTE;
   p_modulo       := MODULO;
   p_note_modulo  := NOTE_MODULO;
   p_istanza      := ISTANZA;
   p_note_istanza := NOTE_ISTANZA;
   p_note_accesso := NOTE_ACCESSO;
   p_ente         := ENTE;
   p_note_ente    := NOTE_ENTE;
   p_progetto     := PROGETTO;
   p_note_progetto:= NOTE_PROGETTO;
   p_ambiente     := AMBIENTE;
END GET_ACCESSO_UTENTE;
PROCEDURE SET_ACCESSO_UTENTE ( p_utente varchar2, p_note_utente varchar2
                             , p_modulo varchar2, p_note_modulo varchar2
                             , p_istanza varchar2, p_note_istanza varchar2
                             , p_note_accesso varchar2
                             , p_ente varchar2, p_note_ente varchar2
                             , p_progetto varchar2, p_note_progetto varchar2
                             , p_ambiente varchar2) IS
/******************************************************************************
 NOME:        SET_ACCESSO_UTENTE
 DESCRIZIONE: Permette di riempire tutte le variabili di ambiente.
 ARGOMENTI:   p_utente  varchar2         codice utente di applicazione
              p_note_utente varchar2     note relative ad utente di applicazione
              p_modulo varchar2          codice modulo di connessione
              p_note_modulo varchar2     note relative a modulo di connessione
              p_istanza varchar2         codice istanza di connessione
              p_note_istanza varchar2    note relative a istanza di connessione
              p_note_accesso varchar2    note relative a diritto di accesso di connessione
              p_ente varchar2            codice ente associato all'istanza di connessione
              p_note_ente varchar2       note relative ad ente di connessione
              p_progetto varchar2        codice progetto di connessione
              p_note_progetto varchar2   note relative a progetto di connessione
              p_ambiente varchar2        codice ambiente di connessione (SI, A00, AD4)
 ECCEZIONI:   --
 ANNOTAZIONI: --
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/06/2001 MM     Creazione.
******************************************************************************/
BEGIN
   UTENTE       := p_utente;
   NOTE_UTENTE  := p_note_utente;
   MODULO       := p_modulo;
   NOTE_MODULO  := p_note_modulo;
   ISTANZA      := p_istanza;
   NOTE_ISTANZA := p_note_istanza;
   NOTE_ACCESSO := p_note_accesso;
   ENTE         := p_ente;
   NOTE_ENTE    := p_note_ente;
   PROGETTO     := p_progetto;
   NOTE_PROGETTO:= p_note_progetto;
   AMBIENTE     := p_ambiente;
END SET_ACCESSO_UTENTE;
FUNCTION GET_ERROR (p_errore VARCHAR2) RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        GET_ERROR
 DESCRIZIONE: Ricerca descrizione errore su Table KEY_ERROR.
 PARAMETRI:   p_errore VARCHAR2 Codifica errore
 RITORNA:     VARCHAR2 Descrizione errore
 ANNOTAZIONI: Se codifica non corretta ritorna la stringa in ingresso.
              Formato errore da ricercare su tabella:
                 X00000  dove X    : primo carattere alfanumerico
                              00000: seguito da 5 caratteri numerici
              Se il codice e seguito da uno spazio, la stringa che segue
           viene accodata alla descrizione estratta.
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    01/03/2001 MF     Prima emissione.
 1    05/03/2002 MM     Inclusione in PACKAGE SI4 e sostituzione della SELECT
                        con SQL_EXECUTE Iin modo che, se la tabella non esiste,
                        restituisca il parametro in ingresso e non dia errore.
******************************************************************************/
d_codice    VARCHAR2(6);
d_note      VARCHAR2(2000);
d_messaggio VARCHAR2(4000);
BEGIN
   IF translate(substr(p_errore,2,5),'123456789','000000000') = '00000'
   AND ( length(p_errore) < 7
       OR substr(p_errore,7,1) = ' '
      ) THEN
      d_codice := substr(p_errore,1,6);
      d_note   := substr(p_errore,7);
      BEGIN -- Cerca il codice di errore corrispondente alla Chiave di Ricerca fornita
         sql_execute('begin
                         select descrizione
                           into SI4.d_ErrMsg
                           from key_error
                          where errore =''' || d_codice ||'''
                         ;
                      end;');
         d_messaggio := d_ErrMsg||d_note;
      EXCEPTION
         WHEN OTHERS THEN
            d_messaggio := p_errore;
      END;
   ELSE
      d_messaggio := p_errore;
   END IF;
   RETURN d_messaggio;
END GET_ERROR;
END SI4;
/
