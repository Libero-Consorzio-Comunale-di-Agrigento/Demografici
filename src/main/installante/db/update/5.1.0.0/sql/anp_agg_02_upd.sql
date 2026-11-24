--liquibase formatted sql
--changeset amonopoli:202604211540_2 runOnChange:true stripComments:false
alter table anpciu_agg disable all triggers
/
update anpciu_agg
   set d_data_decorrenza_anpr = to_date(data_decorrenza_anpr,'j')
 where data_decorrenza_anpr is not null
   and d_data_decorrenza_anpr is null
/
alter table anpciu_agg enable all triggers
/