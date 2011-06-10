class ListsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @deps = @project.deployments.paginate :page => params[:page], :per_page => 6, :order => 'updated_at DESC'
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project.to_xml }
    end
    
  end
  
  def index
    redirect_to projects_path
  end
end