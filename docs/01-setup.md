# Repo Setup

## Prerequisites

- Node.js >= 18.x
- npm or yarn
- Git
- A code editor (VS Code recommended)

## Clone Repositories

```bash
# Clone the repositories you need based on your assignment
git clone <repo-url>/1_JKYog_2.0.git
git clone <repo-url>/2_radhakrishnatemple2.0.git
git clone <repo-url>/3_JKYog_2.0_backend.git
git clone <repo-url>/4_JKYog_Strapi.git
git clone <repo-url>/5_jkyog_auth_backend.git
```

## Frontend Setup (Repos 1 & 2)

```bash
cd 1_JKYog_2.0        # or 2_radhakrishnatemple2.0
npm install
cp .env.example .env.local   # Configure environment variables
npm run dev                  # Start dev server
```

## Backend Setup (Repo 3)

```bash
cd 3_JKYog_2.0_backend
npm install
cp .env.example .env         # Configure database, Stripe, PayPal, Postmark keys
npm run start:dev            # Start NestJS dev server
```

## CMS Setup (Repo 4)

```bash
cd 4_JKYog_Strapi
npm install
cp .env.example .env         # Configure database and admin credentials
npm run develop              # Start Strapi admin panel
```

## Auth Backend Setup (Repo 5)

```bash
cd 5_jkyog_auth_backend
npm install
cp .env.example .env         # Configure OTP provider and JWT secrets
npm run dev                  # Start Express server
```

## Testing Framework Setup

```bash
# Install Playwright (recommended) or Cypress
npm init playwright@latest
# or
npm install cypress --save-dev
```

## Environment Variables

Contact your team lead for the required `.env` values for each repository. Never commit `.env` files to the repository.

## Verification

After setup, verify each service is running:
- Frontend: `http://localhost:3000`
- Backend API: `http://localhost:3001`
- Strapi Admin: `http://localhost:1337/admin`
- Auth Service: `http://localhost:4000`
