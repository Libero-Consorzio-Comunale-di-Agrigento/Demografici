--liquibase formatted sql
--changeset amonopoli:202306261100 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_accordo
(a_tipo_divorzio 		IN	varchar2
,a_tipo_divorzio_altro 		IN	varchar2
,a_id_atto IN varchar2	default null
)

return varchar2

IS

w_tipo			varchar2(10);

begin
-- 1 - Accordo di separazione - X
-- 2 - Accordo di scioglimento del matrimonio - S
-- 3 - Cessazione degli effetti civili - C
-- 4 - Modifica delle condizioni di separazione	 - A - C
-- 5 - Modifica delle condizioni di scioglimento/cessazione effetti civili	 - A - D


  if a_tipo_divorzio||a_tipo_divorzio_altro is null then
     goto fine;
  end if;

  begin
    if a_tipo_divorzio = 'A' and a_tipo_divorzio_altro = 'M' then
      select t53.id
        into w_tipo
        from anst53 t53
       where tipo_divorzio_ads = (select tipo_divorzio
                                   from civdpa dpa
                                  where id_atto = a_id_atto);
    else
      select t53.id
        into w_tipo
        from anst53 t53
       where tipo_divorzio_ads                = a_tipo_divorzio
         and nvl(tipo_divorzio_altro_ads,' ') = nvl(a_tipo_divorzio_altro,' ')
         and rownum = 1
      ;
    end if;
  exception
    when others then
         w_tipo := '';
  end;

<< fine >>

  return w_tipo;
end;
/
