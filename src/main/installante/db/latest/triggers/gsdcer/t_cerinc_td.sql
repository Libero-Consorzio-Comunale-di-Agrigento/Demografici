--liquibase formatted sql
--changeset amonopoli:202310070930_2 runOnChange:true stripComments:false
create or replace trigger CERINC_TD
before DELETE
on CERINC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     null;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
     begin  
       delete cerinc_zk
        where anno_emissione  = :old.anno_emissione
          and progr_emissione = :old.progr_emissione
       ;
     exception
       when others then 
            null;
     end;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
     null;
   end;

end;
/
