--liquibase formatted sql
--changeset amonopoli:202304111720_3 runOnChange:true
create or replace trigger CIVMAT_TD
before DELETE
on CIVMAT
for each row
declare
   w_errore		varchar2(255);
   errore		exception;

begin
  begin
    delete civana
     where id_atto = :old.id_atto
    ;
    delete civana_recupero
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVANA ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civcom
     where id_atto = :old.id_atto
    ;
    delete civcom
     where id_atto_rif = :old.id_atto
    ;
    delete civcom
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_m
               and cod_com_nas      = :old.cod_com_nas_m
               and nvl(data_nas,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome     = :old.cognome_nome_m
               and cod_rec          = 0)
       and formula          = '132'
       and tipo_atto        = 2
       and :old.natura      = 'O'
    ;
    delete civcom
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_f
               and cod_com_nas      = :old.cod_com_nas_f
               and nvl(data_nas,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome     = :old.cognome_nome_f
               and cod_rec          = 0)
       and formula          = '132'
       and tipo_atto        = 2
       and :old.natura      = 'O'
    ;
    delete civcom
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_m
               and cod_com_nas      = :old.cod_com_nas_m
               and nvl(data_nas,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome     = :old.cognome_nome_m
               and cod_rec          = 0)
       and formula          in ('138','138-NO')
       and tipo_atto        = 2
       and :old.natura      in ('D','C','S')
    ;
    delete civcom
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_f
               and cod_com_nas      = :old.cod_com_nas_f
               and nvl(data_nas,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome     = :old.cognome_nome_f
               and cod_rec          = 0)
       and formula          in ('138','138-NO')
       and tipo_atto        = 2
       and :old.natura      in ('D','C','S')
    ;
    delete civcom com
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civann ann
             where ann.tipo_atto 	= com.tipo_atto
               and ann.formula   	= com.formula
               and ann.c4	   	= to_char(:old.anno)
               and ann.c5 		= to_char(:old.atto))
       and formula          = '175'
       and tipo_atto        = 4
       and :old.natura      in ('D','C','S')
    ;
    delete civcom com
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civann ann
             where ann.tipo_atto 	= com.tipo_atto
               and ann.formula   	= com.formula
               and ann.c29	   	= to_char(:old.anno)
               and ann.c30 		= to_char(:old.atto))
       and formula          = '175-NO'
       and tipo_atto        = 4
       and :old.natura      in ('D','C','S')
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVCOM ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civttr
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTTR ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtes
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTES ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civdma
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVDMA ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civspo
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVSPO ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civrma
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVRMA ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtte
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTTE ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtta
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTTA ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civdoc
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVDOC ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civdfi
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVDFI ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civart
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVART ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civcma
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVCMA ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civchi
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVCHI ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtli
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTLI ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtli_formule
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTLI_FORMULE ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civtli_annotazioni
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVTLI_ANNOTAZIONI ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civann
     where id_atto = :old.id_atto
    ;
    delete civann
     where id_atto_rif = :old.id_atto
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_m
               and cod_com_nas      = :old.cod_com_nas_m
               and nvl(data_nas,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome     = :old.cognome_nome_m
               and cod_rec          = 0)
       and c7		    	= to_char(:old.anno)
       and c8               	= decode(:old.parte,1,'I','II')
       and upper(nvl(c9,' ')) = decode(:old.serie,'',' ',upper('SERIE '||:old.serie))
       and c10   			= to_char(:old.atto)
       and formula          	in ('132','132-NO')
       and tipo_atto        	= 2
       and :old.natura        = 'O'
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_f
               and cod_com_nas      = :old.cod_com_nas_f
               and nvl(data_nas,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome     = :old.cognome_nome_f
               and cod_rec          = 0)
       and c7		    	= to_char(:old.anno)
       and c8               	= decode(:old.parte,1,'I','II')
       and upper(nvl(c9,' ')) = decode(:old.serie,'',' ',upper('SERIE '||:old.serie))
       and c10		   	= to_char(:old.atto)
       and formula          	in ('132','132-NO')
       and tipo_atto        	= 2
       and :old.natura        = 'O'
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_m
               and cod_com_nas      = :old.cod_com_nas_m
               and nvl(data_nas,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome     = :old.cognome_nome_m
               and cod_rec          = 0)
       and c4		    	 = to_char(:old.anno)
       and c5		    	 = to_char(:old.atto)
       and formula          	 = '138'
       and tipo_atto        	 = 2
       and :old.natura         in ('D','C','S')
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_m
               and cod_com_nas      = :old.cod_com_nas_m
               and nvl(data_nas,0)  = nvl(:old.data_nas_m,0)
               and cognome_nome     = :old.cognome_nome_m
               and cod_rec          = 0)
       and c29		    	 = to_char(:old.anno)
       and c30		    	 = to_char(:old.atto)
       and formula          	 = '138-NO'
       and tipo_atto        	 = 2
       and :old.natura         in ('D','C','S')
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in 
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_f
               and cod_com_nas      = :old.cod_com_nas_f
               and nvl(data_nas,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome     = :old.cognome_nome_f
               and cod_rec          = 0)
       and c4		    	 = to_char(:old.anno)
       and c5    	 		 = to_char(:old.atto)
       and formula          	 = '138'
       and tipo_atto        	 = 2
       and :old.natura         in ('D','C','S')
    ;
    delete civann
     where (ufficio,anno,atto,parte,nvl(serie,' ')) in
           (select ufficio,anno,atto,parte,nvl(serie,' ')
              from civnas
             where cod_pro_nas      = :old.cod_pro_nas_f
               and cod_com_nas      = :old.cod_com_nas_f
               and nvl(data_nas,0)  = nvl(:old.data_nas_f,0)
               and cognome_nome     = :old.cognome_nome_f
               and cod_rec          = 0)
       and c29		    	 = to_char(:old.anno)
       and c30   	 		 = to_char(:old.atto)
       and to_char(:old.parte) = 2
       and :old.serie          = 'C'
       and formula          	 = '138-NO'
       and tipo_atto        	 = 2
       and :old.natura         in ('D','C','S')
    ;
    delete civann
     where c4    			= to_char(:old.anno)
       and c5    			= to_char(:old.atto)
       and formula           	= '175'
       and tipo_atto        	= 4
       and :old.natura        in ('D','C','S')
    ;
    delete civann
     where c29    		= to_char(:old.anno)
       and c30    		= to_char(:old.atto)
       and formula           	= '175-NO'
       and tipo_atto        	= 4
       and :old.natura        in ('D','C','S')
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVANN ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civdpa
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVDPA ('||SQLERRM||')';
         raise errore;
  end;

  begin
    delete civocc
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVOCC ('||SQLERRM||')';
         raise errore;
  end;

   begin
    delete civmar
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVMAR ('||SQLERRM||')';
         raise errore;
  end;

   begin
    delete civsog
     where id_atto = :old.id_atto
    ;
  exception 
    when others then
         w_errore := 'Errore in eliminazione CIVSOG ('||SQLERRM||')';
         raise errore;
  end;

exception
  when errore then
       raise_application_error(-20999, w_errore);
	 ROLLBACK;
  when others then
       raise_application_error(-20999, 'Errore ('||SQLERRM||')');
	 ROLLBACK;
end;
/
