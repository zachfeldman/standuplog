require 'open-uri'
require 'json'
require 'uri'

#setup git log stuff
today = Time.now.strftime('%A')

if today == "Monday"
	log = `cd #{ENV['STANDUPLOG_PATH']} && git log --author=#{ENV['STANDUPLOG_AUTHOR']} --after={3.days.ago} --before={2.days.ago} --pretty=oneline`
else
	log = `cd #{ENV['STANDUPLOG_PATH']} && git log --author=#{ENV['STANDUPLOG_AUTHOR']} --after={1.days.ago} --pretty=oneline`
end

commits = log.split("\n")
commits_pretty = ""
commits.each do |commit|
	commit_word_array = commit.split(" ")
	commit_id = commit_word_array.first[0..7]
	commit_word_array.delete_at(0)
	final_message = "#{commit_id} - #{commit_word_array.join(" ")}\n\n"
	commits_pretty = commits_pretty + final_message
end
	
puts commits_pretty

#setup the email
api_user = ENV['SENDGRID_USERNAME'] 
api_key = ENV['SENDGRID_API_KEY']
to = ENV['STANDUPLOG_EMAIL']
to_name = "Zach Feldman"
subject = "Day Before Git Log for #{Time.now.strftime('%m-%d-%Y')}"
text = commits_pretty
from = "no-reply@standups.com"

#send it using SendGrid RESTful API
if !log.empty?
	request = "https://sendgrid.com/api/mail.send.json?api_user=#{api_user}&api_key=#{api_key}&to=#{to}&toname=#{to_name}&subject=#{subject}&text=#{text}&from=#{from}"
	html = open(URI.escape(request)).read
	response = JSON.parse(html)
	if response["message"] == "success"
		puts "Git log sent."
	end
end
