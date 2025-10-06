package it.finmatica.de4gsdzk.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnJndi
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.jdbc.datasource.lookup.JndiDataSourceLookup

import javax.sql.DataSource

/**
 * I DataSource in questa Configurazione sono quelli che vengono utilizzati in produzione sul tomcat quando è
 * disponibile un NamingContext. Sovrascrivono i DataSource configurati su DataSourceConfig
 */
@Configuration
public class JndiDataSourceConfig {

    /**
     * Il dataSource principale non proxato. Punta alla connessione verso lo user principale. NON va usato nei service. Questo bean
     * viene usato da Hibernate e da JPA.
     */
    @ConditionalOnJndi
    @Bean(name = TransactionManagerConfig.DATA_SOURCE_PRINCIPALE, destroyMethod = "")
    DataSource jndiUnproxiedDataSource(@Value("\${spring.datasource.jndi-name}") String dataSourceJndi) {
        return new JndiDataSourceLookup().getDataSource(dataSourceJndi)
    }

    /**
     * Il DataSource che punta verso GDM NON collegato alla transazione. Questo bean serve per configurare correttamente
     * il transactionManager di gdm.
     */
    @ConditionalOnJndi
    @Bean(name = TransactionManagerConfig.DATA_SOURCE_GDM, destroyMethod = "")
    DataSource jndiUnproxiedDataSourceGdm(@Value("\${spring.datasources.gdm.jndi-name}") String dataSourceJndi) {
        return new JndiDataSourceLookup().getDataSource(dataSourceJndi)
    }

    /**
     * Connessione verso AD4. Questo dataSource NON è collegato alla transazione corrente. Se si ottiene una connessione
     * da questo dataSource, va chiusa manualmente, ad es: try {*     connection = ad4DataSource.getConnection() }
     * finally {*     connection?.close() }* @return
     */
    @ConditionalOnJndi
    @Bean(name = TransactionManagerConfig.DATA_SOURCE_AD4, destroyMethod = "")
    DataSource jndiUnproxiedDataSourceAd4(@Value("\${spring.datasources.ad4.jndi-name}") String dataSourceJndi) {
        return new JndiDataSourceLookup().getDataSource(dataSourceJndi)
    }
}
