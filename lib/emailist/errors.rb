class Emailist < Array
	class InvalidTLD < StandardError; end
	class InvalidEmailFormat < StandardError; end
	class CantVerifyProfile < StandardError; end
end