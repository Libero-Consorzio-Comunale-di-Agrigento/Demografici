package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoOrdinamentoAnnotazione
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Predicate
import javax.persistence.criteria.Root

class CivFormulaAnnotazioneRepositoryImpl implements CivFormulaAnnotazioneCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<CivFormulaAnnotazione> listByParams (Map params){
        int pageSize = params?.pageSize ?: Integer.MAX_VALUE
        int activePage = params?.activePage ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<CivFormulaAnnotazione> query = cb.createQuery(CivFormulaAnnotazione.class);
        Root<CivFormulaAnnotazione> root = query.from(CivFormulaAnnotazione.class);

        List<Predicate> predicates = new ArrayList<>();

        if (params?.tipoAtto){
            predicates.add(cb.equal(root.get("tipoAtto"), params?.tipoAtto));
        }

        if (params?.tipiAnnotazione?.size() > 0){
            predicates.add(cb.in(root.get("tipoAnnotazione"), params.tipiAnnotazione))
        }

        if (params?.tipoOrdinamento){
            if (params.tipoOrdinamento == ETipoOrdinamentoAnnotazione.Nuovo_Ordinamento){
                predicates.add(cb.in(root.get("nuovoOrdinamento"), Boolean.TRUE))
            }
            if (params.tipoOrdinamento == ETipoOrdinamentoAnnotazione.Vecchio_Ordinamento){
                predicates.add(cb.in(root.get("nuovoOrdinamento"), Boolean.FALSE))
            }
        }

        if (params?.filtro) {
            predicates.add(cb.or(
                cb.like(cb.lower(root.get("id")), "%" + params.filtro.toLowerCase() + "%"),
                cb.like(cb.lower(root.get("descrizione")), "%" + params.filtro.toLowerCase() + "%")
            ))
        }

        if (params?.filtroEsteso) {
            predicates.add(cb.or(
                    cb.like(cb.lower(root.get("id")), params.filtroEsteso.toLowerCase()),
                    cb.like(cb.lower(root.get("descrizione")), params.filtroEsteso.toLowerCase()),
                    cb.like(cb.lower(root.get("descrizioneEstesa")), params.filtroEsteso.toLowerCase())
            ))
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

        List<CivFormulaAnnotazione> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class);
        Root<CivFormulaAnnotazione> itemsRootCount = countQuery.from(CivFormulaAnnotazione.class);
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult();

        return new PageImpl<>(lista, pageable, count);
    }

}
