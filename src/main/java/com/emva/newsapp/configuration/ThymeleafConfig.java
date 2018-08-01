package com.emva.newsapp.configuration;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Description;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.ViewResolver;
import org.thymeleaf.spring5.ISpringTemplateEngine;
import org.thymeleaf.spring5.SpringTemplateEngine;
import org.thymeleaf.spring5.templateresolver.SpringResourceTemplateResolver;
import org.thymeleaf.spring5.view.ThymeleafViewResolver;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.ITemplateResolver;

//@Configuration
//@ComponentScan("com.emva.newsapp")
public class ThymeleafConfig implements ApplicationContextAware {
    
    private ApplicationContext applicationContext;
    
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }
    
    @Bean
    public ViewResolver viewResolver() {
        ThymeleafViewResolver resolver = new ThymeleafViewResolver();
        resolver.setTemplateEngine(templateEngine());
        resolver.setCharacterEncoding("UTF-8");
        resolver.setContentType("text/html; charset=UTF-8");
//        resolver.setViewNames(new String[] { "*html"});
        resolver.setOrder(1);
        return resolver;
    }
    
    @Bean
    @Description("Thymeleaf Template Engine")
    public ISpringTemplateEngine templateEngine() {
        SpringTemplateEngine templateEngine = new SpringTemplateEngine();
        templateEngine.setEnableSpringELCompiler(true);
        templateEngine.setTemplateResolver(templateResolver());
        return templateEngine;
    }
    
    @Bean
    @Description("Thymeleaf Template Resolver")
    public ITemplateResolver templateResolver() {
        SpringResourceTemplateResolver templateResolver = new SpringResourceTemplateResolver();
        templateResolver.setApplicationContext(applicationContext);
        templateResolver.setPrefix("/WEB-INF/views/");
        templateResolver.setSuffix(".html");
        templateResolver.setCharacterEncoding("UTF-8");
        templateResolver.setTemplateMode(TemplateMode.HTML);
        return templateResolver;
    }
    
    @Bean
    public MessageSource messageSource() {
        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setCacheSeconds(-1);
        messageSource.setBasename("/WEB-INF/Messages");
        return messageSource;
    }
    
    //@Bean
    //public CookieLocaleResolver localeResolver() {
        //normal ResourceBundleMessageSource scans for files in the classpath (e.g. Java Resources/src/main/java or src/main/resources)
        //While ReloadableResourceBundleMessageSource can refer to any Spring resource location
        //for example /WEB-INF/Messages. it's possible to access classpath with classpath: (then setCacheSeconds should be -1)
        //CookieLocaleResolver localeResolver = new CookieLocaleResolver();
        //Locale defaultLocale = new Locale("es", "ar");
        //localeResolver.setDefaultLocale(defaultLocale);
        //return localeResolver;
    //}
 }
