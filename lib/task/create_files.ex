defmodule Mix.Tasks.CreateFiles do
  use Mix.Task
  import Mix.TasksHelper.CreateApplicationService
  import Mix.TasksHelper.CreateEvent
  import Mix.TasksHelper.CreateDomainModel
  import Mix.TasksHelper.CreateDomainModelRepository
  import Mix.TasksHelper.CreateEventListener
  import Mix.TasksHelper.CreateEventPublisher
  import Mix.TasksHelper.CreateFactory
  import Mix.TasksHelper.CreateMigration
  # --a  application service module name
  # --e  internal event module name
  # --m  domain model module name
  # --mf domain model fields (student_id:binary_id lesson_id:string)
  # --l  internal event listener
  # --p  event publisher
  # --migration  create migration
  def run(["-h"]) do
    """
    Example: mix create_files --a CreateStudentLessonTopic45 --e StudentLessonTopicCreated345 --m StudentLessonTopic54 --mf "student_id:binary_id lesson_id:binary_id lesson_id_2:binary_id" --migration create_student_table_34
    """
    |> IO.inspect()
  end

  def run([]) do
    application_service_name = IO.gets("What is application service name? (CamelCase)\n")
    event_name = IO.gets("What is internal event name? (CamelCase)\n")
    domain_name = IO.gets("What is domain model name? (CamelCase)\n")
    listener? = IO.gets("Create listener?(y/n) ")
    publisher? = IO.gets("Create publisher?(y/n) ")
    migration? = IO.gets("Create migration?(y/n) ")

    migration_name =
      if String.trim(migration?) == "y" do
        migration_name = IO.gets("Migration name:")
        String.trim(migration_name)
      end

    params = [
      "--a",
      String.trim(application_service_name),
      "--e",
      String.trim(event_name),
      "--m",
      String.trim(domain_name),
      "--l",
      String.trim(listener?),
      "--p",
      String.trim(publisher?),
      "--migration",
      migration_name
    ]

    run(params)
  end

  def run(params) do
    params
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> {a, b} end)
    |> Map.new()
    |> create_file()
  end

  defp create_file(params) do
    if Map.get(params, "--a") do
      IO.inspect("we are here 1")
      create_application_service(params)
      IO.inspect("we are here 2")
      create_application_service_test(params)
    end

    if Map.get(params, "--e") do
      create_event(params)
      create_event_test(params)
    end

    if Map.get(params, "--m") do
      create_domain_model(params)
      create_domain_model_test(params)
      create_domain_model_repository(params)
      create_domain_model_repository_test(params)
      create_factory(params)
    end

    if Map.get(params, "--a") && Map.get(params, "--e") && Map.get(params, "--l") == "y" do
      create_internal_event_listener(params)
      create_internal_event_listener_test(params)
    end

    if Map.get(params, "--a") && Map.get(params, "--e") && Map.get(params, "--p") == "y" do
      create_external_event_publisher(params)
      create_external_event_publisher_test(params)
    end

    if Map.get(params, "--migration") do
      create_migration(params)
    end

    System.cmd("mix", ["format"])
  end
end
