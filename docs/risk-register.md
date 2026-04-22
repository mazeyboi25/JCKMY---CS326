# Risk Score = Likelihood (1-5) * Impact (1 -5)
## 1. Fake student accounts / invalid verification
### Likelihood: 4
### Impact: 5
### Risk Score: 20
### Owner: Backend Developer
### Mitigation: Restrict to school emails, OTP verification, optional ID upload
### Contingency: Disable suspicious accounts, manual verification

## 2. Login system failure
### Likelihood: 3
### Impact: 5
### Risk Score: 15
### Owner: Backend Developer
### Mitigation: Use Firebase/Auth, validate inputs, test login flows
### Contingency: Password reset, fallback error handling

## 3. Chat system delay or failure
### Likelihood: 3
### Impact: 4
### Risk Score: 12
### Owner: Backend Developer
### Mitigation: Use real-time database, test message delivery
### Contingency: Refresh chat, notify users

## 4. Image upload failure
### Likelihood: 3
### Impact: 4
### Risk Score: 12
### Owner: Frontend Developer
### Mitigation: Limit file size, validate formats, use cloud storage
### Contingency: Retry upload, show error message

## 5. Poor UI/UX
### Likelihood: 3
### Impact: 3
### Risk Score: 9
### Owner: Frontend Develoepr
### Mitigation: Follow simple layout, test with users
### Contingency: Redesign screens based on feedback

## 6. Data loss / database issues
### Likelihood: 2
### Impact: 5
### Risk Score: 10
### Owner: Backend Developer
### Mitigation: Use cloud DB with backups, validate data
### Contingency: Restore backups

## 7. Low user adoption
### Likelihood: 3
### Impact: 4
### Risk Score: 12
### Owner: Project Manager
### Mitigation: focus on useful features, promote in campus
### Contingency: Improve features, add incentives

## 8. Deployement failure
### Likelihood: 2
### Impact: 5
### Risk Score: 10
### Owner: Git Manager
### Mitigation: Test deployment first, use reliable hosting
### Contingency: Rollback and redeploy