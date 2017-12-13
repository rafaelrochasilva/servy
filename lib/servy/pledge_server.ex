defmodule Servy.PledgeServer do
  use GenServer
  @moduledoc """
  Handles the amout of Pledges for given names
  """

  defmodule State do
    defstruct total: 0, pledges: []
  end

  @type pledge :: {binary, number}
  @name :pledge_server

  # Client

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  @spec create_pledge(binary, number) :: [pledge]
  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  @spec recent_pledges() :: binary
  def recent_pledges do
    GenServer.call(@name, :recent_pledges)
  end

  @spec total_pledged() :: number
  def total_pledged do
    GenServer.call(@name, :total_pledged)
  end

  # Server

  def init(:ok) do
    {pledges, total} = fetch_recent_state_from_services()
    state = %State{pledges: pledges, total: total}
    {:ok, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    pledges =
      [{name, amount} | state.pledges]
      |> Enum.take(3)

    new_total = state.total + amount

    new_state = %State{pledges: pledges, total: new_total}

    {:reply, id, new_state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call(:total_pledged, _from, state) do
    {:reply, state.total, state}
  end

  def handle_info(message, state) do
    IO.puts "Unexpected message: #{inspect message}"
    {:noreply, state}
  end

  # Simulates an add to a externall service
  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  # Simulates a fetch from an external service
  defp fetch_recent_state_from_services do
    {[{"wilma", 35}, {"mike", 10}], 45}
  end
end
