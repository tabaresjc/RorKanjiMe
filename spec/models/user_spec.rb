require 'spec_helper'

describe User do
	before :each do
		@user = User.new(name: "First User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
	end
	subject { @user }
    
	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:authenticate) }	
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
  it { should respond_to(:timezone) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
  	it { should be_admin }
  end

	it 'should be valid when all fields are present' do
		@user.should be_valid
	end	

	describe 'validation of the [name] field' do
		it 'should error when name is not present' do
			@user.name = " "
			@user.should_not be_valid
		end

		it 'should error when name is too long' do
			@user.name = "a" * 101
			@user.should_not be_valid
		end
	end

	describe 'validation of the [email] field' do
		it 'should error when email is not present' do
			@user.email = " "
			@user.should_not be_valid
		end

		it 'should error when email is too long' do
			@user.email = ("a" * 100) + "@" + ("b" * 100) + ".com" 
			@user.should_not be_valid
		end


	    it "should be invalid with wrong format" do
	      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
	      addresses.each do |invalid_address|
	        @user.email = invalid_address
	        expect(@user).not_to be_valid
	      end
	    end
		
		it "should be valid with the correct format" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
	      	end
	    end

		it "should be unique" do
			@user.save

			@user1 = User.new(name: "Second User", email: @user.email)
			@user1.save
			expect(@user1).not_to be_valid
	    end

		it "should be unique even in case insensitive" do
			@user.save

			@user1 = User.new(name: "Second User", email: @user.email.upcase)
			@user1.save
			expect(@user1).not_to be_valid
	    end	    
	end

	describe 'validation of the [password_digest] field' do
		it "should validate empty password" do
			@user.password = " "
			@user.password_confirmation = " "
			@user.should_not be_valid
    end

		it "should validate missmatch" do
			@user.password = "mismatch"
			@user.should_not be_valid
	    end	    
	end

  describe "validation of the [timezone] field" do
    it "should validate empty timezone" do
      @user.timezone = " "
      @user.should_not be_valid
    end
    
  end  

	describe "return value of authenticate method" do
		before :each do
			@user.save
			@found_user = User.find_by(email: @user.email)
		end 

		it "should validate a valid password" do
			@user.should eq @found_user.authenticate(@user.password)
		end

		it "should validate an invalid password" do
			user_for_invalid_password = @found_user.authenticate("invalid")

			@user.should_not eq user_for_invalid_password
    		expect(user_for_invalid_password).to be_false
		end
	end

	describe "remember token" do
		before { @user.save }
		subject { @user }
		it (:remember_token) { should_not be_blank }
	end

	describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

		it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

		describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end    
	end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end    

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end  
end
