package edu.sm.app.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AiKeywordRecommendRequest {
    private Integer recId;
    private String keyword;
}
