--liquibase formatted sql
--changeset amonopoli:202606111530_3 runOnChange:true stripComments:false
delete anadcc
 where cod_cc in (501,502,503,504)
/
insert into anadcc
       (cod_cc, descrizione, condizione_sql, tipo_comunicazione)
select 501, 'Pratica - Soggetto annullato'         , '', 'P' from dual UNION
select 502, 'Pratica - Soggetto con PT / CC'       , '', 'P' from dual UNION
select 503, 'Pratica - Soggetto Straniero UE'      , '', 'P' from dual UNION
select 504, 'Pratica - Soggetto Straniero extra-UE', '', 'P' from dual
/
