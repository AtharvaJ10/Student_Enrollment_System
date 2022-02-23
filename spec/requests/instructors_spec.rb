require 'rails_helper'

describe 'The Instructor Controller', type: :feature do

    before :each do
      User.create(id: 100, email: 'user1@gmail.com', password: 'password', name: 'User1', user_type: 'Instructor', sign_in_count: 1)
      Instructor.create(id: 1, department: 'cs', user_id: 100)
      visit '/users/sign_in'
      fill_in 'Email', with: 'user1@gmail.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      
    end

    it 'Logs in as an Instructor' do
      expect(current_path).to eq(courses_path)
    end

    it 'Index Displays list of instructors' do
      visit "/instructors"
      expect(current_path).to eq(instructors_path)
    end

    it "Edits an instructor" do
      visit "/instructors/1/edit"
      expect(current_path).to eq(edit_instructor_path(1))
    end

    it "Shows an instructor" do
      visit "/instructors/1"
      expect(current_path).to eq(instructor_path(1))
    end

    it "Removes an Instructor" do
      expect { Instructor.destroy(1) }.to change { Instructor.count }.by(-1)
    end

end

