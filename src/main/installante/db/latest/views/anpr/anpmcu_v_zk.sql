--liquibase formatted sql
--changeset amonopoli:202604221045 runAlways:true runOnChange:true stripComments:false
create or replace view anpmcu_v_zk
AS
select mcu.* 
     , to_char(null) info_ws
     , decode(mcu.flag_invio_ws, '', f_ANPR_get_note_ws(mcu.id_operazione,mcu.note_ws,mcu.data_invio_ws,mcu.data_reg)) note_ws_vis
     , decode(mcu.flag_invio_ws, 'S', f_ANPR_get_info_ws(mcu.id_operazione,mcu.note_ws,mcu.data_invio_ws,mcu.data_reg)) info_ws_vis
     , to_date(mcu.data_reg,'j') d_data_reg
     , to_date(mcu.data_invio_ws,'j') d_data_invio_ws
     , f_ANPR_des_esito_ciu(mcu.esito_anpr) des_esito_anpr
  from anpmcu mcu
/
comment on table anpmcu_v_zk is 'ANPR - Movimenti Comunicazioni in Uscita (view) - ZK'
/
