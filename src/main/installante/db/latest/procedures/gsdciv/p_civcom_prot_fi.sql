--liquibase formatted sql
--changeset amonopoli:202304281235 runOnChange:true stripComments:false
create or replace procedure civcom_PROT_fi
(a_tipo_atto		IN	number
,a_ufficio		IN	number
,a_anno			IN	number
,a_parte		IN	number
,a_serie		IN	varchar2
,a_atto			IN	number
,a_formula		IN	varchar2
,a_codice_co		IN	number
,a_id			IN	number
)

IS

cursor sel_dest is
select ddc.TIPO_ATTO      
     , ddc.CODICE_CO      
     , ddc.SEQUENZA       
     , ddc.CODICE_EN      
     , den.SIGLA
  from civden den
     , civddc ddc
 where den.codice_en = ddc.codice_en
   and ddc.tipo_atto = decode(a_formula,'',a_tipo_atto,0)
   and ddc.codice_co = a_codice_co
 order by sequenza
;

w_sigla                 varchar2(255);

w_cod_pro_ute		number;
w_cod_com_ute		number;
w_istat_ute		varchar2(6);

w_cod_pro_dest		number;
w_cod_com_dest		number;
w_istat_dest		varchar2(6);
w_istat_dest_1		varchar2(6);

w_cod_pro_eve		number;
w_cod_com_eve		number;
w_istat_eve		varchar2(6);
w_cod_pro_nas		number;
w_cod_com_nas		number;
w_istat_nas		varchar2(6);
w_cod_pro_attnas	number;
w_cod_com_attnas	number;
w_istat_attnas		varchar2(6);
w_cod_pro_res		number;
w_cod_com_res		number;
w_istat_res		varchar2(6);
w_cod_pro_nas_2		number;
w_cod_com_nas_2		number;
w_istat_nas_2		varchar2(6);
w_cod_pro_attnas_2	number;
w_cod_com_attnas_2	number;
w_istat_attnas_2	varchar2(6);
w_cod_pro_res_2		number;
w_cod_com_res_2		number;
w_istat_res_2		varchar2(6);

w_sequenza		number;

w_errore		varchar2(4000);
errore			exception;

w_operazione_log	varchar2(255) := 'civcom_PROT_fi';

function f_ctr_comune_soppresso
(a_istat_com 	in	varchar2)

return number

IS

w_istat_com	varchar2(6);
w_cod_pro	number;
w_cod_com	number;

w_return	number;

begin

  w_return := 0;

  if a_istat_com is not null then
     w_istat_com := lpad(a_istat_com,6,'0');
     w_cod_pro   := substr(w_istat_com,1,3);
     w_cod_com   := substr(w_istat_com,4,3);

     begin
       select 1 into w_return
         from arccom
        where cod_provincia = w_cod_pro
          and cod_Comune    = w_cod_com
          and (cod_pro_fusione, cod_Com_fusione) = (select pro_cliente, com_cliente from menuditta)
          and rownum = 1
       ;
       DOCAREA_PKG.ins_log('civcom_PROT_fi', 'comune soppresso - oggi comune utente');
     exception
       when others then
            w_return := 0;
     end;
  end if;

  return w_return;

exception
  when others then
       return w_return;
       
end;

begin
  DOCAREA_PKG.ins_log('civcom_PROT_fi', 'id_com: '||a_id||
                                        ' - tipo_atto: '||a_tipo_atto||
                                        ' - ufficio: '||a_ufficio||
                                        ' - anno: '||a_anno||
                                        ' - parte: '||a_parte||
                                        ' - serie: '||a_serie||
                                        ' - atto: '||a_atto||
                                        ' - codice_co: '||a_codice_co);

  begin
    delete civcom_dest
     where id_com       = a_id
       and flag_ws_mail is null
    ;
  exception
    when others then
         w_errore := 'Errore in eliminazione CIVCOM_MAIL ('||sqlerrm||')';
         raise errore;
  end;

-- tipo_atto =  1: su atto di cittadinanza presente in archivio
-- tipo_atto =  2: su atto di nascita presente in archivio
-- tipo_atto =  4: su atto di matrimonio presente in archivio
-- tipo_atto = -4: su atto di unione civile presente in archivio
-- tipo_atto =  5: su atto di morte presente in archivio 
-- tipo_atto =  6: su atto di nascita non presente in archivio - da atto di Cittadinanza
-- tipo_atto =  7: su atto di nascita non presente in archivio - da atto di Matrimonio
-- tipo_atto = -7: su atto di nascita non presente in archivio - da atto di Unione Civile
-- tipo_atto =  8: su atto di nascita non presente in archivio - da atto di Morte
-- tipo_atto =  9: su atto di matrimonio non presente in archivio - da atto di Divorzio 
-- tipo_atto = -9: su atto di unione civile non presente in archivio - da atto di Scioglimento Unione Civile

  begin
    select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
      into w_istat_ute
      from menuditta
    ;
  exception
    when others then
         w_errore := 'Errore in ricerca menuditta ('||sqlerrm||')';
         raise errore;
  end;

  begin
    select decode(a_tipo_atto, 1, w_cod_pro_ute, 
                               6, cit.cod_pro_nas)
         , decode(a_tipo_atto, 1, w_cod_com_ute,  
                               6, cit.cod_com_nas)
         , decode(a_tipo_atto, 1, w_istat_ute,  
                               6, lpad(cit.cod_pro_nas,3,'0')||lpad(cit.cod_com_nas,3,'0'))
         , cit.cod_pro_nas
         , cit.cod_com_nas
         , lpad(cit.cod_pro_nas,3,'0')||lpad(cit.cod_com_nas,3,'0')
         , mar.cod_pro_atto_nas
         , mar.cod_com_atto_nas
         , lpad(mar.cod_pro_atto_nas,3,'0')||lpad(mar.cod_com_atto_nas,3,'0')
         , cit.cod_pro_res
         , cit.cod_com_res
         , lpad(cit.cod_pro_res,3,'0')||lpad(cit.cod_com_res,3,'0')
         , to_number(null)
         , to_number(null)
         , to_char(null)
         , to_number(null)
         , to_number(null)
         , to_char(null)
         , to_number(null)
         , to_number(null)
         , to_char(null)
      into w_cod_pro_eve
         , w_cod_com_eve
         , w_istat_eve
         , w_cod_pro_nas
         , w_cod_com_nas
         , w_istat_nas
         , w_cod_pro_attnas
         , w_cod_com_attnas
         , w_istat_attnas
         , w_cod_pro_res
         , w_cod_com_res
         , w_istat_res
         , w_cod_pro_nas_2
         , w_cod_com_nas_2
         , w_istat_nas_2
         , w_cod_pro_attnas_2
         , w_cod_com_attnas_2
         , w_istat_attnas_2
         , w_cod_pro_res_2
         , w_cod_com_res_2
         , w_istat_res_2
      from civmar mar, civcit cit
     where mar.id_atto (+) = cit.id_atto
       and cit.ufficio     = a_ufficio
       and cit.anno        = a_anno
       and cit.atto        = a_atto
       and a_tipo_atto     in (1,6)
    UNION
    select nas.cod_pro_nas
         , nas.cod_com_nas
         , lpad(nas.cod_pro_nas,3,'0')||lpad(nas.cod_com_nas,3,'0')
         , nas.cod_pro_nas
         , nas.cod_com_nas
         , lpad(nas.cod_pro_nas,3,'0')||lpad(nas.cod_com_nas,3,'0')
         , to_number(null)
         , to_number(null)
         , to_char(null)
         , nas.cod_pro_res
         , nas.cod_com_res
         , lpad(nas.cod_pro_res,3,'0')||lpad(nas.cod_com_res,3,'0')
         , to_number(null)
         , to_number(null)
         , to_char(null)
         , to_number(null)
         , to_number(null)
         , to_char(null)
         , to_number(null)
         , to_number(null)
         , to_char(null)
      from civnas nas
     where ufficio        = a_ufficio
       and anno           = a_anno
       and nvl(parte,0)   = nvl(a_parte,0)
       and nvl(serie,' ') = nvl(a_serie,' ')
       and atto           = a_atto
       and a_tipo_atto    = 2
    UNION
    select decode(a_tipo_atto, 4, mat.cod_pro_mat, 
                               9, w_cod_pro_ute, 
                               7, decode(substr(a_formula,1,1), '1',mat.cod_pro_nas_m,
                                                                '5',mat.cod_pro_nas_f))
         , decode(a_tipo_atto, 4, mat.cod_com_mat, 
                               9, w_cod_com_ute, 
                               7, decode(substr(a_formula,1,1), '1',mat.cod_com_nas_m,
                                                                '5',mat.cod_com_nas_f))
         , decode(a_tipo_atto, 4, lpad(mat.cod_pro_mat,3,'0')||lpad(mat.cod_com_mat,3,'0'),
                               9, w_istat_ute, 
                               7, decode(substr(a_formula,1,1), '1',lpad(mat.cod_pro_nas_m,3,'0')||lpad(mat.cod_com_nas_m,3,'0'),
                                                                '5',lpad(mat.cod_pro_nas_f,3,'0')||lpad(mat.cod_com_nas_f,3,'0')))
         , decode(a_formula,'',
             mat.cod_pro_nas_m,
             decode(substr(a_formula,1,1), '1',mat.cod_pro_nas_m,
                                           '5',mat.cod_pro_nas_f))
         , decode(a_formula,'',
             mat.cod_com_nas_m,
             decode(substr(a_formula,1,1), '1',mat.cod_com_nas_m,
                                           '5',mat.cod_com_nas_f))
         , decode(a_formula,'',
             lpad(mat.cod_pro_nas_m,3,'0')||lpad(mat.cod_com_nas_m,3,'0'),
             decode(substr(a_formula,1,1), '1',lpad(mat.cod_pro_nas_m,3,'0')||lpad(mat.cod_com_nas_m,3,'0'),
                                           '5',lpad(mat.cod_pro_nas_f,3,'0')||lpad(mat.cod_com_nas_f,3,'0')))
         , decode(a_formula,'',
             spo.cod_pro_atto_nas_m,
             decode(substr(a_formula,1,1), '1',spo.cod_pro_atto_nas_m,
                                           '5',spo.cod_pro_atto_nas_f))
         , decode(a_formula,'',
             spo.cod_com_atto_nas_m,
             decode(substr(a_formula,1,1), '1',spo.cod_com_atto_nas_m,
                                           '5',spo.cod_com_atto_nas_f))
         , decode(a_formula,'',
             lpad(spo.cod_pro_atto_nas_m,3,'0')||lpad(spo.cod_com_atto_nas_m,3,'0'),
             decode(substr(a_formula,1,1), '1',lpad(spo.cod_pro_atto_nas_m,3,'0')||lpad(spo.cod_com_atto_nas_m,3,'0'),
                                           '5',lpad(spo.cod_pro_atto_nas_f,3,'0')||lpad(spo.cod_com_atto_nas_f,3,'0')))
         , decode(a_formula,'',
             mat.cod_pro_res_m,
             decode(substr(a_formula,1,1), '1',mat.cod_pro_res_m,
                                           '5',mat.cod_pro_res_f))
         , decode(a_formula,'',
             mat.cod_com_res_m,
             decode(substr(a_formula,1,1), '1',mat.cod_com_res_m,
                                           '5',mat.cod_com_res_f))
         , decode(a_formula,'',
             lpad(mat.cod_pro_res_m,3,'0')||lpad(mat.cod_com_res_m,3,'0'),
             decode(substr(a_formula,1,1), '1',lpad(mat.cod_pro_res_m,3,'0')||lpad(mat.cod_com_res_m,3,'0'),
                                           '5',lpad(mat.cod_pro_res_f,3,'0')||lpad(mat.cod_com_res_f,3,'0')))
         , mat.cod_pro_nas_f
         , mat.cod_com_nas_f
         , lpad(mat.cod_pro_nas_f,3,'0')||lpad(mat.cod_com_nas_f,3,'0')
         , spo.cod_pro_atto_nas_f
         , spo.cod_com_atto_nas_f
         , lpad(spo.cod_pro_atto_nas_f,3,'0')||lpad(spo.cod_com_atto_nas_f,3,'0')
         , mat.cod_pro_res_f
         , mat.cod_com_res_f
         , lpad(mat.cod_pro_res_f,3,'0')||lpad(mat.cod_com_res_f,3,'0')
      from civspo spo, civmat mat
     where spo.id_atto (+)    = mat.id_atto
       and mat.ufficio        = a_ufficio
       and mat.anno           = a_anno
       and nvl(mat.parte,0)   = nvl(a_parte,0)
       and nvl(mat.serie,' ') = nvl(a_serie,' ')
       and mat.atto           = a_atto
       and a_tipo_atto        in (4,7,9)
    UNION
    select decode(a_tipo_atto, -4, uci.cod_pro_mat, 
                               -9, w_cod_pro_ute, 
                               -7, decode(substr(a_formula,1,1), '1',uci.cod_pro_nas_m,
                                                                 '5',uci.cod_pro_nas_f))
         , decode(a_tipo_atto, -4, uci.cod_com_mat, 
                               -9, w_cod_com_ute, 
                               -7, decode(substr(a_formula,1,1), '1',uci.cod_com_nas_m,
                                                                 '5',uci.cod_com_nas_f))
         , decode(a_tipo_atto, -4, lpad(uci.cod_pro_mat,3,'0')||lpad(uci.cod_com_mat,3,'0'),
                               -9, w_istat_ute, 
                               -7, decode(substr(a_formula,1,1), '1',lpad(uci.cod_pro_nas_m,3,'0')||lpad(uci.cod_com_nas_m,3,'0'),
                                                                 '5',lpad(uci.cod_pro_nas_f,3,'0')||lpad(uci.cod_com_nas_f,3,'0')))
         , decode(a_formula,'',
             uci.cod_pro_nas_m,
             decode(substr(a_formula,1,1), '1',uci.cod_pro_nas_m, 
                                           '5',uci.cod_pro_nas_f))
         , decode(a_formula,'',
             uci.cod_com_nas_m,
             decode(substr(a_formula,1,1), '1',uci.cod_com_nas_m,
                                           '5',uci.cod_com_nas_f))
         , decode(a_formula,'',
             lpad(uci.cod_pro_nas_m,3,'0')||lpad(uci.cod_com_nas_m,3,'0'),
             decode(substr(a_formula,1,1), '1',lpad(uci.cod_pro_nas_m,3,'0')||lpad(uci.cod_com_nas_m,3,'0'),
                                           '5',lpad(uci.cod_pro_nas_f,3,'0')||lpad(uci.cod_com_nas_f,3,'0')))
         , decode(a_formula,'',
             spo.cod_pro_atto_nas_m,
             decode(substr(a_formula,1,1), '1',spo.cod_pro_atto_nas_m,
                                           '5',spo.cod_pro_atto_nas_f))
         , decode(a_formula,'',
             spo.cod_com_atto_nas_m,
             decode(substr(a_formula,1,1), '1',spo.cod_com_atto_nas_m,
                                           '5',spo.cod_com_atto_nas_f))
         , decode(a_formula,'',
             lpad(spo.cod_pro_atto_nas_m,3,'0')||lpad(spo.cod_com_atto_nas_m,3,'0'),
             decode(substr(a_formula,1,1), '1',lpad(spo.cod_pro_atto_nas_m,3,'0')||lpad(spo.cod_com_atto_nas_m,3,'0'),
                                           '5',lpad(spo.cod_pro_atto_nas_f,3,'0')||lpad(spo.cod_com_atto_nas_f,3,'0')))
         , decode(a_formula,'',
             uci.cod_pro_res_m,
             decode(substr(a_formula,1,1), '1',uci.cod_pro_res_m,
                                           '5',uci.cod_pro_res_f))
         , decode(a_formula,'',
             uci.cod_com_res_m,
             decode(substr(a_formula,1,1), '1',uci.cod_com_res_m,
                                           '5',uci.cod_com_res_f))
         , decode(a_formula,'',
             lpad(uci.cod_pro_res_m,3,'0')||lpad(uci.cod_com_res_m,3,'0'),
             decode(substr(a_formula,1,1), '1',lpad(uci.cod_pro_res_m,3,'0')||lpad(uci.cod_com_res_m,3,'0'),
                                           '5',lpad(uci.cod_pro_res_f,3,'0')||lpad(uci.cod_com_res_f,3,'0')))
         , uci.cod_pro_nas_f
         , uci.cod_com_nas_f
         , lpad(uci.cod_pro_nas_f,3,'0')||lpad(uci.cod_com_nas_f,3,'0')
         , spo.cod_pro_atto_nas_f
         , spo.cod_com_atto_nas_f
         , lpad(spo.cod_pro_atto_nas_f,3,'0')||lpad(spo.cod_com_atto_nas_f,3,'0')
         , uci.cod_pro_res_f
         , uci.cod_com_res_f
         , lpad(uci.cod_pro_res_f,3,'0')||lpad(uci.cod_com_res_f,3,'0')
      from civspo spo, civuci uci
     where spo.id_atto (+)    = uci.id_atto
       and uci.ufficio        = a_ufficio
       and uci.anno           = a_anno
       and nvl(uci.parte,0)   = nvl(a_parte,0)
       and nvl(uci.serie,' ') = nvl(a_serie,' ')
       and uci.atto           = a_atto
       and a_tipo_atto        in (-4,-7,-9)
    UNION
    select decode(a_tipo_atto, 5, mor.cod_pro_mor, mor.cod_pro_nas)
         , decode(a_tipo_atto, 5, mor.cod_com_mor, mor.cod_com_nas)
         , decode(a_tipo_atto, 5, lpad(mor.cod_pro_mor,3,'0')||lpad(mor.cod_com_mor,3,'0'), 
                                  lpad(mor.cod_pro_nas,3,'0')||lpad(mor.cod_com_nas,3,'0'))
         , mor.cod_pro_nas
         , mor.cod_com_nas
         , lpad(mor.cod_pro_nas,3,'0')||lpad(mor.cod_com_nas,3,'0')
         , mar.cod_pro_atto_nas
         , mar.cod_com_atto_nas
         , lpad(mar.cod_pro_atto_nas,3,'0')||lpad(mar.cod_com_atto_nas,3,'0')
         , mor.cod_pro_res
         , mor.cod_com_res
         , lpad(mor.cod_pro_res,3,'0')||lpad(mor.cod_com_res,3,'0')
         , to_number(null)
         , to_number(null)
         , to_char(null)
         , to_number(null)
         , to_number(null)
         , to_char(null)
         , to_number(null)
         , to_number(null)
         , to_char(null)
      from civmar mar, civmor mor
     where mar.id_atto (+)    = mor.id_atto
       and mor.ufficio        = a_ufficio
       and mor.anno           = a_anno
       and nvl(mor.parte,0)   = nvl(a_parte,0)
       and nvl(mor.serie,' ') = nvl(a_serie,' ')
       and mor.atto           = a_atto
       and a_tipo_atto        in (5,8)
    ;
  exception
    when others then
         w_cod_pro_nas    := '';
         w_cod_com_nas    := '';
         w_istat_nas      := '';
         w_cod_pro_attnas := '';
         w_cod_com_attnas := '';
         w_istat_attnas   := '';
         w_cod_pro_res    := '';
         w_cod_com_res    := '';
         w_istat_res      := '';
         w_cod_pro_res_2  := '';
         w_cod_com_res_2  := '';
         w_istat_res_2    := '';
         w_errore         := 'Errore in sel_dati ('||sqlerrm||')';
         raise errore;
  end;
 
  DOCAREA_PKG.ins_log('civcom_PROT_fi', 'w_istat_ute: '||w_istat_ute);
  DOCAREA_PKG.ins_log('civcom_PROT_fi', 'w_istat_eve: '||w_istat_eve);
  for rec in sel_dest loop
      w_sigla := upper(rec.sigla);
      DOCAREA_PKG.ins_log('civcom_PROT_fi', 'den.sigla: '||w_sigla);

<< tribunale_procura >>
      if w_sigla in ('TRIBUNALE_UTE','PROCURA_UTE') then
--         if nvl(w_istat_eve,'000000') = w_istat_ute and a_anno <= 2000 then
         if a_tipo_atto in (1,2,4,5,-4) and a_anno <= 2000 then
            begin
              insert into civcom_dest
                     (id_com, cod_ente_dest, cod_pro_dest, cod_com_dest)
              values (a_id, rec.codice_en, to_number(null), to_number(null))
              ;
              DOCAREA_PKG.ins_log(w_operazione_log, 'inserito '||rec.sigla);
            exception
              when others then
                   w_errore := 'Errore in inserimento destinatari - '||rec.sigla||' ('||sqlerrm||')';
                   raise errore;
            end;
         end if;
         goto fine;
      end if;
        
<< prefetto >>
      if w_sigla = 'PREFETTO_UTE' then
--         if nvl(w_istat_eve,'000000') = w_istat_ute and a_anno > 2000 then
         if a_tipo_atto in (1,2,4,5,-4) and a_anno > 2000 then
             begin
              insert into civcom_dest
                     (id_com, cod_ente_dest, cod_pro_dest, cod_com_dest)
              values (a_id, rec.codice_en, to_number(null), to_number(null))
              ;
              DOCAREA_PKG.ins_log(w_operazione_log, 'inserito '||rec.sigla);
            exception
              when others then
                   w_errore := 'Errore in inserimento destinatari - '||rec.sigla||' ('||sqlerrm||')';
                   raise errore;
            end;
         end if;
         goto fine;
      end if;
        
<< comune >>
      if w_sigla = 'COMUNE_EVE' then
         w_cod_pro_dest := w_cod_pro_eve;
         w_cod_com_dest := w_cod_com_eve;
         w_istat_dest   := w_istat_eve;
         DOCAREA_PKG.ins_log(w_operazione_log, 'w_istat_dest '||w_istat_dest);
      elsif w_sigla = 'COMUNE_NAS' then
         w_cod_pro_dest := w_cod_pro_nas;
         w_cod_com_dest := w_cod_com_nas;
         w_istat_dest   := w_istat_nas;
         DOCAREA_PKG.ins_log(w_operazione_log, w_cod_pro_attnas||' '||w_cod_com_attnas||' '||w_istat_attnas);
      elsif w_sigla = 'COMUNE_ATTNAS' then
         DOCAREA_PKG.ins_log(w_operazione_log, 'w_istat_dest '||w_istat_dest);
         w_cod_pro_dest := w_cod_pro_attnas;
         w_cod_com_dest := w_cod_com_attnas;
         w_istat_dest   := w_istat_attnas;
         DOCAREA_PKG.ins_log(w_operazione_log, 'w_istat_dest '||w_istat_dest);
      elsif w_sigla = 'COMUNE_RES' then
         w_cod_pro_dest := w_cod_pro_res;
         w_cod_com_dest := w_cod_com_res;
         w_istat_dest   := w_istat_res;
         DOCAREA_PKG.ins_log(w_operazione_log, 'w_istat_dest '||w_istat_dest);
      else 
         goto comune_2;
      end if;

      if nvl(w_istat_dest,w_istat_ute) != w_istat_ute and w_cod_pro_dest < 199 
         and f_ctr_comune_soppresso(nvl(w_istat_dest,w_istat_ute)) = 0
      then
         begin
           insert into civcom_dest
                  (id_com, cod_ente_dest, cod_pro_dest, cod_com_dest)
           values (a_id, rec.codice_en, w_cod_pro_dest, w_cod_com_dest)
           ;
           DOCAREA_PKG.ins_log(w_operazione_log, 'inserito '||rec.sigla||' '||w_istat_dest);
         exception
           when others then
                w_errore := 'Errore in inserimento destinatari - '||rec.sigla||' ('||sqlerrm||')';
                raise errore;
         end;
     end if;
     goto fine;

<< comune_2 >>
      if w_sigla = 'COMUNE_NAS_2' then
         w_cod_pro_dest := w_cod_pro_nas_2;
         w_cod_com_dest := w_cod_com_nas_2;
         w_istat_dest   := w_istat_nas_2;
         w_istat_dest_1 := w_istat_nas;
         DOCAREA_PKG.ins_log(w_operazione_log, 'w_istat_dest '||w_istat_dest);
      elsif w_sigla = 'COMUNE_ATTNAS_2' then
         w_cod_pro_dest := w_cod_pro_attnas_2;
         w_cod_com_dest := w_cod_com_attnas_2;
         w_istat_dest   := w_istat_attnas_2;
         w_istat_dest_1 := w_istat_attnas;
         DOCAREA_PKG.ins_log(w_operazione_log, 'w_istat_dest '||w_istat_dest);
      elsif w_sigla = 'COMUNE_RES_2' then
         w_cod_pro_dest := w_cod_pro_res_2;
         w_cod_com_dest := w_cod_com_res_2;
         w_istat_dest   := w_istat_res_2;
         w_istat_dest_1 := w_istat_res;
         DOCAREA_PKG.ins_log(w_operazione_log, 'w_istat_dest '||w_istat_dest);
      else 
         goto ente_generico;
      end if;

      if nvl(w_istat_dest,w_istat_ute) not in (w_istat_ute,w_istat_dest_1) and w_cod_pro_dest < 199  
         and f_ctr_comune_soppresso(nvl(w_istat_dest,w_istat_ute)) = 0
      then
         begin
           insert into civcom_dest
                  (id_com, cod_ente_dest, cod_pro_dest, cod_com_dest)
           values (a_id, rec.codice_en, w_cod_pro_dest, w_cod_com_dest)
           ;
           DOCAREA_PKG.ins_log(w_operazione_log, 'inserito '||rec.sigla||' '||w_istat_dest);
         exception
           when others then
                w_errore := 'Errore in inserimento destinatari - '||rec.sigla||' ('||sqlerrm||')';
                raise errore;
         end;
      end if;
      goto fine;

<< ente_generico >>
      if w_sigla = 'ENTE_GENERICO' then
         begin
           insert into civcom_dest
                  (id_com, cod_ente_dest, cod_pro_dest, cod_com_dest)
           values (a_id, rec.codice_en, to_number(null), to_number(null))
           ;
           DOCAREA_PKG.ins_log(w_operazione_log, 'inserito '||rec.sigla||' '||w_istat_dest);
         exception
           when others then
                w_errore := 'Errore in inserimento destinatari - '||rec.sigla||' ('||sqlerrm||')';
                raise errore;
         end;
         goto fine;
      end if;

<< non_gestito >>
      w_errore := 'Destinatario non gestito: '||rec.sigla;
      DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
      goto fine;

<< fine >>
      null;

  end loop;

exception
  when errore then
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);
end;
/
