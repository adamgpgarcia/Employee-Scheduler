
<h1 align="center">Casa Colina Employee Scheduler</h1>
<h3 align="center">Fall 2020 Senior Capstone</h3>


### Overview

The goal of this project is to create an employee scheduling platform that will streamline all tasks involving employee scheduling. Allow a company the able to update/post schedules, communicate with employees, accept timecard submissions remotely and automatically. All while increasing efficiency and eliminating human error.


### Motivation

Two out of three of my last employers did not use database driven scheduling systems. Using basic methods always resulted in human error. Employees would be over scheduled, under scheduled, delays int getting schedules out. This not only affected the employers but the also the morale of employees.

### Codebase

Android Application: Flutter Application
Database Framework: Django REST Api
Database SQL: SQLite
Hosted: Google Cloud, Apache HTTP Server
Languages: Dart, Python, SQLite


<h2 align="center">Entity Relationship Diagram</h2>

<p align="center">
  <img width="700" src="https://user-images.githubusercontent.com/25330599/152046522-6edb2ed2-8a5a-41f2-9166-dd5d237e19d0.jpg">
</p>

<br clear="left"/>


<h2 align="center">Flutter App Examples</h2>

<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152046435-9b518308-41c7-4a7d-83d3-3c6def384506.png" align="left" width="200px"/>

## Login Screen

    - This screen logs in a user into the database with a username and password

    - User is promted if password or login is wrong
    
    - If no response from the database is received a promt "cannot connect at this time" is given
    
    - If username and password is correct an authentication token is returned

<br clear="left"/>
<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152046476-df3da065-2d47-45b4-a801-42c1a84ad4b6.png" align="right" width="200px"/>

## Schedule Viewer Screen

    - This screen gives a weekly view at current and future schedules 

    - Shifts can be filtered by All, Personal, and Pick-up shifts
    
    - Released shifts show up in the pick-up option and can be picked up
    
    - At a quick glance white bars signify days you are scheduled to work  

<br clear="left"/>
<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152046484-cfa3aeaa-4213-4203-8d01-cfe98f5296db.png" align="left" width="200px"/>

## Schedule Availability Screen

    - This screen allows employees to update their schedule availability

    - Times can be add, editied, and deleted
    
    - Multiple time brackets can be added to one day
    
    - Employees can only be scheduled for a shift when their availability allows

<br clear="left"/>
<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152046458-833b358d-4890-45a4-884a-1c1f6636e79e.png" align="right" width="200px"/>

## Timecard Screen

    - This screen displays the users clocked hours for the schedule period 
    
    - When an employee is scheduled they are allowed to update start and end times and add lunch breaks 
    
    - Total, Regular, Overtime 1 (8 >), and Overtime 2 (12 >) hours are calculated and displayed 
    
    - Minutes are rounded to the next 15 minute increment 

<br clear="left"/>
<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152046466-80d175ef-2da7-4d62-b881-391aefb21ca0.png" align="left" width="200px"/>

## WorkChat Screen

    - This screen shows a users open chat threads

    - Users can navigate to a open thread or start a new one
    
    - Threads have the last message displyed with date 
    
    - User initials fill in their avatar circle 

<br clear="left"/>
<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152208480-d03afb51-39e2-4726-a78e-80adc2a9a80b.png" align="right" width="200px"/>

## Single Chat Screen

    - This screen shows a single chat thread

    - Messages are color coated based on sender and receiver
    
    - Messages are time stamped with date and time
    
<br clear="left"/>
<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152046452-498a5693-f172-40c8-b1a9-caeca9f797e2.png" align="left" width="200px"/>

## Admin Dashboard Screen

    - This screen provides admin navigaton to employees, schedules, and timecards  

<br clear="left"/>
<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152046493-3a0b11a1-a60c-4d76-bfa8-43a1b2e9c5bf.png" align="right" width="200px"/>

## Admin Timecard Review Screen

    - This screen gives admin a quick glance at the remaining outstanding timecards 

    - Current status of an individual timecard can be accessed with the view button
    
    - Schedule time period and timecard due date are displayed

<br clear="left"/>
<br/><br/>
    
<img src="https://user-images.githubusercontent.com/25330599/152211075-a51e8be8-7384-4923-b5ad-fbbdc30d13d5.png" align="left" width="200px"/>

## Admin Single Timecard Review Screen

    - This screen gives an overview of a single timecard

    - Total, Regular, Overtime 1 (8 >), and Overtime 2 (12 >) hours are calculated and displayed
    
    - If timecards are not satisfactory they can be returned to the employee

<br clear="left"/>
<br/><br/>

<img src="https://user-images.githubusercontent.com/25330599/152046511-e9e93efb-4dca-4592-9b3f-9a6dd0ffaa8f.png" align="right" width="200px"/>

## Admin Schedule Creation Screen

    - This screen allows for the viewing, creation, editing and deleting of schedules

    - All schedules that have been released show up here
    
    - Total shifts in schedule are viewable 

<br clear="left"/>
<br/><br/>
    
<img src="https://user-images.githubusercontent.com/25330599/152209096-ed92da84-9f69-4c72-82fc-c27e93e7c29e.png" align="left" width="200px"/>

## Admin Employee Record Screen

    - This screen lists all employees in the database
    
    - New employees can be added from this screen

    - Employees can be editied by viewing employee
    
    - User initials fill in their avatar circle 

<br clear="left"/>
<br/><br/>
  





