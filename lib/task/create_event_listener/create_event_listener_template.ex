defmodule Mix.TasksHelper.EventListenerTemplate do
  def template(
        event_name: event_name,
        prefix: prefix
      ) do
    event_variable_name = Macro.underscore(event_name)

    """
    defmodule #{prefix}.#{event_name}EventListener do
      alias #{prefix}.#{event_name}
      use #{prefix}.EventListener,
        subscription_key: "#{event_variable_name}_event"


      def handle(%#{event_name}{} = event, metadata) do

      end
    end

    """
  end
end
