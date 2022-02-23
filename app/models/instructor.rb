class Instructor < ApplicationRecord
    has_many :courses, dependent: :destroy
    belongs_to :user
    validates_presence_of :department
end
