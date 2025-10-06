--liquibase formatted sql
--changeset amonopoli:202503261010_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY LEGGI_FILE AS
procedure apri_file(dir_file varchar2, nome_file varchar2, file_mode varchar2)
is
BEGIN
		leggi_file.id_file := UTL_FILE.FOPEN(dir_file,nome_file,file_mode);
		IF UTL_FILE.IS_OPEN(leggi_file.id_file) THEN DBMS_OUTPUT.PUT_LINE('Opened '|| nome_file);
		ELSE
		 raise_application_error(-20999,'errore in apertura file',TRUE);
		END IF;
END;
function leggi_riga
return varchar2
is
v_riga_orig VARCHAR2(32767):= null;
BEGIN
IF UTL_FILE.IS_OPEN(leggi_file.id_file)  THEN
utl_file.get_line(leggi_file.id_file,v_riga_orig);
ELSE
raise_application_error (-20000,'Errore in lettura');
END IF;
return (v_riga_orig);
END;
procedure chiudi_file
is
begin
UTL_FILE.FCLOSE(leggi_file.id_file);
END;
function conta_righe(dir_file varchar2, nome_file varchar2)
return number
IS
v_riga_orig VARCHAR2(32767):= null;
ignore INTEGER;
id_orig UTL_FILE.FILE_TYPE;
err VARCHAR2(100);
num_righe NUMBER:= 0;
BEGIN
id_orig := UTL_FILE.FOPEN(dir_file,nome_file,'r');
		LOOP
		 utl_file.get_line(id_orig,v_riga_orig);
		 num_righe := num_righe +1;
		END LOOP;
UTL_FILE.FCLOSE(id_orig);
return (num_righe);
EXCEPTION
WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Righe ' || num_righe);
	 UTL_FILE.FCLOSE(id_orig);
	 return (num_righe);
END;
END LEGGI_FILE;
/

