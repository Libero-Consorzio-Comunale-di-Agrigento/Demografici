--liquibase formatted sql
--changeset amonopoli:202511100850 runOnChange:true stripComments:false
CREATE OR REPLACE FUNCTION f_TPR_ctr_numero_pratica 
(a_anagrafe         IN 	VARCHAR2
,a_tipo_evento      IN 	VARCHAR2
,a_anno_pratica     IN 	NUMBER
,a_pratica          IN 	NUMBER
,a_archivio_rif     IN 	VARCHAR2
) 

RETURN VARCHAR2

IS

v_count 	NUMBER := 0;

w_errore	varchar2(4000);
errore		exception;

BEGIN

--  Come funziona:
-- 
--  1. Per ANATPR: Controlla se esiste già un record con la combinazione di anagrafe, tipo_evento, anno_pratica e pratica
--  2. Per ANAC01: Controlla se esiste già un record con anno_protocollo_aire e protocollo_aire
--  3. Ritorna NULL se non trova corrispondenze
--  4. Ritorna il messaggio appropriato se trova corrispondenze
 
  IF a_archivio_rif = 'ANATPR' THEN
-- Controllo su tabella ANATPR
     begin
       SELECT COUNT(*)
         INTO v_count
         FROM ANATPR
        WHERE anagrafe     = a_anagrafe
          AND tipo_evento  = a_tipo_evento
          AND anno_pratica = a_anno_pratica
          AND pratica      = a_pratica
       ;
       IF v_count > 0 THEN
          w_errore := 'Anno e Pratica gia'' presenti';
          raise errore;
       END IF;
     exception
       when others then
            w_errore := 'Errore in ricerca pratica';
     end;

  ELSIF a_archivio_rif = 'ANAC01' THEN
-- Controllo su tabella ANAC01
     begin
       SELECT COUNT(*)
         INTO v_count
         FROM ANAC01
        WHERE anno_protocollo_aire = a_anno_pratica
          AND protocollo_aire      = a_pratica
       ;
       IF v_count > 0 THEN
          w_errore := 'Anno e Protocollo AIRE (cancellazione) gia'' presenti';
          raise errore;
       END IF;
     exception
       when others then
            w_errore := 'Errore in ricerca Protocollo AIRE di cancellazione';
            raise errore;
     end;

  ELSIF a_archivio_rif = 'ANAA01' THEN
-- Controllo su tabella ANAA01
     begin
       SELECT COUNT(*)
         INTO v_count
         FROM ANAA01
        WHERE anno_protocollo_aire = a_anno_pratica
          AND protocollo_aire      = a_pratica
       ;
       IF v_count > 0 THEN
          w_errore := 'Anno e Protocollo AIRE (iscrizione) gia'' presenti';
          raise errore;
       END IF;
     exception
       when others then
            w_errore := 'Errore in ricerca Protocollo AIRE di iscrizione';
            raise errore;
     end;
  END IF;

-- Se non esistono record, restituisce NULL
  RETURN NULL;
 
EXCEPTION
  WHEN errore THEN
       return w_errore;
  WHEN OTHERS THEN
       w_errore := 'Errore in controllo esistenza pratica ('||a_anagrafe||' - '||a_tipo_evento||' - '||a_anno_pratica||' - '||a_pratica||')';
       return w_errore;
END;
/
