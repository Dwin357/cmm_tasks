require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "associations" do
    it "has many projects" do
      subject = Customer.reflect_on_association(:projects)
      expect(subject.macro).to eq(:has_many)
    end
  end
end
