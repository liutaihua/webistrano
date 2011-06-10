require 'open-uri'
require 'uri'

class Hash
  def to_query
    URI.escape to_a.collect {|kv|kv.join('=')}.join('&')
  end
end

class ScmerController < ApplicationController
  def deploy
#    tag_name = params[:tag_name]
#    task = params[:task]
    task, tag_name = params[:cmd].split('/')
    raise "#{task} not found" unless dep = Deployment.find_by_task(task)
    h = {
        'stage_id' => dep.stage.id,
        'project_id' => dep.stage.project.id,
        'deployment[task]' => task,
        'deployment[description]' =>'deployed by scmer',
        'deployment[override_locking]' =>'',
        'deployment[prompt_config][tag_name]' => tag_name

    }

    f = open('http://bv14:3000/scmer/create?' + h.to_query)
#    return render :inline => "<%= debug f %>"
  end

   def create
     return render :inline => "teting scmer/create"
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

end

__END__

--- !map:HashWithIndifferentAccess
commit: Start deployment
project_id: "91"
authenticity_token: tHZtF2llC6mh8ct7GiY29tScTKBIvyZA4n/aG/nCrbI=
action: create
stage_id: "282"
controller: deployments
deployment: !map:HashWithIndifferentAccess
  task: FHTEST:TESTupdates
  description: dfaf
  override_locking: ""
  prompt_config: !map:HashWithIndifferentAccess
    tag_name: dfaf