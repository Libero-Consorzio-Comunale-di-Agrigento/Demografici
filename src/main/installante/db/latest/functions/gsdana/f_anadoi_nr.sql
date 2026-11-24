--liquibase formatted sql
--changeset amonopoli:202606100955_1 runOnChange:true stripComments:false
create or replace function F_ANADOI_NR
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
         select ANADOI_SQ.nextval
           into w_id
           from dual
         ;
       end;
   end if;

   return w_id;

end;
/* End Procedure: F_ANADOI_NR */
/
