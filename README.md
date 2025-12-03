# Homestead Companion

Building software for users in their 70s requires a specific mindset: **High Contrast, Big Buttons, Low Latency, and Zero Ambiguity**.

This project uses **Flutter (Web)** for its ability to build "Chunky" UIs and **Firebase** for real-time updates and backend simplicity.

## Design Philosophy
- **Navigation**: Large, always-visible Bottom Navigation Bar.
- **Typography**: Base font size 18sp+. High contrast.
- **Input**: Minimize typing. Sliders, checkboxes, photo pickers.


## Modules
1. **The Flock**: Chicken management (Daily To-Do, Tasks).
2. **The Knowledge Base**: Wiki for homestead info.
3. **The Garden**: Visual layout and inventory for trees and beds.

## Current Status
- **Framework**: Flutter Web project initialized.
- **Backend**: Firebase integrated (Auth, Firestore).
- **Auth**: Email/Password Authentication implemented.
- **UI**: High-contrast theme and navigation shell implemented.
- **Modules Completed**:
    - **The Flock**: Daily tasks (dynamic), one-off tasks, flock info.
    - **Knowledge Base**: Firestore integration, Add/Edit/Delete items.
    - **The Orchard (Trees)**: Refactored file structure. List view, Detail view, Add/Edit functionality.
    - **The Garden**: Implemented. List gardens, visual layout (rows/beds/walkways), add/edit/delete zones.
    - **Knowledge Base Content**: Populated with ~75 items (Chickens, Trees, Garden).
- **In Progress**:
    - **The Learning Center**: On Hold (YouTube integration disabled).
- **Next Steps**: 
    - Add Cover Crop knowledge.
    - Refine Garden Manager UI.
