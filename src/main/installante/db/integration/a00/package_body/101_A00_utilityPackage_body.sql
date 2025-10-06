--liquibase formatted sql
--changeset amonopoli:202503261001_2 runOnChange:false stripComments:false
create or replace package body UtilityPackage
AS
PROCEDURE Compile_All
/******************************************************************************
 NOME:        Compile_All
 DESCRIZIONE: Compilazione di tutti gli oggetti invalidi presenti nel DB.
 ANNOTAZIONI: Tenta la compilazione in cicli successivi.
              Termina la compilazione quando il numero degli oggetti
              invalidi non varia rispetto al ciclo precedente.
 REVISIONI:
 Rev. Data        Autore  Descrizione
 ---- ----------  ------  ----------------------------------------------------
 1    23/01/2001  MF      Inserimento commento.
******************************************************************************/
IS
   d_obj_name       varchar2(30);
   d_obj_type       varchar2(30);
   d_command        varchar2(200);
   d_cursor         integer;
   d_rows           integer;
   d_old_rows       integer;
   d_return         integer;
   cursor c_obj is
      select object_name, object_type
      from   OBJ
      where  object_type in ('PROCEDURE'
                            ,'TRIGGER'
                            ,'FUNCTION'
                            ,'PACKAGE'
                            ,'PACKAGE BODY'
                            ,'VIEW')
       and   status = 'INVALID'
      order by  decode(object_type
                      ,'PACKAGE',1
                      ,'PACKAGE BODY',2
                      ,'FUNCTION',3
                      ,'PROCEDURE',4
                      ,'VIEW',5
                             ,6)
             , object_name
      ;
BEGIN
   d_old_rows := 0;
   LOOP
      d_rows := 0;
      BEGIN
         open  c_obj;
         LOOP
            BEGIN
               fetch c_obj into d_obj_name, d_obj_type;
               EXIT WHEN c_obj%NOTFOUND;
               d_rows := d_rows + 1;
               IF d_obj_type = 'PACKAGE BODY' THEN
                  d_command := 'alter PACKAGE '||d_obj_name||' compile BODY';
               ELSE
                  d_command := 'alter '||d_obj_type||' '||d_obj_name||' compile';
               END IF;
               d_cursor  := dbms_sql.open_cursor;
               dbms_sql.parse(d_cursor,d_command,dbms_sql.native);
               d_return := dbms_sql.execute(d_cursor);
               dbms_sql.close_cursor(d_cursor);
            EXCEPTION
               WHEN OTHERS THEN null;
            END;
         END LOOP;
         close c_obj;
      END;
      if d_rows = d_old_rows then
         EXIT;
      else
         d_old_rows := d_rows;
      end if;
   END LOOP;
   if d_rows > 0 then
      raise_application_error(-20999,'Esistono n.'||to_char(d_rows)||' Oggetti di DataBase non validabili !');
   end if;
END Compile_All;
 
END UtilityPackage;
/* End Package Body: UtilityPackage */
/