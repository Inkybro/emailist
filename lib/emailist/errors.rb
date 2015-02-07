class Emailist < Array
	class InvalidTLD < StandardError; end
	class InvalidEmailFormat < StandardError; end
	class HostDead < StandardError; end
	class ProfileNotFound < StandardError; end
end