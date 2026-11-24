--liquibase formatted sql
--changeset amonopoli:202606081520_3 runOnChange:true stripComments:false
create or replace procedure CIE_CARICA_DCN
(a_TipoOperazione	IN	varchar2
,a_NumeroCarta		IN	varchar2
,a_CodiceFiscale	IN	varchar2
,a_Statura		IN	varchar2
,a_Foto			IN	BLOB
)

IS

w_matricola		number;
w_campo		varchar2(1);

begin
-- dbms_output.put_line('tipo_op '||a_TipoOperazione);
-- dbms_output.put_line('numero '||a_NumeroCarta);
-- dbms_output.put_line('CF '||a_CodiceFiscale);
 begin
   select matricola
     into w_matricola
     from anaana
    where cod_fiscale	= a_CodiceFiscale
      and fascia 	in (1,3)
   UNION
   select matricola
     from anaana ana
    where cod_fiscale	= a_CodiceFiscale
      and fascia 	= 6
      and not exists (select 'x' from anaana ana_1
                       where ana_1.cod_fiscale = ana.cod_fiscale
                         and ana_1.fascia      in (1,3))
   ;
 exception
   when no_data_found then
	  raise_application_error
	    (-20999,'[CIE N.'||a_NumeroCarta||' - '||
			'C.F. '||a_CodiceFiscale||'] '||
			'Nessun individuo residente corriponde al Codice Fiscale');
   when too_many_rows then
	  raise_application_error
	    (-20999,'[CIE N.'||a_NumeroCarta||' - '||
			'C.F. '||a_CodiceFiscale||'] '||
			'Esistono piu'' individui residenti corripondenti al Codice Fiscale');
   when others then
	  raise_application_error
	    (-20999,'[CIE N.'||a_NumeroCarta||' - '||
			'C.F. '||a_CodiceFiscale||'] '||
			'Errore in ricerca individuo ('||SQLERRM||')');
 end;

 if a_TipoOperazione = 'C' then
-- dbms_output.put_line('tipo = C');
    begin
      select 'x'
        into w_campo
        from anadcn
       where matricola 	= w_matricola
      ;
      raise too_many_rows;
    exception
      when no_data_found then
     	   begin
	     insert into anadcn (matricola, FOTO_CIE)
	     values (w_matricola, a_FOTO)
	     ;
	   exception
	     when others then
  	          ROLLBACK;
		    raise_application_error
 	     	      (-20999,'[CIE N.'||a_NumeroCarta||' - '||
		 	        'C.F. '||a_CodiceFiscale||'] '||
			        'Errore in inserimento foto ('||SQLERRM||')');
	   end;
      when too_many_rows then
	   begin
	     update anadcn
		set foto_CIE = empty_blob()
             where matricola	= w_matricola
	     ;
	     update anadcn
		set foto_CIE = a_FOTO
             where matricola	= w_matricola
	     ;
	   exception
	     when others then
  	          ROLLBACK;
		    raise_application_error
 	     	      (-20999,'[CIE N.'||a_NumeroCarta||' - '||
		 	        'C.F. '||a_CodiceFiscale||'] '||
			        'Errore in aggiornamento foto ('||SQLERRM||')');
	   end;
     end;
     COMMIT;
 end if;
end;
/
