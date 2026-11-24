--liquibase formatted sql
--changeset amonopoli:202402051325_1 runOnChange:true stripComments:false
create or replace function f_provincia_stato
	(a_cod_provincia	number,
	 a_cod_comune		number,
	 a_sigla_provincia	varchar2,
	 a_flag_sigla_pro	varchar2,
	 a_flag_parentesi	varchar2)

return varchar2

IS

w_descrizione		varchar2(255);
w_provincia_stato	varchar2(255);

begin
  if a_cod_provincia in (199,999) then
     w_provincia_stato	:= a_sigla_provincia;

  elsif a_cod_provincia > 200 then
     if a_cod_provincia in (701,702,703) and a_cod_comune >= 500 then
	if a_cod_provincia = 701 then
	   w_descrizione 	:= 'FIUME';
	elsif a_cod_provincia = 702 then
	   w_descrizione	:= 'POLA';
	elsif a_cod_provincia = 703 then
	   w_descrizione	:= 'ZARA';
 	end if;
     else
        begin
          select nvl(a.descrizione_al1,a.descrizione)
	    into w_descrizione
	    from arccom a
	   where a.cod_provincia = a_cod_provincia
	     and a.cod_comune	 = 0
	     and a_cod_comune	 > 0
          ;
        exception
          when others then
	       w_descrizione := null; 
        end;
     end if;
     
     w_provincia_stato := nvl(w_descrizione, a_sigla_provincia);

  else

     if a_flag_sigla_pro is null then
        begin
          select a.descrizione
   	    into w_descrizione
  	    from arcpro a
  	   where a.cod_provincia	= a_cod_provincia
          ;
        exception
          when others then
	       w_descrizione := null;
        end;
     else
        w_descrizione := null;
     end if;
        
     w_provincia_stato	:= nvl(w_descrizione, a_sigla_provincia);

  end if;

  if a_flag_parentesi = 'S' and w_provincia_stato is not null then
     w_provincia_stato 	:= '('||w_provincia_stato||')';
  end if;

  return w_provincia_stato;

end;
/
