--liquibase formatted sql
--changeset amonopoli:202303091300_1 runOnChange:true stripComments:false
create or replace function F_CIVDDO_NR
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
         select CIVDDO_SQ.nextval
           into w_id
           from dual
         ;
       end;
    end if;

    return w_id;

end;
/* End Function: F_CIVDDO_NR */
/
