--liquibase formatted sql
--changeset amonopoli:202501151015_3 runOnChange:true stripComments:false
create or replace function f_WSPA_get_servizio_x_id_rif
(a_tabella_rif		IN	varchar2
,a_id_tabella_rif	IN	varchar2
,a_tipo_codice		IN	varchar2
)

return varchar2

IS

w_codice_cliente	varchar2(255);

w_cod_certificato	varchar2(255);
w_tot_diritti		number;

w_tipo_codice	varchar2(255) := upper(a_tipo_codice);
w_cod_servizio	varchar2(255);
w_cod_depag  	varchar2(255);

w_return	varchar2(255);

begin
  w_return := '';
  begin
    select id
      into w_codice_cliente
      from menuditta_v
    ;
  exception 
    when others then
         w_codice_Cliente := '000000';
  end;

  if a_tabella_rif||a_id_tabella_rif is not null then
     begin
       select cem.cod_certificato,
              nvl(cem.segreteria,0) + nvl(cem.stato_civile,0) + nvl(cem.rimborso_st,0) + nvl(cem.carta_identita,0) + nvl(cem.bollo,0) 
         into w_cod_certificato, w_tot_diritti
         from cercem cem
        where annullamento  is null
          and id            = a_id_tabella_rif
          and a_tabella_rif = 'CERCEM'
       ;
     exception
       when others then
            w_cod_certificato := '';
            w_tot_diritti     := '';
     end;
  end if;

  if w_cod_certificato is not null then
     if w_codice_cliente = '015192' then
        w_return := f_WSPA_get_servizio_SDM(a_tabella_rif,w_cod_certificato,a_tipo_codice,w_tot_diritti);
     else
        w_return := f_WSPA_get_servizio(a_tabella_rif,w_cod_certificato,a_tipo_codice);
     end if;
  end if;

  return w_return;

end;
/
