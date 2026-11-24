--liquibase formatted sql
--changeset amonopoli:202606111240 runAlways:true runOnChange:true stripComments:false
create or replace view anadet_v_zk
AS
select det.*
     , dep.descrizione des_evento_pratica
     , (select min(b.evento_pratica)
          from anadep c, anadet b
         where c.cod_ep            = b.evento_pratica
           and c.flag_annullamento is null
           and det.evento_pratica  not in (7,8)
           and b.anagrafe          = det.anagrafe
           and b.tipo_evento       = det.tipo_evento
           and b.sequenza          > det.sequenza) next_evento_pratica_P
     , (select b.cod_ep
          from anadep b
         where det.evento_pratica  not in (7,8)
           and b.flag_annullamento is not null
           and rownum = 1) next_evento_pratica_N
  from anadep dep, anadet det
 where dep.cod_ep = det.evento_pratica
/
comment on table anadet_v_zk is 'Anagrafe - Relazione Eventi Testata (view)'
/
