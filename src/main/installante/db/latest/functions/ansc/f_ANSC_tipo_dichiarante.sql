--liquibase formatted sql
--changeset amonopoli:202303291200 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_dichiarante
(a_tipo_dichiarante	IN	varchar2
,a_tipo_comparente	IN	varchar2
,a_tipo_atto		IN	number	default NULL
)

return varchar2

IS

w_tipo_dichiarante	varchar2(255) := upper(a_tipo_dichiarante);
w_tipo_comparente	varchar2(255) := upper(a_tipo_comparente);

w_return		varchar2(255);

begin
  if a_tipo_dichiarante is not null then
     if nvl(a_tipo_atto,0) = 4 then
        begin
          select id
            into w_return
            from anst52
           where tipo_dichiarante_ads = w_tipo_dichiarante
          ;
        exception
          when others then
               w_return := '';
        end;
     else
        begin
          select id
            into w_return
            from anst04
           where tipo_dichiarante_ads = w_tipo_dichiarante
             and f_ANSC_flag_comparente(w_tipo_comparente,tipo_comparente_ads) = 'true'
          ;
        exception
          when others then
               w_return := '';
        end;

        if w_return is null then
           begin
             select id
               into w_return
               from anst04
              where tipo_dichiarante_ads = w_tipo_dichiarante
                and tipo_comparente_ads is null 
             ;
           exception
             when others then
                  w_return := '';
           end;
        end if;
     end if;
  end if;

  return w_return;
end;
/
