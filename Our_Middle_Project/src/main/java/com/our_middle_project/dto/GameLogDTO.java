package com.our_middle_project.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class GameLogDTO {
	
    private int gameLogNo;
    private int memNo;
    private int levelNo;
    private int score;
    private int combo;
    private int clearTime;      
    
    
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    
    
}
