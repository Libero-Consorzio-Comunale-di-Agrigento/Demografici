--liquibase formatted sql
--changeset snocca:202212061700 runOnChange:true
create or replace view civfcr_v
(codice, descrizione, flag_autorita, flag_restituzione)
AS
select '201', 'Verbale di chiusura dei registri dello stato civile alla fine dell''anno (Formula 201)', '', '' from dual
UNION
select '202', 'Verbale di chiusura di un registro dello stato civile al quale segue un registro suppletivo (Formula 202)', '', '' from dual
UNION
select '203', 'Chiusura del registro principale che debba trasportarsi negli uffici dell''autorità giudiziaria (Formula 203)', 'S', '' from dual
UNION
select '205', 'Chiusura del registro suppletivo (Formula 205)', 'S', '' from dual
UNION
select '206', 'Chiusura del registro principale, restituito dall''autorità giudiziaria dopo la fine dell''anno (Formula 206)', 'S', 'S' from dual
/
comment on table civfcr_v is 'Stato Civile - Formule di Chiusura Registro (view)'
/
