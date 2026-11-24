--liquibase formatted sql
--changeset amonopoli:202605221210_1 runOnChange:true stripComments:false
create or replace function f_AGEV_aggiorna_tabrep
(a_id_anatpr			IN	number		-- id della pratica (rif. anatpr)
,a_pratica_new			IN	number		-- nuovi valori: numero della pratica
,a_anno_pratica_new		IN	number		-- nuovi valori: anno della pratica
,a_cod_pro_eve_new		IN	number		-- nuovi valori: cod_pro dell'evento
,a_cod_com_eve_new		IN	number		-- nuovi valori: cod_com dell'evento
,a_data_reg_new			IN	varchar2	-- nuovi valori: data di registrazione (yyyy-mm-dd)
,a_cod_pro_iscr_aire_new	IN	number		-- nuovi valori: cod_pro del comune iscr. aire
,a_cod_com_iscr_aire_new	IN	number		-- nuovi valori: cod_com del comune iscr. aire
,a_terminalista			IN	varchar2	-- codice di ad4 dell'utente in sessione
,a_motivo			IN	varchar2	-- motivo dell'eliminazione
,a_terminale			IN	varchar2	-- return della f_tabrep_terminale
)

return number
 
IS

w_evento		number;
w_data_eve_j		number;
w_pratica		number;
w_anno_pratica		number;

w_data_reg_new_j	number := to_char(to_date(a_data_reg_new,'yyyy-mm-dd'),'j');

w_chiave		varchar2(255) := 'AGEV';
w_terminale		varchar2(255) := a_terminale;
w_parametri		varchar2(2000);

w_return		number := 0;

begin
  begin
    select dce.cod_eve, 
           to_char(nvl(tpr.d_data_decorrenza,tpr.d_data_pratica),'j'),
           tpr.pratica, 
           tpr.anno_pratica
      into w_evento, w_data_eve_j, w_pratica, w_anno_pratica
      from anadce dce, anatpr tpr
     where nvl(dce.tipo_evento_tpr,' ') = nvl(tpr.cod_variazione,' ')
       and dce.tipo_evento              = tpr.tipo_evento
       and dce.anagrafe                 = tpr.anagrafe
       and dce.flag_tpr                 = 'S'
       and tpr.id                       = a_id_anatpr
    ;
  exception
    when others then
         w_return := -1;
         goto fine;
  end;

  w_parametri := lpad(w_evento,2,'0')||
                 to_char(w_data_eve_j)||
                 lpad(w_pratica,4,'0')||
                 lpad(w_anno_pratica,4,'0')||
                 lpad(nvl(a_pratica_new,0),4,'0')||
                 lpad(nvl(a_anno_pratica_new,0),4,'0')||
                 lpad(nvl(a_cod_pro_eve_new,0),3,'0')||
                 lpad(nvl(a_cod_com_eve_new,0),3,'0')||
                 lpad(nvl(w_data_reg_new_j,0),7,'0')||
                 lpad(nvl(a_cod_pro_iscr_aire_new,0),3,'0')||
                 lpad(nvl(a_cod_com_iscr_aire_new,0),3,'0')||
                 rpad(a_terminalista,8,' ')||
                 a_motivo;

  begin
    insert into tabrep (chiave, parametri, terminale)
    select w_chiave, w_parametri, w_terminale
      from dual
     where not exists (select 1 from tabrep b
                        where chiave    = w_chiave
                          and terminale = w_terminale)
    ;
    w_return := 1;
    if sql%notfound then
       w_return := 0;
       begin
         update tabrep
            set parametri = w_parametri
          where chiave    = w_chiave
            and terminale = w_terminale
         ;
         w_return := 1;
       exception
         when others then
              w_return := -1;
       end;
    end if;
  exception
    when others then
         w_return := -1;
  end;

<< fine >>

  return w_return;

end;
/
