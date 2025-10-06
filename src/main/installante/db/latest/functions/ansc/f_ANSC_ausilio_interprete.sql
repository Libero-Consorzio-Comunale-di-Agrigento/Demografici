--liquibase formatted sql
--changeset amonopoli:202303281250_4 runOnChange:true stripComments:false
create or replace function f_ANSC_ausilio_interprete
(a_tipo_comparente	IN	varchar2
)

return varchar2

IS

w_tipo_comparente	varchar2(255) := upper(a_tipo_comparente);
w_codice		varchar2(255) := 'IT';

w_flag			varchar2(10);

begin
  if w_tipo_comparente is not null and w_codice is not null then
     w_flag := 'false';
     if instr(w_tipo_comparente,w_codice) > 0 then
        w_flag := 'true'; 
     end if;
  end if;

  return w_flag;
end;
/
