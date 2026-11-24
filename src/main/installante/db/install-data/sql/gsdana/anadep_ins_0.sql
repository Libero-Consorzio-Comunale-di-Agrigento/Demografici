--liquibase formatted sql
--changeset amonopoli:202606081430_91 runOnChange:true stripComments:false
insert into anadep (COD_EP, DESCRIZIONE)
select 0, 'NOTE PER ACCERTAMENTO VIGILI'
  from dual
 where not exists (select 'x' from anadep b
                    where b.cod_ep = 0)
/
