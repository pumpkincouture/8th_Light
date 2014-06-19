class Game
        
attr_accessor :board, :comp_winning_combos, :human_winning_combos, :comp_moves, :human_moves
    
        
def initialize(user, computer)
  #Initialize the variables, this will launch the game into first_turn
        @user="O"
        @computer="X"
        @comp_moves=[]
        @human_moves=[]
        
        @board={"1"=>"1", "2"=>"2", "3"=>"3", "4"=>"4", "5"=>"5", 
        "6"=>"6", "7"=>"7", "8"=>"8", "9"=>"9"}
        
        @comp_winning_combos=[[1,2,3], [4,5,6], [7,8,9],
        [1,4,7], [2,5,8], [3,6,9], 
        [1,5,9], [3,5,7]]
        
        @human_winning_combos=[[1,2,3], [4,5,6], [7,8,9],
        [1,4,7], [2,5,8], [3,6,9], 
        [1,5,9], [3,5,7]]
        
        first_turn
end


def display_board
  #This method prints the board
    puts "#{@board["1"]} | #{@board["2"]} | #{@board["3"]}"
    puts "---------"
    puts "#{@board["4"]} | #{@board["5"]} | #{@board["6"]}"
    puts "---------"
    puts "#{@board["7"]} | #{@board["8"]} | #{@board["9"]}"
end


def first_turn
  #This places a 5 in the middle so the computer takes a dominant position
  puts "Welcome to Tic Tac Toe! The computer will be 'X' and will go first."
    
    @board["5"]="X"
    display_board
    puts "The computer has chosen space number 5."
      @comp_moves << 5
      @human_winning_combos.each do|sub_array|
        if sub_array.include? 5
           sub_array.clear
        end
      end
    user_turn
end
        
        
def user_turn
  #This method asks the user for a number. That string is then evaluated as having a number inside of it. If not, it throws an error. 
  #If that space is already taken taken, it throws an error. 

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
        end

      #this pushes the moves to the human's moves array. Everytime the human makes a move, the number will be pushed to this array.
      @human_moves << answer.to_i

      #this finds the choice the human chose within the comp winning combos array and deletes the entire array containing that number.
      @comp_winning_combos.each do|sub_array|
        if sub_array.include? answer.to_i
           sub_array.clear
        end
      end
end

        
def try_again
  puts "I'm sorry, that is not a valid move, please try again."
      user_turn
end
      

def second_turn
  #The second move of the computer in order to win should be to capture one of the board's corners. This method picks a corner.
  comp=[]
      
    @comp_winning_combos.each do|sub_array|
      if sub_array.include? 7 || 3
        comp << 1
      else 
        comp << -1
      end
    end
                
      if comp[-1]==-1
        choice="1"
      else comp[-1]!= -1
        choice="3"
      end
                
    @board[choice]="X"
    display_board
    puts "The computer has chosen space number #{choice}."
     

      #method pushes moves to computer's moves array. Everytime the computer makes a move, the number will be pushed to this array.
      @comp_moves << choice.to_i
       
      #this finds the choice that the computer picks within the human's winning combos array, and deletes the array containing that number. 
      @human_winning_combos.each do|sub_array|
        if sub_array.include? choice.to_i
           sub_array.clear
        end
      end
  user_turn
end

      
def third_turn
  #This method analyzes the computer's third turn. This is where the possibility to win exists.
  #This method is called outside of the Class- if the computer wins, the game ends. If not, it goes to block, or it goes into optimal_move.
  if win_one
  else
    block_one
  end
end


def win_one
  #This method compares the winning moves left for the computer to its current moves array. It isolates the unique number and places it on the board. 
  first_num=@comp_moves[0]
  second_num=@comp_moves[1]
     
      @comp_winning_combos.each do|sub_array|
        if sub_array.include?(first_num) && sub_array.include?(second_num)
            if sub_array.length==3
               sub_array.delete(first_num)
               sub_array.delete(second_num)
               @comp_moves << sub_array[0]
           else
               sub_array.length==2
            end
        end
      end
        
    if @comp_moves.length==3
      @comp_moves.map!(&:to_s)
      win_num=@comp_moves[-1]
      @board[win_num]="X"
      display_board
      print "Computer wins!"
      return true
    else
      return false
    end
end


def block_one
  #This method compares the human's winning moves to the human's current position array. 
  #If the method finds a winning combo with 2 of the human move numbers, it isolates the number so that the human can't choose that number and win.
    
  numbers_to_block=0
  first_num=@human_moves[0]
  other_num=@human_moves[-1]
  
    @human_winning_combos.each do|sub_array|
      if sub_array.include?(first_num) && sub_array.include?(other_num)
         sub_array.delete(first_num)
         sub_array.delete(other_num)
         numbers_to_block += sub_array[0]
      end
    end   

      if numbers_to_block > 0
         @board[numbers_to_block.to_s]="X"
         display_board
         puts "Computer blocked you in number #{numbers_to_block}."
         @comp_moves << numbers_to_block
         
         #the isolated number is deleted along with the other two numbers from the human winning combos. The user_second method is called to collect user_input.
         @human_winning_combos.each do|sub_array|
            if sub_array.include? numbers_to_block.to_i
               sub_array.clear
            end
          end
          user_second
      else
        #if the computer cannot evaluate a block move (aka, the user does not have 2 out of 3 numbers in a winning combo), it will call optimal_move.
        optimal_move
      end
end


def optimal_move
    #This method creates a lose-lose situation for the human- the computer will set up two possible winning combinations on the board.
    #No matter which number the human chooses, the computer will win.
    #The method is essentially a frequency hash- it tracks which numbers show up the most in the computer's winning combinations. It picks the number
    #which shows up the most frequently. 

  numbers=[]
  frequencies=Hash.new(0)
    
    
    @comp_winning_combos.each do |sub_array|
      sub_array.each do |i|
        frequencies[i.to_s]+=1
      end
    end
      

    frequencies.each do |k,v|
      if frequencies[k]>1
        numbers << k
      else 
        numbers << k
      end
    end

  random_number=numbers[0] unless numbers[0]==nil

  @board[random_number]="X"
    display_board
    puts "The computer chose number #{random_number}."
    @comp_moves << random_number.to_i

    @human_winning_combos.each do|sub_array|
      if sub_array.include? random_number.to_i
         sub_array.clear
      end
    end
    #Computer will pick an optimal move and then call user_second to get user_input. This will move it to the fourth_turn.
    user_second
end


def user_second
  #Attached to the third_move. If computer blocks or chooses optimal move, this method will be prompted, placing the 'X' on the board, and triggering fourth_turn.
  puts "Please choose a number for your 'O'."
      
      answer=gets.chomp
        if @board[answer] !~ /\d+/
          error
        elsif @board[answer].include? "X" || "O" 
          try_again
        else
          @board[answer]="O"
          display_board
          puts "You've placed an 'O' in number #{answer}."      
          @human_moves << answer.to_i
          @comp_winning_combos.each do|sub_array|
            if sub_array.include? answer.to_i
               sub_array.clear
            end
          end
          fourth_turn
        end
end    

  
def error
   puts "I'm sorry, that is not a valid move, please try again."
   user_second
end


def fourth_turn
  #This method analyzes the computer's fourth turn and possibility to win.
  #This method is not called outside of the Class so that it is not triggered if third_turn proves to be a win.
    if win_two
    else
        block_two
    end
end


def win_two
  #This method is similar to the win_one method- but it analyzes each comp move potential pair. i.e, first number with the second, second with the third.
  #This takes into account all of the computer's current spots on the board and how they relate to winning combinations.

    first_num=@comp_moves[0]
    second_num=@comp_moves[1]
    other_num=@comp_moves[-1]
    
    winning_numbers=[]
     
    @comp_winning_combos.each do|sub_array|
      if sub_array.include?(first_num) && sub_array.include?(other_num)
           sub_array.delete(first_num)
           sub_array.delete(other_num)
           winning_numbers << sub_array[0]

      elsif sub_array.include?(second_num) && sub_array.include?(other_num)
           sub_array.delete(second_num)
           sub_array.delete(other_num)
           winning_numbers << sub_array[0]

      else winning_numbers.length==0
      end
    end

    #Checks to see if any numbers were indeed added to the array. 
    if winning_numbers.length !=0
        string=winning_numbers[0].to_s
        @board[string]="X"
        display_board
        puts "The Computer wins!"
        @comp_moves << winning_numbers[0]
    else
        return false
    end
end


def block_two

  #This method is similar to block_one, but picks win over block when the two possibilities arise simultaneously.

    numbers_to_block=0
    first_num=@human_moves[0]
    other_num=@human_moves[-1]
    second_num=@human_moves[1]
    
    
    @human_winning_combos.each do |sub_array|
        if sub_array.include?(second_num) && sub_array.include?(other_num)
            if sub_array.length==3
               sub_array.delete(other_num)
               sub_array.delete(second_num)
               numbers_to_block += sub_array[0]
            else
               sub_array.length==2
            end
        end
    end
    
      
    if numbers_to_block > 0 && numbers_to_block!=@comp_moves[-1]
        @board[numbers_to_block.to_s]="X"
        display_board
        puts "Computer blocked you in number #{numbers_to_block}!"
        @comp_moves << numbers_to_block
           @human_winning_combos.each do|sub_array|
          if sub_array.include? numbers_to_block.to_i
            sub_array.clear
          end
        end
        user_last
    
    #If no block is found, the computer goes to next_move
    else
        next_move
      end
end


def next_move
  #This method is attached to fourth_turn but works similarly to optimal_move. Once it has a number it will trigger user_last for input.

    numbers=[]
    frequencies=Hash.new(0)
    
    
      @comp_winning_combos.each do |sub_array|
          sub_array.each do |i|
             frequencies[i.to_s]+=1
          end
      end
      

      frequencies.each do |k,v|
        if frequencies[k]>1
           numbers << k
        else 
           numbers << k
        end
      end

random_number=numbers[0] unless numbers[0]==nil

   @board[random_number]="X"
    display_board
    puts "The computer chose number #{random_number}."
    @comp_moves << random_number.to_i

    @human_winning_combos.each do|sub_array|
      if sub_array.include? random_number.to_i
        sub_array.clear
      end
    end
      user_last
end

def user_last
  
  puts "Please choose a number for your 'O'."
      
      answer=gets.chomp
        if @board[answer] !~ /\d+/
          user_error
        elsif @board[answer].include? "X" || "O" 
          try_again
        else
          @board[answer]="O"
          display_board
          puts "You've placed an 'O' in number #{answer}."      
          @human_moves << answer.to_i
          
          @comp_winning_combos.each do|sub_array|
            if sub_array.include? answer.to_i
               sub_array.clear
            end
          end
          fifth_turn
        end
 end 

def user_error
    puts "I'm sorry, that space is taken, please try another number."
    user_last
end


def fifth_turn
    #This method analyzes the computer's fifth turn and possibility to win, as well as whether or not it's a Cat's Game.

    if last_win
    else
    random_move
    end
end


def last_win

    first_num=@comp_moves[0]
    second_num=@comp_moves[1]
    other_num=@comp_moves[-1]
    
    winning_numbers=[]
    
      @comp_winning_combos.each do|sub_array|
          if sub_array.include? (first_num) && sub_array.include? (other_num)
             sub_array.delete(first_num)
             sub_array.delete(other_num)
             winning_numbers << sub_array[0]
          end
      end
    
    if winning_numbers.length !=0
        string=winning_numbers[0].to_s
        @board[string]="X"
        display_board
        puts "The Computer wins!"
        return true
    else
        return false
    end
end


def random_move
    #This method checks to see if the last space is empty and chooses that space. Since none of the other moves evaluated to true, this is a Cat's Game. 
    last=[]
    
    @board.each do |k,v|
        if @board[k] != "X" && @board[k] != "O"
            last << v
        else
        ;
        end
    end
    
    string=last.to_s
    @board[string]="X"
    display_board
    puts "Cat's game"

end


end

new_game=Game.new("Human", "Tic Tac Toe Warlord")
new_game.second_turn
new_game.third_turn




