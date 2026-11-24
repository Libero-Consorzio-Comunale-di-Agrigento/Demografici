package it.finmatica.de4gsdzk.certificazione


import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.ETipoSoggetto
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils

import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.Predicate
import javax.persistence.criteria.Root

class CerCertificatoEmessoRepositoryUtils {

    static List<Predicate> getPredicatesByBaseRicercaCertificato(CriteriaBuilder cb, Root<CerCertificatoEmesso> root, BaseRicercaCertificato r) {
        List<Predicate> predicates = new ArrayList<>()

        if (r.terminalista != null) {
            predicates.add(cb.equal(root.get("terminalista"), r.terminalista))
        }

        if (r.modalitaRilascio != null) {
            predicates.add(cb.equal(root.get("modalitaRilascio"), r.modalitaRilascio))
        }

        if (r.escludiAnnullati != null && r.escludiAnnullati) {
            predicates << cb.or(cb.equal(root.get('annullamento'), ETipoSiNo.NO), cb.isNull(root.get('annullamento')))
        }

        if (r.tipoPagamento != null) {
            predicates.add(cb.equal(root.get("tipoPagamento"), r.tipoPagamento))
        }

        return predicates
    }

    static List<Predicate> getPredicatesByRicercaCertificato(CriteriaBuilder cb, Root<CerCertificatoEmesso> root, RicercaCertificato r) {
        List<Predicate> predicates = new ArrayList<>()

        predicates.addAll(getPredicatesByBaseRicercaCertificato(cb, root, r))

        if (r.dataEmissioneDal != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("dataEmissione"), r.dataEmissioneDal))
        }

        if (r.dataEmissioneAl != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("dataEmissione"), r.dataEmissioneAl))
        }

        if (r.tipoCertificato != null) {
            predicates.add(cb.equal(root.get("tipoCertificato"), r.tipoCertificato))
        }

        if(r.tipoSoggettoCertificato == null) {
            // Se il tipo soggetto non è specificato, cerca sia in richiedente che in beneficiario (OR)
            if (!TestoUtils.isVuoto(r.cognomeTipoSoggettoCertificato)) {
                predicates.add(cb.or(
                    cb.like(
                        cb.lower(root.get("richiedente").get("cognome")),
                        SqlUtils.endsLike(r.cognomeTipoSoggettoCertificato.toLowerCase())
                    ),
                    cb.like(
                        cb.lower(root.get("beneficiario").get("cognome")),
                        SqlUtils.endsLike(r.cognomeTipoSoggettoCertificato.toLowerCase())
                    )
                ))
            }
            if (!TestoUtils.isVuoto(r.nomeTipoSoggettoCertificato)) {
                predicates.add(cb.or(
                    cb.like(
                        cb.lower(root.get("richiedente").get("nome")),
                        SqlUtils.endsLike(r.nomeTipoSoggettoCertificato.toLowerCase())
                    ),
                    cb.like(
                        cb.lower(root.get("beneficiario").get("nome")),
                        SqlUtils.endsLike(r.nomeTipoSoggettoCertificato.toLowerCase())
                    )
                ))
            }
        } else if (r.tipoSoggettoCertificato == ETipoSoggetto.RICHIEDENTE_CERTIFICATO) {
            if (!TestoUtils.isVuoto(r.cognomeTipoSoggettoCertificato)) {
                predicates.add(cb.like(
                        cb.lower(root.get("richiedente").get("cognome")),
                        SqlUtils.endsLike(r.cognomeTipoSoggettoCertificato.toLowerCase())
                ))
            }
            if (!TestoUtils.isVuoto(r.nomeTipoSoggettoCertificato)) {
                predicates.add(cb.like(
                        cb.lower(root.get("richiedente").get("nome")),
                        SqlUtils.endsLike(r.nomeTipoSoggettoCertificato.toLowerCase())
                ))
            }
        } else if (r.tipoSoggettoCertificato == ETipoSoggetto.BENEFICIARIO_CERTIFICATO) {
            if (!TestoUtils.isVuoto(r.cognomeTipoSoggettoCertificato)) {
                predicates.add(cb.like(
                        cb.lower(root.get("beneficiario").get("cognome")),
                        SqlUtils.endsLike(r.cognomeTipoSoggettoCertificato.toLowerCase())
                ))
            }
            if (!TestoUtils.isVuoto(r.nomeTipoSoggettoCertificato)) {
                predicates.add(cb.like(
                        cb.lower(root.get("beneficiario").get("nome")),
                        SqlUtils.endsLike(r.nomeTipoSoggettoCertificato.toLowerCase())
                ))
            }
        }

        if (r.annoEmissione != null) {
            predicates.add(cb.equal(root.get("annoEmissione"), r.annoEmissione))
        }

        if (r.progressivoEmissione != null) {
            predicates.add(cb.equal(root.get("progressivoEmissione"), r.progressivoEmissione))
        }

        return predicates
    }

    static List<Predicate> getPredicatesByRicercaCertificatoStampa(CriteriaBuilder cb, Root<CerCertificatoEmesso> root, RicercaCertificatoStampa r) {
        List<Predicate> predicates = new ArrayList<>()

        predicates.addAll(getPredicatesByBaseRicercaCertificato(cb, root, r))

        if (r.soloCartaIdentita != null) {
            if (r.soloCartaIdentita) {
                predicates << cb.isNotNull(root.get('cartaIdentita'))
            }
        }

        if (r.soloBollo != null) {
            if (r.soloBollo) {
                predicates << cb.isNotNull(root.get('bollo'))
            }
        }

        return predicates
    }

    static List<Predicate> getListPredicatesByRicercaCertificatoStampa(CriteriaBuilder cb, Root<CerCertificatoEmesso> root, RicercaCertificatoStampa r) {
        List<Predicate> predicates = getPredicatesByRicercaCertificatoStampa(cb, root, r)
        if (r.dataEmissioneDal != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("dataEmissione"), r.dataEmissioneDal))
        }
        if (r.dataEmissioneAl != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("dataEmissione"), r.dataEmissioneAl))
        }
        predicates
    }

    static List<Predicate> getDirittiPredicatesByRicercaCertificatoStampa(CriteriaBuilder cb, Root<CerCertificatoEmesso> root, RicercaCertificatoStampa r) {
        List<Predicate> predicates = getPredicatesByRicercaCertificatoStampa(cb, root, r)

        predicates << cb.or(cb.equal(root.get('annullamento'), ETipoSiNo.NO), cb.isNull(root.get('annullamento')))

        if (r.dataEmissioneDal != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("dataEmissione"), r.dataEmissioneDal))
        }

        if (r.dataEmissioneAl != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("dataEmissione"), r.dataEmissioneAl))
        }

        return predicates
    }

    static List<Predicate> getDirittiRiepilogoPredicatesByRicercaCertificatoStampa(CriteriaBuilder cb, Root<CerCertificatoEmesso> root, RicercaCertificatoStampa r) {
        List<Predicate> predicates = getPredicatesByRicercaCertificatoStampa(cb, root, r)

        predicates << cb.or(cb.equal(root.get('annullamento'), ETipoSiNo.NO), cb.isNull(root.get('annullamento')))

        if (r.riepilogo.dataRiepilogoDal != null) {
            predicates.add(cb.greaterThanOrEqualTo(root.get("dataEmissione"), r.riepilogo.dataRiepilogoDal))
        }

        if (r.riepilogo.dataRiepilogoAl != null) {
            predicates.add(cb.lessThanOrEqualTo(root.get("dataEmissione"), r.riepilogo.dataRiepilogoAl))
        }
        predicates
    }

}
