--liquibase formatted sql
--changeset amonopoli:202606101210_1 runOnChange:true stripComments:false
create or replace function F_ANAC01_NR
( a_id		number
)

return number

is

w_id	number;

begin
   if a_id is not null then
      w_id := a_id;
   else
       begin 
         select ANAC01_SQ.nextval
           into w_id
           from dual
         ;
       end;
   end if;

   return w_id;

end;
/* End Procedure: F_ANAC01_NR */
/
