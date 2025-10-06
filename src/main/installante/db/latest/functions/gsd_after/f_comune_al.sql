--liquibase formatted sql
--changeset amonopoli:202402051320 runOnChange:true stripComments:false
create or replace function f_comune_al
	(a_cod_provincia	number,
	 a_cod_comune		number,
	 a_data			number) 
return varchar2
IS
w_flag_vcos		varchar2(10);
w_des			varchar2(255);

begin
  if a_data is not null then
     begin
       select nvl(sto.descrizione_al1,sto.descrizione)
         into w_des
         from arccom_storico sto
        where sto.cod_provincia     = a_cod_provincia
          and sto.cod_comune         = a_cod_comune
          and a_data  between nvl(data_inizio_validita,1111111)
                            and nvl(data_fine_validita,9999999)
       ;
     exception
       when others then
            w_des := null;
     end;
  end if;

  if w_des is null then
     begin
       select nvl(com.descrizione_al1,com.descrizione)
         into w_des
         from arccom com
        where com.cod_provincia = a_cod_provincia
          and com.cod_comune    = a_cod_comune
          and rownum = 1
       ;
     EXCEPTION 
       when no_data_found then
            w_des := null;
     end;
  end if;

  return w_des;
end;
/
