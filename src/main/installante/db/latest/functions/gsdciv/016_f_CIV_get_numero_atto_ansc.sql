--liquibase formatted sql
--changeset amonopoli:202310251700 runOnChange:true stripComments:false
create or replace function f_CIV_get_numero_atto_ansc
(a_tipo_atto		IN	number
,a_ufficio		IN   	number
,a_anno			IN	number
,a_parte		IN 	number
,a_serie		IN	varchar2
,a_atto			IN	number
)

return varchar2

IS

w_flag_ansc		varchar2(255) := f_flag_ANSC();

w_id_atto		varchar2(255);
w_numero_unico		number;
w_id_atto_ansc		varchar2(255);

w_numero_atto_ansc	varchar2(255);

begin
  if nvl(w_flag_ansc,'N') = 'S' and a_tipo_atto||a_ufficio||a_anno||a_parte||a_serie||a_atto is not null then
     if a_tipo_atto in (1,6) then
        w_id_atto := f_CIV_get_id_atto(1,a_ufficio,a_anno,a_parte,a_serie,a_atto);

        begin
          select numero_unico, id_atto_ansc
            into w_numero_unico, w_id_atto_ansc
            from civcit_v
           where id_atto = w_id_atto
             and rownum  = 1
          ;
        exception
          when others then
               w_id_atto_ansc := '';
        end;

     elsif a_tipo_atto = 2 then
        w_id_atto := f_CIV_get_id_atto(2,a_ufficio,a_anno,a_parte,a_serie,a_atto);

        begin
          select numero_unico, id_atto_ansc
            into w_numero_unico, w_id_atto_ansc
            from civnas_v
           where id_atto = w_id_atto
             and rownum  = 1
          ;
        exception
          when others then
               w_id_atto_ansc := '';
        end;

     elsif a_tipo_atto in (4,7,9) then
        w_id_atto := f_CIV_get_id_atto(4,a_ufficio,a_anno,a_parte,a_serie,a_atto);

        begin
          select numero_unico, id_atto_ansc
            into w_numero_unico, w_id_atto_ansc
            from civmat_v
           where id_atto = w_id_atto
             and rownum  = 1
          ;
        exception
          when others then
               w_id_atto_ansc := '';
        end;

     elsif a_tipo_atto in (-4,-7,-9) then
        w_id_atto := f_CIV_get_id_atto(-4,a_ufficio,a_anno,a_parte,a_serie,a_atto);

        begin
          select numero_unico, id_atto_ansc
            into w_numero_unico, w_id_atto_ansc
            from civuci_v
           where id_atto = w_id_atto
             and rownum  = 1
          ;
        exception
          when others then
               w_id_atto_ansc := '';
        end;


     elsif a_tipo_atto in (5,8) then
        w_id_atto := f_CIV_get_id_atto(5,a_ufficio,a_anno,a_parte,a_serie,a_atto);

        begin
          select numero_unico, id_atto_ansc
            into w_numero_unico, w_id_atto_ansc
            from civmor_v
           where id_atto = w_id_atto
             and rownum  = 1
          ;
        exception
          when others then
               w_id_atto_ansc := '';
        end;

     end if;
  end if;

  if w_numero_unico||w_id_atto_ansc is not null then
     w_numero_atto_ansc := f_CIV_numero_atto_ansc(w_id_atto_ansc,w_numero_unico);
  end if;

  return w_numero_atto_ansc;
end;
/