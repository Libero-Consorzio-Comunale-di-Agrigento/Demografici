--liquibase formatted sql
--changeset amonopoli:202412091640 runOnChange:true stripComments:false
create or replace trigger CERFCT_TIU
before INSERT
    or UPDATE
on CERFCT
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
    begin  -- Check DATA Integrity on INSERT or UPDATE
      if INSERTING then
      	 if :new.d_data is null then
            :new.d_data := trunc(sysdate);
         end if;
         if :new.data is null and :new.d_data is not null then  
            :new.data := to_number(to_char(trunc(:new.d_data),'j'))  ;
         end if;
      end if;
      if UPDATING then
         if :new.data != nvl(:old.data,0) then
            :new.d_data := to_date(:new.data,'j');
         elsif nvl(trunc(:new.d_data), to_date('01/01/1800','dd/mm/yyyy')) != 
		nvl(trunc(:old.d_data), to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data := to_number(to_char(trunc(:new.d_data),'j'));
         end if;
      end if;
    end;
end;
/
