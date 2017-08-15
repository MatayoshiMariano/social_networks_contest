class Post::Comments

  attr_reader :id, :user

  def initialize(id:, user:)
    @id, @user = id, user
  end

  def commentors
    @commentors ||= Post::Commentors.new(comments: comments).get
  end

  def comments
    @comments ||= facebook.client.get_connection(
                    id, "comments", limit: 1000,
                    fields: attributes
                  )
  end

  def attributes
    @attributes ||= [:message_tags, :from, :permalink_url, :created_time]
  end

  def facebook
    ::Facebook::User.new(user)
  end

end
