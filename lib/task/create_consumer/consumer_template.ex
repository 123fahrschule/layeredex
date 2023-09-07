defmodule Mix.Tasks.ConsumerTemplate do
  def template(path: path, prefix: prefix) do
    [folder, name] = String.split(path, "/")

    event =
      File.read!("test/fixtures/domain-events/#{folder}/#{name}/default.json")
      |> Jason.decode!()

    event_data_keys = Map.keys(event["data"])

    keyword_results =
      Enum.reduce(event_data_keys, "", fn key, acc ->
        acc <> "#{key}: #{key},\n"
      end)

    map_params =
      Enum.reduce(event_data_keys, "", fn key, acc ->
        acc <> "\"#{key}\" => #{key},\n"
      end)

    event_description = File.read!("test/fixtures/domain-events/#{folder}/#{name}/README.md")

    [exchange, routing_key] =
      event_description
      |> String.split("\n")
      |> Enum.reject(fn x -> x == "" end)
      |> List.last()
      |> String.split("|")
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.map(fn x -> String.trim(x) end)
      |> Enum.map(fn x -> String.trim(x, "`") end)

    sub_module_name =
      name |> String.split("_") |> Enum.map(fn x -> String.capitalize(x) end) |> Enum.join()

    module_name = String.capitalize(folder)

    """
    defmodule #{module_name}.#{sub_module_name}EventConsumer do
      use #{prefix}.EventConsumer,
        routing_key: "#{routing_key}",
        remote_exchange: "#{exchange}"

      def handle(event, handler_fn \\\\\ &#{prefix}.your_application_service/1) do
        case event
             |> map_params()
             |> handler_fn.() do
          :ok -> :ok
          error -> throw({:retry, error})
        end
      end

      defp map_params(
             %{
               "type" => "#{event["type"]}",
               "data" => %{
                  #{map_params}
               }
             } = event
           ) do

        [
          #{keyword_results}
          metadata: extract_event_metadata(event)
        ]
      end
    end

    """
  end
end
