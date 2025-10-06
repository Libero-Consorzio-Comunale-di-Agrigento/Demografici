--liquibase formatted sql
--changeset amonopoli:202309131625 runOnChange:true stripComments:false
create or replace function f_CIV_init_parto_plurimo
(a_ufficio        IN       number
,a_anno           IN       number
,a_parte          IN       number
,a_serie          IN       varchar2
,a_atto           IN       number
,a_num_gemello    IN       number
,a_tot_gemelli    IN       number
)

return number

IS

w_atto 		  number;
w_id_atto         varchar2(25);

w_numero_unico    number;
w_numero_unico_pr number;

w_ufficio_pr      number;
w_anno_pr         number;
w_parte_pr        number;
w_serie_pr        varchar2(1);
w_atto_pr         number;
w_id_atto_pr      varchar2(25);

w_return          number;

begin
  w_return := 0;
  if a_ufficio||a_anno||a_parte||a_serie||a_atto is not null and nvl(a_num_gemello,0) > 0 and nvl(a_tot_gemelli,0) > 1 then
     if a_num_gemello = 1 then
        for i in 1..a_tot_gemelli loop
            w_numero_unico := f_CIV_numero_unico(a_anno,'N');
            w_atto         := a_atto + i - 1;
            w_id_atto      := f_CIV_get_id_atto(2,a_ufficio,a_anno,a_parte,a_serie,w_atto);
            if i = 1 then
               w_ufficio_pr      := a_ufficio;
               w_anno_pr         := a_anno;
               w_parte_pr        := a_parte;
               w_serie_pr        := a_serie;
               w_atto_pr         := a_atto;
               w_id_atto_pr      := w_id_atto;
               w_numero_unico_pr := w_numero_unico;
            end if;
            begin
              insert into civnas_plurimo
                     (UFFICIO, ANNO, PARTE, SERIE, ATTO, ID_ATTO, NUMERO_UNICO,
                      NUM_GEMELLO, TOT_GEMELLI, 
                      UFFICIO_PR, ANNO_PR, PARTE_PR, SERIE_PR, ATTO_PR, ID_ATTO_PR, NUMERO_UNICO_PR)
              values (a_ufficio, a_anno, a_parte, a_serie, w_atto, w_id_atto, w_numero_unico,
                      i, a_tot_gemelli, 
                      w_ufficio_pr, w_anno_pr, w_parte_pr, w_serie_pr, w_atto_pr, w_id_atto_pr, w_numero_unico_pr)
              ;
              if sql%found then
                 w_return := 1;
              end if;
            exception
              when others then 
                   w_return := 0;
            end;
        end loop;
     end if;
  end if;
  
  return w_return;
exception
  when others then
       w_return := -1;
       return w_return;  
end;
/
