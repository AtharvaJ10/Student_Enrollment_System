class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :dob
      t.string :phone
      t.string :major

      t.timestamps
    end
  end
end
