defmodule Mix.TasksHelper.EventListenerTestTemplate do
  def template(
        event_name: event_name,
        prefix: prefix
      ) do

    """
    defmodule #{prefix}.#{event_name}EventListenerTest do
      use Support.DataCase, async: false


      @tag :integration
      test "handle event" do
      end
    end

    """
  end
end
