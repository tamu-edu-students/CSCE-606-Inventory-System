require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) do
    {
      name: 'Test User',
      email: 'test@example.com',
      password: 'Password1!',
      password_confirmation: 'Password1!'
    }
  end

  # Validations
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(valid_attributes)
      expect(user).to be_valid
      puts "✅ Test Passed: valid attributes"
    end

    it 'requires a name' do
      user = User.new(valid_attributes.merge(name: nil))
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
      puts "✅ Test Passed: requires name"
    end

    it 'requires an email' do
      user = User.new(valid_attributes.merge(email: nil))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
      puts "✅ Test Passed: requires email"
    end

    it 'requires a unique email' do
      User.create!(valid_attributes)
      user = User.new(valid_attributes)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
      puts "✅ Test Passed: requires unique email"
    end

    it 'requires a valid email format' do
      user = User.new(valid_attributes.merge(email: 'invalid_email'))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
      puts "✅ Test Passed: valid email format"
    end

    it 'requires password to meet complexity requirements' do
      user = User.new(valid_attributes.merge(password: 'simple', password_confirmation: 'simple'))
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must include at least one uppercase letter")
      expect(user.errors[:password]).to include("must include at least one number")
      expect(user.errors[:password]).to include("must include at least one special character")
      puts "✅ Test Passed: meet password requirements"
    end
    

    it 'requires password to be at least 8 characters' do
      user = User.new(valid_attributes.merge(password: 'Short1!', password_confirmation: 'Short1!'))
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')
      puts "✅ Test Passed: password longer than 8 characters"
    end
  end

  # Authentication
  describe 'authentication' do
    let(:user) { User.create!(valid_attributes) }

    it 'authenticates with correct password' do
      expect(user.valid_password?('Password1!')).to be true
      puts "✅ Test Passed: valid password"
    end

    it 'does not authenticate with incorrect password' do
      expect(user.valid_password?('WrongPass1!')).to be false
      puts "✅ Test Passed: No good password"
    end
  end

  # Associations
  describe 'associations' do
    it 'has many bins with dependent destroy' do
      association = described_class.reflect_on_association(:bins)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      puts "✅ Test Passed: assotiation with bins"
    end
  end


  # Password reset functionality
  describe 'password reset' do
    new_user = let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!', bins_count: 0) }
    puts "✅ Created User: #{new_user.inspect}"

    it 'generates a password reset token' do
      expect {
        user.send_reset_password_instructions
      }.to change { user.reload.reset_password_token }.from(nil)
      puts "✅ Test Passed: password reset"
      expect(user.reset_password_token).not_to be_nil
      expect(user.reset_password_sent_at).not_to be_nil
    end

  end

  # User status
  describe 'user status' do
    let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password123') }

    it 'is active by default' do
      expect(user.active?).to be true
    end

    it 'can be deactivated' do
      user.deactivate!
      expect(user.active?).to be false
    end

    it 'tracks last login timestamp' do
      expect {
        user.record_login!
      }.to change { user.last_login_at }
    end
  end
end
# helped by cursor