--liquibase formatted sql
--changeset amonopoli:202305110930_1 runOnChange:true stripComments:false
create or replace trigger ANSCIU_TIU
before INSERT
    or UPDATE
on ansciu
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_flag_automatico	varchar2(1);

w_tipo_atto		number;

w_flag_errore		varchar2(255);
w_flag_anomalia		varchar2(255);
w_errore		varchar2(4000);

w_xml_richiesta		clob;
w_xml_risposta		clob;

begin
   :new.d_data_reg := nvl(:new.d_data_reg, sysdate);

   if INSERTING or UPDATING then
      :new.INFO_WS := f_ANSC_get_html(:new.SERVIZIO,:new.INFO_WS);
   end if;

<< ins_ansmcu>>
null;

   if INSERTING or UPDATING then
      begin
        insert into ansmcu 
               (ID_OPERAZIONE, DATA_ORA, SERVIZIO, NOTE, TERMINALISTA, D_DATA_REG, 
                FLAG_INVIO_WS, NOTE_WS, ID_OPERAZIONE_ANSC, ESITO_ANSC, D_DATA_INVIO_WS,
                INFO_WS)
        values (:new.ID_OPERAZIONE, sysdate, :new.SERVIZIO, :new.NOTE, :new.TERMINALISTA, :new.D_DATA_REG, 
                :new.FLAG_INVIO_WS, :new.NOTE_WS, :new.ID_OPERAZIONE_ANSC, :new.ESITO_ANSC, :new.D_DATA_INVIO_WS,
                :new.INFO_WS)
        ;
      exception
        when others then
             raise_application_error(-20999,'Errore in ins ANSMCU ('||SQLERRM||')');
      end;
   end if;

   if UPDATING then
         begin
           update anserr
              set id_operazione = :new.id_operazione
            where id_operazione = :old.id_operazione
           ;
         exception
           when others then
                raise_application_error(-20999,'Errore in upd ANSERR ('||SQLERRM||')');
         end;
   end if;


exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANSCIU_TIU */
/
