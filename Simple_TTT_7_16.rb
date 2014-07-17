#Here's what we want.

#We want the game to keep taking spaces until there are no longer spaces to be taken. When there are no more spaces, it will be game_over.

#Next iteration: we want the game to recognize when it has won. It's either won, or there are no spaces left. Method that checks wins.



class Game

 attr_reader :board, :comp_moves, :human_moves
  def initialize(play_game=false)
    @no_space=8

    @board={"1"=>"1", "2"=>"2", "3"=>"3", "4"=>"4", "5"=>"5", 
    "6"=>"6", "7"=>"7", "8"=>"8", "9"=>"9"}

  def display_board
    puts "#{@board["1"]} | #{@board["2"]} | #{@board["3"]}"
    puts "---------"
    puts "#{@board["4"]} | #{@board["5"]} | #{@board["6"]}"
    puts "---------"
    puts "#{@board["7"]} | #{@board["8"]} | #{@board["9"]}"
    end

    puts "Welcome to a Simpler Tic Tac Toe. The computer will goes first."
      @board["5"]="X"
      
      #combinations used for tests
      
    #   @board["1"]="X"
    #   @board["2"]="O"
    #   @board["3"]="X"
    #   @board["4"]="O"
    #   @board["5"]="X"
    #   @board["6"]="O"
    #   @board["7"]="X"
    #   @board["8"]="O"
    #   @board["9"]="X"

      puts "The computer chose space number 5"
      display_board
      @no_space -= 1
      # print @no_space
  end


def game_over?
    @no_space<=0
    
    #Evaluates to true if all spaces are taken. 
    
end


# def count_spaces
#   @board.each do |k,v|
#       if @board[k]== "X" || @board[k]== "O"
#           @no_space << k
#       end
#   end
#   print @no_space
# end

def play_game
    return "Game over" if game_over?
    user_turn
    computer_turn
    # count_spaces
end


def computer_turn
    move=[]
    
    @board.each do |k, v|
        move << k if @board[k]!= "X" && @board[k]!="O"
    end
    move.map!(&:to_s)
    pick_one=move[-1]
    @board[pick_one]="X"
    display_board
    puts "Computer chose space #{pick_one}."
    @no_space -= 1
    
end

def user_turn
      puts "Please choose a number for your 'O'."
      
      answer=gets.chomp
        if @board[answer] !~ /\d+/
          try_again
        elsif @board[answer].include? "X" || "O" 
          try_again
        else
          @board[answer]="O"
          display_board
          puts "You've placed an 'O' in number #{answer}."
          @no_space -= 1
          puts @no_space
        end
end

def try_again
  puts "I'm sorry, that is not a valid move, please try again."
      user_turn
end


end

new_game=Game.new(true)

until new_game.game_over?
new_game.play_game
end
