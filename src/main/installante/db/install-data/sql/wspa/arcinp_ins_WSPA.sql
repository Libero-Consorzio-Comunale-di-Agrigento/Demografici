--liquibase formatted sql
--changeset amonopoli:202501101000 runOnChange:true
insert into arcinp (PARAMETRO, VALORE, DESCRIZIONE, GRUPPO, NOTE, FLAG_VISIBILE)
select 'WSPA', 'N', 'INTEGRAZIONE WSPA', 'CER', 'Se valorizzato, attiva l''integrazione con i web-servicei di Pagamento On-Line. Deve contenere il nome del provider che gestisce i pagamenti (valori ammessi: DEPAG, NEXTSTEP)', 'S'
  from dual
 where not exists (select 1 from arcinp
                    where parametro = 'WSPA')
/
update arcinp
   set note = 'Se valorizzato, attiva l''integrazione con i web-servicei di Pagamento On-Line. Deve contenere il nome del provider che gestisce i pagamenti (valori ammessi: DEPAG, NEXTSTEP)'
 where parametro = 'WSPA'
/
update arcinp
   set valore = 'DEPAG'
 where parametro = 'WSPA'
   and exists (select 1 from arcinp b where parametro = 'DEPAG_URL')
/
update arcinp
   set valore = 'NEXTSTEP'
 where parametro = 'WSPA'
   and exists (select 1 from arcinp b where parametro = 'NEXT_URL')
/
