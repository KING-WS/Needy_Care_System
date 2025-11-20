package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class ChatLog {
    private Integer logId;             // log_id
    private Integer recId;             // rec_id
    private String senderType;         // sender_type (USER/AI)
    private String messageContent;     // message_content
    private String sentimentType;      // sentiment_type
    private String isDeleted;          // is_deleted
    private LocalDateTime logRegdate;  // log_regdate
}
