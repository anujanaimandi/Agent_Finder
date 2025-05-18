document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("inquiryForm");
  const listContainer = document.getElementById("inquiryList");

  // Handle form submission
  if (form) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();

      const formData = {
        clientName: e.target.clientName.value,
        clientEmail: e.target.email.value,
        subject: e.target.subject.value,
        type: e.target.type.value,
        agentName: e.target.agentName?.value || null,
        message: e.target.message.value,
      };

      fetch("http://localhost:8086/api/inquiries", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      })
        .then((res) => {
          if (!res.ok) throw new Error("Failed to submit inquiry");
          return res.json();
        })
        .then((data) => {
          alert("Inquiry submitted successfully!");
          form.reset();
          location.reload(); // Refresh to show the new inquiry
        })
        .catch((err) => {
          console.error(err);
          alert("Something went wrong while submitting the inquiry.");
        });
    });
  }

  // Fetch and display inquiries
  if (listContainer) {
    fetch("http://localhost:8086/api/inquiries")
      .then((response) => {
        if (!response.ok) throw new Error("Failed to fetch inquiries");
        return response.json();
      })
      .then((data) => {
        listContainer.innerHTML = "";
        if (data.length === 0) {
          listContainer.innerHTML = "<p>No inquiries submitted yet.</p>";
          return;
        }

        data.forEach((inquiry) => {
          const card = document.createElement("div");
          card.className = "inquiry-card";

          card.innerHTML = `
            <h3>${inquiry.subject}</h3>
            <p><strong>Status:</strong> ${inquiry.status}</p>
            <p><strong>Message:</strong> ${inquiry.message}</p>
            <p><strong>Type:</strong> ${inquiry.type || "N/A"}</p>
            <p><strong>Submitted By:</strong> ${inquiry.clientName} (${inquiry.clientEmail})</p>
            <p><strong>Reply:</strong> ${
              inquiry.reply ? inquiry.reply : "Please expect a reply from admin."
            }</p>
            <button class="delete-btn" data-id="${inquiry.id}">Delete</button>
          `;

          listContainer.appendChild(card);
        });

        // Add event listeners for delete buttons
        document.querySelectorAll(".delete-btn").forEach((btn) => {
          btn.addEventListener("click", function () {
            const inquiryId = this.getAttribute("data-id");
            if (confirm("Are you sure you want to delete this inquiry?")) {
              fetch(`http://localhost:8086/api/inquiries/${inquiryId}`, {
                method: "DELETE",
              })
                .then((res) => {
                  if (!res.ok) throw new Error("Failed to delete inquiry");
                  alert("Inquiry deleted successfully.");
                  location.reload();
                })
                .catch((err) => {
                  console.error(err);
                  alert("Failed to delete inquiry. Please try again.");
                });
            }
          });
        });
      })
      .catch((error) => {
        console.error(error);
        listContainer.innerHTML = `<p style="color:red;">Failed to load inquiries. Please try again later.</p>`;
      });
  }
});
