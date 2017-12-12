defmodule Servy.PledgeServer do
  @moduledoc """
  Handles the amout of Pledges for given names
  """

  @type pledge :: {binary, number}
  @process_name :pledge_server

  def start do
    pid = spawn(__MODULE__, :listen_loop, [[], 0])
    Process.register(pid, :pledge_server)
    pid
  end

  @spec create_pledge(binary, number) :: [pledge]
  def create_pledge(name, amount) do
    send @process_name, {self(), :create_pledge, name, amount}

    receive do {:response, status} -> status end
  end

  @spec recent_pledges() :: binary
  def recent_pledges do
    send @process_name, {self(), :recent_pledges}

    receive do {:response, pledges} -> pledges end
  end

  @spec total_pledged() :: number
  def total_pledged do
    send @process_name, {self(), :total_pledged}

    receive do {:total_pledged, total} -> total end
  end

  def listen_loop(state, total) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        new_state =
          [{name, amount} | state]
          |> Enum.take(3)
        IO.puts "#{total} + #{amount}"
        new_total = total + amount
        send sender, {:response, id}
        listen_loop(new_state, new_total)

      {sender, :recent_pledges} ->
        send sender, {:response, state}
        listen_loop(state, total)

      {sender, :total_pledged} ->
        send sender, {:total_pledged, total}
        listen_loop(state, total)

      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state, total)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
