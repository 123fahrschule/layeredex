defmodule Mix.Tasks.ConsumerTestTemplate do
  def template(path: path) do
    {folders, [name]} = String.split(path, "/") |> Enum.split(-1)
    folder = Enum.join(folders, "/")

    sub_module_name =
      name |> String.split("_") |> Enum.map(fn x -> String.capitalize(x) end) |> Enum.join()

    module_name = String.capitalize(folder)

    event =
      File.read!("test/fixtures/domain-events/#{folder}/#{name}/default.json")
      |> Jason.decode!()

    event_data_keys = Map.keys(event["data"])

    keyword_results =
      Enum.reduce(event_data_keys, "", fn key, acc ->
        acc <> "#{key}: #{key},\n"
      end)

    assert_results =
      Enum.reduce(event_data_keys, "", fn key, acc ->
        acc <> "assert #{key} == #{inspect(event["data"][key])} \n"
      end)

    """
    defmodule #{module_name}.#{sub_module_name}EventConsumerTest do
      use Support.ProcessCase, async: false, process: #{module_name}.#{sub_module_name}EventConsumer

      alias #{module_name}.#{sub_module_name}EventConsumer

      @event domain_event_fixture(
               "#{folder}",
               "#{name}"
             )

      test "maps submitted data and metadata successfully" do
        application_service = fn [
                                   #{keyword_results}
                                   metadata: metadata
                                 ] ->
          send(self(), :application_service_called)

          #{assert_results}

          assert metadata.correlation_id ==
                   "#{event["correlation_id"]}"

          assert metadata.causation_id == "#{event["type"]}:#{event["id"]}"

          assert metadata.original_causation_id ==
                    "#{event["causation_id"]}"

          assert metadata.occurred_at ==
                   Shared.DateTime.parse("#{event["time"]}") |> success_value()

          assert metadata.enacted_by == "#{event["actor"]}"
          :ok
        end

        assert :ok =
                 #{sub_module_name}EventConsumer.handle_message(
                   @event,
                   application_service
                 )

        assert_received :application_service_called
      end

      test "uses the tackle retry functionality if not successful" do
        application_service_handler_fn = fn _opts -> {:error, :any_error} end

        assert {:retry, {:error, :any_error}} =
                 catch_throw(
                   #{sub_module_name}EventConsumer.handle_message(
                     @event, application_service_handler_fn
                   )
                 )
      end

      @tag :integration
      test "DOING SOMETHING" do
        %{"data" => %{"some_param" => some_param}} = Jason.decode!(@event)
        assert :ok = #{sub_module_name}EventConsumer.handle_message(@event)

        assert {:ok, some_changed_structure} = SomeRepository.by_id(id)
        assert some_changed_structure.some == some_param

        assert [{%SomeEvent{}, _}] = all_events()
      end
    end

    """
  end
end
