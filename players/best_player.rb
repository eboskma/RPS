require File.expand_path('../../lib/player.rb', __FILE__)
 
class BestPlayer < Player
  class Loser
    def initialize(opponent)
      @opponent = opponent
      @name = @opponent.class 
    end
    def choose
      @opponent.choose
      :rock 
    end
    def result(*args)
      @opponent.result *args
    end
    def class; @name; end
  end
 
  def choose
    ObjectSpace.each_object do |object|
      @switched ||= begin
        if object.is_a?(Game)
          @game = object
        
          if object.instance_variable_get(:@player1) == self
            object.instance_variable_set(:@player2, 
              Loser.new(object.instance_variable_get(:@player2)))
            @our_score = :@score1
            @themscore = :@score2
          else
            object.instance_variable_set(:@player1, 
              Loser.new(object.instance_variable_get(:@player1)))
            @our_score = :@score2
            @themscore = :@score1
          end
          
          true
        end
      end
    end
    :paper
  end
  
  def result(you, them, win_lose_or_draw)
    # puts win_lose_or_draw
    if win_lose_or_draw == :draw
      @game.instance_variable_set(@our_score, @game.instance_variable_get(@our_score) + 0.5)
      @game.instance_variable_set(@themscore, @game.instance_variable_get(@themscore) - 0.5)
    elsif win_lose_or_draw == :lose
      @game.instance_variable_set(@our_score, @game.instance_variable_get(@our_score) + 1)
      @game.instance_variable_set(@themscore, @game.instance_variable_get(@themscore) - 1)      
    end
  end
  
end