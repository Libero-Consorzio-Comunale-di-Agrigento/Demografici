--liquibase formatted sql
--changeset amonopoli:202501311415_11 runOnChange:true stripComments:false
create or replace procedure ANAANA_FI
(a_matricola			NUMBER,
 a_fascia_new			NUMBER,
 a_fascia_old			NUMBER,
 a_stato			NUMBER,
 a_cognome_nome			VARCHAR2,
 a_sesso			VARCHAR2,
 a_data_nas			NUMBER,
 a_cod_pro_nas			NUMBER,
 a_cod_com_nas			NUMBER,
 a_sospensione_old		number,
 a_val_espatrio_old		varchar2,
 a_data_val_espatrio_old	number,
 a_note_old			varchar2,
 a_sospensione			number,
 a_val_espatrio			varchar2,
 a_data_val_espatrio		number,
 a_note				varchar2

)
is
w_motivo	varchar2(2000);
w_data_scad	varchar2(100);
begin
--	Creata il 03/06/2003
--	Aggiornata il 13/09/2005 (A. Monopoli)
--	Aggiornata il 23/01/2006 - ANAMSI (A. Monopoli)

if INSERTING then
   if a_fascia_new = 1 or (a_fascia_new = 5 and a_stato = 70) then
/*raise_application_error(-20999,'ins dentro if - fascia '||to_char(a_fascia_new)||
' stato '||to_char(a_stato)||
' nome '||a_cognome_nome||
' sesso '||a_sesso||
' data_nas '||to_char(a_data_nas)||
' cod_pro_nas '||to_char(a_cod_pro_nas)||
' cod_com_nas '||to_char(a_cod_com_nas));*/
      	 begin
	         select decode(ini.motivo,'','',' - Motivo: '||ini.motivo),
		          decode(ini.data_scadenza,'','',' - Scadenza Provvedimento: '||
			      to_char(to_date(ini.data_scadenza,'j'),'dd/mm/yyyy'))
	           into w_motivo, w_data_scad
	           from anaini ini
	          where nvl(data_scadenza,9999999) 	>= to_char(sysdate,'j')
		    and cognome_nome 			= a_cognome_nome
  		    and sesso				= a_sesso
		    and data_nas			= a_data_nas
		    and nvl(cod_pro_nas,0)		= nvl(a_cod_pro_nas,0)
		    and nvl(cod_com_nas,0)		= nvl(a_cod_com_nas,0)
 	            and rownum 	 = 1
  	         ;
                 raise too_many_rows;
         exception
	   when no_data_found then
                null;
           when too_many_rows then
     	        raise_application_error
	          (-20999,'ATTENZIONE! Inidividuo non Immigrabile'||w_motivo||w_data_scad);
           when others then
                raise_application_error
                  (-20999,'Errore in ricerca ANAINI ('||SQLCODE||')');
	 end;

      	 begin
	         select matricola
	           into w_motivo
	           from anaana ana
	          where cognome_nome 		= a_cognome_nome
  		    and sesso			= a_sesso
		    and data_nas		= a_data_nas
		    and nvl(cod_pro_nas,0)	= nvl(a_cod_pro_nas,0)
		    and nvl(cod_com_nas,0)	= nvl(a_cod_com_nas,0)
		    and fascia + 0		= 1
 	            and rownum 	 = 1
  	         ;
                 raise too_many_rows;
         exception
	   when no_data_found then
                null;
           when too_many_rows then
     	        raise_application_error
	          (-20999,'ATTENZIONE! Inidividuo gia'' Residente '||
			  '(Matricola '||w_motivo||')');
           when others then
                raise_application_error
                  (-20999,'Errore in ricerca Archivio Individui ('||SQLCODE||')');
	end;
   end if;
end if;
if UPDATING then
/*raise_application_error(-20999,'ins - '||
' fascia_old '||to_char(a_fascia_old)||
' fascia '||to_char(a_fascia_new)||
' stato '||to_char(a_stato)||
' nome '||a_cognome_nome||
' sesso '||a_sesso||
' data_nas '||to_char(a_data_nas)||
' cod_pro_nas '||to_char(a_cod_pro_nas)||
' cod_com_nas '||to_char(a_cod_com_nas));*/
   if a_fascia_new = 1 and a_fascia_old != 1 then
      	 begin
	         select decode(ini.motivo,'','',' - Motivo: '||ini.motivo),
		          decode(ini.data_scadenza,'','',' - Scadenza Provvedimento: '||
			      to_char(to_date(ini.data_scadenza,'j'),'dd/mm/yyyy'))
	           into w_motivo, w_data_scad
	           from anaini ini
	          where nvl(data_scadenza,9999999) 	>= to_char(sysdate,'j')
		    and cognome_nome 			= a_cognome_nome
  		    and sesso				= a_sesso
		    and data_nas			= a_data_nas
		    and nvl(cod_pro_nas,0)		= nvl(a_cod_pro_nas,0)
		    and nvl(cod_com_nas,0)		= nvl(a_cod_com_nas,0)
 	            and rownum 	 = 1
  	  	 ;
                 raise too_many_rows;
         exception
	   when no_data_found then
                null;
           when too_many_rows then
     	        raise_application_error
	          (-20999,'ATTENZIONE! Inidividuo non Immigrabile'||w_motivo||w_data_scad);
           when others then
                raise_application_error
                  (-20999,'Errore in ricerca ANAINI ('||SQLCODE||')');
	 end;

   end if;
   if nvl(a_sospensione_old,0) 		!= nvl(a_sospensione,0) 	or
	nvl(a_val_espatrio_old,'X') 	!= nvl(a_val_espatrio,'X') 	or
	nvl(a_data_val_espatrio_old,0)	!= nvl(a_data_val_espatrio,0) 	or
	nvl(a_note_old,'X')		!= NVL(a_note,'X')
   then
  	begin
	  insert into anamsi
		(matricola, sospensione, val_espatrio, data_val_espatrio, note, 
                 data_reg, ora_reg, minuti_reg, terminalista,
                 sospensione_prec, val_espatrio_prec, data_val_espatrio_prec, note_prec)
	  values (a_matricola, a_sospensione, a_val_espatrio, a_data_val_espatrio, a_note, 
		  to_char(sysdate,'j'), to_char(sysdate,'hh24'), to_char(sysdate,'mi'),
		  si4.utente,
                  a_sospensione_old, a_val_espatrio_old, a_data_val_espatrio_old, a_note_old)
	  ;
         exception
           when others then
                raise_application_error
                  (-20999,'Errore in inserimento ANAMSI ('||SQLCODE||')');
	end;
   end if;
end if;
end;
/
