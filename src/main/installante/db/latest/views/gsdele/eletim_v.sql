--liquibase formatted sql
--changeset amonopoli:202601201110 runOnChange:true stripComments:false
create or replace view eletim_v
AS
select t.*,
       decode(t.tipo_tim,1,'UE / CEC',2,'CECir') des_tipo_tim,
       decode(t.progr_tim,1,'Autentica Liste Ricompilate/Nuove Sezioni',
                          2,'Autentica Rettifiche SE',
                          3,'Autentica Blocco Liste',
                          8,'Chiusura Liste (A-L)',
                          9,'Chiusura Liste (M-Z)') des_progr_tim
  from eletim t
/
comment on table eletim_v is 'Elettorale - Timbri di chiusura liste (view)'
/
