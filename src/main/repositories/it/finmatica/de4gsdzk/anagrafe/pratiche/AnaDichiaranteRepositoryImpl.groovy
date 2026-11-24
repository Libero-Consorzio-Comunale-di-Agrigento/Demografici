package it.finmatica.de4gsdzk.anagrafe.pratiche

import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.criteria.*

class AnaDichiaranteRepositoryImpl implements AnaDichiaranteCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    Page<AnaDichiarante> listAllByRicercaPratica(RicercaPratica r, PageRequest p) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()

        // Query principale
        CriteriaQuery<AnaDichiarante> query = cb.createQuery(AnaDichiarante)
        Root<AnaDichiarante> root = query.from(AnaDichiarante)
        // fetch con cast a Join: evita il doppio join SQL su anatpr_v_zk
        Fetch praticaFetch = root.fetch("pratica", JoinType.LEFT)
        praticaFetch.fetch("statoPratica", JoinType.LEFT)
        praticaFetch.fetch("terminalista", JoinType.LEFT)
        Join<AnaDichiarante, AnaPratica> praticaJoin = (Join<AnaDichiarante, AnaPratica>) praticaFetch

        //Ordinamento
        if (p.sort) {
            List<Order> ll = []
            for (Sort.Order m : p.sort) {
                Path path = root
                for (String part : m.property.split("\\.")) {
                    path = path.get(part)
                }
                ll.add(m.direction == Sort.Direction.DESC ? cb.desc(path) : cb.asc(path))
            }
            if (!(ll.isEmpty())) {
                query.orderBy(ll)
            }
        }


        List<Predicate> predicates = buildPredicates(cb, root, praticaJoin, r)

        query.select(root).where(predicates.toArray(new Predicate[0]))

        List<AnaDichiarante> lista = entityManager.createQuery(query)
                .setFirstResult(p.getOffset())
                .setMaxResults(p.getPageSize())
                .getResultList()

        // Count query con join
        CriteriaQuery<Long> countQuery = cb.createQuery(Long)
        Root<AnaDichiarante> countRoot = countQuery.from(AnaDichiarante)
        Join<AnaDichiarante, AnaPratica> countPraticaJoin = countRoot.join("pratica", JoinType.LEFT)

        List<Predicate> countPredicates = buildPredicates(cb, countRoot, countPraticaJoin, r)

        countQuery.select(cb.count(countRoot)).where(countPredicates.toArray(new Predicate[0]))
        Long count = entityManager.createQuery(countQuery).getSingleResult()

        return new PageImpl<>(lista, p, count)
    }

    private List<Predicate> buildPredicates(
            CriteriaBuilder cb,
            Root<AnaDichiarante> root,
            Join<AnaDichiarante, AnaPratica> praticaJoin,
            RicercaPratica r
    ) {
        List<Predicate> predicates = []

        // Dichiarante
        if (r.cognomeDichiarante) {
            predicates.add(cb.like(cb.lower(root.get("cognome")), "%${r.cognomeDichiarante.toLowerCase()}%"))
        }
        if (r.nomeDichiarante) {
            predicates.add(cb.like(cb.lower(root.get("nome")), "%${r.nomeDichiarante.toLowerCase()}%"))
        }
        if (r.codiceFiscaleDichiarante) {
            predicates.add(cb.equal(cb.upper(root.get("codiceFiscale")), r.codiceFiscaleDichiarante.toUpperCase()))
        }
        if (r.matricolaDichiarante) {
            predicates.add(cb.equal(root.get("matricola"), r.matricolaDichiarante))
        }
        if (r.idAnprDichiarante) {
            predicates.add(cb.equal(root.get("idAnpr"), r.idAnprDichiarante))
        }
        if (r.idSchedaDichiarante) {
            predicates.add(cb.equal(root.get("idScheda"), r.idSchedaDichiarante))
        }

        // Pratica
        if (r.archivioAnagrafe) {
            predicates.add(cb.equal(praticaJoin.get("archivioAnagrafe"), r.archivioAnagrafe))
            // predicato ridondante su root: consente a Oracle di fare predicate pushing nella UNION di anatpr_v_zk_soggetti
            predicates.add(cb.equal(root.get("archivioAnagrafe"), r.archivioAnagrafe))
        }
        if (r.tipoPratica) {
            predicates.add(cb.equal(praticaJoin.get("tipoPratica"), r.tipoPratica))
            // idem: riduce i branch UNION da 7 a 2 (o 1 se archivioAnagrafe è valorizzato)
            predicates.add(cb.equal(root.get("tipoPratica"), r.tipoPratica))
        }
        if (r.statoPratica?.codEp) {
            predicates.add(cb.equal(praticaJoin.get("statoPratica").get("codEp"), r.statoPratica.codEp))
        }
        if (r.dataPraticaDa != null) {
            predicates.add(cb.greaterThanOrEqualTo(praticaJoin.get("data"), r.dataPraticaDa))
        }
        if (r.dataPraticaAl != null) {
            predicates.add(cb.lessThanOrEqualTo(praticaJoin.get("data"), r.dataPraticaAl))
        }
        if (r.annoPratica) {
            predicates.add(cb.equal(praticaJoin.get("anno"), r.annoPratica))
            // idem: limita le righe di anatpr scansionate in ogni branch UNION
            predicates.add(cb.equal(root.get("annoPratica"), r.annoPratica))
        }
        if (r.numeroPratica) {
            predicates.add(cb.equal(praticaJoin.get("numero"), r.numeroPratica))
            predicates.add(cb.equal(root.get("numeroPratica"), r.numeroPratica))
        }
        if (r.numerazione != null) {
            switch (r.numerazione) {
                case ETipoNumerazione.PROVVISORIA:
                    predicates.add(cb.lessThan(praticaJoin.get("numero"), 0))
                    break;
                case ETipoNumerazione.DEFINITIVA:
                    predicates.add(cb.greaterThan(praticaJoin.get("numero"), 0))
                    break;
            }
        }
        if (r.terminalista) {
            predicates.add(cb.equal(praticaJoin.get("terminalista"), r.terminalista))
        }

        return predicates
    }
}
