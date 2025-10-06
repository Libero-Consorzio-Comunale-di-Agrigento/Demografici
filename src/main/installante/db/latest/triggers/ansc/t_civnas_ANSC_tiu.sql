--liquibase formatted sql
--changeset amonopoli:202305181125_4 runOnChange:true stripComments:false
create or replace trigger CIVNAS_ANSC_TIU
before INSERT
    or UPDATE
on CIVNAS
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_integrazione_ansc	varchar2(255) := f_valore_inp('ANSC',1,1,'X','S');

w_servizio              varchar2(255);
w_archivio_rif		varchar2(255) := 'NAS';
w_note			varchar2(4000);

w_ansciu_ins		number;
w_anslog_ins		number;

w_init_plurimo		number;

w_id_atto		varchar2(255);
w_numero_unico		number;

w_operazione_log	varchar2(255) := 'civnas_ANSC_tiu';
w_note_log              varchar2(4000);

begin
  if nvl(w_integrazione_ansc,'N') = 'S' then
     begin
       if (INSERTING and :new.cod_rec = 3 and :new.atto > 0) 
          or (UPDATING and :new.cod_rec = 3 and :old.atto < 0 and :new.atto > 0) 
       then
             if :new.parto_plurimo is not null and :new.parto_plurimo_num_gemello = 1 then
                w_init_plurimo := f_CIV_init_parto_plurimo(:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto,:new.parto_plurimo_num_gemello,:new.parto_plurimo_tot_gemelli);
             end if;
   
             if :new.parto_plurimo is not null then
                w_id_atto := f_CIV_get_id_atto(2,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto);
                begin
                  select numero_unico
                    into w_numero_unico
                    from civnas_plurimo
                   where id_atto = w_id_atto
                  ;
                exception
                  when others then
                       w_numero_unico := '';
                end;
             end if;

             if w_numero_unico is not null then
                :new.numero_unico := w_numero_unico;
             else
                if INSERTING then
                   :new.numero_unico := nvl(:new.numero_unico, f_CIV_numero_unico(:new.anno,'S'));
                elsif UPDATING then
                   :new.numero_unico := nvl(:new.numero_unico, f_CIV_numero_unico(:new.anno,''));
                end if;
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
/* End Trigger: CIVNAS_ANSC_TIU */
/
