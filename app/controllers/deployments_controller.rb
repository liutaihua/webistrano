class DeploymentsController < ApplicationController
  
  before_filter :load_stage, :except => [:scm_deploy]
  before_filter :ensure_deployment_possible, :only => [:new, :create]
  before_filter :ensure_not_viewer , :except => [:index, :show]

  # GET /projects/1/stages/1/deployments
  # GET /projects/1/stages/1/deployments.xml
  def index
    @deployments = @stage.deployments

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @deployments.to_xml }
    end
  end

  # GET /projects/1/stages/1/deployments/1
  # GET /projects/1/stages/1/deployments/1.xml
  def show
    @deployment = @stage.deployments.find(params[:id])
    set_auto_scroll
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @deployment.to_xml }
      format.js { render :partial => 'status.html.erb' }
    end
  end

  # GET /projects/1/stages/1/deployments/new
  def new
    @deployment = @stage.deployments.new
    unless cmd = @stage.effective_configuration('show_log_cmd').blank?
      @deployment.description = `#{cmd}` rescue ''
    end

    @deployment.task = params[:task]
#    @task_list = [] + @stage.list_tasks.collect{|task| [task[:name], task[:name]]}.sort()
@task_list = [['All tasks: ', '']] + @stage.list_tasks.collect{|task| [task[:name], task[:name]]}.sort()
    
    if params[:repeat]
      @original = @stage.deployments.find(params[:repeat])
      @deployment = @original.repeat
    end
  end

  # POST /projects/1/stages/1/deployments
  # POST /projects/1/stages/1/deployments.xml
  def create
     logger.error("create ....begin");
    @deployment = Deployment.new
    
    respond_to do |format|
	
      if populate_deployment_and_fire

        if params[:revert] then
  	   @deployment.git_server_revert_background!
           #@deployment.git_server_revert_background!(params[:deployment][:prompt_config][:tag_name])
	end

        
        @deployment.deploy_in_background!

        format.html { redirect_to project_stage_deployment_url(@project, @stage, @deployment)}
        format.xml  { head :created, :location => project_stage_deployment_url(@project, @stage, @deployment) }
      else
        @deployment.clear_lock_error
        format.html { render :action => "new" }
        format.xml  { render :xml => @deployment.errors.to_xml }
      end
    end
     logger.error("create ....end");
  end

 def scm_create
#    @p = params
#    return render :inline => '<%= debug(@p) %>'
    @deployment = Deployment.new

    respond_to do |format|
      if populate_deployment_and_fire

        @deployment.deploy_in_background!

        format.html { redirect_to project_stage_deployment_url(@project, @stage, @deployment)}
        format.xml  { head :created, :location => project_stage_deployment_url(@project, @stage, @deployment) }
      else
        @deployment.clear_lock_error
        format.html { render :action => "new" }
        format.xml  { render :xml => @deployment.errors.to_xml }
      end
    end
  end

  def scm_deploy
#    tag_name = params[:tag_name]
#    task = params[:task]
    task, tag_name = params[:cmd].strip.split('/')
    raise "#{task} not found--!!" unless dep = Deployment.find_by_task(task)
    h = {
        'project_id' => dep.stage.project.id,
        'stage_id' => dep.stage.id,
        'deployment[task]' => task,
        'deployment[description]' =>'deployed by scmer',
        'deployment[override_locking]' =>'',
        'deployment[prompt_config][tag_name]' => tag_name
    }
    session[:pid] = dep.stage.project.id

   redirect_to("http://op.sdo.com/capui/deployments/scm_create?" + h.to_query, :status => 302)
#    return render :inline => "<%= debug f %>"
  end



  # GET /projects/1/stages/1/deployments/latest
  def latest
    @deployment = @stage.deployments.find(:first, :order => "created_at desc")

    respond_to do |format|
      format.html { render :action => "show"}
      format.xml do
        if @deployment
          render :xml => @deployment.to_xml
        else
          render :status => 404, :nothing => true
        end
      end
    end
  end
  
  # POST /projects/1/stages/1/deployments/1/cancel
  def cancel
    redirect_to "/" and return unless request.post?
    @deployment = @stage.deployments.find(:first, :order => "created_at desc")

    respond_to do |format|
      begin
        @deployment.cancel!
        
        flash[:notice] = "Cancelled deployment by killing it"
        format.html { redirect_to project_stage_deployment_url(@project, @stage, @deployment)}
        format.xml  { head :ok }
      rescue => e
        flash[:error] = "Cancelling failed: #{e.message}"
        format.html { redirect_to project_stage_deployment_url(@project, @stage, @deployment)}
        format.xml  do
          @deployment.errors.add("base", e.message)
          render :xml => @deployment.errors.to_xml 
        end
      end
    end
  end
  
  protected
  def ensure_deployment_possible
    if current_stage.deployment_possible?
        true
    else
      respond_to do |format|  
        flash[:error] = 'A deployment is currently not possible.'
        format.html { redirect_to project_stage_url(@project, @stage) }
        format.xml  { render :xml => current_stage.deployment_problems.to_xml }
        false
      end
    end
  end
  
  def set_auto_scroll
    if params[:auto_scroll].to_s == "true"
      @auto_scroll = true
    else
      @auto_scroll = false
    end
  end
  
  # sets @deployment
  def populate_deployment_and_fire
    return Deployment.lock_and_fire do |deployment|
	
      @deployment = deployment
      @deployment.attributes = params[:deployment]
      @deployment.prompt_config = params[:deployment][:prompt_config] rescue {}
      @deployment.revision = params[:deployment][:prompt_config][:tag_name] rescue ''
      @deployment.stage = current_stage
      @deployment.user = current_user
      @deployment.revert = 1 unless params[:revert].blank? rescue ''
    end
  end
  
end
