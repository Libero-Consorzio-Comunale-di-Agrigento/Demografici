package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaDizionarioPraticheRepository extends JpaRepository<AnaDizionarioPratiche, String> {

    List<AnaDizionarioPratiche> findAllByArchivioAnagrafeAndTipoPraticaAndCodiceArchivioOrderBySequenza(ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica, ETipoArchivioDizionario tipoArchivioDizionario)

    AnaDizionarioPratiche findByCodiceAndArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(String codice, ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica, ETipoArchivioDizionario tipoArchivioDizionario)
}