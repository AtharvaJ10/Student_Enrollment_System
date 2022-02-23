json.extract! course, :id, :name, :description, :instructor_name, :weekdayone, :weekdaytwo, :start_time, :end_time, :course_code, :capacity, :waitlist_capacity, :status, :room, :created_at, :updated_at
json.url course_url(course, format: :json)
