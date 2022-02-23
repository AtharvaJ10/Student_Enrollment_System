class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user!
    before_action :create_admin
    
    #Function for creating admin in users table as soon as home page is displayed
    def create_admin
      temp = User.where(email: "admin@ncsu.edu")
      if temp.length()==0
        user = User.new
        user.name = "Admin"
        user.email = "admin@ncsu.edu"
        user.password = "admin123"
        user.user_type = "Admin"
        user.sign_in_count = 1
        user.save!

        admin = Admin.new
        admin.phone = "0000000000"
        admin.user_id = user.id
        admin.save!
      end
    end

    #Function that retrieves instructor/student id from instructor/student table using user id as foreign key
    def get_id
      if current_user.user_type == "Instructor"
        obj = Instructor.find_by(user_id: current_user.id)
        @userid = obj.id
      elsif current_user.user_type == "Student"
        obj = Student.find_by(user_id: current_user.id)
        @userid = obj.id
      else
        @userid = current_user.id
      end
    end

    protected
    
    #defining permitted parameters
    def configure_permitted_parameters
      #devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :type])
      devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:user_type,:email,:password,:name,:password_confirmation)}
    end

end
