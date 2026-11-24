--liquibase formatted sql
--changeset amonopoli:202510081130 runOnChange:true stripComments:false
create or replace function f_GSD_get_campo_x_unicode
(a_tabella_rif	IN	varchar2
,a_id_rif  	IN	number
,a_campo_rif	IN	varchar2
)

return nvarchar2

IS

w_tabella_rif	varchar2(255) := upper(a_tabella_rif);
w_campo_rif	varchar2(255) := upper(a_campo_rif);

w_tipo_atto	number;
w_id_atto_rif	varchar2(255);

w_stringa       varchar2(2000);

begin
  if w_tabella_rif = 'CIVCIT' then
     w_tipo_atto := 1;

     begin
       select id_atto into w_id_atto_rif
         from civcit
        where id = a_id_rif
       ;
     exception
       when others then
            w_id_atto_rif := '';
     end;
     goto modulo_CIV;

  elsif w_tabella_rif = 'CIVNAS' then
     w_tipo_atto := 2;

     begin
       select id_atto into w_id_atto_rif
         from civnas
        where id = a_id_rif
       ;
     exception
       when others then
            w_id_atto_rif := '';
     end;
     goto modulo_CIV;

  elsif w_tabella_rif = 'CIVPUB' then
     w_tipo_atto := 3;

     begin
       select id_atto into w_id_atto_rif
         from civpub
        where id = a_id_rif
       ;
     exception
       when others then
            w_id_atto_rif := '';
     end;
     goto modulo_CIV;

  elsif w_tabella_rif = 'CIVMAT' then
     w_tipo_atto := 4;

     begin
       select id_atto into w_id_atto_rif
         from civmat
        where id = a_id_rif
       ;
     exception
       when others then
            w_id_atto_rif := '';
     end;
     goto modulo_CIV;

  elsif w_tabella_rif = 'CIVUCI' then
     w_tipo_atto := -4;

     begin
       select id_atto into w_id_atto_rif
         from civuci
        where id = a_id_rif
       ;
     exception
       when others then
            w_id_atto_rif := '';
     end;
     goto modulo_CIV;

  elsif w_tabella_rif = 'CIVMOR' then
     w_tipo_atto := 5;

     begin
       select id_atto into w_id_atto_rif
         from civmor
        where id = a_id_rif
       ;
     exception
       when others then
            w_id_atto_rif := '';
     end;
     goto modulo_CIV;

  elsif w_tabella_rif = 'ANAANA' then
     goto modulo_ANA;

  end if;

  goto fine;

<< modulo_CIV >>

  w_stringa := f_CIV_get_campo(w_tipo_atto, w_id_atto_rif, w_campo_rif);
  goto fine;

<< modulo_ANA >>
  w_stringa := f_get_campo_ANA(a_id_rif, w_campo_rif);
  goto fine;

<< fine >>

  return w_stringa;
end;
/
