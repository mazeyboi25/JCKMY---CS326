# Defect Log

## Bug Entry

Bug ID: 001  
Title: Login allows non-school email  
Description: The login system accepts emails that are not from a school domain, which breaks the student-only restriction.

Severity: High  
Status: Closed  
Assigned To: Backend Developer  

### Steps to Reproduce
- Open Login Screen
- Enter a non-school email (e.g., user@gmail.com)
- Enter password
- Click "Login / Sign Up"

### Expected Result
System should reject the email and show an error message:
"Please use a valid school email"

### Actual Result
User is allowed to log in without verification

### Fix Applied
Added validation to only allow school email domains

### Resolution
Bug fixed and tested successfully
