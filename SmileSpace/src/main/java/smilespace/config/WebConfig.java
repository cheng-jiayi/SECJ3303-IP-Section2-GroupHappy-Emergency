package smilespace.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {
    "smilespace.controller"
})
public class WebConfig implements WebMvcConfigurer {
    
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/modules/");
        resolver.setSuffix(".jsp");
        registry.viewResolver(resolver);
    }
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Serve uploaded files
        String uploadPath = System.getProperty("user.dir") + "/uploads/";
        System.out.println("DEBUG: Upload path configured: " + uploadPath);
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath)
                .setCachePeriod(3600);
        
        // CSS resources
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/css/")
                .setCachePeriod(3600);
        
        // JavaScript resources
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/js/")
                .setCachePeriod(3600);
        
        // General images
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/images/")
                .setCachePeriod(3600);
        
        // Static resources
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/")
                .setCachePeriod(3600);
        
        // WebJars for Bootstrap, jQuery, etc.
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");
    }
}