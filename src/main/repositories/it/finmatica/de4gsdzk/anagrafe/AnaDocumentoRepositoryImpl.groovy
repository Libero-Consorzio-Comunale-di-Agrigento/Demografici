package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class AnaDocumentoRepositoryImpl implements AnaDocumentoCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<AnaDocumento> findAllByAnagrafe(RicercaDocumento r, Pageable pageable) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()

        CriteriaQuery<AnaDocumento> query = cb.createQuery(AnaDocumento.class)
        Root<AnaDocumento> root = query.from(AnaDocumento.class)

        root.fetch("anagrafe", JoinType.INNER)
        root.fetch("tipoDocumento", JoinType.INNER)
        root.fetch("allegati", JoinType.LEFT)
        root.fetch("ente", JoinType.LEFT)
        root.fetch("categoria", JoinType.LEFT)
        root.fetch("motivoRilascio", JoinType.LEFT)

        Predicate[] predicates = getPredicates(cb, root, r)
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
        Root<AnaDocumento> countRoot = countQuery.from(AnaDocumento.class)

        countRoot.join("anagrafe", JoinType.INNER)
        countRoot.join("tipoDocumento", JoinType.INNER)
        countRoot.join("allegati", JoinType.LEFT)
        countRoot.join("ente", JoinType.LEFT)

        Predicate[] countPredicates = getPredicates(cb, countRoot, r)
        countQuery
                .select(cb.count(countRoot))
                .where(cb.and(countPredicates))

        List<AnaDocumento> resultList = entityManager.createQuery(query)
                .setFirstResult((int) pageable.getOffset())
                .setMaxResults(pageable.getPageSize())
                .getResultList()
        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(resultList, pageable, count)
    }

    @Override
    long countByAnagrafe(RicercaDocumento r) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()

        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<AnaDocumento> countRoot = countQuery.from(AnaDocumento.class)

        countRoot.join("anagrafe", JoinType.INNER)
        countRoot.join("tipoDocumento", JoinType.INNER)

        Predicate[] countPredicates = getPredicates(cb, countRoot, r)
        countQuery
                .select(cb.count(countRoot))
                .where(cb.and(countPredicates))

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return count
    }


    @Override
    List<AnaDocumento> listAllByAnagrafe(RicercaDocumento r) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()

        CriteriaQuery<AnaDocumento> query = cb.createQuery(AnaDocumento.class)
        Root<AnaDocumento> root = query.from(AnaDocumento.class)

        root.fetch("anagrafe", JoinType.INNER)
        root.fetch("tipoDocumento", JoinType.INNER)
        root.fetch("allegati", JoinType.LEFT)
        root.fetch("ente", JoinType.LEFT)
        root.fetch("categoria", JoinType.LEFT)
        root.fetch("motivoRilascio", JoinType.LEFT)

        Predicate[] predicates = getPredicates(cb, root, r)
        Join<AnaDocumento, AnaTipoDocumento> tipoDocumentoJoin = root.join("tipoDocumento", JoinType.INNER)

        query
                .select(root)
                .where(cb.and(predicates))
                .orderBy(cb.asc(tipoDocumentoJoin.get("descrizione")))

        List<AnaDocumento> list = entityManager.createQuery(query).getResultList()
        return new ArrayList<>(new LinkedHashSet<>(list))

    }

    private Predicate[] getPredicates(CriteriaBuilder cb, Root<AnaDocumento> root, RicercaDocumento r) {
        List<Predicate> predicates = []
        predicates.add(cb.equal(root.get("anagrafe"), r.anagrafe))

        Set<Join> joins = root.getJoins()
        Join<AnaDocumento, AnaTipoDocumento> tipoDocumentoJoin = joins.find { it.attribute.name == 'tipoDocumento' }
        if (tipoDocumentoJoin == null) {
            tipoDocumentoJoin = root.join("tipoDocumento", JoinType.INNER)
        }

        Predicate noFlags = cb.and(
                cb.isNull(tipoDocumentoJoin.get("flagStranieri")),
                cb.isNull(tipoDocumentoJoin.get("flagIdentita"))
        )
        Predicate hasFlags = cb.or(
                cb.isNotNull(tipoDocumentoJoin.get("flagStranieri")),
                cb.isNotNull(tipoDocumentoJoin.get("flagIdentita"))
        )
        if (r.storico) {
            predicates.add(cb.and(hasFlags, cb.greaterThan(root.get("progressivo"), 1)))
        } else {
            predicates.add(cb.or(noFlags, cb.and(hasFlags, cb.equal(root.get("progressivo"), 1))))
        }

        if (r.convivenzaDiFatto) {
            predicates.add(cb.isNotNull(tipoDocumentoJoin.get("flagConvivenzaDiFatto")))
        } else {
            predicates.add(cb.isNull(tipoDocumentoJoin.get("flagConvivenzaDiFatto")))
        }

        return predicates.toArray(new Predicate[0])
    }
}
