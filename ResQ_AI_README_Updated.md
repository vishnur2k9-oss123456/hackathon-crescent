# 🚨 ResQ AI

> **A Smart Emergency Reporting and Response Coordination Platform for Faster Incident Reporting, Priority Assessment, and Emergency Team Recommendations.**

![Platform](https://img.shields.io/badge/platform-Web%20Application-blue.svg)
![Languages](https://img.shields.io/badge/language-Tamil%20%7C%20English-orange.svg)
![Maps](https://img.shields.io/badge/maps-OpenStreetMap-green.svg)
![Mode](https://img.shields.io/badge/mode-Demo%20%7C%20Server-lightgrey.svg)

---

## 📌 Problem Statement

During emergencies such as medical incidents, fires, and road accidents, people may struggle to report what happened and share their location quickly. Important details can be missed, and emergency reports may be difficult to organize and prioritize.

ResQ AI aims to make emergency reporting easier through a single web application. Users can submit incident details using text or supported voice input, request SOS assistance, and view report status. The system applies priority rules and can recommend suitable available response teams based on the incident information.

**ResQ AI is a reporting and coordination tool. It does not directly contact or dispatch real emergency teams.**

---

## 🎯 Objectives

1. Make emergency reporting simple and accessible.
2. Support Tamil and English voice/text reporting.
3. Help identify incident severity using priority rules and optional AI assistance.
4. Store reports and show their status.
5. Support offline report saving and later synchronization.
6. Display incident and team information on a map.
7. Help staff review incidents and recommended teams.

---

## 🚀 Features

| Feature | Description | Availability |
|---|---|---|
| **Emergency Reporting** | Submit incident details through a report form. | Demo and server mode |
| **SOS Support** | Open the phone's emergency call option using the 112 link. | Requires the user to tap Call |
| **Voice & Text Input** | Supports Tamil and English browser speech input, with a text fallback. | Chrome/Edge and internet for speech |
| **Priority Assessment** | Uses incident details and rules to identify priority levels and show reasons. | Rule-based fallback; optional AI |
| **Offline Report Queue** | Saves reports locally when offline and supports synchronization in server mode. | Browser storage; server needed for confirmation |
| **Incident Desk** | Allows staff to review incident reports and dashboard analytics. | Demo and server mode |
| **Team Recommendation** | Lists suitable available teams for an incident. | Staff view |
| **Map & Route View** | Displays incident/team locations and routes where routing is available. | Internet required |
| **Role-Based Access** | Provides different permissions for admin and responder accounts. | Server mode with Supabase |
| **Dark Mode** | Provides a dark interface option. | Available in the app |

---

## 🧠 How It Works

ResQ AI follows a simple emergency-reporting workflow:

```text
┌───────────────────────────────────────────────────────────┐
│                     RESQ AI WORKFLOW                      │
├───────────────────────────────────────────────────────────┤
│  STAGE 1: REPORT                                           │
│  User opens the app and submits an emergency report       │
│  using the form, text, voice input, or SOS option.         │
├───────────────────────────────────────────────────────────┤
│  STAGE 2: LOCATION & PRIORITY                              │
│  The app uses available location information and          │
│  incident details to calculate a priority level.          │
├───────────────────────────────────────────────────────────┤
│  STAGE 3: INCIDENT MANAGEMENT                              │
│  The report appears in the incident desk. Staff can        │
│  review details and update the incident status.            │
├───────────────────────────────────────────────────────────┤
│  STAGE 4: TEAM RECOMMENDATION & MAP                        │
│  The app can recommend suitable available teams and       │
│  show incident/team locations and routes when available.  │
└───────────────────────────────────────────────────────────┘
```

### 1. Emergency Reporting
- Users choose the emergency category and enter the incident details.
- Reports can be submitted through the report form.
- Voice input can help fill supported report fields.

### 2. Priority Assessment
- The app checks the report details using its priority rules.
- Details such as a large number of affected people or words such as `trapped` can raise the priority.
- If the server has an AI key configured, AI priority assistance can be used. Otherwise, the app uses a rule-based fallback.

### 3. Incident Management
- Staff can open an incident and review its details.
- Authorized staff can update incident status.
- The incident history records who updated the status and when.

### 4. Team Recommendation & Map
- The app can list the nearest available suitable teams as recommendations.
- The map can show an incident, a selected team, and a route when routing is available.
- A recommendation or assignment in the app does **not** mean that a real team has been contacted.

---

## 🏗️ Technology Stack

| Component | Technology | Purpose |
|---|---|---|
| **Frontend** | HTML, CSS and JavaScript | User interface and app interactions |
| **Database & Authentication** | Supabase | Shared data, staff login and roles in server mode |
| **Backend** | Node.js | Server-side application and API |
| **AI Assistance** | Anthropic API (optional) | AI-based priority assistance |
| **Maps** | Leaflet and OpenStreetMap | Map display |
| **Route Service** | Public OSRM server | Route calculation |
| **Voice Input** | Browser Web Speech API | Tamil (`ta-IN`) and English (`en-IN`) speech recognition |
| **Offline Support** | Browser local storage/queue | Save reports locally while offline |

---

## ⚙️ Installation & Setup

### Requirements

- Google Chrome or Microsoft Edge
- Internet connection for CDN libraries, maps, and browser speech recognition
- Node.js and npm for server mode
- A Supabase project for shared data, login, and roles
- An Anthropic API key only if AI priority assistance is required

### Option A: Run in Demo Mode

No backend setup is required.

1. Open the project folder.
2. Open `public/index.html` in Chrome.
3. Use the application in **DEMO MODE**.

> In demo mode, data is stored in that browser only. Demo accounts are not secure and must not be used for real emergency operations.

### Option B: Run in Server Mode

```bash
cd server
npm install
cp ../.env.example .env
npm start
```

The server runs at:

```text
http://localhost:3000
```

### Supabase Configuration

1. Create a Supabase project.
2. Open the Supabase SQL Editor.
3. Run `database/schema.sql`.
4. In **Dashboard → Authentication → Users**, create two staff users and enable auto-confirm.
5. Run the two `insert into profiles` statements at the bottom of `schema.sql`, using the staff users' email addresses.
6. Copy the Supabase URL, anon key, and service-role key into `server/.env`.
7. Keep the service-role key on the server only. Never expose it in frontend code.

### Optional AI Configuration

Add the following values to the server environment file:

```env
ANTHROPIC_API_KEY=your_api_key
AI_MODEL=your_preferred_model
```

The AI key is used by the server. If it is not configured, the application uses its rule-based priority fallback.

### Maps and Voice

- Maps use Leaflet and OpenStreetMap; no map API key is required for the current setup.
- Routing uses a public OSRM server. For heavy usage, configure your own routing server and follow OpenStreetMap tile usage policies.
- Voice input uses the browser Web Speech API and requires a supported browser and internet connection.
- If voice recognition is unavailable, users can enter the report using the text box.

### Frontend on Another Host

Set `window.RESQ_API_BASE` in `public/config.js` and configure `ALLOWED_ORIGIN` in the server `.env` file.

---

## 🔐 Demo Login Accounts

These accounts are available in **DEMO MODE only** and are shown on the sign-in screen.

| Role | Email | Password | Permissions |
|---|---|---|---|
| **Admin** | `admin@demo.resq` | `Admin#Demo1` | Assign, delete, update status, and change any team |
| **Responder** | `responder@demo.resq` | `Resp#Demo1` | Update incident status and team status; cannot assign or delete |

In server mode, these demo accounts do not exist. Use the Supabase staff accounts created during setup. Roles are enforced by the server.

---

## 🧪 Testing Checklist

1. **Medical report:** Home → Medical Emergency → complete the form → Submit. Check the priority reason.
2. **Tamil voice:** Report page → தமிழ் → Speak, or use the Tamil example button. Add a location manually if it is not extracted.
3. **English voice:** Try: `road accident near Velachery Chennai, 3 people hurt`. Check the category, location, and people fields.
4. **Location permission:** Deny GPS access → Home → SOS → Block location. After the 5-second countdown, check that the manual location box appears.
5. **Priority rules:** Test a report mentioning 25 or more people, or words such as `trapped`. Check the displayed priority reason.
6. **Team recommendation:** Sign in as admin → open an incident → check the Recommended Team list.
7. **Status update:** Open an incident → Update status → check the history.
8. **Offline queue:** In browser DevTools, select Network → Offline → submit a report. Check for **Saved Locally**. In server mode, reconnect and check **Syncing** followed by **Server Confirmed**.
9. **Map:** Sign in → Map → select an incident and team. Check the route or the dashed straight line fallback.
10. **Dashboard:** Open the Desk page and check the incident charts.
11. **Mobile layout:** Use browser DevTools device toolbar at a width of 375 px.
12. **Role permissions:** Sign in as responder and verify that Delete and Assign actions are refused.
13. **Failure handling:** Temporarily block the map, routing, or API services and check that the app displays suitable messages.

---

## ⚠️ Known Limitations

- The application has not been tested end-to-end in a browser in the development environment. Run the testing checklist before presenting or deploying it.
- Demo mode stores data in the current browser only. Demo accounts are not secure.
- SOS and report endpoints are public by design. They are rate-limited per IP in memory; production use needs CAPTCHA and a shared rate limiter.
- Voice understanding uses keyword rules, not AI. Tamil street names are not extracted; only known city/area names are recognized.
- Manually entered places receive an approximate map position from a small built-in city list. GPS is needed for exact positions.
- Changing the language reloads the page, so an unsent form may be cleared.
- Translation covers navigation, SOS, voice, categories, and sync states, but not every sentence.
- Server sessions use a Supabase access token stored in `sessionStorage` for one hour. There is no token refresh flow.
- Live updates use polling every 10 seconds, not WebSockets.
- Public map and routing services may be unavailable or have usage limits.

---

## 🛡️ Safety & Operational Disclaimer

- **Not an emergency dispatch service:** ResQ AI does not contact, dispatch, or guarantee the arrival of real emergency responders.
- **Use official emergency services:** In an actual emergency, users should contact the appropriate local emergency service directly. The app's 112 button opens the phone call link; the user must tap Call.
- **Recommendations need human action:** Team recommendations and assignments shown in the app are records or suggestions only. They are not proof that a team has received the request.
- **Demo mode is for demonstration:** Do not use demo accounts or browser-only data for real emergency operations.
- **Production readiness:** Before real-world deployment, obtain authorized emergency-service integration, security review, monitoring, and appropriate operational approval.

---

## 👥 Project Information

**Project Name:** ResQ AI  
**Project Type:** Emergency Reporting and Response Coordination Web Application  
**Previous Version:** ResQ Emergency Response (Round 1)

The original Round 1 app design and core pages are preserved, including the report form, severity scoring, incident desk, incident detail page, and dark mode. The upgrade was made in place in `public/index.html`, rather than rewriting the application.
