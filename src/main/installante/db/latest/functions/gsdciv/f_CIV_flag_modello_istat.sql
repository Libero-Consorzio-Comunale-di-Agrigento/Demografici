--liquibase formatted sql
--changeset snocca:202401031127 runOnChange:true stripComments:false
create or replace function f_CIV_flag_modello_istat
(a_modello_istat	IN	varchar2
,a_id_atto		IN	varchar2
,a_id_civann	IN	number default null
)

return varchar2

IS

w_istatel_inp		varchar2(255);
w_modello_istat		varchar2(255) := upper(a_modello_istat);

w_flag			varchar2(255);

begin
   if a_modello_istat is not null and (a_id_atto is not null or a_id_civann is not null) then
      w_istatel_inp := nvl(rtrim(f_valore_inp('ISTATEL',1,1,'X','S')),'N');

      if w_istatel_inp = 'S' then
         if w_modello_istat = 'P4' then
            begin
              select 'S'
                into w_flag
                from istmp4
               where id_atto = a_id_atto
                 and rownum = 1
              ;
            exception
              when others then
                   w_flag := '';
            end;

         elsif w_modello_istat = 'D3' then
            begin
              select 'S'
                into w_flag
                from istmd3
               where a_id_atto in (id_atto_mat,id_atto_pub)
                 and rownum = 1
              ;
            exception
              when others then
                   w_flag := '';
            end;

         elsif w_modello_istat = 'D4' then
            begin
              select 'S'
                into w_flag
                from istmd4
               where id_atto = a_id_atto
                 and rownum = 1
              ;
            exception
              when others then
                   w_flag := '';
            end;

         elsif w_modello_istat = 'D4BIS' then
            begin
              select 'S'
                into w_flag
                from istm4b
               where id_atto = a_id_atto
                 and rownum = 1
              ;
            exception
              when others then
                   w_flag := '';
            end;

         elsif w_modello_istat = 'D3U' then
            begin
              select 'S'
                into w_flag
                from istmdu
               where a_id_atto in (id_atto_mat,id_atto_pub)
                 and rownum = 1
              ;
            exception
              when others then
                   w_flag := '';
            end;

         elsif w_modello_istat = 'SC' then
            begin
              select 'S'
                into w_flag
                from istmsc
               where id_atto = a_id_atto
                 and rownum = 1
              ;
            exception
              when others then
                   w_flag := '';
            end;
         elsif w_modello_istat = 'SU' then
            begin
              select 'S'
                into w_flag
                from istmsu
               where id_atto = a_id_atto
              ;
            exception
              when others then
                   w_flag := '';
            end;
         elsif w_modello_istat = 'PROVV' then
            begin
              select 'S'
                into w_flag
                from dual
               where exists (select 1 from istmsu where cod_modello = 'PROVV' and id_civann = a_id_civann)
                  or exists (select 1 from istmsc where cod_modello = 'PROVV' and id_civann = a_id_civann)
              ;
            exception
              when others then
                   w_flag := '';
            end;

         end if;
      end if; --if w_istatel_inp = 'S' then

   end if; --if a_modello_istat is not null and (a_id_atto is not null or a_id_civann is not null) then


  return w_flag;
end;
/
