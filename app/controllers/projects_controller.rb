class ProjectsController < ApplicationController
  def index
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      flash[:notice] = "Project has been created!" # for next page load (after redirect)
      redirect_to @project #, notice: "Project has been created!"
    else
      # If you were to use flash instead of flash.now in this case,
      # the user would see the message twice —
      # once on the current page and once on the next page.
      flash.now[:alert] = "Project has not been created." # for current page load
      render "new"
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
