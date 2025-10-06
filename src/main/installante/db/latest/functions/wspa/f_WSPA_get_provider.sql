--liquibase formatted sql
--changeset amonopoli:202501150925 runOnChange:true stripComments:false
create or replace function f_WSPA_get_provider

return varchar2

IS

w_wspa_inp	varchar2(255) := f_valore_inp('WSPA',1,20,'X','S');

w_nextstep	varchar2(255);
w_depag		varchar2(255);

w_return	varchar2(255);

begin
  w_return := '';

  if nvl(w_wspa_inp,'N') not in ('N','S') then
     w_return := w_wspa_inp;
     goto fine;
  end if;

  w_nextstep := f_valore_inp('NEXT_URL',1,255,'X','S');
  if nvl(w_nextstep,'N') like 'HTTP%' then
     w_return := 'NEXTSTEP';
     goto fine;
  end if;
  
  w_depag    := f_valore_inp('DEPAG_URL',1,255,'X','S');
  if nvl(w_depag,'N') like 'HTTP%' then
     w_return := 'DEPAG';
     goto fine;
  end if;

  w_return := 'DEPAG';

<< fine >>
  return w_return;

end;
/
