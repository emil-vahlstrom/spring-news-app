package com.emva.newsapp.configuration;

import java.util.EnumSet;

import javax.servlet.DispatcherType;
import javax.servlet.FilterRegistration;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;

import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.filter.HiddenHttpMethodFilter;
import org.springframework.web.servlet.DispatcherServlet;

public class WebMvcInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        AnnotationConfigWebApplicationContext rootContext = new AnnotationConfigWebApplicationContext();
        rootContext.register(WebMvcConfig.class);
        rootContext.register(ThymeleafConfig.class);
        
        ServletRegistration.Dynamic registration = servletContext.addServlet("dispatcher", new DispatcherServlet(rootContext));
        registration.addMapping("/");
        registration.setLoadOnStartup(1);
        
        registerCharacterEncodingFilter(servletContext);
        registerHiddenHttpMethodFilter(servletContext);
    }
    
    private void registerCharacterEncodingFilter(final ServletContext servletContext) {
        CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
        characterEncodingFilter.setEncoding("UTF-8");
        characterEncodingFilter.setForceEncoding(true);
        FilterRegistration.Dynamic filter = servletContext.addFilter("characterEncodingFilter", characterEncodingFilter);
        filter.addMappingForUrlPatterns(null, false, "/*");
    }

    private void registerHiddenHttpMethodFilter(final ServletContext servletContext) {
        HiddenHttpMethodFilter filter = new HiddenHttpMethodFilter();
        FilterRegistration.Dynamic registration = servletContext.addFilter("hiddenHttpMethodFilter", filter);
        registration.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST), false, "/*");
    }
}
