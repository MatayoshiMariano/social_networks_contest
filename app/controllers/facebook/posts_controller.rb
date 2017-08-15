require 'csv'

class Facebook::PostsController < ApplicationController

  before_action :set_uid
  before_action :set_facebook_posts, if: :user_signed_in?, only: :index
  before_action :set_commentors, if: :user_signed_in?, only: :show

  def index
  end

  def set_facebook_posts
    @facebook_posts = if page.present?
      facebook.client.get_page(page)
    else
      facebook.client.get_connection(@uid, 'feed', {
        limit: 10,
        fields: ['message', 'object_id', 'link', 'created_time']
      })
    end
  end

  def page
    @page ||= params.permit!.to_h.dig(:page)
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
    attributes = %w{name comment_link created_at}

    ::CSV.generate(headers: true) do |csv|
      csv << attributes

      @commentors.each do |commentor|
        name = commentor.dig("from", "name")
        time = commentor.dig("created_time").to_time.in_time_zone
        permalink_url = commentor.dig('permalink_url')
        url = "=HYPERLINK(\"#{permalink_url}\"; \"#{name}\")"
        row = [commentor.dig("from", "name"), url, time]
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
