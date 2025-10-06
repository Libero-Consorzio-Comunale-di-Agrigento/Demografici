--liquibase formatted sql
--changeset amonopoli:202303241300_1 runOnChange:true stripComments:false
insert into arcinp (PARAMETRO, VALORE, DESCRIZIONE, GRUPPO)
select 'DUCD_MAILS', 'N', 'DUCD: SMISTAMENTO', 'GSD'
  from dual
 where not exists (select 'x' from arcinp b
                    where b.parametro = 'DUCD_MAILS')
/
update arcinp 
   set note          = 'Nell''ambito dell''integrazione con il protocollo e l''invio delle mail, gestisce la possibilità di eseguire lo smistamento all''unità mittente.
Valorizzato a ''S'' indica che verrà attivato lo smistamento.
Valorizzato a ''N'' indica che non verrà attivato lo smistamento.
'
     , flag_visibile = 'S'
 where parametro = 'DUCD_MAILS'
   and note      is null
/
