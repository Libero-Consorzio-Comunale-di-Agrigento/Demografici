--liquibase formatted sql
--changeset amonopoli:202306060955 runOnChange:true stripComments:false
create or replace function f_ANSC_ctr_allegato
(a_archivio_rif		IN	varchar2
,a_id_rif		IN	varchar2
,a_nome_file		IN	varchar2	default NULL
)

return varchar2

IS

w_archivio_rif		varchar2(255) := upper(a_archivio_rif);

w_nome_file		varchar2(255);
w_estensione_file	varchar2(255);

w_return		varchar2(4000);

w_integrazione_ansc 	varchar2(1) := upper(f_valore_inp('ANSC',1,1,'X','S'));

begin
  w_return := '';

  if nvl(w_integrazione_ansc,'N') = 'N' then
     goto fine;
  end if;

  if a_archivio_rif is not null and a_id_rif is not null then
     if w_archivio_rif = 'ALL' then
        begin
          select substr(faa.nome,1,instr(faa.nome,'.',-1)-1), 
                 upper(substr(faa.nome,instr(faa.nome,'.',-1)+1))
            into w_nome_file, w_estensione_file
            from civfas_alle faa
           where id = a_id_rif
          ;
        exception 
          when others then
               w_return := 'Errore in ricerca allegato (id: '||a_id_rif||')';
        end;
     end if; -- if w_archivio_rif = 'ALL' then

  else
     w_nome_file       := substr(a_nome_file,1,instr(a_nome_File,'.',-1)-1);
     w_estensione_file := upper(substr(a_nome_file,instr(a_nome_file,'.',-1)+1));

  end if; -- if a_archivio_rif is not null and a_id_rif is not null then

  if w_nome_file is not null and w_return is null then
     begin
       select null
         into w_return
         from anst10
        where descrizione = w_estensione_file
          and rownum = 1
       ;
     exception 
       when others then
            w_return := 'Estensione del file non prevista nelle tabelle ANSC (estensione: '||w_estensione_file||')';
     end;

     if w_return is null then
--        if translate(w_nome_file,'()\/ -','******') like '%*%' then
--           w_return := 'Nome del file non accettato da ANSC (caratteri non ammessi: " " (spazio), "(", ")", "\", "/", "-")';
--        end if;
        if translate(w_nome_file,'.\/','***') like '%*%' then
           w_return := 'Nome del file non accettato da ANSC (caratteri non ammessi: ".", "\", "/")';
        end if;
     end if;
  end if; --if w_nome_file is not null then

<< fine >>

  return w_return;
end;
/
