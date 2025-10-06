--liquibase formatted sql
--changeset amonopoli:202410111140 runOnChange:true stripComments:false
insert into arcpro_storico 
       (COD_PROVINCIA, DESCRIZIONE, SIGLA_PROVINCIA, DATA_ISTITUZIONE, DATA_INIZIO_VALIDITA, DATA_FINE_VALIDITA, FLAG_ISTAT)
select s.cod_provincia
     , s.descrizione
     , s.sigla_provincia
     , s.data_istituzione
     , to_char(to_date('01/01/1800','dd/mm/yyyy'),'j')
     , s.data_inizio_validita-1
     , to_char(null)
  from arcpro_storico s
 where to_char(to_date(s.data_inizio_validita,'j'),'yyyy') = 1861
   and not exists (select 1 from arcpro_storico b
                    where b.cod_provincia        = s.cod_provincia
                      and b.data_inizio_validita < s.data_inizio_validita)
/
