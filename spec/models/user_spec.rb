require 'spec_helper'

describe User do
	before :each do
		@user = User.new(name: "First User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
	end

	it 'should respont to fields' do
		@user.should respond_to(:name)
		@user.should respond_to(:email)
		@user.should respond_to(:password_digest)
		@user.should respond_to(:password)
		@user.should respond_to(:password_confirmation)
		@user.should respond_to(:authenticate)
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
end
