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
end
