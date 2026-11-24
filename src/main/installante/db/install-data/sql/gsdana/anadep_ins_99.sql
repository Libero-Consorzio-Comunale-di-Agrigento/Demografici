--liquibase formatted sql
--changeset amonopoli:202606081430_92 runOnChange:true stripComments:false
insert into anadep (COD_EP, DESCRIZIONE)
select 99, 'NOTE PRATICA' 
  from dual
 where not exists (select 'x' from anadep b
                    where b.cod_ep = 99)
/
