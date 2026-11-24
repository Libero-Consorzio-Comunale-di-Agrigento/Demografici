--liquibase formatted sql
--changeset amonopoli:202605110855_1 runOnChange:true stripComments:false
create or replace function f_SCAW_catalogo_FAM
(p_cod_eve		in	number
,p_cod_mov 		in 	number
,p_sesso 		in 	varchar2
,p_data_reg 		in 	varchar2
,p_pratica_eve 		in 	number
,p_anno_pratica_eve 	in 	number
,p_id_catalogo		in 	varchar2)

return varchar2

IS

w_cod_fam		number;
w_progr_fam		number;
w_dati_fam		varchar2(32000);
w_catalogo		varchar2(32000);

w_step			number;

cursor sel_fam is
SELECT wmf.*,
       DECODE(wmf.cod_eve,
         2,'da',3,'da',4,'da',7,'da',
         50,'a',51,'a',52,'a',55,'a',56,'a',93,'a',94,'a','') DA_A,
       decode(wmf.cod_mov||wmf.cod_eve,
         '251','* Per conferma dei DATI ANAGRAFICI di :',
         '455','* Per conferma dei DATI ANAGRAFICI di :',
         '456','* Per conferma dei DATI ANAGRAFICI di :') CONFERMA
  FROM anawmf WMF
 WHERE wmf.cod_eve             = p_cod_eve
   AND wmf.cod_mov             = p_cod_mov
   AND wmf.pratica             = p_pratica_eve
   AND wmf.anno_pratica        = p_anno_pratica_eve
   AND wmf.data_reg 	   = p_data_reg
 ORDER BY sequenza
;
 
begin
  w_progr_fam	:= 0;

  for rec in sel_fam loop
      w_progr_fam	:= w_progr_fam + 1;

      if rec.conferma is not null then
w_step := w_progr_fam||'.'||1;
         w_dati_fam := rec.CONFERMA||chr(10)||chr(10);
      end if;

w_step := w_progr_fam||'.'||2;
      w_dati_fam    := w_dati_fam||rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PAR_EDIT;

      if rec.paternita is not null or rec.maternita is not null then
w_step := w_progr_fam||'.'||3;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.PATERNITA||' '||rec.MATERNITA;      
      end if;

w_step := w_progr_fam||'.'||4;
      w_dati_fam    := w_dati_fam||chr(10)||
                       chr(9)||rec.DATA_NAS_EDIT||' a '||rec.DES_COM_NAS;
 
      if rec.atto_nas is not null then
w_step := w_progr_fam||'.'||5;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.ATTO_NAS;      
      end if;     

w_step := w_progr_fam||'.'||6;
      w_dati_fam    := w_dati_fam||chr(10)||
                       chr(9)||rec.DI_SESSO;
w_step := w_progr_fam||'.'||7;
      w_dati_fam    := w_dati_fam||chr(10)||
                       chr(9)||rec.STATO_CIVILE||' '||rec.COGNOME_NOME_CN;

      if rec.data_mat_ved is not null then
w_step := w_progr_fam||'.'||8;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.DATA_MAT_VED;
      end if;

      if rec.atto_mat_ved is not null then
w_step := w_progr_fam||'.'||9;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.ATTO_MAT_VED;
      end if;

      if rec.TITOLO_STUDIO is not null then
w_step := w_progr_fam||'.'||10;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.TITOLO_STUDIO;
      end if;

      if rec.DES_COD_PROF is not null then
w_step := w_progr_fam||'.'||11;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.DES_COD_PROF;
      end if;

      if rec.DES_NAZIONALITA is not null then
w_step := w_progr_fam||'.'||12;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.DES_NAZIONALITA;
      end if;

      if rec.DES_COD_FISCALE is not null then
w_step := w_progr_fam||'.'||13;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.DES_COD_FISCALE;
      end if;

      if p_id_catalogo in (2,3,4) then
w_step := w_progr_fam||'.'||14;
         w_dati_fam := w_dati_fam||chr(10)||
                       chr(9)||rec.INIBIZIONE_ESPATRIO;
      end if;

w_step := w_progr_fam||'.'||15;
      w_dati_fam    := w_dati_fam||chr(10)||chr(10)||
                       rec.EVENTO||' '||rec.DATA_EVE||' '||rec.DA_A||' '||rec.DES_COM_EVE;

      if rec.pratica_edit is not null then
w_step := w_progr_fam||'.'||16;
         w_dati_fam    := w_dati_fam||chr(10)||
                          rec.PRATICA_EDIT;
      end if;

      if p_id_catalogo in (2,3,4) then
w_step := w_progr_fam||'.'||17;
         w_dati_fam   := w_dati_fam||chr(10)||chr(10)||
                         'Eventi di Stato Civile:'||chr(10)||
                         f_SCAW_catalogo_ESC(rec.matricola,1);
      end if;

w_step := w_progr_fam||'.'||18;
      w_dati_fam   := w_dati_fam||chr(10)||chr(10)||
                      'Documenti:'||chr(10)||
                      f_SCAW_catalogo_DOC(rec.matricola,'XX','',1);

      if p_id_catalogo in (3,4) then
w_step := w_progr_fam||'.'||19;
         w_dati_fam   := w_dati_fam||chr(10)||chr(10)||
                         f_SCAW_catalogo_AUC(rec.matricola,1);
w_step := w_progr_fam||'.'||20;
         w_dati_fam   := w_dati_fam||chr(10)||chr(10)||
                         f_SCAW_catalogo_VIN(rec.matricola,1);
      end if;

      if p_id_catalogo in (4) then
w_step := w_progr_fam||'.'||21;
         if rec.matricola_militare||rec.classe_leva||rec.numero_lista is not null then
            w_dati_fam   := w_dati_fam||chr(10)||chr(10)||
                            'Dati del Ruolo Matricolare:'||chr(10)||
                            rec.MATRICOLA_MILITARE||' '||rec.CLASSE_LEVA||' '||rec.NUMERO_LISTA;
         end if;
w_step := w_progr_fam||'.'||22;
         if rec.des_esito||rec.des_com_leva||rec.des_com_distretto is not null then
            w_dati_fam   := w_dati_fam||chr(10)||
                            rec.DES_ESITO||' '||rec.DES_COM_LEVA||' '||rec.DES_COM_DISTRETTO;
         end if;
w_step := w_progr_fam||'.'||23;
         if rec.data_arruolamento||rec.data_chiamata||rec.data_congedo is not null then
            w_dati_fam   := w_dati_fam||chr(10)||
                            rec.DATA_ARRUOLAMENTO||' '||rec.DATA_CHIAMATA||' '||rec.DATA_CONGEDO;
         end if;
w_step := w_progr_fam||'.'||24;
         if rec.des_arma is not null then
            w_dati_fam   := w_dati_fam||chr(10)||
                            rec.DES_ARMA;
         end if;
w_step := w_progr_fam||'.'||25;
         if rec.des_corpo is not null then
            w_dati_fam   := w_dati_fam||chr(10)||
                            rec.DES_CORPO;
         end if;
w_step := w_progr_fam||'.'||26;
         if rec.forza is not null then
            w_dati_fam   := w_dati_fam||chr(10)||
                            rec.FORZA;
         end if;
w_step := w_progr_fam||'.'||27;
         if rec.des_grado is not null then
            w_dati_fam   := w_dati_fam||chr(10)||
                            rec.DES_GRADO;
         end if;
      end if;

w_step := w_progr_fam||'.'||28;
      if w_progr_fam = 1 then
	 w_catalogo	:= w_dati_fam;
      else
	 w_catalogo 	:= w_catalogo||chr(10)||chr(10)||w_dati_fam;
      end if;
  end loop;

w_step := w_progr_fam||'.'||29;
  w_catalogo := w_catalogo||chr(10);

  return w_catalogo;

exception
  when others then
       w_catalogo := '';
--       w_catalogo := w_step||' - '||SQLERRM;
       return w_catalogo;
end;
/
