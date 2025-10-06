package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import it.finmatica.de4gsdzk.utils.ETipoEvento
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class CivTipoAttoRepositoryImpl implements CivTipoAttoCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    List<CivTipoAtto> findAllByTipoAttoAndParteAndSerieAndNatura(Integer tipoAtto, Integer parte, String serie, ENaturaAtto natura){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CivTipoAtto> query = cb.createQuery(CivTipoAtto.class)
        Root<CivTipoAtto> root = query.from(CivTipoAtto.class)

        List<Predicate> predicates = new ArrayList<>()

        predicates.add(cb.equal(root.get("tipoAtto"), tipoAtto))

        if (parte != null){
            predicates.add(cb.equal(root.get("parte"), parte))
        } else {
            predicates.add(cb.isNull(root.get("parte")))
        }

        if (serie) {
            predicates.add(cb.equal(root.get("serie"), serie))
        } else {
            predicates.add(cb.isNull(root.get("serie")))
        }

        predicates.add(cb.equal(root.get("natura"), natura))

        query.where(predicates.toArray(new Predicate[predicates.size()]))

        return entityManager.createQuery(query).getResultList()
    }

    @Override
    Page<CivTipoAtto> listByParams (Integer tipoAtto, Map params){
        int pageSize = params?.pageSize ?: Integer.MAX_VALUE
        int activePage = params?.activePage ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<CivTipoAtto> query = cb.createQuery(CivTipoAtto.class);
        Root<CivTipoAtto> root = query.from(CivTipoAtto.class);

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

        if (params?.filtro) {
            predicates.add(cb.or(
                cb.like(cb.lower(root.get("descrizione")), "%" + params.filtro.toLowerCase() + "%"),
                cb.like(cb.lower(root.get("serie")), "%" + params.filtro.toLowerCase() + "%"),
                cb.like(cb.lower(root.get("descrizioneEstesa")), "%" + params.filtro.toLowerCase() + "%")
            ))
        }

        if (params?.natura?.size() > 0){
            predicates.add(cb.in(root.get("natura"), params.natura));
        }

        if (params?.idCategoria != null){
            predicates.add(cb.equal(root.get("categoriaDomain").get("id"), params.idCategoria))
        }

        if (params?.codiceMinuta != null){
            predicates.add(cb.equal(root.get("codiceMinuta"), params.codiceMinuta))
        }

        if (params.senzaFormule){
            predicates.add(cb.isNull(root.get("categoriaDomain").get("flagFormule")))
        }

        if (params.flagAnsc != null) {
            if (params.flagAnsc) {
                predicates.add(cb.isTrue(root.get("flagAnsc")))
            } else {
                predicates.add(cb.isNull(root.get("flagAnsc")))
            }
        }

        if (params.selectedTipoEvento != null) {
            if ((params.selectedTipoEvento as ETipoEvento) in [ETipoEvento.Divorzio, ETipoEvento.Scioglimento]) {
                predicates.add(cb.isTrue(root.get("divorzio")))
            } else {
                predicates.add(cb.isNull(root.get("divorzio")))
            }
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

        List<CivTipoAtto> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class);
        Root<CivTipoAtto> itemsRootCount = countQuery.from(CivTipoAtto.class);
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult();

        return new PageImpl<>(lista, pageable, count);
    }

}
