--liquibase formatted sql
--changeset amonopoli:202305181145 runOnChange:true stripComments:false
create or replace function f_ANSC_stringa
(a_stringa	IN	varchar2
,a_non_ammessi	IN	varchar2 default NULL
)

return varchar2

IS

w_stringa		varchar2(4000) := a_stringa;

begin
  if nvl(a_non_ammessi,' ') = '()' then
     w_stringa := replace(replace(w_stringa,'(',''),')','');
  end if;

  return w_stringa;

end;
/
