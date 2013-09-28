require 'spec_helper'

describe "users/show" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    visit user_path(user)
  end

  subject { page }
  it { should have_content(user.name) }
  it { should have_content(user.email) }
end
