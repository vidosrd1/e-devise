class DeviseController < Devise.parent_controller.constantize
  include Devise::Controllers::ScopedViews

  if respond_to?(:helper)
    helper DeviseHelper
  end

  if respond_to?(:helper_method)
    helpers = %w(resource scope_name resource_name signed_in_resource
                 resource_class resource_params devise_mapping)
    helper_method(*helpers)
  end

  prepend_before_action :assert_is_devise_resource!
  respond_to :html if mimes_for_respond_to.empty?

  def _prefixes #:nodoc:
    @_prefixes ||= if self.class.scoped_views? && request && devise_mapping
      ["#{devise_mapping.scoped_path}/#{controller_name}"] + super
    else
      super
    end
  end

  protected

  def resource
    instance_variable_get(:"@#{resource_name}")
  end
  def resource_name
    devise_mapping.name
  end

  alias :scope_name :resource_name

  def resource_class
    devise_mapping.to
  end
  def signed_in_resource
    warden.authenticate(scope: resource_name)
  end
  def devise_mapping
    @devise_mapping ||= request.env["devise.mapping"]
  end
  def assert_is_devise_resource! #:nodoc:
    unknown_action! <<-MESSAGE unless devise_mapping
Could not find devise mapping for path #{request.fullpath.inspect}.
This may happen for two reasons:

1) You forgot to wrap your route inside the scope block. For example:

  devise_scope :user do
    get "/some/route" => "some_devise_controller"
  end

2) You are testing a Devise controller bypassing the router.
   If so, you can explicitly tell Devise which mapping to use:

   @request.env["devise.mapping"] = Devise.mappings[:user]

MESSAGE
  end
  def navigational_formats
    @navigational_formats ||= Devise.navigational_formats.select { |format| Mime::EXTENSION_LOOKUP[format.to_s] }
  end
  def unknown_action!(msg)
    logger.debug "[Devise] #{msg}" if logger
    raise AbstractController::ActionNotFound, msg
  end
  def resource=(new_resource)
    instance_variable_set(:"@#{resource_name}", new_resource)
  end
  def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?
    no_input = devise_mapping.no_input_strategies

    authenticated = if no_input.present?
      args = no_input.dup.push scope: resource_name
      warden.authenticate?(*args)
    else
      warden.authenticated?(resource_name)
    end

    if authenticated && resource = warden.user(resource_name)
      set_flash_message(:alert, 'already_authenticated', scope: 'devise.failure')
      redirect_to after_sign_in_path_for(resource)
    end
  end
  def successfully_sent?(resource)
    notice = if Devise.paranoid
      resource.errors.clear
      :send_paranoid_instructions
    elsif resource.errors.empty?
      :send_instructions
    end

    if notice
      set_flash_message! :notice, notice
      true
    end
  end
  # Example (i18n locale file):
  #
  #   en:
  #     devise:
  #       passwords:
  #         #default_scope_messages - only if resource_scope is not found
  #         user:
  #           #resource_scope_messages
  #
  # Please refer to README or en.yml locale file to check what messages are
  # available.
  def set_flash_message(key, kind, options = {})
    message = find_message(kind, options)
    if options[:now]
      flash.now[key] = message if message.present?
    else
      flash[key] = message if message.present?
    end
  end
  def set_flash_message!(key, kind, options = {})
    if is_flashing_format?
      set_flash_message(key, kind, options)
    end
  end
  def set_minimum_password_length
    if devise_mapping.validatable?
      @minimum_password_length = resource_class.password_length.min
    end
  end
  def devise_i18n_options(options)
    options
  end
  def find_message(kind, options = {})
    options[:scope] ||= translation_scope
    options[:default] = Array(options[:default]).unshift(kind.to_sym)
    options[:resource_name] = resource_name
    options = devise_i18n_options(options)
    I18n.t("#{options[:resource_name]}.#{kind}", **options)
  end
  def translation_scope
    "devise.#{controller_name}"
  end
  def clean_up_passwords(object)
    object.clean_up_passwords if object.respond_to?(:clean_up_passwords)
  end
  def respond_with_navigational(*args, &block)
    respond_with(*args) do |format|
      format.any(*navigational_formats, &block)
    end
  end
  def resource_params
    params.fetch(resource_name, {})
  end
  ActiveSupport.run_load_hooks(:devise_controller, self)
end
