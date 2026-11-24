--liquibase formatted sql
--changeset amonopoli:202606111410_2 runOnChange:true stripComments:false
CREATE OR REPLACE package body ANAAGEV is


PROCEDURE MAIN 
(sessione in varchar2
,w_messaggio_1 IN OUT varchar2
,w_messaggio_2 IN OUT varchar2
,w_messaggio_3 IN OUT varchar2
) 
is
w_errore                varchar2(255);
errore                  exception;


BEGIN
  rep_sessione := sessione;
  begin
    select substr(parametri,1,2),substr(parametri,3,7),
           to_number(substr(parametri,10,4)),to_number(substr(parametri,14,4)),
           to_number(ltrim(substr(parametri,18,4),'0')),
           to_number(ltrim(substr(parametri,22,4),'0')),
           to_number(ltrim(substr(parametri,26,3),'0')),
           to_number(ltrim(substr(parametri,29,3),'0')),
           to_number(ltrim(substr(parametri,32,7),'0')),
           to_number(ltrim(substr(parametri,39,3),'0')),
           to_number(ltrim(substr(parametri,42,3),'0')),
           rtrim(substr(parametri,45,8)),
           rtrim(substr(parametri,53))
      into p_evento,p_data_eve,p_pratica,p_anno_pratica,
           p_pratica_new,p_anno_pratica_new,p_cod_pro_eve_new,
           p_cod_com_eve_new,p_data_reg_new,
           p_cod_pro_iscr_aire_new,p_cod_com_iscr_aire_new,
           w_terminalista, w_note_par
      from tabrep
     where chiave    = 'AGEV'
       and terminale = rep_sessione --userenv('terminal')
    ;
  exception
    when no_data_found then
      w_errore := 'Errore in estrazione parametri ('||SQLERRM||')';
      raise errore;
    when others then
      w_errore := 'Errore in estrazione parametri ('||SQLERRM||')';
      raise errore;
  end;
  w_messaggio_1 := '';
  w_messaggio_2 := '';
  w_messaggio_3 := '';
  ANAAGEV.tr_main(w_messaggio_1,w_messaggio_2,w_messaggio_3);
end;  

PROCEDURE tr_main 
(w_messaggio_1 IN OUT varchar2
,w_messaggio_2 IN OUT varchar2
,w_messaggio_3 IN OUT varchar2
)
is
w_errore                varchar2(255);
errore                  exception;
begin
   w_messaggio_1 := 'Evento '||P_EVENTO;                                                   
   w_messaggio_1 := w_messaggio_1||chr(10)||'Data Evento '||to_char(to_date(P_DATA_EVE,'j'),'dd/mm/yyyy');                                            
   w_messaggio_1 := w_messaggio_1||chr(10)||'Pratica '||P_PRATICA||' - Anno Pratica '||P_ANNO_PRATICA;                                           
   if p_pratica_new is not null then
      w_messaggio_1 := w_messaggio_1||chr(10)||'Nuova Pratica '||P_PRATICA_NEW||' - Nuovo Anno Pratica '||P_ANNO_PRATICA_NEW;
   end if;
   if p_cod_pro_eve_new is not null then
      w_messaggio_1 := w_messaggio_1||chr(10)||'Nuovo Comune Evento - Cod.Pro. '||lpad(P_COD_PRO_EVE_NEW,3,'0')||' Cod.Com. '||lpad(P_COD_COM_EVE_NEW,3,'0');
   end if;
   if p_cod_pro_iscr_aire_new is not null then
      w_messaggio_1 := w_messaggio_1||chr(10)||'Nuovo Comune Iscrizione AIRE - Cod.Pro. '||lpad(P_COD_PRO_ISCR_AIRE_NEW,3,'0')||' Cod.Com. '||lpad(P_COD_COM_ISCR_AIRE_NEW,3,'0');
   end if;
   if p_data_reg_new is not null then
      w_messaggio_1 := w_messaggio_1||chr(10)||'Nuova Data Reg. '||to_char(to_date(P_DATA_REG_NEW,'j'),'dd/mm/yyyy');
   end if;

  w_trattamento := 9;
  for rec_mat in sel_dati_matricola loop
    if w_trattamento = 1 then
      exit;
    end if;
    begin
      select 0
        into w_trattamento
        from dual
       where not exists (select 'x'
                           from anaeve
                          where data_reg    > rec_mat.data_reg
                            and matricola    = rec_mat.matricola);
--    begin
--      select 0
--        into w_trattamento
--        from dual
--       where not exists (select 'x'
--                           from anaeve
--                          where cod_eve_pr   != rec_mat.cod_eve_pr
--                            and data_reg      = rec_mat.data_reg
--                            and matricola     = rec_mat.matricola);
        begin
          select 0
            into w_trattamento
            from dual
           where not exists (select 'x'
                               from anaeve
                              where data_reg   >= p_data_reg_new
                                and matricola      = rec_mat.matricola
             and (cod_eve_pr   != rec_mat.cod_eve_pr  or
                    data_eve     not in (p_data_eve,p_data_eve - 1) or
                     pratica             != p_pratica           or
                anno_pratica        != p_anno_pratica      or
                   matricola         != rec_mat.matricola))  ;
        exception
          when others then
               w_trattamento := 1;
        end;
--    exception
--      when others then
--           w_trattamento := 1;
--    end;
    exception
      when others then
           w_trattamento := 1;
    end;
    w_parametri_log := 'matricola: '||rec_mat.matricola||' - '||
                       'w_trattamento: '||w_trattamento;
    w_note_log := '';
    inserisci_gsdlog(w_fase_log,w_parametri_log,w_note_log,w_terminalista);

    if w_trattamento = 1 then
      exit;
    end if;
    w_matricola := rec_mat.matricola;
    w_data_reg  := rec_mat.data_reg;
    w_cod_eve   := rec_mat.cod_eve;
    w_cod_eve_pr := rec_mat.cod_eve_pr;
    r_cod_pro_eve_old  := rec_mat.cod_pro_eve_old;
    r_cod_com_eve_old  := rec_mat.cod_com_eve_old;
    r_cod_pro_iscr_aire_old := rec_mat.cod_pro_iscr_aire_old;
    r_cod_com_iscr_aire_old := rec_mat.cod_com_iscr_aire_old;
-- dbms_output.put_line('passa p1 '||w_matricola);
    ANAAGEV.UPD_ANAMOV;
    ANAAGEV.UPD_ANAEVE;
-- dbms_output.put_line('passa p2 '||rec_mat.cod_eve||'-'||rec_mat.cod_mov);
    if rec_mat.COD_EVE in (91,92) and rec_mat.COD_MOV in (10,11) then	/* update su eventi CABI */
      w_anagrafe	:= 'RES';
      w_tipo_evento := 'E';
        ANAAGEV.UPD_ANATPR;
        ANAAGEV.UPD_ANACRE;
        ANAAGEV.UPD_ANACRM;
        ANAAGEV.UPD_ANASAP_7;
        ANAAGEV.UPD_ANASAP;
    end if;
    if rec_mat.COD_MOV = 2 then				/* update su eventi CAPR */
-- dbms_output.put_line('PASSA PER Capr '||P_DATA_REG_NEW);
      w_anagrafe	:= 'RES';
      w_tipo_evento := 'C';
      ANAAGEV.UPD_ANATPR;
      w_conta_cp4 := 0;
      for rec_cp4 in sel_anacp4 loop
        w_cp4_anno_pratica := rec_cp4.cp4_anno_pratica;
        w_cp4_pratica      := rec_cp4.cp4_pratica;
        w_cp4_numero_dic   := rec_cp4.cp4_numero_dic;
        w_cp4_anno_dic     := rec_cp4.cp4_anno_dic;
        cp4_numero_dic_new := '';
-- dbms_output.put_line(w_cp4_anno_pratica||'-'||w_cp4_pratica||'-'||w_cp4_anno_dic||'-'||w_cp4_numero_dic);
        if p_pratica != nvl(p_pratica_new, p_pratica) then
          w_conta_cp4 := w_conta_cp4 + 1;
         if w_conta_cp4 > 1 and rec_cp4.cp4_numero_dic > 5000 then
           cp4_numero_dic_new := rec_cp4.cp4_numero_dic - rec_cp4.cp4_pratica + p_pratica_new;
         else
           cp4_numero_dic_new := p_pratica_new;
         end if;
       end if;
       ANAAGEV.UPD_ANACPM;
       ANAAGEV.UPD_ANACP4;
     end loop;
      ANAAGEV.UPD_ANASAP_7;
      ANAAGEV.UPD_ANASAP;
    end if;
    commit;
    if rec_mat.COD_MOV = 1 then				/* update su eventi IAPR */
-- dbms_output.put_line('PASSA PER iapr '||P_DATA_REG_NEW);
-- dbms_output.put_line(p_anno_pratica||'-'||p_pratica||'-'||p_pratica_new||'-'||p_anno_pratica_new);
      w_anagrafe	:= 'RES';
      w_tipo_evento := 'I';
      ANAAGEV.UPD_ANATPR_1;
      ANAAGEV.UPD_ANAAPM;
      ANAAGEV.UPD_ANAAP4;
      ANAAGEV.UPD_ANASAP_7;
      ANAAGEV.UPD_ANASAP_1;
    end if;
    commit;
    if rec_mat.cod_mov = 3 then  /* update su emigrazione aire*/
-- dbms_output.put_line('PASSA PER emigrazione aire');
      begin
        select a01.protocollo_aire
          into protocollo_aire
          from anaa01 a01
         where a01.anno_pratica = p_anno_pratica
           and a01.pratica      = p_pratica
           and ((a01.motivo     = 'C01' and
                   rec_mat.cod_eve       = 52)
                  or
                  (a01.motivo    != 'C01' and
                   rec_mat.cod_eve      != 52));
      exception
        when others then
          null;
      end;
      ANAAGEV.UPD_ANAA01;
      ANAAGEV.UPD_ANAA0M;
      if rec_mat.cod_eve = 52 then
-- dbms_output.put_line('2PASSA PER emigrazione aire');
        w_cp4_anno_pratica := p_anno_pratica;
        w_cp4_pratica      := p_pratica;
        w_cp4_numero_dic   := p_pratica;
        w_cp4_anno_dic     := p_anno_pratica;
        ANAAGEV.UPD_ANACPM;
        ANAAGEV.UPD_ANACP4;
      end if;
--      ANAAGEV.UPD_ANASAP_7;
      commit;
    else
      tratta_ana := 1;
      begin
        select 0
          into tratta_ana
          from anaana
         where matricola = rec_mat.matricola
           and data_reg  = rec_mat.data_reg;
      exception
        when others then
          tratta_ana := 1;
      end;
      if NVL(TRATTA_ANA,1) != 1 then
         ANAAGEV.UPD_ANAANA;
      end if;
    end if;
    commit;
  end loop;
  if NVL(W_TRATTAMENTO,1) NOT IN (0,1) then
      w_messaggio_2 := '*** Non esiste nessun evento relativo ai parametri indicati!';
  ELSIF NVL(W_TRATTAMENTO,1) = 0 then
      w_messaggio_2 := '*** Aggiornamento eventi terminato correttamente!';
  END IF;
-- dbms_output.put_line('prima gsdlog');
  anaagev.INS_GSDLOG;
  commit;
exception
  when errore then
       raise_application_error(-20999, w_errore);
       ROLLBACK;
  when others then
       raise_application_error(-20999, 'Errore in aggiornamento('||SQLERRM||')');
       ROLLBACK;
END;

procedure UPD_ANAMOV is
begin
        update anamov
           set pratica            = nvl(p_pratica_new,pratica),
               anno_pratica       = nvl(p_anno_pratica_new,anno_pratica),
               cod_pro_eve        = nvl(p_cod_pro_eve_new,cod_pro_eve),
               cod_com_eve        = nvl(p_cod_com_eve_new,cod_com_eve),
               cod_pro_iscr_aire  = nvl(p_cod_pro_iscr_aire_new,cod_pro_iscr_aire),
               cod_com_iscr_aire  = nvl(p_cod_com_iscr_aire_new,cod_com_iscr_aire),
               data_reg           = nvl(p_data_reg_new,data_reg)
         where cod_eve                          = w_cod_eve
           and data_eve                         = p_data_eve
           and nvl(pratica,p_pratica)           = p_pratica
           and nvl(anno_pratica,p_anno_pratica) = p_anno_pratica
           and matricola                        = w_matricola
           and data_reg                         = w_data_reg
;
w_parametri_log := 'cod_eve: '||w_cod_eve||' - '||
                   'matricola: '||w_matricola||' - '||
                   'pratica_old: '||p_pratica||' - '||
                   'anno_pratica_old: '||p_anno_pratica||' - '||
                   'data_eve_old: '||p_data_eve||' - '||
                   'data_reg_old: '||w_data_reg;
if sql%found then
   w_note_log      := 'aggiornamento anamov eseguito';
elsif sql%found then
   w_note_log      := 'aggiornamento NON anamov eseguito';
end if;

inserisci_gsdlog(w_fase_log,w_parametri_log,w_note_log,w_terminalista);

end;
procedure UPD_ANAEVE is
begin
        update anaeve
           set pratica           = nvl(p_pratica_new,pratica),
               anno_pratica      = nvl(p_anno_pratica_new,anno_pratica),
               cod_pro_eve       = decode(cod_pro_eve,'','',
                                     nvl(p_cod_pro_eve_new,cod_pro_eve)),
               cod_com_eve       = decode(cod_com_eve,'','',
                                     nvl(p_cod_com_eve_new,cod_com_eve)),
               cod_pro_iscr_aire = decode(cod_pro_iscr_aire,'','',
                                     nvl(p_cod_pro_iscr_aire_new,cod_pro_iscr_aire)),
               cod_com_iscr_aire = decode(cod_com_iscr_aire,'','',
                                     nvl(p_cod_com_iscr_aire_new,cod_com_iscr_aire)),
               data_reg          = nvl(p_data_reg_new,data_reg)
         where cod_eve_pr   = w_cod_eve_pr
           and data_eve     in (p_data_eve,p_data_eve - 1)
           and pratica      = p_pratica
           and anno_pratica = p_anno_pratica
           and matricola    = w_matricola
;

w_parametri_log := 'cod_eve_pr: '||w_cod_eve_pr||' - '||
                   'matricola: '||w_matricola||' - '||
                   'pratica_old: '||p_pratica||' - '||
                   'anno_pratica_old: '||p_anno_pratica||' - '||
                   'data_eve_old: '||p_data_eve;
if sql%found then
   w_note_log      := 'aggiornamento anaeve eseguito';
elsif sql%found then
   w_note_log      := 'aggiornamento NON anaeve eseguito';
end if;

inserisci_gsdlog(w_fase_log,w_parametri_log,w_note_log,w_terminalista);
end;
procedure UPD_ANATPR is
begin
        update anatpr
           set pratica 		= nvl(p_pratica_new, pratica),
	       anno_pratica  	= nvl(p_anno_pratica_new, anno_pratica)
         where anno_pratica 	= p_anno_pratica
           and pratica 		= p_pratica
           and data_pratica  	= p_data_eve
	   and anagrafe		= w_anagrafe
	   and tipo_evento	= w_tipo_evento
           and not exists (select 'x'
                             from anatpr b
                            where b.pratica 	= nvl(p_pratica_new, b.pratica)
                              and b.anno_pratica= nvl(p_anno_pratica_new, b.anno_pratica)
			      and b.anagrafe	= w_anagrafe
			      and b.tipo_evento	= w_tipo_evento)
;
end;

procedure UPD_ANATPR_1 is
begin
        update anatpr
           set pratica 		= nvl(p_pratica_new, pratica),
	       anno_pratica  	= nvl(p_anno_pratica_new, anno_pratica)
         where anno_pratica 	= p_anno_pratica
           and pratica 		= p_pratica
           and data_pratica  	= p_data_eve
	   and anagrafe		= w_anagrafe
	   and tipo_evento	= w_tipo_evento
	   and exists (select 'x'
			 from anaap4 a
			where a.anno_pratica	= a.anno_dic
			  and a.pratica		= a.numero_dic
			  and a.anno_dic	= anatpr.anno_pratica
			  and a.numero_dic	= anatpr.pratica)
           and not exists (select 'x'
                             from anatpr b
                            where b.pratica 	= nvl(p_pratica_new, b.pratica)
                              and b.anno_pratica= nvl(p_anno_pratica_new, b.anno_pratica)
			      and b.anagrafe	= w_anagrafe
			      and b.tipo_evento	= w_tipo_evento)
;
end;
procedure UPD_ANACRE is
begin
      update anacre
         set pratica 		= nvl(p_pratica_new, pratica),
	     anno_pratica 	= nvl(p_anno_pratica_new, anno_pratica)
       where anno_pratica 	= p_anno_pratica
         and pratica 		= p_pratica
         and not exists (select 'x'
                           from anacre b
                          where b.pratica 	= nvl(p_pratica_new, b.pratica)
                            and b.anno_pratica 	= nvl(p_anno_pratica_new, b.anno_pratica))
;
end;

procedure UPD_ANACRM is
begin
	update anacrm
	   set pratica 		= nvl(p_pratica_new, pratica),
	       anno_pratica 	= nvl(p_anno_pratica_new, anno_pratica)
	 where anno_pratica 	= p_anno_pratica
	   and pratica 		= p_pratica
	   and not exists (select 'x'
          	             from anacrm b
                  	    where b.pratica 	= nvl(p_pratica_new, b.pratica)
	                      and b.anno_pratica= nvl(p_anno_pratica_new, b.anno_pratica))
;
end;
procedure UPD_ANASAP is
begin
	update anasap
	   set pratica 		= nvl(p_pratica_new, pratica),
	       anno_pratica 	= nvl(p_anno_pratica_new, anno_pratica)
	 where anno_pratica 	= p_anno_pratica
	   and pratica 		= p_pratica
	   and anagrafe		= w_anagrafe
	   and tipo_evento	= w_tipo_evento
	   and not exists (select 'x'
        	             from anasap b
                	    where b.pratica 	= nvl(p_pratica_new, b.pratica)
                      	      and b.anno_pratica= nvl(p_anno_pratica_new, b.anno_pratica)
			      and b.anagrafe	= w_anagrafe
			      and b.tipo_evento	= w_tipo_evento)
;
end;

procedure UPD_ANASAP_7 is
begin
	update anasap
	   set data_evento      = nvl(p_data_reg_new,data_evento)
	 where anno_pratica 	= p_anno_pratica
	   and pratica 		= p_pratica
	   and anagrafe		= w_anagrafe
	   and tipo_evento	= w_tipo_evento
	   and evento_pratica   = 7
;
end;

procedure UPD_ANASAP_1 is
begin
	update anasap
	   set pratica 		= nvl(p_pratica_new, pratica),
	       anno_pratica 	= nvl(p_anno_pratica_new, anno_pratica)
	 where anno_pratica 	= p_anno_pratica
	   and pratica 		= p_pratica
	   and anagrafe		= w_anagrafe
	   and tipo_evento	= w_tipo_evento
	   and exists (select 'x'
			 from anaap4 a
			where a.anno_pratica	= a.anno_dic
			  and a.pratica		= a.numero_dic
			  and a.anno_dic	= anasap.anno_pratica
			  and a.numero_dic	= anasap.pratica)
	   and not exists (select 'x'
        	             from anasap b
                	    where b.pratica 	= nvl(p_pratica_new, b.pratica)
                      	      and b.anno_pratica= nvl(p_anno_pratica_new, b.anno_pratica)
			      and b.anagrafe	= w_anagrafe
			      and b.tipo_evento	= w_tipo_evento)
;
end;
procedure UPD_ANAAPM is
begin
	update anaapm
	   set anno_dic 	= nvl(p_anno_pratica_new, anno_dic),
	       numero_dic 	= nvl(p_pratica_new, numero_dic)
         where anno_dic 	= nvl(p_anno_pratica, anno_dic)
           and numero_dic 	= nvl(p_pratica, numero_dic)
	   and exists (select 'x'
			 from anaap4 a
			where a.anno_pratica	= a.anno_dic
			  and a.pratica		= a.numero_dic
			  and a.anno_dic	= anaapm.anno_dic
			  and a.numero_dic	= anaapm.numero_dic)
           and not exists (select 'x'
                             from anaapm b
                            where b.numero_dic 	= nvl(p_pratica_new, b.numero_dic)
                              and b.anno_dic 	= nvl(p_anno_pratica_new, b.anno_dic))
;
end;

procedure UPD_ANAAP4 is
begin
	update anaap4
	   set pratica 		= nvl(p_pratica_new, pratica),
 	       anno_pratica 	= nvl(p_anno_pratica_new, anno_pratica),
               anno_dic 	= decode(anno_dic,p_anno_pratica,nvl(p_anno_pratica_new,anno_dic),anno_dic),
               numero_dic 	= decode(numero_dic,p_pratica,nvl(p_pratica_new,numero_dic),numero_dic),
	       cod_pro_eve	= nvl(p_cod_pro_eve_new, cod_pro_eve),
	       cod_com_eve	= nvl(p_cod_com_eve_new, cod_com_eve),
	       cod_pro_iscr_aire= nvl(p_cod_pro_iscr_aire_new, cod_pro_iscr_aire),
	       cod_com_iscr_aire= nvl(p_cod_com_iscr_aire_new, cod_com_iscr_aire),
              -- data_reg          = nvl(p_data_reg_new,data_reg),
               data_definizione = decode(data_definizione,w_data_reg,nvl(p_data_reg_new,data_definizione),data_definizione)
         where anno_pratica 	= p_anno_pratica
           and pratica 		= p_pratica
           and (((p_anno_pratica != p_anno_pratica_new and p_pratica!= p_pratica_new) 
                 and not exists (select 'x'
                                   from anaap4 b
                                  where b.pratica     = nvl(p_pratica_new, b.pratica)
                                    and b.anno_pratica= nvl(p_anno_pratica_new, b.anno_pratica)))
                or (p_pratica = p_pratica_new and 
                    p_anno_pratica = p_anno_pratica_new)) 
;
end;
procedure UPD_ANACPM is
begin
	update anacpm
	   set anno_dic 	= nvl(p_anno_pratica_new, anno_dic),
               numero_dic 	= nvl(cp4_numero_dic_new, numero_dic)
         where anno_dic 	= w_cp4_anno_dic
           and numero_dic 	= w_cp4_numero_dic
;
end;
procedure UPD_ANACP4 is
begin
	update anacp4
	   set pratica 		= nvl(p_pratica_new, pratica),
               anno_pratica 	= nvl(p_anno_pratica_new, anno_pratica),
               anno_dic 	= nvl(p_anno_pratica_new, anno_dic),
               numero_dic 	= nvl(cp4_numero_dic_new, numero_dic),
	       cod_pro_eve	= nvl(p_cod_pro_eve_new, cod_pro_eve),
	       cod_com_eve	= nvl(p_cod_com_eve_new, cod_com_eve),
              -- data_reg         = nvl(p_data_reg_new,data_reg),
               data_definizione = decode(data_definizione,w_data_reg,nvl(p_data_reg_new,data_definizione),data_definizione)
         where anno_pratica 	= w_cp4_anno_pratica
           and pratica 		= w_cp4_pratica
	   and anno_dic		= w_cp4_anno_dic
  	   and numero_dic	= w_cp4_numero_dic
;
end;
procedure UPD_ANAA01 is
begin
        update anaa01
           set pratica             = nvl(p_pratica_new,pratica),
               anno_pratica        = nvl(p_anno_pratica_new,anno_pratica),
               data_definizione    = decode(data_definizione,w_data_reg,nvl(p_data_reg_new,data_definizione),data_definizione)
         where anno_pratica        = p_anno_pratica
           and protocollo_aire     = protocollo_aire
;
end;

procedure UPD_ANAA0M is
begin
        update anaa0m
           set pratica                = nvl(p_pratica_new,pratica),
               anno_pratica        = nvl(p_anno_pratica_new,anno_pratica)
         where anno_pratica        = p_anno_pratica
           and protocollo_aire        = protocollo_aire
;
end;

procedure UPD_ANAANA is
begin
        update anaana
           set data_reg          = nvl(p_data_reg_new,data_reg)
         where matricola  = w_matricola
;
end;

procedure INS_GSDLOG is
w_des_evento	varchar2(255);
w_parametri		varchar2(2000);
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

  begin
    select 'pratica: '||nvl(p_pratica_new,p_pratica)||'/'||nvl(p_anno_pratica_new,p_anno_pratica)||      
           ' - evento_ric: '||p_evento||' ('||w_des_evento||')'||
           ' - data_evento_ric: '||to_char(to_date(p_data_eve,'j'),'dd/mm/yyyy')||
           ' - pratica_ric: '||p_pratica||
           ' - anno_pratica_ric: '||p_anno_pratica||
           decode(p_pratica_new,'','',
             ' - pratica_new :'||p_pratica_new||' (old: '||p_pratica||')')||
           decode(p_anno_pratica_new,'','',
             ' - anno_pratica_new: '||p_anno_pratica_new||' (old: '||p_anno_pratica||')')||
           decode(p_cod_pro_eve_new,'','',
             ' - cod_pro_eve_new: '||p_cod_pro_eve_new||' (old: '||r_cod_pro_eve_old||')')||
           decode(p_cod_pro_eve_new,'','',
             ' - cod_com_eve_new: '||p_cod_com_eve_new||' (old: '||r_cod_com_eve_old||')')||
           decode(p_data_reg_new,'','',
             ' - data_reg_new: '||to_char(to_date(p_data_reg_new,'j'),'dd/mm/yyyy')||
             ' (old: '||to_char(to_date(w_data_reg,'j'),'dd/mm/yyyy')||')')||
           decode(p_cod_pro_iscr_aire_new,'','',
             ' - cod_pro_iscr_aire_new: '||p_cod_pro_iscr_aire_new||
             ' (old: '||r_cod_pro_iscr_aire_old||')')||
           decode(p_cod_com_iscr_aire_new,'','',
             ' - cod_com_iscr_aire_new: '||p_cod_com_iscr_aire_new||
             ' (old: '||r_cod_com_iscr_aire_old||')')
      into w_parametri
      from dual
    ;
  exception
    when others then 
         w_parametri := 'pratica: '||nvl(p_pratica_new,p_pratica)||'/'||nvl(p_anno_pratica_new,p_anno_pratica)||
                        ' - errore: '||SQLERRM;
  end;

  inserisci_gsdlog('AGEV', w_parametri, w_note_par, w_terminalista);
end;

FUNCTION VERSIONE  
RETURN varchar2 

IS

BEGIN
-- Versione              Autore Note
-- 'V3.0 del 13/11/2019'   AM   nuova gestione pkg senza uso di codice RPF
   RETURN 'V3.0 del 13/11/2019';
END VERSIONE;

END ANAAGEV;
/
