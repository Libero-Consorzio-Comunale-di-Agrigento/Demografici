--liquibase formatted sql
--changeset amonopoli:202411051720 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW CERDDC_FILTRO
AS 
SELECT dce.cod_certificato
     , dri.cod_ri modalita_rilascio
     , decode(dri.esenzione_diritti,'SI',to_number(null),
         decode(dri.fascia_tariffaria,'',dtd_1.importo_1,dtd_1.importo_2)) segreteria
     , decode(dri.esenzione_diritti,'SI',to_number(null),
         decode(dri.fascia_tariffaria,'',dtd_2.importo_1,dtd_2.importo_2)) stato_civile
     , decode(dri.esenzione_diritti,'SI',to_number(null),
         decode(dri.fascia_tariffaria,'',dtd_3.importo_1,dtd_3.importo_2)) carta_identita
     , decode(dri.esenzione_diritti,'SI',to_number(null),
         decode(dri.fascia_tariffaria,'',dtd_4.importo_1,dtd_4.importo_2)) rimborso_st
     , decode(dri.esenzione_diritti,'SI',to_number(null),
         decode(dri.fascia_tariffaria,'',to_number(null),dtd_9.importo_1)) bollo
  FROM cerdri dri
     , cerdtd dtd_1
     , cerdtd dtd_2
     , cerdtd dtd_3
     , cerdtd dtd_4
     , cerdtd dtd_9
     , cerddc ddc_1
     , cerddc ddc_2
     , cerddc ddc_3
     , cerddc ddc_4
     , cerdce dce
 where dtd_9.cod_diritto       (+) = 9
   and dtd_9.fascia_tariffaria (+) = dri.fascia_tariffaria
   and dtd_1.cod_diritto       (+) = ddc_1.cod_diritto
   and dtd_1.fascia_tariffaria (+) = ddc_1.fascia_tariffaria
   and ddc_1.cod_certificato   (+) = dce.cod_certificato
   and ddc_1.cod_diritto       (+) = 1
   and dtd_2.cod_diritto       (+) = ddc_2.cod_diritto
   and dtd_2.fascia_tariffaria (+) = ddc_2.fascia_tariffaria
   and ddc_2.cod_certificato   (+) = dce.cod_certificato
   and ddc_2.cod_diritto       (+) = 2
   and dtd_3.cod_diritto       (+) = ddc_3.cod_diritto
   and dtd_3.fascia_tariffaria (+) = ddc_3.fascia_tariffaria
   and ddc_3.cod_certificato   (+) = dce.cod_certificato
   and ddc_3.cod_diritto       (+) = 3
   and dtd_4.cod_diritto       (+) = ddc_4.cod_diritto
   and dtd_4.fascia_tariffaria (+) = ddc_4.fascia_tariffaria
   and ddc_4.cod_certificato   (+) = dce.cod_certificato
   and ddc_4.cod_diritto       (+) = 4
/
comment on table cerddc_filtro is 'Certificazione - Filtri Diritti Per Certificato / Modalità di Rilascio (view)'
/
