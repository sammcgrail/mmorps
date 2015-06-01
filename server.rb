require "sinatra"

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

def choice(input)
  p_score = 0
  c_score = 0

  while p_score < 3 || c_score < 3
    puts "\nPlayer Score: #{p_score}, Computer Score: #{c_score}"
    print 'Please choose rock (r), paper (p), or scissors (s):'
    player = input
    choices_p = { 'r' => 'rock', 'p' => 'paper', 's' => 'scissors'}
    choices_c = { 0 => 'rock', 1 => 'paper', 2 => 'scissors'}
    comp = rand(3)
    if player == 'Rock' || player == 'Paper' || player == 'Scissors'
        comp = choices_c[comp]
            puts "Player chose #{player}."
            puts "Computer chose #{comp}."
            player_wins = "#{player} beats #{comp}, Player wins the round."
            comp_wins = "#{comp} beats #{player}, Computer wins the round."
            tie = "Tie, choose again."
        if player == 'Rock' && comp == 'Scissors' || player == 'Paper' && comp == 'Rock' || player == 'Scissors' && comp == 'Paper'
            puts player_wins
            p_score += 1
        elsif comp == 'Rock' && player == 'Scissors' || comp == 'Paper' && player == 'Rock' || comp == 'Scissors' && player == 'Paper'
            puts comp_wins
            c_score +=1
        else
            puts tie
        end
    end
    if p_score == 3
        puts "\nPlayer wins the game!"
    else c_score == 3
        puts "\nComputer wins the game!"
    end
  end
end

choice([params['value']])

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
