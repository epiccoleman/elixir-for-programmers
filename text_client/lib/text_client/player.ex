defmodule TextClient.Player do

  alias TextClient.{State, Summary, Prompter, Mover}

  # won, lost, good guess, bad guess, already used letter, init
  def play(game = %State{ tally: %{ game_state: :won}}) do
    exit_with_message("You win! \nThe word was \"#{game.tally.letters}\"")
  end

  def play(%State{ tally: %{ game_state: :lost}}) do
    exit_with_message("You lose")
  end

  def play(game = %State{ tally: %{ game_state: :good_guess}}) do
    continue_with_message(game, "Good guess")
  end

  def play(game = %State{ tally: %{ game_state: :bad_guess}}) do
    continue_with_message(game, "That letter isn't in the word")
  end

  def play(game = %State{}) do
    continue(game)
  end

  def continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  defp continue_with_message(game, message) do
    IO.puts(message)
    continue(game)
  end

  defp exit_with_message(message) do
    IO.puts(message)
    exit(:normal)
  end
end
