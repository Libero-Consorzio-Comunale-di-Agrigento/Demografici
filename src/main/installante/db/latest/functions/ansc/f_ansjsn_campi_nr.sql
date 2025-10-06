--liquibase formatted sql
--changeset amonopoli:202304281630_2 runOnChange:true stripComments:false
create or replace function F_ANSJSN_CAMPI_NR
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
       select ANSJSN_CAMPI_SQ.nextval
         into w_id
         from dual
       ;
     end;
  end if;

  return w_id;

end;
/* End Procedure: ANSJSN_CAMPI_NR */
/

	