class AddCourseToWaitlist < ActiveRecord::Migration[7.0]
  def change
    add_reference :waitlists, :course, null: false, foreign_key: true
  end
end
