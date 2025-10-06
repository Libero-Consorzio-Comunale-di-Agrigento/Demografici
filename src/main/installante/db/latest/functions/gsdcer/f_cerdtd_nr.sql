--liquibase formatted sql
--changeset snocca:202401191537_3 runOnChange:true stripComments:false
create or replace function F_CERDTD_NR
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
         select CERDTD_SQ.nextval
           into w_id
           from dual
         ;
       end;
   end if;

   return w_id;

end;
/
