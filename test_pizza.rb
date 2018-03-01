require 'minitest/autorun'
require './pizza'
class Test < Minitest::Test
  def test_prefix_sum
    a =
    [
      [0, 1, 0, 0],
      [1, 1, 0, 1],
      [0, 0, 0, 1],
    ]
    ps =
    [
      [0, 1, 1, 1],
      [1, 3, 3, 4],
      [1, 3, 3, 5],
    ]
    assert_equal ps, prefix_sum(a)
  end

  def test_at_least_at_most
    a =
    [
      [0, 1, 0],
      [1, 1, 1],
    ]
    # single slice
    assert_equal false, at_least_at_most?(a, 1, [[0,0],[0,0]])

    # square slice
    assert_equal false, at_least_at_most?(a, 2, [[0,0],[1,1]])
    assert_equal true, at_least_at_most?(a, 1, [[0,0],[1,1]])

    # column slice
    assert_equal true, at_least_at_most?(a, 1, [[0,0],[1,0]])
    assert_equal false, at_least_at_most?(a, 1, [[0,1],[1,1]])

    # row slice
    assert_equal true, at_least_at_most?(a, 1, [[0,0],[0,2]])
    assert_equal false, at_least_at_most?(a, 1, [[1,0],[1,2]])

    # full slice
    assert_equal true, at_least_at_most?(a, 2, [[0,0],[1,2]])
    assert_equal false, at_least_at_most?(a, 3, [[0,0],[1,2]])
  end

  def test_is_not_already_marked
    marked = [
      [nil, true, nil],
      [true, nil, nil],
    ]
    assert_equal true, is_not_already_marked?(marked, [[0,0],[0,0]])
    assert_equal false, is_not_already_marked?(marked, [[0,0],[0,1]])
    assert_equal false, is_not_already_marked?(marked, [[0,1],[0,1]])
    assert_equal true, is_not_already_marked?(marked, [[0,2],[1,2]])
  end

  def test_mark
    marked = [
      [nil, true, nil],
      [true, nil, nil],
    ]
    m1 = [
      [true, true, nil],
      [true, nil, nil],
    ]
    assert_equal m1, mark(marked, [[0,0],[0,0]])
  end

  def test_submatric
    a =
    [
      [0, 1, 0, 0],
      [1, 1, 0, 1],
      [0, 0, 0, 1],
    ]
    m1 =
    [
      [0, 1],
      [1, 1],
    ]
    assert_equal m1, submatrix(a, [[0,0],[1,1]])
  end

  def test_slice_area
    assert_equal 1, slice_area([[1,1],[1,1]])
    assert_equal 2, slice_area([[0,1],[1,1]])
    assert_equal 4, slice_area([[0,0],[1,1]])
  end

  def test_slice_sum
    a =
    [
      [0, 1, 0],
      [1, 1, 1],
    ]
    # single slice
    assert_equal 0, slice_sum(a, [[0,0],[0,0]])
    assert_equal 1, slice_sum(a, [[1,0],[1,0]])

    # square slice
    assert_equal 3, slice_sum(a, [[0,0],[1,1]])
    assert_equal 3, slice_sum(a, [[0,1],[1,2]])

    # column slice
    assert_equal 1, slice_sum(a, [[0,0],[1,0]])
    assert_equal 2, slice_sum(a, [[0,1],[1,1]])

    # row slice
    assert_equal 1, slice_sum(a, [[0,0],[0,2]])
    assert_equal 3, slice_sum(a, [[1,0],[1,2]])

    # full slice
    assert_equal 4, slice_sum(a, [[0,0],[1,2]])
  end

  def test_slice_sum_sample
    a =
    [
      [0, 0, 0, 0],
      [0, 1, 1, 0],
      [0, 0, 0, 0],
    ]
    assert_equal 1, slice_sum(a, [[0,0],[2,1]])
  end

  def test_rotate
    a =
    [
      [0, 0, 0, 0],
      [0, 1, 1, 1],
      [0, 0, 1, 0],
    ]
    rotated =
    [
      [0, 0, 0],
      [0, 1, 0],
      [1, 1, 0],
      [0, 1, 0],
    ]
    assert_equal rotated, rotate(a)
  end

  def test_transpose
    a =
    [
      [0, 0, 0, 0],
      [0, 1, 1, 1],
      [0, 0, 1, 0],
    ]
    transposed =
    [
      [0, 0, 0],
      [0, 1, 0],
      [0, 1, 1],
      [0, 1, 0],
    ]
    assert_equal transposed, transpose(a)
  end

  def test_unrotate
    rotated =
    [
      [1, 1, 1, 0],
      [2, 2, 3, 3],
      [2, 2, 0, 0],
      [0, 0, 4, 0],
      [0, 0, 4, 0],
    ]
    results =
    [
      [[0,0],[0,2]],
      [[1,0],[2,1]],
      [[1,2],[1,3]],
      [[3,2],[4,2]],
    ]
    unrotated =
    [
      [0, 3, 0, 0, 0],
      [1, 3, 0, 4, 4],
      [1, 2, 2, 0, 0],
      [1, 2, 2, 0, 0],
    ]
    unrotated_results =
    [
      [[1,0],[3,0]],
      [[2,1],[3,2]],
      [[0,1],[1,1]],
      [[1,3],[1,4]],
    ]
    assert_equal rotated, rotate(unrotated)
    assert_equal unrotated_results, unrotate(rotated, results)
  end

  def test_untranspose
    transposed =
    [
      [1, 1, 1, 0],
      [2, 2, 3, 3],
      [2, 2, 0, 0],
      [0, 0, 4, 0],
      [0, 0, 4, 0],
    ]
    results =
    [
      [[0,0],[0,2]],
      [[1,0],[2,1]],
      [[1,2],[1,3]],
      [[3,2],[4,2]],
    ]
    untransposed =
    [
      [1, 2, 2, 0, 0],
      [1, 2, 2, 0, 0],
      [1, 3, 0, 4, 4],
      [0, 3, 0, 0, 0],
    ]
    untransposed_results =
    [
      [[0,0],[2,0]],
      [[0,1],[1,2]],
      [[2,1],[3,1]],
      [[2,3],[2,4]],
    ]
    assert_equal transposed, transpose(untransposed)
    assert_equal untransposed_results, untranspose(results)
  end

  def test_composition
    aa =
    [
      [1, 1, 1, 0],
      [2, 2, 3, 3],
      [2, 2, 0, 0],
      [0, 0, 4, 0],
      [0, 0, 4, 0],
    ]
    results =
    [
      [[0,0],[0,2]],
      [[1,0],[2,1]],
      [[1,2],[1,3]],
      [[3,2],[4,2]],
    ]
    _transposed =
    [
      [1, 2, 2, 0, 0],
      [1, 2, 2, 0, 0],
      [1, 3, 0, 4, 4],
      [0, 3, 0, 0, 0],
    ]
    transposed_rotated =
    [
      [0, 1, 1, 1],
      [3, 3, 2, 2],
      [0, 0, 2, 2],
      [0, 4, 0, 0],
      [0, 4, 0, 0],
    ]
    transposed_rotated_result =
    [
      [[0,1],[0,3]],
      [[1,2],[2,3]],
      [[1,0],[1,1]],
      [[3,1],[4,1]],
    ]
    assert_equal transposed_rotated, rotate(transpose(aa))
    assert_equal results, untranspose(unrotate(transposed_rotated, transposed_rotated_result))
  end

  def test_unrotate_twice
    aa =
    [
      [1, 1, 1, 0],
      [2, 2, 3, 3],
      [2, 2, 0, 0],
      [0, 0, 4, 0],
      [0, 0, 4, 0],
    ]
    results =
    [
      [[0,0],[0,2]],
      [[1,0],[2,1]],
      [[1,2],[1,3]],
      [[3,2],[4,2]],
    ]
    rotated_twice =
    [
      [0, 4, 0, 0],
      [0, 4, 0, 0],
      [0, 0, 2, 2],
      [3, 3, 2, 2],
      [0, 1, 1, 1],
    ]
    rotated_results =
    [
      [[4,1],[4,3]],
      [[2,2],[3,3]],
      [[3,0],[3,1]],
      [[0,1],[1,1]],
    ]
    assert_equal rotated_twice, rotate(rotate(aa))
    assert_equal results, unrotate(rotate(rotated_twice), unrotate(rotated_twice, rotated_results))
  end


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

  def test_single_element
    input = %(1 1 1 1
T)
    output = %(0
)
    assert_equal output, prepare_output(solution(prepare_input(input)))
  end

  def test_two_elements
    input = %(1 2 1 1
TM)
    output = %(0
)
    assert_equal output, prepare_output(solution(prepare_input(input)))
  end

  def test_two_elements_max_2
    input = %(1 2 1 2
TM)
    output = %(1
0 0 0 1)
    assert_equal output, prepare_output(solution(prepare_input(input)))
  end

  def prepare_output(result)
    s = result.length.to_s
    s += "\n"
    s += result.map do |slice|
      [slice[0][0], slice[0][1], slice[1][0], slice[1][1]].join(" ")
    end.join("\n")
    s
  end

  def prepare_input(s)
    _r, _c, l, h = s.split("\n").first.split(' ').map(&:to_i)
    aa = []
    s.split("\n")[1..-1].each do |row|
      aa << row.split('').map { |c| c == 'M' ? 1 : 0 }
      # { val: 1, marked: false, important: false } : { val: 0, marked: false, important: false}  }
    end
    {
      aa: aa,
      l: l,
      h: h,
    }
  end
end
