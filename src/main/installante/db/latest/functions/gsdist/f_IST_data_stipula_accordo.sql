--liquibase formatted sql
--changeset amonopoli:202312291415_1 runOnChange:true stripComments:false
create or replace function f_IST_data_stipula_accordo
(a_tipo_atto	IN	number
,a_id_atto	IN	varchar2
,a_cod_modello	IN	varchar2
)

return date

IS

w_data		date;

begin
  if a_tipo_atto||a_id_atto||a_cod_modello is not null then
     if a_tipo_atto = 4 and a_cod_modello in ('6SD','12SD') 
        or a_tipo_atto = -4 and a_cod_modello in ('6SU','12SU') 
     then
        begin
          select d_accordo_data
            into w_data
            from civdpa 
           where id_atto = a_id_atto
          ;
        exception
          when others then
               w_data := '';
        end;
     end if;
  end if;

  return w_data;

end;
/
