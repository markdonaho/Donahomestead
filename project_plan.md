# Homestead Companion - Project Plan

## Overview
Building software for users in their 70s requires a specific mindset: **High Contrast, Big Buttons, Low Latency, and Zero Ambiguity**.
This project uses **Flutter (Web)** for its ability to build "Chunky" UIs and **Firebase** for real-time updates and backend simplicity.

## Phase 1: The "Grandparent" UI/UX Framework
Before coding features, we need a strict design system to ensure usability.

- **Navigation**: Avoid "Hamburger" menus. Use a large, always-visible **Bottom Navigation Bar** with labels (e.g., "Garden", "Trees", "Chickens").
- **Typography**: Base font size should be **18sp or 20sp**. High contrast (Black text on white background, avoid light greys).
- **Input**: Minimize typing. Use sliders, oversized checkboxes, and photo pickers.

## Phase 2: Project Setup & "The Flock" (Chickens)
Start here for immediate daily value (the To-Do list).

### 1. Infrastructure
- Initialize Flutter Web project.
- Setup Firebase (Firestore for data, Auth for login, Hosting for the web app).
- **Auth Strategy**: Email/Password Authentication (implemented).

### 2. Chicken Module
- **Daily To-Do**: A list of booleans that resets every night at 4 AM.
- **Tasks**: Feed, Water, Collect Eggs, Coop Door Check.
- **Flock Info (Static)**: A simple card showing the count (6) and maybe names/breeds.

## Phase 3: The Knowledge Base (The Brain)
A simple "Wiki" to support other modules.

### 1. Data Structure
- **Collection**: `knowledge_items`
- **Fields**: `title`, `category` (Chicken, Veggie, Tree, Pest), `content` (text), `image_url`.

### 2. Features
- **ListView**: A searchable list of cards.
- **Detail View**: Large image at the top, readable text below.
- **Editor**: A simple form to Add/Edit content.
- **Content Population**:
    - [ ] Current Garden items (Veggie varieties)
    - [ ] Tree varieties (Apple, Pear, etc.)
    - [ ] Cover Crop knowledge
    - [ ] Chicken care knowledge

## Phase 4: Trees (The Orchard)
Simple inventory management for the trees.

### 1. Features
- **List view**: List of the trees (Apple, Pear, etc.).
- **Detail view**: Photo, Type, Age, and "Notes/Log" (e.g., "Pruned on Nov 2025").

## Phase 5: The Garden (Visual Layout)
Abstract the "layout" so it doesn't become a complex drawing tool.

### 1. Garden Manager
Use a "Row Stack" approach instead of a grid.

- **Garden Container**: Define "Big Garden" or "Raised Bed 1".
- **The Layout**: A vertical list representing the physical space.
- **Item Types**: "Plant Row", "Walkway", "Empty Bed".
- **Interaction**: Click big "+" button -> "Add Row" -> Choose from Knowledge Base -> Appears in list.

## Phase 5: Testing & Deployment
- **The "Dad" Test**: Hand the tablet to your dad without explaining how it works.
- **Deploy**: Firebase Hosting.

## Phase 6: The Learning Center (YouTube Integration) - **IN PROGRESS**
We have added a "Learning Center" tab to the Knowledge Base, currently testing with a single video.

### 1. Strategy
- **Scenario**: Mom clicks on "Learning Center" tab.
- **Result**: A large video player shows the "Homesteading" playlist.

### 2. Technical Implementation
- **Package**: `youtube_player_iframe` (Flutter Web standard).
- **Data Model**: Added `youtubePlaylistId` to `knowledge_items`.
- **Current Status**: 
    - [x] Basic Player Integration
    - [ ] Full Playlist Support (Currently single video for testing)
    - [ ] Dynamic Playlist ID handling

### 3. UX Implementation
- **Tabs**:
    1.  **Library**: The list of Knowledge Items.
    2.  **Learning Center**: The YouTube Player.

## Data Model Preview (Firestore)

```json
// collections

users: { uid, name, role }

daily_tasks: {
  date: "2025-12-02",
  tasks: [
    { title: "Feed Chickens", completed: true, completed_by: "Dad" },
    { title: "Water Raised Beds", completed: false }
  ]
}

gardens: {
  id: "main_garden",
  name: "Big Garden",
  // Instead of complex grids, just an ordered list of zones
  zones: [
    { type: "row", content: "Potatoes", status: "planted" },
    { type: "walkway", width: "2ft" },
    { type: "row", content: "Corn", status: "sprouting" }
  ]
}

knowledge_base: {
  id: "tomato_cherokee_purple",
  name: "Cherokee Purple Tomato",
  type: "plant",
  days_to_harvest: 80,
  notes: "Dad's favorite. Needs extra calcium."
}
```
