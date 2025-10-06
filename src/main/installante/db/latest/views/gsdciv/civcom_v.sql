--liquibase formatted sql
--changeset amonopoli:202303061000 runAlways:true runOnChange:true stripComments:false
create or replace view civcom_v
as
select c.*,
       decode(c.tipo_atto,
         7,4,
         9,4,
         -7,-4,
         -9,-4,
         6,1,
         8,5,
       c.tipo_atto) tipo_atto_rif,
       decode(c.tipo_atto,
         7,2,
         9,4,
         -7,2,
         -9,-4,
         6,2,
         8,2,
       c.tipo_atto) tipo_atto_com,
       decode(c.formula,'','',
         decode(substr(c.formula,1,1),
           '5','5',
           'X','X',
         '1')) tipo_formula,
       'S' flag_dettagli,
       f_CIV_flag_protocollo(c.id,c.codice_co,c.tipo_atto,c.formula) flag_protocollo,
       f_CIV_flag_albo_pretorio(c.id,c.codice_co,c.tipo_atto,c.formula) flag_albo_pretorio,
       f_CIV_formula_ann(c.tipo_atto,c.formula,'') formula_dfa,
       f_CIV_formula_ann(c.tipo_atto,c.formula,'S') des_formula,
       f_CIV_des_comunicazione(c.tipo_atto,c.codice_co,c.formula, 'S') des_nome_file_comunicazione,
       f_CIV_des_comunicazione(c.tipo_atto,c.codice_co,c.formula) des_comunicazione,
       f_CIV_des_comunicazione_estesa(c.tipo_atto,c.codice_co,c.formula,c.ufficio,c.anno,c.parte,c.serie,c.atto,c.id_atto_rif,1) des_comunicazione_CIT,
       f_CIV_des_comunicazione_estesa(c.tipo_atto,c.codice_co,c.formula,c.ufficio,c.anno,c.parte,c.serie,c.atto,c.id_atto_rif,2) des_comunicazione_NAS,
       f_CIV_des_comunicazione_estesa(c.tipo_atto,c.codice_co,c.formula,c.ufficio,c.anno,c.parte,c.serie,c.atto,c.id_atto_rif,4) des_comunicazione_MAT,
       f_CIV_des_comunicazione_estesa(c.tipo_atto,c.codice_co,c.formula,c.ufficio,c.anno,c.parte,c.serie,c.atto,c.id_atto_rif,-4) des_comunicazione_UCI,
       f_CIV_des_comunicazione_estesa(c.tipo_atto,c.codice_co,c.formula,c.ufficio,c.anno,c.parte,c.serie,c.atto,c.id_atto_rif,5) des_comunicazione_MOR
  from civcom c
/
comment on table civcom_v is 'Stato Civile - Comunicazioni (view)'
/

