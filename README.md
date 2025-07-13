# 🗞️ NewsApplicationTechnozis

A Swift-based iOS News Application that supports offline-first architecture, Core Data storage, and user login with `UserDefaults`.

## 🚀 Features

- 📰 **News Feed**: Displays articles fetched from the server.
- 💾 **Offline Support**: Stores data using Core Data for access without internet.
- 🔐 **Login System**: Uses `UserDefaults` for persistent login.
- 🔄 **Manual Sync**: Updates content when internet is available with a sync button.
- 🌐 **Intelligent Merging**: Compares and merges local & remote changes during sync.
- 📅 **Last Sync Timestamp**: Tracks and stores the last sync using `UserDefaults`.

## 🧑‍💻 Tech Stack

- **Language**: Swift
- **Architecture**: MVVM
- **Persistence**: Core Data
- **User Defaults**: For login and sync info
- **Git**: Multi-branch development with PR-based workflow

## 📂 Branch Strategy

- `main`: Production-ready code  
- `development`: Active development  
- `PR/*`: Feature-specific pull request branches  

## 🧑‍🤝‍ Collaborators

- [@MynkRai](https://github.com/MynkRai)
- [@dharmeshKochariOS](https://github.com/dharmeshKochariOS)

## 📲 Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/Swapnilbaranwal/NewsApplicationTechnozis.git
