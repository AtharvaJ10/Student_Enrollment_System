class WaitlistsController < ApplicationController
  before_action :set_waitlist, only: %i[ show edit update destroy ]

  # GET /waitlists or /waitlists.json
  def index
    get_id
    if current_user.user_type == 'Student'
      @courses = []
      @waitlist = Waitlist.where(student_id: @userid)
      @waitlist.each do |enrollment|
        @courses.append(Course.where(id: enrollment.course_id))
      end
    else 
      if current_user.user_type == 'Instructor'
        @courses = Course.where(instructor_id: @userid)
      else
        @courses = Course.all
      end
      @course_wise = []
      @courses.each do |course|
        @students = []
        @waitlist = Waitlist.where(course_id: course.id)
        @waitlist.each do |enrollment|
          @students.append(Student.where(id: enrollment.student_id))
        end
        @course_wise.append(@students)
      end
    end
  end

  # GET /waitlists/1 or /waitlists/1.json
  def show
  end

  # GET /waitlists/new
  def new
    get_id
    if current_user.user_type == "Student"
      @waitlist = Waitlist.new
      temp = params[:c_id]
      id = temp["course_id"]
      @course = Course.find(id)
      @waitlist1 = Waitlist.find_by(course_id: @course.id, student_id: @userid)
    else
      par = params[:enroll]
      c_id = par[:course_id]
      s_id = par[:student_id]

      if Course.find(c_id).status == "CLOSED" || Course.find(c_id).status == "OPEN"
        return redirect_to courses_path, notice: "Course is in open or closed state"
      else
        en = Waitlist.new
        en.course_id = c_id
        en.student_id = s_id
        en.save!

        @course1 = Course.find(c_id)
        @waitlist_count = Waitlist.where(course_id: c_id).count
        if @course1.waitlist_capacity<=@waitlist_count
          if @waitlist_count>=@course1.waitlist_capacity
            h={:id => @course1.id, :status => "CLOSED"}
          end
          @course1.update(h)
        end

        h = {:c_id => {:course_id => c_id}, :flag => {:flag_val => 1}, :waitlist => {:wl => '1'}}
        return redirect_to students_path(h), notice: "Student Waitlisted"
      end
    end
  end

  # GET /waitlists/1/edit
  def edit
  end

  # POST /waitlists or /waitlists.json
  def create
    @waitlist = Waitlist.new(waitlist_params)

    respond_to do |format|
      if @waitlist.save
        @course1 = Course.find(@waitlist.course_id)
        @waitlist_count = Waitlist.where(course_id: @waitlist.course_id).count
        if @course1.waitlist_capacity<=@waitlist_count
          if @waitlist_count>=@course1.waitlist_capacity
            h={:id => @course1.id, :status => "CLOSED"}
          end
          @course1.update(h)
        end
        format.html { redirect_to waitlist_url(@waitlist), notice: "Waitlist was successfully created." }
        format.json { render :show, status: :created, location: @waitlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @waitlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /waitlists/1 or /waitlists/1.json
  def update
    respond_to do |format|
      if @waitlist.update(waitlist_params)
        format.html { redirect_to waitlist_url(@waitlist), notice: "Waitlist was successfully updated." }
        format.json { render :show, status: :ok, location: @waitlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @waitlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /waitlists/1 or /waitlists/1.json
  def destroy
    @course1 = Course.find(@waitlist.course_id)
    h={:id => @course1.id, :status => "WAITLIST"}
    @course1.update(h)
    @waitlist.destroy

    respond_to do |format|
      format.html { redirect_to waitlists_url, notice: "Waitlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waitlist
      @waitlist = Waitlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def waitlist_params
      params.fetch(:waitlist, {})
      params.require(:waitlist).permit(:c_id,:course_id, :student_id)
    end
end
