defmodule TimeHelper do
  @minute 60
  @hour   @minute*60
  @day    @hour*24
  @week   @day*7
  @divisor [@week, @day, @hour, @minute, 1]

  def sec_to_str(sec) do
    {_, [s, m, h, d, w]} =
        Enum.reduce(@divisor, {sec,[]}, fn divisor,{n,acc} ->
          {rem(n,divisor), [div(n,divisor) | acc]}
        end)
    ["#{w} wk", "#{d} d", "#{h} hr", "#{m} min", "#{s} sec"]
    |> Enum.reject(fn str -> String.starts_with?(str, "0") end)
    |> Enum.join(", ")
  end

  def sec_to_weeks(sec) do
    {:ok, Kernel.trunc(sec / @week)}
  end
end
