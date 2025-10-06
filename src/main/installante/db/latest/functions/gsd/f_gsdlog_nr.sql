--liquibase formatted sql
--changeset amonopoli:202506111230_1 runOnChange:true stripComments:false
create or replace function F_GSDLOG_NR
(a_id		IN 	number
)

return number

IS

w_anno		number;
w_numero	number;

w_id		number;

begin
   if a_id is not null then
      w_id := a_id;
   else
       begin 
         select GSDLOG_SQ.nextval
           into w_id
           from dual
         ;
       end;
    end if;

    return w_id;

end;
/
