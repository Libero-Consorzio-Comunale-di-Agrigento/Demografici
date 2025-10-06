package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazione
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Predicate
import javax.persistence.criteria.Root

class CivSoggettoAnnotazioneRepositoryImpl implements CivSoggettoAnnotazioneCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<CivSoggettoAnnotazione> listByParams (Map params){
        int pageSize = params?.pageSize ?: Integer.MAX_VALUE
        int activePage = params?.activePage ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CivSoggettoAnnotazione> query = cb.createQuery(CivSoggettoAnnotazione.class)
        Root<CivSoggettoAnnotazione> root = query.from(CivSoggettoAnnotazione.class)

        List<Predicate> predicates = new ArrayList<>()

        if (params?.tipoComune != null){
            predicates.add(cb.equal(root.get("tipoComune"), params.tipoComune))
        }

        if (params?.idAtto){
            predicates.add(cb.equal(root.get("idAtto"), params.idAtto))
        }

        if (params?.tipoFormula){
            predicates.add(cb.equal(root.get("tipoFormula"), params.tipoFormula))
        }

        if (params?.tipoAtto != null){
            predicates.add(cb.equal(root.get("tipoAtto"), params.tipoAtto))
        }

        if (params?.tipoAttoAnnotazione != null){
            predicates.add(cb.equal(root.get("tipoAttoAnnotazione"), params.tipoAttoAnnotazione))
        }

        if (params?.tipoAttoRif){
            predicates.add(cb.equal(root.get("tipoAttoRif"), params?.tipoAttoRif))
        }

        if (params?.ufficio != null){
            predicates.add(cb.equal(root.get("ufficio"), params?.ufficio))
        }

        if (params?.anno != null){
            predicates.add(cb.equal(root.get("anno"), params?.anno))
        }

        if (params?.atto != null){
            predicates.add(cb.equal(root.get("atto"), params?.atto))
        }

        if (params?.parte != null){
            predicates.add(cb.equal(root.get("parte"), params?.parte))
        }

        if (params?.serie){
            predicates.add(cb.equal(root.get("serie"), params?.serie))
        }

        if (params?.idAttoAnsc){
            predicates.add(cb.like(cb.lower(root.get("idAttoAnsc")), params.idAttoAnsc.toLowerCase() + "%"))
        }

        if (params?.cognome){
            predicates.add(cb.or(
                    cb.like(cb.lower(root.get("cognome")), params.cognome.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("cognome2")), params.cognome.toLowerCase() + "%")
            ))
        }

        if (params?.nome){
            predicates.add(cb.or(
                    cb.like(cb.lower(root.get("nome")), params.nome.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("nome2")), params.nome.toLowerCase() + "%")
            ))
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

        List<CivSoggettoAnnotazione> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<CivSoggettoAnnotazione> itemsRootCount = countQuery.from(CivSoggettoAnnotazione.class)
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(lista, pageable, count)
    }

    @Override
    List<CivSoggettoAnnotazione> findAllByIdAttoAndTipoFormula(String identificativoAtto, String tipoFormula){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CivSoggettoAnnotazione> query = cb.createQuery(CivSoggettoAnnotazione.class)
        Root<CivSoggettoAnnotazione> root = query.from(CivSoggettoAnnotazione.class)

        List<Predicate> predicates = new ArrayList<>()

        predicates.add(cb.equal(root.get("idAtto"), identificativoAtto))

        predicates.add(cb.equal(root.get("tipoFormula"), tipoFormula))

        query.where(predicates.toArray(new Predicate[predicates.size()]))

        return entityManager.createQuery(query).getResultList()
    }

}
