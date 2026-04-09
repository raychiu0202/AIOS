package cn.iocoder.aios.module.mes.framework.web.config;

import cn.iocoder.aios.framework.swagger.config.AiosSwaggerAutoConfiguration;
import org.springdoc.core.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * mes 模块的 web 组件的 Configuration
 *
 * @author 芋道源码
 */
@Configuration(proxyBeanMethods = false)
public class MesWebConfiguration {

    /**
     * mes 模块的 API 分组
     */
    @Bean
    public GroupedOpenApi mesGroupedOpenApi() {
        return AiosSwaggerAutoConfiguration.buildGroupedOpenApi("mes");
    }

}
