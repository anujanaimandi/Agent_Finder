package com.realestate.service;

import com.realestate.model.Inquiry;
import com.realestate.repository.InquiryRepository;

import java.util.*;

public class InquiryService {
    private final InquiryRepository repo = new InquiryRepository();

    public Inquiry createInquiry(Inquiry inquiry) {
        List<Inquiry> inquiries = repo.findAll();
        inquiry.setId(inquiries.isEmpty() ? 1 : inquiries.get(inquiries.size() - 1).getId() + 1);
        repo.save(inquiry);
        return inquiry;
    }

    public List<Inquiry> getAllInquiries() {
        return repo.findAll();
    }

    public Optional<Inquiry> getInquiryById(int id) {
        return repo.findAll().stream().filter(i -> i.getId() == id).findFirst();
    }

    public boolean updateStatus(int id, String status) {
        List<Inquiry> inquiries = repo.findAll();
        boolean found = false;
        for (Inquiry i : inquiries) {
            if (i.getId() == id) {
                i.setStatus(status);
                found = true;
                break;
            }
        }
        if (found) repo.overwriteAll(inquiries);
        return found;
    }

    public boolean addReply(int id, String reply) {
        List<Inquiry> inquiries = repo.findAll();
        boolean found = false;
        for (Inquiry i : inquiries) {
            if (i.getId() == id) {
                i.setReply(reply);
                i.setStatus("RESOLVED");
                found = true;
                break;
            }
        }
        if (found) repo.overwriteAll(inquiries);
        return found;
    }

    public void deleteInquiryById(Long id) {
        List<Inquiry> inquiries = getAllInquiries();
        boolean removed = inquiries.removeIf(i -> i.getId() == id.intValue());
        if (!removed) {
            throw new RuntimeException("Inquiry with ID " + id + " not found");
        }
        repo.overwriteAll(inquiries);
    }

}

