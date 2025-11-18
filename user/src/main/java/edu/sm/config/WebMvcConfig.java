package edu.sm.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
@Slf4j
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${app.dir.imgsdir}")
    String imgdir;
    @Value("${app.dir.logsdir}")
    String logdir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 프로젝트 내부 imgs 폴더를 웹에서 접근 가능하게 설정
        registry.addResourceHandler("/imgs/**")
                .addResourceLocations(imgdir);
        registry.addResourceHandler("/logs/**")
                .addResourceLocations(logdir);
        
        log.info("이미지 저장 경로 설정: {}", imgdir);
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")//shop 서버외에 어떤 서버도 들어갈 수 있엉!
                .allowedMethods("HEAD", "GET", "POST", "PUT", "DELETE", "OPTIONS")
                .maxAge(3600)
                .allowCredentials(false)
                .allowedHeaders("Authorization", "Cache-Control", "Content-Type");
    }

}