--liquibase formatted sql
--changeset amonopoli:202606091055_2 runOnChange:true stripComments:false
create or replace trigger ANASAP_TIU
before INSERT
    or UPDATE
on ANASAP
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   :new.id         := f_anasap_nr(:new.id);
   :new.id_pratica := f_ANA_get_id_pratica(:new.anagrafe,:new.tipo_evento,:new.anno_pratica,:new.pratica);

   begin
     select tpr.id
       into :new.id_anatpr
       from anatpr tpr
      where id_pratica = :new.id_pratica
        and rownum = 1
     ;
   exception
     when others then
--          raise_application_error(-20999, 'id_anatpr non trovato ('||sqlerrm||')');
          null;
   end;


   begin  -- Check DATA Integrity on INSERT or UPDATE
      if INSERTING then
         if :new.data_reg is null and :new.d_data_reg is null then
            :new.data_reg := to_char(sysdate,'j');
            :new.d_data_reg := sysdate;
         elsif :new.data_reg is not null and :new.d_data_reg is null then
            :new.d_data_reg := to_date(:new.data_reg,'j');
         elsif :new.d_data_reg is not null and :new.data_reg is null then
            :new.data_reg := to_char(:new.d_data_reg,'j');
         end if;
         if :new.data_evento is not null and :new.d_data_evento is null then
            :new.d_data_evento := to_date(:new.data_evento,'j');
         elsif :new.d_data_evento is not null and :new.data_evento is null then
            :new.data_evento := to_char(:new.d_data_evento,'j');
         end if;
         if :new.data_restituzione is not null and :new.d_data_restituzione is null then
            :new.d_data_restituzione := to_date(:new.data_restituzione,'j');
         elsif :new.d_data_restituzione is not null and :new.data_restituzione is null then
            :new.data_restituzione := to_char(:new.d_data_restituzione,'j');
         end if;
      end if;

      if UPDATING then
         if nvl(:old.data_reg,0) != nvl(:new.data_reg,0) then
            :new.d_data_reg          := to_date(:new.data_reg,'j');
         elsif nvl(:old.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_reg            := to_char(:new.d_data_reg,'j');
         end if;
         if nvl(:old.data_evento,0) != nvl(:new.data_evento,0) then
            :new.d_data_evento          := to_date(:new.data_evento,'j');
         elsif nvl(:old.d_data_evento,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_evento,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_evento            := to_char(:new.d_data_evento,'j');
         end if;
         if nvl(:old.data_restituzione,0) != nvl(:new.data_restituzione,0) then
            :new.d_data_restituzione          := to_date(:new.data_restituzione,'j');
         elsif nvl(:old.d_data_restituzione,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_restituzione,to_date('01/01/1800','dd/mm/yyyy')) then
            :new.data_restituzione            := to_char(:new.d_data_restituzione,'j');
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
/
