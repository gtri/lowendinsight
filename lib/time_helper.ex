# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

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
    Kernel.trunc(sec / @week)
  end

  def get_commit_delta(last_commit_date) do
    case DateTime.from_iso8601(last_commit_date) do
      {:error, error} ->
        {:error, error}
      {:ok, last_commit_date, _something} ->
        DateTime.diff(DateTime.utc_now(), last_commit_date)
        #{:ok, seconds}
    end
  end

  def sum_ts_diff([_head | []], accumulator) do
    {:ok, accumulator}
  end

  def sum_ts_diff([head_1 | tail], accumulator) do
    [head_2 | _next_tail] = tail
    [_ | timestamp_1] = head_1
    [_ | timestamp_2] = head_2
    sum_ts_diff(tail, (timestamp_2 - timestamp_1) + accumulator)
  end

  def sum_ts_diff(list) do
    sum_ts_diff(list, 0)
  end
end
