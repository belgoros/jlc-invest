require 'spec_helper'

describe OperationsController do
  let(:admin) { create(:admin) }
  let(:client) { create(:client) }
  let(:account) { create(:account, client: client)}
  
  before(:each) do
    sign_in admin
    @operation = create(:deposit, sum: 1000, rate: 2, close_date: (Date.today + 6.months), withholding: 12, account: account)
  end

  describe "GET #index" do
    it "renders the :index view" do
      visit operations_path
      response.should render_template :index
    end
  end

  describe "POST create" do        
    
    it "creates a new operation" do
      expect {
        post :create, operation: attributes_for(:deposit, sum: 1000, rate: 2, close_date: (Date.today + 6.months), withholding: 12, account: account), account_id: account.id
      }.to change(Operation, :count).by(1)
    end

    it "redirects to the client accounts page" do
      post :create, operation: attributes_for(:deposit, sum: 1000, rate: 2, close_date: (Date.today + 6.months), withholding: 12, account: account), account_id: account.id
      response.should redirect_to account
    end
  end
  
  describe 'DELETE #destroy' do    

    it "deletes the operation from the database" do
      expect {
        delete :destroy, id: @operation, account_id: account.id
      }.to change(Operation, :count).by(-1)
    end

    it "redirects to the Account operations page" do
      delete :destroy, id: @operation, account_id: account.id
      response.should redirect_to account
    end
  end
  
  describe "PDF generation" do    
    it "creates a PDF report for a specified account operation" do
      get :show, id: @operation, account_id: account.id, format: :pdf
      response.content_type.should eq("application/pdf")
      response.headers["Content-Disposition"].should eq("inline")      
    end
  end
  
end

