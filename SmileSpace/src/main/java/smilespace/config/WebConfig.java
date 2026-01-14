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
        resolver.setPrefix("/modules/");
        resolver.setSuffix(".jsp");
        registry.viewResolver(resolver);
    }
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Use a more specific pattern instead of **/images/**
        registry.addResourceHandler("/modules/*/images/**")
                .addResourceLocations("/modules/");
        
        // Handle CSS, JS, and other resources
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/css/");
        
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/js/");
        
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/images/");
        
        // If you need to serve all static resources from root
        // But be careful with this - it might conflict with your view resolver
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");
    }
}