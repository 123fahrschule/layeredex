defmodule Mix.TasksHelper.CreateEventPublisherTemplate do
  def template(
        prefix: prefix,
        event_name: event_name
      ) do
    event_variable_name = Macro.underscore(event_name)

    """
    defmodule #{prefix}.#{event_name}EventPublisher do
      use Sna, :event_publisher

      @subscription_key "publish_#{event_variable_name}_event"
      @publisher_options routing_key: "routing_key.routing_key"

      alias #{prefix}.#{event_name}

      def publish(%#{event_name}{} = event, metadata, client) do
        event
        |> to_external_event(metadata)
        |> publish_event(client)
      end

      def to_external_event(event, metadata) do
        %{
          "id" => metadata[:event_id],
          "type" =>
            Shared.URN.generate_type("student-specified-driving-license-ownership"),
          "subject" => "de.123fahrschule:student",
          "data" => %{
            "student_id" => event.student_id,
          }
        }
        |> add_metadata(metadata)
      end
    end

    """
  end
end
