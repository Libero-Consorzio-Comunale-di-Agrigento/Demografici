--liquibase formatted sql
--changeset amonopoli:202503211125_3 runOnChange:true stripComments:false
create or replace function F_ISTMD4_NR
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
         select ISTMD4_SQ.nextval
           into w_id
           from dual
         ;
       end;
   end if;

   return w_id;

end;
/
