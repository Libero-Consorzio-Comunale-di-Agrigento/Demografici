--liquibase formatted sql
--changeset amonopoli:202509011055_2 runOnChange:true stripComments:false
create or replace trigger ANACDF_TIU
before INSERT
    or UPDATE
on ANACDF
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id           := F_ANACDF_NR(:new.id);
     :new.version      := nvl(:new.version,0);

     :new.stato_cdf    := nvl(:new.stato_cdf,'D');
     :new.data_reg     := nvl(:new.data_reg,to_number(to_char(trunc(sysdate),'j')));
     :new.terminalista := nvl(:new.terminalista,si4.utente); 	
    
     if UPDATING then
        if nvl(:old.cognome_nome_cv,' ') != nvl(:new.cognome_nome_cv,' ') and nvl(:old.cognome_cv||:old.nome_cv,' ') = nvl(:new.cognome_cv||:new.nome_cv,' ') then
           :new.cognome_cv   := f_cognome(:new.cognome_nome_cv);
           :new.nome_cv      := f_nome(:new.cognome_nome_cv);
        end if;
     end if;

     :new.cognome_cv   := nvl(:new.cognome_cv,f_cognome(:new.cognome_nome_cv));
     :new.nome_cv      := nvl(:new.nome_cv,f_nome(:new.cognome_nome_cv));

     if INSERTING then
        if :new.data_inizio is not null and :new.d_data_inizio is null then
           :new.d_data_inizio := to_date(:new.data_inizio,'j');
        elsif :new.d_data_inizio is not null and :new.data_inizio is null then 
           :new.data_inizio := to_char(:new.d_data_inizio,'j');
        end if;

        if :new.data_fine is not null and :new.d_data_fine is null then
           :new.d_data_fine := to_date(:new.data_fine,'j');
        elsif :new.d_data_fine is not null and :new.data_fine is null then 
           :new.data_fine   := to_char(:new.d_data_fine,'j');
        end if;

        if :new.data_reg is not null and :new.d_data_reg is null then
           :new.d_data_reg := to_date(:new.data_reg,'j');
        elsif :new.d_data_reg is not null and :new.data_reg is null then 
           :new.data_reg   := to_char(:new.d_data_reg,'j');
        elsif :new.data_reg is null and :new.d_data_reg is null then
           :new.data_reg   := to_char(sysdate,'j');
           :new.d_data_reg := sysdate;
        end if;
     end if;

     if UPDATING then
        if nvl(:old.data_inizio,1111111) != nvl(:new.data_inizio,1111111) then
           :new.d_data_inizio := to_date(:new.data_inizio,'j');
        elsif nvl(:old.d_data_inizio,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_inizio,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_inizio := to_char(:new.d_data_inizio,'j');
        end if;

        if nvl(:old.data_fine,1111111) != nvl(:new.data_fine,1111111) then
           :new.d_data_fine := to_date(:new.data_fine,'j');
        elsif nvl(:old.d_data_fine,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_fine,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_fine := to_char(:new.d_data_fine,'j');
        end if;

        if nvl(:old.data_reg,1111111) != nvl(:new.data_reg,1111111) then
           :new.d_data_reg := to_date(:new.data_reg,'j');
        elsif nvl(:old.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) != nvl(:new.d_data_reg,to_date('01/01/1800','dd/mm/yyyy')) then
           :new.data_reg := to_char(:new.d_data_reg,'j');
        end if;
     end if;

     if :new.data_fine is not null then
        :new.stato_cdf := 'F';
     end if;

     if UPDATING then
        if nvl(:old.stato_cdf,'D') != nvl(:new.stato_cdf,'D') then
           :new.data_reg     := to_char(sysdate,'j');
           :new.d_data_reg   := sysdate;
           :new.terminalista := si4.utente; 
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
/* End Trigger: ANACDF_TIU */
/
