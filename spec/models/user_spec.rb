require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it "has many tasks" do
      subject = User.reflect_on_association(:tasks)
      expect(subject.macro).to eq(:has_many)
    end
  end
end
