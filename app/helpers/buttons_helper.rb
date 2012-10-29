# -*- encoding : utf-8 -*-
module ButtonsHelper
  def auth_buttons(mode = :link)
    html = PROVIDERS.map do |provider|
      cls = PROVIDER_CLS[provider] || provider
      if mode == :link
        link_to raw('<span class="provider">&nbsp;</span>'), auth_path(provider), :class => cls, :rel => provider
      else
        %{<button type="submit" name="#{provider}" class="#{cls}"><span>#{provider}</span></button>}.html_safe
      end
    end
    html.join.html_safe
  end
  PROVIDERS = [:facebook, :twitter, :vkontakte]
  PROVIDER_CLS = {:vkontakte => 'vk'}

  # ---


  # Генерирует ссылку или кнопку с иконкой регистрации/входа через социальную сеть.
  def auth_connect_button(service_name)
    auth_button(service_name)
  end

  def auth_disconnect_button(authentication)
    auth_button(authentication.provider) do |params|
      params[:url]  = authentication_path(authentication)
      params[:auth] = authentication
    end
  end

  def auth_button(service_name)
    provider = service_name.titleize.downcase

    params = {
      name: provider,
      url:  "/auth/#{provider}",
      auth: nil
    }

    yield params if block_given?

    if params[:auth] or not (@connected_providers.present? and @connected_providers.include?(provider))
      render partial: "shared/method_auth_connect_button",
             locals: params
    end
  end

  # Returns a link designed as button. Takes the same parameters as link_to.
  # Options are applied to link_to (except :flavor).
  # :flavor - selects look & feel of the button (nil for default,
  # :big, :alt, :bigalt for alternatives)
  def link_button(name, options = {}, html_options = {}, &block)
    flavor = html_options.delete(:flavor) || ""
    is_disabled = button_disabled?(html_options.delete(:disabled))
    css_class = apply_classes( ("disabled" if is_disabled),
                               flavor_class(flavor) )

    render( :partial => "shared/method_link_button",
            :locals => { :name => name,
              :css_class => css_class,
              :options => (options unless is_disabled),
              :html_options => html_options,
              :block => (capture(&block) if block_given?) } )
  end

  # Returns submit button designed to conform to UI. Takes the same
  # parameters as submit_tag.
  # :flavor - selects look & feel of the button (nil for default,
  # :big, :alt, :bigalt for alternatives)
  def submit_button(name, options = {})
    _button(name, options, true)
  end

  def button(name, options = {})
    _button(name, options, false)
  end

  private

  def _button(name, options = {}, submit = false)
    flavor = options.delete(:flavor)
    is_disabled = button_disabled?(options[:disabled])
    button_options = options.
      merge(:class => apply_classes(options[:class].to_s, 'link-button-l'))

    button = content_tag( :button, name,
                          button_options.merge(:type => submit ? 'submit' : 'button') )
    content_tag( :div,
                 button + content_tag(:span, '', :class => 'link-button-r'),
                 :class => apply_classes( 'link-button',
                                          ("disabled" if is_disabled),
                                          flavor_class(flavor) ) )
  end

  def flavor_class(flavor)
    flavor ? "link-button-#{flavor}" : ''
  end

  def button_disabled?(is_disabled)
    true if is_disabled == "disabled" || is_disabled == true
  end

  def apply_classes(*classes)
    classes.flatten.join(' ').strip
  end

  AUTH_BUTTON_SIZE = {
    :mini => "15x15",
    :small => "61x19",
    :normal => "80x25"
  }
end
