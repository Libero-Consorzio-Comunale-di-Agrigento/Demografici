package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaVariazioneAnagrafeRepository extends JpaRepository<AnaVariazioneAnagrafe, Integer>, AnaVariazioneAnagrafeCustomRepository {
}