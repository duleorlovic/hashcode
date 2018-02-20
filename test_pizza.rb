require 'minitest/autorun'
require './pizza'
class Test < Minitest::Test
  def test_sample
    input = %(3 5 1 6
TTTTT
TMMMT
TTTTT)
    output = %(3
0 0 2 1
0 2 2 2
0 3 2 4)
    assert_equal output, prepare_output(solution(prepare_input(input)))
  end

  def test_that_is_skipped
    skip "later"
  end

  def prepare_output(n:, r:)
    s = n.to_s
    s += "\n"
    s += r.map do |row|
      row.join(" ")
    end.join("\n")
    s
  end

  def prepare_input(s)
    r, c, l, h = s.split("\n").first.split(' ').map &:to_i
    a = []
    s.split("\n")[1..-1].each do |row|
      a << row.split('').map { |c| c == 'T' ? 1 : -1 }
    end
    {
      a: a,
      l: l,
      h: h,
    }
  end
end
