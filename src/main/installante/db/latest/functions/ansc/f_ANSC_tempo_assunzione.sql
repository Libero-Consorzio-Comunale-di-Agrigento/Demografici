--liquibase formatted sql
--changeset amonopoli:202307071535_3 runOnChange:true stripComments:false
create or replace function f_ANSC_tempo_assunzione
(a_tempo_impiego 		IN	varchar2
)

return varchar2

IS

w_testo			varchar2(4000);
w_tempo			varchar2(10);

begin
-- 1 - ha assunto pubblico impiego - AO
-- 2 - assumerà pubblico impiego - AA

  if a_tempo_impiego is null then
     goto fine;
  end if;

  begin
    select t45.id
      into w_tempo
      from anst45 t45
     where tempo_impiego_ads = a_tempo_impiego
       and rownum = 1
    ;
  exception
    when others then
         w_tempo := '';
  end;

<< fine >>

  return w_tempo;
end;
/
