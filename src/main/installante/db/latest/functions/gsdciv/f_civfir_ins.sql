--liquibase formatted sql
--changeset amonopoli:202402201420 runOnChange:true stripComments:false
create or replace function f_civfir_ins
(a_TIPO_ATTO		IN	number
,a_UFFICIO		IN	number
,a_ANNO			IN	number
,a_PARTE		IN	number
,a_SERIE		IN	varchar2
,a_ATTO			IN	number
,a_ID_ATTO		IN	varchar2
,a_COD_RUOLO		IN	varchar2
,a_COGNOME		IN	varchar2
,a_NOME			IN	varchar2
,a_DATA_NAS		IN	date
,a_SEQUENZA		IN	number
)

return number

IS

w_return	number;

begin
  w_return := 0;

  begin
    insert into civfir
           (TIPO_ATTO, UFFICIO, ANNO, PARTE, SERIE, ATTO, ID_ATTO, COD_RUOLO, COGNOME, NOME, D_DATA_NAS, SEQUENZA)
    select a_tipo_atto, a_ufficio, a_anno, a_parte, a_serie, a_atto, a_id_atto, a_cod_ruolo, a_cognome, a_nome, a_data_nas, a_sequenza
      from dual
     where not exists (select 'x' from civfir b
                        where b.id_atto   = a_id_atto
                          and b.cod_ruolo = a_cod_ruolo)
    ;
    if sql%found then
       w_return := 1;
    elsif sql%notFound then
       begin
         update civfir
            set cognome    = a_cognome
              , nome       = a_nome
              , d_data_nas = a_data_nas
          where id_atto   = a_id_atto
            and cod_ruolo = a_cod_ruolo
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
    end if;
  exception
    when others then
         w_return := -1;
  end;

  return w_return;
end;
/

