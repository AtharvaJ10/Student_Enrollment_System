require 'rails_helper'
describe 'the signin process', type: :feature do
    before :each do
        User.create(id: 100, email: 'user1@gmail.com', password: 'password', name: 'User1', user_type: 'Instructor', sign_in_count: 1)
        Instructor.create(id: 1, department: 'cs', user_id: 100)
    end
    it 'signs @user in' do
        visit '/users/sign_in'
        fill_in 'Email', with: 'user1@gmail.com'
        fill_in 'Password', with: 'password'
        click_button 'Log in'
        expect(current_path).to eq(courses_path)
        expect(page).to have_text('Signed in successfully.')
    end
end