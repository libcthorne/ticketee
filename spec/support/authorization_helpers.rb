module AuthorizationHelpers
  def assign_role!(user, role, project)
    # remove any existing role this user has on the project
    Role.where(user: user, project: project).delete_all
    # set the new role
    Role.create!(user: user, role: role, project: project)
  end
end

RSpec.configure do |c|
  # make helper methods available
  c.include AuthorizationHelpers
end
