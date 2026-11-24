--liquibase formatted sql
--changeset amonopoli:202601201535 runOnChange:true stripComments:false
create or replace view eledsr_v
AS
select dsr.*
--
     , to_date(dsr.data_revisione,'j') d_data_revisione
     , to_date(dsr.data_verbale,'j') d_data_verbale
     , dsr.anno||dsr.revisione||lpad(dsr.progr_revisione,2,'0') id
  from eledsr dsr
/
comment on table eledsr_v is 'Elettorale - Dizionario Storico Revisioni (view)'
/
