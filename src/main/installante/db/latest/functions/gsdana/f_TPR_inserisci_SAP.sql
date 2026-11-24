--liquibase formatted sql
--changeset amonopoli:202509291450 runOnChange:true stripComments:false
create or replace function f_TPR_inserisci_SAP
(a_anagrafe		IN	varchar2
,a_tipo_evento		IN	varchar
,a_anno_pratica		IN	number
,a_pratica		IN	number
,a_evento_pratica	IN	number
,a_terminalista		IN	varchar2
)

return number

IS

w_anagrafe	varchar2(255) := upper(a_anagrafe);
w_tipo_evento	varchar2(255) := upper(a_tipo_evento);

w_sequenza	number;

w_fase_log		varchar2(255) := 'ZK';
w_parametri_log		varchar2(2000);
w_note_log		varchar2(2000);
w_terminalista_log	varchar2(255) := a_terminalista;
w_operazione_log	varchar2(255);
w_return_log		number;

w_return	number;

begin
  w_return := 0;

  w_operazione_log := 'Avanzamento Pratica (zk)';
  w_parametri_log  := 'anagrafe: '||a_anagrafe||' - '|| 
                      'tipo_evento: '||a_tipo_evento||' - '||
                      'anno_pratica: '||a_anno_pratica||' - '||
                      'pratica: '||a_pratica||' - '||
                      'evento_pratica: '||a_evento_pratica;

  if a_anagrafe       is not null and
     a_tipo_evento    is not null and
     a_anno_pratica   is not null and
     a_pratica        is not null and
     a_evento_pratica is not null 
  then
     begin   
       select max(sequenza)
         into w_sequenza
         from anasap
        where anagrafe       = w_anagrafe
          and tipo_evento    = w_tipo_evento
          and anno_pratica   = a_anno_pratica
          and pratica        = a_pratica
          and evento_pratica = a_evento_pratica
       ;
     exception
       when others then
            w_sequenza := '';
     end;


     begin
       insert into anasap 
              (ANAGRAFE, TIPO_EVENTO, ANNO_PRATICA, PRATICA, 
               SEQUENZA, EVENTO_PRATICA, 
               DATA_EVENTO, TERMINALISTA, DATA_REG)
       select w_anagrafe, w_tipo_evento, a_anno_pratica, a_pratica, 
              decode(w_sequenza,'',min(det.sequenza), w_sequenza + 1),
              a_evento_pratica,
              to_char(sysdate,'j'),
              a_terminalista, 
              to_char(sysdate,'j') 
         from anadet det
        where det.anagrafe       = w_anagrafe
          and det.tipo_evento    = w_tipo_evento
          and det.evento_pratica = a_evento_pratica
          and not exists (select 'x'
                            from anasap b
                           where b.anagrafe       = w_anagrafe
                             and b.tipo_evento    = w_tipo_evento
                             and b.anno_pratica   = a_anno_pratica
                             and b.pratica        = a_pratica
                             and b.evento_pratica = a_evento_pratica
                             AND (a_evento_pratica = 8 
                                  or (a_evento_pratica != 8 and b.data_evento = to_char(sysdate,'j'))))
        group by det.anagrafe, det.tipo_evento, det.evento_pratica
       ;
       if sql%found then
          w_return := 1;
          w_operazione_log := '[inserito] '||w_operazione_log;
       elsif sql%notFound then
          w_return := 0;
          w_operazione_log := '[NON inserito] '||w_operazione_log;
       end if;
     exception
       when others then
            w_return := -1;
            w_operazione_log := '[errore] '||w_operazione_log||' ('||sqlerrm||')';
     end;
  end if; --if a_anagrafe       is not null and

  w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);

  return w_return;

end;
/
