package it.finmatica.de4gsdzk.anagrafe.pratiche


import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.FileUtils
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.ZipUtils
import it.finmatica.smartdoc.api.struct.File
import org.apache.commons.io.FilenameUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.zkoss.zhtml.Filedownload

@Transactional
@Service
class AnaRecuperoPraticaService {

    private final AnaPraticaAnprRepository anaPraticaAnprRepository
    private final AnaPraticaWebRepository anaPraticaWebRepository

    AnaRecuperoPraticaService(AnaPraticaAnprRepository anaPraticaAnprRepository,
                              AnaPraticaWebRepository anaPraticaWebRepository) {
        this.anaPraticaAnprRepository = anaPraticaAnprRepository
        this.anaPraticaWebRepository = anaPraticaWebRepository
    }

    Page<AnaRecuperoPraticaBaseDomain> findAllByTipoPraticaAndFiltroLike(ETipoPratica tipoPratica, String filtro, String archivio, PageRequest p) {
        if(archivio == 'WEB') {
            if ((filtro?.trim() ?: "") != "") {
                return anaPraticaWebRepository.findAllByTipoPraticaAndFiltroLike(tipoPratica, SqlUtils.beginsAndEndsLike(filtro), p)
            } else {
                return anaPraticaWebRepository.findAllByTipoPraticaAndFiltroLike(tipoPratica, "%", p)
            }

        } else {
            if ((filtro?.trim() ?: "") != "") {
                return anaPraticaAnprRepository.findAllByTipoPraticaAndFiltroLike(tipoPratica, SqlUtils.beginsAndEndsLike(filtro), p)
            } else {
                return anaPraticaAnprRepository.findAllByTipoPraticaAndFiltroLike(tipoPratica, "%", p)
            }
        }

    }

    static void downloadDocumenti(AnaRecuperoPraticaBaseDomain pratica) {
        if (pratica.allegati.size() == 1) {
            IAllegatoPratica a = pratica.allegati.first()
            Filedownload.save(a.blob, null, a.nome)
            return
        }

        List<ZipUtils.VirtualFile> virtualFiles = pratica.allegati.collect {a ->
            File fileRet = new File()
            fileRet.nome = "${a.sequenza}_${a.nome}"
            fileRet.contentType = FileUtils.getMimeType(FilenameUtils.getExtension(fileRet.nome))
            fileRet.inputStream = new ByteArrayInputStream(a.blob)

            return new ZipUtils.VirtualFile(fileRet.nome, fileRet.inputStream)
        }


        String filename = "${pratica.tipoPratica.getEtichettaDesc()}_${pratica.id}.${ETipoFile.ZIP.estensione}"
        byte[] zipContent = ZipUtils.zipFiles(virtualFiles)
        String contentType = FileUtils.getMimeType(FilenameUtils.getExtension(filename))

        Filedownload.save(zipContent, contentType, "${pratica.tipoPratica.id}_${pratica.id}")
    }

    void saveOrUpdate(AnaRecuperoPraticaBaseDomain pratica) {
        if(pratica instanceof AnaPraticaAnpr) {
            anaPraticaAnprRepository.updateAnpads(pratica.id, pratica.archivioAnagrafe?.id, pratica.tipoPratica?.id, pratica.annoPratica, pratica.pratica)
        } else if (pratica instanceof AnaPraticaWeb) {
            anaPraticaWebRepository.save(pratica)
        }
    }

}
