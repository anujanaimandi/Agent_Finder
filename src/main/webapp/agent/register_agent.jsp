<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register Agent</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #e0e7ff;
            --primary-dark: #3a56d4;
            --dark: #1e293b;
            --gray: #64748b;
            --light: #f8fafc;
            --white: #ffffff;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            --shadow-hover: 0 10px 15px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            --radius: 12px;
            --radius-sm: 8px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--light);
            color: var(--dark);
            line-height: 1.6;
            padding: 2rem;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .registration-container {
            max-width: 500px;
            width: 100%;
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 2.5rem;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--primary);
            background: linear-gradient(90deg, #4361ee, #3a0ca3);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .form-header p {
            color: var(--gray);
            font-size: 0.95rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark);
            font-size: 0.9rem;
        }

        .input-field {
            position: relative;
        }

        input {
            width: 100%;
            padding: 0.8rem 1rem 0.8rem 2.5rem;
            border: 1px solid #e2e8f0;
            border-radius: var(--radius-sm);
            font-size: 0.95rem;
            transition: var(--transition);
            background-color: var(--light);
        }

        input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
            font-size: 0.9rem;
        }

        .submit-btn {
            width: 100%;
            background: var(--primary);
            color: var(--white);
            border: none;
            padding: 0.9rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .submit-btn:hover {
            background: var(--primary-dark);
            box-shadow: var(--shadow-hover);
            transform: translateY(-2px);
        }

        .submit-btn i {
            font-size: 0.9rem;
        }

        /* Floating label animation */
        .floating-label-group {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .floating-label {
            position: absolute;
            left: 2.5rem;
            top: 0.8rem;
            color: var(--gray);
            font-size: 0.95rem;
            pointer-events: none;
            transition: all 0.2s ease;
            background: var(--light);
            padding: 0 0.3rem;
        }

        input:focus ~ .floating-label,
        input:not(:placeholder-shown) ~ .floating-label {
            top: -0.6rem;
            left: 1.7rem;
            font-size: 0.75rem;
            color: var(--primary);
            background: var(--white);
        }

        @media (max-width: 576px) {
            body {
                padding: 1rem;
            }

            .registration-container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>


    <div class="registration-container">
        <div class="form-header">
            <h2>Join Our Team</h2>
            <p>Complete the form to become a registered agent</p>
        </div>

        <form action="<%= request.getContextPath() %>/upload_agent" method="post">
            <div class="form-group">
                <div class="input-field">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="name" name="name" placeholder=" " required>
                    <label for="name" class="floating-label">Full Name</label>
                </div>
            </div>

            <div class="form-group">
                <div class="input-field">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" id="email" name="email" placeholder=" " required>
                    <label for="email" class="floating-label">Email Address</label>
                </div>
            </div>

            <div class="form-group">
                <div class="input-field">
                    <i class="fas fa-phone input-icon"></i>
                    <input type="text" id="phoneNumber" name="phoneNumber" placeholder=" " required>
                    <label for="phoneNumber" class="floating-label">Phone Number</label>
                </div>
            </div>

            <div class="form-group">
                <div class="input-field">
                    <i class="fas fa-building input-icon"></i>
                    <input type="text" id="agencyName" name="agencyName" placeholder=" " required>
                    <label for="agencyName" class="floating-label">Agency Name</label>
                </div>
            </div>

            <button type="submit" class="submit-btn">
                <i class="fas fa-user-plus"></i> Register Agent
            </button>
        </form>
    </div>

</body>
</html>