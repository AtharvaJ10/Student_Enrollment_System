<h1> Let's Enroll! </h1>

Lets Enroll is an Enrollment Portal that provides a platform for all the students studying in a Univeristy to enroll in different courses. <br>
The Instructors have the ability to add a course, view the course and delete the course that they have opted for. <br>

The link for the Portal is: https://letsenroll.herokuapp.com/.  <br>
Users can enroll as an Instructor or a Student. There is an Admin in the system that is the superuser of all the users. The credentials for the Admin user are provided below <br>

<h3> Admin Credentials: </h3>
email: admin@ncsu.edu <br>
password: admin123


<h3> A Tour through the Application </h3>
<h4> 1. Login and Sign Up </h4>
  
* The Home Page of the App is the Login Page where a User can login as an Instructor, Student or the Admin. A Sign Up link is available in the navigation bar to sign up as an Instructor or a Student.
  
* If an Instructor is Signed up, the user is asked to fill out the mandatory department field for the first login. Similarly, a student is asked to fill out the mandatory fields like Date of Birth, Phone number and Major.

<h4> 2. Show Courses <h4>
  
* If a User is logged in as an Instructor, a courses list will be rendered wherein the user can view all the course details but can only edit/delete the courses that they create. The user can create a new course by using the new course link.
 
* If a User is logged in as a Student, all the available courses created by instructors are visible and they can view the course details and then enroll for the same by using the Create Enrollment button.
  
* If a User is logged in as an Admin, they can view all the courses available and their course details. They can add/update/delete a course for any instructor by clicking on "Add a course" in the show instructors page.
 
 <h4> 3. Show Enrollments <h4>
 
 * The Show enrollment link in the navbar can be used by the instructors to view all the students enrolled in all the courses which they have created. For every course they add or remove students. On clicking on "Add a student" link they can see the list of students not enrolled in the course and enroll them.
   
 * Students can use the Show enrollment link to view all the courses they are enrolled in. They can use the Drop button to drop the course.
   
 * Admins can view all the students enrolled in all the courses. For every course they can add or remove students. On clicking on "Add a student" link they can see the list of students not enrolled in the course and enroll them.
  
 <h4> 4. Show Waitlists <h4>
 
 * The Show Waitlists link can be used by the instructors to view all the studens who are on a waitlist for their courses. They can also remove the student from the waitlist. 
   
 * Students can use the Show waitlist link to view the courses they are waitlisted in. They can also drop the courses they are waitlisted in.

 * The Show Waitlists link can be used by the admins to view all the studens who are on a waitlist for all the courses. They can also remove the student from the waitlist. 
   
 <h4> 5. Different Scenarios <h4>
   
 * Once a course is deleted by an Instructor, all the enrollments to that course gets deleted.
   
 * The course status is changed automatically according to the waitlist capacity, the enrollment capacity, total number of enrollments and the total number of students enrolled in the waitlist. The status is updated as soon as a Student enrolls in a course, drops a course, or an instructor enrolls or drops a student.
   
 <h4> Testing </h4>
  
* The user model and Instructors controller are tested using Rspec. The user model is tested through all its validations whereas the instructor controller is tested for all its CRUD operations.  
   
