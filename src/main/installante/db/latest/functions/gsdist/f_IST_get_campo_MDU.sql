--liquibase formatted sql
--changeset amonopoli:202503211120_2 runOnChange:true stripComments:false
create or replace function f_IST_get_campo_MDU
(a_id_atto		IN	varchar2
,a_campo		IN	varchar2
)

return varchar2

IS

w_campo			varchar2(255) := upper(a_campo);

w_regime_patrimoniale	varchar2(255);

w_return		varchar2(255);

begin
  if a_id_atto is not null and w_campo is not null then
     begin
       select decode(uci.convenzioni,'SI','2','1')
         into w_regime_patrimoniale
         from civuci uci
        where uci.id_atto = a_id_atto
       ;
     exception
       when others then
            w_return := '';
     end;

     if w_campo = 'REGIME_PATRIMONIALE' then
        w_return := w_regime_patrimoniale;
     else
        w_return := '';
     
     end if; --if w_campo =...
  end if; --if a_id_atto is not null and w_campo is not null then

  return w_return;

end;
/

