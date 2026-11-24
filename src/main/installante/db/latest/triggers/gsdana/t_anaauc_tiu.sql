--liquibase formatted sql
--changeset amonopoli:202511111455_2 runOnChange:true stripComments:false
create or replace trigger ANAAUC_TIU
before INSERT
    or UPDATE
on ANAAUC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id           := F_ANAAUC_NR(:new.id);
     :new.version      := nvl(:new.version,0);

     :new.COGNOME_MOR        := nvl(:new.cognome_mor, f_cognome(:new.cognome_nome_mor));    
     :new.NOME_MOR           := nvl(:new.nome_mor, f_nome(:new.cognome_nome_mor));
     :new.D_DATA_NAS_MOR     := nvl(:new.d_data_nas_mor, to_date(:new.data_nas_mor,'j'));
     :new.D_DATA_MOR         := nvl(:new.d_data_mor, to_date(:new.data_mor,'j'));
     :new.D_DATA_CREMAZIONE  := nvl(:new.d_data_cremazione, to_date(:new.data_cremazione,'j'));      
     :new.D_DATA_AFFIDAMENTO := nvl(:new.d_data_affidamento, to_date(:new.data_affidamento,'j'));
     :new.D_DATA_REG         := nvl(:new.d_data_reg, to_date(:new.data_reg,'j'));

     :new.COGNOME_NOME_MOR   := nvl(:new.cognome_nome_mor, :new.cognome_mor||'/'||:new.nome_mor);
     :new.DATA_NAS_MOR     := nvl(:new.data_nas_mor, to_char(:new.d_data_nas_mor,'j'));
     :new.DATA_MOR         := nvl(:new.data_mor, to_char(:new.d_data_mor,'j'));
     :new.DATA_CREMAZIONE  := nvl(:new.data_cremazione, to_char(:new.d_data_cremazione,'j'));      
     :new.DATA_AFFIDAMENTO := nvl(:new.data_affidamento, to_char(:new.d_data_affidamento,'j'));
     :new.DATA_REG         := nvl(:new.data_reg, to_char(:new.d_data_reg,'j'));
     
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANAAUC_TIU */
/
