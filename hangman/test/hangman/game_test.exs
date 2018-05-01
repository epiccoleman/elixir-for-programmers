defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert game.letters |> Enum.all?(fn l -> l =~ ~r/[a-z]/ end)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, :won)
      assert { ^game, _ } = Game.make_move(game, "x")
    end
    # this assert is equivalent to this:
    # { new_game, _ } = Game.make_move(game, "x")
    # assert new_game == game
    #
    # it functions by pinning the value of game in the pattern match, which
    # means that it will only match if the first value in tuple returned by game
    # is equal to the value of game.
  end

  # test "state isn't changed for :lost game" do
  #   game = Game.new_game()
  #   |> Map.put(:game_state, :lost)

  #   assert { ^game, _ } = Game.make_move(game, "x")
  # end

end