package edu.sm.config;

import lombok.AllArgsConstructor;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true, prePostEnabled = true)
@AllArgsConstructor
public class SecurityConfig  {

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public StandardPBEStringEncryptor  textEncoder(@Value("${app.key.algo}") String algo, @Value("${app.key.skey}") String skey) {
        StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
        encryptor.setAlgorithm(algo);
        encryptor.setPassword(skey);
        return encryptor;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        // CSRF 비활성화
        http.csrf((csrf) -> csrf.disable());

        // http.cors(Customizer.withDefaults());

        // [추가된 부분] iframe 허용 설정 (X-Frame-Options: SAMEORIGIN)
        // 이 설정이 있어야 home.jsp 안에 있는 cam.jsp(iframe)가 보입니다.
        http.headers((headers) -> headers
                .frameOptions((frameOptions) -> frameOptions.sameOrigin())
        );

        // Spring Security의 기본 로그아웃 비활성화 (커스텀 로그아웃 사용)
        http.logout((logout) -> logout.disable());

        // 권한 규칙 작성
        http.authorizeHttpRequests(authorize -> authorize
                        //@PreAuthrization을 사용할 것이기 때문에 모든 경로에 대한 인증처리는 Pass
                        .anyRequest().permitAll()
//                        .anyRequest().authenticated()
        );
        return http.build();
    }
}