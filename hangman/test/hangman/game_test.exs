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
      assert game = Game.make_move(game, "x")
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

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("skookum")
    game = Game.make_move(game, "k")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    game = Game.new_game("frig")
    game = Game.make_move(game, "f")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    game = Game.make_move(game, "r")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    game = Game.make_move(game, "i")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    game = Game.make_move(game, "g")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a bad guess is recognized" do
    game = Game.new_game("chooch")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "7 bad guesses is a lost game" do
    game = Game.new_game("z")
    game = Game.make_move(game, "a")
    game = Game.make_move(game, "b")
    game = Game.make_move(game, "c")
    game = Game.make_move(game, "d")
    game = Game.make_move(game, "e")
    game = Game.make_move(game, "f")
    game = Game.make_move(game, "g")
    assert game.game_state == :lost
    assert game.turns_left == 1
  end
end
