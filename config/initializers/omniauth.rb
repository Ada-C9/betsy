Rails.application.config.middleware.use OmniAuth::Builder do

# ------- FOR LOCAL --------


 provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], scope: "user:email"

 # ------- FOR HEROKU --------


  # provider :github, ENV.fetch("GITHUB_CLIENT_ID"), ENV.fetch("GITHUB_CLIENT_SECRET"), scope: "user:email"

end
