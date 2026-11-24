--liquibase formatted sql
--changeset amonopoli:202511121245 runOnChange:true stripComments:false
create or replace view AD4_UTENTI_GSD
AS
select utente, 
       decode(instr(nominativo,' '),0,nominativo,
         substr(nominativo,1,instr(nominativo,' ')-1)) cognome,
       decode(instr(nominativo,' '),0,to_char(null),
         substr(nominativo,instr(nominativo,' ')+1)) nome
  from a_utenti ut
 where exists (select 'x'
                 from a_diritti_accesso dir
                where dir.utente = ut.utente
                  and dir.applicazione like '%GSD%') 
UNION
select utente, 
       decode(instr(nominativo,' '),0,nominativo,
         substr(nominativo,1,instr(nominativo,' ')-1)) cognome,
       decode(instr(nominativo,' '),0,to_char(null),
         substr(nominativo,instr(nominativo,' ')+1)) nome
  from ad4_utenti ut
 where exists (select 'x'
                 from ad4_diritti_accesso dir
                where dir.utente = ut.utente
                  and dir.modulo = 'DE4GSD') 
UNION
select utente, 
       decode(instr(nominativo,' '),0,nominativo,
         substr(nominativo,1,instr(nominativo,' ')-1)) cognome,
       decode(instr(nominativo,' '),0,to_char(null),
         substr(nominativo,instr(nominativo,' ')+1)) nome
  from ad4_utenti ut
 where exists (select 'x'
                 from ad4_diritti_accesso dir
                where dir.utente = ut.utente
                  and dir.modulo = 'DE4WEB'
                  and dir.ruolo not like 'UTE%')
/
comment on table ad4_utenti_gsd is 'Generale - Utenti già associati al progetto DE4GSD'
/
