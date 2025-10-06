--liquibase formatted sql
--changeset amonopoli:202507220955 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_firmato_x_fas
(a_id_civfas	IN 	number
)

return varchar2

IS

w_id_atto	number;
w_id_atto_rif	varchar2(255);
w_archivio_rif	varchar2(255);
w_id_rif    	number;

w_flag		varchar2(255);

begin
  if a_id_civfas is not null then
     begin
       select id_atto
         into w_id_atto_rif
         from civfas
        where id = a_id_civfas
          and rownum = 1
       ;
     end;

     begin
       select 'NAS', nas.id
         into w_archivio_rif, w_id_rif
         from civnas nas
        where id_atto = w_id_atto_rif
       UNION
       select 'MAT', mat.id
         from civmat mat
        where id_atto = w_id_atto_rif
       UNION
       select 'UCI', uci.id
         from civuci uci
        where id_atto = w_id_atto_rif
       UNION
       select 'MOR', mor.id
         from civmor mor
        where id_atto = w_id_atto_rif
       UNION
       select 'CIT', cit.id
         from civcit cit
        where id_atto = w_id_atto_rif
       ;
    exception
      when others then
           w_archivio_rif := '';
           w_id_rif       := '';
    end;
  end if;

  if w_archivio_rif is not null and w_id_rif is not null then
     w_flag := f_ANSC_flag_firmato(w_archivio_rif,w_id_rif,'ATT');
  end if;

  return w_flag;

end;
/
