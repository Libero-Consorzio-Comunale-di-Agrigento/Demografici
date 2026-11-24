--liquibase formatted sql
--changeset amonopoli:202503101225_1 runOnChange:true stripComments:false
create or replace function f_ANA_get_anagrafe
(a_fascia_cod_mov	IN	number
)

return varchar2

IS

w_anagrafe	varchar2(255);

begin
  if a_fascia_cod_mov is not null then
     begin
       select decode(a_fascia_cod_mov, 
                1, 'RES', 
                2, 'RES', 
                3, 'AIR', 
                4, 'AIR', 
                5, 'AIS', 
                6, 'NRE',
               10, 'RES',
               11, 'RES',
               12, 'AIR',
               13, 'AIR',
               97, 'RES',
               98, 'AIR'
              ) 
         into w_anagrafe
         from dual
       ;
     exception
       when others then 
            w_anagrafe := '';
     end;
  end if;

  return w_anagrafe;

end;
/
