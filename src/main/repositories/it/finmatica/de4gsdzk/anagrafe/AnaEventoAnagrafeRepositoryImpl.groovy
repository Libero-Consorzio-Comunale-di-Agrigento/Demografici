package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class AnaEventoAnagrafeRepositoryImpl implements AnaEventoAnagrafeCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<AnaEventoAnagrafe> findAllByAnagrafe(AnaAnagrafe anagrafe, Pageable pageable) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()

        CriteriaQuery<AnaEventoAnagrafe> query = cb.createQuery(AnaEventoAnagrafe.class)
        Root<AnaEventoAnagrafe> root = query.from(AnaEventoAnagrafe.class)

        root.fetch("famiglia", JoinType.LEFT)
        //root.fetch("anagrafe", JoinType.LEFT)

        Predicate[] predicates = getPredicates(cb, root, anagrafe)
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
        Root<AnaEventoAnagrafe> countRoot = countQuery.from(AnaEventoAnagrafe.class)

        countRoot.join("famiglia", JoinType.LEFT)

        Predicate[] countPredicates = getPredicates(cb, countRoot, anagrafe)
        countQuery
                .select(cb.count(countRoot))
                .where(cb.and(countPredicates))

        List<AnaEventoAnagrafe> resultList = entityManager.createQuery(query)
                .setFirstResult((int) pageable.getOffset())
                .setMaxResults(pageable.getPageSize())
                .getResultList()
        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(resultList, pageable, count)
    }

    @Override
    long countByAnagrafe(AnaAnagrafe anagrafe) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()

        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<AnaEventoAnagrafe> countRoot = countQuery.from(AnaEventoAnagrafe.class)

        countRoot.join("famiglia", JoinType.LEFT)

        Predicate[] countPredicates = getPredicates(cb, countRoot, anagrafe)
        countQuery
                .select(cb.count(countRoot))
                .where(cb.and(countPredicates))

        Long count = entityManager.createQuery(countQuery).getSingleResult()
        return count
    }

    private Predicate[] getPredicates(CriteriaBuilder cb,
                                      Root<AnaEventoAnagrafe> root,
                                      AnaAnagrafe anagrafe) {
        List<Predicate> predicates = []
        predicates.add(cb.equal(root.get("anagrafe"), anagrafe))

        return predicates.toArray(new Predicate[0])
    }
}
