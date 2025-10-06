--liquibase formatted sql
--changeset amonopoli:202305181125_2 runOnChange:true stripComments:false
create or replace trigger CIVMAT_ANSC_TIU
before INSERT
    or UPDATE
on CIVMAT
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_integrazione_ansc	varchar2(255) := f_valore_inp('ANSC',1,1,'X','S');
w_flag_ansc		varchar2(255) := f_flag_ANSC();

w_servizio              varchar2(255);
w_archivio_rif		varchar2(255) := 'MAT';
w_note			varchar2(4000);

w_ansciu_ins		number;
w_anslog_ins		number;

w_servizio_log		varchar2(255);
w_operazione_log	varchar2(255) := 'civmat_ANSC_tiu';
w_note_log              varchar2(4000);

begin
  if nvl(w_integrazione_ansc,'N') = 'S' then
     begin
       if (INSERTING and :new.cod_rec = 3 and :new.atto > 0) then
          :new.numero_unico := nvl(:new.numero_unico, f_CIV_numero_unico(:new.anno,'S'));
       elsif (UPDATING and :new.cod_rec = 3 and :old.atto < 0 and :new.atto > 0) then
          :new.numero_unico := nvl(:new.numero_unico, f_CIV_numero_unico(:new.anno,''));
       end if;

       if UPDATING and nvl(w_flag_ansc,'N') = 'S' then
          if :old.id_atto_ansc is null and :new.id_atto_ansc is not null then
             begin
               update civann
                  set testo_annotazione = replace(
                                            replace(testo_annotazione,'N. '||:new.numero_unico||' Anno '||:new.anno||' (*)', 'N. '||:new.id_atto_ansc),
                                              '[(*) numero unico comunale in attesa di validazione ANSC]','')
                where id_atto_rif = :new.id_atto
                  and instr(testo_annotazione,'(*)') > 0
               ;
             exception
               when others then 
                    ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore', sqlerrm, :new.id_atto);
             end;

          elsif :old.id_atto_ansc is not null and :new.id_atto_ansc is null then
             begin
               update civann
                  set testo_annotazione = replace(testo_annotazione,'N. '||:old.id_atto_ansc, 'N. '||:new.numero_unico||' Anno '||:new.anno||' (*)')||
                                            ' [(*) numero unico comunale in attesa di validazione ANSC]'
                where id_atto_rif = :new.id_atto
                  and instr(testo_annotazione,:old.id_atto_ansc) > 0
               ;
             exception
               when others then 
                    ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore', sqlerrm, :new.id_atto);
             end;

          elsif :old.id_atto_ansc is not null and :new.id_atto_ansc is not null and :old.id_atto_ansc != :new.id_atto_ansc then
             begin
               update civann
                  set testo_annotazione = replace(testo_annotazione,'N. '||:old.id_atto_ansc,'N. '||:new.id_atto_ansc)
                where id_atto_rif = :new.id_atto
               ;
             exception
               when others then 
                    ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'errore', sqlerrm, :new.id_atto);
             end;
          end if;
       end if;

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
/* End Trigger: CIVMAT_ANSC_TIU */
/
