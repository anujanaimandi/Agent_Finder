package appointment;

public class Appointment {
    private String id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String date;
    private String time;
    private String service;
    private String propertyType;
    private String notes;
    private String timestamp;

    public Appointment(String id, String firstName, String lastName, String email, String phone,
                       String date, String time, String service, String propertyType,
                       String notes, String timestamp) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.date = date;
        this.time = time;
        this.service = service;
        this.propertyType = propertyType;
        this.notes = notes;
        this.timestamp = timestamp;
    }

    public String getId() { return id; }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getDate() { return date; }
    public String getTime() { return time; }
    public String getService() { return service; }
    public String getPropertyType() { return propertyType; }
    public String getNotes() { return notes; }
    public String getTimestamp() { return timestamp; }

    public void setId(String id) { this.id = id; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setDate(String date) { this.date = date; }
    public void setTime(String time) { this.time = time; }
    public void setService(String service) { this.service = service; }
    public void setPropertyType(String propertyType) { this.propertyType = propertyType; }
    public void setNotes(String notes) { this.notes = notes; }
    public void setTimestamp(String timestamp) { this.timestamp = timestamp; }
}
