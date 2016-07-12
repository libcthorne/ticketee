#require 'spec_helper'
# Before you run the specs, there’s just one last thing you need to do—change the
# line at the top of the file from require "spec_helper" to require "rails_helper" , to
# set up Rails. This way, Rails will be loaded, Factory Girl will be loaded, and then Rails
# can autoload the ProjectPolicy class correctly.
require 'rails_helper'

describe ProjectPolicy do

  let(:user) { User.new }

  # A great way to make your tests more DRY:
  # defining an unchanging method call in one place,
  # and then simply referring to it when you need it.
  subject { ProjectPolicy }


  context "policy_scope" do
    subject { Pundit.policy_scope(user, Project) }

    let!(:project) { FactoryGirl.create :project }
    let(:user) { FactoryGirl.create :user }

    it "is empty for anonymous users" do
      expect(Pundit.policy_scope(nil, Project)).to be_empty
    end

    it "includes projects a user is allowed to view" do
      assign_role!(user, :viewer, project)
      expect(subject).to include(project)
    end

    it "doesn't include projects a user is not allowed to view" do
      expect(subject).to be_empty
    end

    it "returns all projects for admins" do
      user.admin = true
      expect(subject).to include(project)
    end
  end

  context "permissions" do
    subject { ProjectPolicy.new(user, project) }

    let(:user) { FactoryGirl.create :user }
    let(:project) { FactoryGirl.create :project }

    context "for anonymous users" do
      let(:user) { nil }

      it { should_not permit_action :show }
      it { should_not permit_action :update }
    end

    context "for viewers of the project" do
      before { assign_role!(user, :viewer, project) }

      it { should permit_action :show }
      it { should_not permit_action :update }
    end

    context "for editors of the project" do
      before { assign_role!(user, :editor, project) }

      it { should permit_action :show }
      it { should_not permit_action :update }
    end

    context "for managers of the project" do
      before { assign_role!(user, :manager, project) }

      it { should permit_action :show }
      it { should permit_action :update }
    end

    context "for managers of other projects" do
      before do
        assign_role!(user, :manager, FactoryGirl.create(:project))
      end

      it { should_not permit_action :show }
      it { should_not permit_action :update }
    end

    context "for administrators" do
      let(:user) { FactoryGirl.create :user, :admin }

      it { should permit_action :show }
      it { should permit_action :update }
    end
  end


  # Per action rather than per role approach #
  ############################################

  # permissions :show? do
  #   let(:user) { FactoryGirl.create :user }
  #   let(:project) { FactoryGirl.create :project }

  #   it "blocks anonymous users" do
  #     expect(subject).not_to permit(nil, project)
  #   end

  #   it "allows viewers of the project" do
  #     assign_role!(user, :viewer, project)
  #     expect(subject).to permit(user, project)
  #   end

  #   it "allows editors of the project" do
  #     assign_role!(user, :editor, project)
  #     expect(subject).to permit(user, project)
  #   end

  #   it "allows managers of the project" do
  #     assign_role!(user, :manager, project)
  #     expect(subject).to permit(user, project)
  #   end

  #   it "allows administrators" do
  #     admin = FactoryGirl.create :user, :admin
  #     expect(subject).to permit(admin, project)
  #   end

  #   it "doesn't allow users assigned to other projects" do
  #     other_project = FactoryGirl.create :project
  #     assign_role!(user, :manager, other_project)
  #     expect(subject).not_to permit(user, project)
  #   end
  # end

  # permissions :update? do
  #   let(:user) { FactoryGirl.create :user }
  #   let(:project) { FactoryGirl.create :project }

  #   it "blocks anonymous users" do
  #     expect(subject).not_to permit(nil, project)
  #   end

  #   it "doesn't allows viewers of the project" do
  #     assign_role!(user, :viewer, project)
  #     expect(subject).not_to permit(user, project)
  #   end

  #   it "doesn't allows editors of the project" do
  #     assign_role!(user, :editor, project)
  #     expect(subject).not_to permit(user, project)
  #   end

  #   it "allows managers of the project" do
  #     assign_role!(user, :manager, project)
  #     expect(subject).to permit(user, project)
  #   end

  #   it "allows administrators" do
  #     admin = FactoryGirl.create :user, :admin
  #     expect(subject).to permit(admin, project)
  #   end

  #   it "doesn't allow users assigned to other projects" do
  #     other_project = FactoryGirl.create :project
  #     assign_role!(user, :manager, other_project)
  #     expect(subject).not_to permit(user, project)
  #   end
  # end

end
