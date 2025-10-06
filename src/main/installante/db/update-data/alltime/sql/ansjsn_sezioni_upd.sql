--liquibase formatted sql
--changeset amonopoli:202306201525_1 runAlways:true runOnChange:true stripComments:false
declare
  w_id_max	number;
  w_id_next	number;
  w_id 		number;

begin
  begin
    select nvl(max(id),0)
      into w_id_max
      from ansjsn_sezioni
    ;
  exception
    when others then
         w_id_max := 0;
  end;

  w_id_next := f_ansjsn_sezioni_nr('');

dbms_output.put_line('w_id_max: '||w_id_max);
dbms_output.put_line('w_id_next: '||w_id_next);

  if w_id_next >= w_id_max then 
dbms_output.put_line('numerazione OK');
     null;
  else
     for i in w_id_next..w_id_max loop
         w_id := f_ansjsn_sezioni_nr('');
dbms_output.put_line('numerazione - w_id: '||w_id);
     end loop;
  end if;
  

end;
/
