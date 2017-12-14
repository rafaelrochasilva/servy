defmodule Servy.SensorServer do
  use GenServer
  @name :sensor_server

  alias Servy.VideoCam

  # Client Interface

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data)
  end

  # Server Callbacks

  def init(:ok) do
    initial_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:ok, initial_state}
  end

  def handle_info(:refresh, _state) do
    IO.puts "Refreshing the cache..."
    new_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:noreply, new_state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, :timer.seconds(5))
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  def run_tasks_to_get_sensor_data do
    IO.puts "Running tasks to get sensor data..."

    pid = Task.async(fn -> Servy.Tracker.get_location_str("bigfoot") end)

    snapshots =
      ["cam1", "cam2", "cam3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await(&1))

    location = Task.await(pid)

    %{snapshots: snapshots, location: location}
  end
end
