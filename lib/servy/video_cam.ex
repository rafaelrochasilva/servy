defmodule Servy.VideoCam do

  def get_snapshot(camera) do
    #Simulates a GET request to an external API
    :timer.sleep(1000)

    "#{camera}-snapshot.jpg"
  end
end
