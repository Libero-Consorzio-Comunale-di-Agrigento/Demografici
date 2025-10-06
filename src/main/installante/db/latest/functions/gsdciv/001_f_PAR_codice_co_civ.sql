--liquibase formatted sql
--changeset snocca:202211251317 runOnChange:true
create or replace function f_PAR_codice_co_civ
(a_fase		IN	varchar2
,a_funzione	IN	varchar2
)

return varchar2

IS

w_codice_co		varchar2(255);

begin
  if a_fase||a_funzione is not null then
     if a_fase = 'SCPW' then
        w_codice_co := substr(a_funzione,3,2);
        w_codice_co := lpad(w_codice_co,2,'0');
     end if;
     
     if translate(w_codice_co,'0123456789','9999999999') not in ('9','99') then
        w_codice_co := '';
     end if;
  end if;
 
  return w_codice_co;

end;
/
