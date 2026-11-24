--liquibase formatted sql
--changeset amonopoli:202512041255_1 runOnChange:true stripComments:false
create or replace function f_SAPW_catalogo_FAM
(p_anagrafe		varchar2
,p_tipo_evento		varchar2
,p_anno_pratica		number
,p_pratica		number
,p_anno_dic		number
,p_numero_dic		number
,p_modello		varchar2
)
								   
return varchar2

IS

w_comune_utente		varchar2(255) := f_get_comune_cliente('COD_COMUNE');

w_cod_fam		number;
w_progr_fam		number;
w_dati_fam		varchar2(32000);
w_catalogo		varchar2(32000);

w_step			number;

cursor sel_fam is
select *
  from CERTPR TPR
 where tpr.anagrafe          = p_anagrafe
   and tpr.tipo_evento       = p_tipo_evento
   and tpr.anno_pratica      = p_anno_pratica
   and tpr.pratica           = p_pratica
   and tpr.anno_dic          = nvl(p_anno_dic,tpr.anno_dic)
   and tpr.numero_dic        = nvl(p_numero_dic,tpr.numero_dic)
   and tpr.flag_annullamento is null
   and tpr.flag_soggetto     = 'S'
 order by sequenza_par, data_nas
;

begin

  w_progr_fam	:= 0;

  for rec in sel_fam loop
      w_progr_fam	:= w_progr_fam + 1;

      if p_modello in ('FAM_DCA_1','FAM_DCA_3') then
w_step := 1;
	 w_dati_fam	:= '- '||rec.COGNOME_NOME||' '||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;

      elsif p_modello in ('FAM_DCA_2') then
w_step := 2;
	 w_dati_fam	:= '- '||rec.COGNOME_NOME||chr(9)||rec.DATA_NASCITA||' '||rec.RAPPORTO_PARENTELA;

      elsif p_modello in ('FAM_VAA') then
w_step := 3;
         if nvl(w_comune_utente,'000000') = '037032' then
            w_dati_fam	:= w_progr_fam||'. '||rec.COGNOME_NOME||' - '||rec.DATA_NASCITA||' - '||rec.COMUNE_NASCITA||chr(9)||rec.RAPPORTO_PARENTELA;
         else
            w_dati_fam	:= w_progr_fam||'. '||rec.COGNOME_NOME||chr(9)||rec.DATA_NASCITA||' '||rec.RAPPORTO_PARENTELA;
         end if;

      end if;

      if w_progr_fam = 1 then
w_step := 4;
	 w_catalogo	:= w_dati_fam;
      else
w_step := 5;
	 w_catalogo 	:= w_catalogo||chr(10)||w_dati_fam;
      end if;
  end loop;

  w_catalogo := w_catalogo||chr(10);

  return w_catalogo;

exception
  when others then
--       w_catalogo := '';
       w_catalogo := w_progr_fam||'.'||w_step||' - '||SQLERRM;
       return w_catalogo;
end;
/
