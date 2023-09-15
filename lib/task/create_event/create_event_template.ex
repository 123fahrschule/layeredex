defmodule Mix.TasksHelper.CreateEventTemplate do
  def template(
        prefix: prefix,
        event_name: event_name,
        domain_model_name: domain_model_name
      ) do
    """
    defmodule #{prefix}.#{event_name} do
      use #{prefix}.Includes, :domain_event

      alias #{prefix}.#{domain_model_name}

      @derive {Shared.AppendableEvent, stream_id: :student_id}

      defstruct [:student_id]

      def for(%#{domain_model_name}{id: id}) do
        %@me{student_id: id}
      end
    end

    """
  end
end
