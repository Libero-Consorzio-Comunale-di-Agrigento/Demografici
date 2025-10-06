--liquibase formatted sql
--changeset amonopoli:202506121350 runOnChange:true stripComments:false
create or replace function f_stato_estero_al
(a_cod_provincia	IN	number
,a_cod_comune		IN	number
,a_data_rif		IN	number
)

return varchar2

IS

w_data_rif		number := nvl(a_data_rif,to_char(sysdate,'j'));
w_descrizione		varchar2(255);

begin
  if (a_cod_provincia >= 201 and a_cod_provincia not in (701,702,703))
     or (a_cod_provincia in (701,702,703) and a_cod_comune < 500)
  then
     begin
       select s.descrizione
         into w_descrizione
         from arcsta_storico s
        where s.cod_stato = a_cod_provincia
          and w_data_rif  between s.data_inizio_validita
                              and s.data_fine_validita
          and a_cod_provincia between 201 and 799
        ;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;

  return w_descrizione;

end;
/
