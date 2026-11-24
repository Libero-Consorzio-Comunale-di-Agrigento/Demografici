--liquibase formatted sql
--changeset amonopoli:202512190840_1 runOnChange:true stripComments:false
create or replace function f_TPR_get_sequenza_SAP
(a_anagrafe		IN 	varchar2
,a_tipo_evento 		IN	varchar2
,a_anno_pratica 	IN 	number
,a_pratica 		IN	number
,a_evento_pratica 	IN 	number
)

return number

IS

w_anagrafe	varchar2(255) := upper(a_anagrafe);
w_tipo_evento	varchar2(255) := upper(a_tipo_evento);

w_sequenza 	number;

begin
  if a_anagrafe||a_tipo_evento||a_anno_pratica||a_pratica||a_evento_pratica is null then
     goto fine;
  end if;

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
    if w_sequenza is not null then
       w_sequenza := w_sequenza + 1;
    end if;
  exception
    when others then
         w_sequenza := '';
  end;

  if w_sequenza is null then
     begin
       select sequenza
         into w_sequenza
         from anadet
        where anagrafe       = w_anagrafe
          and tipo_evento    = w_tipo_evento
          and evento_pratica = a_evento_pratica
       ;
     exception
       when others then
            w_sequenza := '';
     end;
  end if;
  
<< fine >>
  
  return w_sequenza; 

end;
/
