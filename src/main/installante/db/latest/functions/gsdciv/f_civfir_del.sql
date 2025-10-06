--liquibase formatted sql
--changeset amonopoli:202403111255 runOnChange:true stripComments:false
create or replace function f_civfir_del
(a_ID_ATTO		IN	varchar2
,a_COD_RUOLO		IN	varchar2
)

return number

IS

w_count_fir	number;

w_return	number;

begin
  w_return := 0;

--
-- stato_presa_visione_ansc
--
-- 0 = da visionare (DVI)
-- 1 = visionato (VIS)
-- 2 = annullato (ANN)
--

  begin
    delete civfir
     where id_atto               = a_id_atto
       and cod_ruolo             = a_cod_ruolo
       and (id_presa_visione_ansc is null
            or (id_presa_visione_ansc is not null and nvl(stato_presa_visione_ansc,-1) in (0,2))
           )
    ;
    if sql%found then
       w_return := 1;
    elsif sql%notFound then
       w_return := 0;
    end if;
  exception
    when others then
         w_return := -1;
  end;

  return w_return;
end;
/

