# 4WARD Life Compass

## Project Description
An application that supports [4WARD Life Compass](https://4wardlc.com/), included functions are:
- LCI Test (similar to personality test)
- Seven Things (to-do-list with purpose)
- Campaign (to gather friends/family and compare Seven Things performance)
- Live Chat with POLL
- Goals Settings (goals based on LCI Test)

## Project Structure
The expected project sturcture will be as follows (adopting to MVVM with Provider):
```
lci-project
│
└─── Model
│
└─── Route
│
└─── DAO
│
└─── Screen (Views)
│
└─── Services
│
└─── View Model
│
└─── main.dart
```

## Git branching strategy
- master - Live branch (currently not applicable)
- version branch (v0.x.0) - Alpha version branches, all current development will be under latest branch here (latest v0.7.2)
- TEMP_BRANCH - only for project migration and project structure changes usage
