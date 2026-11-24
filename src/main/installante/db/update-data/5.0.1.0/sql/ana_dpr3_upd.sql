--liquibase formatted sql
--changeset amonopoli:202510301200_2 runOnChange:true stripComments:false
update anadpr
   set id = sesso||lpad(cod_pr,5,'0')
 where sesso||cod_pr is not null
   and id is null
/
update anadpr
   set d_data_ult_agg = to_date(data_ult_agg,'j')
 where data_ult_agg is not null
   and d_data_ult_agg is null
/
update anadpr
   set version = 0
 where version is null
/
