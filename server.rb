require "sinatra"

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get '/' do
    if session[:visit_count].nil?
      visit_count = 1
    else
      # Everything in the session is stored as key-value strings. We need to
      # convert back to an integer before we can use this value in our app.
      visit_count = session[:visit_count].to_i
    end
    session[:visit_count] = visit_count + 1
    "You've visited this page #{visit_count} time(s).\n"

    erb :index, locals: {visit_count: visit_count}
end
