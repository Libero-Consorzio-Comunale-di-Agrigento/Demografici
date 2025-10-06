--liquibase formatted sql
--changeset amonopoli:202412051615 runAlways:true stripComments:false
create or replace view anadoc_v
AS
select doc.*,
-- des_com_ente
       f_comune_al(doc.cod_pro_ente,doc.cod_com_ente,'') des_com_ente,
-- sigla_pro_ente
       f_provincia_stato_al(doc.cod_pro_ente,doc.cod_com_ente,'','S','','') sigla_pro_ente,
-- des_com_ente_agg
       f_comune_al(doc.cod_pro_ente_agg,doc.cod_com_ente_agg,'') des_com_ente_agg,
-- sigla_pro_ente_agg
       f_provincia_stato_al(doc.cod_pro_ente_agg,doc.cod_com_ente_agg,'','S','','') sigla_pro_ente_agg
  from anadoc doc
/
COMMENT ON TABLE ANADOC IS 'Anagrafe - Documenti (view)'
/
