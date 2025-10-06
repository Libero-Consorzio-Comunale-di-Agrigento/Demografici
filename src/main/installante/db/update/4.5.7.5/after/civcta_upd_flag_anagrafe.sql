--liquibase formatted sql
--changeset amonopoli:202404241125 runOnChange:true stripComments:false
update civcta
   set flag_anagrafe = 'S'
 where flag_anagrafe is null
   and tipo_atto = 1
   and sigla in ('DAQ','ASM','AS1','ASA','DPE','R18','ATL')
-- escludo:
-- 'GIU' - GIURAMENTO
/
update civcta
   set flag_anagrafe = 'S'
 where flag_anagrafe is null
   and tipo_atto = 2
   and sigla in ('O1A','O1B','T2A','ATL','CNA','TEA','TEP','CGE','ADO')
-- escludo:
-- 'ODN' - TRASCRIZIONE DECRETO TRIBUNALE OMESSA DIC. DI NASCITA	
-- 'RPN' - RICONOSCIMENTO (PRE-NATALE)	
-- 'RIC' - RICONOSCIMENTO (POST-NASCITA)	
-- 'O1'  - PARTE 1 (SENZA SERIE)	
/
update civcta
   set flag_anagrafe = 'S'
 where flag_anagrafe is null
   and tipo_atto = 4
   and sigla in ('O1','O2A','T2B','ATL','TEP','TEA','CPD','TMC','TMD','FCC','PDV',	-- matrimoni
                 'UCO','AVV','TRI','EST')						-- divorzi
-- escludo:
-- 'UAC' - UFFICIALE DI STATO CIVILE - ACCORDO (CESSAZIONE / SCIOGLIMENTO / SEPARAZIONE)	
-- 'UAL' - UFFICIALE DI STATO CIVILE - ALTRO	
-- 'AAL' - AVVOCATI - ALTRO	
-- 'RCN' - RICONCILIAZIONE
/
update civcta
   set flag_anagrafe = ''
 where flag_anagrafe = 'S'
   and tipo_atto = 4
   and sigla = 'RCN'		-- divorzi
/
update civcta
   set flag_anagrafe = 'S'
 where flag_anagrafe is null
   and tipo_atto = 5
   and sigla in ('O1','T2A','O2B','T2B','ATL','TEP','TEA','CIG','BIS','MPR')
/
update civcta
   set flag_anagrafe = 'S'
 where flag_anagrafe is null
   and tipo_atto = -4
   and sigla in ('O1','UCN','FCC','PDV','UPD','T2','TPD','TEP','TEA','ATL',		-- unioni civili
                 'UCO','AVV','TRI','EST','ANN')						-- scioglimenti
-- escludo:
-- 'MCO' - MANCATA COMPARIZIONE	
-- 'DVS' - DICHIARAZIONE VOLONTA' SCIOGLIMENTO UNIONE	
-- 'UAC' - SCIOGLIMENTO UNIONE CIVILE - UFFICIALE (ACCORDO)	
-- 'UAL' - UFFICIALE DI STATO CIVILE - ALTRO	
-- 'SCC' - SCELTA COGNOME COMUNE	
/
update civcta
   set flag_anagrafe = ''
 where flag_anagrafe = 'S'
   and tipo_atto = -4
   and sigla     = 'SCC'	-- unioni civili
/