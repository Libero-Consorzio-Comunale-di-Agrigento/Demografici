package it.finmatica.de4gsdzk.anagrafe


import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class AnaFamigliaRepositoryImpl implements AnaFamigliaCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    AnaFamiglia getByParams(String id, Map params) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<AnaFamiglia> query = cb.createQuery(AnaFamiglia.class)
        Root<AnaFamiglia> root = query.from(AnaFamiglia.class)
        if (params?.fetch) {
            for (Map f : params.fetch) {
                JoinType tipo = (f.tipo ?: JoinType.INNER)
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

}
