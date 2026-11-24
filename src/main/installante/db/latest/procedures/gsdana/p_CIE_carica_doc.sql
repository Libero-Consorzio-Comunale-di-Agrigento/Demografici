--liquibase formatted sql
--changeset amonopoli:202606081520_1 runOnChange:true stripComments:false
create or replace procedure CIE_CARICA_DOC 
	(a_TipoOperazione		IN	varchar2,
	 a_NumeroCarta		IN	varchar2,
	 a_Cognome			IN	varchar2,
	 a_Nome			IN	varchar2,
	 a_ComuneNascita		IN	varchar2,
	 a_DataNascita		IN	varchar2,
	 a_Sesso			IN	varchar2,
	 a_Statura			IN	varchar2,
	 a_EstremiNascita		IN	varchar2,
	 a_ComuneResidenza	IN	varchar2,
	 a_Tipo			IN	varchar2,
	 a_Indirizzo		IN	varchar2,
	 a_NumCiv			IN	varchar2,
	 a_Cap			IN	varchar2,
	 a_Cittadinanza		IN	varchar2,
	 a_CodiceFiscale		IN	varchar2,
	 a_ValidoEspatrio		IN	varchar2,
	 a_DataEmissione		IN	varchar2,
	 a_DataScadenza		IN	varchar2
	)
is
w_matricola		number;
w_campo		varchar2(1);
begin

--   ??? "Id_Operatore": "VLTMRA67A52L682X",
-- a_TipoOperazione	IN	varchar2,
-- a_NumeroCarta	IN	varchar2,	-- "NumeroCarta": "CA30132TP",
--   ??? "Motivazione": "4",
-- a_Cognome		IN	varchar2,	-- "Cognome": "DI GRAZIA",
--   ??? "CognomeAnagTrib": "DI GRAZIA",
-- a_Nome		IN	varchar2,	-- "Nome": "DAVIDE",
--   ??? "NomeAnagTrib": "DAVIDE",
-- a_ComuneNascita	IN	varchar2,	-- "ComuneNascita": "D423",
--   ??? "StatoEstero": "",
-- a_DataNascita	IN	varchar2,	-- "DataNascita": "21-08-2005",
-- a_Sesso		IN	varchar2,	-- "Sesso": "M",
-- a_Statura		IN	varchar2,	-- "Statura": "171",
-- a_EstremiNascita	IN	varchar2,	-- "EstremiNascita": "373 p1 sA-2005 081021",
-- a_ComuneResidenza	IN	varchar2,	-- "ComuneResidenza": "L331",
-- a_Tipo		IN	varchar2,	-- "Domicilio": {"Tipo": "VIALE",
-- a_Indirizzo		IN	varchar2,	-- "Domicilio": {"Indirizzo": "EMILIA ROMAGNA",
-- a_NumCiv		IN	varchar2,	-- "Domicilio": {"NumCiv": "N. 1 C",
-- a_Cap		IN	varchar2,	-- "Domicilio": {"CAP": "91100"
-- a_Cittadinanza	IN	varchar2,	-- "Cittadinanza": "ITA",
-- a_CodiceFiscale	IN	varchar2,	-- "CodFis": "DGRDVD05M21D423G",
--   ??? "DatiAggiuntivi": "",
-- a_ValidoEspatrio	IN	varchar2,	-- "ValidoEspatrio": "S",
-- a_DataEmissione	IN	varchar2,	-- "DataEmissione": "30-09-2024",
-- a_DataScadenza	IN	varchar2 	-- "DataScadenza": "21-08-2034",
--   ??? "DataProvvedimento": "30-09-2024"

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
    update anadoc
	 set progr_documento 	= progr_documento + 1
     where matricola		= w_matricola
	 and tipo_documento	= 'CE'
    ;
  exception
    when others then
         ROLLBACK;
	   raise_application_error
 	     (-20999,'[CIE N.'||a_NumeroCarta||' - '||
		 	 'C.F. '||a_CodiceFiscale||'] '||
			 'Errore in aggiornamento progressivo documento ('||SQLERRM||')');
  end;
  begin
    insert into anadoc
	    (matricola, tipo_documento, progr_documento, natura_documento,
	     ente_emissione, data_emissione, cod_pro_ente, cod_com_ente,
	     numero, data_scadenza, espatrio)
    select w_matricola,
	     'CE',
	     1,
	     'O',
	     1,
	     to_char(to_date(a_DataEmissione,'dd/mm/yyyy'),'j'),
	     pro_cliente,
	     com_cliente,
	     a_NumeroCarta,
	     to_char(to_date(a_DataScadenza,'dd/mm/yyyy'),'j'),
	     decode(rtrim(a_ValidoEspatrio),'TRUE','S','VERO','S','S','S','1','S','T','S','')
	from menuditta
     where rownum 	= 1
    ;
  exception
    when others then
	   ROLLBACK;
	   raise_application_error
 	     (-20999,'[CIE N.'||a_NumeroCarta||' - '||
		 	 'C.F. '||a_CodiceFiscale||'] '||
			 'Errore in inserimento documento ('||SQLERRM||')');
  end;
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
	     insert into anadcn (matricola, statura)
	     values (w_matricola, a_Statura)
	     ;
	   exception
	     when others then
  	          ROLLBACK;
		    raise_application_error
 	     	      (-20999,'[CIE N.'||a_NumeroCarta||' - '||
		 	        'C.F. '||a_CodiceFiscale||'] '||
			        'Errore in inserimento connotati ('||SQLERRM||')');
	   end;
    when too_many_rows then
	   begin
	     update anadcn
		  set statura	= a_Statura
		where matricola	= w_matricola
	     ;
	   exception
	     when others then
  	          ROLLBACK;
		    raise_application_error
 	     	      (-20999,'[CIE N.'||a_NumeroCarta||' - '||
		 	        'C.F. '||a_CodiceFiscale||'] '||
			        'Errore in aggiornamento connotati ('||SQLERRM||')');
	   end;
  end;
  COMMIT;
 end if;
end;
/
