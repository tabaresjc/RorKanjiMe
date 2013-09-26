require 'spec_helper'


describe "Users" do

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end
    subject { page }
    it { should have_title('User List') }
    it { should have_content('Users') }

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('tr > td', text: user.name)
      end
    end
  end  

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { expect(page).to have_content(user.name) }
    it { expect(page).to have_content(user.email) }
  end

  describe "signup" do
  	before { visit signup_path }
  	let(:submit) { "Create my account" }
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "user[name]",   				with: "Example User"
        fill_in "user[email]",       			with: "user@example.com"
        fill_in "user[password]",     			with: "foobar"
        fill_in "user[password_confirmation]", 	with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }
        subject { page }

        it { should have_link('Sign out') }
        it { should have_content(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end      
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    subject { page }

    describe "page" do
      it { should have_content("Profile: #{user.name}") }
      it { should have_link('Change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Update User" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Update User"
      end

      it { should have_title("Profile") }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end  


end
