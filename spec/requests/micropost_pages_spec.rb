require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do 
        fill_in 'micropost_content', with: "Lorem ipsum"
        fill_in 'micropost_title', with: "Title"
      end
      
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum", title: "New title 1")
      FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet", title: "New title 2")
      sign_in user
      visit root_path
    end

    it "should render the user's feed" do
      user.feed.each do |item|
        expect(page).to have_selector("div#fi#{item.id}", text: item.content)
      end
    end
  end 

  describe "micropost destruction" do
    before do 
      30.times { FactoryGirl.create(:micropost, user: user)  }
    end

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        user.microposts.each do |m|
          expect { page.find(:xpath, "//a[@href='/microposts/#{m.id}']").click }.to change(Micropost, :count).by(-1)  
        end
      end 
    end
  end  
end