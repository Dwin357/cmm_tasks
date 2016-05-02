require 'rails_helper'

RSpec.describe "nav bar", type: :view do
  include SessionsHelper
  context "when user is logged in" do
    before :each do
      login(FactoryGirl.create(:user))
    end
    after :each do
      logout
    end
    it "has users username" do
      render partial: "shared/nav_bar"
      expect(rendered).to match /#{FactoryGirl.attributes_for(:user)[:username]}/
    end
    it "has link to users tasks" do
      render partial: "shared/nav_bar"
      expect(rendered).to match /#{link_to "My Tasks", user_path(current_user!)}/
    end
    it "has a link for user to sign out" do
      render partial: "shared/nav_bar"
      expect(rendered).to match /#{link_to "Logout", session_path(current_user!), method: :delete }/
    end
    it "has link add new customers" do
      render partial: "shared/nav_bar"
      expect(rendered).to match /#{link_to "New Customer", new_customer_path}/
    end
    it "has link to view customers" do
      render partial: "shared/nav_bar"
      expect(rendered).to match /#{link_to "View Customers", customers_path}/
    end
    # it "has link add new project" do
    #   render partial: "shared/nav_bar"
    #   expect(rendered).to match /#{link_to "New Customer", new_customer_path}/
    # end
    # it "has link to view projects" do
    #   render partial: "shared/nav_bar"
    #   expect(rendered).to match /#{link_to "View Customers", customers_path}/
    # end    
  end
end