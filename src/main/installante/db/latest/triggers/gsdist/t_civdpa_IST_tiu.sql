--liquibase formatted sql
--changeset amonopoli:20231645 runOnChange:true stripComments:false
create or replace trigger CIVDPA_IST_TIU
before INSERT
    or UPDATE
on CIVDPA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

w_cod_rec		number;
w_natura		varchar2(255);
w_ufficio		number;
w_anno			number;
w_atto			number;
w_parte			number;
w_serie			varchar2(255);
w_cod_pro_mat		number;
w_cod_com_mat		number;
w_cognome_nome_m	varchar2(255);
w_data_nas_m		number;
w_cod_pro_res_m		number;
w_cod_com_res_m		number;
w_nazionalita_m		varchar2(255);
w_cod_fiscale_m		varchar2(255);
w_cognome_nome_f	varchar2(255);
w_data_nas_f		number;
w_cod_pro_res_f		number;
w_cod_com_res_f		number;
w_nazionalita_f		varchar2(255);
w_cod_fiscale_f		varchar2(255);
w_id_civdta		number;
w_id_atto		varchar2(255);

begin
--
-- 08/01/2024 (AM): controllo modifica tipo_divorzio da civdpa (rif. CIVMAT_IST_FI)
-- 18/01/2024 (AM): gestito UPDATE di comune matrimonio (rif. CIVMAT_IST_FI)
--

 if nvl(w_integrazione_istat,'N') = 'S' then
   if UPDATING then
      if :old.tipo_divorzio != :new.tipo_divorzio and (:old.tipo_divorzio = 'A' or :new.tipo_divorzio = 'A') then     
         begin
           select mat.cod_rec,mat.natura,mat.ufficio,mat.anno,mat.atto,mat.parte,mat.serie,
                  mat.cod_pro_mat,mat.cod_com_mat,
                  mat.cognome_nome_m,mat.data_nas_m,mat.cod_pro_res_m,mat.cod_com_res_m,mat.nazionalita_m,mat.cod_fiscale_m,
                  mat.cognome_nome_f,mat.data_nas_f,mat.cod_pro_res_f,mat.cod_com_res_f,mat.nazionalita_f,mat.cod_fiscale_f,
                  mat.id_civdta,mat.id_atto
             into w_cod_rec,w_natura,w_ufficio,w_anno,w_atto,w_parte,w_serie,
                  w_cod_pro_mat,w_cod_com_mat,
                  w_cognome_nome_m,w_data_nas_m,w_cod_pro_res_m,w_cod_com_res_m,w_nazionalita_m,w_cod_fiscale_m,
                  w_cognome_nome_f,w_data_nas_f,w_cod_pro_res_f,w_cod_com_res_f,w_nazionalita_f,w_cod_fiscale_f,
                  w_id_civdta,w_id_atto
             from civmat mat
            where mat.id_atto = :new.id_atto
              and mat.cod_rec in (0,3)
           ;
         exception
           when others then
                w_cod_rec		:= '';
                w_natura		:= '';
                w_ufficio		:= '';
                w_anno			:= '';
                w_atto			:= '';
                w_parte			:= '';
                w_serie			:= '';
                w_cod_pro_mat		:= '';
                w_cod_com_mat		:= '';
                w_cognome_nome_m	:= '';
                w_data_nas_m		:= '';
                w_cod_pro_res_m		:= '';
                w_cod_com_res_m		:= '';
                w_nazionalita_m		:= '';
                w_cod_fiscale_m		:= '';
                w_cognome_nome_f	:= '';
                w_data_nas_f		:= '';
                w_cod_pro_res_f		:= '';
                w_cod_com_res_f		:= '';
                w_nazionalita_f		:= '';
                w_cod_fiscale_f		:= '';
                w_id_civdta		:= '';
                w_id_atto		:= '';
         end;
      end if; --if :old.tipo_divorzio != :new.tipo_divorzio and (:old.tipo_divorzio = 'A' or :new.tipo_divorzio = 'A') then     
      ISTAT_PKG.ins_log('civdpa_ist_tiu','w_id_civdta: '||w_id_civdta||' - w_natura: '||w_natura);

      if w_id_atto is not null then
         begin  -- Global FUNCTIONAL Integrity at Level 0
                ISTAT_PKG.ins_log('civdpa_ist_tiu',:new.id_atto);
		CIVMAT_IST_FI(w_cod_rec,w_natura,w_ufficio,w_anno,w_atto,w_parte,w_serie,
 			      w_cod_pro_mat,w_cod_com_mat,
			      w_cognome_nome_m,w_data_nas_m,w_cod_pro_res_m,w_cod_com_res_m,w_nazionalita_m,w_cod_fiscale_m,
			      w_cognome_nome_f,w_data_nas_f,w_cod_pro_res_f,w_cod_com_res_f,w_nazionalita_f,w_cod_fiscale_f,
			      null,		--a_atto_old
                              w_id_civdta,w_id_atto,:new.tipo_divorzio,
                              null, null	--a_cod_pro_mat_old,a_cod_com_mat_old
                             );
         end;
      end if; --if w_id_atto is not null then
   end if; --if UPDATING then
 end if; --if nvl(w_integrazione_istat,'N') = 'S' then
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: CIVDPA_IST_TIU */
/
