class Notification < ActionMailer::Base
  
  @@webistrano_sender_address = 'AutoDeployer'
  
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
  
  def report(projects, deployments, depsum,email = 'jminfo@126.com')
    @subject    = "部署情况推进情况汇总-" + Time.now.strftime('%Y-%m-%d')
    @body       = {:projects => projects, :deployments => deployments, :depsum => depsum}
    @recipients = email
    @from       = 'webis@snda.com'
    @sent_on    = Time.now
    @headers    = {}
  end

end
