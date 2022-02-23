class Student < ApplicationRecord
    belongs_to :user
    has_many :enrollments
    has_many :waitlists, dependent: :destroy
    validates_presence_of :dob, :phone, :major
end
