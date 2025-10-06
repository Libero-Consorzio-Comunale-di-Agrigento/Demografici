--liquibase formatted sql
--changeset amonopoli:202310201855 runOnChange:true stripComments:false
create or replace function f_ANSC_get_comune_x_id
(A_ID_COMUNE		IN	number
)

return varchar2

IS

w_comune		varchar2(255);

begin
  begin
    select t.descrizione_it
      into w_comune
      from anpt03 t
     where codice = a_id_comune
       and rownum = 1
    ;
  exception
    when others then 
         w_comune := '';
  end;

  return w_comune;
end;
/
