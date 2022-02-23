class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy ]

  #getid function called at places where student id or instructor id is required.
  #getid function is defined in application_controller.rb

  # GET /enrollments or /enrollments.json
  def index
    get_id
    if current_user.user_type == 'Student'  #Student can see only his own enrollments
      @courses = []
      @enrollments = Enrollment.where(student_id: @userid)
      @enrollments.each do |enrollment|
        @courses.append(Course.where(id: enrollment.course_id))
      end
    else
      if current_user.user_type == 'Instructor'  #Instructors can see enrollments for courses he has created.
        @courses = Course.where(instructor_id: @userid)
      else
        @courses = Course.all   #Admin case: Admin can see enrollments for all courses.
      end
      @course_wise = []
      @courses.each do |course|
        @students = []
        @enrollments = Enrollment.where(course_id: course.id)
        @enrollments.each do |enrollment|
          @students.append(Student.where(id: enrollment.student_id))
        end
        @course_wise.append(@students)
      end
    end
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    get_id
    if current_user.user_type == "Student" #student can see all his enrollments in the courses
      @enrollment = Enrollment.new
      temp = params[:c_id]
      id = temp["course_id"]
      @course = Course.find(id)
      @enrolled = Enrollment.find_by(course_id: @course.id, student_id: @userid)
    else
      par = params[:enroll]
      c_id = par[:course_id]
      s_id = par[:student_id]
      
      if Course.find(c_id).status == "CLOSED" || Course.find(c_id).status == "WAITLIST"
        return redirect_to courses_path, notice: "Course is in wailist or closed"
      else
      
        en = Enrollment.new
        en.course_id = c_id
        en.student_id = s_id
        en.save!
        

        @course1 = Course.find(c_id)
        @enrollment_count = Enrollment.where(course_id: c_id).count
        @waitlist_count = Waitlist.where(course_id: c_id).count
        if @course1.capacity<=@enrollment_count
          if @waitlist_count>=@course1.waitlist_capacity
            h={:id => @course1.id, :status => "CLOSED"}
          else
            h={:id => @course1.id, :status => "WAITLIST"}
          end
          @course1.update(h)
        end

        h = {:c_id => {:course_id => c_id}, :flag => {:flag_val => 1}, :waitlist => {:wl => '0'}}

        return redirect_to students_path(h), notice: "Student Enrolled"
      end

    end
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments or /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        @course1 = Course.find(@enrollment.course_id)
        @enrollment_count = Enrollment.where(course_id: @enrollment.course_id).count
        @waitlist_count = Waitlist.where(course_id: @enrollment.course_id).count
        if @course1.capacity<=@enrollment_count
          if @waitlist_count>=@course1.waitlist_capacity
            h={:id => @course1.id, :status => "CLOSED"}
          else
            h={:id => @course1.id, :status => "WAITLIST"}
          end
          @course1.update(h)
        end
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    @course1 = Course.find(@enrollment.course_id)
    @enrollment_count = Enrollment.where(course_id: @enrollment.course_id).count
    if @course1.capacity>@enrollment_count-1
      h={:id => @course1.id, :status => "OPEN"}
      @course1.update(h)
    end
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
      
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.fetch(:enrollment, {})
      params.require(:enrollment).permit(:student_id, :course_id, :enroll)
    end
end
