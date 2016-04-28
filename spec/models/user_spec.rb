require 'rails_helper'

RSpec.describe User, type: :model do

  let(:subject) { build(:user) }

  describe "associations" do
    it "has many tasks" do
      subject = User.reflect_on_association(:tasks)
      expect(subject.macro).to eq(:has_many)
    end
  end

  describe "password" do
    it "encrypts password in db" do
      expect(subject.password_digest).to_not eq("joker")
    end
    it "recognizes authentic password" do
      expect(subject.authentic_password?("joker")).to be true
    end

    describe "reset password" do
      it "returns a new password" do
        expect(subject.reset_password_to_random).to_not eq("joker")
      end
      it "resets the models password to new random pw" do
        random_pw = subject.reset_password_to_random
        expect(subject.authentic_password?(random_pw)).to be true
      end
    end
  end
end
