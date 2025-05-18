package com.realestate.controller;

import com.realestate.dto.AddReplyRequest;
import com.realestate.dto.CreateInquiryRequest;
import com.realestate.dto.InquiryResponse;
import com.realestate.dto.UpdateStatusRequest;
import com.realestate.model.Inquiry;
import com.realestate.service.InquiryService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/inquiries")
@CrossOrigin(origins="*")
public class InquiryController {
    private final InquiryService service = new InquiryService();

    @PostMapping
    public InquiryResponse create(@RequestBody CreateInquiryRequest request) {
        Inquiry inquiry = new Inquiry(0, request.getType(), request.getSubject(), request.getClientName(), request.getClientEmail(), request.getMessage(), "PENDING", "");
        Inquiry saved = service.createInquiry(inquiry);
        return toResponse(saved);
    }

    @GetMapping
    public List<InquiryResponse> getAll() {
        return service.getAllInquiries().stream().map(this::toResponse).collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    public InquiryResponse getById(@PathVariable int id) {
        Inquiry inquiry = service.getInquiryById(id).orElseThrow(() -> new RuntimeException("Not found"));
        return toResponse(inquiry);
    }

    @PutMapping("/{id}/status")
    public String updateStatus(@PathVariable int id, @RequestBody UpdateStatusRequest request) {
        return service.updateStatus(id, request.getStatus()) ? "Status updated." : "Inquiry not found.";
    }

    @PutMapping("/{id}/reply")
    public String addReply(@PathVariable int id, @RequestBody AddReplyRequest request) {
        return service.addReply(id, request.getReply()) ? "Reply added." : "Inquiry not found.";
    }

    @DeleteMapping("/{id}")
    public void deleteById(@PathVariable Long id) {
        service.deleteInquiryById(id);
    }

    private InquiryResponse toResponse(Inquiry i) {
        return new InquiryResponse(i.getId(), i.getType(), i.getSubject(), i.getClientName(), i.getClientEmail(), i.getMessage(), i.getStatus(), i.getReply());
    }
}
