--liquibase formatted sql
--changeset amonopoli:202407191025 runOnChange:true stripComments:false
create or replace function f_ANSC_get_albero_JSN
(a_id_sezione     IN       number
,a_id_campo       IN       number
)

return varchar2

IS

cursor sel_sezione (w_id_par number) is
select id, sezione, id_padre from ansjsn_sezioni
where id = w_id_par
;

cursor sel_campo (w_id_par number) is
select id, campo, id_sezione from ansjsn_campi
where id = w_id_par
;

w_id_sezione   number;
w_sezione  varchar2(255);
w_id_padre number;
w_id_campo number;
w_campo    varchar2(255);

w_return          varchar2(4000);

begin
  if a_id_campo is not null then
     goto estrai_campo;
  end if;

  if a_id_sezione is not null then
     goto estrai_sezione;
  end if;

<< estrai_sezione >>
  OPEN sel_sezione(a_id_sezione);
  FETCH sel_sezione INTO w_id_sezione, w_sezione, w_id_padre;
  CLOSE sel_sezione;
  
  if w_id_sezione is null then
     goto fine;
  end if;
  
  w_return := w_sezione;

  if w_id_padre is not null then
     goto loop_sezione;
  end if;

  goto fine;

<< estrai_campo >>
  OPEN sel_campo(a_id_campo);
  FETCH sel_campo INTO w_id_campo, w_campo, w_id_sezione;
  CLOSE sel_campo;

  if w_id_campo is null then
     goto fine;
  end if;

  w_return := w_campo;

  w_id_padre := w_id_sezione;

<< loop_sezione >>
  OPEN sel_sezione(w_id_padre);
  FETCH sel_sezione INTO w_id_sezione, w_sezione, w_id_padre;
  CLOSE sel_sezione;

  w_return := w_sezione||'.'||w_return;

  if w_id_padre is not null then
     goto loop_sezione;
  end if;

  goto fine;

<< fine >>
null;

  return w_return;
end;
/
