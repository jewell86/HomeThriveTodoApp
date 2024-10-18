#  Jewell's HomeThrive take home Todo App

Thank you for reviewing my project app! 

## Steps to run the app are simple - clone the repo in your terminal by running 
`git clone https://github.com/jewell86/HomeThriveTodoApp.git`
### Open the project in Xcode & press the play button!

## This simple todo list app has a few functions:
### Upon first app launch, it will fetch and render 5 todo list items for hardcoded user "3" (in production we would pass through the unique user's id)
### To reset the app to fetch the items from service again, delete the app from the simulator & rebuild
### You can now edit, add or tasks as needed
### Edit & add functionalities initialize a popup alert for you to add or edit an item, or cancel
### Edit an item by tapping the pencil icon for that item
### Delete an item by swiping the cell to the left
### Items will persist between app launches, only fetching from the service upon first initial app launch
### Items can be filtered by All, Completed(checked) & Not Completed(unchecked)
### Tapping on an item or it's checkbox will move the item to either the Completed or Not Completed tab, and a strikethrough is added for Completed items.

## Testing
### To run the UI & unit tests, tap the uppermost diamond symbol for each test file, or the diamond symbol next to the desired test.
### Testing uses a separate in-memory database that is reset for each test

## Notes about the architecture & code choices
### This MVVM design is common with SwiftUI implementation & is the design that I'm most familiar with, so I chose to follow that pattern
### I would have added more unit & UI tests for all cases if this were a prod app, as well as added Snapshot testing
### I didn't add error handling for the sake of time, but normally I'd add error banners/graceful failures where needed 
### I also would have created a few more files/classes to be more modular, but I didn't want to bloat this small project
### I'm running into a couple non-blocking runtime warnings around the database during testing & the textfield for both alert popups, but I didn't have time to investigate them further. 
