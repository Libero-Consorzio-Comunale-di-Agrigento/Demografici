--liquibase formatted sql
--changeset snocca:202303130930 runAlways:true runOnChange:true stripComments:false
create or replace view CIVTTA_V
AS
SELECT tta.*,
-- cognome_nome_1
       tta.cognome_1||' '||tta.nome_1 cognome_nome_1,
-- des_com_nas_1
       f_comune_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,to_char(tta.d_data_nas_1,'j')) des_com_nas_1,
-- sigla_pro_nas_1
       f_provincia_stato_al(tta.cod_pro_nas_1,tta.cod_com_nas_1,'','S','',to_char(tta.d_data_nas_1,'j')) sigla_pro_nas_1,
-- des_com_res_1
       f_comune_al(tta.cod_pro_res_1,tta.cod_com_res_1,'') des_com_res_1,
-- sigla_pro_res_1
       f_provincia_stato_al(tta.cod_pro_res_1,tta.cod_com_res_1,'','S','','') sigla_pro_res_1,
-- cognome_nome_2
       tta.cognome_2||' '||tta.nome_2 cognome_nome_2,
-- des_com_nas_2
       f_comune_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,to_char(tta.d_data_nas_2,'j')) des_com_nas_2,
-- sigla_pro_nas_2
       f_provincia_stato_al(tta.cod_pro_nas_2,tta.cod_com_nas_2,'','S','',to_char(tta.d_data_nas_2,'j')) sigla_pro_nas_2,
-- des_com_res_2
       f_comune_al(tta.cod_pro_res_2,tta.cod_com_res_2,'') des_com_res_2,
-- sigla_pro_res_2
       f_provincia_stato_al(tta.cod_pro_res_2,tta.cod_com_res_2,'','S','','') sigla_pro_res_2,
-- cognome_nome_3
       tta.cognome_3||' '||tta.nome_3 cognome_nome_3,
-- des_com_nas_3
       f_comune_al(tta.cod_pro_nas_3,tta.cod_com_nas_3,to_char(tta.d_data_nas_3,'j')) des_com_nas_3,
-- sigla_pro_nas_3
       f_provincia_stato_al(tta.cod_pro_nas_3,tta.cod_com_nas_3,'','S','',to_char(tta.d_data_nas_3,'j')) sigla_pro_nas_3,
-- des_com_res_3
       f_comune_al(tta.cod_pro_res_3,tta.cod_com_res_3,'') des_com_res_3,
-- sigla_pro_res_3
       f_provincia_stato_al(tta.cod_pro_res_3,tta.cod_com_res_3,'','S','','') sigla_pro_res_3,
-- cognome_nome_4
       tta.cognome_4||' '||tta.nome_4 cognome_nome_4,
-- des_com_nas_4
       f_comune_al(tta.cod_pro_nas_4,tta.cod_com_nas_4,to_char(tta.d_data_nas_4,'j')) des_com_nas_4,
-- sigla_pro_nas_4
       f_provincia_stato_al(tta.cod_pro_nas_4,tta.cod_com_nas_4,'','S','',to_char(tta.d_data_nas_4,'j')) sigla_pro_nas_4,
-- des_com_res_4
       f_comune_al(tta.cod_pro_res_4,tta.cod_com_res_4,'') des_com_res_4,
-- sigla_pro_res_4
       f_provincia_stato_al(tta.cod_pro_res_4,tta.cod_com_res_4,'','S','','') sigla_pro_res_4
  FROM civtta tta
/
comment on table CIVTTA_V is 'Stato Civile - Testimoni per Atto (view)'
/
