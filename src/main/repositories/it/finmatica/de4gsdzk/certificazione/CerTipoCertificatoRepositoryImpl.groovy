package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.certificazione.CerAnagrafeFiltro
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.utils.CerAnagrafeFiltroPredicateUtils
import org.springframework.data.domain.*

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class CerTipoCertificatoRepositoryImpl implements CerTipoCertificatoCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    Page<CerTipoCertificato> listByParams(Map params) {
        if (!params?.anagrafeFiltroList) {
            throw new IllegalArgumentException('anagrafeFiltroList is required')
        }

        int pageSize = params?.pageSize as int ?: Integer.MAX_VALUE
        int activePage = params?.activePage as int ?: 0

        Pageable pageable = new PageRequest(activePage, pageSize)

        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CerTipoCertificato> query = cb.createQuery(CerTipoCertificato.class)
        Root<CerTipoCertificato> root = query.from(CerTipoCertificato.class)
        root.fetch('categoriaTipoCertificato', JoinType.INNER)
        root.fetch('tipoCertificatoTariffaDirittoList', JoinType.LEFT)
        root.fetch('tipoDocumentoAnagrafe', JoinType.LEFT)

        List<Predicate> predicates = new ArrayList<>()

        predicates.add(CerAnagrafeFiltroPredicateUtils.buildWherePredicate(cb, root, params.anagrafeFiltroList as List<CerAnagrafeFiltro>))

        if (params?.categoriaTipoCertificato != null) {
            predicates.add(cb.equal(root.get("categoriaTipoCertificato"), params?.categoriaTipoCertificato))
        }

        if (params?.filtro) {
            predicates.add(cb.like(cb.lower(root.get("descrizioneEstesa")), "%" + params.filtro.toLowerCase() + "%"))
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

        List<CerTipoCertificato> lista = entityManager.createQuery(query).setFirstResult(pageable.getOffset()).setMaxResults(pageable.getPageSize()).getResultList()

        // Create Count Query
        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class)
        Root<CerTipoCertificato> itemsRootCount = countQuery.from(CerTipoCertificato.class)
        countQuery.select(cb.count(itemsRootCount)).where(predicates.toArray(new Predicate[predicates.size()]))

        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(lista, pageable, count)
    }

}
