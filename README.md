# ShareSpace
## Collaborators:
[Yuliia Engman](https://github.com/YuliiaEngman)

[Luba Kaper](https://github.com/lubakaper)

[Bienbenido Angeles](https://github.com/bienbenidoangeles)

[Eric Davenport](https://github.com/EricDavenport)

## Description:
This application connects directly people who have extra empty space: office rooms, garages, backyards etc. and people who want to rest such spaces. Since pandemic there is a drastic increase of interest of such spaces since a lot of people are working remotelly and home enviroment with loud kids, family or roommates is not productive. On other hand there are more empty spaces available because a lot of people leaving rented properties and going back home.

Our app is serving for both parties - homeowner and renter. The homeowner or person who has empty space is able to post the space he wants to rent. The person who wants to rent is able to search by location on the map and use messaging to communicate with the space owner. To promote diversity the user will be able to see the information about owner only after he confirms the reservation. 

## Challenges:
Database Querying:
- Limits with compound querying of multiple fields containing inequalities

- Coordinate-Querying had to be done separately:
     * Database (limited to 256 objects)
     * On the app

Firebase Messaging:
- Used Firebase database services for messaging system

- Created Messaging UI from scratch

- Technical Challenges:
     * Constraints, constraints, once again constraints

Calendar Kit:
- FSCalendar, since Apple framework doesn’t have a calendar

- Selecting dates for reservation
     * UI 
     * Date objects
     * Restriction dates before the current date



  
