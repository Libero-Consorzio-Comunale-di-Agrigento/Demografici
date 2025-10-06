package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.ParametroProtocolloDiz
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ParametroProtocolloDizRepository extends JpaRepository<ParametroProtocolloDiz, Long> {

    List<ParametroProtocolloDiz> findAllByModulo(String modulo)

}

