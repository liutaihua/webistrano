Notification.deliver_report(nil, Deployment.find_by_sql('select * from deployments where dayofyear(completed_at) = dayofyear(now()) and status = "success" order by completed_at desc'),User.find_by_sql('select users.id,login,count(*) as cnt from users left join deployments on users.id = deployments.user_id where dayofyear(completed_at) = dayofyear(now()) and status = "success"  group by users.id order by cnt desc'), 'foo@bar.com')
