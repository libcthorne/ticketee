class ProjectPolicy < ApplicationPolicy
  # The Scope class can be used to filter out resources,
  # depending on what permissions people have.
  # For example, you could limit which objects are returned
  # to display in an index action.
  class Scope < Scope
    def resolve
      # scope is the argument passed to policy_scope (Project)
      #scope

      return scope.none if user.nil?
      return scope.all if user.admin?

      scope.joins(:roles).where(roles: { user_id: user })
    end
  end

  # RE #show:
  # By default, the ApplicationPolicy states that if the
  # project exists in the database, then permission is granted.

  def show?
    # user: current user
    user.try(:admin?) || record.has_member?(user)
  end

  # RE #update:
  # default is return false

  def update?
    user.try(:admin?) || record.has_manager?(user)
  end

end
