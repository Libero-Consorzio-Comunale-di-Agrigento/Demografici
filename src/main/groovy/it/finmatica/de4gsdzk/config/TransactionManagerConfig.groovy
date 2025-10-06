package it.finmatica.de4gsdzk.config

import groovy.transform.CompileStatic
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Primary
import org.springframework.data.transaction.CustomChainedTransactionManager
import org.springframework.jdbc.datasource.DataSourceTransactionManager
import org.springframework.jdbc.datasource.TransactionAwareDataSourceProxy
import org.springframework.orm.jpa.JpaTransactionManager
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.annotation.EnableTransactionManagement

import javax.persistence.EntityManagerFactory
import javax.sql.DataSource

@CompileStatic
@EnableTransactionManagement(proxyTargetClass = true)
@Configuration
class TransactionManagerConfig {

    public static final String DATA_SOURCE_PRINCIPALE   = "unproxiedDataSource"
    public static final String DATA_SOURCE_GDM          = "unproxiedDataSourceGdm"
    public static final String DATA_SOURCE_AD4          = "unproxiedDataSourceAd4"

    /**
     * DataSource principale. Punta alla connessione verso lo user principale. È un TransactionAwareDataSource in modo tale da essere
     * legato alla transazione corrente. È possibile utilizzarlo quindi direttamente nel codice ad es:
     * dataSource.getConnection() -> restituirà la connessione legata alla transazione corrente.
     */
    @Bean
    @Primary
    DataSource dataSource(@Qualifier(TransactionManagerConfig.DATA_SOURCE_PRINCIPALE) DataSource dataSource) {
        return new TransactionAwareDataSourceProxy(dataSource)
    }

    /**
     * Il DataSource che punta verso GDM, collegato alla transazione corrente. È un TransactionAwareDataSource in modo
     * tale da essere legato alla transazione corrente. È possibile utilizzarlo quindi direttamente nel codice ad es:
     * dataSource_gdm.getConnection() -> restituirà la connessione legata alla transazione corrente.
     */
    @Bean("dataSource_gdm")
    DataSource dataSource_gdm(@Qualifier(TransactionManagerConfig.DATA_SOURCE_GDM) DataSource dataSource) {
        return new TransactionAwareDataSourceProxy(dataSource)
    }

    /**
     * TransactionManager primario: è il chained-transaction-manager che implementa il BE2PC (Best Effort 2 Phase Commit) che significa
     * che a meno di errori molto strani (ad es: caduta della connessione) questo bean garantisce la sincronizzazione delle commit sulle due connessioni AGSPR e GDM.
     * Questa configurazione è fondamentale per non avere dati disallineati tra AGSPR e GDM.
     * @param jpaTransactionManager
     * @param gdmTransactionManager
     * @return
     */
    @Primary
    @Bean
    PlatformTransactionManager transactionManager(JpaTransactionManager jpaTransactionManager, @Qualifier("transactionManager_gdm") PlatformTransactionManager gdmTransactionManager) {
        new CustomChainedTransactionManager(gdmTransactionManager, jpaTransactionManager)
    }

    /**
     * TransactionManager per JPA (connessione verso lo user)
     * @param jpaTransactionManager
     * @param gdmTransactionManager
     * @return
     */
    @Bean
    JpaTransactionManager jpaTransactionManager(EntityManagerFactory entityManagerFactory) {
        return new JpaTransactionManager(entityManagerFactory)
    }

    /**
     * TransactionManager per la connessione verso GDM
     * @param jpaTransactionManager
     * @param gdmTransactionManager
     * @return
     */
    @Bean
    PlatformTransactionManager transactionManager_gdm(@Qualifier(TransactionManagerConfig.DATA_SOURCE_GDM) DataSource dataSourceGdm) {
        return new DataSourceTransactionManager(dataSourceGdm)
    }

}
