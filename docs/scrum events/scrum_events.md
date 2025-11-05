## **Scrum Events - Minutes of Meet**

### 10/15/25 
* Lending app idea
* The team discusses potential features like user login/logout, a marketplace-style listing page, and messaging between buyers and sellers.

### 10/17/25
#### Ideas Discussed
* Database and Messaging Design - Messaging should be organized by request, with separate chat threads for each request
* Buyers and sellers will have separate profiles, with ability to switch between them
* Messaging should store sender ID, receiver ID, and request ID to track which item the conversation is about 
#### Next Steps to be taken : 
* Development Workflow : set up a boilerplate codebase with Google/OAuth integration, testing frameworks, and basic CSS 
* Each feature will be developed on a separate branch, and merged into the main branch via pull requests
* The main branch will have rules to enforce code review and prevent direct pushes
* Documentation should be updated alongside code changes

### 10/21/25
#### Progress
* Login page has been implemented with Google client credentials shared via email
* Item CRUD (Create, Read, Update, Delete) operations and associated test cases being worked upon
* Messaging operations also being worked on
#### Next Steps to be taken : 
* Team members are responsible for both backend and frontend implementation 
* Generating test data and creating test cases after the initial framework is built
* Synchronizing UI across different pages with a uniform style
* Documentation should be updated alongside code changes

### 10/23/25
#### Progress
* Item CRUD (Create, Read, Update, Delete) operations and associated test cases implemented
* Messaging operations also being worked on
#### Next Steps to be taken : 
* Working on displaying item details, including seller information and improving the UI for item cards
* Implementing a seller profile page that can be accessed from item cards, showing the seller's listings
* Discussed potentially implementing a user verification process using a third-party verification service.

### 10/25/25
* Team agreed to add price ranges and category filtering as additional features
* Potential future features discussed : email integration and notifications
#### Next Steps to be taken : 
* Start work on user verification, profiling, and implementing prices in the database
* Start handling reviews, allowing sellers to review buyers, and implementing image upload functionality
* Deploy project on Heroku

### 10/28/25
#### Progress
* Implemented a user profile page with functionality to add address, edit name, and include a verification button
* Completed messaging functionality, though styling needs improvement
* Added user buttonless to allow viewing seller information and other items
#### Next Steps to be taken : 
* Decided against creating a separate user browsing page, as item browsing already exists
* Suggested integrating ratings and reviews directly on the seller's page rather than creating a separate page
* Plan includes adding a 5-star rating system and a reviews tab on the seller's profile

### 10/30/25
#### Progress
* Completing verification work and needs to add test cases
* Nearly finished the image upload feature
* Seller verification feature now includes a badge system to indicate verification status on seller pages
#### Next Steps to be taken : 
* Team plans to work on presentation artifacts during the weekend, with potential collaboration 
* Will implement sorting functionality, including price-based sorting for items
* Plan includes adding a 5-star rating system and a reviews tab on the seller's profile

### 11/2/25
#### Progress
* Added several key features including an approval request flow and the ability to view requests made on team members' listings
* Test coverage was reported to be between 65-89%
* Team acknowledged some testing challenges, such as difficulty logging in with multiple users simultaneously

### 11/4/25
#### Progress
* Test Coverage increased
#### To Do
* Record both the demo and presentation videos.
* Create a draft pull request to merge dev and domain branches







