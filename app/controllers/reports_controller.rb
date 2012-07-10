class ReportsController < ApplicationController
  skip_before_filter :login_required
  layout nil

  def daily
    @projects = nil
    @deployments = Deployment.find_by_sql('select * from deployments where dayofyear(completed_at) = dayofyear(now()) and status = "success" order by completed_at desc')
    @depsum = User.find_by_sql('select users.id,nick,login,count(*) as cnt from users left join deployments on users.id = deployments.user_id where dayofyear(completed_at) = dayofyear(now()) and YEAR(deployments.completed_at) = YEAR(now()) and status = "success"   group by users.id order by cnt desc')

    @email = 'aqywyyyw@groups.snda.com'

    @rtag = dep2tag(@deployments)
  end

  def weekly
    deployments = Deployment.find :all, :conditions => ['completed_at between ? and ? ', 1.week.ago.to_s(:db), Time.now.to_s(:db)]
    @rtag = dep2tag2(deployments)
    #Notification.deliver_wreport(@rtag.sort_by{|x|x[:project]})
#    render :text => @rtag.to_json
  end

  def month
    deployments = Deployment.find :all, :conditions => ['completed_at between ? and ? ', 1.week.ago.to_s(:db), Time.now.to_s(:db)]
    @rtag = dep2tag2(deployments)
    #Notification.deliver_wreport(@rtag.sort_by{|x|x[:project]})
#    render :text => @rtag.to_json
  end

  # GET //1
  # GET /projects/1.xml
  def show
    @projects = nil
    @dateid = params[:id]
    @deployments = Deployment.find_by_sql("select * from deployments where dayofyear(completed_at) = dayofyear(#{@dateid}) and YEAR(deployments.completed_at)  = YEAR(#{@dateid}) and status = 'success' order by completed_at desc")
    @depsum = User.find_by_sql("select users.id,nick,login,count(*) as cnt from users left join deployments on users.id = deployments.user_id where dayofyear(completed_at) = dayofyear(#{@dateid}) and YEAR(deployments.completed_at) = YEAR(#{@dateid}) and status = 'success'   group by users.id order by cnt desc")
    @email = 'aqywyyyw@groups.snda.com'

    @rtag = dep2tag(@deployments)



  end

  def gitdiff
    stage = Stage.find(params['stage'])
    depl = @stage.recent_deployments(1).first
    rev = depl.revision
    path = File.join(MyCfg[:git_root], stage.effective_configuration(MyCfg[:git_path_var]))
    tag1, tag2 = strip_build_no(rev, params['tag'])
    cmd = 'cd %s && git diff %s %s --stat' % [path, tag1, tag2]
    render :text =>"<pre>" +  `#{cmd}` +"</pre>"
  end

  private
  def strip_build_no(*arg)
    arg.map do |s|
       $1 if s =~ /(.*_\d+)(_\d+)/
    end
  end

  def dep2tag(deployments)
    rtag = {}
    deployments.each do |dep|
      next unless dep.revision =~ MyCfg[:rev_reg]
      if rtag[$1]
        rtag[$1][:cnt] += 1
      else
        rtag[$1] = {:project => dep.stage.project.name + '/' + dep.stage.name, :cnt => 1, :rev => $1.chop}
      end
    end
    rtag.values.sort_by {|t| t[:project]} #return values array
  end

  def dep2tag2(deployments)
    rtag = {}
    hz = {}
    deployments.each do |dep|
      next unless dep.revision =~ MyCfg[:rev_reg]
      prj, tsk = dep.stage.project.name , dep.stage.name
      hz[prj] ||= {}
      hz[prj][tsk] ||= {}
      k = tsk

      if rtag[k]
        rtag[k][:pcnt] += 1
        rtag[k][:revs][$1] ? rtag[k][:revs][$1] +=1 : rtag[k][:revs][$1] = 1
      else
        hz[prj][tsk] = rtag[k] = {:project => k, :pcnt => 1, :revs =>{$1 => 1}}
      end
    end
#    rtag.values.sort_by {|t| t[:project]} #return values array
    hz
  end

end
