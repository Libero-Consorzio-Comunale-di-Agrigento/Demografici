package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class AnaArchivioComunicazioneRepositoryImpl implements AnaArchivioComunicazioneCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    List<AnaArchivioComunicazione> listAllByUkPratica(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica, Integer numeroPratica, Integer annoPratica, Map params) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<AnaArchivioComunicazione> query = cb.createQuery(AnaArchivioComunicazione.class)
        Root<AnaArchivioComunicazione> root = query.from(AnaArchivioComunicazione.class)

        List<Predicate> predicates = new ArrayList<>()

        if (params?.fetch) {
            for (Map f : params.fetch) {
                JoinType tipo = (f.tipo ?: JoinType.INNER)
                List<String> sa = f.campo.tokenize(".")
                Fetch fe = root.fetch(sa[0], tipo)
                for (int i = 1; i < sa.size(); i ++) {
                    fe = fe.fetch(sa[i], tipo)
                }
            }
        }

        predicates.add(cb.equal(root.get("archivioAnagrafe"), archivioAnagrafe))
        predicates.add(cb.equal(root.get("tipoPratica"), tipoPratica))
        predicates.add(cb.equal(root.get("numeroPratica"), numeroPratica))
        predicates.add(cb.equal(root.get("annoPratica"), annoPratica))


        if (params?.stampaEseguita != null) {
            predicates.add(cb.equal(root.get("stampaEseguita"), params?.stampaEseguita))
        }

        if (params?.priorita != null) {
            if (params.priorita) {
                predicates.add(cb.isTrue(root.get("comunicazione").get("priorita")))
            } else {
                predicates.add(cb.isNull(root.get("comunicazione").get("priorita")))
            }
        }

        if(params?.pratica != null) {
            predicates.add(cb.isNull(root.get("comunicazione").get("flagSoggetto")))
        }

        query.where(predicates.toArray(new Predicate[predicates.size()]))

        if ((params?.order?.size ?: 0) > 0) {
            List<javax.persistence.criteria.Order> ll = []
            for (Sort.Order m : params?.order) {
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

        return entityManager.createQuery(query).getResultList()
    }

    @Override
    Page<AnaArchivioComunicazione> listByParams(Map params) {
        int pageSize = params?.pageSize ?: Integer.MAX_VALUE
        int activePage = params?.activePage ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<AnaArchivioComunicazione> query = cb.createQuery(AnaArchivioComunicazione.class)
        Root<AnaArchivioComunicazione> root = query.from(AnaArchivioComunicazione.class)

        List<Predicate> predicates = new ArrayList<>()

        if (params?.fetch) {
            for (Map f : params.fetch) {
                JoinType tipo = (f.tipo ?: JoinType.INNER)
                List<String> sa = f.campo.tokenize(".")
                Fetch fe = root.fetch(sa[0], tipo)
                for (int i = 1; i < sa.size(); i ++) {
                    fe = fe.fetch(sa[i], tipo)
                }
            }
        }

        if (params?.stampaEseguita != null) {
            predicates.add(cb.equal(root.get("stampaEseguita"), params?.stampaEseguita))
        }

        if (params?.idCom != null) {
            predicates.add(cb.equal(root.get("comunicazione").get("id"), params?.idCom))
        }

        if (params?.idsCom?.size() > 0) {
            predicates.add(cb.in(root.get("comunicazione").get("id"), params?.idsCom))
        }

        if (params?.statoProtocollazione) {
            predicates.add(cb.equal(root.get("statoProtocollazione"), params?.statoProtocollazione))
        }

        if (params?.soloDaStampare) {
            predicates.add(cb.notEqual(root.get("statoProtocollazione"), EStatoProtocollazione.D))
            predicates.add(cb.notEqual(root.get("statoProtocollazione"), EStatoProtocollazione.P))
        }

        query.where(predicates.toArray(new Predicate[predicates.size()]))

        if ((params?.order?.size ?: 0) > 0) {
            List<javax.persistence.criteria.Order> ll = []
            for (Sort.Order m : params?.order) {
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

        List<AnaArchivioComunicazione> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<AnaArchivioComunicazione> itemsRootCount = countQuery.from(AnaArchivioComunicazione.class)
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(lista, pageable, count)
    }

}
