document.addEventListener("DOMContentLoaded", () => {
    const inquiriesContainer = document.getElementById("inquiriesContainer");
    const searchInput = document.getElementById("searchInput");
    const statusFilter = document.getElementById("statusFilter");
    const modal = document.getElementById("inquiryModal");
    const closeModal = document.querySelector(".close-button");
    const markResolved = document.getElementById("markResolved");
    const markInProgress = document.getElementById("markInProgress");
    const replyButton = document.getElementById("replyButton"); // New reply button
  
    let inquiriesData = [];
    let currentInquiry = null;
  
    async function fetchInquiries() {
      const res = await fetch("http://localhost:8086/api/inquiries");
      const data = await res.json();
      inquiriesData = data;
      displayInquiries(data);
    }
  
    function displayInquiries(data) {
      inquiriesContainer.innerHTML = "";
      const filtered = data.filter((inquiry) => {
        const searchMatch = inquiry.subject
          .toLowerCase()
          .includes(searchInput.value.toLowerCase());
        const statusMatch =
          statusFilter.value === "ALL" || inquiry.status === statusFilter.value;
        return searchMatch && statusMatch;
      });
  
      filtered.forEach((inquiry) => {
        const card = document.createElement("div");
        card.classList.add("card");
        card.innerHTML = `
            <h3>${inquiry.subject}</h3>
            <p><strong>${inquiry.clientName} || ${inquiry.clientEmail}</strong></p>
            <p>${inquiry.message.substring(0, 100)}...</p>
            <p><strong>Reply:</strong> ${
              inquiry.reply ? inquiry.reply : "Please add a reply"
            }</p>
            <span class="status ${inquiry.status}">${inquiry.status.replace(
          "_",
          " "
        )}</span>
          `;
        card.addEventListener("click", () => openModal(inquiry));
        inquiriesContainer.appendChild(card);
      });
    }
  
    function openModal(inquiry) {
      currentInquiry = inquiry;
      document.getElementById("modalSubject").textContent = inquiry.subject;
      document.getElementById("modalClientName").textContent = inquiry.clientName;
      document.getElementById("modalClientEmail").textContent =
        inquiry.clientEmail;
      document.getElementById("modalMessage").textContent = inquiry.message;
      document.getElementById("modalStatus").textContent = inquiry.status;
      modal.classList.remove("hidden");
    }
  
    closeModal.addEventListener("click", () => modal.classList.add("hidden"));
  
    markResolved.addEventListener("click", () => updateStatus("RESOLVED"));
    markInProgress.addEventListener("click", () => updateStatus("IN_PROGRESS"));
  
    replyButton.addEventListener("click", () => openReplyModal()); // Add event listener for reply button
  
    async function updateStatus(newStatus) {
      if (!currentInquiry) return;
      await fetch(
        `http://localhost:8086/api/inquiries/${currentInquiry.id}/status`,
        {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ status: newStatus }),
        }
      );
      modal.classList.add("hidden");
      fetchInquiries();
    }
  
    function openReplyModal() {
      const replyMessage = prompt("Enter your reply message:");
      if (!replyMessage) return;
  
      fetch(`http://localhost:8086/api/inquiries/${currentInquiry.id}/reply`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ reply: replyMessage }),
      })
        .then((res) => {
          if (!res.ok) throw new Error("Failed to send reply");
          alert("Reply sent successfully!");
        })
        .catch((err) => {
          console.error(err);
          alert("Something went wrong while sending the reply.");
        });
    }
  
    searchInput.addEventListener("input", () => displayInquiries(inquiriesData));
    statusFilter.addEventListener("change", () =>
      displayInquiries(inquiriesData)
    );
  
    fetchInquiries();
  });
  