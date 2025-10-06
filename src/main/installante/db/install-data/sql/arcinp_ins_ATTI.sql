--liquibase formatted sql
--changeset snocca:202301051536 runOnChange:true
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_DX_SX','S','DESTRO-SINISTRO AUTO'
  from dual
 where not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_DX_SX') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MINUS','N','MINUSCOLE NEGLI ATTI'
  from dual
 where not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MINUS') 
/ 
update arcinp 
   set note          = 'Valori consentiti: ''S'' - ''N''
Valorizzato a ''S'' attiva l''automatismo (dove previsto) di abilitare la gestione delle lettere minuscole nel campo di riferimento'
     , flag_visibile = 'S'
 where parametro = 'ATTI_MINUS'
   and note      is null
/
update arcinp 
   set note          = 'Valori consentiti: ''S'' - ''N''
Valorizzato a ''S'', abilita l''automatismo che prevede, nell''indicazione in lettere delle date, il giorno UNO viene indicato come PRIMO'
     , flag_visibile = 'S'
 where parametro = 'ATTI_PRIMO'
   and note      is null
/
--
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_CIT',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_CIT') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_NAS1A',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_NAS1A') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_NAS1B',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_NAS1B') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_NAS2A',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_NAS2A') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_NAS2B',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_NAS2B') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MAT1',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MAT1') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MAT2A',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MAT2A') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MAT2B',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MAT2B') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MAT2C',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MAT2C') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MOR1',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MOR1') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MOR2A',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MOR2A') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MOR2B',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MOR2B') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_MOR2C',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_MOR2C') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_UCI',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_UCI') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_UCI1',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_UCI1') 
/ 
insert into arcinp (parametro,valore,descrizione)
select 'ATTI_UCI2',valore,'DESTRO-SINISTRO AUTO'
  from arcinp
 where parametro 	= 'ATTI_DX_SX'
   and not exists (select 'x'
		     from arcinp
		    where parametro = 'ATTI_UCI2') 
/ 
update arcinp 
   set note          = 'SOLO per Atti di Cittadinanza
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Cittadinanza e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_CIT'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Matrimonio - Parte 1
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Matrimonio, Parte 1, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_MAT1'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Matrimonio - Parte 2 Serie A
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Matrimonio, Parte 2 Serie A, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_MAT2A'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Matrimonio - Parte 2 Serie B
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Matrimonio, Parte 2 Serie B, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_MAT2B'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Matrimonio - Parte 2 Serie C
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Matrimonio, Parte 2 Serie C, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_MAT2C'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Morte  - Parte 1
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Morte, Parte 1, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_MOR1'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Morte  - Parte 2 Serie A
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Morte, Parte 2 Serie A, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_MOR2A'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Morte  - Parte 2 Serie B
Valori previsti: ''S'' - ''S1'' - ''INV'' - ''INV1'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Morte, Parte 2 Serie B, e segue la seguente logica: 
- atto 1 con margine sinistro, alto
- atto 2 con margine sinistro, basso 
- atto 3 con margine destro, alto
- atto 4 con margine destro, basso
... e cosi via...
Se la proposta del destra/sinistra e alto/basso deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare
- ''INV'': se si vuole ivertire completamente la logica
- ''INV1'': se invece si vuole solo spostare la gestione di un numero'
     , flag_visibile = 'S'
 where parametro = 'ATTI_MOR2B'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Morte  - Parte 2 Serie C
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Morte, Parte 2 Serie C, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_MOR2C'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Nascita  - Parte 1 Serie A
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Nascita, Parte 1 Serie A, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_NAS1A'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Nascita  - Parte 1 Serie B
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Nascita, Parte 1 Serie B, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_NAS1B'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Nascita  - Parte 2 Serie A
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Nascita, Parte 2 Serie A, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_NAS2A'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Nascita  - Parte 2 Serie B
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Nascita, Parte 2 Serie B, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_NAS2B'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Unione  - Senza Parte e Serie (Verbali)
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Unione Civile, senza Parte e Serie, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_UCI'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Unione  - Parte 1
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Unione Civile, Parte 1, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_UCI1'
   and note      is null
/
update arcinp 
   set note          = 'SOLO per Atti di Unione  - Parte 2
Valori previsti: ''S'' - ''INV'' - ''N''
Valorizzato a ''S'' attiva l''automatismo di proposta del margine (Destro / Sinistro) in fase di stampa dell''atto. 
Ha effetto SOLO per Atti di Unione Civile, Parte 2, e segue la seguente logica: 
- atti dispari con margine sinistro
- atti pari con margine destro
Se la proposta del destra/sinistra deve essere invertita - ad esempio, per motivi di stampa dei moduli del registro, oppure a motivo di atti annullati - allora impostare con il valore ''INV'''
     , flag_visibile = 'S'
 where parametro = 'ATTI_UCI2'
   and note      is null
/
