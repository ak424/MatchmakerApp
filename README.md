
**Matchmaker App - Matrimonial Card Interface (iOS)**

Project Description
MatchmakerApp is an iOS application that simulates a matrimonial app by displaying match cards similar to Shaadi.com's card format. The app fetches user data from an API, displays it using SwiftUI, and allows users to accept or decline matches. The app ensures persistence of user decisions even in offline mode by using Core Data.

This project is a small implementation of a larger vision aimed at creating a comprehensive matrimonial application with more advanced features and functionalities planned for future development. The UI is kept minimal to ensure a clean and user-friendly experience, which can be adjusted to meet any future requirements.

**Features**

API Integration: Seamlessly fetches user data from Random User API to provide a continuous stream of new user profiles.

Card Design: Elegantly displays user images and essential details on visually appealing cards, each equipped with Accept and Decline buttons for easy interaction.

Accept/Decline Functionality: Smoothly updates the UI and underlying database based on user actions, complete with pleasing animations to enhance the user experience when accepting or declining profiles.

Profile Listing: Presents user profiles in a card layout, showcasing user information alongside action buttons for efficient navigation and interaction.

Local Database: Utilizes Core Data to store user profiles and their statuses, ensuring seamless offline functionality with data caching and synchronization for a consistent user experience.

Design Patterns: Adopts the Model-View-ViewModel (MVVM) design pattern to separate concerns, enhancing code maintainability, testability, and scalability.

Error Handling: Implements comprehensive error handling mechanisms for API calls, database operations, and network connectivity issues, providing a robust and reliable user experience.

**Libraries Used**

UrlSession - For managing network requests.
SDWebImageSwiftUI - For downloading and showing images in the UI.
ReachabilitySwift - For checking and validating network connection.
lottie-ios - For showing amazing animations.

**Installation and Setup**

Clone the repository:
git clone https://github.com/ak424/MatchmakerApp.git 

Install dependencies:
Make sure you have CocoaPods installed. Run pod install.

Open the .xcworkspace file in Xcode:

Select your target device or simulator and hit the Run button in Xcode.

**Screenshots for reference:**
![Simulator Screenshot - iPhone 15 Pro - 2024-07-27 at 00 43 55](https://github.com/user-attachments/assets/e8d55bba-e4df-455d-a52a-e7265445ad43)
![Simulator Screenshot - iPhone 15 Pro - 2024-07-27 at 00 44 42](https://github.com/user-attachments/assets/ba88cf6c-eed9-445a-90b1-f6286e1f0519)
![Simulator Screenshot - iPhone 15 Pro - 2024-07-27 at 00 44 53](https://github.com/user-attachments/assets/73fcb9fd-ecfd-4acf-9714-452bd178009d)
![Simulator Screenshot - iPhone 15 Pro - 2024-07-27 at 00 45 01](https://github.com/user-attachments/assets/699a63a9-f241-47ee-ac23-5115034a747a)

