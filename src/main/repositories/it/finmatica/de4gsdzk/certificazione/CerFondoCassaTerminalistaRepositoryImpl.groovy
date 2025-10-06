package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.certificazione.CerFondoCassaTerminalista
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.utils.DataUtils

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Predicate
import javax.persistence.criteria.Root

class CerFondoCassaTerminalistaRepositoryImpl implements CerFondoCassaTerminalistaCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    private static Predicate[] createBasePredicates(CriteriaBuilder cb, Root<CerFondoCassaTerminalista> root,
                                                    CerTerminalista terminalista, Date data) {
        Predicate terminalistaPredicate = cb.equal(root.get("id").get("terminalista"), terminalista)
        Date start = DataUtils.getStartOfDay(data)
        Date end = DataUtils.getEndOfDay(data)
        Predicate dataPredicate = cb.and(
                cb.greaterThanOrEqualTo(root.get("id").get("data"), start),
                cb.lessThanOrEqualTo(root.get("id").get("data"), end)
        )

        return [terminalistaPredicate, dataPredicate] as Predicate[]
    }

    @Override
    CerFondoCassaTerminalista findByTerminalistaAndData(CerTerminalista terminalista, Date data) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<CerFondoCassaTerminalista> query = cb.createQuery(CerFondoCassaTerminalista)
        Root<CerFondoCassaTerminalista> root = query.from(CerFondoCassaTerminalista)

        query.where(createBasePredicates(cb, root, terminalista, data))


        List<CerFondoCassaTerminalista> results = entityManager.createQuery(query).getResultList();

        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    boolean existsByTerminalistaAndData(CerTerminalista terminalista, Date data) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<Long> query = cb.createQuery(Long)
        Root<CerFondoCassaTerminalista> root = query.from(CerFondoCassaTerminalista)

        query.select(cb.literal(1))
                .where(createBasePredicates(cb, root, terminalista, data))

        return !entityManager.createQuery(query)
                .setMaxResults(1)
                .getResultList()
                .isEmpty()
    }
}
