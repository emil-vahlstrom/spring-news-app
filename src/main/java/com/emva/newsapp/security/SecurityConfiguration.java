package com.emva.newsapp.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationTrustResolver;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

import com.emva.newsapp.configuration.CustomSuccessHandler;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {
    
    @Autowired
    private CustomSuccessHandler customSuccessHandler;
    
    @Autowired
    @Qualifier("customUserDetailsService")
    private UserDetailsService userDetailsService;
    
    @SuppressWarnings("unused")
    @Autowired
    private PersistentTokenRepository tokenRepository;
    
    @Bean public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    /**
     * If logged out and trying to do an action that requires login, sometimes you get a NullPointerException,
     * when the SecurityContextHolder tries to get the Authentication-object and it's null.
     * A fix for this problem is to override the AuthenticationTrustResolver.
     * More info on the problem: https://github.com/spring-projects/spring-security/issues/4011
     * @return
     */
    @Bean
    public AuthenticationTrustResolver trustResolver() {
        return new AuthenticationTrustResolver() {
            @Override
            public boolean isRememberMe(Authentication authentication) {
                return false;
            }
            @Override
            public boolean isAnonymous(Authentication authentication) {
                return false;
            }
        };
    }
    
    @Autowired
    public void configureGlobalSecurity(AuthenticationManagerBuilder auth) throws Exception {
//        auth.inMemoryAuthentication().withUser("admin").password("abc123").roles("PUBLISHER");
//        auth.inMemoryAuthentication().withUser("user").password("abc123").roles("USER");
        auth.userDetailsService(userDetailsService);
        auth.authenticationProvider(authenticationProvider());
    }

    private DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authenticationProvider = new DaoAuthenticationProvider();
        authenticationProvider.setUserDetailsService(userDetailsService);
        authenticationProvider.setPasswordEncoder(passwordEncoder());
        return authenticationProvider;
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http.authorizeRequests()
            .antMatchers("/", "/home").permitAll()
            .antMatchers("/results").permitAll()
            .antMatchers("/admin").access("hasRole('ADMIN')")
//            .antMatchers("/users").access("hasRole('ADMIN')")
            /*** USERS ROUTES ***/
            .antMatchers("/users/").permitAll()
            .antMatchers("/users/new").permitAll()
            .antMatchers("/users/authenticated").permitAll()
            .antMatchers(HttpMethod.POST, "/users/").permitAll()
//            .antMatchers("/users/{\\d+}/edit").access("isFullyAuthenticated()")
            .antMatchers(HttpMethod.GET, "/users/{\\d+}").access("isFullyAuthenticated() AND hasRole('ADMIN')")
//            .antMatchers(HttpMethod.POST, "/users/{\\d+}").access("isFullyAuthenticated()") /* APPLIES FOR POST, PUT, DELETE */
            /*** NEWS ROUTES ***/
            .antMatchers("/news/new").access("hasRole('PUBLISHER')")
            .antMatchers(HttpMethod.POST, "/news").access("hasRole('PUBLISHER')")
            .antMatchers("/news/new/preview").access("hasRole('PUBLISHER')")
            .antMatchers("/news/{\\d+}/edit").access("hasRole('PUBLISHER')")
            .antMatchers("/news/{\\d+}/edit/preview").access("hasRole('PUBLISHER')")
            .antMatchers(HttpMethod.GET, "/news/{\\d+}").permitAll()
            /* seems to apply for POST, PUT, DELETE. If implementing PUT or DELETE it is still handled as a POST-request
            // probably because the requests are sent from a HTML-form with POST as method and input type=hidden name=_method value=PUT/DELETE
            // and then filtered with HiddenHttpMethodFilter */
            .antMatchers("/news/{\\d+}").access("hasRole('PUBLISHER') OR hasRole('ADMIN')")
//            .antMatchers(HttpMethod.DELETE, "/news/{\\d+}").access("hasRole('PUBLISHER') OR hasRole('ADMIN')")
            /*** COMMENT ROUTES ***/
            .antMatchers("/news/{\\d+}/comments/new").access("hasRole('USER')")
            .antMatchers("/news/{\\d+}/comments/{\\d+}/edit").access("hasRole('USER')")
            .antMatchers("/news/{\\d+}/comments/{\\d+}/reply").access("hasRole('USER')")
            
            .and().formLogin().loginPage("/login").successHandler(customSuccessHandler)
            .usernameParameter("ssoId").passwordParameter("password")
            .and().csrf()
//            .disable()
            .and()
            .exceptionHandling()
            .accessDeniedPage("/access-denied")
            ;
    }
    
    
}
