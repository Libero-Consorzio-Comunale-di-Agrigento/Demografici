--liquibase formatted sql
--changeset amonopoli:202601201530 runOnChange:true stripComments:false
create or replace view eledce_v
AS
select dce.*
--
     , dce.anno_elezioni||lpad(dce.progr_elezioni,2,'0') id
  from eledce dce
/
comment on table eledce_v is 'Elettorale - Dizionario Consultazioni Elettorali (view)'
/
