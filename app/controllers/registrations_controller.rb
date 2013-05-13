# -*- coding: utf-8 -*-
class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource
    if params[:accepted_tos]
      if resource.save
        resource.profile.update_attributes settings: params[:settings], name: params[:name]
        render 'welcome/pend_act.html.haml'
      else
        # Если в будущем нужно будет реализовать детальное описание ошибок
        # flash[:error] = resource.errors.messages.each.map{|k,v| "#{k.capitalize} #{v[0]}"}
        flash[:error] = "Проверьте заполненные поля"
        redirect_to root_path(modal: true)
      end
    else
      flash[:error] = "Вам необходимо принять соглашение"
      redirect_to root_path(modal: true)
    end
  end
end
