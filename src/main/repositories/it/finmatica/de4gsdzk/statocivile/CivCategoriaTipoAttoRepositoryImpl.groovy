package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Predicate
import javax.persistence.criteria.Root

class CivCategoriaTipoAttoRepositoryImpl implements CivCategoriaTipoAttoCustomRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    List<CivCategoriaTipoAtto> findAllByTipoAttoAndParteAndSerieAndNatura(Integer tipoAtto, Integer parte, String serie, ENaturaAtto natura, Map params){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<CivCategoriaTipoAtto> query = cb.createQuery(CivCategoriaTipoAtto.class);
        Root<CivCategoriaTipoAtto> root = query.from(CivCategoriaTipoAtto.class);

        List<Predicate> predicates = new ArrayList<>();

        predicates.add(cb.equal(root.get("tipoAtto"), tipoAtto));

        if (parte != null){
            predicates.add(cb.equal(root.get("parte"), parte));
        } else {
            predicates.add(cb.isNull(root.get("parte")));
        }

        if (serie) {
            predicates.add(cb.equal(root.get("serie"), serie));
        } else {
            predicates.add(cb.isNull(root.get("serie")));
        }

        if (params?.divorzio != null) {
            if (params?.divorzio) {
                predicates.add(cb.equal(root.get("divorzio"), Boolean.TRUE))
            } else {
                predicates.add(cb.isNull(root.get("divorzio")))
            }
        }

        if (params.flagAnsc != null) {
            if (params.flagAnsc) {
                predicates.add(cb.isTrue(root.get("flagAnsc")))
            } else {
                predicates.add(cb.isNull(root.get("flagAnsc")))
            }
        }

        predicates.add(cb.or(
            cb.equal(root.get("natura"), natura),
            cb.isNull(root.get("natura"))
        ))

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

        return entityManager.createQuery(query).getResultList()
    }

}
