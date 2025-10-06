--liquibase formatted sql
--changeset amonopoli:202305181159 runOnChange:true stripComments:false
create or replace function f_ansciu_ins
(a_ID_OPERAZIONE	IN	number
,a_SERVIZIO		IN	varchar2
,a_ARCHIVIO_RIF		IN	varchar2
,a_ID_RIF		IN	varchar2
,a_NOTE			IN	varchar2
,a_TERMINALISTA		IN	varchar2
,a_DATA_REG		IN	date
,a_ID_ATTO		IN	varchar2	default null
)

return number

IS

w_id_operazione		number := a_id_operazione;
w_servizio		varchar2(255) := a_servizio;
w_archivio_rif		varchar2(255) := a_archivio_rif;
w_id_rif		varchar2(255) := a_id_rif;
w_note			varchar2(4000) := a_note;
w_terminalista		varchar2(255) := a_terminalista;
w_data_reg		date := a_data_reg;
w_id_atto		varchar2(255) := a_id_atto;

w_return		number;

begin
  w_return := 0;

  if a_servizio is not null and a_archivio_rif is not null and ( (a_servizio <> 'R008_R' and a_id_rif is not null) or (a_servizio = 'R008_R') ) then
     if w_id_operazione is not null then
        begin
          insert into ansciu
                 (id_operazione, servizio, archivio_rif, id_rif, note, terminalista, d_data_reg, id_atto)
          select w_id_operazione, w_servizio, w_archivio_rif, w_id_rif, w_note, w_terminalista, w_data_reg, w_id_atto
            from dual
           where not exists (select 1 from ansciu b
                              where b.id_operazione = w_id_operazione)
          ;
          if sql%notfound then
             begin
               update ansciu
                  set d_data_reg = sysdate
                where id_operazione = w_id_operazione
               ;
               w_return := 1;
             exception
               when others then
                    w_return := -1;
             end;
          else
             w_return := 1;
          end if;
        exception
          when others then
               w_return := -1;
        end;
     else
        begin
          insert into ansciu
                 (id_operazione, servizio, archivio_rif, id_rif, note, terminalista, d_data_reg, id_atto)
          values (w_id_operazione, w_servizio, w_archivio_rif, w_id_rif, w_note, w_terminalista, w_data_reg, w_id_atto)
          ;
          w_return := 1;
        exception
          when others then
               w_return := -1;
        end;
     end if;
  end if;

  return w_return;

end;
/
