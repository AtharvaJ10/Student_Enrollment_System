class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
    get_id
  end
  
  # This function ensures that an instructor cannot edit/destroy any other instructor's course.
  # The course can only be edited/deleted by its corresponding instructor and admin
  def correct_user
    if @userid!=@course.instructor_id && current_user.user_type!='Admin'
      redirect_to courses_path, notice: "Not authorized to edit/delete this course."
    end
  end
  
  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
    get_id
    if current_user.user_type == 'Admin'
      @par2 = params[:ins]
      $inst_id = @par2[:ins_id]
    end
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    get_id
    @course = Course.new(course_params)
    if current_user.user_type=="Instructor"
      @course.instructor_id = @userid
    else
      @course.instructor_id = $inst_id
    end

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
      get_id
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :description, :instructor_name, :weekdayone, :weekdaytwo, :start_time, :end_time, :course_code, :capacity, :waitlist_capacity, :status, :room, :instructor_id, :ins)
    end
end
