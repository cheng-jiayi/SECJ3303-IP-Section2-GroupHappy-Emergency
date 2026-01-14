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
                .addResourceLocations("file:" + uploadPath);
        
        // CSS resources
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/css/");
        
        // JavaScript resources
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/js/");
        
        // General images
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/images/");

        // Module Specific images
        registry.addResourceHandler("/modules/**")
                .addResourceLocations("/WEB-INF/views/modules/");
        
        // Static resources
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");
        
        // WebJars for Bootstrap, jQuery, etc.
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");
    }
}