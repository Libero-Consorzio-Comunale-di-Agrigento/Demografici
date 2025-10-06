--liquibase formatted sql
--changeset amonopoli:202503261023_2 runOnChange:false stripComments:false
create or replace package body IntegrityPackage
AS
   NestLevel   number;

-- Procedure to Initialize Switched Functional Integrity
PROCEDURE SetFunctional
is
BEGIN
   Functional := TRUE;
END;

-- Procedure to Reset Switched Functional Integrity
PROCEDURE ReSetFunctional
is
BEGIN
   Functional := FALSE;
END;

-- Procedure to initialize the trigger nest level
PROCEDURE InitNestLevel
is
BEGIN
   NestLevel := 0;
   v_entry   := 0;
END;

-- Function to return the trigger nest level
FUNCTION GetNestLevel return number
is
BEGIN
   if NestLevel is null then
      NestLevel := 0;
   end if;
   return(NestLevel);
END;

-- Procedure to increase the trigger nest level
PROCEDURE NextNestLevel
is
BEGIN
   if NestLevel is null then
      NestLevel := 0;
   end if;
   NestLevel := NestLevel + 1;
END;

-- Procedure to decrease the trigger nest level
PROCEDURE PreviousNestLevel
is
BEGIN
   NestLevel := NestLevel - 1;
END;

PROCEDURE Set_PostEvent
( a_istruzione  varchar2
, a_messaggio   varchar2
) as
actual_level    integer;
BEGIN
   actual_level := IntegrityPackage.GetNestLevel;
   v_entry := v_entry + 1;
   v_istruzione(v_entry) := a_istruzione;
   v_messaggio(v_entry)  := lpad(actual_level,2,'0')||a_messaggio;
END Set_PostEvent;

PROCEDURE Exec_PostEvent
as
cursor_id       integer;
rows_processed  integer;
actual_level    integer;
element_level   integer;
element_message varchar2(2000);
BEGIN
   actual_level := IntegrityPackage.GetNestLevel;
   FOR LoopCnt IN 1..v_entry LOOP
      element_level := to_number(substr(v_messaggio(LoopCnt), 1, 2));
      IF  element_level = actual_level
      AND v_istruzione(LoopCnt)is NOT NULL
      THEN
         IntegrityPackage.NextNestLevel;
         BEGIN
            cursor_id := dbms_sql.open_cursor;
            dbms_sql.parse(cursor_id, v_istruzione(LoopCnt), dbms_sql.native);
            IF upper(substr(ltrim(v_istruzione(LoopCnt)), 1, 6)) = 'SELECT' THEN
               rows_processed:= dbms_sql.execute_and_fetch(cursor_id);
               IF  substr(ltrim(substr(ltrim(v_istruzione(LoopCnt)), 7)), 1, 1) = 0
               AND rows_processed > 0 THEN
                  element_message := substr(v_messaggio(LoopCnt), 3);
                  IF element_message is null THEN
                     element_message := 'Sono presenti registrazioni collegate. Operazione non eseguita.';
                  END IF;
                  raise_application_error(-20008,element_message);
               ELSIF  substr(ltrim(substr(ltrim(v_istruzione(LoopCnt)),7)), 1, 1) != 0
                  AND rows_processed = 0 THEN
                  element_message := substr(v_messaggio(LoopCnt), 3);
                  IF element_message is null THEN
                     element_message := 'Non e'' presente la registrazione richiesta. Operazione non eseguita.';
                  END IF;
                  raise_application_error(-20008, element_message);
               END IF;
            ELSE -- non statement di SELECT
               rows_processed:= dbms_sql.execute(cursor_id);
            END IF;
            dbms_sql.close_cursor(cursor_id);
         EXCEPTION
            WHEN OTHERS THEN
               dbms_sql.close_cursor(cursor_id);
            raise;
         END;
         IntegrityPackage.PreviousNestLevel;
         v_istruzione(LoopCnt) := NULL;
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      InitNestLevel;
      raise;
END Exec_PostEvent;

END IntegrityPackage;
/* End Package Body: IntegrityPackage */
/
