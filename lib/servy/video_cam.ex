defmodule Servy.VideoCam do
  @moduledoc """
  VideoCam simulates a request to an external API, by using a timer with 1s.
  By this we can exercise how to construct its request by spawing its requests
  instead of using it in a sequencial form and reducing the total time of the
  request.
  """

  @spec get_snapshot(binary) :: binary
  def get_snapshot(camera) do
    #Simulates a GET request to an external API
    :timer.sleep(1000)

    "#{camera}-snapshot.jpg"
  end
end
