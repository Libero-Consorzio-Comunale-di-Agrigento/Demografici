--liquibase formatted sql
--changeset amonopoli:202606111536 runOnChange:true stripComments:false
insert into anadco_zk
       (codice_co, descrizione, cod_modello, tipo_comunicazione, flag_priorita, 
        ente_destinatario, tipo_documento_rif, flag_soggetto, flag_apr4_allegato)
select 500 + rownum codice_co,
       mod.descrizione,
       mod.cod_modello,
       mod.tipo_modello tipo_comunicazione,
       'S' flag_priorita,
       to_char(null) ente_destinatario,
       to_char(null) tipo_documento_rif,
       case
            when mod.cod_modello in ('ARI','ARE','AVC','PCI','ARC','REN','RRM','EXT','UE0','MPC','MPT','MCC') then 'S'
            when mod.cod_modello like 'RE%' then 'S'
            when mod.cod_modello like 'RR%' then 'S'
            when mod.cod_modello like 'MC%' then 'S'
            when mod.cod_modello like 'UE%' then 'S'
       end flag_soggetto,
       mod.flag_apr4_allegato
  from anamod mod
 where mod.tipo_modello = 'P'
   and not exists (select 1 from anadco_zk dco 
                    where flag_priorita = 'S')
/
insert into anadco_zk
       (codice_co, descrizione, cod_modello, tipo_comunicazione, flag_priorita, 
        ente_destinatario, tipo_documento_rif, flag_soggetto, flag_apr4_allegato)
select dco.codice_co,
       dco.descrizione,
       mod.cod_modello,
       mod.tipo_modello tipo_comunicazione,
       to_char(null) flag_priorita,
       dco.ente_destinatario,
       dco.tipo_documento_rif,
       to_char(null) flag_soggetto,
       mod.flag_apr4_allegato
  From anamod mod
     , anadco dco
 where mod.tipo_modello = 'C'
   and mod.cod_modello  = dco.cod_modello
   and dco.flag_scaw    is null
   and not exists (select 1 from anadco_zk dco 
                    where flag_priorita is null)
/
