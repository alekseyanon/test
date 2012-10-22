# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
module UserFeatures
  module Roles
    ROLES = [:admin, :traveler]

    def self.included(base)
      base.extend ClassMethods
      base.send(:roles_support)
    end

    module ClassMethods
      def roles_support
        bitfield_attribute :roles,
                           :values => ROLES

        # validate            :check_roles

        include InstanceMethods
      end

      # with any of given roles
      # Usage: with_role(:contractor), with_role(:contractors), with_role("contractor", :employers), with_role([:contractors, :employers])
      def with_role(*args)
        roles = Array(args).map{|role| role.to_s.singularize }
        role_val = magic_number_for(:roles, roles)
        scoped( role_val.zero? ? {} : {:conditions => ["roles & ?", role_val]} )
      end

      def bit_values_for(role)
        (0..(2**ROLES.size)).select{|n| n&(2**ROLES.index(role)) != 0 }
      end

    end


    module InstanceMethods

      def role?(role)
        roles.include?(role.to_sym)
      end

      def admin?
        self.role?(:admin)
      end

      def traveler?
        self.role?(:traveler)
      end

      def anonymous?
        false
      end

      # основная роль юзера в системе: исполнитель или заказчик
      # def main_role
      #   contractor? ? :contractor : :employer
      # end

      private

      # def check_roles
      #   return true #if self.fake?
      #   self.errors.add :roles, "User should be either :contractor or :employer or :admin" if (self.roles & [:traveler, :admin]).empty?
      # end

    end

  end
end
