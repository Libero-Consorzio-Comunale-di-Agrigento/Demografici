--liquibase formatted sql
--changeset amonopoli:202504011135_0 runOnChange:true stripComments:false
create or replace function f_ESC_descrizione_evento
(a_matricola      IN       number
,a_stato_civile   IN       varchar2
,a_data_div       IN       number
,a_data_div_ann   IN       number
)

return varchar2

IS

w_descrizione_eve          varchar2(255);

begin
  if a_stato_civile = 'CN' then
     w_descrizione_eve := 'Matrimonio';

  elsif a_stato_civile = 'VE' then
     W_descrizione_eve := 'Vedovanza';

  elsif a_stato_civile = 'UC' then
     w_descrizione_eve := 'Unione Civile';

  elsif a_stato_civile = 'VE' then
     w_descrizione_eve := 'Vedovanza da U.C.';

  elsif a_stato_civile in ('DV','GC') then 
     if a_data_div is not null then
        begin
          select tse.descrizione
            into w_descrizione_eve
            from anatse tse, anasen sen
           where tse.flag_divorzio        is not null
             and tse.cod_se               = sen.tipo_sentenza
             and sen.data_decreto	  in (a_data_div,a_data_div_ann)
             and sen.matricola 	          = a_matricola
             and rownum 		  = 1
          ;
          if instr(w_descrizione_eve,' ') > 0 then
             w_descrizione_eve := substr(w_descrizione_eve,1,instr(w_descrizione_eve,' ')-1);
          end if;
          w_descrizione_eve := initcap(w_descrizione_eve);
        exception
          when others then
--               w_descrizione_eve := 'Sci./Ces./Sep.';
               w_descrizione_eve := 'Sciogl./Cessaz.';
        end;
     else
--        w_descrizione_eve := 'Sci./Ces./Sep.';
        w_descrizione_eve := 'Sciogl./Cessaz.';
     end if;

  elsif a_stato_civile = 'GU' then 
     if a_data_div is not null then
        begin
          select tse.descrizione
            into w_descrizione_eve
            from anatse tse, anasen sen
           where tse.flag_divorzio        is not null
             and tse.cod_se               in (a_data_div,a_data_div_ann)
             and sen.data_decreto	  = a_data_div
             and sen.matricola 	          = a_matricola
             and rownum 		  = 1
          ;
          if instr(w_descrizione_eve,' ') > 0 then
             w_descrizione_eve := substr(w_descrizione_eve,1,instr(w_descrizione_eve,' ')-1);
          end if;
          w_descrizione_eve := initcap(w_descrizione_eve);
        exception
          when others then
--               w_descrizione_eve := 'Sci./Ces./Sep. da U.C.';
               w_descrizione_eve := 'Sciogl./Cessaz.';
        end;
     else
--        w_descrizione_eve := 'Sci./Ces./Sep. da U.C.';
        w_descrizione_eve := 'Sciogl./Cessaz.';
     end if;

  end if;
--or a_data_div||a_data_div_ann is null then

<< fine >>
null;

  return w_descrizione_eve;  
  
end;
/
