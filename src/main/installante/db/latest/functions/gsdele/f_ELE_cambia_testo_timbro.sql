--liquibase formatted sql
--changeset amonopoli:202603061455 runOnChange:true stripComments:false
create or replace function f_ELE_cambia_testo_timbro
(a_tipo_tim		IN	number
,a_progr_tim		IN	number
,a_sesso		IN	varchar2
,a_sezione		IN	number
,a_testo_tim		IN	varchar2
,a_flag_revisione	IN	varchar2	default NULL
,a_tipo_lista		IN	varchar2	default NULL
,a_flag_estratto	IN	varchar2	default NULL
)

return varchar2

IS

w_iscritti			number;
w_iscrivendi_se			number;
w_cancellandi_se		number;
w_votanti			number;
w_votanti_aire			number;
w_votanti_ovi			number;
w_non_votanti			number;
w_non_votanti_fs		number;

w_iscrivendi_I		number;
w_iscrivendi_E		number;
w_cancellandi_C		number;
w_cancellandi_E		number;

w_progr_rif		number;
w_progr_rif_count	number;
w_progr_tot		number;
w_num_pagine		number;

w_comune_utente		varchar2(255) := f_get_comune_cliente('DES_COMUNE');
w_solo_comune_utente	varchar2(255) := f_get_comune_cliente('DES_COM');
w_data_oggi		varchar2(255) := to_char(sysdate,'dd/mm/yyyy');
w_sezione		varchar2(255) := nvl(to_char(a_sezione),'___');

w_testo		varchar2(4000);

cursor sel_tabrep is
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       nvl(W_VERBALE1_3,'__________') W_VERBALE1_3, nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE1_3,
       nvl(W_VERBALE2_1,'__________') W_VERBALE2_1, nvl(W_DATA_VERBALE2_1,'__________') W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       nvl(W_DATA_VERBALE2_3,'__________') W_DATA_VERBALE2_3,
       to_char(null) w_data_verbale2_4,
       W_ANNO_ELEZIONI, W_PROGR_ELEZIONI,
       nvl(W_DATA_ELEZIONI,'__________') W_DATA_ELEZIONI,
       to_char(null) W_AI_SEGGI, to_char(null) W_ALFABETICO, to_char(null) W_STORICO,
       to_char(null) W_FLAG_POLITICHE, to_char(null) W_FLAG_REFERENDUM, to_char(null) W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE_BL,
       w_SALTO_P,
       W_TIMBRO1_1, W_TIMBRO1_2, W_TIMBRO1_3, W_TIMBRO2_1, W_TIMBRO2_2, W_TIMBRO2_3, 'N' W_TIMBRO2_4,
       to_char(null) W_REVISIONE,
       to_char(null) W_DATA_TIMBRO1_2
  From tabrep_LGA3
 where terminale         = 'ELELGA3'
   and a_sezione         is null
   and a_flag_revisione  is null
   and a_tipo_lista is null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       nvl(W_VERBALE1_3,'__________') W_VERBALE1_3, nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE1_3,
       nvl(W_VERBALE2_1,'__________') W_VERBALE2_1, nvl(W_DATA_VERBALE2_1,'__________') W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       nvl(W_DATA_VERBALE2_3,'__________') W_DATA_VERBALE2_3,
       nvl(W_DATA_VERBALE2_4,'__________') W_DATA_VERBALE2_4,
       W_ANNO_ELEZIONI, W_PROGR_ELEZIONI,
       nvl(W_DATA_ELEZIONI,'__________') W_DATA_ELEZIONI,
       W_AI_SEGGI, W_ALFABETICO, W_STORICO,
       W_FLAG_POLITICHE, W_FLAG_REFERENDUM, W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE_BL,
       w_SALTO_P,
       W_TIMBRO1_1, W_TIMBRO1_2, W_TIMBRO1_3, W_TIMBRO2_1, W_TIMBRO2_2, W_TIMBRO2_3, W_TIMBRO2_4,
       to_char(null) W_REVISIONE,
       to_char(null) W_DATA_TIMBRO1_2
  From tabrep_LSA3
 where terminale         = 'ELELSA3'
   and a_sezione         is not null
   and a_flag_revisione  is null
   and a_tipo_lista      is null
   and a_flag_estratto   is null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       nvl(W_VERBALE1_3,'__________') W_VERBALE1_3, nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE1_3,
       nvl(W_VERBALE2_1,'__________') W_VERBALE2_1, nvl(W_DATA_VERBALE2_1,'__________') W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       nvl(W_DATA_VERBALE2_3,'__________') W_DATA_VERBALE2_3,
       nvl(W_DATA_VERBALE2_4,'__________') W_DATA_VERBALE2_4,
       W_ANNO_ELEZIONI, W_PROGR_ELEZIONI,
       nvl(W_DATA_ELEZIONI,'__________') W_DATA_ELEZIONI,
       W_AI_SEGGI, W_ALFABETICO, W_STORICO,
       W_FLAG_POLITICHE, W_FLAG_REFERENDUM, W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE_BL,
       w_SALTO_P,
       W_TIMBRO1_1, W_TIMBRO1_2, W_TIMBRO1_3, W_TIMBRO2_1, W_TIMBRO2_2, W_TIMBRO2_3, W_TIMBRO2_4,
       to_char(null) W_REVISIONE,
       to_char(null) W_DATA_TIMBRO1_2
  From tabrep_SELS
 where terminale         = 'ELESELS'
   and a_sezione         is not null
   and a_flag_revisione  is null
   and a_tipo_lista      is null
   and a_flag_estratto   is not null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       to_char(null) w_verbale1_3, to_char(null) w_data_verbale1_3,
       to_char(null) W_VERBALE2_1, to_char(null) W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       to_char(null) W_DATA_VERBALE2_3,
       to_char(null) w_data_verbale2_4,
       to_char(null) W_ANNO_ELEZIONI, to_char(null) W_PROGR_ELEZIONI,
       to_char(null) W_DATA_ELEZIONI,
       to_char(null) W_AI_SEGGI, to_char(null) W_ALFABETICO, to_char(null) W_STORICO,
       to_char(null) W_FLAG_POLITICHE, to_char(null) W_FLAG_REFERENDUM, to_char(null) W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       to_char(null) W_DATA_VERBALE_BL,
       'N' w_salto_p,
       'N' W_TIMBRO1_1, W_TIMBRO1_2, 'N' W_TIMBRO1_3, 'N' W_TIMBRO2_1, W_TIMBRO2_2, 'N' W_TIMBRO2_3, 'N' W_TIMBRO2_4,
       W_REVISIONE,
       to_char(null) W_DATA_TIMBRO1_2
  From tabrep_CGA3
 where terminale         = 'ELECGA3'
   and a_sezione         is null
   and a_flag_revisione  is not null
   and a_tipo_lista is null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       to_char(null) W_VERBALE1_3, to_char(null) W_DATA_VERBALE1_3,
       to_char(null) W_VERBALE2_1, to_char(null) W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       to_char(null) W_DATA_VERBALE2_3,
       to_char(null) W_DATA_VERBALE2_4,
       to_char(null) W_ANNO_ELEZIONI, to_char(null) W_PROGR_ELEZIONI,
       to_char(null) W_DATA_ELEZIONI,
       to_char(null) W_AI_SEGGI, to_char(null) W_ALFABETICO, to_char(null) W_STORICO,
       to_char(null) W_FLAG_POLITICHE, to_char(null) W_FLAG_REFERENDUM, to_char(null) W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       to_char(null) W_DATA_VERBALE_BL,
       'N' w_salto_p,
       'N' W_TIMBRO1_1, W_TIMBRO1_2, 'N' W_TIMBRO1_3, 'N' W_TIMBRO2_1, W_TIMBRO2_2, 'N' W_TIMBRO2_3, 'N' W_TIMBRO2_4,
       W_REVISIONE,
       W_DATA_TIMBRO1_2
  From tabrep_CSA3
 where terminale         = 'ELECSA3'
   and a_sezione         is not null
   and a_flag_revisione  is not null
   and a_tipo_lista is null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       to_char(null) w_verbale1_3, to_char(null) w_data_verbale1_3,
       nvl(W_VERBALE2_1,'__________') W_VERBALE2_1, nvl(W_DATA_VERBALE2_1,'__________') W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       nvl(W_DATA_VERBALE2_3,'__________') W_DATA_VERBALE2_3,
       to_char(null) w_data_verbale2_4,
       W_ANNO_ELEZIONI, W_PROGR_ELEZIONI,
       nvl(W_DATA_ELEZIONI,'__________') W_DATA_ELEZIONI,
       to_char(null) W_AI_SEGGI, to_char(null) W_ALFABETICO, to_char(null) W_STORICO,
       to_char(null) W_FLAG_POLITICHE, to_char(null) W_FLAG_REFERENDUM, to_char(null) W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE_BL,
       w_SALTO_P,
       W_TIMBRO1_1, W_TIMBRO1_2, W_TIMBRO1_3, W_TIMBRO2_1, W_TIMBRO2_2, W_TIMBRO2_3, 'N' W_TIMBRO2_4,
       to_char(null) W_REVISIONE,
       to_char(null) W_DATA_TIMBRO1_2
  From tabrep_LGAA
 where terminale         = 'ELEGAA3'
   and a_sezione         is null
   and a_flag_revisione  is null
   and a_tipo_lista is   not null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       nvl(W_VERBALE1_3,'__________') W_VERBALE1_3, nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE1_3,
       nvl(W_VERBALE2_1,'__________') W_VERBALE2_1, nvl(W_DATA_VERBALE2_1,'__________') W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       nvl(W_DATA_VERBALE2_3,'__________') W_DATA_VERBALE2_3,
       nvl(W_DATA_VERBALE2_4,'__________') W_DATA_VERBALE2_4,
       W_ANNO_ELEZIONI, W_PROGR_ELEZIONI,
       nvl(W_DATA_ELEZIONI,'__________') W_DATA_ELEZIONI,
       W_AI_SEGGI, W_ALFABETICO, W_STORICO,
       W_FLAG_POLITICHE, W_FLAG_REFERENDUM, W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE_BL,
       w_SALTO_P,
       W_TIMBRO1_1, W_TIMBRO1_2, W_TIMBRO1_3, W_TIMBRO2_1, W_TIMBRO2_2, W_TIMBRO2_3, W_TIMBRO2_4,
       to_char(null) W_REVISIONE,
       to_char(null) W_DATA_TIMBRO1_2
  From tabrep_LSAA
 where terminale         = 'ELESAA3'
   and a_sezione         is not null
   and a_flag_revisione  is null
   and a_tipo_lista      is not null
   and a_flag_estratto   is null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       nvl(W_VERBALE1_3,'__________') W_VERBALE1_3, nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE1_3,
       nvl(W_VERBALE2_1,'__________') W_VERBALE2_1, nvl(W_DATA_VERBALE2_1,'__________') W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       nvl(W_DATA_VERBALE2_3,'__________') W_DATA_VERBALE2_3,
       nvl(W_DATA_VERBALE2_4,'__________') W_DATA_VERBALE2_4,
       W_ANNO_ELEZIONI, W_PROGR_ELEZIONI,
       nvl(W_DATA_ELEZIONI,'__________') W_DATA_ELEZIONI,
       W_AI_SEGGI, W_ALFABETICO, W_STORICO,
       W_FLAG_POLITICHE, W_FLAG_REFERENDUM, W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       nvl(W_DATA_VERBALE1_3,'__________') W_DATA_VERBALE_BL,
       w_SALTO_P,
       W_TIMBRO1_1, W_TIMBRO1_2, W_TIMBRO1_3, W_TIMBRO2_1, W_TIMBRO2_2, W_TIMBRO2_3, W_TIMBRO2_4,
       to_char(null) W_REVISIONE,
       to_char(null) W_DATA_TIMBRO1_2
  From tabrep_SELA
 where terminale         = 'ELESELA'
   and a_sezione         is not null
   and a_flag_revisione  is null
   and a_tipo_lista      is not null
   and a_flag_estratto   is not null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       to_char(null) w_verbale1_3, to_char(null) w_data_verbale1_3,
       to_char(null) W_VERBALE2_1, to_char(null) W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       to_char(null) W_DATA_VERBALE2_3,
       to_char(null) w_data_verbale2_4,
       to_char(null) W_ANNO_ELEZIONI, to_char(null) W_PROGR_ELEZIONI,
       to_char(null) W_DATA_ELEZIONI,
       to_char(null) W_AI_SEGGI, to_char(null) W_ALFABETICO, to_char(null) W_STORICO,
       to_char(null) W_FLAG_POLITICHE, to_char(null) W_FLAG_REFERENDUM, to_char(null) W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       to_char(null) W_DATA_VERBALE_BL,
       'N' w_salto_p,
       'N' W_TIMBRO1_1, W_TIMBRO1_2, 'N' W_TIMBRO1_3, 'N' W_TIMBRO2_1, W_TIMBRO2_2, 'N' W_TIMBRO2_3, 'N' W_TIMBRO2_4,
       W_REVISIONE,
       to_char(null) W_DATA_TIMBRO1_2
  From tabrep_CGAA
 where terminale         = 'ELEGAA3'
   and a_sezione         is null
   and a_flag_revisione  is not null
   and a_tipo_lista      is not null
   and rownum    = 1
UNION
select W_TIPO_FIRMA,
       nvl(W_VERBALE,'__________') w_verbale, nvl(W_DATA_VERBALE,'__________') w_data_verbale,
       to_char(null) W_VERBALE1_3, to_char(null) W_DATA_VERBALE1_3,
       to_char(null) W_VERBALE2_1, to_char(null) W_DATA_VERBALE2_1,
       nvl(W_VERBALE2_2,'__________') W_VERBALE2_2, nvl(W_DATA_VERBALE2_2,'__________') W_DATA_VERBALE2_2,
       to_char(null) W_DATA_VERBALE2_3,
       to_char(null) W_DATA_VERBALE2_4,
       to_char(null) W_ANNO_ELEZIONI, to_char(null) W_PROGR_ELEZIONI,
       to_char(null) W_DATA_ELEZIONI,
       to_char(null) W_AI_SEGGI, to_char(null) W_ALFABETICO, to_char(null) W_STORICO,
       to_char(null) W_FLAG_POLITICHE, to_char(null) W_FLAG_REFERENDUM, to_char(null) W_FLAG_AMMINISTRATIVE,
       W_DATA_RIF_SEMESTRALE, W_COMMISSIONE,
       to_char(null) W_DATA_VERBALE_BL,
       'N' w_salto_p,
       'N' W_TIMBRO1_1, W_TIMBRO1_2, 'N' W_TIMBRO1_3, 'N' W_TIMBRO2_1, W_TIMBRO2_2, 'N' W_TIMBRO2_3, 'N' W_TIMBRO2_4,
       W_REVISIONE,
       W_DATA_TIMBRO1_2
  From tabrep_CSAA
 where terminale         = 'ELESAA3'
   and a_sezione         is not null
   and a_flag_revisione  is not null
   and a_tipo_lista      is not null
   and rownum    = 1
;

cursor sel_tel_0 is
select sum(ISCRITTI_TOT_M) iscritti_tot_M,
       sum(ISCRITTI_TOT_F) iscritti_tot_F,
       sum(ISCRITTI_AIRE_M) iscritti_aire_M,
       sum(ISCRITTI_AIRE_F) iscritti_aire_F,
       sum(ISCRIVENDI_SE_M) iscrivendi_se_M,
       sum(ISCRIVENDI_SE_F) iscrivendi_se_F,
       sum(CANCELLANDI_SE_M) cancellandi_se_M,
       sum(CANCELLANDI_SE_F) cancellandi_se_F,
       sum(VOTANTI_TOT_M) votanti_tot_M,
       sum(VOTANTI_TOT_F) votanti_tot_F,
       sum(VOTANTI_AIRE_M) votanti_aire_M,
       sum(VOTANTI_AIRE_F) votanti_aire_F,
       sum(NON_VOTANTI_TOT_M) non_votanti_tot_M,
       sum(NON_VOTANTI_TOT_F) non_votanti_tot_F,
       sum(NON_VOTANTI_AIRE_M) non_votanti_aire_M,
       sum(NON_VOTANTI_AIRE_F) non_votanti_aire_F,
       sum(NON_VOTANTI_FUORI_SEDE_M) non_votanti_fs_M,
       sum(NON_VOTANTI_FUORI_SEDE_F) non_votanti_fs_F,
       sum(VOTANTI_CAMERA_TOT_M) votanti_camera_tot_M,
       sum(VOTANTI_CAMERA_TOT_F) votanti_camera_tot_F,
       sum(VOTANTI_CAMERA_AIRE_M) votanti_camera_aire_M,
       sum(VOTANTI_CAMERA_AIRE_F) votanti_camera_aire_F,
       sum(VOTANTI_OVI_M) votanti_ovi_M,
       sum(VOTANTI_OVI_F) votanti_ovi_F,
       sum(VOTANTI_OVI_CAMERA_M) votanti_ovi_camera_M,
       sum(VOTANTI_OVI_CAMERA_F) votanti_ovi_camera_F
  from eletel
 where anno_elezioni  = 0
   and progr_elezioni = 0
   and sezione        = nvl(a_sezione,sezione)
;

cursor sel_tel_ele (a_anno_ele number, a_progr_ele number) is
select sum(ISCRITTI_TOT_M) iscritti_tot_M,
       sum(ISCRITTI_TOT_F) iscritti_tot_F,
       sum(ISCRITTI_AIRE_M) iscritti_aire_M,
       sum(ISCRITTI_AIRE_F) iscritti_aire_F,
       sum(ISCRIVENDI_SE_M) iscrivendi_se_M,
       sum(ISCRIVENDI_SE_F) iscrivendi_se_F,
       sum(CANCELLANDI_SE_M) cancellandi_se_M,
       sum(CANCELLANDI_SE_F) cancellandi_se_F,
       sum(VOTANTI_TOT_M) votanti_tot_M,
       sum(VOTANTI_TOT_F) votanti_tot_F,
       sum(VOTANTI_AIRE_M) votanti_aire_M,
       sum(VOTANTI_AIRE_F) votanti_aire_F,
       sum(NON_VOTANTI_TOT_M) non_votanti_tot_M,
       sum(NON_VOTANTI_TOT_F) non_votanti_tot_F,
       sum(NON_VOTANTI_AIRE_M) non_votanti_aire_M,
       sum(NON_VOTANTI_AIRE_F) non_votanti_aire_F,
       sum(NON_VOTANTI_FUORI_SEDE_M) non_votanti_fs_M,
       sum(NON_VOTANTI_FUORI_SEDE_F) non_votanti_fs_F,
       sum(VOTANTI_CAMERA_TOT_M) votanti_camera_tot_M,
       sum(VOTANTI_CAMERA_TOT_F) votanti_camera_tot_F,
       sum(VOTANTI_CAMERA_AIRE_M) votanti_camera_aire_M,
       sum(VOTANTI_CAMERA_AIRE_F) votanti_camera_aire_F,
       sum(VOTANTI_OVI_M) votanti_ovi_M,
       sum(VOTANTI_OVI_F) votanti_ovi_F,
       sum(VOTANTI_OVI_CAMERA_M) votanti_ovi_camera_M,
       sum(VOTANTI_OVI_CAMERA_F) votanti_ovi_camera_F
  from eletel
 where anno_elezioni  = a_anno_ele
   and progr_elezioni = a_progr_ele
   and sezione        = nvl(a_sezione,sezione)
;

begin
  w_testo := a_testo_tim;
  for rec_par in sel_tabrep loop
      w_testo := replace(w_testo,'<COMUNE>',w_comune_utente);
      w_testo := replace(w_testo,'<comune>',w_comune_utente);
      w_testo := replace(w_testo,'<SOLO_COMUNE>',w_solo_comune_utente);
      w_testo := replace(w_testo,'<solo_comune>',w_solo_comune_utente);
      w_testo := replace(w_testo,'<DATA_OGGI>',w_solo_comune_utente);
      w_testo := replace(w_testo,'<data_oggi>',w_data_oggi);
      w_testo := replace(w_testo,'<SEZIONE>',w_sezione);
      w_testo := replace(w_testo,'<sezione>',w_sezione);

      w_testo := replace(w_testo,'<COMMISSIONE>',rec_par.w_commissione);
      w_testo := replace(w_testo,'<commissione>',rec_par.w_commissione);
      w_testo := replace(w_testo,'<DATA_RIF_SEMESTRALE>',nvl(rec_par.w_data_timbro1_2,rec_par.w_data_rif_semestrale));
      w_testo := replace(w_testo,'<data_rif_semestrale>',nvl(rec_par.w_data_timbro1_2,rec_par.w_data_rif_semestrale));
      w_testo := replace(w_testo,'<DATA_BLOCCO_LISTE>',rec_par.w_data_verbale_BL);
      w_testo := replace(w_testo,'<data_blocco_liste>',rec_par.w_data_verbale_BL);
      w_testo := replace(w_testo,'<DATA_ELEZIONI>',rec_par.w_data_elezioni);
      w_testo := replace(w_testo,'<data_elezioni>',rec_par.w_data_elezioni);

      if a_tipo_tim = 1 and a_progr_tim = 1 then
         if rec_par.w_tipo_firma = 'C' then
            w_testo := replace(w_testo,'<FIRMA>','da questa Commissione');
            w_testo := replace(w_testo,'<firma>','da questa Commissione');
         elsif rec_par.w_tipo_firma = 'U' then
            w_testo := replace(w_testo,'<FIRMA>','dall''Ufficiale Elettorale');
            w_testo := replace(w_testo,'<firma>','dall''Ufficiale Elettorale');
         elsif rec_par.w_tipo_firma = 'R' then
            w_testo := replace(w_testo,'<FIRMA>','dal Responsabile dell''Ufficio Elettorale');
            w_testo := replace(w_testo,'<firma>','dal Responsabile dell''Ufficio Elettorale');
         end if;
      elsif a_tipo_tim = 1 and a_progr_tim = 2 then
         if rec_par.w_tipo_firma = 'C' then
            w_testo := replace(w_testo,'<FIRMA>','di questa Commissione');
            w_testo := replace(w_testo,'<firma>','di questa Commissione');
         elsif rec_par.w_tipo_firma = 'U' then
            w_testo := replace(w_testo,'<FIRMA>','dell''Ufficiale Elettorale');
            w_testo := replace(w_testo,'<firma>','dell''Ufficiale Elettorale');
         elsif rec_par.w_tipo_firma = 'R' then
            w_testo := replace(w_testo,'<FIRMA>','di questo Ufficio Elettorale');
            w_testo := replace(w_testo,'<firma>','di questo Ufficio Elettorale');
         end if;
      end if;

      if a_tipo_tim = 1 and a_progr_tim in (1,2) then
         w_testo := replace(w_testo,'<VERBALE>',rec_par.w_verbale);
         w_testo := replace(w_testo,'<verbale>',rec_par.w_verbale);
         w_testo := replace(w_testo,'<DATA_VERBALE>',rec_par.w_data_verbale);
         w_testo := replace(w_testo,'<data_verbale>',rec_par.w_data_verbale);
      elsif a_tipo_tim = 1 and a_progr_tim = 3 then
         w_testo := replace(w_testo,'<DATA_BLOCCO_LISTE>',rec_par.w_data_verbale_bl);
         w_testo := replace(w_testo,'<data_blocco_liste>',rec_par.w_data_verbale_bl);
      elsif a_tipo_tim = 2 and a_progr_tim = 1 then
         w_testo := replace(w_testo,'<VERBALE>',rec_par.w_verbale2_1);
         w_testo := replace(w_testo,'<verbale>',rec_par.w_verbale2_1);
         w_testo := replace(w_testo,'<DATA_VERBALE>',rec_par.w_data_verbale2_1);
         w_testo := replace(w_testo,'<data_verbale>',rec_par.w_data_verbale2_1);
      elsif a_tipo_tim = 2 and a_progr_tim = 2 then
         w_testo := replace(w_testo,'<VERBALE>',rec_par.w_verbale2_2);
         w_testo := replace(w_testo,'<verbale>',rec_par.w_verbale2_2);
         w_testo := replace(w_testo,'<DATA_VERBALE>',rec_par.w_data_verbale2_2);
         w_testo := replace(w_testo,'<data_verbale>',rec_par.w_data_verbale2_2);
      elsif a_tipo_tim = 2 and a_progr_tim = 3 then
         w_testo := replace(w_testo,'<DATA_VERBALE>',rec_par.w_data_verbale2_3);
         w_testo := replace(w_testo,'<data_verbale>',rec_par.w_data_verbale2_3);
      end if;

      if a_tipo_lista is null then		-- liste ordinarie
         for rec_0 in sel_tel_0 loop
             if a_sesso = 'M' then
                w_iscritti       := rec_0.iscritti_tot_m;
                w_iscrivendi_se  := rec_0.iscrivendi_se_m;
                w_cancellandi_se := rec_0.cancellandi_se_m;
             elsif a_sesso = 'F' then
                w_iscritti       := rec_0.iscritti_tot_f;
                w_iscrivendi_se  := rec_0.iscrivendi_se_f;
                w_cancellandi_se := rec_0.cancellandi_se_f;
             elsif a_sesso = 'X' then
                w_iscritti       := rec_0.iscritti_tot_m + rec_0.iscritti_tot_f;
                w_iscrivendi_se  := rec_0.iscrivendi_se_m + rec_0.iscrivendi_se_f;
                w_cancellandi_se := rec_0.cancellandi_se_m + rec_0.cancellandi_se_f;
             end if;
         end loop;

         if a_flag_revisione is null and rec_par.w_anno_elezioni||rec_par.w_progr_elezioni is not null then
            for rec_ele in sel_tel_ele (rec_par.w_anno_elezioni, rec_par.w_progr_elezioni) loop
                if a_sesso = 'M' then
                   w_votanti        := rec_ele.votanti_tot_m;
                   w_votanti_aire   := rec_ele.votanti_aire_m;
                   w_votanti_ovi    := rec_ele.votanti_ovi_m;
                   w_non_votanti    := rec_ele.non_votanti_tot_m;
                   w_non_votanti_fs := rec_ele.non_votanti_fs_m;
                elsif a_sesso = 'F' then
                   w_votanti        := rec_ele.votanti_tot_f;
                   w_votanti_aire   := rec_ele.votanti_aire_f;
                   w_votanti_ovi    := rec_ele.votanti_ovi_f;
                   w_non_votanti    := rec_ele.non_votanti_tot_f;
                   w_non_votanti_fs := rec_ele.non_votanti_fs_f;
                elsif a_sesso = 'X' then
                   w_votanti        := rec_ele.votanti_tot_m + rec_ele.votanti_tot_f;
                   w_votanti_aire   := rec_ele.votanti_aire_m + rec_ele.votanti_aire_f;
                   w_votanti_ovi    := rec_ele.votanti_ovi_m + rec_ele.votanti_ovi_f;
                   w_non_votanti    := rec_ele.non_votanti_tot_m + rec_ele.non_votanti_tot_f;
                   w_non_votanti_fs := rec_ele.non_votanti_fs_m + rec_ele.non_votanti_fs_f;
                end if;
            end loop;
         end if;

      elsif a_tipo_lista is not null then	-- liste aggiunte
         begin
           select count(*)
             into w_iscritti
             from eleela
            where ((sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
              and stato      = 'E'
              and sezione    = nvl(a_sezione,sezione)
              and tipo_lista = a_tipo_lista
           ;
           w_iscrivendi_se  := 0;
           w_cancellandi_se := 0;
         exception
           when others then
                w_iscritti       := 0;
                w_iscrivendi_se  := 0;
                w_cancellandi_se := 0;
         end;

         if a_flag_revisione is null and rec_par.w_anno_elezioni||rec_par.w_progr_elezioni is not null then
            begin
              select count(*)
                into w_votanti
                from eleela ela, anaana ana
               where ((ela.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                 and ela.stato      = 'E'
                 and ela.matricola  = ana.matricola
                 and add_months(to_date(ana.data_nas,'j'),216) <= to_date(rtrim(rec_par.w_data_elezioni,'_'),'dd/mm/yyyy')
                 and ela.sezione    = nvl(a_sezione,ela.sezione)
                 and ela.tipo_lista = a_tipo_lista
              ;
              w_votanti_aire   := 0;
              w_votanti_ovi    := 0;
              w_non_votanti    := 0;
              w_non_votanti_fs := 0;
            exception
              when others then
                   w_votanti        := 0;
                   w_votanti_aire   := 0;
                   w_votanti_ovi    := 0;
                   w_non_votanti    := 0;
                   w_non_votanti_fs := 0;
            end;
         end if;
      end if;

--
-- 01/03/2022 (AM)
-- . con parametro W_AI_SEGGI = 'N' la lista viene stampata completa, comprensiva delle eventuali variazioni di semestrale
-- . con parametro W_AI_SEGGI = 'S' entrano in gioco tutti i parametri successivi (W_ALFABETICO, W_STORICO, etc...)
--
-- . con parametro W_ALFABETICO = 'N' la lista viene stampata completa
-- . con parametro W_ALFABETICO = 'S' la lista viene stampata, in ordine alfabetico, con le seguenti condizionanti:
--   . con parametro W_STORICO = 'S' vengono stampati anche in non-18enni e gli aire
--   . con parametro W_STORICO = 'N' vengono esclusi i non-18enni
--     . con parametro W_FLAG_REFERNDUM e/o W_FLAG_POLITICHE = 'S' vengono esclusi gli aire ed incluse le opzioni di voto in italia
--     . con parametro W_FLAG_AMMINISTRATIVE vengono inclusi anche gli aire
--
      if a_sezione is not null then	-- sezionali
         if a_flag_revisione is null then 		-- stampa liste sezionali
            if rec_par.w_ai_seggi = 'N' then
               w_iscritti := w_iscritti + w_iscrivendi_se - w_cancellandi_se;
            elsif rec_par.w_ai_seggi = 'S' then
               if rec_par.w_alfabetico||rec_par.w_storico = 'NN' then
                  w_iscritti := w_iscritti;
                  w_votanti  := w_iscritti;
               elsif rec_par.w_alfabetico||rec_par.w_storico = 'SS' then
                  w_iscritti := w_iscritti;
                  w_votanti  := w_iscritti;
               elsif rec_par.w_flag_referendum||rec_par.w_flag_politiche = 'NN' then
                  w_iscritti := w_votanti;
                  w_votanti  := w_votanti;
                  w_iscritti := w_iscritti - w_non_votanti_fs;
                  w_votanti  := w_votanti - w_non_votanti_fs;
               else
                  w_iscritti := w_votanti - w_votanti_aire + w_votanti_ovi;
                  w_votanti  := w_votanti - w_votanti_aire + w_votanti_ovi;
                  w_iscritti := w_iscritti - w_non_votanti_fs;
                  w_votanti  := w_votanti - w_non_votanti_fs;
               end if;
            end if;
         elsif a_flag_revisione is not null then 	-- stampa code sezionali
            if a_tipo_lista is null then		-- liste ordinarie
               begin
                 select count(*)
                   into w_iscrivendi_I
                   from anaana ana, elemov mov
                  where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ana.matricola      = mov.matricola
                    and mov.tipo_movimento = 'I'
                    and mov.sezione        = a_sezione
                    and mov.sospensione    is null
                    and mov.revisione      = rec_par.w_revisione
                 ;
                 select count(*)
                   into w_iscrivendi_E
                   from anaana ana, elemov mov
                  where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ana.matricola      = mov.matricola
                    and mov.tipo_movimento = 'E'
                    and mov.sezione        = a_sezione
                    and mov.sospensione    is null
                    and mov.revisione      = rec_par.w_revisione
                 ;
                 select count(*)
                   into w_cancellandi_C
                   from eleana ele, elemov mov
                  where ((ele.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ele.sezione        = a_sezione
                    and ele.stato          = 'E'
                    and ele.matricola      = mov.matricola
                    and mov.tipo_movimento = 'C'
                    and mov.sospensione    is null
                    and mov.revisione      = rec_par.w_revisione
                 ;
                 select count(*)
                   into w_cancellandi_E
                   from eleana ele, elemov mov
                  where ((ele.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ele.sezione        = a_sezione
                    and ele.stato          = 'E'
                    and ele.matricola      = mov.matricola
                    and mov.sezione        is not null
                    and mov.tipo_movimento = 'E'
                    and mov.sospensione    is null
                    and mov.revisione      = rec_par.w_revisione
                 ;
               exception
                 when others then
                      w_iscrivendi_I  := 0;
                      w_iscrivendi_E  := 0;
                      w_cancellandi_C := 0;
                      w_cancellandi_E := 0;
               end;

            elsif a_tipo_lista is not null then		-- liste aggiunte
               begin
                 select count(*)
                   into w_iscrivendi_I
                   from anaana ana, elemla mla
                  where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ana.matricola      = mla.matricola
                    and mla.tipo_movimento = 'I'
                    and mla.sezione        = a_sezione
                    and mla.sospensione    is null
                    and mla.tipo_lista     = a_tipo_lista
                 ;
                 select count(*)
                   into w_iscrivendi_E
                   from anaana ana, elemla mla
                  where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ana.matricola      = mla.matricola
                    and mla.tipo_movimento = 'E'
                    and mla.sezione        = a_sezione
                    and mla.sospensione    is null
                    and mla.tipo_lista     = a_tipo_lista
                 ;
                 select count(*)
                   into w_cancellandi_C
                   from eleela ela, elemla mla
                  where ((ela.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ela.sezione        = a_sezione
                    and ela.stato          = 'E'
                    and ela.tipo_lista     = mla.tipo_lista
                    and ela.matricola      = mla.matricola
                    and mla.tipo_movimento = 'C'
                    and mla.sospensione    is null
                    and mla.tipo_lista     = a_tipo_lista
                 ;
                 select count(*)
                   into w_cancellandi_E
                   from eleela ela, elemla mla
                  where ((ela.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ela.sezione        = a_sezione
                    and ela.stato          = 'E'
                    and ela.tipo_lista     = mla.tipo_lista
                    and ela.matricola      = mla.matricola
                    and mla.sezione        is not null
                    and mla.tipo_movimento = 'E'
                    and mla.sospensione    is null
                    and mla.tipo_lista     = a_tipo_lista
                 ;
               exception
                 when others then
                      w_iscrivendi_I  := 0;
                      w_iscrivendi_E  := 0;
                      w_cancellandi_C := 0;
                      w_cancellandi_E := 0;
               end;
            end if;
         end if;

      elsif a_sezione is null then	-- generali
         if a_flag_revisione is null then 		-- stampa liste generali
            w_iscritti := w_iscritti;
            w_votanti  := w_votanti;
         elsif a_flag_revisione is not null then 	-- stampa code generali
            if a_tipo_lista is null then		-- liste ordinarie
               begin
                 select count(*)
                   into w_iscrivendi_I
                   from anaana ana, elemov mov
                  where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ana.matricola      = mov.matricola
                    and mov.tipo_movimento = 'I'
                    and mov.sospensione    is null
                    and mov.revisione      = rec_par.w_revisione
                 ;
                 select count(*)
                   into w_iscrivendi_E
                   from eleana ele, anaana ana, elemov mov
--                  where ele.sesso          != ana.sesso
                  where mov.progr_lista_gen is not null
                    and ele.stato          = 'E'
                    and ele.matricola      = mov.matricola
                    and ((ana .sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ana.matricola      = mov.matricola
                    and mov.tipo_movimento = 'E'
                    and mov.sospensione    is null
                    and mov.revisione      = rec_par.w_revisione
                 ;
                 select count(*)
                   into w_cancellandi_C
                   from eleana ele, elemov mov
                  where ((ele.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ele.stato          = 'E'
                    and ele.matricola      = mov.matricola
                    and mov.tipo_movimento = 'C'
                    and mov.sospensione    is null
                    and mov.revisione      = rec_par.w_revisione
                 ;
                 select count(*)
                   into w_cancellandi_E
                   from eleana ele, anaana ana, elemov mov
--                  where ele.sesso          != ana.sesso
                  where mov.progr_lista_gen is not null
                    and ((ele.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ele.stato          = 'E'
                    and ele.matricola      = mov.matricola
                    and ana.matricola      = mov.matricola
                    and mov.tipo_movimento = 'E'
                    and mov.sospensione    is null
                    and mov.revisione      = rec_par.w_revisione
                 ;
               exception
                 when others then
                      w_iscrivendi_I  := 0;
                      w_iscrivendi_E  := 0;
                      w_cancellandi_C := 0;
                      w_cancellandi_E := 0;
               end;

            elsif a_tipo_lista is not null then		-- liste aggiunte
               begin
                 select count(*)
                   into w_iscrivendi_I
                   from anaana ana, elemla mla
                  where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ana.matricola      = mla.matricola
                    and mla.tipo_movimento = 'I'
                    and mla.sospensione    is null
                    and mla.tipo_lista     = a_tipo_lista
                 ;
                 select count(*)
                   into w_iscrivendi_E
                   from eleela ela, anaana ana, elemla mla
--                  where ela.sesso          != ana.sesso
                  where mla.progr_lista_gen is not null
                    and ela.stato          = 'E'
                    and ela.matricola      = mla.matricola
                    and ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ana.matricola      = mla.matricola
                    and mla.tipo_movimento = 'E'
                    and mla.sospensione    is null
                    and mla.tipo_lista     = a_tipo_lista
                 ;
                 select count(*)
                   into w_cancellandi_C
                   from eleela ela, elemla mla
                  where ((ela.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ela.stato          = 'E'
                    and ela.tipo_lista     = mla.tipo_lista
                    and ela.matricola      = mla.matricola
                    and mla.tipo_movimento = 'C'
                    and mla.sospensione    is null
                    and mla.tipo_lista     = a_tipo_lista
                 ;
                 select count(*)
                   into w_cancellandi_E
                   from eleela ela, anaana ana, elemla mla
--                  where ana.sesso          != ela.sesso
                  where mla.progr_lista_gen is not null
                    and ((ela.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                    and ela.stato          = 'E'
                    and ela.tipo_lista     = mla.tipo_lista
                    and ela.matricola      = mla.matricola
                    and ana.matricola      = mla.matricola
                    and mla.tipo_movimento = 'E'
                    and mla.sospensione    is null
                    and mla.tipo_lista     = a_tipo_lista
                 ;
               exception
                 when others then
                      w_iscrivendi_I  := 0;
                      w_iscrivendi_E  := 0;
                      w_cancellandi_C := 0;
                      w_cancellandi_E := 0;
               end;
            end if;
         end if;
      end if;

      if a_sesso = 'M' then
         w_testo := replace(w_testo,'<ELETTORI_ELETTRICI>','elettori');
         w_testo := replace(w_testo,'<elettori_elettrici>','elettori');
      elsif a_sesso = 'F' then
         w_testo := replace(w_testo,'<ELETTORI_ELETTRICI>','elettrici');
         w_testo := replace(w_testo,'<elettori_elettrici>','elettrici');
      elsif a_sesso = 'X' then
         w_testo := replace(w_testo,'<ELETTORI_ELETTRICI>','elettori/elettrici');
         w_testo := replace(w_testo,'<elettori_elettrici>','elettori/elettrici');
      end if;

      if a_flag_revisione is not null then		-- stampa code
         w_iscritti := w_iscritti + w_iscrivendi_I + w_iscrivendi_E - w_cancellandi_C - w_cancellandi_E;
      end if;

      w_testo := replace(w_testo,'<TOT_ISCRITTI>',w_iscritti);
      w_testo := replace(w_testo,'<tot_iscritti>',w_iscritti);
      w_testo := replace(w_testo,'<TOT_VOTANTI>',w_votanti);
      w_testo := replace(w_testo,'<tot_votanti>',w_votanti);

      if instr(upper(w_testo),'<NUMERO_PAGINE>') > 0 then
         w_progr_rif := 0;
         if a_sezione is null then
            if a_flag_revisione is null then		-- stampa lista generale
               if a_tipo_lista is null then		-- liste ordinarie
                  begin
                    select numero_x --decode(a_sesso,'M',numero_m,'F',numero_f)
                      into w_progr_rif
                      from elen02
                     where rownum = 1
                    ;
                  exception
                    when others then
                         w_progr_rif := 0;
                  end;

               elsif a_tipo_lista is not null then	-- liste aggiunte
                  begin
                    select nvl(max(ela.progr_lista_gen),0)
                      into w_progr_rif
                      from eleela ela
                     where ((ela.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                       and ela.tipo_lista      = a_tipo_lista
                       and ela.progr_lista_gen is not null
                    ;
                  exception
                    when others then
                         w_progr_rif := 0;
                  end;
               end if;
            elsif a_flag_revisione is not null then	-- stampa code generali
               if a_tipo_lista is null then		-- liste ordinarie
                  begin
                    select nvl(max(mov.progr_lista_gen),0)
                      into w_progr_rif
                      from anaana ana, elemov mov
                     where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                       and ana.matricola       = mov.matricola
                       and mov.progr_lista_gen is not null
                       and mov.sospensione     is null
                       and mov.revisione       = rec_par.w_revisione
                    ;
                  exception
                    when others then
                         w_progr_rif := 0;
                  end;
               elsif a_tipo_lista is not null then	-- liste aggiunte
                  begin
                    select nvl(max(mla.progr_lista_gen),0)
                      into w_progr_rif
                      from anaana ana, elemla mla
                     where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                       and ana.matricola       = mla.matricola
                       and mla.progr_lista_gen is not null
                       and mla.sospensione     is null
                       and mla.tipo_lista      = a_tipo_lista
                    ;
                  exception
                    when others then
                         w_progr_rif := 0;
                  end;
               end if;
            end if;
         elsif a_sezione is not null then
            if a_flag_revisione is null then		-- stampa lista sezionale
               if a_tipo_lista is null then		-- liste ordinarie
                  begin
                    select numero_x, --decode(a_sesso,'M',numero_m,'F',numero_f),
                           numero_x --decode(a_sesso,'M',numero_m,'F',numero_f)
                      into w_progr_rif, w_progr_rif_count
                      from elen03
                     where sezione = a_sezione
                       and rownum = 1
                    ;
                  exception
                    when others then
                         w_progr_rif := 0;
                  end;

               elsif a_tipo_lista is not null then		-- liste aggiunte
                  begin
                    select nvl(max(ela.progr_lista_sez),0),
                           count(distinct(ela.progr_lista_sez))
                      into w_progr_rif, w_progr_rif_count
                      from eleela ela
                     where ((ela.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                       and ela.tipo_lista      = a_tipo_lista
                       and ela.sezione         = a_sezione
                       and ela.progr_lista_sez is not null
                    ;
                  exception
                    when others then
                         w_progr_rif := 0;
                  end;
               end if;

               if rec_par.w_ai_seggi||rec_par.w_alfabetico||rec_par.w_storico = 'SSN' then
                  w_progr_rif := w_iscritti;
               elsif rec_par.w_ai_seggi||rec_par.w_alfabetico||rec_par.w_storico = 'SSS' then
                  w_progr_rif := w_progr_rif_count;
               end if;

            elsif a_flag_revisione is not null then	-- stampa code sezionali
               if a_tipo_lista is null then		-- liste ordinarie
                  begin
                    select nvl(max(mov.progr_lista_sez),0)
                      into w_progr_rif
                      from anaana ana, elemov mov
                     where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                       and ana.matricola       = mov.matricola
                       and mov.progr_lista_sez is not null
                       and mov.sospensione     is null
                       and mov.sezione         = a_sezione
                       and mov.revisione       = rec_par.w_revisione
                    ;
                  exception
                    when others then
                         w_progr_rif := 0;
                  end;
               elsif a_tipo_lista is not null then	-- liste aggiunte
                  begin
                    select nvl(max(mla.progr_lista_sez),0)
                      into w_progr_rif
                      from anaana ana, elemla mla
                     where ((ana.sesso = a_sesso and a_sesso != 'X') or a_sesso = 'X')
                       and ana.matricola       = mla.matricola
                       and mla.progr_lista_sez is not null
                       and mla.sospensione     is null
                       and mla.sezione         = a_sezione
                       and mla.tipo_lista      = a_tipo_lista
                    ;
                  exception
                    when others then
                         w_progr_rif := 0;
                  end;

               end if;
            end if;
         end if;

         if mod(w_progr_rif,10) = 0 then
            w_progr_tot  := w_progr_rif;
         elsif mod(w_progr_rif,10) = 9 then
            w_progr_tot  := w_progr_rif + 1;
         else
            if rec_par.w_salto_p = 'S' then
               w_progr_tot  := w_progr_rif+(10-mod(w_progr_rif,10));
            else
               if mod(w_progr_rif,2) = 1 then
                  w_progr_tot := w_progr_rif + 1;
               else
                  w_progr_tot  := w_progr_rif;
               end if;
            end if;
         end if;

         if a_tipo_tim = 1 and a_progr_tim = 1 then
            null;

         elsif a_tipo_tim = 1 and a_progr_tim = 2 then
            if rec_par.w_timbro1_1 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            elsif a_tipo_tim = 1 and a_progr_tim = 3 then
            if rec_par.w_timbro1_1 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_2 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;

         elsif a_tipo_tim = 2 and a_progr_tim = 1 then
            if rec_par.w_timbro1_1 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_2 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_3 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
         elsif a_tipo_tim = 2 and a_progr_tim = 2 then
            if rec_par.w_timbro1_1 = 'S' then
                  w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_2 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_3 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro2_1 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;

         elsif a_tipo_tim = 2 and a_progr_tim = 3 then
            if rec_par.w_timbro1_1 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_2 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_3 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro2_1 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro2_2 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;

         elsif a_tipo_tim = 2 and a_progr_tim = 4 then
            if rec_par.w_timbro1_1 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_2 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro1_3 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro2_1 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro2_2 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
            if rec_par.w_timbro2_3 = 'S' then
               w_progr_tot := w_progr_tot + 2;
            end if;
         end if;

         if a_flag_revisione is not null then
            w_num_pagine := '';	-- in caso di stampa code non Ã¨ possibile conteggiare il numero di pagine
         else
--            w_num_pagine := W_PROGR_TOT;
            w_num_pagine := trunc(w_progr_tot/10)+1;
         end if;

         w_testo := replace(w_testo,'<NUMERO_PAGINE>',nvl(to_char(w_num_pagine),'___'));
         w_testo := replace(w_testo,'<numero_pagine>',nvl(to_char(w_num_pagine),'___'));
      end if;
  end loop;

  if w_testo is not null then
     w_testo := '     '||w_testo;
  end if;

  return w_testo;
end;
/
