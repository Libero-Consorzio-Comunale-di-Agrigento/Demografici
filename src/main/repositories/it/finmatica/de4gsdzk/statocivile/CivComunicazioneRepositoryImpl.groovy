package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneFormula
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class CivComunicazioneRepositoryImpl implements CivComunicazioneCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<CivComunicazione> listByParams(Map params) {
        int pageSize = params?.pageSize ?: Integer.MAX_VALUE
        int activePage = params?.activePage ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CivComunicazione> query = cb.createQuery(CivComunicazione.class)
        Root<CivComunicazione> root = query.from(CivComunicazione.class)

        List<Predicate> predicates = new ArrayList<>()

        if (params?.tipoComunicazione != null) {
            predicates.add(cb.equal(root.get("tipoComunicazione"), params.tipoComunicazione))
        }

        if (params?.tipoAtto != null) {
            Subquery<CivComunicazioneAtto> subquery = query.subquery(CivComunicazioneAtto.class)
            Root<CivComunicazioneAtto> ca = subquery.from(CivComunicazioneAtto.class)
            subquery.select(ca.get("comunicazione")).where(cb.equal(ca.get("tipoAtto"), params.tipoAtto))
            predicates.add(cb.in(root.get("id")).value(subquery))
        }

        if (params?.idFormulaDfa) {
            Subquery<CivComunicazioneFormula> subquery = query.subquery(CivComunicazioneFormula.class)
            Root<CivComunicazioneFormula> ca = subquery.from(CivComunicazioneFormula.class)
            subquery.select(ca.get("comunicazione")).where(cb.equal(ca.get("formula").get("id"), params.idFormulaDfa))
            predicates.add(cb.in(root.get("id")).value(subquery))
        }

        if ((params?.filtro != null) && (params?.filtro != "") ){
            try{
                predicates.add(cb.equal(root.get("id"), new Integer(Integer.parseInt(params.filtro)) ))
            } catch (NumberFormatException e){
                predicates.add(cb.like(cb.lower(root.get("descrizione")), "%" + params.filtro.toLowerCase() + "%"))
            }
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

        List<CivComunicazione> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<CivComunicazione> itemsRootCount = countQuery.from(CivComunicazione.class)
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(lista, pageable, count)
    }

}
