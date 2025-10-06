package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.utils.TestoUtils

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.Query
import javax.persistence.criteria.*

class AnaAnagrafeRepositoryImpl implements AnaAnagrafeCustomRepository {

    @PersistenceContext
    private EntityManager entityManager

    @Override
    AnaAnagrafe getByParams(Integer id, Map params){
        CriteriaBuilder cb = entityManager.getCriteriaBuilder()
        CriteriaQuery<AnaAnagrafe> query = cb.createQuery(AnaAnagrafe.class)
        Root<AnaAnagrafe> root = query.from(AnaAnagrafe.class)
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
    List<AnaAnagrafe> findAllRettificatiByRicercaIndividuo(RicercaIndividuo r) {
        String cognomeNome = null
        if (!TestoUtils.isVuoto(r.cognome) || !TestoUtils.isVuoto(r.nome)) {
            cognomeNome = "${TestoUtils.isVuoto(r.cognome) ? "%" : r.cognome}/${TestoUtils.isVuoto(r.nome) ? "%" : r.nome}"
        }

        String sql = """
            select distinct ana.*
              from anaana_v ana, anamov_v mov
             where ana.cognome_nome_ric != upper(mov.cognome_nome)
               and ana.matricola = mov.matricola
               ${!TestoUtils.isVuoto(cognomeNome) ? 'and upper(mov.cognome_nome) like :cognomeNome' : ''}
               ${!TestoUtils.isVuoto(r.codiceFiscale) ? 'and ana.cod_fiscale like :codiceFiscale' : ''}
               ${r.sesso != null ? 'and ana.sesso = :sesso' : ''}
               ${r.matricola != null ? 'and ana.matricola like :matricola' : ''}
               ${r.idSoggettoAnpr != null ? 'and ana.id_soggetto_anpr like :idSoggettoAnpr' : ''}
               ${!TestoUtils.isVuoto(r.idUnicoAnpr) ? 'and ana.id_unico_anpr like :idUnicoAnpr' : ''}
               ${r.dataNascitaDal != null ? 'and ana.d_data_nas >= :dataNascitaDal' : ''}
               ${r.dataNascitaAl != null ? 'and ana.d_data_nas <= :dataNascitaAl' : ''}
          UNION
            select distinct ana.*
              from anaana_v ana, anamov_v mov
             where ana.cognome_nome_ric != upper(mov.cognome_nome_prec)
               and ana.matricola = mov.matricola
               ${!TestoUtils.isVuoto(cognomeNome) ? 'and upper(mov.cognome_nome) like :cognomeNome' : ''}
               ${!TestoUtils.isVuoto(r.codiceFiscale) ? 'and ana.cod_fiscale like :codiceFiscale' : ''}
               ${r.sesso != null ? 'and ana.sesso = :sesso' : ''}
               ${r.matricola != null ? 'and ana.matricola like :matricola' : ''}
               ${r.idSoggettoAnpr != null ? 'and ana.id_soggetto_anpr like :idSoggettoAnpr' : ''}
               ${!TestoUtils.isVuoto(r.idUnicoAnpr) ? 'and ana.id_unico_anpr like :idUnicoAnpr' : ''}
               ${r.dataNascitaDal != null ? 'and ana.d_data_nas >= :dataNascitaDal' : ''}
               ${r.dataNascitaAl != null ? 'and ana.d_data_nas <= :dataNascitaAl' : ''}
        """

        Query query = entityManager.createNativeQuery(sql, AnaAnagrafe.class)

        if (!TestoUtils.isVuoto(cognomeNome)) {
            query.setParameter("cognomeNome", cognomeNome)
        }
        if (!TestoUtils.isVuoto(r.codiceFiscale)) {
            query.setParameter("codiceFiscale", r.codiceFiscale)
        }
        if (r.sesso != null) {
            query.setParameter("sesso", r.sesso.id)
        }
        if (r.matricola != null) {
            query.setParameter("matricola", r.matricola)
        }
        if (r.idSoggettoAnpr != null) {
            query.setParameter("idSoggettoAnpr", r.idSoggettoAnpr)
        }
        if (!TestoUtils.isVuoto(r.idUnicoAnpr)) {
            query.setParameter("idUnicoAnpr", r.idUnicoAnpr)
        }
        if (r.dataNascitaDal != null) {
            query.setParameter("dataNascitaDal", r.dataNascitaDal)
        }
        if (r.dataNascitaAl != null) {
            query.setParameter("dataNascitaAl", r.dataNascitaAl)
        }

        // Create query and set parameters
        return query.getResultList()
    }

}
