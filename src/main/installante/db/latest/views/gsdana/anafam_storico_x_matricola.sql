--liquibase formatted sql
--changeset amonopoli:202503041535 runOnChange:true stripComments:false
create or replace view anafam_storico_x_matricola
       (matricola, fascia, cod_fam, anagrafe, cod_fam_unique, w_ord, id)
AS
select distinct eve.matricola, 
       decode(eve.cod_mov,10,1,3) fascia, 
       eve.cod_fam, 
       decode(eve.cod_mov,10,'RES',12,'AIR','') anagrafe,
       decode(eve.cod_mov,10,'RES',12,'AIR')||lpad(eve.cod_fam,7,'0') cod_fam_unique,
       2 w_ord,
       decode(eve.cod_mov,10,'RES',12,'AIR')||lpad(eve.cod_fam,7,'0')||lpad(eve.matricola,7,'0')
  from anaeve eve
 where eve.cod_fam is not null
   and eve.cod_mov in (10,12)
   and not exists (select 1 from anaana ana
                    where ana.matricola = eve.matricola
                      and ana.cod_fam   = eve.cod_fam
                      and ((ana.fascia in (1,2) and eve.cod_mov = 10) or
                           (ana.fascia in (3,4) and eve.cod_mov = 12)))
UNION
select ana.matricola,
       decode(ana.fascia,2,1,4,3,ana.fascia),
       ana.cod_fam,
       decode(ana.fascia,2,'RES',4,'AIR',1,'RES',3,'AIR',''),
       decode(ana.fascia,2,'RES',4,'AIR',1,'RES',3,'AIR','')||lpad(ana.cod_fam,7,'0'),
       1,
       decode(ana.fascia,2,'RES',4,'AIR',1,'RES',3,'AIR')||lpad(ana.cod_fam,7,'0')||lpad(ana.matricola,7,'0')
  from anaana ana
 where cod_fam is not null
   and fascia  in (1,2,3,4)
 order by 6, 2
/ 
comment on table anafam_storico_x_matricola is 'Anagrafe - Famiglie Storiche del soggetto per matricola  (view)'
/
