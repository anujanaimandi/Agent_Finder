package com.realestate.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InquiryResponse {
    private int id;
    private String type;
    private String subject;
    private String clientName;
    private String clientEmail;
    private String message;
    private String status;
    private String reply;
}

