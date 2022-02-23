class InstructorsController < ApplicationController
  before_action :set_instructor, only: %i[ show edit update destroy ]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # This function ensures that an instructor cannot edit/destroy any other profile
  def correct_user
    get_id
    if current_user.user_type!='Admin' && @userid!=@instructor.id
      redirect_to courses_path, notice: "Not authorized to edit/delete this Profile."
    end
  end

  # Used to update admin details.
  def edit_admin
    name = params['name']
    phone = params['phone']

    user = User.find_by(user_type: "Admin")
    ad = Admin.find_by(user_id: user.id)

    user.update({:name => name})
    ad.update({:phone => phone})

    redirect_to courses_path, notice: "Admin Successfully Updated"
  end

  #used to update instructor details.
  def edit_user
    name = params['name']
    email = params['email']
    pass = params['password']
    dep = params['department']
    id = params['id']

    user = User.find_by(id: Instructor.find_by(id: id).user_id)
    uid = User.find_by(id: Instructor.find_by(id: id).user_id).id

    h = {:name => name, :email => email, :password => pass, :user_type => "Instructor"}
    user.update(h)
    
    ins = Instructor.find_by(id: id)
    ins.update({:department => dep})
    
    redirect_to instructors_path, notice:"Instructor updated successfully"
  end

  # used to create a new user as intructor and redirect to the instructors path.
  def create_user
    name = params['name']
    email = params['email']
    pass = params['password']
    dep = params['department']

    user = User.new
    user.name = name
    user.email = email
    user.password = pass
    user.user_type = 'Instructor'
    user.sign_in_count = 1
    user.save!
    
    user = User.find_by(email: email).id
    ins = Instructor.new
    ins.department = dep
    ins.user_id = user
    
    ins.save!

    redirect_to instructors_path

  end

  # GET /instructors or /instructors.json
  def index
    @instructors = Instructor.all
  end

  # GET /instructors/1 or /instructors/1.json
  def show
    @user = @instructor.user_id
    @user = User.find_by(id:@user)
  end

  # GET /instructors/new
  def new
    @instructor = Instructor.new
  end

  # GET /instructors/1/edit
  def edit
  end

  # POST /instructors or /instructors.json
  def create
    @instructor = Instructor.new(instructor_params)

    respond_to do |format|
      if @instructor.save
        format.html { redirect_to instructor_url(@instructor), notice: "Instructor was successfully created." }
        format.json { render :show, status: :created, location: @instructor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instructors/1 or /instructors/1.json
  def update
    respond_to do |format|
      if @instructor.update(instructor_params)
        format.html { redirect_to instructor_url(@instructor), notice: "Instructor was successfully updated." }
        format.json { render :show, status: :ok, location: @instructor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instructors/1 or /instructors/1.json
  def destroy
    @user_record = User.find(@instructor.user_id)
    @user_record.destroy
    @instructor.destroy

    respond_to do |format|
      format.html { redirect_to instructors_url, notice: "Instructor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      if params[:id]!='0'
        @instructor = Instructor.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def instructor_params
      params.require(:instructor).permit(:department)
    end
end
