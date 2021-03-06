require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  fixtures :all
  # render_views
  
  # before :all do
  #   let(:user) => User.first
  # end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    User.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  # it "create action should redirect when model is valid" do
  #   User.any_instance.stubs(:valid?).returns(true)
  #   post :create
  #   response.should redirect_to(root_url)
  # end

  it "edit action should redirect when not logged in" do
    get :edit, :id => "ignored"
    response.should redirect_to(login_url)
  end

  it "edit action should render edit template" do
    @controller.stubs(:current_user).returns(User.first)
    get :edit, :id => User.first.id
    response.should render_template(:edit)
  end

  it "update action should redirect when not logged in" do
    put :update, :id => "ignored"
    response.should redirect_to(login_url)
  end

  # it "update action should render edit template when user is invalid" do
  #   @controller.stubs(:current_user).returns(User.first)
  #   User.any_instance.stubs(:valid?).returns(false)
  #   put :update, :id => "ignored"
  #   response.should render_template(:edit)
  # end

  it "update action should redirect when user is valid" do
    @controller.stubs(:current_user).returns(User.first)
    User.any_instance.stubs(:valid?).returns(true)
    put :update, :id => User.first, :user => {:name => "Spiro Agnew"} # need to pass a change otherwise - no update
    response.should redirect_to(users_url)
  end
  
  it 'show action should render show template' do
    @controller.stubs(:current_user).returns(User.first)
    get :show, :id => "ignored"
    response.should render_template('show')
  end
end
