--liquibase formatted sql
--changeset amonopoli:202606111546 runOnChange:true stripComments:false
insert into anadct	
       (anagrafe, tipo_evento, codice_co, numero_copie, id, id_anadep)
select inp_v.anagrafe, 
       inp_v.tipo_evento, 
       dco.codice_co, 
       decode(nvl(substr(inp_v.valore,1,1),'N'),'N','0', substr(inp_v.valore,1,1)) numero_copie,
       inp_v.anagrafe||inp_v.tipo_evento||lpad(dco.codice_co,3,'0') id,
       decode(substr(inp_v.parametro,6,3),'VAA',1,'VAI',1,'VAE',1,'VAC',1,'REN',9,'RRM',10)
  from (select 'RES' anagrafe, 'I' tipo_evento, parametro, valore from arcinp where parametro like 'IAPR%' and length(parametro) = 8
        UNION
        select 'RES' anagrafe, 'E' tipo_evento, parametro, valore from arcinp where parametro like 'CABI%' and length(parametro) = 8
        UNION
        select 'RES' anagrafe, 'C' tipo_evento, parametro, valore from arcinp where parametro like 'CAPR%' and length(parametro) = 8
        UNION
        select 'AIR' anagrafe, 'I' tipo_evento, parametro, valore from arcinp where parametro like 'IAIR%' and length(parametro) = 8
        UNION
        select 'AIR' anagrafe, 'E' tipo_evento, parametro, valore from arcinp where parametro like 'CABA%' and length(parametro) = 8
        UNION
        select 'AIR' anagrafe, 'C' tipo_evento, parametro, valore from arcinp where parametro like 'KAIR%' and length(parametro) = 8
       ) inp_v
     , anadco_zk dco
 where dco.cod_modello   = substr(inp_v.parametro,6,3)
   and dco.flag_priorita = 'S'
   and not exists (select 1 from anadct dct
                    where dct.anagrafe    = inp_v.anagrafe
                      and dct.tipo_evento = inp_v.tipo_evento
                      and dct.codice_co   = dco.codice_co)
/
insert into anadct	
       (anagrafe, tipo_evento, codice_co, numero_copie, id)
select dco_v.anagrafe, 
       dco_v.tipo_evento, 
       dco.codice_co, 
       decode(nvl(substr(inp.valore,1,1),'N'),'N','0', substr(inp.valore,1,1)) numero_copie,
       dco_v.anagrafe||dco_v.tipo_evento||lpad(dco.codice_co,3,'0') id
  from (select 'RES' anagrafe, 'I' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%ISCRIZIONE%APR%'
        UNION
        select 'RES' anagrafe, 'E' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%INDIRIZZO%APR%'
        UNION
        select 'RES' anagrafe, 'C' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%CANCELLAZIONE%APR%'
                                                                            or upper(descrizione) like '%EMIGRAZIONE%'
        UNION
        select 'RES' anagrafe, 'R' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%RETTIFICA%APR%'
                                                                            or upper(descrizione) like '%RETTIFICHE%APR%'
                                                                            or upper(descrizione) like '%CAMBIO%GENERALI%APR%'
        UNION
        select 'AIR' anagrafe, 'I' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%ISCRIZIONE%AIRE%'
        UNION
        select 'AIR' anagrafe, 'E' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%INDIRIZZO%AIRE%'
        UNION
        select 'AIR' anagrafe, 'C' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%CANCELLAZIONE%AIRE%'
        UNION
        select 'AIR' anagrafe, 'R' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%RETTIFICA%AIRE%'
                                                                            or upper(descrizione) like '%RETTIFICHE%AIRE%'
                                                                            or upper(descrizione) like '%CAMBIO%GENERALI%AIRE%'
       ) dco_v
     , arcinp inp
     , anadco_zk dco
 where inp.parametro = 'SCAN_'||dco.cod_modello
   and dco.codice_co      = dco_v.codice_co
   and dco.flag_priorita is null
   and not exists (select 1 from anadct dct
                    where dct.anagrafe    = dco_v.anagrafe
                      and dct.tipo_evento = dco_v.tipo_evento
                      and dct.codice_co   = dco.codice_co)
/
insert into anadct	
       (anagrafe, tipo_evento, codice_co, numero_copie, id)
select dco_v.anagrafe, 
       dco_v.tipo_evento, 
       dco.codice_co, 
       decode(nvl(substr(inp.valore,1,1),'N'),'N','0', substr(inp.valore,1,1)) numero_copie,
       dco_v.anagrafe||dco_v.tipo_evento||lpad(dco.codice_co,3,'0') id
  from (select 'RES' anagrafe, 'R' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%RETTIFICA%'
                                                                            or upper(descrizione) like '%RETTIFICHE%'
        UNION
        select 'AIR' anagrafe, 'R' tipo_evento, codice_co from anadco_zk where upper(descrizione) like '%RETTIFICA%'
                                                                            or upper(descrizione) like '%RETTIFICHE%'
       ) dco_v
     , arcinp inp
     , anadco_zk dco
 where inp.parametro = 'SCAN_'||dco.cod_modello
   and dco.codice_co      = dco_v.codice_co
   and dco.flag_priorita is null
   and not exists (select 1 from anadct dct
                    where dct.anagrafe    = dco_v.anagrafe
                      and dct.tipo_evento = dco_v.tipo_evento
                      and dct.codice_co   = dco.codice_co)
/
