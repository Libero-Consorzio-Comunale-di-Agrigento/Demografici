--liquibase formatted sql
--changeset amonopoli:202507301135 runOnChange:true stripComments:false
create or replace function f_ANSC_get_descrizione_TAB
(A_TABELLA_RIF		IN	VARCHAR2
,A_CODICE_RIF           IN	VARCHAR2
,a_campo_des		IN	varchar2	default NULL
,a_campo_cod		IN	varchar2	default NULL
)

return varchar2

IS

w_tabella_rif	varchar2(255) := upper(a_tabella_rif);
w_codice_rif	varchar2(255) := a_codice_rif;
w_campo_des	varchar2(255) := upper(nvl(a_campo_des,'descrizione'));
w_campo_cod	varchar2(255) := upper(nvl(a_campo_cod,'id'));

w_sql		varchar2(32000);
w_result	varchar2(32000);

w_descrizione	varchar2(4000);

begin
  if w_tabella_rif is not null and w_codice_rif is not null then
     w_sql := 'select '||w_campo_des||' from '||w_tabella_rif||' where '||w_campo_cod||' = '''||w_codice_rif||'''';
     begin
       execute immediate w_sql into w_result;
     exception
       when others then
            w_result := '';
     end;

     w_descrizione := nvl(w_result, w_codice_rif);
  end if;

  return w_descrizione;

end;
/
