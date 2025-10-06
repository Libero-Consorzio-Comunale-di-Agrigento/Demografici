--liquibase formatted sql
--changeset amonopoli:202310070930_1 runOnChange:true stripComments:false
create or replace trigger CERINC_TIU
before INSERT
    or UPDATE
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
     :new.id      := F_CERINC_NR(:new.id);
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
     if INSERTING then
        begin  
          delete cerinc_zk
           where anno_emissione  = :new.anno_emissione
             and progr_emissione = :new.progr_emissione
          ;
          insert into cerinc_zk
                 (TERMINALE, MATRICOLA, ANNO, ATTO, PARTE, SERIE, UFFICIO, SESSO, ANNO_EMISSIONE, PROGR_EMISSIONE)
          values (:new.TERMINALE, :new.MATRICOLA, :new.ANNO, :new.ATTO, :new.PARTE, :new.SERIE, :new.UFFICIO, :new.SESSO, :new.ANNO_EMISSIONE, :new.PROGR_EMISSIONE)
          ;
        exception
          when others then 
               null;
        end;

     elsif UPDATING then
        begin  
          update cerinc_zk
             set TERMINALE       = :new.TERMINALE, 
                 MATRICOLA       = :new.MATRICOLA,   
                 ANNO            = :new.ANNO, 
                 ATTO            = :new.ATTO, 
                 PARTE           = :new.PARTE, 
                 SERIE           = :new.SERIE, 
                 UFFICIO         = :new.UFFICIO,   
                 SESSO           = :new.SESSO, 
                 ANNO_EMISSIONE  = :new.ANNO_EMISSIONE, 
                 PROGR_EMISSIONE = :new.PROGR_EMISSIONE
           where anno_emissione  = :old.anno_emissione
             and progr_emissione = :old.progr_emissione
          ;
        exception
          when others then 
               null;
        end;
     end if;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
     if INSERTING then
        begin 
          CERINC_FI(:new.matricola, :new.anno_emissione, :new.progr_emissione);
        end;
     end if;
   end;

end;
/
