require 'spec_helper'


describe "Users" do

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    
    before(:each) do
      sign_in user
      visit users_path
    end
    
    subject { page }

    describe "delete links" do
      
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link("ru#{user.id}") }
        it { should_not have_link("ru#{admin.id}") }

        it "should be able to delete another user" do
          expect do
            click_link("ru#{user.id}")
          end.to change(User, :count).by(-1)
        end
        
      end
    end

    describe "change links" do
      
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link("cu#{admin.id}") }
        it { should have_link("cu#{user.id}") }
        
      end
    end    
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo", title: "Foo Title") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar", title: "Bar Title") }

    before do
      sign_in user
      visit user_path(user)
    end

    subject { page }

    it { should have_content(user.name) }
    it { should have_content(user.email) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m1.title) }
      it { should have_content(m2.content) }
      it { should have_content(m2.title) }
      it { should have_content(user.microposts.count) }
    end
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

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    subject { page }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
