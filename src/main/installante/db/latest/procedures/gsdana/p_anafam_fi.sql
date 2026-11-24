--liquibase formatted sql
--changeset amonopoli:202503071455_11 runOnChange:true stripComments:false
create or replace procedure ANAFAM_FI
(a_fascia_old			IN	number,
 a_progr_eliminazione_old	IN	number,
 a_fascia_new			IN	number,
 a_progr_eliminazione_new	IN OUT 	number)
IS
w_numero			number := 0;
w_progr_eliminazione		number;
w_controllo			number;
BEGIN
IF UPDATING then
 begin
   select 1
     into w_controllo
     from arcinp inp
    where inp.parametro			= 'NUMERA_FF'
      and upper(rtrim(inp.valore))	= 'S'
   ;
 exception
   when others then
    	  w_controllo := 0;
 end;
 if w_controllo = 1 then
-- FRC: Famiglie Residenti Cancellate
-- caso 1: cancellazione di famiglia
-- (passaggio da "fascia = 1" a "fascia = 2")
-- assegnazione di progr_eliminazione
  if a_fascia_old = 1 and a_fascia_new = 2 then
     begin
       select numero + 1
         into w_progr_eliminazione
	   from anan01
	  where cod_num = 'FRC'
	 ;
	 update anan01
	    set numero  = numero + 1
	  where cod_num = 'FRC'
	 ;
     exception
	 when no_data_found then
  	      begin
		  insert into anan01
		         (cod_num, numero)
	 	  values ('FRC', 1);
	      end;
		w_progr_eliminazione := 1;
     end;
     a_progr_eliminazione_new := w_progr_eliminazione;
  end if;
-- caso 2: modifica da "fascia = 2" ad altra fascia
-- aggiornamento del numeratore (anan01.numero - 1)
-- se il progressivo che si va ad eliminare corrisponde
-- all'ultimo assegnato
  if a_fascia_old = 2 and a_fascia_new != 2 then
     begin
       select numero
         into w_numero
	   from anan01
	  where cod_num = 'FRC'
	 ;
       if w_numero = a_progr_eliminazione_old then
	    begin
	      update anan01
		   set numero  = numero - 1
	       where cod_num = 'FRC'
	      ;
	    end;
       end if;
     exception
	 when no_data_found then
		null;
     end;
     a_progr_eliminazione_new := null;
  end if;
-- caso 3: modifica del progr_eliminazione
-- aggiornamento del numeratore (anan01.numero = :new)
-- se il progressivo modificato (:old) corrisponde
-- all'ultimo numero memorizzato
  if nvl(a_progr_eliminazione_old,0) != a_progr_eliminazione_new and
     a_fascia_new = 2 and a_fascia_old = 2
  then
     begin
       select numero
         into w_numero
	   from anan01
	  where cod_num = 'FRC'
	 ;
       if nvl(w_numero,0) < a_progr_eliminazione_new then
	    begin
	      update anan01
	         set numero  = a_progr_eliminazione_new
  	       where cod_num = 'FRC'
	      ;
          end;
       end if;
     exception
 	 when no_data_found then
  	      begin
		  insert into anan01
		         (cod_num, numero)
	 	  values ('FRC', a_progr_eliminazione_new);
	      end;
     end;
  end if;
-- FAC: Famiglie A.I.R.E. Cancellate
-- caso 1: cancellazione di famiglia
-- (passaggio da "fascia = 3" a "fascia = 4")
-- assegnazione di progr_eliminazione
  if a_fascia_old = 3 and a_fascia_new = 4 then
     begin
       select numero + 1
         into w_progr_eliminazione
	   from anan01
	  where cod_num = 'FAC'
	 ;
	 update anan01
	    set numero  = numero + 1
	  where cod_num = 'FAC'
	 ;
     exception
	 when no_data_found then
  	      begin
		  insert into anan01
		         (cod_num, numero)
	 	  values ('FAC', 1);
	      end;
		w_progr_eliminazione := 1;
     end;
     a_progr_eliminazione_new := w_progr_eliminazione;
  end if;
-- caso 2: modifica da "fascia = 4" ad altra fascia
-- aggiornamento del numeratore (anan01.numero - 1)
-- se il progressivo che si va ad eliminare corrisponde
-- all'ultimo assegnato
  if a_fascia_old = 4 and a_fascia_new != 4 then
     begin
       select numero
         into w_numero
	   from anan01
	  where cod_num = 'FAC'
	 ;
       if w_numero = a_progr_eliminazione_old then
	    begin
	      update anan01
		   set numero  = numero - 1
	       where cod_num = 'FAC'
	      ;
	    end;
       end if;
     exception
	 when no_data_found then
		null;
     end;
     a_progr_eliminazione_new := null;
  end if;
-- caso 3: modifica del progr_eliminazione
-- aggiornamento del numeratore (anan01.numero = :new)
-- se il progressivo modificato (:old) corrisponde
-- all'ultimo numero memorizzato
  if nvl(a_progr_eliminazione_old,0) != a_progr_eliminazione_new and
     a_fascia_new = 4 and a_fascia_old = 4
  then
     begin
       select numero
         into w_numero
	   from anan01
	  where cod_num = 'FAC'
	 ;
       if nvl(w_numero,0) < a_progr_eliminazione_new then
  	    begin
	      update anan01
	         set numero  = a_progr_eliminazione_new
  	       where cod_num = 'FAC'
	      ;
          end;
       end if;
     exception
 	 when no_data_found then
  	      begin
		  insert into anan01
		         (cod_num, numero)
	 	  values ('FAC', a_progr_eliminazione_new);
	      end;
     end;
  end if;
 end if;
end if;  -- if updating
END;
/
