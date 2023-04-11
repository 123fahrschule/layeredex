defmodule Mix.TasksHelper.CreateMigration do
  def create_migration(%{"--migration" => migration_name} = params) do
    System.cmd("mix", ["ecto.gen.migration", migration_name])

    if Map.get(params, "--mf") do
      model_fields = Map.get(params, "--mf")

      fields =
        if model_fields do
          model_fields
          |> String.split(" ")
          |> Enum.map(fn field -> "add :#{String.replace(field, ":", ", :")}" end)
          |> Enum.join("\n")
        else
          ""
        end

      IO.puts("Add to migration file ->")
      IO.puts("create table(________, primary_key: false) do")
      IO.puts("add :id, :string, primary_key: true")
      IO.puts(fields)
      IO.puts("add :lock_version, :integer, default: 1")
      IO.puts("timestamps()")
      IO.puts("end")

    end
  end
end
