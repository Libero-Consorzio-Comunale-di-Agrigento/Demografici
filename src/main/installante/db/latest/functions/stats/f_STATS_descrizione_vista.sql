--liquibase formatted sql
--changeset amonopoli:202411191550_2 runOnChange:true stripComments:false
create or replace function f_STATS_descrizione_vista
(a_tname	IN	varchar2)

return varchar2

IS

w_tname		varchar2(255) := upper(a_tname);
w_descrizione	varchar2(255);

begin
  w_descrizione := f_STATS_nome_vista(a_tname);
  w_descrizione := replace(initcap(replace(w_descrizione, '_',' ')), 'Gsd ','');

  if w_descrizione like '% Ana' then
     w_descrizione := replace(w_descrizione, ' Ana',' Anagrafe');

  elsif w_descrizione like '% Ana %' then
     w_descrizione := replace(w_descrizione, ' Ana ',' Anagrafe ');

  end if;

  if w_descrizione like '% Ds %' then
     w_descrizione := replace(w_descrizione, ' Ds ',' Documento di Soggiorno ');

  elsif w_descrizione like '% Di %' and w_descrizione not like '% Di Studio%' then
     w_descrizione := replace(w_descrizione, ' Di ',' Documento di Identita ');

  elsif w_descrizione like '% Prof %' then
     w_descrizione := replace(w_descrizione, ' Prof ',' Professionale ');

  elsif w_descrizione like '% Prof %' then
     w_descrizione := replace(w_descrizione, ' Prof ',' Professionale ');

  elsif w_descrizione like '% Doc %' then
     w_descrizione := replace(w_descrizione, ' Doc ',' Documento ');

  elsif w_descrizione like '% Par %' then
     w_descrizione := replace(w_descrizione, ' Par ',' Parentela ');

  elsif w_descrizione like '% Par' then
     w_descrizione := replace(w_descrizione, ' Par',' Parentela');

  elsif w_descrizione like '% Ele %' then
     w_descrizione := replace(w_descrizione, ' Ele ',' Elettorale ');

  elsif w_descrizione like '% Ele' then
     w_descrizione := replace(w_descrizione, ' Ele',' Elettorale');

  elsif w_descrizione like '% Cap %' then
     w_descrizione := replace(w_descrizione, ' Cap ',' CAP ');

  elsif w_descrizione like 'Suddivisione %' then
     w_descrizione := replace(w_descrizione, 'Suddivisione ','Suddivisione per Unita Territoriale ');
     w_descrizione := replace(w_descrizione, ' 0',' ');

  elsif w_descrizione like 'Unita %' then
     w_descrizione := replace(w_descrizione, 'Unita ','Unita Territoriale ');
     w_descrizione := replace(w_descrizione, ' 0',' ');

  elsif w_descrizione like '% Eve' then
     w_descrizione := replace(w_descrizione, ' Eve',' Evento');

  elsif w_descrizione like '% Mov' then
     w_descrizione := replace(w_descrizione, ' Mov',' Movimento');

  end if;

  if w_descrizione like '% Cod' then
     w_descrizione := replace(w_descrizione, ' Cod',' (Codice)');

  elsif w_descrizione like '% Des' then
     w_descrizione := replace(w_descrizione, ' Des',' (Descrizione)');

  elsif w_descrizione like '% S' then
     w_descrizione := replace(w_descrizione, ' S',' S/N');

  elsif w_descrizione like '% Si' then
     w_descrizione := replace(w_descrizione, ' Si',' SI/NO');

  end if;

  return w_descrizione;

end;
/
