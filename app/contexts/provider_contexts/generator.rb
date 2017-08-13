class ProviderContexts::Generator

  attr_reader :user, :auth

  def initialize(user:, auth:)
    @user, @auth = user, auth
  end

  def provider
    user.providers.where(type: auth.provider)
                  .first_or_initialize do |provider|
      provider.access_token = auth.credentials.token
      provider.uid = auth.uid
      provider.expires_at = Time.at(auth.credentials.expires_at)
    end.save
  end

  def providers
    @providers ||= user.providers
  end

end
