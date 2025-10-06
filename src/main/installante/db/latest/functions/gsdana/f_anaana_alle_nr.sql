--liquibase formatted sql
--changeset amonopoli:202503071555_2 runOnChange:true stripComments:false
create or replace function F_ANAANA_ALLE_NR
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
         select ANAANA_ALLE_SQ.nextval
           into w_id
           from dual
         ;
       end;
    end if;

    return w_id;

end;
/* End Function: F_ANAANA_ALLE_NR */
/
