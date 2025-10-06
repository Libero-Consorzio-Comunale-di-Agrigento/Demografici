--liquibase formatted sql
--changeset amonopoli:202303101050_2 runOnChange:true stripComments:false
create or replace trigger CIVCOM_ALLE_TIU
before INSERT
    or UPDATE
on CIVCOM_ALLE
for each row
declare

w_flag_protocollo	varchar2(255);
w_flag_albo_pretorio	varchar2(255);

w_ctr_gdm       	number;

errore			exception;
errore_gdm		exception;
w_errore		varchar2(4000);

w_operazione_log	varchar2(255) := 'civcom_alle_tiu';

begin
   if INSERTING then
      begin  
        :new.id := F_CIVCOM_ALLE_NR(:new.id);
      end;
      :new.D_DATA_REG      := sysdate;
      :new.TERMINALISTA    := nvl(:new.terminalista,si4.utente);
      :new.nome_allegato   := nvl(:new.nome_allegato,'civcom'||:new.id_com||'_allegato'||:new.id||'.pdf');

      begin
        select flag_protocollo, flag_albo_pretorio 
          into w_flag_protocollo, w_flag_albo_pretorio
          from civcom_v v
         where id = :new.id_com
        ;
      exception
        when others then
             w_flag_protocollo := '';
      end;

      if w_flag_protocollo||w_flag_albo_pretorio is not null then
         :new.flag_da_firmare := f_PROT_flag_da_firmare('CIVCOM',:new.nome_allegato);
      end if;

   end if;

   if INSERTING or UPDATING then

      begin 
        select 1 
          into w_ctr_gdm
          from civcom_alle com_alle_2
         where com_alle_2.nome_allegato = :new.nome_allegato
           and com_alle_2.id            != :new.id
           and com_alle_2.id_com        = :new.id_com
           and rownum = 1
        ;
        raise too_many_rows;
      exception
        when too_many_rows then
             w_errore := 'Nome allegato già presente per la comunicazione selezionata';
             raise errore_gdm;
        when others then 
             null;
      end;
   end if;
      

exception
  when errore then
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
  when errore_gdm then
       raise_application_error(-20999, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
end;
/
