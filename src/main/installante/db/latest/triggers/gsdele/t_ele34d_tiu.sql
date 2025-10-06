--liquibase formatted sql
--changeset amonopoli:202501081525_2 runOnChange:true stripComments:false
create or replace trigger ELE34D_TIU
before INSERT or UPDATE
on ELE34D
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
--dbms_output.put_line('dentro il trigger');
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id := F_ELE34D_NR(:new.id);

     if instr(:new.nome_allegato,'\') > 0 then
        :new.nome_allegato := substr(:new.nome_allegato,instr(:new.nome_allegato,'\',-1)+1);
     elsif instr(:new.nome_allegato,'/') > 0 then
        :new.nome_allegato := substr(:new.nome_allegato,instr(:new.nome_allegato,'/',-1)+1);
     end if;
     if instr(:new.nome_indice,'\') > 0 then
        :new.nome_indice := substr(:new.nome_indice,instr(:new.nome_indice,'\',-1)+1);
     elsif instr(:new.nome_indice,'/') > 0 then
        :new.nome_indice := substr(:new.nome_indice,instr(:new.nome_indice,'/',-1)+1);
     end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
      null;
   end;

   begin  -- Set REFERENTIAL Integrity on UPDATE
      null;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      null;
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
