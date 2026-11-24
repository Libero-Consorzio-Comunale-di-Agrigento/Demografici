package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class CivMatrimonioRepositoryImpl implements CivMatrimonioCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    CivMatrimonio getByParams(Long id, Map params){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CivMatrimonio> query = cb.createQuery(CivMatrimonio.class)
        Root<CivMatrimonio> root = query.from(CivMatrimonio.class)
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

        List<Predicate> predicates = new ArrayList<>()

        predicates.add(cb.equal(root.get("id"), id))

        query.where(predicates.toArray(new Predicate[predicates.size()]))

        return entityManager.createQuery(query).getSingleResult()
    }

    @Override
    CivMatrimonio findByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<CivMatrimonio> query = cb.createQuery(CivMatrimonio.class);
        Root<CivMatrimonio> root = query.from(CivMatrimonio.class);

        root.fetch("tipoAttoDomain", JoinType.LEFT)

        List<Predicate> predicates = new ArrayList<>();

        predicates.add(cb.equal(root.get("ufficio"), ufficio));

        predicates.add(cb.equal(root.get("anno"), anno));

        predicates.add(cb.equal(root.get("atto"), atto));

        predicates.add(cb.equal(root.get("parte"), parte));

        if (serie){
            predicates.add(cb.equal(root.get("serie"), serie));
        } else {
            predicates.add(cb.isNull(root.get("serie")));
        }

        query.where(predicates.toArray(new Predicate[predicates.size()]))

        return entityManager.createQuery(query).getSingleResult()
    }

    @Override
    CivMatrimonio findByIdAttoAnsc(String idAttoAnsc) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<CivMatrimonio> query = cb.createQuery(CivMatrimonio.class);
        Root<CivMatrimonio> root = query.from(CivMatrimonio.class);

        root.fetch("tipoAttoDomain", JoinType.LEFT)

        List<Predicate> predicates = new ArrayList<>();

        predicates.add(cb.equal(root.get("idAttoAnsc"), idAttoAnsc));

        query.where(predicates.toArray(new Predicate[predicates.size()]))

        return entityManager.createQuery(query).getSingleResult()
    }

    @Override
    Page<CivMatrimonio> listByParams (Map params){
        int pageSize = params?.pageSize ?: Integer.MAX_VALUE
        int activePage = params?.activePage ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<CivMatrimonio> query = cb.createQuery(CivMatrimonio.class);
        Root<CivMatrimonio> root = query.from(CivMatrimonio.class);

        List<Predicate> predicates = new ArrayList<>();

        if (params?.ufficio){
            predicates.add(cb.equal(root.get("ufficio"), params?.ufficio));
        }

        if (params?.anno){
            predicates.add(cb.equal(root.get("anno"), params?.anno))
        }

        if (params?.annoDa){
            predicates.add(cb.ge(root.get("anno"), params.annoDa))
        }

        if (params?.annoA){
            predicates.add(cb.le(root.get("anno"), params.annoA))
        }

        if (params?.parte){
            predicates.add(cb.equal(root.get("parte"), params.parte))
        }

        if (params?.serie){
            predicates.add(cb.equal(root.get("serie"), params.serie))
        }

        if (params?.atto != null){
            predicates.add(cb.or(
                cb.equal(root.get("atto"), params.atto),
                cb.equal(root.get("numeroUnico"), params.atto)
            ))
        }

        if (params?.dataMatrimonio){
            predicates.add(cb.equal(root.get("dataMatrimonio"), params.dataMatrimonio))
        }

        if (params?.dataEventoDa){
            predicates.add(cb.greaterThanOrEqualTo(root.get("dataMatrimonio"), params.dataEventoDa))
        }

        if (params?.dataEventoA){
            predicates.add(cb.lessThanOrEqualTo(root.get("dataMatrimonio"), params.dataEventoA))
        }

        if (params?.dataRegistrazioneDa){
            predicates.add(cb.greaterThanOrEqualTo(root.get("dataRegistrazione"), params.dataRegistrazioneDa))
        }

        if (params?.dataRegistrazioneA){
            predicates.add(cb.lessThanOrEqualTo(root.get("dataRegistrazione"), params.dataRegistrazioneA))
        }

        if (params?.natura){
            predicates.add(cb.equal(root.get("natura"), params.natura))
        }

        if (params?.escludiAnnullati){
            predicates.add(cb.notEqual(root.get("natura"), ENaturaAtto.N))
        }

        if (params?.escludiANSC){
            predicates.add(cb.isNull(root.get("numeroUnico")))
        }

        if (params?.tipoLuogoEvento){
            if (params.tipoLuogoEvento == ETipoLuogoEvento.NEL_COMUNE){
                predicates.add(cb.equal(root.get("eventoNelComune"), ETipoSN.S))
            }
            if (params.tipoLuogoEvento == ETipoLuogoEvento.FUORI_COMUNE){
                predicates.add(cb.equal(root.get("eventoNelComune"), ETipoSN.N))
            }
        }

        if (params?.tipoIndividuiAtto){
            if (params.tipoIndividuiAtto == ETipoIndividuiAtto.R){
                predicates.add(cb.equal(root.get("soggettoResidente"), ETipoSN.S))
            }
            if (params.tipoIndividuiAtto == ETipoIndividuiAtto.N){
                predicates.add(cb.equal(root.get("soggettoResidente"), ETipoSN.N))
            }
        }

        if (params?.tipo){
            if (params?.tipo == ETipoEvento.Divorzi){
                predicates.add(cb.equal(root.get("divorzio"), Boolean.TRUE))
            } else {
                predicates.add(cb.equal(root.get("divorzio"), Boolean.FALSE))
            }
        }

        if (params?.stato){
            if (params?.stato == EStatoAtto.PROVVISORIO){
                predicates.add(cb.lt(root.get("atto"), 0))
            }
            if (params?.stato == EStatoAtto.IN_INSERIMENTO){
                predicates.add(cb.equal(root.get("codiceRecord"), 3))
            }
            if (params?.stato == EStatoAtto.CONSOLIDATO){
                predicates.add(cb.equal(root.get("codiceRecord"), 0))
            }
        }

        if (params?.cognome){
            predicates.add(cb.or(
                    cb.like(cb.lower(root.get("cognome1")), params.cognome.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("cognome2")), params.cognome.toLowerCase() + "%")
            ))
        }

        if (params?.nome){
            predicates.add(cb.or(
                    cb.like(cb.lower(root.get("nome1")), params.nome.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("nome2")), params.nome.toLowerCase() + "%")
            ))
        }

        if (params?.comunicazioniPendenti){
            predicates.add(cb.equal(root.get("comunicazioniPendenti"), params.comunicazioniPendenti))
        }

        if (params?.idAttoAnsc) {
            predicates.add(cb.like(root.get("idAttoAnsc"), "%" + params.idAttoAnsc + "%"))
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

        List<CivMatrimonio> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class);
        Root<CivMatrimonio> itemsRootCount = countQuery.from(CivMatrimonio.class);
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult();

        return new PageImpl<>(lista, pageable, count);
    }

}
