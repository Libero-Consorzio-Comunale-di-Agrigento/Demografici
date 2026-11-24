--liquibase formatted sql
--changeset amonopoli:202606111405_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ANAELEV is

procedure main
(sessione 	IN	varchar2
,w_messaggio_1 	IN OUT	varchar2
,w_messaggio_2 	IN OUT	varchar2
,w_messaggio_3	IN OUT	varchar2
)
is
w_errore                varchar2(255);
errore                  exception;
begin
  rep_sessione := sessione;

  w_parametri_log  := '';
  w_note_log       := '';
  w_operazione_log := '';

  begin
    select to_number(substr(parametri,1,2)),to_number(substr(parametri,3,7)),
           to_number(substr(parametri,10,4)),to_number(substr(parametri,14,4)),
            nvl(substr(parametri,18,1),'N'),
           rtrim(substr(parametri,19,8)),
           rtrim(substr(parametri,27))
      into p_evento, p_data_eve, p_pratica, p_anno_pratica,
           w_flag_ripristino,
           w_terminalista, w_note_par
      from tabrep
     where chiave    = 'ELEV'
       and terminale = rep_sessione --userenv('terminal')
     ;
     w_terminalista_log := w_terminalista;
  end;

  w_parametri_log  := 'cod_mov: '||r_cod_mov||' - '||
                      'cod_eve: '||r_cod_eve||' - '||
                      'data_eve: '||p_data_eve||' - '||
                      'pratica: '||p_pratica||' - '||
                      'anno_pratica: '||p_anno_pratica||' - '||
                      'matricola: '||r_matricola||' - '||
                      'data_reg: '||r_data_reg;

  w_messaggio_1 := '';
  w_messaggio_2 := '';
  w_messaggio_3 := '';
  ANAELEV.tr_main (w_messaggio_1, w_messaggio_2, w_messaggio_3);
end;

procedure tr_main
(w_messaggio_1	IN OUT 	varchar2
,w_messaggio_2	IN OUT	varchar2
,w_messaggio_3	IN OUT	varchar2
)
is
w_errore                varchar2(255);
errore                  exception;
begin
  w_messaggio_1 := 'Evento '||p_evento;
  w_messaggio_1 := w_messaggio_1||chr(10)||'Data Evento '||to_char(to_date(P_DATA_EVE,'j'),'dd/mm/yyyy');
  if w_flag_ripristino is not null then
     w_messaggio_1 := w_messaggio_1||chr(10)||'Flag Ripristino DL 5/2012 '||W_FLAG_RIPRISTINO;
  end if;
  w_messaggio_1 := w_messaggio_1||chr(10)||'Pratica '||P_PRATICA||' - Anno Pratica '||P_ANNO_PRATICA;

  TRATTAMENTO      := 9;
  esiste_anatri    := '';
  esiste_eleana    := '';
  esiste_elemov    := '';
  esiste_elemov_51 := '';
  esiste_elemov_FR := '';
  esiste_eleela    := '';
  esiste_elemla    := '';
  esiste_elemla_51 := '';
  esiste_elemla_FR := '';

-- dbms_output.put_line('passa '||p_evento||'-'||p_data_eve||'-'||p_pratica||'-'||p_anno_pratica);
  begin
     select '','','','','','','','','','','','','','','','','','','',''
       into cod_mov_prec,cod_eve_prec,
               data_eve_prec,rapporto_par,sequenza_par,data_inizio_fam,
               data_inizio_res,intestatario,mov_cod_fam,cod_fam,
               via_aire,cod_pro_aire,cod_com_aire,cod_via,num_civ,suffisso,
               interno,sub_interno,nucleo_partenza,nucleo_arrivo
       from dual;
  end;

-- dbms_output.put_line('passa0 ');
  for rec_mat in sel_matricola loop

-- dbms_output.put_line('passa1 ');
    r_matricola  := rec_mat.matricola;
    r_cod_mov    := rec_mat.cod_mov;
    r_cod_eve    := rec_mat.cod_eve;
    r_cod_eve_pr := rec_mat.cod_eve_pr;
    r_data_reg   := rec_mat.data_reg;
    r_id_anaeve  := rec_mat.id_anaeve;
-- dbms_output.put_line('p1 '||r_matricola||'-'||r_cod_mov||'-'||r_cod_eve||'-'||r_cod_eve_pr||'-'||r_id_anaeve);
    if trattamento = 1 then
      exit;
    end if;

    begin
      select 0
        into trattamento
        from dual
       where not exists (select 'x'
                           from anaeve
                          where data_reg     > r_data_reg
                            and matricola    = r_matricola)
      ;
      begin
        select 0
          into trattamento
          from dual
         where not exists (select 'x'
                             from anaeve
                            where cod_eve_pr   != r_cod_eve_pr
                              and data_reg      = r_data_reg
                              and matricola     = r_matricola
                              and id            > r_id_anaeve)
        ;
      exception
        when others then
             trattamento := 2; -- esistono eventi diversi nella stessa data
-- dbms_output.put_line('ERRORE 1 ');
      end;
    exception
      when others then
           trattamento := 1; -- esistono eventi successivi
-- dbms_output.put_line('ERRORE 2 ');
    end;

    if trattamento != 0 then
      exit;
    end if;

-- dbms_output.put_line('p2 '||trattamento);
    begin
      select cod_fam,nucleo_partenza,nucleo_arrivo,
               nvl(intestatario_prec,intestatario),data_nas
        into mov_cod_fam,nucleo_partenza,nucleo_arrivo,intestatario,data_nas
        from anamov
       where cod_mov  	= r_cod_mov
         and cod_eve 		= r_cod_eve
         and data_eve       = anaelev.p_data_eve
         and nvl(pratica,anaelev.p_pratica)    		= anaelev.p_pratica
         and nvl(anno_pratica,anaelev.p_anno_pratica) = anaelev.p_anno_pratica
         and matricola      = r_matricola
         and data_reg       = r_data_reg;
    exception
      when no_data_found then
        w_errore     := 'Errore in estrazione parametri anamov('||SQLERRM||')';
        raise errore;
      when others then
        w_errore     := 'Errore in estrazione parametri anamov('||SQLERRM||')';
        raise errore;
    end;

-- dbms_output.put_line('dopo trattamento '||trattamento);
-- PARTE 1 -- COD_EVE IN (2,3,5,9,11,12,13,14,15,16,17)------------------------------------------------------
    if rec_mat.cod_mov = 1 and rec_mat.cod_eve not in (1,4) then
-- dbms_output.put_line('PRIMA PARTE 1 ' ||rec_mat.cod_eve||'-'||rec_mat.cod_mov);
      ESTRAI_ANAAPM;
      ESTRAI_ANAEVE_PREC;
      if DATA_EVE_PREC is not null then
        ESTRAI_ANAEVE_10_12_PREC;
        ANAELEV.UPD_ANAANA;
      else
       ANAELEV.CONTROLLA_RIFERIMENTI;
         if NVL(TRATTAMENTO,0) = 3 then
           exit; exit;
         end if;
       if DATA_DECORRENZA is not null then
         ANAELEV.UPD_ANAANA_5;
       else
         ANAELEV.DEL_ANAANA;
         ANAELEV.UPD_ANAANA_CN;
         ANAELEV.DEL_ANADOC;
       end if;
      end if;
      ANAELEV.DEL_ANAEVE;
      ANAELEV.DEL_ANAMOV;
      ANAELEV.CONTROLLO_DIC;
      if NUCLEO_ARRIVO is not null then
         ANAELEV.DEL_ANAFAM;
      end if;
    end if;
-- PARTE 2 -- COD_EVE IN (4)----------------------------------------------------
    if rec_mat.cod_eve = 4 then
-- dbms_output.put_line('PARTE 2 ' ||r_cod_MOV);
      ESTRAI_ANAEVE_10_12;
      ESTRAI_ANAEVE_13;
      ESTRAI_ANAEVE_PREC;
      ESTRAI_MAT_AIRE;
-- dbms_output.put_line('PARTE 2 ' ||w_matricola_aire);
      if data_eve_prec is not null then
        UPD_ANAANA;
      ELSE
        cod_mov_prec := 3;
        cod_eve_prec := 1;
        data_eve_prec := data_nas;
        data_reg_prec := data_nas;
        UPD_ANAANA;
      end if;
      if nucleo_partenza is not null then
        UPD_ANAFAM_AIRE;
      end if;
      ANAELEV.DEL_ANAEVE;
      ANAELEV.DEL_ANAMOV;
      ESTRAI_ANAC01;
      DEL_ANAC01;
      DEL_ANAC0M;
      ANAELEV.CONTROLLO_DIC;
    end if;
-------------------------------PARTE 3 -----------------------------------------
-----------------------------------PARTE 4--------------------------------------
--------------------------------COD_EVE IN (6,7,8,9) COD_MOV = 3----------------
   if rec_mat.cod_eve in (6,7,8,9,10) and rec_mat.cod_mov = 3 then
-- dbms_output.put_line('PARTE 4 ' ||rec_mat.cod_eve||'-'||rec_mat.cod_mov);
     ESTRAI_ANAEVE_PREC;
     if data_eve_prec is not null then
       ESTRAI_ANAEVE_10_12_PREC;
       UPD_ANAANA;
     else
       ANAELEV.CONTROLLA_RIFERIMENTI;
--       if NVL(TRATTAMENTO,0) = 1 then
       if NVL(TRATTAMENTO,0) = 3 then
         exit; exit;
       end if;
       DEL_ANAANA;
       UPD_ANAANA_CN;
       DEL_ANADOC;
     end if;
     DEL_ANAEVE;
     DEL_ANAMOV;
     ESTRAI_ANAA01;
     DEL_ANAA01;
     DEL_ANAA0M;
     ANAELEV.CONTROLLO_DIC;
     if nucleo_arrivo is not null then
       DEL_ANAFAM;
     end if;
   end if;
--------------------------------------------------------------------------------
----------------------------PARTE 5 -- COD_EVE = 51 ----------------------------
    if rec_mat.cod_eve in (51,61) then
-- dbms_output.put_line('PARTE 5 ' ||rec_mat.cod_eve);
      ESTRAI_ANAEVE_10_12;
      ESTRAI_ANAEVE_11;
      ESTRAI_ANAEVE_PREC;
      ANAELEV.CONTROLLA_RIFERIMENTI_51;
      if NVL(TRATTAMENTO,0) = 4 then
        exit; exit;
      end if;
      if data_eve_prec is not null then
        UPD_ANAANA;
      ELSE
        cod_mov_prec := 1;
        cod_eve_prec := 1;
        data_eve_prec := data_nas;
        data_reg_prec := data_nas;
        UPD_ANAANA;
      end if;
      if nucleo_partenza is not null then
        UPD_ANAFAM_RES;
      END IF;
      DEL_ANAEVE;
      DEL_ANAMOV;
      ANAELEV.CONTROLLO_DIC;
    end if;
--------------------------------------------------------------------------------
----------------------------------PARTE 6 -- COD_EVE = 52 ----------------------
    if rec_mat.cod_eve = 52 then
-- dbms_output.put_line('PARTE 6 ' ||rec_mat.cod_eve);
      ESTRAI_ANAEVE_10_12;
      ESTRAI_ANAEVE_11;
      ESTRAI_ANAEVE_PREC;
      if data_eve_prec is not null then
        UPD_ANAANA;
      ELSE
        cod_mov_prec := 1;
        cod_eve_prec := 1;
        data_eve_prec := data_nas;
        data_reg_prec := data_nas;
        UPD_ANAANA;
      end if;
      if nucleo_partenza is not null then
        UPD_ANAFAM_RES;
      END IF;
      DEL_ANAEVE;
      DEL_ANAMOV;
      ESTRAI_ANAA01;
      UPD_ANAA01;
      ANAELEV.CONTROLLO_DIC;
      if nucleo_arrivo is not null then
        DEL_ANAFAM;
      end if;
    end if;
--------------------------------------------------------------------------------
--------------------------PARTE 7 -- COD_EVE  in (53,54,58,59,60) --------------
    if rec_mat.cod_eve in(53,54,58,59,60) then
-- dbms_output.put_line('PARTE 7 ' ||rec_mat.cod_eve);
      ESTRAI_ANAEVE_10_12;
      ESTRAI_ANAEVE_11;
      ESTRAI_ANAEVE_PREC;
      if data_eve_prec is not null then
        UPD_ANAANA;
      ELSE
        cod_mov_prec := 1;
        cod_eve_prec := 1;
        data_eve_prec := data_nas;
        data_reg_prec := data_nas;
        UPD_ANAANA;
      end if;
      if nucleo_partenza is not null then
        UPD_ANAFAM_RES;
      END IF;
      DEL_ANAEVE;
      DEL_ANAMOV;
      ANAELEV.CONTROLLO_DIC;
    end if;
-------------------------------------------------------------------------------
-----------------------------PARTE 8 -- COD_EVE in (55,56,57)------------------
    if rec_mat.cod_eve in (55,56,57) then
-- dbms_output.put_line('PARTE 8 ' ||rec_mat.cod_eve);
      ESTRAI_ANAEVE_10_12;
      ESTRAI_ANAEVE_13;
      ESTRAI_ANAEVE_PREC;
      if data_eve_prec is not null then
        UPD_ANAANA;
      ELSE
        cod_mov_prec := 3;
        cod_eve_prec := 1;
        data_eve_prec := data_nas;
        data_reg_prec := data_nas;
        UPD_ANAANA;
      end if;
      if nucleo_partenza is not null then
        UPD_ANAFAM_AIRE;
      END IF;
      DEL_ANAEVE;
      DEL_ANAMOV;
	  pratica_dic      := anaelev.p_pratica;
      anno_pratica_dic := anaelev.p_anno_pratica;
-- dbms_output.put_line('pratica ' ||pratica_dic);
-- dbms_output.put_line('anno pratica ' ||anno_pratica_dic);
      ANAELEV.UPD_ANATPR;
-- dbms_output.put_line('dopo updanatpr');
      ANAELEV.DEL_ANASAP_0;
-- dbms_output.put_line('dopo del anasap');
    end if;
-------------------------------------------------------------------------------
--------------------------PARTE 9 -- COD_EVE = 90 ----------------------
    if rec_mat.cod_eve = 90 then
-- dbms_output.put_line('PARTE 9 ' ||rec_mat.cod_eve);
      ESTRAI_ANAEVE_10_12;
      ESTRAI_ANAEVE_PREC;
      if data_eve_prec is null then
        if rec_mat.cod_mov < 12 then
          cod_mov_prec := 1;
        else
          cod_mov_prec := 3;
        end if;
        cod_eve_prec := 1;
        data_eve_prec := data_nas;
        data_reg_prec := data_nas;
      end if;
      UPD_ANAANA;
      UPD_ANAFAM_90;
      DEL_ANAEVE;
      DEL_ANAMOV;
      if nucleo_arrivo is not null then
        DEL_ANAFAM;
      end if;
    end if;
--------------------------------------------------------------------------------
----------------------------------PARTE 10 -- COD_EVE = 91----------------------
    if rec_mat.cod_eve = 91 then
-- dbms_output.put_line('PARTE 10 ' ||rec_mat.cod_eve);
      if rec_mat.cod_mov < 12 then
        ESTRAI_ANAEVE_11;
        UPD_ANAFAM_RES;
      else
        ESTRAI_ANAEVE_13;
        UPD_ANAFAM_AIRE;
      end if;
      UPD_ANAANA_91;
      DEL_ANAEVE;
      DEL_ANAMOV;
      ANAELEV.CONTROLLO_DIC;
    end if;
-------------------------------------------------------------------------------
----------------------------------PARTE 11 -- COD_EVE = 92 --------------------
    if rec_mat.cod_eve = 92 then
-- dbms_output.put_line('PARTE 11 ' ||rec_mat.cod_eve);
      ESTRAI_ANAEVE_10_12;
      if rec_mat.cod_mov < 12 then
        ESTRAI_ANAEVE_11;
      else
        ESTRAI_ANAEVE_13;
      end if;
      ESTRAI_ANAEVE_PREC;
      if data_eve_prec is null then
        if rec_mat.cod_mov < 12 then
          cod_mov_prec := 1;
        else
          cod_mov_prec := 3;
        end if;
        cod_eve_prec := 1;
        data_eve_prec := data_nas;
        data_reg_prec := data_nas;
      end if;
      UPD_ANAANA_92;
      if nucleo_partenza is not null then
        if rec_mat.cod_mov < 12 then
          UPD_ANAFAM_RES;
        else
          UPD_ANAFAM_AIRE;
        end if;
      END IF;
      DEL_ANAEVE;
      DEL_ANAMOV;
      ANAELEV.CONTROLLO_DIC;
      if nucleo_arrivo is not null then
        DEL_ANAFAM;
      end if;
    end if;
--------------------------------------------------------------------------------
  end loop;
  data_reg_par := r_data_reg;
 ANAELEV.UPD_TABREP_DATA_REG;

 if r_cod_eve in (1,50) then
    w_messaggio_2 := '*** Tipologia di evento non eliminabile ***';
w_note_log := 'Tipologia di evento non eliminabile';

 else

-- trattamento := 1; -- esistono eventi successivi
-- trattamento := 2; -- esistono eventi diversi nella stessa data
-- trattamento := 3; -- esistono riferimenti in archivio elettorale / tributi
-- trattamento := 4; -- esistono riferimenti in archivio elettorale (rif. evento 51)
  if nvl(trattamento,1) = 2 then
    w_messaggio_2 := '*** Esistono eventi piu'' recenti: Eliminazione non consentita ***';
    w_messaggio_2 := w_messaggio_2||chr(10)||chr(10)||'Matricola : '||R_MATRICOLA;
w_note_log := 'Esistono eventi piu'' recenti: Eliminazione non consentita';
    ROLLBACK;

  elsif nvl(trattamento,1) = 3 then

    if esiste_anatri is not null then
-- dbms_output.put_line('passa7a trattamento '||nvl(trattamento,0));
    w_messaggio_2 := '*** Esistono riferimenti sui tributi: Eliminazione non consentita ***';
    w_messaggio_2 := w_messaggio_2||chr(10)||chr(10)||'Matricola : '||R_MATRICOLA;
w_note_log := 'Esistono riferimenti sui tributi: Eliminazione non consentita';
    end if;

    if esiste_eleana is not null or esiste_elemov is not null or
       esiste_eleela is not null or esiste_elemla is not null
    then
-- dbms_output.put_line('passa7b trattamento '||nvl(trattamento,0));
    w_messaggio_2 := '*** Esistono riferimenti su Elettorale: ';
w_note_log := 'Esistono riferimenti su Elettorale:';
      if esiste_eleana is not null then
         w_messaggio_2 := w_messaggio_2||'Archivio Elettori';
w_note_log := w_note_log||'Archivio Elettori';
      elsif esiste_elemov is not null then
         w_messaggio_2 := w_messaggio_2||'Movimenti Elettori';
w_note_log := w_note_log||'Movimenti Elettori';
      elsif esiste_eleela is not null then
         w_messaggio_2 := w_messaggio_2||'Archivio Elettori Liste Aggiunte';
w_note_log := w_note_log||'Archivio Elettori Liste Aggiunte';
      elsif esiste_elemla is not null then
         w_messaggio_2 := w_messaggio_2||'Movimenti Elettori Liste Aggiunte';
w_note_log := w_note_log||'Movimenti Elettori Liste Aggiunte';
      end if;
      w_messaggio_2 := w_messaggio_2||chr(10)||chr(10)||'*** Eliminazione non consentita ***';
      w_messaggio_2 := w_messaggio_2||chr(10)||chr(10)||'Matricola : '||R_MATRICOLA;
    end if;
    ROLLBACK;

  elsif nvl(trattamento,1) = 4 then
    w_messaggio_2 := '*** Individuo in cancellazione elettorale: Eliminazione non consentita ***';
    w_messaggio_2 := w_messaggio_2||chr(10)||chr(10)||'Matricola : '||R_MATRICOLA;
w_note_log := 'Individuo in cancellazione elettorale: Eliminazione non consentita';
    ROLLBACK;

  elsif NVL(TRATTAMENTO,1) not IN (0,1) then
    w_messaggio_2 := '*** Non esiste nessun evento relativo ai parametri indicati! ***';
w_note_log := 'Non esiste nessun evento relativo ai parametri indicati!';
    ROLLBACK;

  elsif NVL(TRATTAMENTO,1) = 0 then
    if esiste_elemov_FR||esiste_elemla_FR is not null then
       w_messaggio_2 := 'Trovati riferimenti su Elettorale che sono stati eliminati:';
w_note_log := 'Trovati riferimenti su Elettorale che sono stati eliminati:';

       if esiste_elemov_FR is not null then
          w_messaggio_2 := w_messaggio_2||chr(10)||'Movimenti Elettori (Fuori Revisione o SOSPESI)';
w_note_log := w_note_log||'Movimenti Elettori (Fuori Revisione o SOSPESI)';

       elsif esiste_elemla_FR is not null then
          w_messaggio_2 := w_messaggio_2||chr(10)||'Movimenti Elettori Liste Aggiunte (SOSPESI)';
w_note_log := w_note_log||'Movimenti Elettori Liste Aggiunte (SOSPESI)';
      end if;
    end if;

    w_messaggio_3 := '*** Eliminazione Eventi terminata correttamente!***';

  end if;

 end if;

 commit;
  --UPD_TABREP_NULL;
 anaelev.INS_GSDLOG;
exception
  when errore then
       rollback;
       if w_parametri_log is not null then
          w_operazione_log := 'Eliminazione Eventi (zk)';
          w_return_log := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
          commit;
       else
          raise_application_error(-20999,w_errore);
       end if;
  when others then
       rollback;
       if w_parametri_log is not null then
          w_operazione_log := 'Eliminazione Eventi (zk)';
          if w_note_log is null then
             w_note_log := sqlerrm;
          end if;
          w_return_log := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
          commit;
       else
          raise_application_error(-20999,'errore ('||SQLERRM||')');
       end if;
end;

procedure ESTRAI_ANAA01 is
begin
  select a01.protocollo_aire
    into protocollo_aire
    from anaa01 a01
   where a01.anno_pratica  = p_anno_pratica
     and a01.pratica       = p_pratica
     and rownum = 1;
exception
  when others then
  protocollo_aire := null;
end;

procedure ESTRAI_MAT_AIRE is
begin
  select matricola_aire
    into w_matricola_aire
    from anac0m
   where anno_pratica  = p_anno_pratica
     and pratica       = p_pratica
     and matricola     = anaelev.r_matricola
     and rownum = 1;
exception
  when others then
  w_matricola_aire := null;
end;

procedure ESTRAI_ANAAPM is
begin
  select data_decorrenza,anadrp.cod_rp,anadrp.sequenza,annullamento
    into data_decorrenza,rapporto_par_apm,sequenza_par_apm,
               annullamento_apm
    from anadrp,anadpi,anaap4,anaapm
   where anadrp.cod_rp (+) = anadpi.cod_rp
     and anadrp.sesso  (+) = anadpi.sesso
     and anadpi.ist_rp         = anaapm.ist_rp
     and anadpi.sesso         = anaapm.sesso
     and anaap4.anno_dic   = anaapm.anno_dic
     and anaap4.numero_dic = anaapm.numero_dic
     and anaapm.matricola  = r_matricola
     and rownum = 1
  order by anaap4.data_reg desc;
end;
procedure ESTRAI_ANAEVE_10_12 is
begin
  select data_inizio,cod_fam,rapporto_par,sequenza
    into data_inizio_fam,cod_fam,rapporto_par,sequenza_par
    from anaeve,anadrp
   where cod_rp (+)    = rapporto_par
     and cod_eve_pr          = r_cod_eve_pr
     and data_eve            = anaelev.p_data_eve - 1
     and pratica             = anaelev.p_pratica
     and anno_pratica        = anaelev.p_anno_pratica
     and matricola         = r_matricola
     and cod_mov                 in (10,12)
     and rownum = 1;
exception
  when others then
     data_inizio_fam:= null;
     cod_fam := null;
     rapporto_par := null;
     sequenza_par := null;
end;

procedure ESTRAI_ANAEVE_10_12_PREC is
begin
  select data_inizio,cod_fam,rapporto_par,sequenza
    into data_inizio_fam,cod_fam,rapporto_par,sequenza_par
    from anaeve,anadrp
    where cod_rp (+)    = rapporto_par
      and matricola         = r_matricola
      and cod_mov                    in (10,12)
      and data_reg in (select max(data_reg)
                         from anaeve
                        where id        < r_id_anaeve
                          and matricola = r_matricola
                          and cod_mov  in (10,12))
     and rownum = 1
 order by data_reg desc,data_eve desc;
exception
  when others then
     data_inizio_fam:= null;
     cod_fam := null;
     rapporto_par := null;
     sequenza_par := null;
end;



procedure ESTRAI_ANAEVE_11 is
begin
  select data_inizio,cod_via,num_civ,suffisso,interno,sub_interno
    into data_inizio_res,cod_via,num_civ,suffisso,interno,sub_interno
    from anaeve
   where cod_eve_pr      = r_cod_eve_pr
     and data_eve       = anaelev.p_data_eve - 1
     and pratica        = anaelev.p_pratica
     and anno_pratica   = anaelev.p_anno_pratica
     and matricola      = r_matricola
     and cod_mov        = 11
     and rownum = 1;
exception
  when others then
    data_inizio_res := null;
    cod_via := null;
    num_civ := null;
    suffisso := null;
    interno := null;
    sub_interno := null;
end;

procedure ESTRAI_ANAEVE_13 is
begin
  select data_inizio,via_aire,cod_pro_aire,cod_com_aire
    into data_inizio_res,via_aire,cod_pro_aire,cod_com_aire
    from anaeve
   where cod_eve_pr      = r_cod_eve_pr
     and data_eve        = anaelev.p_data_eve - 1
     and pratica         = anaelev.p_pratica
     and anno_pratica    = anaelev.p_anno_pratica
     and matricola       = r_matricola
     and cod_mov                 = 13
     and rownum = 1;
exception
  when others then
    data_inizio_res := null;
    via_aire  := null;
    cod_pro_aire := null;
    cod_com_aire := null;
end;

procedure ESTRAI_ANAEVE_PREC is
begin
  select cod_mov,cod_eve,cod_eve_pr,data_eve,pratica,anno_pratica,
         data_reg
    into cod_mov_prec,cod_eve_prec,cod_eve_pr_prec,data_eve_prec,
         pratica_prec,anno_pratica_prec,data_reg_prec
    from anaeve
   where matricola       = r_matricola
     and cod_mov + 0     in (1,2,3,4)
     and id              < r_id_anaeve
     AND data_reg in (select max(data_reg)
                        from anaeve
                       where id          < r_id_anaeve
                         and matricola   = r_matricola
                         and cod_mov + 0 in (1,2,3,4))
     and rownum = 1
        order by data_reg desc,data_eve desc ;
exception
  when others then
--raise_application_error(-20999, 'errore in estrai_anaeve_prec ('||sqlerrm||')');
    cod_mov_prec := null;  cod_eve_prec := null;
    cod_eve_pr_prec := null;
    data_eve_prec := null;
    pratica_prec := null;
    anno_pratica_prec := null;
    data_reg_prec := null;
end;

procedure  ESTRAI_ANAMOV is
begin
  select cod_fam,nucleo_partenza,nucleo_arrivo,
         nvl(intestatario_prec,intestatario),data_nas
    into mov_cod_fam,nucleo_partenza,nucleo_arrivo,intestatario,data_nas
    from anamov
   where cod_mov      = r_cod_mov
     and cod_eve         = r_cod_eve
     and data_eve       = anaelev.p_data_eve
     and nvl(pratica,anaelev.p_pratica)            = anaelev.p_pratica
     and nvl(anno_pratica,anaelev.p_anno_pratica) = anaelev.p_anno_pratica
     and matricola      = r_matricola
     and data_reg       = r_data_reg
     and rownum = 1;
exception
  when others then
    mov_cod_fam := null;
    nucleo_partenza := null;
    nucleo_arrivo := null;
    intestatario := null;
    data_nas:= null;
end;
procedure CONTROLLO_DIC is
begin

  if r_cod_mov = 1 then
    BEGIN
      select anno_dic, numero_dic
        into anno_pratica_dic,pratica_dic
        from anaap4
       where anno_pratica = anaelev.p_anno_pratica
         and pratica = anaelev.p_pratica
         and rownum = 1;
    exception
      when others then
        null;
    end;
  else
    pratica_dic      := anaelev.p_pratica;
    anno_pratica_dic := anaelev.p_anno_pratica;
  end if;
  ANAELEV.UPD_ANATPR;
  ANAELEV.DEL_ANASAP;
-- dbms_output.put_Line(r_cod_mov||'-'||r_cod_eve);
  if (r_cod_mov = 1 or (r_cod_mov = 3 and r_cod_eve != 52)) then -- Iscrizioni
-- dbms_output.put_Line('prima upd_anaap4');
      ANAELEV.UPD_ANAAP4;
  elsif (r_cod_mov = 2 or (r_cod_mov = 3 and r_cod_eve = 52) ) then
-- dbms_output.put_Line('prima upd_anacp4');
      ANAELEV.UPD_ANACP4;
  end if;
END;

procedure DEL_ANAA01 is
begin
        delete anaa01
         where protocollo_aire	= anaelev.protocollo_aire
           and anno_pratica		= anaelev.p_anno_pratica
           and anaelev.protocollo_aire is not null
;
end;

procedure DEL_ANAA0M is
begin
        delete anaa0m
         where protocollo_aire	= anaelev.protocollo_aire
           and anno_pratica		= anaelev.p_anno_pratica
           and anaelev.protocollo_aire is not null
;
end;

procedure DEL_ANAANA is
begin
        delete anaana
         where matricola	= r_matricola
;
end;

procedure DEL_ANADOC is
begin
        delete anadoc
         where matricola        = r_matricola
;
end;

procedure DEL_ANAEVE is
begin
        delete anaeve
         where cod_eve_pr	= r_cod_eve_pr
           and data_eve		in (anaelev.p_data_eve,anaelev.p_data_eve - 1)
           and pratica		= anaelev.p_pratica
           and anno_pratica	= anaelev.p_anno_pratica
           and matricola	= r_matricola
;
end;

procedure DEL_ANAFAM is
begin
  w_flag_preliminare := '';
  if r_cod_eve in (2,3,5,9,11,12,13,14,15,16) then
     w_flag_preliminare := f_flag_preliminare('RES','I',anaelev.p_anno_pratica,anaelev.p_pratica);
  elsif r_cod_eve = 17 then
     begin
       update anaap4
          set flag_aggregazione = '',
              presso 	        = '',
              cod_fam_dest      = ''
        where anno_dic		= anaelev.anno_pratica_dic
          and numero_dic	= anaelev.pratica_dic
          and cod_fam_dest	= anaelev.mov_cod_fam
       ;
     end;
  end if;

  if w_flag_preliminare is null then
     begin
        delete anafam
         where fascia		= decode(r_cod_mov,10,1,12,3,r_cod_mov)
           and cod_fam		= anaelev.mov_cod_fam
        ;
     end;
  end if;
end;

procedure DEL_ANAMOV is
begin
  if w_flag_ripristino = 'S' then
     anaelev.INS_ANAMOV_DL_5_2012;
     anaelev.UPD_ANACPM_DL_5_2012;
--     anaelev.UPD_ANACRM_DL_5_2012;
  else
     begin
        delete anamov
         where (r_cod_mov not in (10,12) and anamov.cod_mov = r_cod_mov or
                r_cod_mov = 10 and anamov.cod_mov in (10,11) or
                r_cod_mov = 12 and anamov.cod_mov in (12,13))
           and cod_eve		= r_cod_eve
           and data_eve		= anaelev.p_data_eve
           and nvl(pratica,anaelev.p_pratica)		= anaelev.p_pratica
           and nvl(anno_pratica,anaelev.p_anno_pratica)	= anaelev.p_anno_pratica
           and matricola	= r_matricola
           and data_reg       = r_data_reg;
     end;
  end if;
end;

procedure UPD_ANAANA is
begin
        update anaana
           set fascia		 = anaelev.cod_mov_prec,
               stato		 = anaelev.cod_eve_prec,
               data_ult_eve	 = anaelev.data_eve_prec,
               cod_fam		 = decode(anaelev.r_cod_mov, 1,
                                     decode(anaelev.cod_mov_prec, 1,
                                       nvl(anaelev.cod_fam,cod_fam),
                                       anaelev.cod_fam),
                                     anaelev.cod_fam),
               rapporto_par	 = nvl(anaelev.rapporto_par_apm,anaelev.rapporto_par),
               sequenza_par	 = nvl(anaelev.sequenza_par_apm,anaelev.sequenza_par),
               data_reg		 = anaelev.data_reg_prec,
               data_inizio_res = decode(anaelev.cod_mov_prec,
					     2,to_number(null),
					     4,to_number(null),
                                     nvl(anaelev.data_inizio_res,data_inizio_res)),
               data_inizio_fam = decode(anaelev.cod_mov_prec,
					     2,to_number(null),
					     4,to_number(null),
                                     nvl(anaelev.data_inizio_fam,data_inizio_fam)),
               matricola_aire	 = decode(r_cod_eve,4,w_matricola_aire,decode(r_cod_mov,3,'',matricola_aire))
         where matricola	 = r_matricola
;
end;

procedure UPD_ANAANA_5 is
begin
        update anaana
           set fascia		 = 5,
               stato		 = decode(anaelev.annullamento_apm,'S',71,70),
               data_ult_eve	 = anaelev.data_decorrenza,
               cod_fam		 = '',
               rapporto_par	 = anaelev.rapporto_par_apm,
               sequenza_par	 = anaelev.sequenza_par_apm,
               data_inizio_res = '',
               data_inizio_fam = ''
         where matricola       = r_matricola
;
end;

procedure UPD_ANAANA_91 is
begin
        update anaana
           set data_inizio_res = anaelev.data_inizio_res
         where matricola       = r_matricola
;
end;

procedure UPD_ANAANA_92 is
begin
         update anaana
            set cod_fam         = anaelev.cod_fam,
                rapporto_par     = nvl(anaelev.rapporto_par_apm,anaelev.rapporto_par),
                sequenza_par     = nvl(anaelev.sequenza_par_apm,anaelev.sequenza_par),
                data_inizio_res = decode(fascia,2,to_number(null),4,to_number(null),
                                      nvl(anaelev.data_inizio_res,data_inizio_res)),
                data_inizio_fam = decode(fascia,2,to_number(null),4,to_number(null),
                                      nvl(anaelev.data_inizio_fam,data_inizio_fam))
          where matricola     = r_matricola
;
end;

procedure UPD_ANAANA_CN is
begin
        update anaana
           set matricola_cn	= ''
         where matricola_cn	= r_matricola
;
end;

procedure UPD_ANAFAM_90 is
begin
        update anafam
           set intestatario	= anaelev.intestatario
         where fascia 		= anaelev.cod_mov_prec
           and cod_fam 		= anaelev.mov_cod_fam
;
end;

procedure UPD_ANAFAM_AIRE is
begin
        update anafam
           set intestatario	= anaelev.intestatario,
               fascia		= nvl(anaelev.cod_mov_prec,anafam.fascia),
               via_aire		= anaelev.via_aire,
               cod_pro_aire	= anaelev.cod_pro_aire,
               cod_com_aire	= anaelev.cod_com_aire
         where fascia		in (3,4)
           and cod_fam		= decode(r_cod_eve,
					     4,anaelev.cod_fam,
                                  92,anaelev.cod_fam,anaelev.mov_cod_fam)
;
end;

procedure UPD_ANAFAM_RES is
begin
        update anafam
           set intestatario	= decode(tipo_fam,1,intestatario,anaelev.intestatario),
               fascia         = nvl(anaelev.cod_mov_prec,anafam.fascia),
               cod_via        = anaelev.cod_via,
               num_civ        = anaelev.num_civ,
               suffisso       = anaelev.suffisso,
               interno        = anaelev.interno,
               sub_interno    = anaelev.sub_interno
         where fascia + 0     in (1,2)
           and cod_fam        = decode(r_cod_eve,
					    52,anaelev.cod_fam,
                                  92,anaelev.cod_fam,anaelev.mov_cod_fam)
;
end;

procedure UPD_TABREP_DATA_REG is
begin
        update tabrep
           set parametri = anaelev.data_reg_par
         where chiave    = 'ELEV'
           and terminale = nvl(rep_sessione,userenv('terminal'))
;
end;

procedure UPD_TABREP_NULL is
begin
        update tabrep
           set parametri = null
         where chiave    = 'ELEV'
           and terminale = nvl(rep_sessione,userenv('terminal'))
;
end;

procedure CONTROLLA_RIFERIMENTI is
w_ctr_eledur	number;
begin
  begin
    select 'S'
      into esiste_anatri
      from anatri
     where matricola = r_matricola;
  exception
    when others then
--         esiste_anatri := null;
         null;
  end;

  begin
    select 'S'
      into esiste_eleana
      from eleana
     where matricola = r_matricola
    ;
  exception
    when others then
--         esiste_eleana := null;
         null;
  end;

  begin
    select revisione, sospensione, flag_trattato
      into ele_revisione, ele_sospensione, ele_flag_trattato
      from elemov
     where matricola = r_matricola
    ;
    if (nvl(ele_revisione,'FR') != 'FR' and ele_sospensione is null)
       or (nvl(ele_revisione,'FR') = 'FR' and ele_flag_trattato is not null)
    then
       w_ctr_eledur := 0;
       begin
         select 1 into w_ctr_eledur
           from eledur
          where (stato_revisione is null and tipo_revisione = ele_revisione and ele_revisione != 'SE')
             or (stato_semestrale is null and progr_semestrale is not null and ele_revisione = 'SE')
         ;
       exception
         when others then
              w_ctr_eledur := 0;
       end;
       if w_ctr_eledur = 1 then
          esiste_elemov    := 'S';
       else
          esiste_elemov_FR := null;
          goto del_elemov;
       end if;
    else
       esiste_elemov_FR := 'S';
       goto del_elemov;
    end if;

    goto salta_del_elemov;

<< del_elemov >>
       begin
         delete elemov
          where matricola = r_matricola
            and ((nvl(revisione,'FR') = 'FR' and flag_trattato is null)
                 or (nvl(revisione,'FR') != 'FR' and sospensione is not null))
         ;
         if sql%found then
            w_messaggio := w_messaggio||chr(10)||chr(10)||'Presente movimento elettorale FR o sospeso: matricola '||r_matricola;
w_note_log := w_note_log||'Presente movimento elettorale FR o sospeso: matricola '||r_matricola;
         end if;
       exception
         when others then
              w_messaggio := w_messaggio||chr(10)||chr(10)||'ERRORE in eliminazione ELEMOV - matricola '||r_matricola||' ('||SQLERRM||')';
w_note_log := w_note_log||'ERRORE in eliminazione ELEMOV - matricola '||r_matricola||' ('||SQLERRM||')';
       end;

<< salta_del_elemov >>
null;

  exception
    when others then
--         esiste_elemov    := null;
--         esiste_elemov_FR := null;
         null;
  end;

  begin
    select 'S'
      into esiste_eleela
      from eleela
     where matricola = r_matricola
    ;
  exception
    when others then
--         esiste_eleela := null;
         null;
  end;

  begin
    select revisione, sospensione
      into ele_revisione, ele_sospensione
      from elemla
     where matricola = r_matricola
    ;
    if (nvl(ele_revisione,'FR') != 'FR' and ele_sospensione is null)
    then
       w_ctr_eledur := 0;
       begin
         select 1 into w_ctr_eledur
           from eledur
          where stato_revisione_agg is null
            and tipo_revisione_agg = ele_revisione
         ;
       exception
         when others then
              w_ctr_eledur := 0;
       end;
       if w_ctr_eledur = 1 then
          esiste_elemla    := 'S';
       else
          esiste_elemla_FR := null;
          goto del_elemla;
       end if;
    else
       esiste_elemla_FR := 'S';
       goto del_elemla;
    end if;

    goto salta_del_elemla;

<< del_elemla >>

       begin
         delete elemla
          where matricola = r_matricola
            and nvl(revisione,'FR') != 'FR'
            and sospensione is not null
         ;
         if sql%found then
            w_messaggio := w_messaggio||chr(10)||chr(10)||'Presente movimento Lista Aggiunta (sospeso): matricola '||r_matricola;
w_note_log := w_note_log||'Presente movimento Lista Aggiunta (sospeso): matricola '||r_matricola;
         end if;
       exception
         when others then
              w_messaggio := w_messaggio||chr(10)||chr(10)||'ERRORE in eliminazione ELEMLA - matricola '||r_matricola||' ('||SQLERRM||')';
w_note_log := w_note_log||'ERRORE in eliminazione ELEMLA - matricola '||r_matricola||' ('||SQLERRM||')';
       end;

<< salta_del_elemla >>
null;

  exception
    when others then
--         esiste_elemla    := null;
--         esiste_elemla_FR := null;
         null;
  end;

  if ESISTE_ANATRI is not null or
     ESISTE_ELEANA is NOT null or ESISTE_ELEMOV is not null or
     ESISTE_ELEELA is NOT null or ESISTE_ELEMLA is not null
  then
     TRATTAMENTO := 3; -- esistono riferimenti in archivio elettorale / tributi
  else
     trattamento := 0;
  end if;
null;
end;

procedure CONTROLLA_RIFERIMENTI_51 is
begin
  begin
    select revisione, sospensione, flag_trattato
      into ele_revisione, ele_sospensione, ele_flag_trattato
      from elemov
     where matricola = r_matricola
       and tipo_movimento = 'C'
       and data_eve between r_data_reg and to_number(to_char(sysdate,'j'))
    ;
    if (nvl(ele_revisione,'FR') != 'FR' and ele_sospensione is null)
       or (nvl(ele_revisione,'FR') = 'FR' and ele_flag_trattato is not null)
    then
       esiste_elemov_51 := 'S';
--       esiste_elemov_FR := null;
    else
--       esiste_elemov_51 := null;
       esiste_elemov_FR := 'S';

       begin
         delete elemov
          where matricola = r_matricola
            and ((nvl(revisione,'FR') = 'FR' and flag_trattato is null)
                 or (nvl(revisione,'FR') != 'FR' and sospensione is not null))
         ;
         if sql%found then
            w_messaggio := w_messaggio||chr(10)||chr(10)||'Presente movimento elettorale (FR o sospeso): matricola '||r_matricola;
w_note_log := w_note_log||'Presente movimento elettorale (FR o sospeso): matricola '||r_matricola;
         end if;
       exception
         when others then
            w_messaggio := w_messaggio||chr(10)||chr(10)||'ERRORE in eliminazione ELEMOV - matricola '||r_matricola||' ('||SQLERRM||')';
w_note_log := w_note_log||'ERRORE in eliminazione ELEMOV - matricola '||r_matricola||' ('||SQLERRM||')';
       end;

    end if;
  exception
    when others then
--         esiste_elemov_51 := null;
--         esiste_elemov_FR := null;
         null;
  end;

  begin
    select revisione, sospensione
      into ele_revisione, ele_sospensione
      from elemla
     where matricola = r_matricola
       and tipo_movimento = 'C'
       and data_eve between r_data_reg and to_number(to_char(sysdate,'j'))
    ;
    if (nvl(ele_revisione,'FR') != 'FR' and ele_sospensione is null) then
       esiste_elemla_51 := 'S';
--       esiste_elemla_FR := null;
    else
--       esiste_elemla_51 := null;
       esiste_elemla_FR := 'S';

       begin
         delete elemla
          where matricola = r_matricola
            and nvl(revisione,'FR') != 'FR'
            and sospensione is not null
         ;
         if sql%found then
            w_messaggio := w_messaggio||chr(10)||chr(10)||'Presente movimento Lista Aggiunta (FR o sospeso): matricola '||r_matricola;
w_note_log := w_note_log||'Presente movimento Lista Aggiunta (FR o sospeso): matricola '||r_matricola;
         end if;
       exception
         when others then
              w_messaggio := w_messaggio||chr(10)||chr(10)||'ERRORE in eliminazione ELEMLA - matricola '||r_matricola||' ('||SQLERRM||')';
w_note_log := w_note_log||'ERRORE in eliminazione ELEMLA - matricola '||r_matricola||' ('||SQLERRM||')';
       end;

    end if;
  exception
    when others then
--         esiste_elemla_51 := null;
--         esiste_elemla_FR := null;
         null;
  end;

  if esiste_elemov_51 is not null or esiste_elemla_51 is not null then
     TRATTAMENTO := 4; -- esistono riferimenti in archivio elettorale (rif. evento 51)
  else
     trattamento := 0;
  end if;
null;
end;

procedure UPD_ANATPR is
begin

     begin
       update anatpr
          set cod_variazione ='P'
        where anagrafe = 'RES'
          and tipo_evento = 'I'
          and anno_pratica =  anaelev.ANNO_PRATICA_DIC
          and pratica        = anaelev.PRATICA_DIC
          and flag_perfezionamento is null
          and r_cod_eve  = 17;
     end;

     begin
	 update anatpr
	    set flag_perfezionamento = ''
	  where ((anagrafe		= decode(r_cod_mov,3,'AIR',4,'AIR',12,'AIR',13,'AIR','RES') and r_cod_eve!=52) or
                 (anagrafe in ('AIR','RES') and r_cod_eve = 52))
 	    and((tipo_evento	= decode(r_cod_mov,3,'I',1,'I',2,'C',4,'C','E') and r_cod_eve != 52) or
             (tipo_evento	= decode(r_cod_mov,3,'C','E') and r_cod_eve = 52))
  	    and anno_pratica	= anaelev.ANNO_PRATICA_DIC
 	    and pratica		= anaelev.PRATICA_DIC
	    and flag_perfezionamento is not null
	 ;
     end;
end;

procedure DEL_ANASAP is
begin
     begin
	 delete anasap
 	  where ((anagrafe		= decode(r_cod_mov,3,'AIR',4,'AIR',12,'AIR',13,'AIR','RES') and r_cod_eve!=52) or
                 (anagrafe in ('AIR','RES') and r_cod_eve = 52))
 	    and((tipo_evento	= decode(r_cod_mov,3,'I',1,'I',2,'C',4,'C','E') and r_cod_eve != 52) or
             (tipo_evento	= decode(r_cod_mov,3,'C','E') and r_cod_eve = 52))
  	    and anno_pratica	= anaelev.ANNO_PRATICA_DIC
 	    and pratica		= anaelev.PRATICA_DIC
            and data_evento     = anaelev.r_data_reg
 	    and evento_pratica	= 7
	 ;
     end;
end;

procedure DEL_ANASAP_0 is
begin
     begin
	 delete anasap
 	  where anno_pratica	= anaelev.ANNO_PRATICA_DIC
 	    and pratica		= anaelev.PRATICA_DIC
            and data_evento     = anaelev.r_data_reg
 	    and evento_pratica	= 7
	 ;
     end;
end;

procedure UPD_ANAA01 is
begin
        update anaa01
           set cod_fam	= ''
	 where protocollo_aire		= anaelev.protocollo_aire
           and anno_pratica		= anaelev.p_anno_pratica
           and anaelev.protocollo_aire 	is not null
	   and flag_aggregazione	is null
;
end;

procedure UPD_ANAAP4 is
begin
        update anaap4
           set data_reg = to_number(null)
	 where anno_pratica		= anaelev.p_anno_pratica
           and pratica      = anaelev.p_pratica
;
end;

procedure UPD_ANACP4 is
begin
        update anacp4
           set data_reg = to_number(null)
	 where anno_pratica		= anaelev.p_anno_pratica
           and pratica      = anaelev.p_pratica
;
end;

procedure ESTRAI_ANAC01 is
begin
  select c01.protocollo_aire
    into r_protocollo_aire
    from anac01 c01
   where c01.anno_pratica  = p_anno_pratica
     and c01.pratica       = p_pratica
     and rownum = 1;
exception
  when others then
    r_protocollo_aire := null;
end;

procedure DEL_ANAC01 is
begin
        delete anac01
         where anno_pratica	= anaelev.p_anno_pratica
           and pratica		= anaelev.p_pratica
           and protocollo_aire  = anaelev.r_protocollo_aire
           and protocollo_aire is not null
;
end;

procedure DEL_ANAC0M is
begin
        delete anac0m
         where anno_pratica	= anaelev.p_anno_pratica
           and pratica		= anaelev.p_pratica
           and protocollo_aire  = anaelev.r_protocollo_aire
           and matricola   = anaelev.r_matricola
           and protocollo_aire is not null
;
end;

procedure INS_ANAMOV_DL_5_2012 is         /*****************************/
begin
       insert into anamov
		 (MATRICOLA, COD_MOV, COD_EVE, COD_VARIAZIONE, ANNO_PRATICA, PRATICA,
              DATA_EVE, COD_PRO_EVE, COD_COM_EVE,
              NUCLEO_PARTENZA, NUCLEO_ARRIVO,
              COGNOME_NOME, STATO_CIVILE, SESSO, NAZIONALITA,
              PATERNITA, MATERNITA,
              TITOLO_STUDIO, COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF, PENSIONATO,
              COD_FAM_PREC, INTESTATARIO_PREC, RAPPORTO_PAR_PREC,
              COD_VIA_PREC, NUM_CIV_PREC, SUFFISSO_PREC, INTERNO_PREC, SCALA_PREC, PIANO_PREC, SUB_INTERNO_PREC,
              COD_FAM, INTESTATARIO, RAPPORTO_PAR, DATA_INIZIO_FAM,
              COD_VIA, NUM_CIV, SUFFISSO, INTERNO, SCALA, PIANO, SUB_INTERNO, DATA_INIZIO_RES,
              COGNOME_NOME_CN, MATRICOLA_CN,
              ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS, COD_EDIFICIO_CENS,
              COD_PRO_NAS, COD_COM_NAS, DATA_NAS, COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS,
              ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS,
              ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR,
              COD_PRO_MAT, COD_COM_MAT, DATA_MAT,
              ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT,
              ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR,
              COD_PRO_VED, COD_COM_VED, DATA_VED,
              ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED,
              COD_FISCALE, CF_CALCOLATO, DATA_REG, TERMINALISTA,
              COD_PRO_DIV, COD_COM_DIV, DATA_DIV,
              ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV,
              COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT, COD_PRO_ATTO_VED, COD_COM_ATTO_VED,
              COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV, DATA_DIV_GIU, DATA_DIV_ANN,
              ANNO_NAS, ANNO_MAT, MATRICOLA_PD, MATRICOLA_MD)
       select mov.MATRICOLA,
-- cod_mov
              decode(anaelev.r_cod_mov,2, 1, 1, 2, mov.cod_mov),
-- cod_eve
              decode(anaelev.r_cod_mov,2, 18, 1, 62, mov.cod_eve),
-- cod_variazione
              decode(anaelev.r_cod_mov,2, to_char(null), 1, to_char(null), 'X'),
              mov.ANNO_PRATICA, mov.PRATICA,
              mov.DATA_EVE, mov.COD_PRO_EVE, mov.COD_COM_EVE,
-- nucleo_partenza
              decode(anaelev.r_cod_mov,2, to_number(null), mov.NUCLEO_ARRIVO),
-- nucleo_arrivo
               decode(anaelev.r_cod_mov,1, to_number(null), mov.NUCLEO_PARTENZA),
              mov.COGNOME_NOME, mov.STATO_CIVILE, mov.SESSO, mov.NAZIONALITA,
              mov.PATERNITA, mov.MATERNITA,
              mov.TITOLO_STUDIO, mov.COD_PROF, mov.ATTIVITA_PROF, mov.POSIZIONE_PROF, mov.PENSIONATO,
-- cod_fam_prec
              decode(anaelev.r_cod_mov, 2, to_number(null), 1, to_number(null), mov.COD_FAM),
-- intestatario_prec
              decode(anaelev.r_cod_mov, 2, to_char(null), 1, to_char(null), mov.INTESTATARIO),
-- rapporto_par_prec
              decode(anaelev.r_cod_mov, 2, to_char(null), 1, to_char(null), mov.RAPPORTO_PAR),
-- cod_via_prec
              decode(anaelev.r_cod_mov, 2, to_number(null), 1, to_number(null), mov.COD_VIA),
-- num_civ_prec
              decode(anaelev.r_cod_mov, 2, to_number(null), 1, to_number(null), mov.NUM_CIV),
-- suffisso_prec
              decode(anaelev.r_cod_mov, 2, to_char(null), 1, to_char(null), mov.SUFFISSO),
-- interno_prec
              decode(anaelev.r_cod_mov, 2, to_number(null), 1, to_number(null), mov.INTERNO),
-- scala_prec
              decode(anaelev.r_cod_mov, 2, to_char(null), 1, to_char(null), mov.SCALA),
-- piano_prec
              decode(anaelev.r_cod_mov, 2, to_char(null), 1, to_char(null), mov.PIANO),
-- sub_interno_prec
              decode(anaelev.r_cod_mov, 2, to_char(null), 1, to_char(null), mov.SUB_INTERNO),
-- cod_fam
              decode(anaelev.r_cod_mov, 2, mov.COD_FAM, 1, mov.COD_FAM, nvl(mov.COD_FAM_PREC,mov.COD_FAM)),
-- intestatario
              decode(anaelev.r_cod_mov, 2, mov.INTESTATARIO, 1, mov.INTESTATARIO, nvl(mov.INTESTATARIO_PREC,mov.INTESTATARIO)),
-- rapporto_par
              decode(anaelev.r_cod_mov, 2, mov.RAPPORTO_PAR, 1, mov.RAPPORTO_PAR, nvl(mov.RAPPORTO_PAR_PREC,mov.RAPPORTO_PAR)),
-- data_inizio_fam
              mov.DATA_EVE,
-- cod_via
              decode(anaelev.r_cod_mov, 2, mov.COD_VIA, 1, mov.COD_VIA, mov.COD_VIA_PREC),
-- num_civ
              decode(anaelev.r_cod_mov, 2, mov.NUM_CIV, 1, mov.NUM_CIV, mov.NUM_CIV_PREC),
-- suffisso
              decode(anaelev.r_cod_mov, 2, mov.SUFFISSO, 1, mov.SUFFISSO, mov.SUFFISSO_PREC),
-- interno
              decode(anaelev.r_cod_mov, 2, mov.INTERNO, 1, mov.INTERNO, mov.INTERNO_PREC),
-- scala
              decode(anaelev.r_cod_mov, 2, mov.SCALA, 1, mov.SCALA, mov.SCALA_PREC),
-- piano
              decode(anaelev.r_cod_mov, 2, mov.PIANO, 1, mov.PIANO, mov.PIANO_PREC),
-- sub_interno
              decode(anaelev.r_cod_mov, 2, mov.SUB_INTERNO, 1, mov.SUB_INTERNO, mov.SUB_INTERNO_PREC),
-- data_inizio_res
              mov.DATA_EVE,
              mov.COGNOME_NOME_CN, mov.MATRICOLA_CN,
              mov.ANNO_CENS, mov.SEZIONE_CENS, mov.FOGLIO_CENS, mov.COD_EDIFICIO_CENS,
              mov.COD_PRO_NAS, mov.COD_COM_NAS, mov.DATA_NAS, mov.COD_PRO_ATTO_NAS, mov.COD_COM_ATTO_NAS,
              mov.ANNO_ATTO_NAS, mov.ATTO_NAS, mov.PARTE_NAS, mov.SERIE_NAS, mov.UFFICIO_NAS,
              mov.ANNO_ATTO_NAS_TR, mov.ATTO_NAS_TR, mov.PARTE_NAS_TR, mov.SERIE_NAS_TR, mov.UFFICIO_NAS_TR,
              mov.COD_PRO_MAT, mov.COD_COM_MAT, mov.DATA_MAT,
              mov.ANNO_ATTO_MAT, mov.ATTO_MAT, mov.PARTE_MAT, mov.SERIE_MAT, mov.UFFICIO_MAT,
              mov.ANNO_ATTO_MAT_TR, mov.ATTO_MAT_TR, mov.PARTE_MAT_TR, mov.SERIE_MAT_TR, mov.UFFICIO_MAT_TR,
              mov.COD_PRO_VED, mov.COD_COM_VED, mov.DATA_VED,
              mov.ANNO_ATTO_VED, mov.ATTO_VED, mov.PARTE_VED, mov.SERIE_VED, mov.UFFICIO_VED,
              mov.COD_FISCALE, mov.CF_CALCOLATO,
-- data_reg
              to_char(sysdate,'j'),
-- terminalista
              anaelev.w_terminalista,
              mov.COD_PRO_DIV, mov.COD_COM_DIV, mov.DATA_DIV,
              mov.ANNO_ATTO_DIV, mov.ATTO_DIV, mov.PARTE_DIV, mov.SERIE_DIV, mov.UFFICIO_DIV,
              mov.COD_PRO_ATTO_MAT, mov.COD_COM_ATTO_MAT, mov.COD_PRO_ATTO_VED, mov.COD_COM_ATTO_VED,
              mov.COD_PRO_ATTO_DIV, mov.COD_COM_ATTO_DIV, mov.DATA_DIV_GIU, mov.DATA_DIV_ANN,
              mov.ANNO_NAS, mov.ANNO_MAT,
              mov.MATRICOLA_PD, mov.MATRICOLA_MD
         from anamov mov
        where ((anaelev.r_cod_mov not in (10,12) and mov.cod_mov = anaelev.r_cod_mov)
               or (anaelev.r_cod_mov = 10 and mov.cod_mov in (10,11))
               or (anaelev.r_cod_mov = 12 and mov.cod_mov in (12,13)))
          and mov.cod_eve						= anaelev.r_cod_eve
          and mov.data_eve						= anaelev.p_data_eve
          and nvl(mov.pratica,anaelev.p_pratica)			= anaelev.p_pratica
          and nvl(mov.anno_pratica,anaelev.p_anno_pratica)	= anaelev.p_anno_pratica
          and mov.matricola						= anaelev.r_matricola
          and mov.data_reg						= anaelev.r_data_reg
       ;
end;

procedure UPD_ANACPM_DL_5_2012 is
begin
  if anaelev.r_cod_mov = 2 and anaelev.r_cod_eve = 51 then
     begin
       update anacp4 cp4
          set data_ripristino    = to_char(sysdate,'j')
        where cp4.anno_pratica  = anaelev.p_anno_pratica
          and cp4.pratica	  = anaelev.p_pratica
        ;
     end;
     begin
       update anacpm cpm
          set flag_ripristino = 'S'
        where cpm.matricola     = anaelev.r_matricola
          and cpm.flag_soggetto = 'S'
          and (cpm.anno_dic, cpm.numero_dic) in
              (select cp4.anno_dic, cp4.numero_dic
                 from anacp4 cp4
                where cp4.anno_pratica = anaelev.p_anno_pratica
                  and cp4.pratica	   = anaelev.p_pratica)
        ;
     end;
  end if;
end;

--procedure UPD_ANACRM_DL_5_2012 is
--begin
--  if anaelev.r_cod_eve in (91,92) then
--     begin
--       update anacrm crm
--          set flag_ripristino = 'S'
--        where crm.matricola     = anaelev.r_matricola
--          and crm.flag_soggetto = 'S'
--          and crm.anno_pratica  = anaelev.p_anno_pratica
--          and crm.pratica	  = anaelev.p_pratica
--        ;
--     end;
--  end if;
--end;

procedure INS_GSDLOG is
w_des_evento	varchar2(255);
begin
  begin
    select descrizione
      into w_des_evento
      from anadev
     where cod_ev = p_evento
    ;
  exception
    when others then
         null;
  end;
     inserisci_gsdlog('ELEV',
                       'pratica: '||p_pratica||'/'||p_anno_pratica||
                         ' - evento_ric: '||p_evento||' ('||w_des_evento||')'||
                         ' - data_evento_ric: '||to_char(to_date(p_data_eve,'j'),'dd/mm/yyyy')||
                         ' - pratica_ric: '||p_pratica||
                         ' - anno_pratica_ric: '||p_anno_pratica||
                         ' - data_reg: '||to_char(to_date(data_reg_par,'j'),'dd/mm/yyyy'),
                       nvl(w_note_log,w_note_par),
                    w_terminalista)
      ;
end;

FUNCTION VERSIONE
RETURN varchar2

IS

BEGIN
-- Versione              Autore Note
-- 'V1.0 del 04/03/2005'        Prima emissione
-- 'V2.0 del 06/04/2011'   KN   Riscritto pkg
-- 'V2.1 del 11/05/2012'   AM	DL 5/2012
-- 'V2.2 del 03/03/2014'   AM   procedure INS_GSDLOG
-- 'V2.3 del 22/10/2014    AM   eliminazione eventi aire (rif. CABA / KAIR)
-- 'V2.4 del 12/09/2017'   AM   delete elemov / elemla ('FR' o movimento sospeso)
-- 'V3.0 del 13/11/2019'   AM   nuova gestione pkg senza uso di codice RPF
-- 'V3.1 del 15/11/2019'   AM   gestito flag_ripristino anche per evento 1-4 reimmigrazione da aire (rif. Malnate)
-- 'V3.2 del 09/01/2020'   AM   (rif. v2.4) delete elemov / elemla anche x revisione diversa da FR, ma non aperta
-- 'V4.0 del 04/06/2026'   AM   controllo eventi successivi in riferimento al campo ID di ANAEVE
-- 'V4.1 del 06/08/2026'   AM   delete anasap: controllo data_evento per evitare eliminazione del doppio perfezioamento
--
   RETURN 'V4.1 del 06/08/2026';
END VERSIONE;

end;
/
