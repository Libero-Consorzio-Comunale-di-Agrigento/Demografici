--liquibase formatted sql
--changeset amonopoli:202511211505_2 runOnChange:true stripComments:false
create or replace trigger anacom_tiu
before INSERT
    or UPDATE
on ANACOM
for each row
declare

w_tipo_atto             varchar2(255);

w_ctr_protocollo        number;
w_fase_prot             varchar2(255);
w_funzione_prot         varchar2(255);

w_cod_modello 		varchar2(255);
w_flag_apr4_allegato	varchar2(255);
w_id_apr4           	number;

errore			exception;
w_errore		varchar2(4000);

w_operazione_log	varchar2(255) := 'anacom_tiu';

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id         := F_ANACOM_NR(:new.id);

     if INSERTING then
        if :new.data_reg is null and :new.d_data_reg is not null then
           :new.data_reg := to_char(:new.d_data_reg,'j');
        elsif :new.d_data_reg is null and :new.data_reg is not null then
           :new.d_data_reg := to_date(:new.data_reg,'j');
        end if;
     end if;

     if UPDATING then
        if nvl(:old.data_reg,0) != nvl(:new.data_reg,0) then
           :new.d_data_reg := to_date(:new.data_reg,'j');
        elsif nvl(:old.d_data_reg,sysdate) != nvl(:new.d_data_reg,sysdate) then
           :new.data_reg   := to_char(:new.d_data_reg,'j');
        end if;
     end if;
   end;

   if :new.comunicazione is null then
      goto fine;
   end if;

   w_fase_prot   := substr(:new.comunicazione,1,4);
   w_cod_modello := substr(:new.comunicazione,6,3);
   w_funzione_prot := 'W'||w_cod_modello;

   if w_fase_prot = 'SCAW' then
     :new.anagrafe    := nvl(:new.anagrafe,f_SCAW_anagrafe(:new.cod_mov,:new.cod_eve));
     :new.tipo_evento := nvl(:new.tipo_evento,f_SCAW_tipo_evento(:new.cod_mov,:new.cod_eve));
   end if;

   begin
     select 1
       into w_ctr_protocollo
       from parametri_protocollo
      where fase     = w_fase_prot
        and funzione = w_funzione_prot
     ;
     DOCAREA_PKG.ins_log(w_operazione_log, w_funzione_prot||' - trovato parametri_protocollo');
   exception
     when others then
          DOCAREA_PKG.ins_log(w_operazione_log, w_funzione_prot||' - NON trovato parametri_protocollo');
          w_ctr_protocollo := 0;
   end;

   if w_ctr_protocollo = 0 then
      goto fine;
   end if;

   if INSERTING then
      begin
        insert into ANACOM_prot
               (COMUNICAZIONE, MATRICOLA, COGNOME_NOME, ANNO_PRATICA, PRATICA,
                COD_MOV, COD_EVE, DATA_REG, ANNO_PROGR, NUMERO_PROGR,
                ENTE_LP, NUMERO_COPIE, ID, ANAGRAFE, TIPO_EVENTO,
                CODICE_CO)
        select :new.COMUNICAZIONE, :new.MATRICOLA, :new.COGNOME_NOME, :new.ANNO_PRATICA, :new.PRATICA,
                :new.COD_MOV, :new.COD_EVE, :new.DATA_REG, :new.ANNO_PROGR, :new.NUMERO_PROGR,
                :new.ENTE_LP, :new.NUMERO_COPIE, :new.ID, :new.anagrafe, :new.tipo_evento,
                :new.CODICE_CO
          from dual
--         where not exists (select 'x' from anacom_prot b
--                            where comunicazione = :new.comunicazione
--                              and anno_progr    = :new.anno_progr
--                              and numero_progr  = :new.numero_progr)
        ;
      exception
        when others then
             w_errore := 'Errore in inserimento ANACOM_PROT ('||sqlerrm||')';
             raise errore;
      end;


   elsif UPDATING then
      begin
        update ANACOM_prot
           set COMUNICAZIONE = :new.COMUNICAZIONE
             , MATRICOLA     = :new.MATRICOLA
             , COGNOME_NOME  = :new.COGNOME_NOME
             , ANNO_PRATICA  = :new.ANNO_PRATICA
             , PRATICA       = :new.PRATICA
             , COD_MOV       = :new.COD_MOV
             , COD_EVE	     = :new.COD_EVE
             , DATA_REG      = :new.DATA_REG
             , ANNO_PROGR    = :new.ANNO_PROGR
             , NUMERO_PROGR  = :new.NUMERO_PROGR
             , ENTE_LP       = :new.ENTE_LP
             , NUMERO_COPIE  = :new.NUMERO_COPIE
             , ID            = :new.ID
             , ANAGRAFE      = :new.ANAGRAFE
             , TIPO_EVENTO   = :new.TIPO_EVENTO
             , CODICE_CO     = :new.CODICE_CO
         where id = :old.id
        ;
      exception
        when others then
             w_errore := 'Errore in aggiornamento ANACOM_PROT ('||sqlerrm||')';
             raise errore;
      end;

   end if;

<< fine >>
null;

exception
  when errore then
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
end;
/
