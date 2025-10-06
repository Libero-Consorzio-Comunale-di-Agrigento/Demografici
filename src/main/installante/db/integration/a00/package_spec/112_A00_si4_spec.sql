--liquibase formatted sql
--changeset amonopoli:202503261012_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE SI4 IS
/******************************************************************************
 NOME:        SI4.
 DESCRIZIONE: Procedure e Funzioni di utilita comune.

 ANNOTAZIONI:
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    25/01/2001 SN     Inserito commento
 1    29/06/2001 MM     Inserite le variabili di connessione, la funzione
                        VERSIONE, le procedure GET_ACCESSO_UTENTE e
                        SET_ACCESSO_UTENTE.
 2    05/03/2002 MM     Inserita la funzione GET_ERROR e relativa variabile
                        d_ErrMsg. 					
******************************************************************************/
       UTENTE        varchar2(8);
       NOTE_UTENTE   varchar2(2000);
       MODULO        varchar2(10);
       NOTE_MODULO   varchar2(2000);
       ISTANZA       varchar2(10);
       NOTE_ISTANZA  varchar2(2000);
       NOTE_ACCESSO  varchar2(2000);
       ENTE          varchar2(4);
       NOTE_ENTE     varchar2(2000);
       PROGETTO      varchar2(8);
       NOTE_PROGETTO varchar2(2000);
       AMBIENTE      varchar2(8);
	   
       function  VERSIONE              RETURN varchar2;
       procedure SQL_EXECUTE           ( p_stringa  varchar2 );
       procedure VIEW_MODIFY           ( nome_vista varchar2
                                       , testo      varchar2
                                       , operatore  varchar2
                                       );
       function  NEXT_ID               ( table_name varchar2
                                       , column_id  varchar2  default 'ID'
                                       , new_id     integer   default null
                                       , locked     number    default 1     --- Di default esegue lock
                                       ) RETURN INTEGER;
       procedure GET_ACCESSO_UTENTE    ( p_utente IN OUT varchar2
                                       , p_note_utente IN OUT varchar2
                                       , p_modulo IN OUT varchar2
                                       , p_note_modulo IN OUT varchar2
                                       , p_istanza IN OUT varchar2
                                       , p_note_istanza IN OUT varchar2
                                       , p_note_accesso IN OUT varchar2
                                       , p_ente IN OUT varchar2
                                       , p_note_ente IN OUT varchar2
                                       , p_progetto IN OUT varchar2
                                       , p_note_progetto IN OUT varchar2
                                       , p_ambiente IN OUT varchar2
                                       );
       procedure SET_ACCESSO_UTENTE    ( p_utente varchar2
                                       , p_note_utente varchar2
                                       , p_modulo varchar2
                                       , p_note_modulo varchar2
                                       , p_istanza varchar2
                                       , p_note_istanza varchar2
                                       , p_note_accesso varchar2
                                       , p_ente varchar2
                                       , p_note_ente varchar2
                                       , p_progetto varchar2
                                       , p_note_progetto varchar2
                                       , p_ambiente varchar2
                                       );
       d_ErrMsg varchar2(2000);
       function GET_ERROR              ( p_errore VARCHAR2
                                       ) RETURN VARCHAR2;									   
END SI4;
/
