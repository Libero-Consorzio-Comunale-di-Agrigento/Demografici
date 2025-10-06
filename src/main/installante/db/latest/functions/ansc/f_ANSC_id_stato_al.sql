--liquibase formatted sql
--changeset amonopoli:202305181139 runOnChange:true stripComments:false
create or replace function f_ANSC_id_stato_al
(A_COD_PROVINCIA	IN	NUMBER  
,A_COD_COMUNE		IN	NUMBER  
,A_DATA			IN	DATE
)

return varchar2

IS

w_data_j		number;

w_cod_stato		number;
w_id_stato		number;

w_des_stato_anpr  varchar2(255);
w_des_stato_ads   varchar2(255);

begin
  if a_cod_provincia||a_cod_comune is not null then
     w_data_j   := to_char(nvl(a_data,trunc(sysdate)),'j');
     if (a_cod_provincia >= 201 and a_cod_provincia not in (701,702,703))
         or (a_cod_provincia in (701,702,703) and a_cod_comune < 500) 
     then
        w_cod_stato := f_ANPR_luogo(a_cod_provincia,a_cod_comune,w_data_j,3,3);
        w_des_stato_anpr := f_ANPR_luogo(a_cod_provincia,a_cod_comune,w_data_j,3,2);
        w_des_stato_ads  := f_stato_estero_al(a_cod_provincia,a_cod_comune,w_data_j);
        if w_des_stato_anpr != nvl(w_des_stato_ads,w_des_stato_anpr) then
           w_id_stato := 200;
        end if;
     else
        w_cod_stato := '100';
     end if;
  end if;

  if w_id_stato is null then
     begin
       select id 
         into w_id_stato
         from anpt02
        where codice = w_cod_stato
          and w_data_j between nvl(data_inizio_validita,1111111) and nvl(data_fine_validita,9999999)
       ;
     exception
       when others then
            w_id_stato := '';
     end;
  end if;

  return w_id_stato;

end;
/
