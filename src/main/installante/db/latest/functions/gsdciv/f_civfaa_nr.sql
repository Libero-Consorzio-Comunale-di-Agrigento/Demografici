--liquibase formatted sql
--changeset snocca:202303231700 runOnChange:true stripComments:false
create or replace function F_CIVFAA_NR
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
         select CIVFAA_SQ.nextval
           into w_id
           from dual
         ;
       end;
    end if;

    return w_id;

end;
/* End Function: F_CIVFAA_NR */
/
