require 'csv'

class Facebook::PostsController < ApplicationController

  before_action :set_uid
  before_action :set_facebook_posts, if: :user_signed_in?, only: :index
  before_action :set_commentors, if: :user_signed_in?, only: :show

  def index
  end

  def set_facebook_posts
    @facebook_posts = facebook.client.get_connection(@uid, 'feed', {
      limit: 10,
      fields: ['message', 'object_id', 'link']
    })
  end

  def show
    respond_to do |format|
      format.html
      format.csv { send_data commentors_csv, filename: "#{@uid}-commentors-facebook-#{id}.csv" }
    end
  end

  def set_commentors
    @commentors = comments.commentors
  end

  def commentors_csv
    attributes = %w{name comment_link}

    ::CSV.generate(headers: true) do |csv|
      csv << attributes

      @commentors.each do |commentor|
        name = commentor.dig("from", "name")
        permalink_url = commentor.dig('permalink_url')
        url = "=HYPERLINK(\"#{permalink_url}\"; \"#{name}\")"
        row = [commentor.dig("from", "name"), url]
        csv << row
      end
    end
  end

  def set_uid
    @uid = params.dig(:uid)
  end

  def id
    @id ||= params.dig(:id)
  end

  def comments
    @comments ||= Post::Comments.new(id: id, user: current_user)
  end

  def facebook
    ::Facebook::User.new(current_user)
  end

end
