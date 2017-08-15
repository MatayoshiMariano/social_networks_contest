class Post::Commentors

	attr_reader :comments

	def	initialize(comments:)
    @comments = comments
	end

  def get
    comments.flat_map do |comment|
      tags = comment.dig("message_tags")
      if tags.present? && tags.count >= 2
        comment.slice("from", "permalink_url", "created_time")
      end
    end.compact.uniq do |comment|
      comment.dig("from", "id")
    end
  end

end

