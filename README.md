# Device-Agnostic Design Course Project II - eca927f4-b000-4091-8075-1d76c43f7a04

Below is the documentation for the project.
## Name of the application

DAD Recipe App

## Brief description of the application

The application have the following functionalities.

- For non logged in users, it shows three tabs.
  - The first one being the main or home page. It shows featured categories (random three categories) and recipe of the day (randomly selected recipe). Clicking the categories redirect to list of recipes page that corresponds to the selected recipe. Additionally, the home page have a button to list all categories which navigates to the category tab. Lastly, the recipe of the day is also clickable, which opens a nested page that shows the recipe details. It's also possible to return back to the home page from this popup page.

  - The second tab shows list of categories. Each cards are clickable that redirects to recipe list page where the clicked category will be auto-selected when the page is loaded. 

  - The third tab shows list of recipe. If the page is loaded by clicking the bottom navigation bar, all categories will be selected and list of recipe in all categories will be listed. Similar to recipe of the day, clicking one of the list of recipe will open popup to show details of the recipe. And a button at the end of the page to go back to the recipe list page.  

- The app has a functionality to search recipe by name from any of the pages. The search icon is clicked from list page, it filters the recipe from the selected category. Whereas, if the icon is clicked from other pages, the search will be from all category recipes.

- The app has a functionality to anonymously login user. It is also possible for users to logout.  

- There will be additional tab shown for logged in users. 

  - Add recipe tab will be added for logged in users which opens create recipe form. Logged in user can add recipe that belongs to a selected category in the form. The form has also simple validation to check all required fields are entered. 
  - The form also notifies the user if the submission is valid and successful or have validation errors by toaster message. 

- The app is designed and implemented to be simple, intuitive, minimalist and responsive. All margins, font style and size, theme of the app are consistent through out the pages.


## Three key challenges faced and key learning moments from working on the project

Generally, I enjoyed working the project. I started the merit functionalities, yet couldn't finish it due to time constraint. Working on the project 1 helped me to refresh the course contents and additional materials. Of course, this application is bigger and complicated than the first project, there was a moment of challenge and learning. I will list the top three challenges and the learning moments together in the list below.

- The first challenge was working to work with bottom navigation bar and switch between pages and keep the state of the application. Even if I knew I can add additional tab for detailed recipe page, I wanted to keep the bottom tabs very small and open the recipe page in some kind of popup. It took me a while to finally get it working. Had to refer other materials and blog. The process helped me to learn how the widgets work and how flutter cascades the pages. 


- The second challenge was working on responsive design. I used to do web page styling with CSS. Flutter way of defining the style in the code was a bit challenging (and messy at times). But I get to refer back the course module and extra materials to keep the page consistent, and more importantly not to break in smaller devices. I have learned to use the `context` size to relatively define width, height, margins and paddings.

- The last challenging part was doing the search functionality. How consistently search the name from different page and trying to keep in consideration of the selected category. I didn't want the search from all pages to be from all categories. If the user is already in the list of recipe page with selected category, it is intuitive that it should be possible to filter already presented list. To get this working was challenging, but finally managed to get it working using global state for the search keys and selected categories.

## List of dependencies and their versions

Here are list of dependencies and their versions used for this project.

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  firebase_core: ^2.13.0
  cloud_firestore: ^4.7.1
  flutter_riverpod: ^2.2.0
  riverpod: ^2.2.0
  shared_preferences: ^2.0.17
  http: ^0.13.5
  firebase_auth: ^4.6.2
  fluttertoast: ^8.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```
