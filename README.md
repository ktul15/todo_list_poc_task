# POC - TODO App

### Flutter version - 3.19.5

### Push notification setup
- when user add a new todo, app will todo data to firebase using rest api as a cloud message, which will be listened by app.
- When app receives a push notification, we will schedule a local notification to display on the day when the todo is due. If due date is today, local notification will be scheduled 5 seconds later.
- If the due date is in future, local notification will be scheduled for the beginning of that day.

### Deep linking setup
- Use this link to test deep links - "https://ktul15.github.io/12", where "12" represents the id of the todo to be fetched from place holder api. When user clicks on this link, app should open and fetch the todo with id = 12 from api and display it on todo list page.
- if deep links open in the browser, please go to app info and enable the links from supported web addresses.

### Json data needed to run the app
- i will provide some keys in json format, to run the app, please add that data in lib/core/firebase_api.dart, in getAccessToken function, as a value of serviceAccountJson variable.