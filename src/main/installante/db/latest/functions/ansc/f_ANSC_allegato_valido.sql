--liquibase formatted sql
--changeset amonopoli:202305231020 runOnChange:true stripComments:false
create or replace function f_ANSC_allegato_valido
(a_archivio_rif		IN	varchar2
,a_id_rif		IN	varchar2
)

return number

IS

w_archivio_rif		varchar2(255) := upper(a_archivio_rif);

w_nome_file		varchar2(255);
w_estensione_file	varchar2(255);

w_return		number;

begin
  w_return := 0;

  if a_archivio_rif is not null and a_id_rif is not null then
     if w_archivio_rif = 'ALL' then
        begin
          select faa.nome, upper(substr(faa.nome,instr(faa.nome,'.',-1)+1))
            into w_nome_file, w_estensione_file
            from civfas_alle faa
           where id = a_id_rif
          ;
        exception 
          when others then
               w_return := -1;
        end;
    
        begin
          select 1
            into w_return
            from anst10
           where descrizione = w_estensione_file
             and rownum = 1
          ;
        exception 
          when others then
               w_return := -1;
        end;

        if w_return >= 0 then
           if translate(w_nome_file,'()\/ -','******') like '%*%' then
              w_return := -2;
           end if;
        end if;

     end if; -- if w_archivio_rif = 'ALL' then
  end if; -- if a_archivio_rif is not null and a_id_rif is not null then

  return w_return;
end;
/



 