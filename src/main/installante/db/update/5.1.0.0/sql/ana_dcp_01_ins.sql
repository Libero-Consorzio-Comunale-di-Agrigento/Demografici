--liquibase formatted sql
--changeset amonopoli:202606161600_3 runOnChange:true stripComments:false
insert into anadcp (codice_co, cod_condizione)
select codice_co, 501 
  from anadco_zk 
 where cod_modello in ('ARI','ARE','ARC')
   and tipo_comunicazione = 'P'
   and not exists (select 1 from anadcp b
                    where cod_condizione = 501)
/
insert into anadcp (codice_co, cod_condizione)
select codice_co, 502 
  from anadco_zk 
 where cod_modello in ('MPC','MPT','MCC','MC1','MC2','MC3') 
   and tipo_comunicazione = 'P' 
   and not exists (select 1 from anadcp b
                    where cod_condizione = 502)
/
insert into anadcp (codice_co, cod_condizione)
select codice_co, 503 
  from anadco_zk 
 where cod_modello in ('UE0','UE1')
   and tipo_comunicazione = 'P' 
   and not exists (select 1 from anadcp b
                    where cod_condizione = 503)
/
insert into anadcp (codice_co, cod_condizione)
select codice_co, 504 
  from anadco_zk 
 where cod_modello in ('EXT')
   and tipo_comunicazione = 'P' 
   and not exists (select 1 from anadcp b
                    where cod_condizione = 504)
/
