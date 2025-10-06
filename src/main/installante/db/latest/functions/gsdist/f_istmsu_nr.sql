--liquibase formatted sql
--changeset amonopoli:202312151105_1 runOnChange:true stripComments:false
create or replace function F_ISTMSU_NR
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
         select ISTMSU_SQ.nextval
           into w_id
           from dual
         ;
       end;
   end if;

   return w_id;

end;
/
