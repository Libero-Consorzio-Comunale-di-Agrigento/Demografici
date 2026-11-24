package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.jpa.repository.JpaRepository

interface AnaStatoRepository extends JpaRepository<AnaStato, Integer> {

    AnaStato findById(Integer id)

}