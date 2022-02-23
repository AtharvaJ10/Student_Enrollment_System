class AddUsertoInstructors < ActiveRecord::Migration[7.0]
  def change
    add_reference :instructors, :user, index: true
  end
end
