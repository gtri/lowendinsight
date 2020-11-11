defmodule Mix.Tasks.Lei.BatchBulkAnalyze do
  use Mix.Task

  def run(args) do
    {:ok, file} = File.read(args)
    String.split(file, "\n")
    |> Enum.chunk_every(1000)
    |> Enum.each(fn x ->
      File.write("temp.txt", List.to_string(Enum.map(x, fn a -> a<>"\n" end)))
      Mix.Tasks.Lei.BulkAnalyze.run(["temp.txt"])
    end)
    File.rm("temp.txt")
  end
end
