# LvlUp
## Level of Achievement
Apollo 11


<br>

## Project Motivation
Have you ever promised yourselves that you will accomplish so and so revision and assignments but at the end of the day you realised that you failed to accomplish them as you lack the motivation to do so? Well, procrastination and a low motivation to study are amongst the main causes of this issue that we students tend to experience. At the root level of these causes, we realised that it is also attributed to students not having a well-thought-out study schedule for them to adhere to, and even if they have, there is little incentive for them to follow their schedule. 

Technology has been and still is being used to solve our daily problems in life, surely it can also help us to solve this problem too, especially when today’s students are generally more interested in online gaming.


<br>

## Project Scope
A gamified study mobile application. (one sentence version)

LvlUp is a mobile application intended for students who finds difficulty committing to their study schedules and managing their workloads. We intend to create LvlUp such that it can help these students better plan their weekly study plans and adhere to it by integrating gamification elements into our application. To further support our target audience in committing to their study schedule, we will also implement a feature for them to review their past and overall study sessions to see how much time they have spent studying and idling.
(longer descriptive version)


<br>

## User Stories
1. As a student with many ongoing stuffs in my life, I can make use of the app’s schedule generation feature based on how strong I am in my respective modules and my available time in a week to quickly and optimally plan my schedules so that I can balance my study time and other aspects of life.

2. As a student who finds it hard to focus on my revision and often loses track of how much time I deviate from my study plan, I can rely on the study summary statistics to give me a summary of how much I actually adhere to my own plan so that I can check the amount of time I deviated from my studies.

3. As a student who has low motivation to study as it is rather dry as compared to playing online games and socialising, the gamified experience of this app helps keep me motivated to study so that I can focus better on my studies.


<br>

## Proposed Core Features

### User Authentication
- User authentication and user accounts.

<br>

### Schedule Generator
-  The app will suggest a weekly study schedule (Aka Quest) based on their strengths in the modules that they are currently taking and their daily timetable through the user inputs functionality:
    * User will input their modules ranking from weakest to strongest, whereby the weaker modules are above the stronger modules in the ranking list. There will be a study intensity scale from 1-10, which indicates the proportion of free time that should be allocated to studying.
    * User will also indicate the time periods that they are free in any particular week, in blocks of 30mins (E.g. 0900-0930 is acceptable, but 0915-0945 and 0915- 0930 are not accepted).

-   Based on these inputs, the app will compute the total amount of free time available for studying in a week. Out of this computed amount of study time available, the app’s schedule generator will prioritise a larger proportion of time to the weaker modules, such that the strongest module has the least amount of time assigned to it.

- The schedule generator will then allocate the timings that the user should study for a particular module based on the free time being input by the user.

- At the end of the day, to allow for flexibility, the user can tweak the schedule generated by the app in the time assign to each module and when they should study.

- Users can tweak this schedule anytime throughout the week, but are not able to reassign any session to be before the time of tweaking. 

<br>

### Timer
- Users can start the timer by accessing the timer page only during their study session

- Users can stop or pause the timer when they take a break or prematurely end their study session respectively.

- Users can view the time remaining for the study session

- The timer will automatically stop and notify the user when the study period is up. 

<br>

### Gamified Experience
- Feel the fun and satisfaction as you are rewarded for your efforts.

- Level up by gaining XP through 
    * XP / hour of studying, tracked through a study timer in the app.

    * Quests are accepted so long as the user has a non-empty schedule to follow.  Quest refers to the weekly study schedule that starts from Monday and ends on Sunday of the same week. Quests allow adventurers to gain more XP. By adhering to the study schedule for as much as the adventurer can, they can gain up to the maximum XP the quest provides. The XP gained is the percentage of adherence to that week study schedule multiplied by the maximum XP when the adventurer takes up the study schedule (on top of point 1). If the user has an adherence of less than 50% the quests will be deemed as dropped by the system, and the user loses XP  (Penalty) and has their week schedule reset  to an empty schedule for the subsequent weeks(User will then have to regenerate a schedule to follow). By successfully adhering to the quests, users can automatically continue doing the quest (follow generated schedule) to gain more XP in the following weeks.

- Watch your adventurer evolve and grow as its appearance changes at higher levels, unlocking cool and funky titles and skills as you climb the ladder of levels. There are 24 different possible evolutions to explore with 11 different titles to obtain.

<br>

### Study Statistics
- Weekly summary showing the latest quest statistics (how much studying the user had done in the week).

- Overall summary of the amount of studying done by the user.  


<br>

## Design and plan

### Design decisions
Instead of using StreamBuilder to listen to the authentication status of the user, we decided to listen to the status using StreamProvider instead as it allows us to access the data in all the descendent widgets of the streamProvider whereas streamBuilder only limits the access of that data to the current widget, making the app harder to work on in future implementations.

<br>

### Architecture diagram
![Software Architecture diagram](/screenshots/lvlUpArchitecture.png)

<br>

### Activity diagram

![activity diagram](/screenshots/LvlUp%20Activity%20Diagram.png)

<br>

### Figma UI prototype images
<br>

![Login page](/screenshots/Login%20page.png)
![Main page](/screenshots/Main%20page.png)
![Schedule input page](/screenshots/Schedule%20input%20page.png)
![Schedule page](/screenshots/Schedule%20page.png)
![Study summary page](/screenshots/Study%20summary%20page.png)