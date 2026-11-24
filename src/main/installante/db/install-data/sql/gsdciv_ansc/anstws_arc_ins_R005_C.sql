--liquibase formatted sql
--changeset amonopoli:202603021710_1 runAlways:true runOnChange:true stripComments:false
delete anstws_arc
 where archivio = 'CER'
   and id_anstws = 'R005_C'
/
insert into anstws_arc (ID, ARCHIVIO, ID_ANSTWS, SEQUENZA, ID_ANST03, ID_ANSTWS_PREC, VERSION, TIPO_EVENTO)
select null, 'CER', 'R005_C', 10, null, null, 0, null
  from dual
 where not exists (select 1 from anstws_arc b
                    where b.archivio  = 'CER'
                      and b.id_anstws = 'R005_C')
/
