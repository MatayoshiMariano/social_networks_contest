class Facebook::User < SimpleDelegator

  def client
    @client ||= Koala::Facebook::API.new(provider.access_token)
  end

  def provider
    @provider ||= self.facebook
  end

end
