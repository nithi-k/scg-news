<!DOCTYPE html>
<html>
<head>
</head>
<body>
  <h1>SCG News</h1>
 
<div align="center">
  <img src="https://user-images.githubusercontent.com/5418396/232339742-dfba2d38-eca3-4ce0-a566-b0c88e04d1d5.PNG" alt="List" width="400">
  <img src="https://user-images.githubusercontent.com/5418396/232339752-e20a2ae7-d142-4a4c-a5a6-0a9a8e02746b.PNG" alt="Detail" width="400">
</div>

  
 
  <h2>How to Run</h2>
  <ol>
    <li>Open the "App" folder and run <code>pod install</code>.</li>
    <li>Swap the development profile as needed at Signing &amp; Capabilities and edit the user pod profile in the Podfile configuration.</li>
    <li>Press run on your desired device (Simulator or Real device) in Xcode.</li>
  </ol>

  <h2>How to Use</h2>
  <h3>News Search</h3>
  <ul>
    <li>On the News Search screen, users can search for articles by typing keywords in the search bar and pressing Enter or the search button.</li>
    <li>The search results will be displayed as a list of articles with their titles and descriptions.</li>
    <li>Users can tap on any article to view its details on the Detail screen.</li>
  </ul>

  <h3>Detail</h3>
  <ul>
    <li>On the Detail screen, users can view the detailed information of a selected article, including the title, description, author, and date published.</li>

  <h2>Current Features</h2>
  <ul>
    <li>REST API integration with <a href="https://newsapi.org/" target="_blank">https://newsapi.org/</a> to fetch news articles.</li>
    <li>Pagination for loading more articles as the user scrolls.</li>
    <li>Search functionality to search for articles based on keywords.</li>
    <li>Custom presentation transition for smooth transitions between screens.</li>
    <li>Modular architecture implementation with MVVM-C pattern for better maintainability and reusability.</li>
    <li>Unit Tests for ArticleSearch module to ensure code quality and functionality.</li>
    <li>Custom API layer built on top of Networking for encapsulating API calls.</li>
  </ul>

  <h2>Future Release</h2>
  <ul>
    <li>Localization support for other languages.</li>
    <li>News topic and headline filtering for more targeted search results.</li>
    <li>UI Tests for further testing and ensuring the user interface behavior.</li>
    <li>Dynamic date query from</li>
  </ul>

  <h2>Architecture</h2>
  <p>The project follows the MVVM-C (Model-View-ViewModel with Coordinator) architecture, which provides a separation of concerns and promotes testability and maintainability. The Coordinator pattern is used for navigation and flow control between screens.</p>

  <h2>Folder Structure</h2>
  <p>The project has the following folder structure:</p>
  <ul>
    <li><em>Module</em> folder: Contains the local development pod, which is a separate module encapsulating specific functionality of the application.</li>
  </ul>

  <h2>Module</h2>
  <p>The module in developmentpod are</p>
  <ul>
    <li>Core: Contains all the main protocols for the app to make it scalable and standardized.</li>
    <li>Core UI: Contains all the base components, including app styles such as fonts, layouts, and colors.</li>
    <li>APILayer: Contains all the service files, along with a customized interface for the News API on top of networking to make the code cleaner and easier to read.</li>
    <li>Utils: Contains all the extension and helper files.</li>
    <li>AppCoordinator: Serves as the root coordinator that connects all the sub-modules inside the app..</li>
    <li>NewsArticle: Represents the module for the News feature, which includes search, detail, and custom transitions.</li>
  </ul>


  <h2>Tests</h2>
  <p>The project includes Unit Tests for the ArticleSearch module to ensure code quality and functionality. These tests are designed to be self-testable and self-buildable, and they can be extended and enhanced as needed.</p>

  <p>If you have any questions or feedback, please feel free to reach
