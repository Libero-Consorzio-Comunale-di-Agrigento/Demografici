--liquibase formatted sql
--changeset amonopoli:202605221140_1 runOnChange:true stripComments:false
create or replace function f_ELEV_aggiorna_tabrep
(a_id_anatpr		IN	number		-- id della pratica (rif. anatpr)
,a_flag_ripristino	IN	varchar2	-- 'S' se la il check è attivo
,a_terminalista		IN	varchar2	-- codice di ad4 dell'utente in sessione
,a_motivo		IN	varchar2	-- motivo dell'eliminazione
,a_terminale		IN	varchar2	-- return della f_tabrep_terminale
)

return number
 
IS

w_evento		number;
w_data_eve_j		number;
w_pratica		number;
w_anno_pratica		number;

w_flag_ripristino	varchar2(1) := nvl(a_flag_ripristino,'N');

w_chiave		varchar2(255) := 'ELEV';
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
                 w_data_eve_j||
                 lpad(w_pratica,4,'0')||
                 w_anno_pratica||
                 w_flag_ripristino||
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
