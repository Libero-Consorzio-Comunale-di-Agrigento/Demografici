--liquibase formatted sql
--changeset vmigliore:202505261600 runOnChange:true
insert into arcinp
       (parametro, valore, descrizione, gruppo, note, flag_visibile)
select 'VANA_2FAM'
     , 'S'
     , 'VANA FAMIGLIE CANC.'
     , 'ANA'
     , ''
     , 'S'
  from dual
 where not exists (select 'x' from arcinp
                    where parametro = 'VANA_2FAM')
/