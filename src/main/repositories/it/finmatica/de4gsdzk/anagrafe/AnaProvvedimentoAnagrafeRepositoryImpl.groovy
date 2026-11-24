package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class AnaProvvedimentoAnagrafeRepositoryImpl implements AnaProvvedimentoAnagrafeCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<AnaProvvedimentoAnagrafe> findAllByAnagrafe(AnaAnagrafe anagrafe, boolean includiPrivati, Pageable pageable) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()

        CriteriaQuery<AnaProvvedimentoAnagrafe> query = cb.createQuery(AnaProvvedimentoAnagrafe.class)
        Root<AnaProvvedimentoAnagrafe> root = query.from(AnaProvvedimentoAnagrafe.class)

        root.fetch("utenteUpd", JoinType.LEFT)
        root.fetch("dettaglioProvvedimento", JoinType.LEFT)
        root.fetch("nazionalita", JoinType.LEFT)
        root.fetch("nazionalitaPrecedente", JoinType.LEFT)
        root.fetch("viaPrecedente", JoinType.LEFT)
        root.fetch("titoloStudioPrecedente", JoinType.LEFT)
        root.fetch("titoloStudio", JoinType.LEFT)
        root.fetch("professionePrecedente", JoinType.LEFT)
        root.fetch("professione", JoinType.LEFT)
        root.fetch("attivitaProfessionalePrecedente", JoinType.LEFT)
        root.fetch("attivitaProfessionale", JoinType.LEFT)
        root.fetch("posizioneProfessionalePrecedente", JoinType.LEFT)
        root.fetch("posizioneProfessionale", JoinType.LEFT)
        root.fetch("rapportoParentelaPrecedente", JoinType.LEFT)
        root.fetch("rapportoParentela", JoinType.LEFT)

        Predicate[] predicates = getPredicates(cb, root, anagrafe, includiPrivati)
        query
                .select(root)
                .where(cb.and(predicates))

        if (pageable.sort) {
            List<Order> ll = []
            for (Sort.Order m : pageable.sort) {
                if (m.direction?.equals(Sort.Direction.DESC)) {
                    ll.add(cb.desc(root.get(m.property)))
                } else {
                    ll.add(cb.asc(root.get(m.property)))
                }
            }
            if (!(ll.isEmpty())) {
                query.orderBy(ll)
            }
        }

        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<AnaProvvedimentoAnagrafe> countRoot = countQuery.from(AnaProvvedimentoAnagrafe.class)

        countRoot.join("utenteUpd", JoinType.LEFT)

        Predicate[] countPredicates = getPredicates(cb, countRoot, anagrafe, includiPrivati)
        countQuery
                .select(cb.count(countRoot))
                .where(cb.and(countPredicates))

        List<AnaProvvedimentoAnagrafe> resultList = entityManager.createQuery(query)
                .setFirstResult((int) pageable.getOffset())
                .setMaxResults(pageable.getPageSize())
                .getResultList()

        if (!resultList.isEmpty()) {
            entityManager.createQuery(
                    "SELECT p FROM AnaProvvedimentoAnagrafe p LEFT JOIN FETCH p.indirizzo.via WHERE p IN :entities",
                    AnaProvvedimentoAnagrafe.class)
                    .setParameter("entities", resultList)
                    .getResultList()
        }

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(resultList, pageable, count)
    }

    @Override
    long countByAnagrafe(AnaAnagrafe anagrafe, boolean includiPrivati) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()

        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<AnaProvvedimentoAnagrafe> countRoot = countQuery.from(AnaProvvedimentoAnagrafe.class)

        Predicate[] countPredicates = getPredicates(cb, countRoot, anagrafe, includiPrivati)
        countQuery
                .select(cb.count(countRoot))
                .where(cb.and(countPredicates))

        Long count = entityManager.createQuery(countQuery).getSingleResult()
        return count
    }

    private Predicate[] getPredicates(CriteriaBuilder cb,
                                      Root<AnaProvvedimentoAnagrafe> root,
                                      AnaAnagrafe anagrafe,
                                      boolean includiPrivati) {
        List<Predicate> predicates = []
        predicates.add(cb.equal(root.get("anagrafe"), anagrafe))

        if (!includiPrivati) {
            predicates.add(cb.isNull(root.get("privato")))
        }

        return predicates.toArray(new Predicate[0])
    }
}
