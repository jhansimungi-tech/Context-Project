# Architectural Context

## Overview

This document provides the architectural context for the JKYog platform ecosystem. All TestSprite assignments reference this file as the foundation for understanding the system under test.

## Repositories

| # | Repo | Stack | Purpose |
|---|------|-------|---------|
| 1 | `1_JKYog_2.0` | Next.js / React | Main public-facing web application (Online Classes, Donations, Events, About, Profile) |
| 2 | `2_radhakrishnatemple2.0` | Next.js / React | Temple site (Puja Services, Calendar, Yoga Fest, Donations, Book Tickets) |
| 3 | `3_JKYog_2.0_backend` | NestJS / TypeScript | Backend API (User, Payment, Stripe, PayPal, Notification, Email services) |
| 4 | `4_JKYog_Strapi` | Strapi v4 | Headless CMS (Articles, Blogs, FAQs, Events, Carousels, Testimonials, Navigation, Config) |
| 5 | `5_jkyog_auth_backend` | Node.js / Express | Authentication microservice (OTP sign-in, refresh tokens) |

## Frontend Architecture (Repos 1 & 2)

- **Framework:** Next.js App Router
- **UI:** React functional components with hooks
- **State:** Zustand stores (`useUserStore`, `useLessonPlayer`)
- **Auth:** Supabase Auth (OTP + OAuth via Google/Apple)
- **Payments:** Stripe Elements (`@stripe/react-stripe-js`) + PayPal
- **Styling:** Tailwind CSS + component-level modules

## Backend Architecture (Repo 3)

- **Framework:** NestJS with modular controllers/services
- **Key Modules:** `UserModule`, `PaymentModule`, `StripeModule`, `PaypalModule`, `NotificationModule`, `EmailModule`
- **External Services:** Stripe API, PayPal API, Postmark (email), Firebase Cloud Messaging (FCM)
- **Auth Guard:** JWT-based guards on protected endpoints

## CMS Architecture (Repo 4)

- **Framework:** Strapi v4 with custom content types
- **Content Types:** Defined via `schema.json` files in `src/api/<type>/content-types/<type>/`
- **Controllers:** Core controllers via `createCoreController` factory
- **Routes:** Core routers via `createCoreRouter` factory
- **API Pattern:** `api::<content-type>.<content-type>` (e.g., `api::online-class.online-class`)

## Auth Microservice (Repo 5)

- **Framework:** Express.js
- **Flow:** Phone/email OTP -> `verify_otp` -> JWT access + refresh tokens
- **Token Refresh:** `getNewAccessToken` via refresh token rotation
