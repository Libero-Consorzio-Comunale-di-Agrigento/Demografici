--liquibase formatted sql
--changeset amonopoli:202309111545 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_ultima_CIU
(a_id_operazione	IN	number
,a_servizio		IN	varchar2
,a_archivio_rif		IN	varchar2
,a_id_rif		IN	varchar2
)

return varchar2

IS

cursor sel_ciu is
select ciu.id_operazione
  from ansciu ciu
 where servizio     = a_servizio
   and archivio_rif = a_archivio_rif
   and id_rif       = a_id_rif
 order by nvl(to_char(d_data_invio_ws,'j'),0000000) desc,
          nvl(to_char(d_data_reg,'j'),0000000) desc,
          ciu.id_operazione desc
;

w_id_fetch	number;

w_flag		varchar2(1);

begin
  w_flag := '';
  if a_servizio is not null and a_archivio_rif is not null and a_id_rif is not null then
     OPEN sel_ciu;
     FETCH sel_ciu INTO w_id_fetch;
     CLOSE sel_ciu;

     if w_id_fetch = a_id_operazione then
        w_flag := 'S';
     end if;
  end if;

  return w_flag;
end;
/
