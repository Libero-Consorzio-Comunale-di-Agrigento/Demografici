--liquibase formatted sql
--changeset amonopoli:202412060935_1 runOnChange:true stripComments:false
create or replace function F_ANADOC_NR
( a_id	IN	number
)

return number

IS

w_id	number;

begin
  if a_id is not null then
     w_id := a_id;

  elsif a_id is null then
     begin 
       select ANADOC_SQ.nextval
         into w_id
         from dual
       ;
     end;
  end if;

  return w_id;

end;
/* End Procedure: F_ANADOC_NR */
/
