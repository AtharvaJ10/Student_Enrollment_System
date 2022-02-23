class Course < ApplicationRecord
	belongs_to :instructor
	has_many :enrollments, dependent: :destroy
	has_many :waitlists, dependent: :destroy
	
    validates :name, presence: true, uniqueness: true
	validates :description, presence: true
	validates :instructor_name, presence: true

	validates :weekdayone, presence: true, inclusion: { in: %w(MON TUE WED THU FRI), message: "Wrong %{value}"}, length: { is: 3}
	validates :weekdaytwo, inclusion: { in: %w(MON TUE WED THU FRI), message: "Wrong %{value}"}, allow_blank: true, exclusion: { in: ->(course) {[course.weekdayone]}, message: "Weekday 1 and weekday 2 cannot be the same"}

	validates :start_time, presence: true, format: { with: /\A(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/, message: "Please enter in the required format HH:MM"}
	validates :end_time, presence: true, format: { with: /\A(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/, message: "Please enter in the required format HH:MM"}, comparison: { greater_than: :start_time}

	validates :course_code, uniqueness: true, presence: true, format: { with: /\A[a-zA-Z]{3}\d{3}\z/}
	validates :capacity, presence: true, :numericality => { greater_than_or_equal_to: 1}
	validates :waitlist_capacity, :numericality => { greater_than_or_equal_to: 0}
	validates :status, presence: true, inclusion: { in: %w(OPEN CLOSED WAITLIST), message: "Wrong %{value}"}
	validates :room, presence: true, allow_blank: false
end
