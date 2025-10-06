--liquibase formatted sql
--changeset amonopoli:202301311300 runOnChange:true
CREATE OR REPLACE function f_CIV_testo_annotazione_x_id
(a_id_civann		IN	number
,a_formula  		IN	varchar2
)

return varchar2

IS

riga_work		varchar2(4000);
conta_variabili		number;
puntatore_fine		number;
campo_stampa            varchar2(4000);
numero                  number := 0;
campo1			varchar2(4000);

w_testo_ann_db		varchar2(4000);

w_testo 		varchar2(4000);

cursor sel_ann is
        select dfa.formula formula,
	       ann.c1, ann.c2, ann.c3, ann.c4, ann.c5, 
	       ann.c6, ann.c7, ann.c8, ann.c9, ann.c10,
               ann.c11, ann.c12, ann.c13, ann.c14, ann.c15, 
	       ann.c16, ann.c17, ann.c18, ann.c19, ann.c20,
               ann.c21, ann.c22, ann.c23, ann.c24, ann.c25, 
	       ann.c26, ann.c27, ann.c28, ann.c29, ann.c30,
               nvl(length(ann.c1),0)+
               nvl(length(ann.c2),0)+
               nvl(length(ann.c3),0)+
               nvl(length(ann.c4),0)+
               nvl(length(ann.c5),0)+
               nvl(length(ann.c6),0)+
               nvl(length(ann.c7),0)+
               nvl(length(ann.c8),0)+
               nvl(length(ann.c9),0)+
               nvl(length(ann.c10),0)+
               nvl(length(ann.c11),0)+
               nvl(length(ann.c12),0)+
               nvl(length(ann.c13),0)+
               nvl(length(ann.c14),0)+
               nvl(length(ann.c15),0)+
               nvl(length(ann.c16),0)+
               nvl(length(ann.c17),0)+
               nvl(length(ann.c18),0)+
               nvl(length(ann.c19),0)+
               nvl(length(ann.c20),0)+
               nvl(length(ann.c21),0)+
               nvl(length(ann.c22),0)+
               nvl(length(ann.c23),0)+
               nvl(length(ann.c24),0)+
               nvl(length(ann.c25),0)+
               nvl(length(ann.c26),0)+
               nvl(length(ann.c27),0)+
               nvl(length(ann.c28),0)+
               nvl(length(ann.c29),0)+
               nvl(length(ann.c30),0) lunghezza_variabili,
               ann.testo_annotazione testo_ann_db
          from civdfa dfa, civann ann
         where dfa.formula		= decode(substr(ann.formula,1,1),
                                        '5','1'||substr(ann.formula,2),
                                        'X','1'||substr(ann.formula,2),
                                            ann.formula)
           and dfa.tipo_atto		= decode(ann.tipo_atto,6,2,7,2,8,2,9,4,-7,2,-9,-4, ann.tipo_atto)
           and ann.id                   = a_id_civann
;

begin

  begin
    select ann.testo_annotazione 
      into w_testo_ann_db
      from civann ann
     where id = a_id_civann
    ;
  exception
    when others then
         w_testo_ann_db := '';
  end;

  if w_testo_ann_db is not null then
     w_testo := w_testo_ann_db;
     goto fine;
  end if;

  begin
    select testo_4000
      into riga_work
      from civtfa
     where formula = decode(substr(a_formula,1,1), 
                       '5','1'||substr(a_formula,2),
                       'X','1'||substr(a_formula,2),
                           a_formula)
       and (riga = 5 and not exists (select 'x' from civtfa 
                                      where formula = decode(substr(a_formula,1,1),
                                                        '5','1'||substr(a_formula,2),
                                                        'X','1'||substr(a_formula,2),
                                                            a_formula)
                                        and riga = 1)
	    or riga = 1)
       and rownum = 1
    ;
  exception
    when others then
   	 riga_work := '';
  end;

  if riga_work is not null then
     conta_variabili	:= 0;
     puntatore_fine	:= 99999;
     for rec in sel_ann loop
       while puntatore_fine > 0 loop
	 begin
	   select instr(riga_work,'#')
   	     into puntatore_fine
             from dual
	   ;
         exception
 	   when others then
	        puntatore_fine := 0;
	 end;
          
 	 if nvl(puntatore_fine,0) > 0 then
            conta_variabili := conta_variabili + 1;
	    begin
	      select substr(riga_work,1,instr(riga_work,'#')-1),
               	     substr(riga_work,instr(riga_work,'#')+1,2),
               	     substr(riga_work,instr(riga_work,'#')+3)
          	into campo_stampa, numero, riga_work
                from dual
	      ;
              select decode(numero,1,rec.c1, 2,rec.c2, 3,rec.c3, 4,rec.c4, 5,rec.c5,
                                   6,rec.c6, 7,rec.c7, 8,rec.c8, 9,rec.c9, 10,rec.c10,
                                   11,rec.c11, 12,rec.c12, 13,rec.c13, 14,rec.c14, 15,rec.c15,
                                   16,rec.c16, 17,rec.c17, 18,rec.c18, 19,rec.c19, 20,rec.c20,
                                   21,rec.c21, 22,rec.c22, 23,rec.c23, 24,rec.c24, 25,rec.c25,
                                   26,rec.c26, 27,rec.c27, 28,rec.c28, 29,rec.c29, 30,rec.c30)
                into campo1
                from dual
	      ;
 	      w_testo := ltrim(w_testo||' '||campo_stampa||campo1);
	    exception
	      when others then
		   w_testo := ltrim(w_testo||' '||campo_stampa);
	    end;
         end if;
       end loop;
     end loop;
     w_testo := w_testo||' '||riga_work;
  else
     w_testo := '';
  end if;

<< fine >>

  return rtrim(ltrim(w_testo));
end;
/
