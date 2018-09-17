defmodule TextClient.Prompter do
  alias TextClient.State

  def accept_move(game = %State{}) do
    IO.gets("Guess a letter: ")
    |> check_input(game)
  end

  defp check_input({:error, reason}, _) do
    IO.puts("game ended #{reason}")
    exit(:normal)
  end

  defp check_input(:eof, _) do
    IO.puts("what, too hard?")
    exit(:normal)
  end

  defp check_input(input, game) do
    input = String.trim(input)
    cond do
      input =~ ~r/\A[a-z]\z/ ->
        Map.put(game, :guess, input)

      true ->
        IO.puts "try a letter, dumbass"
        accept_move(game)
    end
  end
end
