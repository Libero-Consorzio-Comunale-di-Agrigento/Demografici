--liquibase formatted sql
--changeset vmigliore:202408021630_4 runOnChange:true stripComments:false
create or replace function f_ANSC_provincia_aire
(A_MATRICOLA		IN	NUMBER
,A_COD_PRO_RES		IN	NUMBER
,A_COD_COM_RES		IN	NUMBER
)

return varchar2

IS

w_flag_comune_estero	varchar2(255);

w_fascia_ana		number;

w_data_j		number;
w_cod_comune		varchar2(255);
w_cod_pro		number;
w_cod_com		number;

w_provincia		varchar2(255);

begin
  if a_matricola is not null then
     w_flag_comune_estero := f_flag_comune_estero(a_cod_pro_res,a_cod_com_res);

     if nvl(w_flag_comune_estero,'N') = 'S' then
        begin
          select fascia into w_fascia_ana
            from anaana
           where matricola = a_matricola
          ;
        exception
          when others then
               w_fascia_ana := '';
        end;

        if nvl(w_fascia_ana,0) = 3 then
           w_cod_comune := f_get_comune_cliente('COD_COMUNE');
        end if;
     end if;
  end if;

  if w_cod_comune is not null then
     w_cod_pro := substr(w_cod_comune,1,3);
     w_cod_com := substr(w_cod_comune,4,3);
     w_data_j  := to_char(trunc(sysdate),'j');
     w_provincia  := f_provincia_stato_al(w_cod_pro,w_cod_com,'','S','',w_data_j);
  end if;

  return w_provincia;
end;
/
