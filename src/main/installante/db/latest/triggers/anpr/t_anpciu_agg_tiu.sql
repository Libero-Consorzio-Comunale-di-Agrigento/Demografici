--liquibase formatted sql
--changeset amonopoli:202604211545 runOnChange:true stripComments:false
create or replace trigger ANPCIU_AGG_TIU
before INSERT
    or UPDATE
on ANPCIU_AGG
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
         if :new.DATA_DECORRENZA_ANPR is not null and :new.D_DATA_DECORRENZA_ANPR is null then -- forms11
            :new.D_DATA_DECORRENZA_ANPR     := to_date(:new.data_DECORRENZA_ANPR,'j');
         elsif :new.D_DATA_DECORRENZA_ANPR is not null and :new.DATA_DECORRENZA_ANPR is null then -- zk
            :new.DATA_DECORRENZA_ANPR       := to_char(:new.d_data_DECORRENZA_ANPR,'j');
         end if; 

      elsif UPDATING then
         if :old.D_DATA_DECORRENZA_ANPR is not null and :new.D_DATA_DECORRENZA_ANPR is null then
            :new.DATA_DECORRENZA_ANPR := '';
         elsif :old.DATA_DECORRENZA_ANPR is not null and :new.DATA_DECORRENZA_ANPR is null then
            :new.D_DATA_DECORRENZA_ANPR := '';
         elsif :old.D_DATA_DECORRENZA_ANPR is not null and :new.D_DATA_DECORRENZA_ANPR is not null and :old.D_DATA_DECORRENZA_ANPR != :new.D_DATA_DECORRENZA_ANPR then
            :new.DATA_DECORRENZA_ANPR := to_char(:new.D_DATA_DECORRENZA_ANPR,'j');
         elsif :old.DATA_DECORRENZA_ANPR is not null and :new.DATA_DECORRENZA_ANPR is not null and :old.DATA_DECORRENZA_ANPR != :new.DATA_DECORRENZA_ANPR then
            :new.D_DATA_DECORRENZA_ANPR := to_date(:new.DATA_DECORRENZA_ANPR,'j');
         end if;
      end if;
   end;


exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANPCIU_AGG_TIU */
/
