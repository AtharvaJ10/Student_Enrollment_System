class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # This function ensures that an student cannot edit/destroy any other student's course.
  # The student details can only be edited/deleted by the corresponding student and admin.
  def correct_user
    get_id
    if @userid!=@student.id && current_user.user_type!='Admin'
      redirect_to courses_path, notice: "Not authorized to edit/delete this Profile."
    end
  end

  # This function is used to edit the student details
  def edit_student
    name = params['name']
    email = params['email']
    pass = params['password']
    dob = params['dob']
    major = params['major']
    phone = params['phone']
    id = params['id']

    user = User.find_by(id: Student.find_by(id: id).user_id)
    uid = User.find_by(id: Student.find_by(id: id).user_id).id

    h = {:name => name, :email => email, :password => pass, :user_type => "Student"}
    user.update(h)

    ins = Student.find_by(id: id)
    ins.update({:major => major, :dob => dob, :phone => phone})
    
    redirect_to students_path(:flag => {:flag_val => '0'}), notice:"Student updated successfully"
  end

  #Used to create the student 
  def create_student
    name = params['name']
    email = params['email']
    pass = params['password']
    dob = params['dob']
    phone = params['phone']
    major = params['major']

    user = User.new
    user.name = name
    user.email = email
    user.password = pass
    user.user_type = 'Student'
    user.sign_in_count = 1
    user.save!
    
    user = User.find_by(email: email).id
    stud = Student.new
    stud.dob = dob
    stud.phone = phone
    stud.major = major
    stud.user_id = user

    stud.save!
    redirect_to students_path(:flag => {:flag_val => '0'})

  end

  # GET /students or /students.json
  def index
    @f = params[:flag]
    if @f[:flag_val]=='0'
      @students = Student.all
    else
      @par = params[:c_id]
      @par2 = params[:waitlist]
      enrollments = Enrollment.where(course_id: @par[:course_id])
      waitlists = Waitlist.where(course_id: @par[:course_id])
      l = []
      enrollments.each do |enrollment|
        l.append(enrollment.student_id)
      end
      waitlists.each do |waitlist|
        l.append(waitlist.student_id)
      end
      @students = []
      temp = Student.all
      temp.each do |i|
        if l.include?(i.id) == false
          @students.append(i)
        end
      end
    end
  end

  # GET /students/1 or /students/1.json
  def show
    @user = @student.user_id
    @user = User.find_by(id:@user)
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @user_record = User.find(@student.user_id)
    @user_record.destroy
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url(:flag => {:flag_val => '0'}), notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:dob, :phone, :major, :c_id, :flag, :waitlist)
    end
end
