--liquibase formatted sql
--changeset amonopoli:202602251210_2 runAlways:true runOnChange:true stripComments:false
create or replace view anadpi_v
as 
select dpi.*,
       dpi.sesso||lpad(dpi.ist_rp,2,'0') ID,
       dpi.sesso||dpi.cod_rp id_anadrp
  from anadpi dpi
/
comment on table anadpi_v is 'Anagrafe - Dizionario codici di Rapporto Parentela Istat (view)'
/
