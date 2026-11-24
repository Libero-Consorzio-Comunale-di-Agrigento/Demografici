--liquibase formatted sql
--changeset amonopoli:202606081520_2 runOnChange:true stripComments:false
create or replace procedure CIE_AGGIORNA_DOC 
	(a_TipoOperazione	IN	varchar2,
	 a_NumeroCarta		IN	varchar2,
	 a_Motivazione		IN	varchar2,
	 a_DataProvvedimento	IN	varchar2
	)
is
w_matricola	number;
w_numero_doc	varchar2(255);
w_motivo	number;
w_max_cod_md	number;
w_campo		varchar2(1);

begin
-- dbms_output.put_line('tipo_op '||a_TipoOperazione);
-- dbms_output.put_line('numero '||a_NumeroCarta);
 begin
   select matricola, numero
     into w_matricola, w_numero_doc
     from anadoc
    where tipo_documento	= 'CE'
      and numero		= a_NumeroCarta
   ;
 exception
   when no_data_found then
	  raise_application_error
	    (-20999,'[CIE N.'||a_NumeroCarta||' - '||
			'Nessun documento corrispondente al Numero della Carta');
   when too_many_rows then
	  raise_application_error
	    (-20999,'[CIE N.'||a_NumeroCarta||' - '||
			'Esistono piu'' individui collegati allo stesso Numero di Carta');
   when others then
	  raise_application_error
	    (-20999,'[CIE N.'||a_NumeroCarta||' - '||
			'Errore in ricerca documenti ('||SQLERRM||')');
 end;
 
 if a_TipoOperazione in ('A','R') and a_NumeroCarta is not null then
  begin
    select cod_md
      into w_motivo
      from anadmd
--     where descrizione  = substr(a_motivazione,1,30)
     where cod_md	= 50 + to_number(a_motivazione)
       and rownum 	= 1
    ;
  exception
    when no_data_found then
	 w_motivo := '';
    when others then
 	 w_motivo := '';
  end;
 
  if w_motivo is null then
     begin
       select nvl(max(cod_md),0)
         into w_max_cod_md
	 from anadmd
       ;
     exception
       when no_data_found then
	    w_max_cod_md := 0;
       when others then
	    w_max_cod_md := 99;
     end;

     if w_max_cod_md < 99 then
	w_motivo := w_max_cod_md + 1;
        begin
	  insert into anadmd (cod_md, descrizione)
	  values (w_motivo, substr(a_motivazione,1,30))
	  ;
        exception
	  when others then
       	       ROLLBACK;
	       raise_application_error
	         (-20999,'[CIE N.'||a_NumeroCarta||' - '||
			 'Errore in inserimento Motivo Documento ('||SQLERRM||')');
	end;
     end if;
  end if;

  begin
    update anadoc
       set natura_documento 	= 'A',
	   motivo_documento	= w_motivo,
	   data_reg		= to_char(to_date(a_DataProvvedimento,'dd/mm/yyyy'),'j')
     where matricola		= w_matricola
       and tipo_documento	= 'CE'
       and numero		= a_NumeroCarta
    ;
    if SQL%NOTFOUND then
       ROLLBACK;
 	 raise_application_error
 	   (-20999,'[CIE N.'||a_NumeroCarta||' - '||
		     'Errore in aggiornamento documento');
    end if;
  exception
    when others then
         ROLLBACK;
	   raise_application_error
 	     (-20999,'[CIE N.'||a_NumeroCarta||' - '||
			 'Errore in aggiornamento documento Annullato/Revocato ('||SQLERRM||')');
  end;
  COMMIT;
 end if;
end;
/
