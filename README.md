# ArticApp - Art Institute of Chicago Collection Browser

A modern iOS app built with SwiftUI that allows users to browse and explore artworks from the Art Institute of Chicago's collection using their public API.

## 🎨 Features

### Core Functionality
- **Artist Selection**: Browse artworks by popular artists (15 curated artists) or search for custom artists
- **Infinite Scroll**: Seamlessly load more artworks as you scroll (20 items per page)
- **High-Quality Images**: Display artworks using IIIF (International Image Interoperability Framework)
- **Detailed View**: View artwork details with full-screen image capability
- **Pull-to-Refresh**: Refresh content with a simple pull gesture
- **Toast Notifications**: User-friendly feedback for actions and errors

### Technical Features
- **Offline Support**: Queue requests when offline and process them when connection is restored
- **Smart Caching**: Cache data locally with 5-minute TTL for optimal performance
- **Network Monitoring**: Real-time network status indicator
- **Error Handling**: Graceful error handling with user-friendly messages
- **Modern UI**: Clean, responsive design with adaptive grid layout

## 🏗️ Architecture

### Design Patterns
- **MVVM Architecture**: Clean separation of concerns with SwiftUI ViewModels
- **Repository Pattern**: Abstracted data access through protocols
- **Actor-based Concurrency**: Thread-safe operations using Swift actors
- **Combine Framework**: Reactive programming for network monitoring

### Key Components

#### Models
- `Artwork`: Core data model for artwork information
- `PaginationInfo`: Pagination metadata from API responses

#### Networking
- `APIClient`: Handles API communication with error handling and retry logic
- `NetworkMonitor`: Monitors network connectivity status using Combine
- `OfflineQueue`: Manages offline request queuing and processing

#### Persistence
- `JSONDiskCache`: Actor-based thread-safe disk caching with TTL support

#### ViewModels
- `ArtworksViewModel`: Main view model managing artwork data and state
- `ArtistSelectionViewModel`: Handles artist search and selection
- `ArtworkDetailViewModel`: Manages artwork detail view state

#### Views
- `ArtworksGridView`: Main grid view with infinite scroll and adaptive layout
- `ArtworkDetailView`: Detailed artwork view with full-screen image capability
- `ArtistSelectionView`: Artist selection interface with search functionality
- `ArtworkCardView`: Reusable artwork card component

#### Components
- `ErrorView`: Error display with retry functionality
- `LoadingView`: Loading indicator component
- `NetworkStatusView`: Network status indicator
- `ToastView`: Toast notification system

#### Utilities
- `AppLogger`: Thread-safe logging system with categories and levels
- `IIIF`: Image URL generation for Art Institute's IIIF server
- `AppDependencies`: Dependency injection container

## 🚀 Getting Started

### Prerequisites
- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

### Installation
1. Clone the repository
2. Open `ArticApp.xcodeproj` in Xcode
3. Build and run the project

### Dependencies
- **Kingfisher**: Image loading and caching library
- **Combine**: Reactive programming framework (built-in)
- **Network**: Network monitoring (built-in)

## 📱 Usage

### Browsing Artworks
1. Launch the app to see artworks by Vincent van Gogh (default)
2. Tap "Change Artist" to select from popular artists or search for a custom artist
3. Scroll down to load more artworks automatically
4. Tap on any artwork to view details

### Viewing Details
- Tap artwork image to view full-screen
- Pinch to zoom and pan around the image
- Use action buttons to share or view full size

### Offline Usage
- The app works offline using cached data
- Requests are queued when offline and processed when connection is restored
- Network status is indicated in the header

## 🧪 Testing

The project includes unit tests covering:
- **Model Tests**: Artwork model functionality and data validation
- **Error Handling**: AppError enum and error message testing
- **Utility Tests**: IIIF URL generation and AppLogger functionality
- **Constants Tests**: App constants and API endpoints validation
- **ViewModel Tests**: Basic ViewModel structure and property testing

**Note**: Currently, the tests use basic mock data and don't include comprehensive mock services for network, cache, or repository layers. The test comments indicate that proper dependency mocking would be needed for full test coverage.

Run tests using:
```bash
xcodebuild test -scheme ArticApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🎯 Assignment Requirements Compliance

### ✅ User Interface
- **Intuitive & Modern**: Clean, modern UI with smooth animations
- **Thumbnail & Detail Views**: Grid view with detailed artwork information
- **Pull-to-Refresh**: Implemented with smooth animations

### ✅ Caching
- **Local Storage**: JSONDiskCache with file system persistence
- **5-minute TTL**: Automatic cache expiration
- **Cache-First Loading**: Uses cache when available and not expired

### ✅ Resilience
- **Error Handling**: Comprehensive error handling with user feedback
- **Offline Queue**: Requests queued when offline, processed when online
- **Network Monitoring**: Real-time connectivity status

### ⚠️ Testing
- **Unit Tests**: Basic test coverage for models, utilities, and constants

## 🛠️ Technical Decisions

### Infinite Scroll vs Pagination
**Chosen: Infinite Scroll**
- Better user experience for browsing large collections
- Reduces cognitive load of page navigation
- More modern and intuitive interaction pattern

### Network Resilience Strategy
- **Offline Queue**: Requests stored when offline, processed when online
- **Cache Fallback**: Shows cached data when network fails
- **Retry Logic**: Automatic retry with exponential backoff

### Image Loading
- **Kingfisher**: Industry-standard image loading library
- **IIIF Integration**: Direct integration with Art Institute's IIIF server
- **Progressive Loading**: Placeholder → low-res → high-res loading sequence

## 🔮 Future Enhancements

### Planned Features
- **Favorites**: Save favorite artworks locally
- **Enhanced Search**: Global search across all artworks with filters
- **Categories**: Browse by artwork categories and periods
- **Social Features**: Share artworks on social media
- **Accessibility**: Enhanced accessibility support

### Technical Improvements
- **Mock Services**: Implement comprehensive mock services for testing
- **Image Preloading**: Preload next page images for smoother scrolling
- **Analytics**: User interaction tracking and performance metrics
- **Performance Optimization**: Further memory and performance optimizations
- **Test Coverage**: Expand test coverage with proper dependency injection

## 📄 License

This project is created for educational and assessment purposes as part of a technical interview process.

## 👨‍💻 Author

Created by Zeynep Seyis as a technical assessment for iOS engineering position.

---

## 📋 Project Status

**Current Implementation Status:**
- ✅ Core functionality implemented
- ✅ Clean architecture with MVVM pattern
- ✅ Offline support and caching
- ✅ Modern SwiftUI interface
- ⚠️ Basic test coverage (needs mock services)
- ❌ Comprehensive mock services for testing

