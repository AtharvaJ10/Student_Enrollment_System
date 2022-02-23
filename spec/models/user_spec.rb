require 'rails_helper'

RSpec.describe User, type: :model do
  context 'model tests' do
    it 'name mandatory' do
      user = User.new(email: 'kkhulla@ncsu.edu', password: 'khulla123').save
      expect(user).to eq(false)
    end

    it 'email mandatory' do
      user = User.new(name: 'khulla', password: 'khulla123').save
      expect(user).to eq(false)
    end

    it 'password mandatory' do
      user = User.new(email: 'kkhulla@ncsu.edu', name: 'khulla123').save
      expect(user).to eq(false)
    end

  end
end
