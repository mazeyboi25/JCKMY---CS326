# Technical Debt

## List of Technical Debts

1. No proper validation for school email login  
   - Login currently allows invalid email formats

2. Listings not optimized for performance  
   - All items load at once instead of pagination

3. Chat system not fully real-time  
   - Messages may delay or not refresh instantly

4. Sell item form lacks validation  
   - Missing checks for empty fields (title, price)

5. No loading states in UI  
   - Users don’t see feedback during data fetching

---

## Selected Debt to Fix

**Debt Chosen:** Sell item form lacks validation  

### Reason:
This directly affects core functionality (posting items).  
Fixing this improves reliability and user experience.

---

## Refactoring Done

- Added validation for required fields:
  - Title
  - Price
  - Description
- Prevent submission if fields are empty
- Added error messages for users
- Improved form structure for better readability
