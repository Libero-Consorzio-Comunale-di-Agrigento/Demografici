--liquibase formatted sql
--changeset amonopoli:202312291415_1 runOnChange:true stripComments:false
create or replace function f_IST_cod_tribunale
(a_cod_pro	IN	number
,a_cod_com	IN	number
)

return varchar2

IS

w_codice	varchar2(255);

begin
  if a_cod_pro||a_cod_com is not null then
     begin
       select cod_tribunale
         into w_codice
         from arctri 
        where cod_pro_trib = a_cod_pro
          and cod_com_trib = a_cod_com
          and rownum = 1
       ;
     exception
       when others then
            w_codice := '';
     end;
  end if;

  return w_codice;

end;
/
