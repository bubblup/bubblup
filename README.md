# bubblup

**bubbleup** is a quickfire brainstorming app that encourages idea generation.

Short description of your app
Required (core) user stories for your app in a bulleted list
Optional (nice to have) user stories listed separately

## User Stories

- [x] User can write an idea.
- [ ] User can make a voice recording of an idea.
- [ ] User can make a photo of an idea.
- [ ] Visualization of ideas
  - [x] Ideas can be listed out.
  - [ ] Ideas can be rearranged.
- [ ] Facebook authentication

The following **optional** features are implemented:

- [ ] User can draw an idea.
- [ ] The application can dictate what the user says

## Database Structure
class: user
- field: username
- field: password
- embeds_many: ideabox
  
class: ideabox
- field: title
- embeds_many: idea
- embedded_in: user

class: idea
- field: type
- field: contents
- field: url
- embedded_in: ideabox



## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/ky91Ut6.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2016] [Bubblup]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

