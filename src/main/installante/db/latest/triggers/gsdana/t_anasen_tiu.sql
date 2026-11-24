--liquibase formatted sql
--changeset amonopoli:202511051240_2 runOnChange:true stripComments:false
create or replace trigger ANASEN_TIU
before INSERT
    or UPDATE
on ANASEN
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id           := F_ANASEN_NR(:new.id);

     if :new.anno_progr_mov is not null and :new.numero_progr_mov is not  null then
        :new.id_anamov := :new.anno_progr_mov||lpad(:new.numero_progr_mov,6,'0');
     end if;

      if INSERTING then
         if :new.data_decreto is null and :new.d_data_decreto is not null then
            :new.data_decreto := to_char(:new.d_data_decreto,'j');
         elsif :new.d_data_decreto is null and :new.data_decreto is not null then
            :new.d_data_decreto := to_date(:new.data_decreto,'j');
         end if;
         if :new.data_atto_tr is null and :new.d_data_atto_tr is not null then
            :new.data_atto_tr := to_char(:new.d_data_atto_tr,'j');
         elsif :new.d_data_atto_tr is null and :new.data_atto_tr is not null then
            :new.d_data_atto_tr := to_date(:new.data_atto_tr,'j');
         end if;
      end if;
 
      if UPDATING then
         if nvl(:old.data_decreto,0) != nvl(:new.data_decreto,0) then
            :new.d_data_decreto := to_date(:new.data_decreto,'j');
         elsif nvl(:old.d_data_decreto,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_decreto,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_decreto   := to_char(:new.d_data_decreto,'j');
         end if;
         if nvl(:old.data_atto_tr,0) != nvl(:new.data_atto_tr,0) then
            :new.d_data_atto_tr := to_date(:new.data_atto_tr,'j');
         elsif nvl(:old.d_data_atto_tr,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_atto_tr,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_atto_tr   := to_char(:new.d_data_atto_tr,'j');
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
/* End Trigger: ANASEN_TIU */
/
