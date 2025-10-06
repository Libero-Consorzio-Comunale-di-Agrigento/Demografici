--liquibase formatted sql
--changeset amonopoli:202306300940 runOnChange:true stripComments:false
create or replace trigger CIVDPA_TIU
before INSERT
    or UPDATE
on CIVDPA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id := F_CIVDPA_NR(:new.id);

     if :new.avvocato_sposo_cognome is not null and :new.avvocato_sposo_nome is not null then
        :new.avvocato_sposo := :new.avvocato_sposo_cognome||' '||:new.avvocato_sposo_nome;
     end if;
     if :new.avvocato_sposa_cognome is not null and :new.avvocato_sposa_nome is not null then
        :new.avvocato_sposa := :new.avvocato_sposa_cognome||' '||:new.avvocato_sposa_nome;
     end if;

     if INSERTING then
        :new.id_atto := nvl(:new.id_atto,f_CIV_get_id_atto(:new.tipo_atto,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto));
     elsif UPDATING then
        if :new.tipo_atto||:new.ufficio||:new.anno||:new.parte||:new.serie||:new.atto != :old.tipo_atto||:old.ufficio||:old.anno||:old.parte||:old.serie||:old.atto then
           :new.id_atto := f_CIV_get_id_atto(:new.tipo_atto,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
        end if;
     end if;
      
     if INSERTING then
        if :new.data_protocollo is not null and :new.d_data_protocollo is null then
           :new.d_data_protocollo := to_date(:new.data_protocollo,'j');
        elsif :new.d_data_protocollo is not null and :new.data_protocollo is null then 
           :new.data_protocollo := to_char(:new.d_data_protocollo,'j');
        end if;

        if :new.data_nota_rif is not null and :new.d_data_nota_rif is null then
           :new.d_data_nota_rif := to_date(:new.data_nota_rif,'j');
        elsif :new.d_data_nota_rif is not null and :new.data_nota_rif is null then 
           :new.data_nota_rif   := to_char(:new.d_data_nota_rif,'j');
        end if;

        if :new.data_atto_orig is not null and :new.d_data_atto_orig is null then
           :new.d_data_atto_orig := to_date(:new.data_atto_orig,'j');
        elsif :new.d_data_atto_orig is not null and :new.data_atto_orig is null then 
           :new.data_atto_orig   := to_char(:new.d_data_atto_orig,'j');
        end if;

        if :new.accordo_data is not null and :new.d_accordo_data is null then
           :new.d_accordo_data := to_date(:new.accordo_data,'j');
        elsif :new.d_accordo_data is not null and :new.accordo_data is null then 
           :new.accordo_data := to_char(:new.d_accordo_data,'j');
        end if;
     end if;

     if UPDATING then
        if nvl(:old.data_protocollo,1111111) != nvl(:new.data_protocollo,1111111) then
           :new.d_data_protocollo := to_date(:new.data_protocollo,'j');
        elsif nvl(:old.d_data_protocollo,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_protocollo,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_protocollo := to_char(:new.d_data_protocollo,'j');
        end if;

        if nvl(:old.data_nota_rif,1111111) != nvl(:new.data_nota_rif,1111111) then
           :new.d_data_nota_rif := to_date(:new.data_nota_rif,'j');
        elsif nvl(:old.d_data_nota_rif,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_nota_rif,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_nota_rif := to_char(:new.d_data_nota_rif,'j');
        end if;

        if nvl(:old.data_atto_orig,1111111) != nvl(:new.data_atto_orig,1111111) then
           :new.d_data_atto_orig := to_date(:new.data_atto_orig,'j');
        elsif nvl(:old.d_data_atto_orig,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_atto_orig,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_atto_orig := to_char(:new.d_data_atto_orig,'j');
        end if;

        if nvl(:old.accordo_data,1111111) != nvl(:new.accordo_data,1111111) then
           :new.d_accordo_data := to_date(:new.accordo_data,'j');
        elsif nvl(:old.d_accordo_data,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_accordo_data,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.accordo_data := to_char(:new.d_accordo_data,'j');
        end if;
     end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
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
