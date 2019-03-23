require 'rails_helper'

RSpec.describe OperationsController, type: :controller do
=begin
  let(:admin) { create(:admin) }
  let(:client) { create(:client) }
  let(:account) { create(:account, client: client)}

  before(:each) do
    sign_in admin
    @operation = create(:deposit, sum: 1000, rate: 2, close_date: (Date.today + 6.months), withholding: 12, account: account)
  end

  describe "GET #index" do
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
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
      expect(response).to redirect_to account
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
      expect(response).to redirect_to account
    end
  end

  describe "PDF generation" do
    it "returns a PDF file inline" do
      get :show, id: @operation, account_id: account.id, format: :pdf
      expect(response.headers['Content-Type']).to have_content 'pdf'
      expect(response.content_type).to eq("application/pdf")
    end
  end
=end
end
