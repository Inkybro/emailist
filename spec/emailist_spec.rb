require_relative './spec_helper'

describe "Emailist" do

	before(:each) { @email_list = Emailist.new }

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

		describe "with common, leading, invalid word:" do
			it "To" do
				@email_list.add('To.bob.jones@yahoo.com')
				expect(@email_list.first).to eq 'bob.jones@yahoo.com'
			end
		end

		describe "with common, trailing, invalid word:" do
			it "To" do
				@email_list.add('bob.jones@yahoo.com.To')
				expect(@email_list.first).to eq 'bob.jones@yahoo.com'
			end
		end

		it "with invalid TLDs (valid TLD before invalid)" do
			@email_list.add('bob.jones@yahoo.com.gloopoopoop')
			expect(@email_list.first).to eq 'bob.jones@yahoo.com'
		end
	end

	describe "raises errors" do
		it "when an email contains no valid TLD" do
			expect { @email_list.add('bob.jones@yahoo.gloopoopoop') }.to raise_error Emailist::InvalidTLD
		end

		it "when an email's host is dead (with verify_hosts turned on)" do
			@email_list = Emailist.new(verify_hosts: true)
			expect { @email_list.add('bob.jones@gloopoop.poop.com') }.to raise_error Emailist::HostDead
		end
	end

	describe "does not raise errors" do
		it "when an email contains a valid TLD" do
			expect { @email_list.add('bob.jones@yahoo.com') }.to_not raise_error
		end

		it "when an email's host is up (with verify_hosts turned on)" do
			@email_list = Emailist.new(verify_hosts: true)
			expect { @email_list.add('bob.jones@yahoo.com') }.to_not raise_error
		end
	end

end