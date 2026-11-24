--liquibase formatted sql
--changeset amonopoli:202510271405_1 runOnChange:true stripComments:false
create or replace function F_ANATPR_ALLE_NR
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
         select ANATPR_ALLE_SQ.nextval
           into w_id
           from dual
         ;
       end;
    end if;

    return w_id;

end;
/* End Function: F_ANATPR_ALLE_NR */
/
