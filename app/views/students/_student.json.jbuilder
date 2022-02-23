json.extract! student, :id, :dob, :phone, :major, :created_at, :updated_at
json.url student_url(student, format: :json)
