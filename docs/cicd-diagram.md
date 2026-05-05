# CI/CD Pipeline Diagram

```mermaid
graph TD
A[Push to main] --> B[GitHub Actions Triggered]
B --> C[Run Smoke Test]
C --> D[Vercel Deployment]
D --> E[Live App]
```

## Deployment Links

Production:
https://jckmy-cs-326.vercel.app

Vercel:
https://vercel.com/mazeyboi25s-projects/jckmy-cs-326