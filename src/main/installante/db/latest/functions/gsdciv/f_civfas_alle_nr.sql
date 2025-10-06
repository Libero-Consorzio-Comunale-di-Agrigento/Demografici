--liquibase formatted sql
--changeset amonopoli:202304051705_1 runOnChange:true stripComments:false
create or replace function F_CIVFAS_ALLE_NR
( a_id		number
)

return number

IS

w_id	number;

begin
   if a_id is not null then
      w_id := a_id;
   else
       begin 
         select CIVFAS_ALLE_SQ.nextval
           into w_id
           from dual
         ;
       end;
    end if;

    return w_id;

end;
/* End Function: F_CIVFAS_ALLE_NR */
/
