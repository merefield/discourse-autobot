# autopost plugin for Discourse

Based on prior work by Vinoth Kannan (@vinothkannans), but changed enough to warrant its own repo.

### Features:

Currently it supports auto-posting of new videos from:

- YouTube Channel

### Options:

- Can configure how frequent Discourse should poll from source for content.
- Import content as either new topic or reply post for exsiting topic.
- Setting custom owner username for improted posts.

### Settings:

- To import from any YouTube channels you have to configure Google API key in Site Settings.

### Further Development:

- Add other push services if possible

# Installation:

#### Register a YouTube API key. 
(Taken from Google deveeloper docs: https://developers.google.com/youtube/v3/getting-started)
  - You need a Google Account to access the Google Developers Console, request an API key, and register your application.
  - Create a project in the Google Developers Console and obtain authorization credentials so your application can submit API requests.
  - After creating your project, make sure the YouTube Data API is one of the services that your application is registered to use:
  - Go to the Developers Console and select the project that you just registered.
  - Open the API Library in the Google Developers Console. If prompted, select a project or create a new one. In the list of APIs, make sure the status is ON for the YouTube Data API v3.
  - If your application will use any API methods that require user authorization, read the authentication guide to learn how to implement OAuth 2.0 authorization.
  - Select a client library to simplify your API implementation.
  - Familiarize yourself with the core concepts of the JSON (JavaScript Object Notation) data format. JSON is a common, language-independent data format that provides a simpleext representation of arbitrary data structures. For more information, see json.org.

#### Add the plugin repo.
 - cd /var/discourse/containers and edit app.yml .
 - add repo to the plugin section:
  ``- git clone https://github.com/vinkashq/discourse-autopost.git`` .
 - cd /var/discourse & ``./launcer rebuild app`` .

#### Setup plugin for YouTube.
  - Once your app has rebuilt, navigate to ``/admin/plugins/autopost/campaigns`` in the browser
  - create "New Campaign" filling in the required details.
  - __Provider__: select YouTube.
  - __Source__: choose Channel
  - __Channel Id__: to obtain a YouTube channel's ID, go to channel URL, click on "Videos", the ID will be the value after ``/channel/`` and before ``/videos`` - copy this value into the "Channel Id" field.
  - __Category__: selecting a category will import new videos to said cateory _or_ ..
  - __Topic Id__: alternatively, selecting "Topic Id" will add each video as a reply to that topic. Topic Id can be obtained from going to a topic on discourse and noting the number at the end of the URL.
  - __Username for post ownership__: choose a username to be attributed to the posts.
  