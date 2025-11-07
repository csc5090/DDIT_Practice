package com.our_middle_project.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class GameLogDTO {
	
	private Integer score;
	private LocalDateTime startTime;
	private LocalDateTime endTime;
    private Integer memNo;
    private Integer levelNo;
    private Integer combo;
    private Integer clearTime;

    // JSON으로 받는 경우
    private String startTimeStr;
    private String endTimeStr;
}
