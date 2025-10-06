package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.certificazione.CerAnagrafeFiltro
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.certificazione.ECompetenzaCertificazione
import it.finmatica.de4gsdzk.utils.CerAnagrafeFiltroPredicateUtils
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class CerCategoriaTipoCertificatoRepositoryImpl implements CerCategoriaTipoCertificatoCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    //TODO: verify return type
    @Override
    List<String> listByParams(Map params) {
        if (!params?.anagrafeFiltroList) {
            throw new IllegalArgumentException('anagrafeFiltroList is required')
        }
        if (params?.competenzaCertificazioneSet == null) {
            throw new IllegalArgumentException('competenzaCertificazioneSet is required')
        }
        Set<ECompetenzaCertificazione> competenzaCertificazioneSet = params.competenzaCertificazioneSet as Set<ECompetenzaCertificazione>
        if (competenzaCertificazioneSet.isEmpty()) {
            return []
        }

        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<String> query = cb.createQuery(String.class)
        Root<CerTipoCertificato> root = query.from(CerTipoCertificato.class)

        // Select distinct values
        query.select(root.get("categoriaTipoCertificato")).distinct(true)

        Predicate wherePredicate = CerAnagrafeFiltroPredicateUtils.buildWherePredicate(cb, root, params.anagrafeFiltroList as List<CerAnagrafeFiltro>)

        Join<CerTipoCertificato, CerCategoriaTipoCertificato> categoriaJoin = root.join("categoriaTipoCertificato")

        Predicate competenzaPredicate = categoriaJoin.get("competenzaCertificazione").in(competenzaCertificazioneSet)

        query.where(cb.and(wherePredicate, competenzaPredicate))

        if ((params?.order?.size ?: 0) > 0) {
            List<javax.persistence.criteria.Order> ll = []
            for (Sort.Order m : params?.order) {
                if (m.direction?.equals(Sort.Direction.DESC)) {
                    ll.add(cb.desc(categoriaJoin.get(m.property)))
                } else {
                    ll.add(cb.asc(categoriaJoin.get(m.property)))
                }
            }
            if (!(ll.isEmpty())) {
                query.orderBy(ll)
            }
        }

        // Fetch distinct results without pagination
        List<String> lista = entityManager.createQuery(query).getResultList()

        return lista;
    }

}
