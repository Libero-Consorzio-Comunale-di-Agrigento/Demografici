--liquibase formatted sql
--changeset amonopoli:202301231557 runOnChange:true
create or replace function f_CIV_get_campo
(a_tipo_atto		IN	number
,a_id_atto		IN	varchar2
,a_campo		IN	varchar2
)

return varchar2

IS

w_campo		varchar2(255);

w_return	varchar2(4000);

begin
  if a_tipo_atto is not null and a_id_atto is not null and a_campo is not null then
     w_campo := upper(a_campo);

     if a_tipo_atto = 1 then
        begin
          select decode(w_campo,
                   'NATURA',cit.natura)
            into w_return
            from civcit cit
           where id_atto = a_id_atto
             and cod_rec in (0,3)
          ;
        exception
          when others then
               w_return := '';
        end;

     elsif a_tipo_atto = 2 then
        begin
          select decode(w_campo,
                   'DATA_NAS',to_char(nas.data_nas),
                   'NATURA'  ,nas.natura)
            into w_return
            from civnas nas
           where id_atto = a_id_atto
             and cod_rec in (0,3)
          ;
        exception
          when others then
               w_return := '';
        end;

     elsif a_tipo_atto = 3 then
        begin
          select decode(w_campo,
                   'DATA_NAS_M',to_char(pub.data_nas_m),
                   'DATA_NAS_F',to_char(pub.data_nas_f),
                   'NATURA'    ,pub.natura)
            into w_return
            from civpub pub
           where id_atto = a_id_atto
             and cod_rec in (0,3)
          ;
        exception
          when others then
               w_return := '';
        end;

     elsif a_tipo_atto = 4 then
        begin
          select decode(w_campo,
                   'DATA_NAS_M',to_char(mat.data_nas_m),
                   'DATA_NAS_F',to_char(mat.data_nas_f),
                   'NATURA'    ,mat.natura)
            into w_return
            from civmat mat
           where id_atto = a_id_atto
             and cod_rec in (0,3)
          ;
        exception
          when others then
               w_return := '';
        end;

     elsif a_tipo_atto = -4 then
        begin
          select decode(w_campo,
                   'DATA_NAS_M',to_char(uci.data_nas_m),
                   'DATA_NAS_F',to_char(uci.data_nas_f),
                   'NATURA'    ,uci.natura)
            into w_return
            from civuci uci
           where id_atto = a_id_atto
             and cod_rec in (0,3)
          ;
        exception
          when others then
               w_return := '';
        end;

     elsif a_tipo_atto = 5 then
        begin
          select decode(w_campo,
                   'DATA_NAS',to_char(mor.data_nas),
                   'NATURA'  ,mor.natura)
            into w_return
            from civmor mor
           where id_atto = a_id_atto
             and cod_rec in (0,3)
          ;
        exception
          when others then
               w_return := '';
        end;
     end if;
  end if;

  return w_return;
end;
/
