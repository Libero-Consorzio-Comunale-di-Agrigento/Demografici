--liquibase formatted sql
--changeset amonopoli:202510211045_2 runOnChange:true stripComments:false
update anadts
   set d_data_ult_agg = to_date(data_ult_agg,'j')
 where data_ult_agg is not null
   and d_data_ult_agg is null
/
update anadts
   set version = 0
 where version is null
/
