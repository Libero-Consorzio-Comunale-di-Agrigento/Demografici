--liquibase formatted sql
--changeset amonopoli:202311061145 runAlways:true runOnChange:true stripComments:false
create or replace view civann_v
AS
select v.*,
       decode(v.tipo_atto,
         7,4,
         9,4,
         -7,-4,
         -9,-4,
         6,1,
         8,5,
       v.tipo_atto) tipo_atto_rif,
       decode(v.tipo_atto,
         7,2,
         9,4,
         -7,2,
         -9,-4,
         6,2,
         8,2,
       v.tipo_atto) tipo_atto_ann,
       decode(substr(v.formula,1,1),
         '5','5',
         'X','X',
       '1') tipo_formula,
-- testo_annotazione_per_atto
       v.testo_annotazione||
         decode(f_flag_ANSC(),'S',to_char(null),
           ltrim(decode(f_CIV_get_campo(v.tipo_atto, v.id_atto, 'NATURA'), 'O',
              chr(10)||
              f_valore_inp('ATTI_LI',1,255,'X','')||' '||
              'li '|| nvl(to_char(to_date(v.data_reg,'j'),'dd/mm/yyyy'),'__________') ||
              ' L''UFFICIALE DELLO STATO CIVILE'||' ______________________________' ))) testo_annotazione_per_atto,
-- num_colonne
       41 num_colonne,
-- num_righe
       (round(length(v.testo_annotazione)/39)+8) num_righe,
-- flag_firmato_usc_ansc
       f_ANSC_flag_firmato('ANN', v.id, 'USC') flag_firmato_usc_ansc,
-- des_com_prov
       f_comune_al(v.cod_pro_prov,v.cod_com_prov,to_char(v.d_data_prov,'j')) des_com_prov,
-- sigla_pro_prov
       f_provincia_stato_al(v.cod_pro_prov,v.cod_com_prov,'','S','',to_char(v.d_data_prov,'j')) sigla_pro_prov,
-- flag_modello_provv
       f_CIV_flag_modello_istat('PROVV',null,v.id) flag_modello_provv
 from (select ann.*,
              f_CIV_formula_ann(ann.tipo_atto,ann.formula,'') formula_dfa,
              f_CIV_formula_ann(ann.tipo_atto,ann.formula,'S') des_formula,
              nvl(rtrim(f_valore_inp('ATTI_A3',1,1,'X','S')),'N') atti_a3
         from civann ann) v
/
comment on table civann_v is 'Stato Civile - Annotazioni (view)'
/
