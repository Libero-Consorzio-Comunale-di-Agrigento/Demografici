--liquibase formatted sql
--changeset amonopoli:202511251215 runOnChange:true stripComments:false
create or replace function f_ANA_des_comunicazione
(a_codice_co		IN	number
,a_matricola		IN	number
,a_escape       	IN	varchar2	default 'N'
,a_id			IN	number		default null
)

return varchar2

IS

w_codice_co		number := a_codice_co;
w_matricola		number := a_matricola;

w_escape		varchar2(255) := upper(a_escape);

w_tipo_comunicazione	varchar2(255);
w_des_comunicazione	varchar2(255);
w_des_modello		varchar2(255);

w_cognome_nome		varchar2(255);

w_descrizione		varchar2(255);

begin
  if w_codice_co is not null then
     begin
       select dco.tipo_comunicazione, dco.descrizione, mod.descrizione
         into w_tipo_comunicazione, w_des_comunicazione, w_des_modello
         from anamod mod, anadco_zk dco
        where mod.cod_modello  = dco.cod_modello
          and mod.tipo_modello = dco.tipo_comunicazione
          and dco.codice_co    = w_codice_co
       ;
       w_descrizione := w_des_comunicazione;
     exception
       when others then
            w_descrizione := '';
     end;
  end if;

  if w_tipo_comunicazione = 'C' then
     w_descrizione := w_des_modello||' - '||w_descrizione;
  end if;

  if w_matricola is not null then
     begin
       select replace(cognome_nome,'/',' ')
         into w_cognome_nome
         from anaana   
        where matricola = w_matricola
       ;
     exception
       when others then
            w_cognome_nome := '';
     end;

     if w_cognome_nome is not null then
        w_descrizione := w_descrizione||' ('||w_cognome_nome||')';
     end if;
  end if;

  if w_descrizione is not null and a_escape = 'S' then
     w_descrizione := replace(w_descrizione,'/','_');
  end if;

  if a_id is not null then
     w_descrizione := w_descrizione||'_'||a_id;
  end if;

  return w_descrizione;

end;
/
