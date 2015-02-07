require_relative './spec_helper'

describe "EmailList" do

	before(:each) { @email_list = EmailList.new }

	it "allows adding emails" do
		@email_list.add('bob@test.com')
		expect(@email_list.count).to eq 1
	end

	it "allows removing emails" do
		@email_list.add('fred@test.com')
		@email_list.remove('fred@test.com')
		expect(@email_list.count).to eq 0
	end

	it "automatically removes nil values" do
		@email_list.add(nil)
		expect(@email_list.count).to eq 0
	end

	it "automatically maintains uniqueness" do
		@email_list.add('fred@test.com')
		@email_list.add('bob@test.com')
		@email_list.add('fred@test.com')
		expect(@email_list.count).to eq 2
	end

	context "cleans emails" do
		it "with a leading period" do
			@email_list.add('.bob.jones@yahoo.com')
			expect(@email_list.first).to eq 'bob.jones@yahoo.com'
		end

		it "with a trailing period" do
			@email_list.add('bob.jones@yahoo.com.')
			expect(@email_list.first).to eq 'bob.jones@yahoo.com'
		end

		it "with more than one consecutive period" do
			@email_list.add('bob..jones@yahoo.com')
			expect(@email_list.first).to eq 'bob.jones@yahoo.com'
		end

		it "with invalid leading text" do
			@email_list.add('<TAG SIZE="2">bob.jones@yahoo.com')
			expect(@email_list.first).to eq 'bob.jones@yahoo.com'
		end

		it "with invalid trailing text" do
			@email_list.add('bob.jones@yahoo.com<TAG SIZE="2">')
			expect(@email_list.first).to eq 'bob.jones@yahoo.com'
		end

		it "with invalid TLDs (valid TLD before invalid)" do
			@email_list.add('bob.jones@yahoo.com.gloopoopoop')
			expect(@email_list.first).to eq 'bob.jones@yahoo.com'
		end
	end

	context "raises errors" do
		it "when an email contains no valid TLD" do
			expect { @email_list.add('bob.jones@yahoo.gloopoopoop') }.to raise_error EmailList::InvalidTLD
		end
	end

end