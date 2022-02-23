class HomeController < ApplicationController

  #Checks if the user has signed in for the first time and redirects it to respective paths for Instructors and Students
  def index
    if current_user.user_type=="Instructor"
      ins = Instructor.new
      ins.department = 'Computer Science'
      ins.user_id = current_user.id
      current_user.sign_in_count = 1
      ins.save!
      current_user.save!
      redirect_to edit_instructor_path(ins.id)
    elsif current_user.user_type=="Student"
      std = Student.new
      std.dob = '10/10/2022'
      std.phone = '9193214567'
      std.major = 'Computer Science'
      std.user_id = current_user.id
      current_user.sign_in_count = 1
      std.save!
      current_user.save!
      redirect_to edit_student_path(std.id)
    end
  end
  

end
