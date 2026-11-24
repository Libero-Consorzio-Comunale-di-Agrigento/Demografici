--liquibase formatted sql
--changeset amonopoli:202604211120_2 runOnChange:true stripComments:false
create or replace trigger ANPCIU_TIU
before INSERT
    or UPDATE
on ANPCIU
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_flag_automatico	varchar2(1);

w_flag_errore		varchar2(255);
w_flag_anomalia		varchar2(255);
w_errore		varchar2(4000);

w_ctr_xml 		number;

w_xml_richiesta		clob;
w_xml_risposta		clob;

begin
   :new.data_reg := nvl(:new.data_reg, to_char(sysdate,'j'));

   if INSERTING then
      :new.ID_OPERAZIONE := F_ANPCIU_NR(:new.ID_OPERAZIONE,:new.servizio||:new.archivio_rif);
   end if;

   if INSERTING then
      if :new.servizio in ('3002','3003','3005','3007','6001','4001','4003','7001') then
         goto attivazione_ws;
      else
-- controllo invio automatico
         begin
           select tws.flag_automatico
             into w_flag_automatico
             from anptws tws
            where tws.codice = :new.servizio
              and rownum     = 1
           ;
         exception
           when others then
                w_flag_automatico := '';
         end;
anpr_pkg.ins_log('','anpciu_tiu','servizio '||:new.servizio||' - flag_automatico: '||w_flag_automatico);
         if nvl(w_flag_automatico,'N') = 'S' then
            goto attivazione_ws;
         else
            goto ins_anpmcu;
         end if;
      end if;
   end if;

   if UPDATING then
      if :old.id_operazione != :new.id_operazione then
         begin
           update anpciu_agg
              set id_operazione = :new.id_operazione
            where id_operazione = :old.id_operazione
           ;
         exception
           when others then
                raise_application_error(-20999,'Errore in upd ANPCIU_AGG ('||SQLERRM||')');
         end;

         begin
           update anpxml
              set id_operazione   = :new.id_operazione,
                  valore          = decode(tag_1,
                                    '<idOperazioneComune>', to_char(:new.id_operazione),
                                    '<dataOraRichiesta>'  , to_char(sysdate,'yyyy-mm-dd"T"hh24:mi:ss'),
                                    valore)
            where id_operazione = :old.id_operazione
           ;
         exception
           when others then
                raise_application_error(-20999,'Errore in upd ANPXML ('||SQLERRM||')');
         end;
      end if;
      if :new.servizio not in ('3002','3003','3005','3007','6001','4003') then
         if :old.flag_invio_ws||:new.flag_invio_ws is null then
            if :new.servizio = '1014' and :old.matricola is null and :new.matricola is not null then
               goto ins_anpmcu;
            elsif :new.servizio is not null and :old.servizio is not null and :new.servizio != :old.servizio then
               goto ins_anpmcu;
            else
               goto attivazione_ws;
            end if;
         else
            goto ins_anpmcu;
         end if;
      else
         goto ins_anpmcu;
      end if;
   end if;

<< attivazione_ws >>
   w_xml_richiesta := '';
   w_xml_risposta  := '';
   begin
     ANPR_pkg.attivazione_ws(:new.servizio
                            ,:new.id_operazione
                            ,:new.tipo_operazione
                            ,:new.anno_rif
                            ,:new.numero_rif
                            ,:new.matricola
                            ,:new.fascia_fam
                            ,:new.cod_fam
                            ,:new.id_anadoc
                            ,:new.id_anamsi
                            ,:new.archivio_rif
                            ,:new.terminalista
                            ,:new.id_operazione_ANPR
                            ,:new.esito_ANPR
                            ,w_flag_errore
                            ,w_flag_anomalia
                            ,w_xml_richiesta
                            ,w_xml_risposta
                            ,:new.note
                            );
   exception
     when others then
          w_errore := 'errore WS ('||sqlerrm||')';
   end;

   if w_errore is not null then
      :new.flag_invio_ws := '';
      :new.data_invio_ws := to_char(sysdate,'j');
      :new.note_ws       := w_errore;
   elsif nvl(:new.esito_ANPR,'XXXX') in ('0000','00AA') then
      :new.flag_invio_ws := 'S';
      :new.data_invio_ws := to_char(sysdate,'j');
      if nvl(w_flag_anomalia,'N') = 'S' then
         :new.note_ws       := 'OK (anomalie)';
      else 
         :new.note_ws       := 'OK';
      end if;

      begin
        select 1 into w_ctr_xml
          from anpxml
         where id_operazione   = :new.id_operazione
           and flag_modificato = 'S'
           and rownum = 1
        ;
      exception
        when no_data_found then
             begin
               delete anpxml
                where id_operazione = :new.id_operazione
               ;
             exception
               when others then 
anpr_pkg.ins_log('','anpciu_tiu','del_anpxml - errore (1): '||sqlerrm);
             end;
        when others then
anpr_pkg.ins_log('','anpciu_tiu','del_anpxml - errore (2): '||sqlerrm);
      end;

   else
      :new.flag_invio_ws := '';
      :new.data_invio_ws := to_char(sysdate,'j');
      if nvl(w_flag_errore,'N') = 'S' then
         :new.note_ws       := 'KO (vis. errori)';
      else
         :new.note_ws       := 'KO (vis. log)';
      end if;
   end if;

<< ins_anpmcu>>
null;
   if INSERTING or UPDATING then
      begin
        insert into anpmcu 
               (ID_OPERAZIONE, DATA_ORA, SERVIZIO, TIPO_OPERAZIONE, NOTE, TERMINALISTA, DATA_REG, 
                FLAG_INVIO_WS, DATA_INVIO_WS, NOTE_WS, ID_OPERAZIONE_ANPR, ESITO_ANPR)
        values (:new.ID_OPERAZIONE, sysdate, :new.SERVIZIO, :new.TIPO_OPERAZIONE, :new.NOTE, :new.TERMINALISTA, :new.DATA_REG, 
                :new.FLAG_INVIO_WS, :new.DATA_INVIO_WS, :new.NOTE_WS, :new.ID_OPERAZIONE_ANPR, :new.ESITO_ANPR)
        ;
      exception
        when others then
             raise_application_error(-20999,'Errore in ins ANPMCU ('||SQLERRM||')');
      end;
   end if;

   if UPDATING then
      if :old.id_operazione != :new.id_operazione then
         begin
           update anpmcu
              set id_operazione = :new.id_operazione
            where id_operazione = :old.id_operazione
           ;
         exception
           when others then
                raise_application_error(-20999,'Errore in upd ANPMCU ('||SQLERRM||')');
         end;
         begin
           update anperr
              set id_operazione = :new.id_operazione
            where id_operazione = :old.id_operazione
           ;
         exception
           when others then
                raise_application_error(-20999,'Errore in upd ANPERR ('||SQLERRM||')');
         end;
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
/* End Trigger: ANPCIU_TIU */
/
