class Notification < ActionMailer::Base
  
  @@webistrano_sender_address = 'AutoDeployer'
  @@email = 'aqywyyyw@groups.snda.com'
  
  def self.webistrano_sender_address=(val)
    @@webistrano_sender_address = val
  end

  def deployment(deployment, email)
    @subject    = "自动化部署通知：#{deployment.stage.project.name}/#{deployment.stage.name} 执行状态： #{deployment.status}"
    @body       = {:deployment => deployment}
    @recipients = email
    @from       = @@webistrano_sender_address
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def report(projects, deployments, depsum,email, rtag)
    @subject    = "部署情况推进情况汇总-" + Time.now.strftime('%Y-%m-%d')
    @body       = {:projects => projects, :deployments => deployments, :depsum => depsum, :rtag => rtag}
    @recipients = email
    @from       = 'webis@snda.com'
    @sent_on    = Time.now
    @headers    = {}
  end

    def wreport(rtag, email = 'aqywyyyw@groujps.snda.com')
    @subject    = "部署情况推进情况汇总(一周)-"  + 1.week.ago.strftime('%Y-%m-%d') + ' -- ' + Time.now.strftime('%Y-%m-%d')
    @body       = {:rtag => rtag}
    @recipients = email
    @from       = 'webis@snda.com'
    @sent_on    = Time.now
    @headers    = {}
  end
end
