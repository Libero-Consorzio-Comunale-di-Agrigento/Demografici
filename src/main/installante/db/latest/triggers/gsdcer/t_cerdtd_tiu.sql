--liquibase formatted sql
--changeset snocca:202401191537_2 runOnChange:true stripComments:false
create or replace trigger CERDTD_TIU
before INSERT
    or UPDATE
on CERDTD
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   :new.id      := F_CERDTD_NR(:new.id);
   :new.version := nvl(:new.version,0);

   if :new.descrizione is null then
      if :new.cod_diritto = 1 then
         :new.descrizione := 'Diritti Segreteria';
      elsif :new.cod_diritto = 2 then
         :new.descrizione := 'Diritti Stato Civ.';
      elsif :new.cod_diritto = 3 then
         :new.descrizione := 'Carta d''Identita`';
      elsif :new.cod_diritto = 4 then
         :new.descrizione := 'Rimborso Stampati';
      elsif :new.cod_diritto = 9 then
         :new.descrizione := 'Bollo';
      end if;
   end if;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: CERDTD_TIU */
/

