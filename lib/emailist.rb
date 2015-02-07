require "emailist/version"
require "emailist/errors"

class Emailist < Array

	VALID_TLDS = File.read(
		File.expand_path(File.join(File.dirname(__FILE__), '..', 'data', 'valid_tlds.txt'))
	).lines.to_a.map {|tld| tld.gsub(/[^A-Z\-]/, '') }

	INVALID_START_WITH = [
		'TO.', 'To.', 'E-mail', 'AS', 'TO:', 'To:'
	]

	INVALID_END_WITH = [
		'.TO', '.To', 'E'
	]


	def initialize(verify_profiles: false)
		@verify_profiles = verify_profiles
	end


	alias_method :_push, :push
	def push(email)
		_push(clean(email))
		refresh!
	end
	#alias_method :<<, :push
	#alias_method :add, :push

	def <<(email)
		push(email)
	end

	def add(email)
		push(email)
	end

	alias_method :_unshift, :unshift
	def unshift(email)
		_unshift(clean(email))
		refresh!
	end

	alias_method :_delete, :delete
	def delete(email)
		_delete(clean(email))
		refresh!
	end
	
	def remove(email)
		delete(email)
	end

	alias_method :_include?, :include?
	def include?(email)
		_include?(clean(email))
	end

private

	def refresh!
		_delete(nil)
		uniq!
		return self
	end

	def clean(email)
		return if email.nil?

		# strip email first
		email = email.strip
		
		# convert >1 consecutive period to 1 period
		email.gsub!(/\.{2,}/, '.')

		# remove invalid start/end with
		INVALID_START_WITH.each do |with|
			email = email[(with.length)..email.length-1] if email.start_with?(with)
		end
		INVALID_END_WITH.each do |with|
			email = email[0..(email.length-with.length)] if email.end_with?(with)
		end

		# get local/domain parts separated
		local, domain = email.split('@')

		# remove leading/trailing periods
		local = local[1..local.length-1] if local[0] == '.'
		domain = domain[0..domain.length-2] if domain[domain.length-1] == '.'

		# remove invalid leading text
		new_local = ''
		local.chars.each do |char|
			if char =~ /[A-Z0-9!#\$%&'\*\+\-\/=\?\^_`\{\|\}~\.]/i
				new_local += char
			else
				new_local = ''
			end
		end
		local = new_local

		# remove invalid trailing text
		new_domain = ''
		domain.chars.each do |char|
			if char =~ /[A-Z0-9\-\.]/i
				new_domain += char
			else
				break
			end
		end
		domain = new_domain

		# remove invalid TLDs
		domain_split = domain.split('.').reverse
		if !VALID_TLDS.include?(domain_split.first)
			new_domain = []
			found_tld = false
			domain_split.each do |part|
				if !found_tld && VALID_TLDS.include?(part.strip.upcase)
					found_tld = true
					new_domain.unshift(part)
				elsif found_tld
					new_domain.unshift(part)
				end
			end
			raise Emailist::InvalidTLD if !found_tld
		else
			new_domain = domain_split.reverse
		end
		domain = new_domain.join('.')

		email = "#{local}@#{domain}".downcase

		if @verify_profiles
			begin
				response = [PossibleEmail.find_profile(email)].flatten
				if response.empty?
					raise Emailist::CantVerifyProfile
				end
			rescue PossibleEmail::InvalidEmailFormat
				raise Emailist::InvalidEmailFormat
			end
		end

		email
	end
  
end
