package it.finmatica.de4gsdzk.anagrafe

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaConvivenzaDiFattoService {

    private final AnaConvivenzaDiFattoRepository anaConvivenzaDiFattoRepository

    AnaConvivenzaDiFattoService(AnaConvivenzaDiFattoRepository anaConvivenzaDiFattoRepository) {
        this.anaConvivenzaDiFattoRepository = anaConvivenzaDiFattoRepository
    }

    AnaConvivenzaDiFatto get(Integer id) {
        return anaConvivenzaDiFattoRepository.findById(id)
    }

    AnaConvivenzaDiFatto getCdF(Integer id, String cognomeConvivente,String nomeConvivente) {
        List<AnaConvivenzaDiFatto> result = anaConvivenzaDiFattoRepository.getCdF(id, cognomeConvivente, nomeConvivente)
        return result ? result.first() : null
        //nel caso di omonimie passo la cdf con codCdf più alto
    }

    void saveOrUpdate(AnaConvivenzaDiFatto cdf) {
        anaConvivenzaDiFattoRepository.save(cdf)
    }

    AnaConvivenzaDiFatto findByIdAndMatricola(Long id, Integer matricola) {
        return anaConvivenzaDiFattoRepository.findByIdAndMatricola(id, matricola)
    }
}
