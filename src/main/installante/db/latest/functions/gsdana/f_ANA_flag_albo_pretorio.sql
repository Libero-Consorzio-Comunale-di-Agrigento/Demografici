--liquibase formatted sql
--changeset amonopoli:202512041230_2 runOnChange:true stripComments:false
create or replace function f_ANA_flag_albo_pretorio
(a_id			IN	number
,a_codice_co		IN	number
,a_anagrafe		IN	varchar2
,a_tipo_evento		IN	varchar2
)

return varchar2

IS

w_tipo_comunicazione	varchar2(255);
w_cod_modello		varchar2(255);

w_fase_prot		varchar2(255);
w_funzione_prot		varchar2(255);

w_flag_protocollo	varchar2(255);

w_flag			varchar2(255);

begin
  if a_codice_co is not null then
     begin
       select tipo_comunicazione, cod_modello
         into w_tipo_comunicazione, w_cod_modello
         from anadco_zk dco
        where codice_co = a_codice_co
       ;
     exception
       when others then
            w_tipo_comunicazione := '';
            w_cod_modello        := '';
     end;
  end if;

  if w_tipo_comunicazione is not null and w_cod_modello is not null then
     w_funzione_prot := 'W'||w_cod_modello;

     if w_tipo_comunicazione = 'C' then
        w_fase_prot := 'SCAW';
     elsif w_tipo_comunicazione = 'P' then
        if a_anagrafe = 'RES' then
           if a_tipo_evento = 'I' then
              w_fase_prot := 'IAPR';
           elsif a_tipo_evento = 'E' then
              w_fase_prot := 'CABI';
           elsif a_tipo_evento = 'C' then
              w_fase_prot := 'CAPR';
           elsif a_tipo_evento = 'R' then
              w_fase_prot := 'RANR';
           end if;

        elsif a_anagrafe = 'AIR' then
           if a_tipo_evento = 'I' then
              w_fase_prot := 'IAIR';
           elsif a_tipo_evento = 'E' then
              w_fase_prot := 'CABA';
           elsif a_tipo_evento = 'C' then
              w_fase_prot := 'KAIR';
           elsif a_tipo_evento = 'R' then
              w_fase_prot := 'RANA';
           end if;
        end if;
     end if;

     begin 
       select 'S'
         into w_flag
         from parametri_protocollo
        where fase     			= w_fase_prot
          and funzione 			= w_funzione_prot
          and nvl(invio_protocollo,'N') in ('S','R')
          and flag_albo_pretorio 	is not null
       ;
     exception
       when others then
            w_flag := '';
     end;

    if nvl(w_flag,'N') = 'S' then
       begin
         select decode(flag_ws_prot,'','D','P')
           into w_flag
           from anacom_prot
          where id = a_id
         ;
       exception
         when no_data_found then
              w_flag := '';
         when others then
              w_flag := '';
       end;
    end if;

  end if; --if w_tipo_comunicazione is not null and w_cod_modello is not null then

  return w_flag;

end;
/
