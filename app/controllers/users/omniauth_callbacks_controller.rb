class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if provider_generator.provider.present?
      redirect_to root_path
    else
      redirect_to root_path, flash: "No se pudo integrar con facebook"
    end
  end

  def failure
    set_flash_message :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    redirect_to after_omniauth_failure_path_for(resource_name)
  end

  def provider_generator
    @provider_generator ||= ProviderContexts::Generator.new(
      user: current_user, auth: request.env["omniauth.auth"]
    )
  end

end
