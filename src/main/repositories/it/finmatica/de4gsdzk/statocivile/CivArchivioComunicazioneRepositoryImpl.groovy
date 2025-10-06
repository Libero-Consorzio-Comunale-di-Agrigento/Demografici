package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivArchivioComunicazione
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class CivArchivioComunicazioneRepositoryImpl implements CivArchivioComunicazioneCustomRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    List<CivArchivioComunicazione> findAllByUkAttoAndTipoAtto(Integer tipoAtto, Integer ufficio, Integer anno, Integer atto, Integer parte, String serie, Map params){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<CivArchivioComunicazione> query = cb.createQuery(CivArchivioComunicazione.class);
        Root<CivArchivioComunicazione> root = query.from(CivArchivioComunicazione.class);

        List<Predicate> predicates = new ArrayList<>();

        if (params?.fetch){
            for (Map f : params.fetch) {
                JoinType tipo = (f.tipo?:JoinType.INNER)
                List<String> sa = f.campo.tokenize(".")
                Fetch fe = root.fetch(sa[0], tipo)
                for (int i = 1; i < sa.size(); i++) {
                    fe = fe.fetch(sa[i], tipo)
                }
            }
        }

        predicates.add(cb.equal(root.get("tipoAtto"), tipoAtto));

        if (ufficio != null){
            predicates.add(cb.equal(root.get("ufficio"), ufficio));
        } else {
            predicates.add(cb.isNull(root.get("ufficio")));
        }

        if (anno != null){
            predicates.add(cb.equal(root.get("anno"), anno));
        } else {
            predicates.add(cb.isNull(root.get("anno")));
        }

        if (atto != null){
            predicates.add(cb.equal(root.get("atto"), atto));
        } else {
            predicates.add(cb.isNull(root.get("atto")));
        }

        if (parte != null){
            predicates.add(cb.equal(root.get("parte"), parte));
        } else {
            predicates.add(cb.isNull(root.get("parte")));
        }

        if (serie){
            predicates.add(cb.equal(root.get("serie"), serie));
        } else {
            predicates.add(cb.isNull(root.get("serie")));
        }

        if (params?.stampaEseguita != null){
            predicates.add(cb.equal(root.get("stampaEseguita"), params?.stampaEseguita));
        }

        if (params?.idAttoRif){
            predicates.add(cb.equal(root.get("idAttoRif"), params.idAttoRif));
        }

        if (params?.formulaDfa){
            predicates.add(cb.equal(root.get("formulaDfa").get("id"), params.formulaDfa));
        }

        if (params?.priorita != null){
            predicates.add(cb.equal(root.get("comunicazione").get("priorita"), params.priorita));
        }

        query.where(predicates.toArray(new Predicate[predicates.size()]));

        if ((params?.order?.size?:0) > 0){
            List<javax.persistence.criteria.Order> ll = []
            for (Sort.Order m: params?.order){
                if (m.direction?.equals(Sort.Direction.DESC)){
                    ll.add(cb.desc(root.get(m.property)))
                } else {
                    ll.add(cb.asc(root.get(m.property)))
                }
            }
            if (!(ll.isEmpty())){
                query.orderBy(ll)
            }
        }

        return entityManager.createQuery(query).getResultList()
    }

    @Override
    Page<CivArchivioComunicazione> listByParams (Map params){
        int pageSize = params?.pageSize ?: Integer.MAX_VALUE
        int activePage = params?.activePage ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<CivArchivioComunicazione> query = cb.createQuery(CivArchivioComunicazione.class);
        Root<CivArchivioComunicazione> root = query.from(CivArchivioComunicazione.class);

        List<Predicate> predicates = new ArrayList<>();

        if (params?.fetch){
            for (Map f : params.fetch) {
                JoinType tipo = (f.tipo?:JoinType.INNER)
                List<String> sa = f.campo.tokenize(".")
                Fetch fe = root.fetch(sa[0], tipo)
                for (int i = 1; i < sa.size(); i++) {
                    fe = fe.fetch(sa[i], tipo)
                }
            }
        }

        if (params?.tipoAtto){
            predicates.add(cb.equal(root.get("tipoAtto"), params?.tipoAtto));
        }

        if (params?.tipoAttoComunicazione){
            predicates.add(cb.equal(root.get("tipoAttoComunicazione"), params?.tipoAttoComunicazione));
        }

        if (params?.ufficio){
            predicates.add(cb.equal(root.get("ufficio"), params?.ufficio));
        }

        if (params?.anno){
            predicates.add(cb.equal(root.get("anno"), params?.anno));
        }

        if (params?.atto){
            predicates.add(cb.equal(root.get("atto"), params?.atto));
        }

        if (params?.stampaEseguita != null){
            predicates.add(cb.equal(root.get("stampaEseguita"), params?.stampaEseguita));
        }

        if (params?.idCom != null){
            predicates.add(cb.equal(root.get("comunicazione").get("id"), params?.idCom));
        }

        if (params?.idsCom?.size() > 0){
            predicates.add(cb.in(root.get("comunicazione").get("id"), params?.idsCom));
        }

        if (params?.statoProtocollazione){
            predicates.add(cb.equal(root.get("statoProtocollazione"), params?.statoProtocollazione));
        }

        if (params?.soloDaStampare){
            predicates.add(cb.notEqual(root.get("statoProtocollazione"), EStatoProtocollazione.D));
            predicates.add(cb.notEqual(root.get("statoProtocollazione"), EStatoProtocollazione.P));
        }

        query.where(predicates.toArray(new Predicate[predicates.size()]));

        if ((params?.order?.size?:0) > 0){
            List<javax.persistence.criteria.Order> ll = []
            for (Sort.Order m: params?.order){
                if (m.direction?.equals(Sort.Direction.DESC)){
                    ll.add(cb.desc(root.get(m.property)))
                } else {
                    ll.add(cb.asc(root.get(m.property)))
                }
            }
            if (!(ll.isEmpty())){
                query.orderBy(ll)
            }
        }

        List<CivArchivioComunicazione> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class);
        Root<CivArchivioComunicazione> itemsRootCount = countQuery.from(CivArchivioComunicazione.class);
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult();

        return new PageImpl<>(lista, pageable, count);
    }

}
