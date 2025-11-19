package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
@Slf4j
public class FileUploadService {

    @Value("${app.dir.uploadimgsdir}")
    private String uploadDir;

    /**
     * 프로필 사진 업로드
     * @param file 업로드할 파일
     * @param subDir 하위 디렉토리 (예: "profiles")
     * @return 저장된 파일의 상대 경로
     */
    public String uploadProfileImage(MultipartFile file, String subDir) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("파일이 비어있습니다.");
        }

        // 파일 확장자 확인
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        
        // 이미지 파일인지 확인
        if (!isImageFile(extension)) {
            throw new IllegalArgumentException("이미지 파일만 업로드 가능합니다. (jpg, jpeg, png, gif)");
        }

        // 고유한 파일명 생성 (UUID + 원본 확장자)
        String uniqueFilename = UUID.randomUUID().toString() + extension;

        // 저장 경로 생성
        Path uploadPath = Paths.get(uploadDir, subDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
            log.info("디렉토리 생성: {}", uploadPath);
        }

        // 파일 저장
        Path filePath = uploadPath.resolve(uniqueFilename);
        file.transferTo(filePath.toFile());
        log.info("파일 저장 완료: {}", filePath);

        // 웹에서 접근 가능한 상대 경로 반환
        return "/imgs/" + subDir + "/" + uniqueFilename;
    }

    /**
     * 기존 파일 삭제
     * @param filePath 삭제할 파일 경로
     */
    public void deleteFile(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return;
        }

        try {
            // /imgs/profiles/xxx.jpg -> C:/Needy-Care_System/imgs/profiles/xxx.jpg
            String fullPath = uploadDir + filePath.replace("/imgs/", "");
            File file = new File(fullPath);
            
            if (file.exists()) {
                if (file.delete()) {
                    log.info("파일 삭제 완료: {}", fullPath);
                } else {
                    log.warn("파일 삭제 실패: {}", fullPath);
                }
            }
        } catch (Exception e) {
            log.error("파일 삭제 중 오류 발생: {}", filePath, e);
        }
    }

    /**
     * 파일 확장자 추출
     */
    private String getFileExtension(String filename) {
        if (filename == null || filename.isEmpty()) {
            return "";
        }
        int lastIndexOf = filename.lastIndexOf(".");
        if (lastIndexOf == -1) {
            return "";
        }
        return filename.substring(lastIndexOf);
    }

    /**
     * 이미지 파일인지 확인
     */
    private boolean isImageFile(String extension) {
        if (extension == null || extension.isEmpty()) {
            return false;
        }
        String ext = extension.toLowerCase();
        return ext.equals(".jpg") || ext.equals(".jpeg") || 
               ext.equals(".png") || ext.equals(".gif");
    }
}

