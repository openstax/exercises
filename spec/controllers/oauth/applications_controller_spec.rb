require 'rails_helper'

module Oauth
  RSpec.describe ApplicationsController, type: :controller do
    let!(:admin) { FactoryGirl.create :user, :admin }
    let!(:user) { FactoryGirl.create :user }

    let!(:user_user_group) {
      ug = FactoryGirl.create :user_group
      ug.add_user(user, true)
      ug
    }
    
    let!(:admin_user_group) {
      ug = FactoryGirl.create :user_group
      ug.add_user(admin, true)
      ug
    }

    let!(:trusted_application_admin) { FactoryGirl.create :doorkeeper_application, :trusted, owner: admin_user_group }
    let!(:untrusted_application_admin) { FactoryGirl.create :doorkeeper_application, owner: admin_user_group }
    let!(:trusted_application_user) { FactoryGirl.create :doorkeeper_application, :trusted, owner: user_user_group }
    let!(:untrusted_application_user) { FactoryGirl.create :doorkeeper_application, owner: user_user_group }

    it "should let a user get the list of his group's applications" do
      controller.sign_in user
      get :index, :user_group_id => user_user_group.id
      expect(response.code).to eq('200')
      expect(assigns :applications).to include(untrusted_application_user)
      expect(assigns :applications).to include(trusted_application_user)
      expect(assigns :applications).not_to include(untrusted_application_admin)
      expect(assigns :applications).not_to include(trusted_application_admin)
    end

    it "should not let a user get the list of another group's applications" do
      controller.sign_in user
      expect{get :index, :user_group_id => admin_user_group.id}.to raise_error(SecurityTransgression)
      expect(assigns :applications).to be_nil
    end

    it "should let a user get his group's application" do
      controller.sign_in user
      get :show, id: untrusted_application_user.id
      expect(response.code).to eq('200')
      expect(assigns(:application).name).to eq(untrusted_application_user.name)
      expect(assigns(:application).redirect_uri).to eq(untrusted_application_user.redirect_uri)
      expect(assigns(:application).trusted).to eq(untrusted_application_user.trusted)
    end

    it "should not let a user get another group's application" do
      controller.sign_in user
      expect{get :show, id: untrusted_application_admin.id}.to raise_error(SecurityTransgression)
    end

    it "should let an admin get another group's application" do
      controller.sign_in admin
      get :show, id: untrusted_application_user.id
      expect(response.code).to eq('200')
      expect(assigns(:application).name).to eq(untrusted_application_user.name)
      expect(assigns(:application).redirect_uri).to eq(untrusted_application_user.redirect_uri)
      expect(assigns(:application).trusted).to eq(untrusted_application_user.trusted)
    end

    it "should let a user get new for his group" do
      controller.sign_in user
      get :new, :user_group_id => user_user_group.id
      expect(response.code).to eq('200')
    end

    it "should not let a user get new for another group" do
      controller.sign_in user
      expect{get :new, :user_group_id => admin_user_group.id}.to raise_error(SecurityTransgression)
      expect(assigns(:application).id).to be_nil
    end

    it "should let an admin get new for another group" do
      controller.sign_in admin
      get :new, :user_group_id => user_user_group.id
      expect(response.code).to eq('200')
    end

    it "should let a user create an untrusted application for his group" do
      controller.sign_in user
      post :create, :user_group_id => user_user_group.id,
                    :application => {name: 'Some app',
                                     redirect_uri: 'http://www.example.com',
                                     trusted: true}
      expect(response.code).to eq('302')
      expect(assigns(:application).name).to eq('Some app')
      expect(assigns(:application).redirect_uri).to eq('http://www.example.com')
      expect(assigns(:application).trusted).to eq(false)
    end

  it "should not let a user create an application for another group" do
    controller.sign_in user
    expect{post :create, :user_group_id => admin_user_group.id,
                :application => {
                  name: 'Some app',
                  redirect_uri: 'http://www.example.com',
                  trusted: true}}.to raise_error(SecurityTransgression)
    expect(assigns(:application).id).to be_nil
  end

    it "should let an admin create a trusted application for another group" do
      controller.sign_in admin
      post :create, :user_group_id => user_user_group.id,
                    :application => {name: 'Some app',
                                     redirect_uri: 'http://www.example.com',
                                     trusted: true}
      expect(response.code).to eq('302')
      expect(assigns(:application).name).to eq('Some app')
      expect(assigns(:application).redirect_uri).to eq('http://www.example.com')
      expect(assigns(:application).trusted).to eq(true)
    end

    it "should let a user edit his own application" do
      controller.sign_in user
      get :edit, id: untrusted_application_user.id
      expect(response.code).to eq('200')
      expect(assigns(:application).name).to eq(untrusted_application_user.name)
      expect(assigns(:application).redirect_uri).to eq(untrusted_application_user.redirect_uri)
      expect(assigns(:application).trusted).to eq(untrusted_application_user.trusted)
    end

    it "should not let a user edit someone else's application" do
      controller.sign_in user
      expect{get :edit, id: untrusted_application_admin.id}.to raise_error(SecurityTransgression)
    end

    it "should let an admin edit someone else's application" do
      controller.sign_in admin
      get :edit, id: untrusted_application_user.id
      expect(response.code).to eq('200')
      expect(assigns(:application).name).to eq(untrusted_application_user.name)
      expect(assigns(:application).redirect_uri).to eq(untrusted_application_user.redirect_uri)
      expect(assigns(:application).trusted).to eq(untrusted_application_user.trusted)
    end

    it "should let a user update his own application" do
      controller.sign_in user
      post :update, id: untrusted_application_user.id, application: {name: 'Some other name', redirect_uri: 'http://www.example.net', trusted: true}
      expect(response.code).to eq('302')
      expect(assigns(:application).name).to eq('Some other name')
      expect(assigns(:application).redirect_uri).to eq('http://www.example.net')
      expect(assigns(:application).trusted).to eq(false)
    end

    it "should not let a user update someone else's application" do
      controller.sign_in user
      expect{post :update, id: untrusted_application_admin.id, application: {name: 'Some other name', redirect_uri: 'http://www.example.net', trusted: true}}.to raise_error(SecurityTransgression)
    end

    it "should let an admin update someone else's application" do
      controller.sign_in admin
      post :update, id: untrusted_application_user.id, application: {name: 'Some other name', redirect_uri: 'http://www.example.net', trusted: true}
      expect(response.code).to eq('302')
      expect(assigns(:application).name).to eq('Some other name')
      expect(assigns(:application).redirect_uri).to eq('http://www.example.net')
      expect(assigns(:application).trusted).to eq(true)
    end

    it "should let a user destroy his own application" do
      controller.sign_in user
      delete :destroy, id: untrusted_application_user.id
      expect(response.code).to eq('302')
      expect(assigns(:application).destroyed?).to eq(true)
    end

    it "should not let a user destroy someone else's application" do
      controller.sign_in user
      expect{delete :destroy, id: untrusted_application_admin.id}.to raise_error(SecurityTransgression)
    end

    it "should let an admin destroy someone else's application" do
      controller.sign_in admin
      delete :destroy, id: untrusted_application_user.id
      expect(response.code).to eq('302')
      expect(assigns(:application).destroyed?).to eq(true)
    end
  end
end
