# 4WARD Life Compass

## Project Description
An application that support the basic functionality for [4WARD Life Compass](https://4wardlc.com/), included functions are:
- LCI Test (similar to personality test)
- Seven Things (to-do-list with purpose)
- Campaign (to gather friends/family and compare Seven Things performance)
- Live Chat with POLL
- Goals Settings (goals based on LCI Test)

## Project Structure
Current project structure is a mess, the projected/expected project sturcture will be as follows:
>Directories such as firebase functions and flutter web build will be excluded from this tree
```
lci-project
│
└─── Model
│    - Just like ordinary entity object class Example: User.dart
│
└─── Route
│    - Routing class, for easier navigation and application routes
│
└─── Screen (Views)
│    - UI of the application
│
└─── Services (Interface)
│    - Interface of the controllers, improve maintainability
│
└─── Controllers
│    - Main functions are declared here, communication between user interface and backend functions/data
│
└─── main.dart
```

## Git branching strategy
- master - Live branch (currently not applicable)
- version branch (v0.x.0) - Alpha version branches, all current development will be under latest branch here (latest v0.6.0)
- TEMP_BRANCH - only for project migration and project structure changes usage
