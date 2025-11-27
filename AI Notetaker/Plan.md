# Proposed Plan

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS AI Note Taker application built with SwiftUI and SwiftData that allows users to create and manage different types of notes including audio recordings, uploaded files, text input, and web links.

## Technology Stack

- **Platform**: iOS (SwiftUI)
- **Language**: Swift
- **Data Persistence**: CoreData 
- **Architecture**: MVVM (Model-View-ViewModel)
- **UI Framework**: SwiftUI with NavigationSplitView
- **Project File**: `AI Notetaker.xcodeproj` (Use existing xcodeproj and make necessary changes to ContentView)

### Some Proposed Note Types
Based on requirements and mockups in `MockUI/`:
1. **Audio recordings** -  from device microphone
2. **Uploaded audio files** - from device storage
3. **PDF/text files** - document uploads
4. **Text input** - manual text entry
5. **Web links** - YouTube videos and website content fetching

### Git Workflow
- Create repository
- Create git checkpoints after each milestone completion
- Current branch: main
- Recent commits tracked with milestone markers

## Mock UI Designs
Reference mockups in `MockUI/` folder:
- `MainScreen`: Main note list screen with filters
- `RecordAudio.PNG`: Audio recording interface
- `Input-Text.PNG`: Text input interface
- `PDF-Text.PNG`: Document upload interface
- `Web-Link.PNG`: Web link integration interface

## Key Requirements from Planning

1. **Main Screen**: Filterable list of all note types
2. **Content Handling**: Use appropriate tools to open each note type
3. **Local Storage**: All notes stored locally on iPhone using SwiftData
4. **Web Integration**: Fetch and display web content for YouTube/websites
5. **Milestones**: Checkpoint in git after each major feature completion

## Development Considerations

- **SwiftData Evolution**: expansion to support multiple note types
- **File Handling**: Will need proper file management system for audio/PDF uploads
- **Web Content**: Implement web scraping/content fetching for link processing
- **UI Implementation**: Match mockup designs in MockUI folder
- **Testing**: Test with various file types and content sources
