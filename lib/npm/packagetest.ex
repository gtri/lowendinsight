#defmodule Packagetest do
#    def print_json() do
#        File.read!("lib/npm/package-lock.json")
#        |> Packagelockfile.parse!()
#        |> Enum.map(fn package ->
#            ScannerModule.query_npm(package)
#      end)
#    end
#end