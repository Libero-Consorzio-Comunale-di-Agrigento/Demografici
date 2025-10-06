--liquibase formatted sql
--changeset amonopoli:202304281630_3 runOnChange:true stripComments:false
create or replace function F_ANSJSN_SEZIONI_NR
(a_id		IN 	number
)

return number

IS

w_id	number;

begin
  if a_id is not null then
     w_id := a_id;
  else
     begin 
       select ANSJSN_SEZIONI_SQ.nextval
         into w_id
         from dual
       ;
     end;
  end if;

  return w_id;

end;
/* End Procedure: f_ANSJSN_SEZIONI_NR */
/
