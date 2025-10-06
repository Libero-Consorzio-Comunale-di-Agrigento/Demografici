--liquibase formatted sql
--changeset amonopoli:202503240950_0 runOnChange:true stripComments:false
create or replace function f_A00_check_db
(a_tipo_oggetto		IN	varchar2
,a_nome_oggetto		IN	varchar2
,a_nome_colonna		IN	varchar2	default null
)

return number

IS

w_tipo_oggetto		varchar2(255) := upper(a_tipo_oggetto);
w_nome_oggetto		varchar2(255) := upper(a_nome_oggetto);
w_nome_colonna		varchar2(255) := upper(a_nome_colonna);

w_return		number;

begin
  w_return := 0;

  if w_tipo_oggetto = 'TAB' then
     begin
       select 1 into w_return
         from tab
        where tname   = w_nome_oggetto
          and tabtype = 'TABLE'
          and rownum  = 1
       ;
     exception
       when others then
            w_return := 0;
     end;

  elsif w_tipo_oggetto = 'VIW' then
     begin
       select 1 into w_return
         from tab
        where tname   = w_nome_oggetto
          and tabtype = 'VIEW'
          and rownum  = 1
       ;
     exception
       when others then
            w_return := 0;
     end;

  elsif w_tipo_oggetto in ('COL') then
     begin
       select 1 into w_return
         from col
        where tname = w_nome_oggetto
          and cname = w_nome_colonna
          and rownum = 1
       ;
     exception
       when others then
            w_return := 0;
     end;

  elsif w_tipo_oggetto in ('CNS') then
     begin
       select 1 into w_return
         from user_constraints
        where constraint_name = w_nome_oggetto
          and rownum = 1
       ;
     exception
       when others then
            w_return := 0;
     end;

--  elsif w_tipo_oggetto in ('IDX','SEQ','OBJ','FNC','PRC','PKG') then
   else
     begin
       select 1 into w_return
         from obj
        where object_name = w_nome_oggetto
          and rownum = 1
       ;
     exception
       when others then
            w_return := 0;
     end;
  end if;

  return w_return;

end;
/
