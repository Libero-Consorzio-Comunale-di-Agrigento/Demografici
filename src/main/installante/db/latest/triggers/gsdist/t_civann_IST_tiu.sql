--liquibase formatted sql
--changeset amonopoli:202312181020_1 runOnChange:true stripComments:false
create or replace trigger CIVANN_IST_TIU
before INSERT
    or UPDATE
on CIVANN
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

w_cod_modello		varchar2(255) := 'PROVV';
w_progr_questionario	number(8);

w_ufficio_mat		number;
w_anno_mat		number;
w_atto_mat		number;
w_parte_mat		number;
w_serie_mat		varchar2(1);
w_cod_pro_mat		number(3);
w_cod_com_mat		number(3);
w_data_mat		number(8);
w_rito_mat		number(1);
w_convenzioni_mat	number(1);

w_cod_fiscale_m 	varchar2(16);
w_nazionalita_ita_m	number(1);
w_data_nazionalita_m	number(8);
w_cod_fiscale_f		varchar2(16);
w_nazionalita_ita_f	number(1);
w_data_nazionalita_f	varchar2(8);

begin
 if nvl(w_integrazione_istat,'N') = 'S' then
   begin  -- Check DATA Integrity on INSERT or UPDATE
     if INSERTING then
        :new.id      := F_CIVANN_NR(:new.id);
        :new.id_atto := nvl(:new.id_atto,f_CIV_get_id_atto(:new.tipo_atto,:new.ufficio,:new.anno,:new.parte,:new.serie,:new.atto));
     end if;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
      if IntegrityPackage.GetNestLevel = 0 then
         IntegrityPackage.NextNestLevel;

         if (INSERTING and :new.flag_istat = 'S') 
            or (UPDATING and :old.flag_istat is null and :new.flag_istat = 'S') 
         then
            if :new.tipo_atto = 4 then
               begin
                 select mat.ufficio, mat.anno, mat.atto, mat.parte, mat.serie,
                        mat.COD_PRO_MAT, mat.cod_com_mat, mat.data_mat,
                        decode(mat.parte||mat.serie,'2A',1,2),
                        decode(mat.convenzioni,'SI',2,1),
                        mat.cod_fiscale_m, decode(mat.nazionalita_m,'I',1,3),
                        mat.cod_fiscale_f, decode(mat.nazionalita_f,'I',1,3)
                   INTO w_UFFICIO_MAT, w_ANNO_MAT, w_ATTO_MAT, w_PARTE_MAT, w_SERIE_MAT,
                        w_cod_pro_mat, w_cod_com_mat, w_data_mat, w_rito_mat,
                        w_convenzioni_mat,
                        w_cod_fiscale_m, w_nazionalita_ita_m,
                        w_cod_fiscale_f, w_nazionalita_ita_f
                   from civmat mat
                  where id_atto = :new.id_atto
                    and cod_rec = 0
                    and rownum  = 1
                 ;
               exception
                 when others then
                      w_atto_mat          := '';
                      w_parte_mat         := '';
                      w_serie_mat         := '';
                      w_ufficio_mat       := '';
                      w_anno_mat          := '';
                      w_cod_pro_mat       := '';
                      w_Cod_Com_mat       := '';
                      w_data_Mat          := '';
                      w_rito_mat          := '';
                      w_convenzioni_mat   := '';
                      w_cod_fiscale_m     := '';
                      w_nazionalita_ita_m := '';
                      w_cod_fiscale_f     := '';
                      w_nazionalita_ita_f := '';
               end;

               begin
                 insert into istmsc
                       (ufficio, anno, atto, parte, serie,
                        cod_modello, progr_questionario,
                        ufficio_mat, anno_mat, atto_mat, parte_mat, serie_mat,
                        cod_pro_mat, cod_com_mat, data_mat, rito_mat, regime_patrimoniale_mat,
                        cod_fiscale_m, nazionalita_ita_m, data_nazionalita_m,
                        cod_fiscale_f, nazionalita_ita_f, data_nazionalita_f,
                        id_civann,
                        cod_pro_trib, cod_com_trib, data_provvedimento_trib, data_trascr_provv_trib
                       )
                 select :new.ufficio, :new.anno, :new.atto, :new.parte, :new.serie,
                        w_cod_modello, w_progr_questionario,
                        w_ufficio_mat, w_anno_mat, w_atto_mat, w_parte_mat, w_serie_mat,
                        w_cod_pro_mat, w_cod_com_mat, w_data_mat, w_rito_mat, w_convenzioni_mat,
                        w_cod_fiscale_m, w_nazionalita_ita_m, w_data_nazionalita_m,
                        w_cod_fiscale_f, w_nazionalita_ita_f, w_data_nazionalita_f,
                        :new.id,
                        :new.cod_pro_prov, :new.cod_com_prov, to_char(:new.d_data_prov,'j'), :new.data_reg
                   from dual
                  where not exists (select 'x' from istmsc b
                                     where b.id_civann = :new.id)
                    and not exists (select 'x' from istmsc c
                                     where c.id_atto = :new.id_atto_rif
                                       and c.cod_modello <> 'PROVV') -- questo secondo controllo serve ad evitare che l'eventuale annotazione automatica produca un doppio su istmsc
                 ;
                 if sql%found then
                    ISTAT_PKG.ins_log('civann_ist_tiu','istmsc - insert');
                 end if;
               end;

            elsif :new.tipo_atto = -4 then
               begin
                 select uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie,
                        uci.COD_PRO_MAT, uci.cod_com_mat, uci.data_mat,
                        decode(uci.convenzioni,'SI',2,1),
                        uci.cod_fiscale_m, decode(uci.nazionalita_m,'I',1,3),
                        uci.cod_fiscale_f, decode(uci.nazionalita_f,'I',1,3)
                   INTO w_UFFICIO_MAT, w_ANNO_MAT, w_ATTO_MAT, w_PARTE_MAT, w_SERIE_MAT,
                        w_cod_pro_mat, w_cod_com_mat, w_data_mat,
                        w_convenzioni_mat,
                        w_cod_fiscale_m, w_nazionalita_ita_m,
                        w_cod_fiscale_f, w_nazionalita_ita_f
                   from civuci uci
                  where id_atto = :new.id_atto
                    and cod_rec = 0
                    and rownum  = 1
                 ;
               exception
                 when others then
                      w_atto_mat          := '';
                      w_parte_mat         := '';
                      w_serie_mat         := '';
                      w_ufficio_mat       := '';
                      w_anno_mat          := '';
                      w_cod_pro_mat       := '';
                      w_Cod_Com_mat       := '';
                      w_data_Mat          := '';
                      w_convenzioni_mat   := '';
                      w_cod_fiscale_m     := '';
                      w_nazionalita_ita_m := ''; 
                      w_cod_fiscale_f     := ''; 
                      w_nazionalita_ita_f := '';
               end;

               begin
                 insert into istmsu
                       (ufficio, anno, atto, parte, serie, 
                        cod_modello, progr_questionario, 
                        ufficio_uci, anno_uci, atto_uci, parte_uci, serie_uci, 
                        cod_pro_uci, cod_com_uci, data_uci, regime_patrimoniale_uci,
                        cod_fiscale_1, nazionalita_ita_1, data_nazionalita_1, 
                        cod_fiscale_2, nazionalita_ita_2, data_nazionalita_2,
                        id_civann,
                        cod_pro_trib, cod_com_trib, data_provvedimento_trib, data_trascr_provv_trib, tipo_provvedimento_trib)
                 select :new.ufficio, :new.anno, :new.atto, :new.parte, :new.serie, 
                        w_cod_modello, w_progr_questionario, 
                        w_ufficio_mat, w_anno_mat, w_atto_mat, w_parte_mat, w_serie_mat, 
                        w_cod_pro_mat, w_cod_com_mat, w_data_mat, w_convenzioni_mat,
                        w_cod_fiscale_m, w_nazionalita_ita_m, w_data_nazionalita_m, 
                        w_cod_fiscale_f, w_nazionalita_ita_f, w_data_nazionalita_f, 
                        :new.id,
                        :new.cod_pro_prov, :new.cod_com_prov, to_char(:new.d_data_prov,'j'), :new.data_reg, 5
                   from dual
                  where not exists (select 'x' from istmsu b
                                     where b.id_civann = :new.id)
                    and not exists (select 'x' from istmsu c
                                     where c.id_atto = :new.id_atto_rif
                                       and c.cod_modello <> 'PROVV') -- questo secondo controllo serve ad evitare che l'eventuale annotazione automatica produca un doppio su istmsu
                 ;
                 if sql%found then
                    ISTAT_PKG.ins_log('civann_ist_tiu','istmsu - insert');
                 end if;
               end;
            end if;
         end if;

         if UPDATING 
            and :old.flag_istat||:new.flag_istat = 'SS' 
            and :new.cod_pro_prov||:new.cod_com_prov||to_char(:new.d_data_prov,'j')||to_char(:new.d_data_reg,'j') 
                  != :old.cod_pro_prov||:old.cod_com_prov||to_char(:old.d_data_prov,'j')||to_char(:old.d_data_reg,'j') 
         then
            if :new.tipo_atto = 4 then
               begin
                 update istmsc
                    set cod_pro_trib            = :new.cod_pro_prov,
                        cod_com_trib            = :new.cod_com_prov,
                        data_provvedimento_trib = to_char(:new.d_data_prov,'j'),
                        data_trascr_provv_trib  = to_char(:new.d_data_reg,'j')
                  where id_civann = :new.id
                 ;
                 if sql%found then
                    ISTAT_PKG.ins_log('civann_ist_tiu','istmsc - update');
                 end if;
               end;

            elsif :new.tipo_atto = -4 then
               begin
                 update istmsu
                    set cod_pro_trib            = :new.cod_pro_prov,
                        cod_com_trib            = :new.cod_com_prov,
                        data_provvedimento_trib = to_char(:new.d_data_prov,'j'),
                        data_trascr_provv_trib  = to_char(:new.d_data_reg,'j')
                  where id_civann = :new.id
                 ;
                 if sql%found then
                    ISTAT_PKG.ins_log('civann_ist_tiu','istmsu - update');
                 end if;
               end;
            end if;
         end if;

         if UPDATING and :old.flag_istat = 'S' and :new.flag_istat is null then
            if :new.tipo_atto = 4 then
               begin
                 delete istmsc
                  where id_civann = :new.id
                 ;
                 if sql%found then
                    ISTAT_PKG.ins_log('civann_ist_tiu','istmsc - delete');
                 end if;
               end;

            elsif :new.tipo_atto = -4 then
               begin
                 delete istmsu
                  where id_civann = :new.id
                 ;
                 if sql%found then
                    ISTAT_PKG.ins_log('civann_ist_tiu','istmsu - delete');
                 end if;
               end;
            end if;
         end if;

         IntegrityPackage.PreviousNestLevel;
      end if;
   end;
 end if; --if nvl(w_integrazione_istat,'N') = 'S' then
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: CIVANN_IST_TIU */
/
