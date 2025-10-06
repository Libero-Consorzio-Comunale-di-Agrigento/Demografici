package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class CivAnnotazioneAttoRepositoryImpl implements CivAnnotazioneAttoCustomRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    Page<CivAnnotazioneAtto> listByParams (Map params){
        int pageSize = params?.pageSize ?: Integer.MAX_VALUE
        int activePage = params?.activePage ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CivAnnotazioneAtto> query = cb.createQuery(CivAnnotazioneAtto.class)
        Root<CivAnnotazioneAtto> root = query.from(CivAnnotazioneAtto.class)

        List<Predicate> predicates = new ArrayList<>()

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

        if (params?.tipoAtto != null){
            predicates.add(cb.equal(root.get("tipoAtto"), params?.tipoAtto))
        }

        if (params?.tipiAtto != null){
            predicates.add(cb.in(root.get("tipoAtto"), params?.tipiAtto))
        }

        if (params?.ufficio != null) {
            predicates.add(cb.equal(root.get("ufficio"), params?.ufficio))
        }

        if (params?.anno != null) {
            predicates.add(cb.equal(root.get("anno"), params?.anno))
        }

        if (params?.atto != null) {
            predicates.add(cb.equal(root.get("atto"), params?.atto))
        }

        if (params?.parte != null) {
            predicates.add(cb.equal(root.get("parte"), params?.parte))
        }

        if (params?.serie) {
            predicates.add(cb.equal(root.get("serie"), params?.serie))
        }

        if (params?.idAttoAnsc){
            predicates.add(cb.like(cb.lower(root.get("idAttoAnsc")), params.idAttoAnsc.toLowerCase() + "%"))
        }

        if (params?.tipoAttoAnnotazione != null){
            predicates.add(cb.equal(root.get("tipoAttoAnnotazione"), params?.tipoAttoAnnotazione))
        }

        if (params?.formulaDfa){
            predicates.add(cb.equal(root.get("formulaDfa"), params.formulaDfa))
        }

        if (params?.dal){
            predicates.add(cb.greaterThanOrEqualTo(cb.function("TRUNC", Date.class, root.get("dataRegistrazione")), params.dal.clearTime()))
        }

        if (params?.al){
            predicates.add(cb.lessThanOrEqualTo(cb.function("TRUNC", Date.class, root.get("dataRegistrazione")), params.al.clearTime()))
        }

        if (params?.stato){
            predicates.add(cb.equal(root.get("stato"), params.stato))
        }

        if (params?.stati?.size() > 0){
            predicates.add(cb.in(root.get("stato"), params.stati))
        }

        query.where(predicates.toArray(new Predicate[predicates.size()]))

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

        List<CivAnnotazioneAtto> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<CivAnnotazioneAtto> itemsRootCount = countQuery.from(CivAnnotazioneAtto.class)
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(lista, pageable, count)
    }

}
