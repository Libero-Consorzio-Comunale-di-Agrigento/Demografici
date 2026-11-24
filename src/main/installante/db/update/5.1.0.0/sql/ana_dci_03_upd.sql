--liquibase formatted sql
--changeset amonopoli:202510301245_2 runOnChange:true stripComments:false
update anadci
   set d_data_ult_agg = to_date(data_ult_agg,'j')
 where data_ult_agg is not null
   and d_data_ult_agg is null
/
update anadci
   set version = 0
 where version is null
/
