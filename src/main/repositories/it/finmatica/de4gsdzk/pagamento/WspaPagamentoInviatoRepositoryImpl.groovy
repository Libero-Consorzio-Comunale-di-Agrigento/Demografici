package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.pagamento.EStatoInvio
import it.finmatica.de4gsdzk.pagamento.RicercaPagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviatoDettaglio
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class WspaPagamentoInviatoRepositoryImpl implements WspaPagamentoInviatoCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<WspaPagamentoInviato> findAll(RicercaPagamentoInviato ricerca, Pageable pageable) {
        CriteriaBuilder cb = entityManager.criteriaBuilder

        // Main query to fetch data
        CriteriaQuery<WspaPagamentoInviato> query = cb.createQuery(WspaPagamentoInviato)
        Root<WspaPagamentoInviato> root = query.from(WspaPagamentoInviato)

        // Apply fetch joins
        addFetchJoins(root)

        // Build predicates for filtering
        List<Predicate> predicates = buildPredicates(ricerca, cb, root)
        query.where(cb.and(predicates.toArray(new Predicate[0])))

        // Apply sorting if provided
        if (pageable.sort) {
            query.orderBy(getOrderList(cb, root, pageable.sort))
        }

        // Execute paginated query
        List<WspaPagamentoInviato> results = entityManager.createQuery(query)
                .setFirstResult((int) pageable.offset)
                .setMaxResults(pageable.pageSize)
                .getResultList()

        // Count query for total elements
        long total = getCount(ricerca, cb)

        return new PageImpl<>(results, pageable, total)
    }

    private void addFetchJoins(Root<WspaPagamentoInviato> root) {
        Fetch<WspaPagamentoInviato, WspaPagamentoInviatoDettaglio> documentiFetch = root.fetch("documenti", JoinType.LEFT)
        Fetch<WspaPagamentoInviatoDettaglio, CerCertificatoEmesso> certificatoEmessoFetch = documentiFetch.fetch("certificatoEmesso", JoinType.LEFT)
        certificatoEmessoFetch.fetch("tipoCertificato", JoinType.LEFT)
        certificatoEmessoFetch.fetch("terminalista", JoinType.LEFT)
    }

    private List<Order> getOrderList(CriteriaBuilder cb, Root<WspaPagamentoInviato> root, Sort sort) {
        List<Order> orderList = new ArrayList<>()
        for (Sort.Order order : sort) {
            if (order.isDescending()) {
                orderList.add(cb.desc(root.get(order.property)))
            } else {
                orderList.add(cb.asc(root.get(order.property)))
            }
        }
        return orderList
    }

    private long getCount(RicercaPagamentoInviato ricerca, CriteriaBuilder cb) {
        CriteriaQuery<Long> countQuery = cb.createQuery(Long)
        Root<WspaPagamentoInviato> countRoot = countQuery.from(WspaPagamentoInviato)

        // Apply joins for count query
        addJoinForCount(countRoot)

        // Build predicates for count query
        List<Predicate> countPredicates = buildPredicates(ricerca, cb, countRoot)
        countQuery.where(cb.and(countPredicates.toArray(new Predicate[0])))

        // Perform count
        countQuery.select(cb.countDistinct(countRoot))
        return entityManager.createQuery(countQuery).getSingleResult()
    }

    private void addJoinForCount(Root<WspaPagamentoInviato> root) {
        Join<WspaPagamentoInviato, WspaPagamentoInviatoDettaglio> documentiJoin = root.join("documenti", JoinType.LEFT)
        Join<WspaPagamentoInviatoDettaglio, CerCertificatoEmesso> certificatoEmessoJoin = documentiJoin.join("certificatoEmesso", JoinType.LEFT)
        certificatoEmessoJoin.join("tipoCertificato", JoinType.LEFT)
        certificatoEmessoJoin.join("terminalista", JoinType.LEFT)
    }

    private List<Predicate> buildPredicates(RicercaPagamentoInviato ricerca, CriteriaBuilder cb, Root<WspaPagamentoInviato> root) {
        List<Predicate> predicates = new ArrayList<>()

        if (ricerca.dataInvioAl != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("dataInvio"), ricerca.dataInvioAl))
        }
        if (ricerca.dataInvioDal != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("dataInvio"), ricerca.dataInvioDal))
        }
        if (ricerca.statoInvio != null) {
            predicates.add(getStatoInvioPredicate(ricerca.statoInvio, cb, root))
        }

        return predicates
    }

    private Predicate getStatoInvioPredicate(EStatoInvio statoInvio, CriteriaBuilder cb, Root<WspaPagamentoInviato> root) {
        switch (statoInvio) {
            case EStatoInvio.INVIATO_CON_SUCCESSO:
                return cb.isTrue(root.get("flagInvio"))
            case EStatoInvio.INVIO_NON_RIUSCITO:
                return cb.isNull(root.get("flagInvio"))
            default:
                return cb.conjunction()
        }
    }
}
