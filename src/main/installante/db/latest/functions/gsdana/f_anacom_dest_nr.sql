--liquibase formatted sql
--changeset amonopoli:202512041100_1 runOnChange:true stripComments:false
create or replace function F_ANACOM_DEST_NR
(a_id		IN 	number)

return number

IS

w_id		number;

begin
  if a_id is null then
     begin 
       select ANACOM_DEST_SQ.nextval
         into w_id
         from dual
       ;
     end;
  else
     w_id := a_id;
  end if;

  return w_id;

end;
/
