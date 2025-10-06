--liquibase formatted sql
--changeset amonopoli:202312181020_2 runOnChange:true stripComments:false
create or replace trigger CIVANN_IST_TD
before DELETE
on CIVANN
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

begin
 if nvl(w_integrazione_istat,'N') = 'S' then
   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;

         if DELETING then
            if :old.tipo_atto = 4 then
               begin
                 delete istmsc
                  where id_civann = :old.id
                 ;
                 if sql%found then
                    ISTAT_PKG.ins_log('civann_ist_tiu','istmsc - delete');
                 end if;
               end;

            elsif :old.tipo_atto = -4 then
               begin
                 delete istmsu
                  where id_civann = :old.id
                 ;
                 if sql%found then
                    ISTAT_PKG.ins_log('civann_ist_tiu','istmsu - delete');
                 end if;
               end;
            end if;
         end if;

         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
 end if; --if nvl(w_integrazione_istat,'N') = 'S' then
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: CIVANN_IST_TD */
/
