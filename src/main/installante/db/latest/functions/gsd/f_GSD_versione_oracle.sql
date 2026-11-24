--liquibase formatted sql
--changeset amonopoli:202305171651 runOnChange:true stripComments:false
create or replace function f_GSD_versione_oracle

return varchar

IS

w_versione	varchar2(255);

begin
  begin 
    select banner
      into w_versione
      from v$version
     where banner like 'Oracle%'
    ;
    if w_versione is not null then
       w_versione := ltrim(substr(w_versione,instr(w_versione,'Release')+7));
       w_versione := rtrim(substr(w_versione,1,instr(w_versione,' ')-1));
    end if;
  exception
    when others then 
         w_versione := sqlerrm;
  end;

  return w_versione;
end;
/
