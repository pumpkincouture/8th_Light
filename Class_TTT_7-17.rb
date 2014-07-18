#Here's what we want.

#A breakdown of classes. Still a simple loop, but the classes should start to interact with each other.

#Here's what we want.

#A breakdown of classes. Still a simple loop, but the classes should start to interact with each other.

class Game
    
    attr_accessor :board, :no_space
    
    
    def initialize(board=board, no_space=8)
        @no_space=no_space
        
         @board={"1"=>"1", "2"=>"2", "3"=>"3", "4"=>"4", "5"=>"5", 
    "6"=>"6", "7"=>"7", "8"=>"8", "9"=>"9"}
    end
    
    @@no_space=8
    
    def welcome
        puts "Welcome to a Simpler Tic Tac Toe. The computer will go first."
      @board["5"]="X"
      puts "The computer chose space number 5."
      display_board
      @@no_space -= 1
    end
        
    def display_board
    puts "#{@board["1"]} | #{@board["2"]} | #{@board["3"]}"
    puts "---------"
    puts "#{@board["4"]} | #{@board["5"]} | #{@board["6"]}"
    puts "---------"
    puts "#{@board["7"]} | #{@board["8"]} | #{@board["9"]}"
    end

    def game_over?
        # puts @@no_space
        @@no_space<=0
    end
    
 end
 
 class Players < Game
     
     
     def computer_turn
      move=[]
    
      @board.each do |k, v|
        move << k if @board[k]!= "X" && @board[k]!="O"
      end
      
    move.map!(&:to_s)
    #use rand
    pick_one=move[-1]
    @board[pick_one]="X"
    display_board
    puts "Computer chose space #{pick_one}."
    @@no_space -= 1
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
          @@no_space -= 1
        #   puts @@no_space
        end
    end

    def try_again
    puts "I'm sorry, that is not a valid move, please try again."
    user_turn
    end

end

     

new_game=Game.new
player=Players.new
player.welcome

# player.user_turn
# new_game.game_over?
# player.game_over?

until new_game.game_over?
player.user_turn
player.computer_turn
end
