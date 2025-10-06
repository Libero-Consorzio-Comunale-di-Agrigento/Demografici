--liquibase formatted sql
--changeset vmigliore:202408021630_1 runOnChange:true stripComments:false
create or replace function f_ANSC_id_comune_aire
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

w_id_comune		number;

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
     w_data_j     := to_char(trunc(sysdate),'j');
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
  end if;

  return w_id_comune;
end;
/
