require "sinatra"
require "pry"

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get '/' do

  if session[:computer_score].nil?
    computer_score = 0
  else
    computer_score = session[:computer_score].to_i
  end

  if session[:player_score].nil?
    player_score = 0
  else
    player_score = session[:player_score].to_i
  end
  visit_count = session[:visit_count]
  computer_choice = session[:computer_choice]
  player_choice = session[:player_choice]
  game_statement = session[:game_statement]

  if ( computer_score == 2 || player_score == 2 )
    redirect '/gameover'
  end

  erb :index, locals: {
                        visit_count: visit_count,
                        player_choice: player_choice,
                        computer_choice: computer_choice,
                        game_statement: session[:game_statement],
                        player_score: session[:player_score],
                        computer_score: session[:computer_score]
                      }
end

post '/'  do

  session[:player_choice] = params[:choice]

  session[:computer_score].nil? ? computer_score = 0 : computer_score = session[:computer_score]
  session[:player_score].nil? ? player_score = 0 : player_score = session[:player_score]

  computer_choice = ["Rock","Paper","Scissors"].sample
  session[:computer_choice] = computer_choice

  player_choice = session[:player_choice]

  player_wins = "#{player_choice} beats #{computer_choice}, Player wins the round."
  computer_wins = "#{computer_choice} beats #{player_choice}, Computer wins the round."
  tie = "Tie, choose again."

  session[:game_statement] = ""



  if session[:visit_count].nil?
    visit_count = 1
  else
    visit_count = session[:visit_count].to_i
  end
  session[:visit_count] = visit_count + 1

  if player_choice == 'Rock' && computer_choice == 'Scissors' || player_choice == 'Paper' && computer_choice == 'Rock' || player_choice == 'Scissors' && computer_choice == 'Paper'
      session[:game_statement] = player_wins
      player_score += 1
  elsif computer_choice == 'Rock' && player_choice == 'Scissors' || computer_choice == 'Paper' && player_choice == 'Rock' || computer_choice == 'Scissors' && player_choice == 'Paper'
      session[:game_statement] = computer_wins
      computer_score +=1
  else
      session[:game_statement] = tie
  end

  session[:player_score] = player_score
  session[:computer_score] = computer_score

  redirect '/'
end

get '/reset' do
  session[:computer_score] = 0
  session[:player_score] = 0

  redirect '/'
end

post '/gameover' do
  session[:player_score]
  session[:computer_score]
  session[:win_statement] = ""


  erb :gameover, locals: {
                        player_score: session[:player_score],
                        computer_score: session[:computer_score]
                      }
  redirect "/reset"
end

get '/gameover' do

  if session[:player_score] == 2
    session[:win_statement] = "Player wins the game!"
  else session[:computer_score] == 2
    session[:win_statement] = "Computer wins the game!"
  end
  erb :gameover, locals: {
                        player_score: session[:player_score],
                        computer_score: session[:computer_score]
                      }
end

# session[:outcome] = rps_logic(session[:player_choice])
