namespace :webis do
  namespace :status do 
    desc 'show abnormal status'
    task :unlock => :environment do
      Deployment.find(:all, :conditions => 'status != "success"', :limit => 10, :order =>'id desc').each do |r|
        puts "deployment id:%s\ntask:%s\ndesc:%s\ntimestamp:%s\nstatus:%s\n-----------------" % [r.id, r.read_attribute(:task), r.description, r.created_at, r.status]
      end
while true do
  print 'which id?(0 to exit):'
  s = STDIN.gets.strip
  break if s == '0'
  next if s !~ /\d+/
  d = Deployment.find(s)
  d.update_attribute(:status,'failed')
  d.stage.update_attribute(:locked, 0)
  puts "#{d.id} unlocked!"
end  
puts 'bye!'
    end
  end
end
