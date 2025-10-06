package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.certificazione.CerAnagrafeFiltro
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato

import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.Predicate
import javax.persistence.criteria.Root

class CerAnagrafeFiltroPredicateUtils {
    static Predicate buildWherePredicate(CriteriaBuilder cb, Root<CerTipoCertificato> root, List<CerAnagrafeFiltro> anagrafeFiltroList) {
        List<Predicate> predicates = new ArrayList<>();
        for (CerAnagrafeFiltro anagrafeFiltro : anagrafeFiltroList) {
            Predicate predCategoria = cb.equal(root.get("categoriaTipoCertificato"), anagrafeFiltro.categoriaTipoCertificato)

            Predicate predTipoArchivio = cb.equal(root.get("tipoArchivio"), anagrafeFiltro.tipoArchivio)

            Predicate predFiltro;
            if (anagrafeFiltro.filtro != null) {
                predFiltro = cb.equal(root.get("filtro"), anagrafeFiltro.filtro);
            } else {
                predFiltro = cb.isNull(root.get("filtro"));
            }

            Predicate predCodiceControllo;
            if (anagrafeFiltro.codiceControllo != null) {
                predCodiceControllo = cb.equal(root.get("codiceControllo"), anagrafeFiltro.codiceControllo);
            } else {
                predCodiceControllo = cb.isNull(root.get("codiceControllo"));
            }

            Predicate predNotDismesso = cb.isNull(root.get('flagDismesso'))
            predicates.add(cb.and(predCategoria, predTipoArchivio, predFiltro, predCodiceControllo, predNotDismesso));
        }
        return cb.or(predicates.toArray(new Predicate[predicates.size()]))
    }
}
