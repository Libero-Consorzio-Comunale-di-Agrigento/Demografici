--liquibase formatted sql
--changeset amonopoli:202311131000_1 runOnChange:true stripComments:false
create or replace trigger ANSNOT_RTE_TIU
before INSERT
    or UPDATE
on ANSNOT
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
     if INSERTING or UPDATING then
        begin
          insert into ansnot_rte
                 (ID, ID_SOGGETTO_ANSC, ID_ANSC, STATO, GENERE, VALIDO_DAL, VALIDO_AL, 
                  ID_COMUNE_COMPETENTE, ID_COMUNE_FORMAZIONE, ID_OPERAZIONE
--                 , COGNOME_SOGGETTO_ANSC, NOME_SOGGETTO_ANSC
                 )
          select :new.ID, :new.ID_SOGGETTO_ANSC, :new.ID_ANSC, :new.STATO, :new.GENERE, :new.VALIDO_DAL, :new.VALIDO_AL, 
                  :new.ID_COMUNE_COMPETENTE, :new.ID_COMUNE_FORMAZIONE, :new.ID_OPERAZIONE
--               , :new.COGNOME_SOGGETTO_ANSC, :new.NOME_SOGGETTO_ANSC
            from dual
           where not exists (select 1 from ansnot_rte
                              where id = :new.ID)
          ;
          update ansnot_rte
             set ID                     = :new.ID
               , ID_SOGGETTO_ANSC       = :new.ID_SOGGETTO_ANSC
               , ID_ANSC                = :new.ID_ANSC
               , STATO                  = :new.STATO
               , GENERE                 = :new.GENERE
               , VALIDO_DAL             = :new.VALIDO_DAL
               , VALIDO_AL              = :new.VALIDO_AL         
               , ID_COMUNE_COMPETENTE   = :new.ID_COMUNE_COMPETENTE
               , ID_COMUNE_FORMAZIONE   = :new.ID_COMUNE_FORMAZIONE
               , ID_OPERAZIONE          = :new.ID_OPERAZIONE 
--               , COGNOME_SOGGETTO_ANSC  = :new.COGNOME_SOGGETTO_ANSC
--               , NOME_SOGGETTO_ANSC     = :new.NOME_SOGGETTO_ANSC
           where id = :new.ID
          ;
        exception
          when others then
               null;
        end;
     end if; --if INSERTING or UPDATING then

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/
