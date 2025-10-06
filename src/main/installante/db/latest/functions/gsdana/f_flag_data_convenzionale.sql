--liquibase formatted sql
--changeset amonopoli:202509161250 runOnChange:true stripComments:false
create or replace function f_flag_data_convenzionale
(a_matricola		number
,a_cod_mov		number
,a_data			number
)

return varchar2

IS

w_data_ads	varchar2(255);
w_data		varchar2(255);
w_campo		number;
w_asterisco	number := 0;

w_return	varchar2(1);

begin
  begin
    select substr(inp.valore,1,10)
      into w_data_ads
      from arcinp inp
     where inp.parametro	= 'DATA_ADS'
    ;
  exception
    when others then
	 w_data_ads 	:= '00/00/0000';
  end;
  
  w_data := to_char(to_date(a_data,'j'),'dd/mm/yyyy');

  if w_data_ads = w_data then
    if a_cod_mov in (10,12) then
       begin
	 select 1 
	   into w_campo 
	   from dual
	  where exists (select 'x' from anaeve b	
		 	 where b.matricola	= a_matricola
			   and b.cod_mov 	in (10,12)
			   and b.data_eve 	= a_data - 1)
	     or exists (select 'x' from anaeve b
			 where b.matricola 	= a_matricola
			   and b.cod_mov 	in (1,3)
			   and b.data_eve 	= a_data)
	     or exists (select 'x' from anaana b		
			 where b.matricola	= a_matricola
			   and b.data_nas  	= a_data)
	 ;
       exception
	 when no_data_found then
	      w_asterisco := 1;
       end;

    elsif a_cod_mov in (11,13) then
       begin
	 select 1 into w_campo 
	   from dual	
	  where exists (select 'x' from anaeve b
			 where b.matricola	= a_matricola
			   and b.cod_mov 	in (11,13)
			   and b.data_eve 	= a_data - 1)
	     or exists (select 'x' from anaeve b
			 where b.matricola 	= a_matricola
			   and b.cod_mov 	in (1,3)
		 	   and b.data_eve 	= a_data)	
	     or exists (select 'x' from anaana b		
			 where b.matricola	= a_matricola
			   and b.data_nas  	= a_data)
	 ;
       exception
	 when no_data_found then
	      w_asterisco := 1;
       end;
    end if;

    if w_asterisco = 1 then
       w_return := 'S';
    end if;
  end if;
  
  return w_return;
end;
/
