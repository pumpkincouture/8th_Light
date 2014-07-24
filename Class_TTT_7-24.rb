class Game
    attr_reader :no_space, :board, :computer_player, :human_player
    def initialize(board, computer_player, human_player)
     @board = board
     @computer_player = computer_player
     @human_player = human_player
     end
     
     @@no_space=9
     
    def decrease_space
    return "The game has ended!" if game_over?
    @@no_space -= 1
    puts @@no_space
    end
    
    def game_over?
    @@no_space <= 0
    end
    
    def welcome
     puts "Welcome to a Simpler Tic Tac Toe. The computer will go first."
     @board.board["5"]="X"
     puts "The computer chose space number 5."
     @board.display_board
     self.decrease_space
    end
end

class Board

    attr_reader :new_game, :computer_player, :human_player, :user_interface, :board
    
    def initialize(new_game, computer_player, human_player, user_interface)
      @new_game=new_game
      @computer_player= computer_player
      @human_player= human_player
      @ui= user_interface
      
      @board={"1"=>"1", "2"=>"2", "3"=>"3", "4"=>"4", "5"=>"5", 
    "6"=>"6", "7"=>"7", "8"=>"8", "9"=>"9"}
    end
    
    def human_move(answer)
        if @board[answer] !~ /\d+/
        @ui.user_error
        elsif @board[answer].include? "X" || "O" 
        @ui.user_error
        else
        board[answer]="O"
        @ui.choice
        self.display_board
        @new_game.decrease_space
        # self.computer_move
        end
    end
    
    def computer_move(answer)
        @board[answer]="X"
        puts "Computer chose space number #{answer}"
        self.display_board
        @new_game.decrease_space
        # @human_player.user_turn
        
    end
      
    def display_board
    puts "#{@board["1"]} | #{@board["2"]} | #{@board["3"]}"
    puts "---------"
    puts "#{@board["4"]} | #{@board["5"]} | #{@board["6"]}"
    puts "---------"
    puts "#{@board["7"]} | #{@board["8"]} | #{@board["9"]}"
    end
    
end
 
  class UserInterface
      
    def initialize(human_player)
        @human_player=human_player
    end

    def user_prompt
    puts "Please choose a number for your 'O'."
    end
    
    def choice
    puts "You chose space number #{@human_player.human_move}."
    end
    
    def user_error
    puts "I'm sorry, that is not a valid move, please try again."
    @human_player.user_turn
    end
end
 
 
 class ComputerPlayer

  attr_reader :board, :computer_move

  def initialize(board)
    @board = board
    @computer_move=computer_move
  end


  def computer_turn(board)
        move=[]
        board.board.each do |k, v|
        move << k if board.board[k]!= "X" && board.board[k]!="O"
        end
        move.map!(&:to_s)
        @computer_move=move[-1]
    end


end

class HumanPlayer

  attr_reader :human_move, :board, :user_interface

  def initialize(board, user_interface)
    @human_move=human_move
    @board=board
    @ui = user_interface
  end

    def user_turn
    @ui.user_prompt
    @human_move=gets.chomp
    end
end


user_interface= UserInterface.new(board, human_player)
computer_player= ComputerPlayer.new(board)
human_player= HumanPlayer.new(board, user_interface)
board= Board.new(new_game, computer_player, human_player, user_interface)


new_game= Game.new(board, computer_player, human_player)

until new_game.game_over?
human_player.user_turn
board.human_move(human_player.human_move)
computer_player.computer_turn(board)
board.computer_move(computer_player.computer_move)
end












