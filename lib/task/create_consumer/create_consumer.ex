defmodule Mix.Tasks.CreateConsumer do
  use Mix.Task
  @prefix Application.compile_env(:layeredex, :prefix, SomeModuleName)

  def run(["-h"]) do
    """
    Example: mix create_consumer --p charger/telegram_bot_disconnected
    """
    |> IO.inspect()
  end

  def run(params) do
    params
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> {a, b} end)
    |> Map.new()
    |> create_consumer()
  end

  defp create_consumer(params) do
    create_event_consumer_file(params)
    create_event_consumer_test_file(params)

    System.cmd("mix", ["format"])
  end

  defp create_event_consumer_file(%{"--p" => path}) do
    {folders, [name]} = String.split(path, "/") |> Enum.split(-1)
    folder = Enum.join(folders, "/")

    content = Mix.Tasks.ConsumerTemplate.template(path: path, prefix: @prefix)

    File.write(
      get_consumer_path(folder, name),
      content
    )
  end

  defp get_consumer_path(folder, name) do
    app_dir = File.cwd!()
    File.mkdir("#{app_dir}/lib/#{folder}")
    File.mkdir("#{app_dir}/lib/#{folder}/#{name}")

    Path.join([
      app_dir,
      "lib",
      folder,
      name,
      "#{name}_event_consumer.ex"
    ])
  end

  defp create_event_consumer_test_file(%{"--p" => path}) do
    {folders, [name]} = String.split(path, "/") |> Enum.split(-1)
    folder = Enum.join(folders, "/")
    
    content = Mix.Tasks.ConsumerTestTemplate.template(path: path)

    File.write(
      get_consumer_test_path(folder, name),
      content
    )
  end

  defp get_consumer_test_path(folder, name) do
    app_dir = File.cwd!()
    File.mkdir("#{app_dir}/lib/#{folder}")
    File.mkdir("#{app_dir}/lib/#{folder}/#{name}")

    Path.join([
      app_dir,
      "lib",
      folder,
      name,
      "#{name}_event_consumer_test.exs"
    ])
  end
end
