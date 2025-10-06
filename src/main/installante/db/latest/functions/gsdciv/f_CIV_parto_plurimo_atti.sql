--liquibase formatted sql
--changeset amonopoli:202309141045 runOnChange:true stripComments:false
create or replace function f_CIV_parto_plurimo_atti
(a_atto			IN	number
,a_num_gemello		IN	number
,a_tot_gemelli		IN	number
,a_flag_succ_prec	IN	varchar2
,a_id_atto		IN	varchar2 	default NULL
)

return varchar2

IS

w_id_atto_pr		varchar2(255);

cursor sel_succ is
select * from civnas_plurimo
 where id_atto_pr = w_id_atto_pr
   and atto       > a_atto
 order by atto
;

cursor sel_prec is
select * from civnas_plurimo
 where id_atto_pr = w_id_atto_pr
   and atto       < a_atto
 order by atto
;

w_atto			number;
w_conta			number;

w_integrazione_ansc	varchar2(255) := f_valore_inp('ANSC',1,1,'X','S');
w_ambiente_ansc		varchar2(255);
w_comune_cliente	varchar2(255);

w_return		varchar2(255);

begin
  if a_num_gemello||a_tot_gemelli is null then
     goto fine;
  end if;

  if nvl(w_integrazione_ansc,'N') = 'S' then
     --w_ambiente_ansc	:= rtrim(f_ANSC_valore_inp('AMBIENTE',1,10,'X','S'));
     begin
       select upper(rtrim(substr(inp.valore,1,10)))
        into w_ambiente_ansc
        from ansinp inp
       where inp.parametro = 'AMBIENTE'
       ;
      exception
        when others then
             w_ambiente_ansc := '';
     end;
     w_comune_cliente	:= f_get_comune_cliente('COD_COMUNE');

     if (nvl(w_ambiente_ansc,'PROD') = 'PROD' 
         or (nvl(w_ambiente_ansc,'PROD') = 'PRE' and w_comune_cliente in ('039010','025006')))
     then
        begin
          select id_atto_pr
            into w_id_atto_pr
            from civnas_plurimo
           where id_atto = a_id_atto
             and rownum = 1
          ;
        exception
          when others then
               w_id_atto_pr := '';
        end;
   
        if w_id_atto_pr is not null then
           if upper(a_flag_succ_prec) = 'SUCC' then
              w_conta := 1;
              for rec in sel_succ loop
                  if w_conta = 1 then
                     w_return := rec.numero_unico;
                  else
                     w_return := w_return||', '||rec.numero_unico;
                  end if;
                  w_conta := w_conta + 1;
              end loop;
   
           elsif upper(a_flag_succ_prec) = 'PREC' then
              w_conta := 1;
              for rec in sel_prec loop
                  if w_conta = 1 then
                     w_return := rec.numero_unico;
                  else
                     w_return := w_return||', '||rec.numero_unico;
                  end if;
                  w_conta := w_conta + 1;
              end loop;
           end if;
           w_return := w_return||' di questo Comune';
        end if;
     end if;
  end if;

  if w_return is not null then
     goto testo_atti;
  end if;

  if a_atto is not null and a_num_gemello is not null and a_tot_gemelli is not null then
     w_atto := a_atto;
     w_conta := 1;
     if upper(a_flag_succ_prec) = 'SUCC' then
-- i seguent... att... numer...
        for i in a_num_gemello..(a_tot_gemelli-1) loop
            w_atto := w_atto + 1;
            if w_conta = 1 then
               w_return := w_atto;
            else
               w_return := w_return||', '||w_atto;
            end if;
            w_conta := w_conta + 1;
        end loop;

     elsif upper(a_flag_succ_prec) = 'PREC' then
-- i ...     precedent...    att...   numero ...
        w_atto := a_atto - a_num_gemello;
        for i in 1..(a_num_gemello-1) loop
            w_atto := w_atto + 1;
            if i = 1 then
               w_return := w_atto;
            else
               w_return := w_return||', '||w_atto;
            end if;
        end loop;
     end if;
  end if;

<< testo_atti >>

  if upper(a_flag_succ_prec) = 'SUCC' then
     if a_tot_gemelli - a_num_gemello = 1 then
        w_return := 'il seguente atto numero '||w_return;
     else
        w_return := 'i seguenti atti numero '||w_return;
     end if;
  elsif upper(a_flag_succ_prec) = 'PREC' then
     if a_num_gemello - 1 = 1 then
        w_return := 'il precedente atto numero '||w_return;
     else
        w_return := 'i precedenti atti numero '||w_return;
     end if;
  end if;

<< fine >>

  return w_return;
end;
/
