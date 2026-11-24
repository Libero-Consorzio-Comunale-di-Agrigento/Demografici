package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.certificazione.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.Tuple
import javax.persistence.criteria.*

class CerCertificatoEmessoRepositoryImpl implements CerCertificatoEmessoCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    /*******************************
     *  Ricerca Certificato
     ******************************/

    @Override
    Page<CerCertificatoEmesso> findAllByRicercaCertificato(RicercaCertificato r, Pageable pageable) {

        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CerCertificatoEmesso> query = cb.createQuery(CerCertificatoEmesso.class)
        Root<CerCertificatoEmesso> root = query.from(CerCertificatoEmesso.class)
        root.fetch("tipoCertificato", JoinType.LEFT)
        root.fetch("terminalista", JoinType.LEFT)
        root.fetch("modalitaRilascio", JoinType.LEFT)
        Fetch<Object, Object> joinPid = root.fetch("pagamentoInviatoDettaglio", JoinType.LEFT)
        joinPid.fetch("pagamentoInviato", JoinType.LEFT)

        List<Predicate> predicates = CerCertificatoEmessoRepositoryUtils.getPredicatesByRicercaCertificato(cb, root, r)
        query.select(root).where(cb.and(predicates.toArray(new Predicate[0])))

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
        Root<CerCertificatoEmesso> countRoot = countQuery.from(CerCertificatoEmesso.class)
        countRoot.join("tipoCertificato", JoinType.LEFT)
        countRoot.join("terminalista", JoinType.LEFT)
        countRoot.join("modalitaRilascio", JoinType.LEFT)
        Join<Object, Object> countJoinPid = countRoot.join("pagamentoInviatoDettaglio", JoinType.LEFT)
        countJoinPid.join("pagamentoInviato", JoinType.LEFT)

        List<Predicate> countPredicates = CerCertificatoEmessoRepositoryUtils.getPredicatesByRicercaCertificato(cb, countRoot, r)
        countQuery.select(cb.count(countRoot)).where(cb.and(countPredicates.toArray(new Predicate[0])))

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        List<CerCertificatoEmesso> resultList = entityManager.createQuery(query)
                .setFirstResult((int) pageable.getOffset())
                .setMaxResults(pageable.getPageSize())
                .getResultList()

        return new PageImpl<>(resultList, pageable, count)
    }

    /*******************************
     *  Ricerca Certificato Stampa
     ******************************/

    @Override
    Page<CerCertificatoEmesso> findAllByRicercaCertificatoStampa(RicercaCertificatoStampa r, Pageable pageable) {
        CriteriaBuilder cb = entityManager.criteriaBuilder
        CriteriaQuery<CerCertificatoEmesso> query = cb.createQuery(CerCertificatoEmesso)
        Root<CerCertificatoEmesso> root = query.from(CerCertificatoEmesso)

        root.fetch('tipoCertificato', JoinType.LEFT)
        root.fetch('terminalista', JoinType.LEFT)
        root.fetch('modalitaRilascio', JoinType.LEFT)
        root.fetch('tipoPagamento', JoinType.LEFT)
        root.fetch('tipoRichiedente', JoinType.LEFT)

        List<Predicate> predicates = CerCertificatoEmessoRepositoryUtils.getListPredicatesByRicercaCertificatoStampa(cb, root, r)

        query.where(cb.and(predicates.toArray(new Predicate[0])))

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

        List<CerCertificatoEmesso> lista = entityManager.createQuery(query).setFirstResult((int) pageable.offset).setMaxResults(pageable.pageSize).getResultList()

        CriteriaQuery<Long> countQuery = cb.createQuery(Long)
        Root<CerCertificatoEmesso> countRoot = countQuery.from(CerCertificatoEmesso)

        countRoot.join('tipoCertificato', JoinType.LEFT)
        countRoot.join('terminalista', JoinType.LEFT)
        countRoot.join('modalitaRilascio', JoinType.LEFT)
        countRoot.join('tipoPagamento', JoinType.LEFT)

        countQuery.select(cb.count(countRoot))

        ArrayList<Predicate> countPredicates = CerCertificatoEmessoRepositoryUtils.getListPredicatesByRicercaCertificatoStampa(cb, countRoot, r)
        countQuery.where(cb.and(countPredicates.toArray(new Predicate[0])))

        Long total = entityManager.createQuery(countQuery).singleResult

        return new PageImpl<>(lista, pageable, total)
    }

    @Override
    DirittiReport findDirittiByRicercaCertificatoStampa(RicercaCertificatoStampa r) {
        CriteriaBuilder cb = entityManager.criteriaBuilder
        CriteriaQuery<Tuple> query = cb.createTupleQuery()
        Root<CerCertificatoEmesso> root = query.from(CerCertificatoEmesso)

        query.select(cb.tuple(
                cb.sum(root.get('segreteria')).alias("segreteriaSum"),
                cb.sum(root.get('statoCivile')).alias("statoCivileSum"),
                cb.sum(root.get('cartaIdentita')).alias("cartaIdentitaSum"),
                cb.sum(root.get('rimborsoStampati')).alias("rimborsoStampatiSum"),
                cb.sum(root.get('bollo')).alias("bolloSum")
        ))

        List<Predicate> predicates = CerCertificatoEmessoRepositoryUtils.getDirittiPredicatesByRicercaCertificatoStampa(cb, root, r)

        query.where(cb.and(predicates.toArray(new Predicate[0])))

        Tuple result = entityManager.createQuery(query).getSingleResult()

        DirittiReport diritti = new DirittiReport(
                result.get(0, BigDecimal),
                result.get(1, BigDecimal),
                result.get(2, BigDecimal),
                result.get(3, BigDecimal),
                result.get(4, BigDecimal))

        return diritti
    }

    @Override
    DirittiRiepilogoReport findDirittiRiepilogoByRicercaCertificatoStampa(RicercaCertificatoStampa r) {
        CriteriaBuilder cb = entityManager.criteriaBuilder
        CriteriaQuery<Tuple> query = cb.createTupleQuery()
        Root<CerCertificatoEmesso> root = query.from(CerCertificatoEmesso)

        query.select(cb.tuple(
                cb.sum(root.get('segreteria')).alias("segreteriaSum"),
                cb.sum(root.get('statoCivile')).alias("statoCivileSum"),
                cb.sum(root.get('cartaIdentita')).alias("cartaIdentitaSum"),
                cb.sum(root.get('rimborsoStampati')).alias("rimborsoStampatiSum"),
                cb.sum(root.get('bollo')).alias("bolloSum"),
        ))

        List<Predicate> predicates = CerCertificatoEmessoRepositoryUtils.getDirittiRiepilogoPredicatesByRicercaCertificatoStampa(cb, root, r)

        query.where(cb.and(predicates.toArray(new Predicate[0])))

        Tuple result = entityManager.createQuery(query).getSingleResult()

        DirittiRiepilogoReport dirittiRiepilogo = new DirittiRiepilogoReport(
                result.get(0, BigDecimal),
                result.get(1, BigDecimal),
                result.get(2, BigDecimal),
                result.get(3, BigDecimal),
                result.get(4, BigDecimal),
                r.riepilogo.dataRiepilogoAl
        )

        return dirittiRiepilogo
    }

    @Override
    List<DirittiTipoPagamentoReport> findAllDirittiTipoPagamentoByRicercaCertificatoStampa(RicercaCertificatoStampa r) {
        CriteriaBuilder cb = entityManager.criteriaBuilder
        CriteriaQuery<Tuple> query = cb.createTupleQuery()
        Root<CerCertificatoEmesso> root = query.from(CerCertificatoEmesso)
        Join<CerCertificatoEmesso, CerTipoPagamento> join = root.join("tipoPagamento", JoinType.INNER)

        query.select(cb.tuple(
                cb.sum(root.get('segreteria')).alias("segreteriaSum"),
                cb.sum(root.get('statoCivile')).alias("statoCivileSum"),
                cb.sum(root.get('cartaIdentita')).alias("cartaIdentitaSum"),
                cb.sum(root.get('rimborsoStampati')).alias("rimborsoStampatiSum"),
                cb.sum(root.get('bollo')).alias("bolloSum"),
                join
        ))

        List<Predicate> predicates = CerCertificatoEmessoRepositoryUtils.getDirittiPredicatesByRicercaCertificatoStampa(cb, root, r)

        query.where(cb.and(predicates.toArray(new Predicate[0])))

        // TODO: calcola automaticamente i campi della group by
        query.groupBy(join.get('id'), join.get('descrizione'), join.get('flagPagamentoPagoPA'))

        List<Tuple> results = entityManager.createQuery(query).getResultList()

        return results.collect { row ->
            new DirittiTipoPagamentoReport(
                    row.get(0, BigDecimal),
                    row.get(1, BigDecimal),
                    row.get(2, BigDecimal),
                    row.get(3, BigDecimal),
                    row.get(4, BigDecimal),
                    row.get(5, CerTipoPagamento)
            )
        }
    }

}
