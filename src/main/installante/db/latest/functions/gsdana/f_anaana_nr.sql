--liquibase formatted sql
--changeset amonopoli:202508061300 runOnChange:true stripComments:false
create or replace function F_ANAANA_NR
( a_id	IN	number
)

return number

IS

w_id	number;

begin
  if a_id is not null then
     w_id := a_id;

  elsif a_id is null then
     begin 
       select numero
         into w_id
         from anan01
        where cod_num = 'MAT'
       ;
     exception
       when no_data_found then
            w_id := 0;
            begin
              insert into anan01 (cod_num, numero)
              values ('MAT',0)
              ;
            end;
       when others then
            goto fine;
     end;
  end if;

  if w_id is not null then
     w_id := w_id + 1;
     begin
       update anan01
          set numero = w_id
        where cod_num = 'MAT'
       ;
     end;
  end if;

<< fine >>

  return w_id;

end;
/* End Procedure: F_ANAANA_NR */
/
