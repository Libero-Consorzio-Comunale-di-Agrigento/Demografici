--liquibase formatted sql
--changeset ftravaglini:202301201130 runOnChange:true
DECLARE

v_formula_prec        varchar2(255);
v_note_prec           varchar2(4000);
v_note_prec2          varchar2(4000);

errore                exception;
v_errore              varchar2(4000);

CURSOR sel_nfa IS 
SELECT n.* 
  FROM civtfa t, civdfa d, civnfa n
 WHERE t.formula = d.formula 
   and d.formula = n.formula
   and n.note    is not null
 ORDER BY n.formula, n.variabile
;
                            
BEGIN
  FOR rec IN sel_nfa LOOP
      DBMS_OUTPUT.PUT_LINE('FORMULA - VARIABILE - NOTA: ' || rec.formula|| ' - ' ||rec.variabile || ' - ' || rec.note);
      IF (rec.formula = nvl(v_formula_prec,'xxx') and rec.note in (nvl(v_note_prec,'xxx'),nvl(v_note_prec2,'xxx'))) THEN
         BEGIN 
           UPDATE civnfa 
              SET note = NULL 
            WHERE variabile = rec.variabile 
              AND formula   = rec.formula
           ;
           IF sql%found THEN 
              DBMS_OUTPUT.PUT_LINE('   --> Note annullate ');
           ELSE -- sql%notfound
              DBMS_OUTPUT.PUT_LINE('   --> Note non annullate ');
           END IF;
         EXCEPTION
           when others then
                v_errore := 'errore in update civnfa ('||sqlerrm||')';
                raise errore;
         END;
      END IF;
      v_formula_prec := rec.formula;
      v_note_prec2   := v_note_prec;
      v_note_prec    := rec.note;
  END LOOP;
    
EXCEPTION
    WHEN errore THEN
        ROLLBACK;
        raise_application_error(-20999, v_errore);
    WHEN others THEN
        ROLLBACK;
        raise_application_error(-20999, 'errore ('||sqlerrm||')');
    
END;
/