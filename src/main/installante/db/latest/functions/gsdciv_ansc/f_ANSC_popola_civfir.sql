--liquibase formatted sql
--changeset amonopoli:202402201645 runOnChange:true stripComments:false
create or replace function f_ANSC_popola_civfir
(a_tipo_atto		IN	number
,a_id_atto		IN	varchar2
)

return number

IS

cursor sel_cit is
select vj.*, v.flag_firmato_usc_ansc
  from civcit_v v
     , civcit_v_json vj
 where v.id_atto  = vj.id_atto
   and vj.id_atto = a_id_atto
;

cursor sel_nas is
select vj.*, v.flag_firmato_usc_ansc
  from civnas_v v
     , civnas_v_json vj
 where v.id_atto  = vj.id_atto
   and vj.id_atto = a_id_atto
;

cursor sel_mat is
select vj.*, v.flag_firmato_usc_ansc
  from civmat_v v
     , civmat_v_json vj
 where v.id_atto  = vj.id_atto
   and vj.id_atto = a_id_atto
;

cursor sel_mat_int is
select vj.* from civmat_INT_v_json vj
 where vj.id_atto = a_id_atto
;

cursor sel_uci is
select vj.*, v.flag_firmato_usc_ansc
  from civuci_v v
     , civuci_v_json vj
 where v.id_atto  = vj.id_atto
   and vj.id_atto = a_id_atto
;

cursor sel_uci_int is
select vj.* from civuci_INT_v_json vj
 where vj.id_atto = a_id_atto
;

cursor sel_mor is
select vj.*, v.flag_firmato_usc_ansc
  from civmor_v v
     , civmor_v_json vj
 where v.id_atto  = vj.id_atto
   and vj.id_atto = a_id_atto
;

w_esiste_fir	number;
w_max_sequenza	number;

w_tipo_atto	number := a_tipo_atto;
w_id_atto	varchar2(255) := a_id_atto;
w_ufficio	number;
w_anno		number;
w_parte		number;
w_serie		varchar2(255);
w_atto		number;

w_cod_ruolo	varchar2(255);
w_cognome	varchar2(255);
w_nome		varchar2(255);
w_data_nas	date;
w_sequenza	number;

w_civfir_ins	number;
w_civfir_del	number;

w_errore	varchar2(4000);
errore		exception;

w_return	number;

begin
  w_return     := 0;
  w_esiste_fir := 0;

  begin
    select nvl(max(sequenza),0) into w_max_sequenza
      from civfir
     where id_atto = a_id_atto
     ;
  exception
    when others then
         w_errore := 'Errore in ricerca max(sequenza) Firmatari Atto';
         raise errore;
  end;

--  if w_esiste_fir = 1 then
--     goto fine;
--  end if;

-- CIT
-- AS - Ascendente
-- IN - Interessato
-- MD - Madre
-- PD - Padre
-- DE - Delegato
-- IT - Interprete
-- OF - Officiante
--
-- NAS
-- AD - Altro Dichiarante
--
-- MAT
-- SO - Sposo
-- SA - Sposa
-- OF - Officiante
-- T1 - Testimone 1
-- T2 - Testimone 2
-- T3 - Testimone 3
-- T4 - Testimone 4
-- AO - Avvocato Sposo
-- AA - Avvocato Sposa
--
-- UCI
-- C1 - Contraente 1
-- C2 - Contraente 2
-- A1 - Avvocato Contraente 1
-- A2 - Avvocato Contraente 2
--
-- MOR
-- CO - Comparente

  if a_tipo_atto = 1 then
     w_sequenza := w_max_sequenza;
     for rec in sel_cit loop
      if rec.flag_firmato_usc_ansc is null then
         w_ufficio := rec.ufficio;
         w_anno    := rec.anno;
         w_parte   := '';
         w_serie   := '';
         w_atto    := rec.atto;

         w_cod_ruolo := 'IN';
         if nvl(rec.INT_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.INT_cognome;
            w_nome      := rec.INT_nome;
            w_data_nas  := to_date(rec.INT_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'DE';
         if nvl(rec.DEL_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.DEL_cognome;
            w_nome      := rec.DEL_nome;
            w_data_nas  := to_date(rec.DEL_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'PD';
         if nvl(rec.PAT_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.PAT_cognome;
            w_nome      := rec.PAT_nome;
            w_data_nas  := to_date(rec.PAT_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'MD';
         if nvl(rec.MAT_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.MAT_cognome;
            w_nome      := rec.MAT_nome;
            w_data_nas  := to_date(rec.MAT_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'AS';
         if nvl(rec.ASC_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.ASC_cognome;
            w_nome      := rec.ASC_nome;
            w_data_nas  := to_date(rec.ASC_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'IT';
         if nvl(rec.ITP_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.ITP_cognome;
            w_nome      := rec.ITP_nome;
            w_data_nas  := to_date(rec.ITP_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'OF';
         if nvl(rec.OFF_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.OFF_cognome;
            w_nome      := rec.OFF_nome;
            w_data_nas  := to_date(null); --to_date(rec.OFF_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

      end if;
     end loop;

  elsif a_tipo_atto = 2 then
     w_sequenza := w_max_sequenza;
     for rec in sel_nas loop
      if rec.flag_firmato_usc_ansc is null then
         w_ufficio := rec.ufficio;
         w_anno    := rec.anno;
         w_parte   := rec.parte;
         w_serie   := rec.serie;
         w_atto    := rec.atto;

         w_cod_ruolo := 'IN';
         if nvl(rec.INT_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.INT_cognome;
            w_nome      := rec.INT_nome;
            w_data_nas  := to_date(rec.INT_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'PD';
         if nvl(rec.PAT_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.PAT_cognome;
            w_nome      := rec.PAT_nome;
            w_data_nas  := to_date(rec.PAT_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'MD';
         if nvl(rec.MAT_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.MAT_cognome;
            w_nome      := rec.MAT_nome;
            w_data_nas  := to_date(rec.MAT_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'AD';
         if nvl(rec.DIC_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.DIC_cognome;
            w_nome      := rec.DIC_nome;
            w_data_nas  := to_date(rec.DIC_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'IT';
         if nvl(rec.ITP_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.ITP_cognome;
            w_nome      := rec.ITP_nome;
            w_data_nas  := to_date(rec.ITP_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;
      end if;
     end loop;

  elsif a_tipo_atto = 4 then
     w_sequenza := w_max_sequenza;
     for rec in sel_mat loop
      if rec.flag_firmato_usc_ansc is null then
         w_ufficio := rec.ufficio;
         w_anno    := rec.anno;
         w_parte   := rec.parte;
         w_serie   := rec.serie;
         w_atto    := rec.atto;

         for rec_int in sel_mat_int loop
             if rec_int.w_ord = 1 then
                w_cod_ruolo := 'SO';
                if nvl(rec_int.FLAGFIRMATARIO,'false') = 'true' then
                   w_sequenza  := w_sequenza + 1;
                   w_cognome   := rec_int.cognome;
                   w_nome      := rec_int.nome;
                   w_data_nas  := to_date(rec_int.dataNascita,'yyyy-mm-dd');
                   w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
                   if w_civfir_ins = 1 then
                      w_return := w_return + 1;
                   end if;
                else 
                   w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
                   if w_civfir_del = 1 then
                      w_return := w_return - 1;
                   end if;
                end if;
             end if;

             if rec_int.w_ord = 2 then
                w_cod_ruolo := 'SA';
                if nvl(rec_int.FLAGFIRMATARIO,'false') = 'true' then
                   w_sequenza  := w_sequenza + 1;
                   w_cognome   := rec_int.cognome;
                   w_nome      := rec_int.nome;
                   w_data_nas  := to_date(rec_int.dataNascita,'yyyy-mm-dd');
                   w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
                   if w_civfir_ins = 1 then
                      w_return := w_return + 1;
                   end if;
                else 
                   w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
                   if w_civfir_del = 1 then
                      w_return := w_return - 1;
                   end if;
                end if;
             end if;
         end loop;

         w_cod_ruolo := 'T1';
         if nvl(rec.FLAGFIRMATARIO_T1,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.cognome_t1;
            w_nome      := rec.nome_t1;
            w_data_nas  := to_date(rec.dataNascita_t1,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'T2';
         if nvl(rec.FLAGFIRMATARIO_T2,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.cognome_t2;
            w_nome      := rec.nome_t2;
            w_data_nas  := to_date(rec.dataNascita_t2,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'T3';
         if nvl(rec.FLAGFIRMATARIO_T3,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.cognome_t3;
            w_nome      := rec.nome_t3;
            w_data_nas  := to_date(rec.dataNascita_t3,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'T4';
         if nvl(rec.FLAGFIRMATARIO_T4,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.cognome_t4;
            w_nome      := rec.nome_t4;
            w_data_nas  := to_date(rec.dataNascita_t4,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'AO';
         if nvl(rec.AV1_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.AV1_cognome;
            w_nome      := rec.AV1_nome;
            w_data_nas  := to_date(null); --to_date(rec.AV1_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'AA';
         if nvl(rec.AV2_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.AV2_cognome;
            w_nome      := rec.AV2_nome;
            w_data_nas  := to_date(null); --to_date(rec.AV2_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'IT';
         if nvl(rec.ITP_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.ITP_cognome;
            w_nome      := rec.ITP_nome;
            w_data_nas  := to_date(rec.ITP_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'AD';
         if nvl(rec.DIC_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.DIC_cognome;
            w_nome      := rec.DIC_nome;
            w_data_nas  := to_date(rec.DIC_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'OF';
         if nvl(rec.OFF_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.OFF_cognome;
            w_nome      := rec.OFF_nome;
            w_data_nas  := to_date(null); --to_date(rec.OFF_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'SC';
         if nvl(rec.SEG_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.SEG_cognome;
            w_nome      := rec.SEG_nome;
            w_data_nas  := to_date(null); --to_date(rec.SEG_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;
      end if;
     end loop;

  elsif a_tipo_atto = -4 then
     w_sequenza := w_max_sequenza;
     for rec in sel_uci loop
      if rec.flag_firmato_usc_ansc is null then
         w_ufficio := rec.ufficio;
         w_anno    := rec.anno;
         w_parte   := rec.parte;
         w_serie   := rec.serie;
         w_atto    := rec.atto;

         for rec_int in sel_uci_int loop
             if rec_int.w_ord = 1 then
                w_cod_ruolo := 'C1';
                if nvl(rec_int.FLAGFIRMATARIO,'false') = 'true' then
                   w_sequenza  := w_sequenza + 1;
                   w_cognome   := rec_int.cognome;
                   w_nome      := rec_int.nome;
                   w_data_nas  := to_date(rec_int.dataNascita,'yyyy-mm-dd');
                   w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
                   if w_civfir_ins = 1 then
                      w_return := w_return + 1;
                   end if;
                else 
                   w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
                   if w_civfir_del = 1 then
                      w_return := w_return - 1;
                   end if;
                end if;
             end if;

             if rec_int.w_ord = 2 then
                w_cod_ruolo := 'C2';
                if nvl(rec_int.FLAGFIRMATARIO,'false') = 'true' then
                   w_sequenza  := w_sequenza + 1;
                   w_cognome   := rec_int.cognome;
                   w_nome      := rec_int.nome;
                   w_data_nas  := to_date(rec_int.dataNascita,'yyyy-mm-dd');
                   w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
                   if w_civfir_ins = 1 then
                      w_return := w_return + 1;
                   end if;
                else 
                   w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
                   if w_civfir_del = 1 then
                      w_return := w_return - 1;
                   end if;
                end if;
             end if;
         end loop;

         w_cod_ruolo := 'T1';
         if nvl(rec.FLAGFIRMATARIO_T1,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.cognome_t1;
            w_nome      := rec.nome_t1;
            w_data_nas  := to_date(rec.dataNascita_t1,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'T2';
         if nvl(rec.FLAGFIRMATARIO_T2,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.cognome_t2;
            w_nome      := rec.nome_t2;
            w_data_nas  := to_date(rec.dataNascita_t2,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'T3';
         if nvl(rec.FLAGFIRMATARIO_T3,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.cognome_t3;
            w_nome      := rec.nome_t3;
            w_data_nas  := to_date(rec.dataNascita_t3,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'T4';
         if nvl(rec.FLAGFIRMATARIO_T4,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.cognome_t4;
            w_nome      := rec.nome_t4;
            w_data_nas  := to_date(rec.dataNascita_t4,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'A1';
         if nvl(rec.AV1_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.AV1_cognome;
            w_nome      := rec.AV1_nome;
            w_data_nas  := to_date(null); --to_date(rec.AV1_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'A2';
         if nvl(rec.AV2_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.AV2_cognome;
            w_nome      := rec.AV2_nome;
            w_data_nas  := to_date(null); --to_date(rec.AV2_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'AD';
         if nvl(rec.DIC_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.DIC_cognome;
            w_nome      := rec.DIC_nome;
            w_data_nas  := to_date(rec.DIC_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'IT';
         if nvl(rec.ITP_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.ITP_cognome;
            w_nome      := rec.ITP_nome;
            w_data_nas  := to_date(rec.ITP_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'OF';
         if nvl(rec.OFF_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.OFF_cognome;
            w_nome      := rec.OFF_nome;
            w_data_nas  := to_date(null); --to_date(rec.OFF_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;
      end if;
     end loop;

  elsif a_tipo_atto = 5 then
     w_sequenza := w_max_sequenza;
     for rec in sel_mor loop
      if rec.flag_firmato_usc_ansc is null then
         w_ufficio := rec.ufficio;
         w_anno    := rec.anno;
         w_parte   := rec.parte;
         w_serie   := rec.serie;
         w_atto    := rec.atto;

         w_cod_ruolo := 'CO';
         if nvl(rec.CO1_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.CO1_cognome;
            w_nome      := rec.CO1_nome;
            w_data_nas  := to_date(rec.CO1_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;

         w_cod_ruolo := 'AD';
         if nvl(rec.DIC_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.DIC_cognome;
            w_nome      := rec.DIC_nome;
            w_data_nas  := to_date(rec.DIC_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;
 
         w_cod_ruolo := 'IT';
         if nvl(rec.ITP_FLAGFIRMATARIO,'false') = 'true' then
            w_sequenza  := w_sequenza + 1;
            w_cognome   := rec.ITP_cognome;
            w_nome      := rec.ITP_nome;
            w_data_nas  := to_date(rec.ITP_dataNascita,'yyyy-mm-dd');
            w_civfir_ins := f_civfir_ins(w_tipo_atto,w_ufficio,w_anno,w_parte,w_serie,w_atto,w_id_atto,w_cod_ruolo,w_cognome,w_nome,w_data_nas,w_sequenza);
            if w_civfir_ins = 1 then
               w_return := w_return + 1;
            end if;
         else 
            w_civfir_del := f_civfir_del(w_id_atto,w_cod_ruolo);
            if w_civfir_del = 1 then
               w_return := w_return - 1;
            end if;
         end if;
      end if;
     end loop;

  end if;


<< fine >>
  return w_return;

exception
  when errore then
       w_return := -1;
       return w_return;
--       return w_errore;
  when others then
       w_return := -1;
       return w_return;  
--       return w_errore;
end;
/
