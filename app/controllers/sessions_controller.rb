class SessionsController < Devise::SessionsController

    #Used to redirect the different users to their respective paths after signing in.
    #If the user has signed in as an admin it is redirected to show courses. 
    def after_sign_in_path_for(current_user)
        if current_user.user_type=="Admin"
            courses_path
        elsif current_user.sign_in_count == 0
            if current_user.user_type=="Instructor"
                ins = Instructor.new
                ins.department = 'Some department'
                ins.user_id = current_user.id
                ins.save!
                return redirect_to edit_instructor_path(ins.id)
            elsif current_user.user_type=="Student"
                std = Student.new
                std.dob = 'Some date of birth'
                std.phone = 'Some phone'
                std.major = 'Some major'
                std.user_id = current_user.id
                std.save!
                return redirect_to edit_student_path(std.id)
            end
        else
            current_user.sign_in_count+=1
            current_user.save!
            courses_path
        end
    end

end