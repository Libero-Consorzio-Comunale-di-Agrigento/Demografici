package it.finmatica.de4gsdzk.certificazione

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.Query

class CerDettaglioIncassoRepositoryImpl implements CerDettaglioIncassoCustomRepository {

    @PersistenceContext
    EntityManager entityManager

    @Override
    List<Map<String, Object>> findAllDettaglioIncasso(Date dataInizio, Date dataFine) {
        String sql = """
            SELECT 'INCASSO' as tipoDato,
                   COD_DIRITTO,
                   DES_DIRITTO as descrizione,
                   SUM(TOTALE) as totale,
                   SUM(TOTALE_1) as contanti,
                   SUM(TOTALE_2) as pos,
                   SUM(TOTALE_3) as pagopa,
                   SUM(TOTALE_4) as mastercard,
                   SUM(TOTALE_5) as tipoPagamento5,
                   SUM(TOTALE_8) as differito,
                   SUM(TOTALE_9) as altro
            FROM cersce_v_pagamenti
            WHERE D_DATA BETWEEN :dataInizio AND :dataFine
            GROUP BY DES_DIRITTO, COD_DIRITTO
            ORDER BY COD_DIRITTO
        """

        Query query = entityManager.createNativeQuery(sql)
        query.setParameter("dataInizio", dataInizio)
        query.setParameter("dataFine", dataFine)

        List<Object[]> results = query.getResultList()

        return results.collect { result ->
            Object[] row = result as Object[]
            [
                    tipoDato      : row[0],
                    codDiritto    : row[1],
                    descrizione   : row[2],
                    totale        : (row[3] ?: new BigDecimal("0.00")) as BigDecimal,
                    contanti      : (row[4] ?: new BigDecimal("0.00")) as BigDecimal,
                    pos           : (row[5] ?: new BigDecimal("0.00")) as BigDecimal,
                    pagopa        : (row[6] ?: new BigDecimal("0.00")) as BigDecimal,
                    mastercard    : (row[7] ?: new BigDecimal("0.00")) as BigDecimal,
                    tipoPagamento5: (row[8] ?: new BigDecimal("0.00")) as BigDecimal,
                    differito     : (row[9] ?: new BigDecimal("0.00")) as BigDecimal,
                    altro         : (row[10] ?: new BigDecimal("0.00")) as BigDecimal
            ]
        }
    }
}
