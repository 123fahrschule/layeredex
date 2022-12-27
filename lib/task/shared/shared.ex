defmodule Layeredex.Shared do
  def create_asserts(domain_model_variable_name, field_name) do
    """
    assert #{domain_model_variable_name}.#{field_name} == #{field_name}
    """
  end

  def create_setup(field_name, field_type) do
    value =
      case field_type do
        "binary_id" -> "new_uuid()"
        "integer" -> "10"
        "boolean" -> "false"
        "string" -> "Faker.String.naughty()"
        "date" -> "Faker.Date.forward(1)"
        "utc_datetime" -> "Faker.DateTime.forward(1)"
        _ -> "new_uuid()"
      end

    """
    #{field_name} = #{value}
    """
  end
end
