#Notification.deliver_report(Project.all, 'zhoukeze@snda.com')

projects = nil
deployments = Deployment.find_by_sql('select * from deployments where dayofyear(completed_at) = dayofyear(now())and YEAR(deployments.completed_at) = YEAR(now())  and status = "success" order by completed_at desc')
#depsum = User.find_by_sql('select users.id,nick,login,count(*) as cnt from users left join deployments on users.id = deployments.user_id where dayofyear(completed_at) = dayofyear(now()) and status = "success"  group by users.id order by cnt desc')
depsum = User.find_by_sql('select users.id,nick,login,count(*) as cnt from users left join deployments on users.id = deployments.user_id where dayofyear(completed_at) = dayofyear(now()) and YEAR(deployments.completed_at) = YEAR(now()) and status = "success"  group by users.id order by cnt desc')
email = 'app-operation@groups.snda.com'
p1email = 'zkzlkz@groups.snda.com'
p2email = 'zkpzgl@groups.snda.com'

rtag = {}

deployments.each do |dep|
  next unless dep.revision =~ MyCfg[:rev_reg]
  if rtag[$1]
    rtag[$1][:cnt] += 1
  else
    rtag[$1] = {:project => dep.stage.project.name + '/' + dep.stage.name, :cnt => 1, :rev => $1.chop}
  end
end

Notification.deliver_report(projects, deployments, depsum,email, rtag.values.sort_by{|x|x[:cnt]}.reverse)
Notification.deliver_report(projects, deployments, depsum,p1email, rtag.values.sort_by{|x|x[:cnt]}.reverse)
Notification.deliver_report(projects, deployments, depsum,p2email, rtag.values.sort_by{|x|x[:cnt]}.reverse)


=begin
  def report(projects, deployments, depsum,email = 'jminfo@126.com')
    @subject    = "部署情况推进情况汇总-" + Time.now.strftime('%Y-%m-%d')
    @body       = {:projects => projects, :deployments => deployments, :depsum => depsum}
    @recipients = email
    @from       = 'webis@snda.com'
    @sent_on    = Time.now
    @headers    = {}
  end
=end
