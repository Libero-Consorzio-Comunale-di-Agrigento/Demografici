--liquibase formatted sql
--changeset amonopoli:202305181137 runOnChange:true stripComments:false
create or replace function f_ANSC_id_comune_al
(A_COD_PROVINCIA                IN	NUMBER
,A_COD_COMUNE                   IN	NUMBER
,A_DATA                         IN	DATE
)

return varchar2

IS

w_data_j		number;
w_cod_comune		varchar2(255);

w_id_comune		number;

begin
  if a_cod_provincia||a_cod_comune is not null then
     w_data_j     := to_char(nvl(a_data,trunc(sysdate)),'j');
     w_cod_comune := f_ANPR_luogo(a_cod_provincia,a_cod_comune,w_data_j,2,2);
     begin
       select t.codice
         into w_id_comune
         from anpt03 t
        where codistat = w_cod_comune
          and w_data_j between data_istituzione_j and data_cessazione_j
          and rownum = 1
       ;
     exception
       when others then 
            w_id_comune := '';
     end;

     if w_id_comune is null then
        if a_cod_provincia < 201 or (a_cod_provincia in (701,702,703) and a_cod_comune >= 500) then
           w_id_comune := 0;
        end if;
     end if;

  end if;

  return w_id_comune;
end;
/
