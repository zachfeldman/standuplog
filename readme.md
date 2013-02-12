#H2 StandUpLog
#H4 What did I do yesterday?

StandUpLog is a short Ruby script meant to e-mail you a summary of the code you committed yesterday. To use it:

1. [Sign up](http://sendgrid.com/) for a SendGrid developer account.
2. Set the following environmental variables:

export SENDGRID_USERNAME=[your sendgrid username]
export SENDGRID_API_KEY=[your sendgrid password]
export STANDUPLOG_EMAIL=[email to send the log to]
export STANDUPLOG_PATH=[path of your git repo]

Have fun, feel free to fork and improve this is super basic.

