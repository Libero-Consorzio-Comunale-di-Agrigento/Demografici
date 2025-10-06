--liquibase formatted sql
--changeset amonopoli:202402051325_2 runOnChange:true stripComments:false
create or replace function f_provincia_stato_al
	(a_cod_provincia		number,
	 a_cod_comune		number,
	 a_sigla_provincia	varchar2,
	 a_flag_sigla_pro		varchar2,
	 a_flag_parentesi		varchar2,
	 a_data_rif			number)
return varchar2
IS
w_descrizione		varchar2(255);
w_sigla_provincia		varchar2(255);
b_sigla_provincia		varchar2(255);
w_provincia_stato		varchar2(255);
begin
  if a_sigla_provincia is null then
     begin
       select sigla_provincia 
         into b_sigla_provincia 
         from arccom
        where cod_provincia = a_cod_provincia
          and cod_comune    = a_cod_comune
       ;
     exception
       when others then
            null;
     end;

  else
     b_sigla_provincia := a_sigla_provincia;
  end if;

  if a_data_rif is not null then
     if a_cod_provincia < 199 then
        begin
          select s.descrizione, s.sigla_provincia
            into w_descrizione, w_sigla_provincia
            from arcpro_storico s
    	   where s.cod_provincia = a_cod_provincia
             and a_data_rif	 between s.data_inizio_validita
                                     and s.data_fine_validita
             and a_cod_provincia < 199
          ;
        exception
          when others then
               w_provincia_stato := f_provincia_stato(a_cod_provincia,a_cod_comune,b_sigla_provincia,a_flag_sigla_pro,a_flag_parentesi);
               goto fine;
        end;

        if a_flag_sigla_pro is null then
           w_provincia_stato	:= nvl(w_descrizione, b_sigla_provincia);
        else
           w_provincia_stato 	:= nvl(w_sigla_provincia, b_sigla_provincia);
        end if;
 
        if a_flag_parentesi = 'S' and w_provincia_stato is not null then
           w_provincia_stato 	:= '('||w_provincia_stato||')';
        end if;

        goto fine;

     elsif a_cod_provincia between 201 and 799 then
        begin
          select s.descrizione, s.sigla
            into w_descrizione, w_sigla_provincia
            from arcsta_storico s
    	   where s.cod_stato    = a_cod_provincia
             and a_data_rif	 between s.data_inizio_validita
                                     and s.data_fine_validita
             and a_cod_provincia between 201 and 799
          ;
        exception
          when others then
               w_provincia_stato := f_provincia_stato(a_cod_provincia,a_cod_comune,b_sigla_provincia,a_flag_sigla_pro,a_flag_parentesi);
               goto fine;
        end;

        w_provincia_stato	:= nvl(w_descrizione, b_sigla_provincia);

        if a_flag_parentesi = 'S' and w_provincia_stato is not null then
           w_provincia_stato 	:= '('||w_provincia_stato||')';
        end if;

        goto fine;

     else
        w_provincia_stato := f_provincia_stato(a_cod_provincia,a_cod_comune,b_sigla_provincia,a_flag_sigla_pro,a_flag_parentesi);
        goto fine;
     end if;

  else
     w_provincia_stato := f_provincia_stato(a_cod_provincia,a_cod_comune,b_sigla_provincia,a_flag_sigla_pro,a_flag_parentesi);
     goto fine;
  end if;
<< fine >>
  return w_provincia_stato;
end;
/
