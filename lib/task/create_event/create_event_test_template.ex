defmodule Mix.TasksHelper.CreateEventTestTemplate do
  def template(
        prefix: prefix,
        event_name: event_name,
        domain_model_name: domain_model_name
      ) do
    domain_model = Macro.underscore(domain_model_name)

    """
    defmodule #{prefix}.#{event_name}Test do
      use Support.DataCase, async: true
      alias #{prefix}.#{event_name}

      test "generates proper stream id and links the proper streams" do
        #{domain_model} = build(:#{domain_model})
        event = #{event_name}.for(#{domain_model})

        assert Shared.AppendableEvent.stream_id(event) == ""

        assert Shared.AppendableEvent.streams_to_link(event) == []
      end
    end

    """
  end
end
