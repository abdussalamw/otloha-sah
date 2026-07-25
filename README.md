# Otloha Sah – Project Repositories Overview

This package contains all core components of the **Otloha Sah** application.  
The project is divided into **Django backend services** and **Flutter mobile applications**.


.
├── django
│ ├── OtlohaSah # Main backend (users, orders, admin, API)
│ ├── QuranAPI # Quran API service (surahs/ayahs data)
│ └── QuranAPIServer # Deployment wrapper/server for QuranAPI
└── flutter
├── Otloha-Sah-Flutter # Main mobile application UI
└── quran_flutter_widget # Reusable Quran reader widget

## Repository Structure

| Path | Name | Type | Description | Working Branches |
|-----|------|------|-------------|-----------------|
| `django/OtlohaSah` | OtlohaSah Backend | Django / DRF | Main backend service (users, orders, api, admin panel). | `main` (stable) |
| `django/QuranAPI` | Quran API | Django / DRF | Provides Quran text and ayah endpoints used by mobile apps. | `main` |
| `django/QuranAPIServer` | Quran API Server | Django Project | Deployment wrapper/server for the Quran API. | `main` |
| `flutter/Otloha-Sah-Flutter` | Otloha Sah Mobile App | Flutter App | The main user mobile application (UI for ordering & tracking). | `main` (for mobile app), `flutter_web` (for web app) |
| `flutter/quran_flutter_widget` | Quran Flutter Widget | Flutter Package | Reusable Quran reader widget, can be used in other apps. | `player` (for mobile app), `flutter_web` (for web app) |

---

## Notes

- Backend services require `.env` configuration before running.
- Flutter applications require API base URLs to be set.
- Each folder contains its own project code and can be developed independently.

---

## Handover

For setup, deployment, or build guidance — refer to internal project documentation or contact the previous maintainer.


