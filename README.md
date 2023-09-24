# To-Do List 

A simple and efficient To-Do List app, built using SwiftUI and Core Data.

## Features
- Create, update, and delete tasks.
- Mark tasks as completed.
- Filter tasks by their completion status.
- Sort tasks by date or status.
- Color-coded urgency levels for tasks.
- Animations for task completion and addition.

## Tech Stack

### SwiftUI
- Used for the entire UI of the app.
- Utilized many of its features like `NavigationView`, `List`, `ForEach`, and `Button` among others.
- Implemented transitions and animations for a more interactive user experience.

### Core Data
- Primary storage solution for the tasks.
- Used `@FetchRequest` to retrieve stored tasks.
- Integrated with SwiftUI for real-time UI updates.

### Navigation
- Utilized `NavigationLink` for navigating between main list and task editing views.

### State Management
- Made use of `@State`, `@Environment`, and `@ObservedObject` to manage and respond to changes in data.

## Getting Started

1. Clone the repository:
```
git clone [Your Repository URL]
```

2. Open the project in Xcode.

3. Build and run the project on an iOS simulator or a real device.

