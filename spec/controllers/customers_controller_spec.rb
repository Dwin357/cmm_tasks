require 'rails_helper'

RSpec.describe CustomersController, type: :controller do

  describe "GET #new" do
    it 'renders new customers page' do
      get :new
      expect(response).to render_template("new")
    end
  end

end