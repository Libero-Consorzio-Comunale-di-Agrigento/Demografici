--liquibase formatted sql
--changeset amonopoli:202504021205_2 runOnChange:true stripComments:false
create or replace function f_SEN_privacy
(a_matricola	in	number
,a_anno_progr	in	number
,a_numero_progr	in	number
)

return varchar2

IS

w_privacy	varchar2(255);

begin
  if a_matricola    is not null and
     a_anno_progr   is not null and
     a_numero_progr is not null
  then
     begin
       select privacy
         into w_privacy
         from anasen
        where matricola        = a_matricola
          and anno_progr_mov   = a_anno_progr
          and numero_progr_mov = a_numero_progr
          and rownum = 1
       ;
     exception
       when others then
            w_privacy := '';
     end;
  end if;

  return w_privacy;
end;
/
