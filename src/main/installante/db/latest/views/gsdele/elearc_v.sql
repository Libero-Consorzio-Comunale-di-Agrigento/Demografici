--liquibase formatted sql
--changeset amonopoli:202602111520 runOnChange:true stripComments:false
create or replace function f_ELE_flag_giacenza_TEE
(a_matricola		IN	number
,a_tessera		IN	number
,a_data_tessera		IN	number
)

return varchar2

IS

w_flag		varchar2(255);

begin
  if a_matricola is not null and a_tessera is not null and a_data_tessera is not null then
     begin
       select flag_giacenza
         into w_flag
         from eletee
        where matricola    = a_matricola
          and tessera      = a_tessera
          and data_tessera = a_data_tessera
          and rownum = 1
       ;
     exception
       when others then 
            w_flag := '';
     end;
  end if;

  return w_flag;
end;
/
create or replace view elearc_v
AS
select ele.MATRICOLA
     , ele.COGNOME_NOME
     , ele.SESSO
     , ele.STATO
     , ele.MOTIVO
     , ele.COD_VIA_ELE
     , ele.NUM_CIV_ELE
     , ele.SUFFISSO_ELE
     , ele.INTERNO_ELE
     , ele.VIA_AIRE_ELE
     , ele.COD_PRO_AIRE_ELE
     , ele.COD_COM_AIRE_ELE
     , ele.FASCICOLO
     , ele.ANNO
     , ele.SEZIONE
     , ele.PROGR_LISTA_SEZ
     , ele.PROGR_LISTA_GEN
     , ele.REVISIONE
     , ele.PROGR_REVISIONE
     , ele.ZIPCODE_ELE
     , ele.TESSERA_ELE
     , ele.DATA_TESSERA_ELE
     , f_ELE_flag_giacenza_TEE(ele.matricola,ele.tessera_ele,ele.data_tessera_ele) flag_giacenza_tessera_ele
     , ele.NOTE
     , ele.SCALA_ELE
     , ele.PIANO_ELE
     , ele.SUB_INTERNO_ELE
     , ele.CIVICO_ESTERNO_ELE
     , ele.CIVICO_INTERNO_ELE
     , ele.ID_DOCUMENTO_GDM       
--
     , dtl.cod_tl tipo_lista
     , dtl.descrizione_breve des_tipo_lista
     , f_cognome(ele.cognome_nome) cognome
     , f_nome(ele.cognome_nome) nome
     , to_date(ele.data_tessera_ele,'j') d_data_tessera_ele
-- 
     , 'ELEANA' archivio_rif
     , 'ELEANA'||lpad(matricola,10,'0') ID
  from eledtl dtl, eleana ele
 where dtl.cod_tl = 'O'
UNION
select ela.MATRICOLA
     , ela.COGNOME_NOME
     , ela.SESSO
     , ela.STATO
     , ela.MOTIVO
     , ela.COD_VIA_ELE
     , ela.NUM_CIV_ELE
     , ela.SUFFISSO_ELE
     , ela.INTERNO_ELE
     , ela.VIA_AIRE_ELE
     , ela.COD_PRO_AIRE_ELE
     , ela.COD_COM_AIRE_ELE
     , ela.FASCICOLO
     , ela.ANNO
     , ela.SEZIONE
     , ela.PROGR_LISTA_SEZ
     , ela.PROGR_LISTA_GEN
     , ela.REVISIONE
     , ela.PROGR_REVISIONE
     , ela.ZIPCODE_ELE
     , ela.TESSERA_ELE
     , ela.DATA_TESSERA_ELE
     , f_ELE_flag_giacenza_TEE(ela.matricola,ela.tessera_ele,ela.data_tessera_ele) flag_giacenza_tessera_ele
     , ela.NOTE
     , ela.SCALA_ELE
     , ela.PIANO_ELE
     , ela.SUB_INTERNO_ELE
     , ela.CIVICO_ESTERNO_ELE
     , ela.CIVICO_INTERNO_ELE
     , ela.ID_DOCUMENTO_GDM       
--
     , ela.tipo_lista
     , dtl.descrizione_breve des_tipo_lista
     , f_cognome(ela.cognome_nome) cognome
     , f_nome(ela.cognome_nome) nome
     , to_date(ela.data_tessera_ele,'j') d_data_tessera_ele
-- 
     , 'ELEELA' archivio_rif
     , 'ELEELA'||lpad(matricola,10,'0') ID
  from eledtl dtl, eleela ela
 where dtl.cod_tl = ela.tipo_lista
/
comment on table elearc_v is 'Elettorale - Archivio Elettori - Ordinarie + Liste Aggiunte (view)'
/
