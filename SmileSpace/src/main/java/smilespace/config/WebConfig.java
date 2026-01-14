package smilespace.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import smilespace.filter.FeedbackAuthorizationFilter;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {
    "smilespace.controller",
    "smilespace.filter"  // Add this to scan filter package
})
public class WebConfig implements WebMvcConfigurer {
    
    @Bean
    public FeedbackAuthorizationFilter feedbackAuthorizationFilter() {
        return new FeedbackAuthorizationFilter();
    }
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(feedbackAuthorizationFilter())
                .addPathPatterns("/feedback/analytics/**")
                .addPathPatterns("/feedback/reply/**")
                .addPathPatterns("/feedback/resolve/**")
                .addPathPatterns("/feedback/report/**")
                .excludePathPatterns("/feedback")  // Allow everyone to access feedback form
                .excludePathPatterns("/feedback/submit");  // Allow everyone to submit feedback
    }
    
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
