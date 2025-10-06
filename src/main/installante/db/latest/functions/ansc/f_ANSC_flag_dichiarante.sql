--liquibase formatted sql
--changeset amonopoli:202303281250_1 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_dichiarante
(a_tipo_dichiarante	IN	varchar2
,a_codice		IN	varchar2
,a_tipo_avv     IN  varchar2 default null
)

return varchar2

IS

w_tipo_dichiarante	varchar2(255) := upper(a_tipo_dichiarante);
w_codice		varchar2(255) := upper(a_codice);

w_flag			varchar2(10);

begin
  if w_tipo_dichiarante is not null and w_codice is not null then
     w_flag := 'false';
     if instr(w_tipo_dichiarante,w_codice) > 0 then
        if nvl(a_tipo_avv, 'X') = 'AVV2' and w_tipo_dichiarante in ('SOSAAO', 'SAAO') then
            w_flag := 'false';
        else
            w_flag := 'true';
        end if;
     elsif w_codice in ('PD','MD') and w_tipo_dichiarante like '%EN%' then
        w_flag := 'true'; 
     elsif w_codice in ('C1','C2') and w_tipo_dichiarante like '%CI%' then
        w_flag := 'true'; 
     end if;

  elsif w_codice is not null then
     w_flag := 'false';

  end if;

  return w_flag;
end;
/



 