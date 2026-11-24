--liquibase formatted sql
--changeset amonopoli:202604221140 runAlways:true runOnChange:true stripComments:false
create or replace function f_ANPR_flag_modifica_pre_TWS
(a_servizio	IN	varchar2)

return varchar2

IS

w_servizio	varchar2(255) := upper(a_servizio);
w_flag		varchar2(255);

begin
--
--                   '1010', -- APR - Iscrizione Convivenza
--                   '1014', -- Acquisizione e gestione dei procedimenti amministrativi
--                   '5010', -- Mutazione liste elettorali
--                   '5011', -- Mutazione liste sezioni
--                   '5013', -- Revoca dato
--
  if w_servizio in ('1001', -- APR - Iscrizione per Nascita
                    '1002', -- APR - Iscrizione per altri motivi
                    '1013', -- Annullamento iscrizione
                    '2001', -- Cancellazione per morte accertata o presunta prova
                    '2003', -- Cancellazione per altri motivi
                    '2011', -- Annullamento cancellazione
                    '5001', -- APR - Mutazione composizione famiglia/convivenza
                    '5005', -- APR - Mutazione residenza
                    '5008', -- Mutazione dati generali/stato civile
                    '5012', -- Annullamento mutazione
                    '5014', -- Rettifica dati subentro
                    'A001', -- AIRE - Iscrizione per nascita
                    'A002', -- AIRE - Iscrizione per altri motivi
                    'A006') -- AIRE - Mutazione
  then
     w_flag := 'S';
  end if;

  return w_flag;
end;
/
create or replace view anptws_v_zk
AS
select tws.*
     , f_ANPR_flag_modifica_pre_TWS(tws.codice) flag_modifica_pre
  from anptws tws
/
comment on table anptws_v_zk is 'ANPR - WS: Codici e URL (view)'
/
