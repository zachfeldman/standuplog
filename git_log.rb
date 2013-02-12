require 'open-uri'
require 'json'
require 'uri'

#setup git log stuff
today = Time.now.strftime('%A')

if today == "Monday"
	log = `cd #{ENV['STANDUPLOG_PATH']} && git log --author=#{ENV['STANDUPLOG_AUTHOR']} --after={4.days.ago} --before={3.day.ago} --pretty=oneline`
else
	log = `cd #{ENV['STANDUPLOG_PATH']} && git log --author=#{ENV['STANDUPLOG_AUTHOR']} --after={2.days.ago} --pretty=oneline`
end

puts log

#setup the email
api_user = ENV['SENDGRID_USERNAME'] 
api_key = ENV['SENDGRID_API_KEY']
to = ENV['STANDUPLOG_EMAIL']
to_name = "Zach Feldman"
subject = "Day Before Git Log for #{Time.now.strftime('%m-%d-%Y')}"
text = log
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
