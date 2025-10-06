package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscNotifica
import it.finmatica.de4gsdzk.utils.RicercaNotifica
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class AnscNotificaRepositoryImpl implements AnscNotificaCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<AnscNotifica> listAllByRicerca (RicercaNotifica ricerca, Pageable pageable){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<AnscNotifica> query = cb.createQuery(AnscNotifica.class)
        Root<AnscNotifica> root = query.from(AnscNotifica.class)

        List<Predicate> predicates = new ArrayList<>()

        /*
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
        */

        if (ricerca?.getStatoNotifica() != null){
            predicates.add(cb.equal(root.get("stato"), ricerca.getStatoNotifica()))
        }

        if (ricerca?.getGenereNotifica() != null){
            predicates.add(cb.equal(root.get("genere"), ricerca.getGenereNotifica()))
        }

        if (ricerca?.getDal()){
            predicates.add(cb.greaterThanOrEqualTo(root.get("validoDal"), ricerca.getDal().clearTime()))
        }

        if (ricerca?.getAl()){
            predicates.add(cb.lessThanOrEqualTo(root.get("validoDal"), ricerca.getAl().clearTime()))
        }

        query.where(predicates.toArray(new Predicate[predicates.size()]))

        if (pageable.sort){
            List<Order> ll = []
            for (Sort.Order m: pageable.sort){
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

        List<AnscNotifica> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<AnscNotifica> itemsRootCount = countQuery.from(AnscNotifica.class)
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(lista, pageable, count)
    }

}
