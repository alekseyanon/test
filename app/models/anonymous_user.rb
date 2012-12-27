# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class AnonymousUser

  def roles; []; end

  def role?(role); role == :anonymous; end

  def logged_in?; false; end

  def deleted?; false; end

  def admin?; false; end

  def traveler?; false; end

  def anonymous?; true; end

  def id; nil; end

  def city_id; nil; end

  def city; nil; end

end