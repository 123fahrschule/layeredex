defmodule Mix.TasksHelper.CreateEventPublisherTestTemplate do
  def template(
        prefix: prefix,
        event_name: event_name,
        model_name: model_name
      ) do
    event_variable_name = Macro.underscore(event_name)

    model_variable_name =
      if model_name do
        Macro.underscore(model_name)
      else
        "domain_model_name"
      end

    """
    defmodule #{prefix}.#{event_name}EventPublisherTest do
      use Support.DataCase, async: false

      @subscription_key "publish_#{event_variable_name}_event"
      @publisher_options routing_key: "sna-backend.---------------------------"

      alias #{prefix}.#{event_name}EventPublisher, as: Publisher

      test "maps event and metadata to external format" do
        #{model_variable_name} = insert(:#{model_variable_name})

        event = #{event_name}.for(#{model_variable_name})

        metadata =
          Metadata.for_command("#{String.replace(event_variable_name, "_", "-")}",
            enacted_by: "my enacted by",
            event_id: event_id = Shared.UUID.generate()
          )

        assert external_event = Publisher.to_external_event(event, metadata)

        assert external_event["id"] == event_id
        assert external_event["source"] == "de.123fahrschule:sna-backend"
        assert external_event["subject"] == "de.123fahrschule:notifier:text-message-delivery-request"
        assert external_event["time"]

        assert external_event["type"] == "de.123fahrschule:notifier:deliver-text-message"

        assert external_event["actor"] == "my enacted by"
        assert external_event["causation_id"] == metadata[:causation_id]
        assert external_event["correlation_id"] == metadata[:correlation_id]

        assert %{} = external_event["data"]
      end
    end

    """
  end
end
