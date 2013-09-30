require 'spec_helper'

describe "users/index" do
  let(:user) { FactoryGirl.create(:user) }
  
  before(:each) do
    sign_in user
    visit users_path
  end
  
  subject { page }

  it { should have_title('User List') }
  it { should have_content('Users') }

  describe "pagination" do
    before(:all)do
      User.delete_all
      30.times { FactoryGirl.create(:user) }
    end
    after(:all) { User.delete_all } 
       
    it { should have_selector('ul.pagination') }
    it "should list each user" do
      User.paginate(page: 1, :per_page => 10).each do |ul|
        expect(page).to have_content(ul.name)
      end
    end
  end


  describe "for signed-in users" do      
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem", title: "Lorem 1")
      FactoryGirl.create(:micropost, user: user, content: "Ipsum", title: "Ipsum 2")
    end


    describe "render the user's feed" do
      before do
        visit root_path
      end

      it "should show all micropost of the user" do
        user.feed.each do |item|
          expect(page).to have_selector("div#fi#{item.id}", text: item.content)
        end
      end

    end

    describe "follower/following counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit root_path
      end

      it { should have_link("0 following", href: following_user_path(user)) }
      it { should have_link("1 followers", href: followers_user_path(user)) }
    end
  end
end
