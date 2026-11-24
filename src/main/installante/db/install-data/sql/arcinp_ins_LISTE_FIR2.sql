--liquibase formatted sql
--changeset amonopoli:202603021605 runOnChange:true stripComments:false
insert into arcinp (PARAMETRO, VALORE, DESCRIZIONE, GRUPPO, FLAG_VISIBILE)
select 'LISTE_FIR2', 'S', 'LISTE: FIRMA CECIR', 'ELE', 'S'
  from dual
 where not exists (select 1 from arcinp
                    where parametro = 'LISTE_FIR2')
/
