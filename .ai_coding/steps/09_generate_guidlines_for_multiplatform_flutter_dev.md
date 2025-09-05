Read the following documentation https://docs.flutter.dev/ui/adaptive-responsive and:

* Think ultra-hard for this
* Follow these links and read all of them too and write them exactly as they are per page under .ai_coding/guidelines/flutter-adaptive-responsive:
  * General approach
  * SafeArea & MediaQuery
  * Large screens & foldables
  * User input & accessibility
  * Capabilities & policies
  * Best practices for adaptive apps
  * Additional resources
* Look at the youtube video provided at the bottom of the page and read the transcript. Save that as is to ai_coding/guidelines/flutter-adaptive-responsive too.
* Use the dart MCP server to consult any exsiting packages that would be helpful, only consider widely used libraries and prefer using native tools as described in the official docs. Write the findings about packages in ai_coding/guidelines/flutter-adaptive-responsive too.
* Note that we want to build a fully adaptive and responsive flutter app in frontend. Choose approaches that in the long term will make it easy to implement for all device types like: web, tablet, mobile (ios and android). Avoid just doing localized techniques and use a global approach that can be used everwhere in the app.
* Use playwright to look at this demo project: https://abuanwar072.github.io/core_dashboard/
  * Click on different parts of it and look around
  * Pay attention to the sign up and login pages
* You can find the full code repository for that demo project here: https://github.com/abuanwar072/Flutter-Responsive-Admin-Panel-or-Dashboard 
* The behaviour of this demo project is very very close to what I want to achieve in our frontend/ here.
* Ultra think about the example code and compare it to flutter-multiplatform-development-guide.md we have here. Update the guide by taking inspiration from the demo codebase.
* Do not change fundamental decisions in our project such as using bloc instead of provider.
* Use all of the information you gathered above to write a comprehensive summary guideline under ai_coding/guidelines/ for designing and implementing a Flutter app that runs on both Mobile and Web. You are gonna use that guideline for all of the development we do on the frontend side.