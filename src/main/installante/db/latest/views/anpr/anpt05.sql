--liquibase formatted sql
--changeset amonopoli:202605290925 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW anpt05
(CODICE
,DESCRIZIONE
,COD_RP_ADS
,SESSO_ADS
,DESCRIZIONE_ADS
)
AS
SELECT to_number(ist_rp),
       decode(ist_rp,
         '23','Convivente (con vincoli di adozione o affettivi)',
	 '24','Responsabile della convivenza non affettiva',
	 '25','Convivente in convivenza non affettiva',
	      descrizione), 
               cod_rp,
               sesso,
               descrizione
     FROM anadpi
UNION
select 26,
       'Tutore',
       '',
       '',
       'Non gestita gsd'
  from dual
 where not exists (select 1 from anadpi where ist_rp = '26')
UNION
select 99,
       'Non definito/comunicato',
       '',
       '',
       'Non gestita gsd'
  from dual
/
comment on table anpt05 is 'ANPR - Relazioni di Parentela'
/
