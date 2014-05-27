require 'spec_helper'

describe ClientsController do

  describe 'GET #index' do
    it "populates an array of all clients" do
      clients = []
      3.times do
        clients << create(:client)
      end

      get :index
      expect(assigns(:clients)).to match_array(clients)
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
   end

  describe 'GET #new' do
    before { get :new }

    it "assigns a new Client to @client" do
      expect(assigns(:client)).to be_a_new(Client)
    end

    it "renders the :new template" do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    let(:client) { create(:client)}
    before { get :edit, id: client }

    it "assigns the requested client to @client" do
      expect(assigns(:client)).to eq client
    end

    it "renders the :edit template" do
      expect(response).to render_template :edit
    end
  end

  describe 'GET #show' do
    let(:client) { create(:client)}
    before { get :show, id: client }

    it "assigns the requested client to @client" do
      expect(assigns(:client)).to eq client
    end

    it "renders the :show template" do
      expect(response).to render_template :show
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new client in the database" do
        expect {
          post :create, client: attributes_for(:client)
        }.to change(Client, :count).by(1)
      end

      it "redirects to clients#index" do
        post :create, client: attributes_for(:client)
        expect(response).to redirect_to clients_path
      end
    end

    context "with invalid attributes" do
      it "does not save the new client in the database" do
        expect {
          post :create, client: attributes_for(:invalid_client)
        }.to_not change(Client, :count)
      end

      it "re-renders the :new template" do
        post :create, client: attributes_for(:invalid_client)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:client) { create(:client, firstname: 'John', lastname: 'Smith') }

    context "valid attributes" do
      it "locates the requested @client" do
        patch :update, id: client, client: attributes_for(:client)
        expect(assigns(:client)).to eq(client)
      end

      it "changes @client's attributes" do
        patch :update, id: client, client: attributes_for(:client, firstname: 'Larry', lastname: 'Smith')
        client.reload
        expect(client.firstname).to eq("Larry")
        expect(client.lastname).to eq("SMITH")
      end

      it "redirects to the updated client" do
        patch :update, id: client, client: attributes_for(:client)
        expect(response).to redirect_to clients_path
      end
    end

    context "with invalid attributes" do
      it "does not change the client's attributes" do
        patch :update, id: client, client: attributes_for(:client, firstname: 'Larry', lastname: nil)
        client.reload
        expect(client.firstname).to_not eq("Larry")
        expect(client.lastname).to eq("SMITH")
      end

      it "re-renders the edit template" do
        patch :update, id: client, client: attributes_for(:invalid_client)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) { @client = create(:client)}

    it "deletes the client" do
      expect {
        delete :destroy, id: @client
      }.to change(Client, :count).by(-1)
    end

    it "redirects to clients#index" do
      delete :destroy, id: @client
      expect(response).to redirect_to clients_path
    end
  end

end