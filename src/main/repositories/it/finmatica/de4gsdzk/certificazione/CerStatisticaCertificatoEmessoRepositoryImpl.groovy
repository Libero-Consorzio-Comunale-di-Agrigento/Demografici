package it.finmatica.de4gsdzk.certificazione

import javax.persistence.EntityManager
import javax.persistence.PersistenceContext
import javax.persistence.Query

class CerStatisticaCertificatoEmessoRepositoryImpl implements CerStatisticaCertificatoEmessoCustomRepository {

    @PersistenceContext
    EntityManager entityManager

    @Override
    List<Map<String, Object>> findAllDettaglioTerminalisti(Date dataInizio, Date dataFine) {
        String sql = """
            SELECT 'TERMINALISTA' as tipoDato,
                   TERMINALISTA as descrizione,
                   SUM(COUNT_VALIDI) as certificatiEmessi,
                   SUM(SUM_SEGRETERIA) as dirittiSegreteria,
                   SUM(SUM_STATO_CIVILE) as dirittiStatoCivile,
                   SUM(SUM_CARTA_IDENTITA) as dirittiCartaIdentita,
                   SUM(SUM_RIMBORSO_ST) as rimborsoStampati,
                   SUM(SUM_BOLLO) as bolli,
                   SUM(SUM_DIVERSI_1) as diversi1,
                   SUM(SUM_DIVERSI_2) as diversi2
            FROM CERSCE_V
            WHERE D_DATA BETWEEN :dataInizio AND :dataFine
            GROUP BY TERMINALISTA
            ORDER BY TERMINALISTA
        """

        Query query = entityManager.createNativeQuery(sql)
        query.setParameter("dataInizio", dataInizio)
        query.setParameter("dataFine", dataFine)

        List<Object[]> results = query.getResultList()

        return results.collect { Object[] row ->
            BigDecimal dirittiSegreteria = (row[3] ?: new BigDecimal("0.00")) as BigDecimal
            BigDecimal dirittiStatoCivile = (row[4] ?: new BigDecimal("0.00")) as BigDecimal
            BigDecimal dirittiCartaIdentita = (row[5] ?: new BigDecimal("0.00")) as BigDecimal
            BigDecimal rimborsoStampati = (row[6] ?: new BigDecimal("0.00")) as BigDecimal
            BigDecimal bolli = (row[7] ?: new BigDecimal("0.00")) as BigDecimal
            BigDecimal diversi1 = (row[8] ?: new BigDecimal("0.00")) as BigDecimal
            BigDecimal diversi2 = (row[9] ?: new BigDecimal("0.00")) as BigDecimal

            [
                tipoDato: row[0],
                descrizione: row[1],
                certificatiEmessi: row[2],
                dirittiSegreteria: dirittiSegreteria,
                dirittiStatoCivile: dirittiStatoCivile,
                dirittiCartaIdentita: dirittiCartaIdentita,
                rimborsoStampati: rimborsoStampati,
                bolli: bolli,
                diversi1: diversi1,
                diversi2: diversi2,
                totale: dirittiSegreteria + dirittiStatoCivile + dirittiCartaIdentita + rimborsoStampati + bolli + diversi1 + diversi2
            ]
        }
    }
}
