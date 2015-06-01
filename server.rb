require "sinatra"
require "pry"

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

# def choice(params)
#   p_score = 0
#   c_score = 0
#
#   while p_score < 3 || c_score < 3
#     puts "\nPlayer Score: #{p_score}, Computer Score: #{c_score}"
#     print 'Please choose rock (r), paper (p), or scissors (s):'
#     player = input
#     choices_c = { 0 => 'rock', 1 => 'paper', 2 => 'scissors'}
#     comp = rand(3)
#     if player == 'Rock' || player == 'Paper' || player == 'Scissors'
#         comp = choices_c[comp]
#             puts "Player chose #{player}."
#             puts "Computer chose #{comp}."
#             player_wins = "#{player} beats #{comp}, Player wins the round."
#             comp_wins = "#{comp} beats #{player}, Computer wins the round."
#             tie = "Tie, choose again."
#         if player == 'Rock' && comp == 'Scissors' || player == 'Paper' && comp == 'Rock' || player == 'Scissors' && comp == 'Paper'
#             puts player_wins
#             p_score += 1
#         elsif comp == 'Rock' && player == 'Scissors' || comp == 'Paper' && player == 'Rock' || comp == 'Scissors' && player == 'Paper'
#             puts comp_wins
#             c_score +=1
#         else
#             puts tie
#         end
#     end
#     if p_score == 3
#         puts "\nPlayer wins the game!"
#     else c_score == 3
#         puts "\nComputer wins the game!"
#     end
#   end
# end




get '/' do
  #COUNTER
  if session[:visit_count].nil?
    visit_count = 1
  else
    visit_count = session[:visit_count].to_i
  end
  session[:visit_count] = visit_count + 1
  "You've visited this page #{visit_count} time(s).\n"
  #COUNTER

  session[:computer_choice] = ["rock","paper","scissors"].sample
  computer_choice = session[:computer_choice]
  player_choice = session[:player_choice]
  game_statement = session[:game_statement]
  erb :index, locals: {visit_count: visit_count, player_choice: player_choice, computer_choice: computer_choice, game_statement: game_statement}
end

post '/'  do
  session[:player_choice] = params[:choice]

  computer_score = session[:computer_score]
  player_score = session[:player_score]
  computer_choice = session[:computer_choice]
  player_choice = session[:player_choice]
  player_wins = "#{player_choice} beats #{computer_choice}, Player wins the round."
  comp_wins = "#{computer_choice} beats #{player_choice}, Computer wins the round."
  tie = "Tie, choose again."

  game_statement = ""

  if player_choice == 'Rock' && computer_choice == 'Scissors' || player_choice == 'Paper' && computer_choice == 'Rock' || player_choice == 'Scissors' && computer_choice == 'Paper'
      game_statement = player_wins
      player_score += 1
  elsif computer_choice == 'Rock' && player_choice == 'Scissors' || computer_choice == 'Paper' && player_choice == 'Rock' || computer_choice == 'Scissors' && player_choice == 'Paper'
      game_statement = comp_wins
      computer_score +=1
  else
      game_statement = tie
  end

  game_statement = session[:game_statement]

  redirect '/'
end

# session[:outcome] = rps_logic(session[:player_choice])
