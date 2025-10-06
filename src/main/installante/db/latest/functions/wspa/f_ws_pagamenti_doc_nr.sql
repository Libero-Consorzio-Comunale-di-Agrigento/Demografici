--liquibase formatted sql
--changeset amonopoli:202501131620_1 runOnChange:true stripComments:false
create or replace function F_WS_PAGAMENTI_DOC_NR
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
         select WS_PAGAMENTI_DOC_SQ.nextval
           into w_id
           from dual
         ;
       end;
   end if;

   return w_id;

end;
/* End Procedure: F_WS_PAGAMENTI_DOC_NR */
/
