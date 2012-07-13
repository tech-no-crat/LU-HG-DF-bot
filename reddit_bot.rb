require "ruby_reddit_api"

class RedditBotError
  attr_accessor :message
  def initialize(msg)
    @message = msg
  end
end

class RedditBot
  include Reddit

  def initialize(username, password, reddit)
    @r = Api.new username, password
    unless @r.login
      raise RedditBotError.new("Unable to login!")
    end
    @reddit = reddit
  end
end
