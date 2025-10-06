--liquibase formatted sql
--changeset amonopoli:202411191605_2 runOnChange:true stripComments:false
create or replace function F_DOMICILIO_DIGITALE
(a_matricola		IN	number)

return varchar2

IS

w_domicilio		varchar2(255);

begin
  if a_matricola is not null then
     begin
       select indirizzo_rec
         into w_domicilio
         from anaari_v
        where flag_domicilio_digitale = 'S'
          and matricola               = a_matricola
          and rownum = 1
       ;
     exception
       when others then
            w_domicilio := '';
     end;
  end if;
 
  return w_domicilio;
end;
/
