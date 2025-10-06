--liquibase formatted sql
--changeset amonopoli:202305181120 runOnChange:true stripComments:false
create or replace function f_CIV_numero_unico
(a_anno 		IN 	number
,a_flag_recupero 	IN 	varchar2
)

return number

IS

w_flag_recupero varchar2(1) := nvl(upper(a_flag_recupero), 'N');
w_numero        number      := 0;
w_contatore     number;
w_max_assegnato number;
w_max           number;

w_errore	varchar(4000);
errore		exception;

begin
  if a_anno is null then
     return 0;
  end if;

  -- Ottengo il numero dal contatore
  begin
    select nvl(max(numero), 0)
      into w_contatore
      from civn01
     where anno = a_anno
    ;
  exception
    when others then
         w_errore := 'errore in sel_civn01 ('||sqlerrm||')';
         raise errore;
  end;

  if w_flag_recupero = 'S' then
     -- Ottengo il massimo numero assegnato
     begin
       select nvl(max(alv.numero_unico), 0)
         into w_max_assegnato
         from ansall_v alv
        where COALESCE(alv.anno, a_anno) = a_anno
       ;
     exception
       when others then
            w_errore := 'errore in sel_ansall_v ('||sqlerrm||')';
            raise errore;
     end;

     -- Se devo recuperare buchi, seleziono partendo dal massimo attuale

     -- Ottengo il massimo attuale
     w_max := greatest(w_max_assegnato, w_contatore);

     -- Cerco il primo numero non assegnato nel range [1...massimo attuale]
     begin
       select min(r.numero)
         into w_numero
         from (select rownum as numero from dual connect by rownum <= w_max) r
        where not exists (select 1
                            from ansall_v v
                           where v.numero_unico = r.numero
                             and v.anno = a_anno)
       ;
     exception
       when others then
            w_errore := 'errore in sel_dual - 1 ('||sqlerrm||')';
            raise errore;
     end;

     if w_numero is null then
        -- Se non ci sono buchi, seleziono incrementando il massimo attuale
        w_numero := w_max + 1;
     end if;

  else
     -- Se non devo recuperare buchi, seleziono partendo dal contatore
     w_numero := w_contatore + 1;
  end if;

  -- Se il numero selezionato è maggiore del contatore aggiorno il contatore
  if w_numero > w_contatore then
     begin
       update civn01
          set numero = w_numero
        where anno = a_anno
       ;
     exception
       when others then
            w_errore := 'errore in upd_civn01 ('||sqlerrm||')';
            raise errore;
     end;

     if SQL%ROWCOUNT = 0 then
        begin
          insert into civn01 (anno, numero)
          values (a_anno, w_numero)
          ;
        exception
          when others then
               w_errore := 'errore in ins_civn01 ('||sqlerrm||')';
               raise errore;
        end;
     end if;
  end if;

  return w_numero;

exception
  when errore then
--       rollback;
--       raise_application_error(-20999, w_errore);
       return 0;
  when others then
       w_errore := 'errore ('||sqlerrm||')';
--       rollback;
--       raise_application_error(-20999, w_errore);
       return 0;
end;
/
