--liquibase formatted sql
--changeset vmigliore:202501200930 runOnChange:true stripComments:false
create or replace function f_CER_get_progr_emissione
(a_anno  IN number)

return number

IS

w_progr  number;

begin
  if a_anno is not null then
     begin
       select numero
         into w_progr
         from cern01 n01
        where anno = a_anno
       ;
     exception
       when no_data_found then
            begin
              insert into cern01 (anno, numero)
              values (a_anno, 0)
              ;
              w_progr := 0;
            exception
              when others then
                   w_progr := '';
            end;
       when others then
            w_progr := '';
     end;

     if w_progr is not null then
        w_progr := w_progr + 1;
        begin
          update cern01
             set numero = w_progr
           where anno = a_anno
           ;
        exception
          when others then
               w_progr := '';
        end;
     end if; --if w_progr is not null then
  end if;

  return w_progr;

end;
/