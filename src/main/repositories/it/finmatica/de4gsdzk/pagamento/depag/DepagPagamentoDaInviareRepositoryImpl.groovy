package it.finmatica.de4gsdzk.pagamento.depag

import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.CerTipoPagamento
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviare
import it.finmatica.de4gsdzk.certificazione.RicercaCertificato
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class DepagPagamentoDaInviareRepositoryImpl implements DepagPagamentoDaInviareCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<DepagPagamentoDaInviare> findAllByRicercaCertificato(RicercaCertificato r, Pageable pageable) {
        CriteriaBuilder cb = entityManager.criteriaBuilder
        CriteriaQuery<DepagPagamentoDaInviare> query = cb.createQuery(DepagPagamentoDaInviare)
        Root<DepagPagamentoDaInviare> root = query.from(DepagPagamentoDaInviare)

        root.fetch("servizio", JoinType.LEFT)
        Fetch<Object, CerCertificatoEmesso> certificatoEmessoFetch = root.fetch("certificatoEmesso", JoinType.LEFT)
        certificatoEmessoFetch.fetch("tipoCertificato", JoinType.LEFT)
        certificatoEmessoFetch.fetch("terminalista", JoinType.LEFT)

        Join<Object, CerCertificatoEmesso> certificatoEmessoJoin = root.join("certificatoEmesso")
        Join<CerCertificatoEmesso, CerTipoPagamento> tipoPagamentoJoin = certificatoEmessoJoin.join("tipoPagamento")

        List<Predicate> predicates = buildPredicates(r, cb, tipoPagamentoJoin, certificatoEmessoJoin)

        query.where(cb.and(predicates.toArray(new Predicate[0])))

        if (pageable.sort) {
            List<Order> ll = []
            for (Sort.Order m : pageable.sort) {
                if (m.direction?.equals(Sort.Direction.DESC)) {
                    ll.add(cb.desc(certificatoEmessoJoin.get(m.property)))
                } else {
                    ll.add(cb.asc(certificatoEmessoJoin.get(m.property)))
                }
            }
            if (!(ll.isEmpty())) {
                query.orderBy(ll)
            }
        }

        List<DepagPagamentoDaInviare> lista = entityManager.createQuery(query).setFirstResult((int) pageable.offset).setMaxResults(pageable.pageSize).getResultList()

        CriteriaQuery<Long> countQuery = cb.createQuery(Long)
        Root<DepagPagamentoDaInviare> countRoot = countQuery.from(DepagPagamentoDaInviare)

        Join<Object, CerCertificatoEmesso> certificatoEmessoCountJoin = countRoot.join("certificatoEmesso")
        Join<CerCertificatoEmesso, CerTipoPagamento> tipoPagamentoCountJoin = certificatoEmessoCountJoin.join("tipoPagamento")

        List<Predicate> predicatesCount = buildPredicates(r, cb, tipoPagamentoCountJoin, certificatoEmessoCountJoin)

        countQuery.select(cb.count(countRoot))
        countQuery.where(cb.and(predicatesCount.toArray(new Predicate[0])))
        Long total = entityManager.createQuery(countQuery).singleResult

        return new PageImpl<>(lista, pageable, total)
    }

    private ArrayList<Predicate> buildPredicates(RicercaCertificato r,
                                                 CriteriaBuilder cb,
                                                 Join<CerCertificatoEmesso, CerTipoPagamento> tipoPagamentoJoin,
                                                 Join<Object, CerCertificatoEmesso> certificatoEmessoJoin) {
        List<Predicate> predicates = new ArrayList<>()

        if (r.dataEmissioneDal) {
            predicates << cb.greaterThanOrEqualTo(certificatoEmessoJoin.get('dataEmissione'), r.dataEmissioneDal)
        }
        if (r.dataEmissioneAl) {
            predicates << cb.lessThanOrEqualTo(certificatoEmessoJoin.get('dataEmissione'), r.dataEmissioneAl)
        }
        if (r.terminalista) {
            predicates << cb.equal(certificatoEmessoJoin.get('terminalista'), r.terminalista)
        }

        predicates << cb.equal(tipoPagamentoJoin.get('flagPagamentoPagoPA'), true)

        return predicates
    }
}
