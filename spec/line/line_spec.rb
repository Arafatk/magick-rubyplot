require 'spec_helper'
describe 'Graph' do
  it 'Make a line plot of a graph' do
    random_lines
    plot = Rubyplot::Line.new
    plot.title = 'A Line Graph'
    plot.labels = {
      0 => 'Ola Ruby',
      1 => 'Hello ruby'
    }
    # Data inputted and normalized like the usual cases.
    plot.data( [20, 23, 19, 8],:Marco,:blue)
    plot.data( [1, 53, 76, 18],:John,:green)
    # Starting the ultimate Write script of the whole thinplot.
    plot.write('spec/reference_images/line_test_1.png')

    expect(compare_with_reference?('line.png', 'line_test_1.png', 10)).to eq(true)
  end

  it 'Fails to match with the reference image' do
    plot = Rubyplot::Line.new
    plot.title = 'A Line Graph'
    plot.labels = {
      0 => 'Ola Ruby',
      1 => 'Hello ruby'
    }
    # Data inputted and normalized like the usual cases.
    plot.data( [20, 23, 19, 8],:Marco)
    plot.data([1, 53, 76, 19],:John)
    # Starting the ultimate Write script of the whole thinplot.
    plot.write('spec/reference_images/line_test_2.png')
    expect(compare_with_reference?('line.png', 'line_test_2.png', 10)).to eq(false)
  end

  it 'Tests Very Small Plot' do
    setup_data
    plot = Rubyplot::Line.new(200)
    plot.title = 'Very Small Line Chart 200px'
    @datasets.each do |data|
      plot.data(data[1], data[0])
    end
    plot.write('spec/reference_images/line_very_small_test.png')
  end

  it 'test_should_not_hang_with_0_0_100' do
    plot = Rubyplot::Line.new(320)
    plot.title = 'Hang Value Graph Test'
    plot.data( [0, 0, 100],'test')

    plot.write('spec/reference_images/line_hang_value_test.png')
  end

  it 'test_line_small_values' do
    @datasets = [
      [[0.1, 0.14356, 0.0, 0.5674839, 0.456],:small],
      [[0.2, 0.3, 0.1, 0.05, 0.9],:small2]
    ]

    plot = Rubyplot::Line.new
    plot.title = 'Small Values Line Graph Test'
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.write('spec/reference_images/line_small_values_test.png')

    plot = Rubyplot::Line.new(400)
    plot.title = 'Small Values Line Graph Test 400px'
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.write('spec/reference_images/line_small_values_small_plot_test.png')
  end

  it 'test_line_starts_with_zero' do
    @datasets = [
      [[0, 5, 10, 8, 18],:first0],
      [[1, 2, 3, 4, 5],:normal]
    ]

    plot = Rubyplot::Line.new
    plot.title = 'Small Values Line Graph Test'
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.write('spec/reference_images/line_small_zero_test.png')

    plot = Rubyplot::Line.new(400)
    plot.title = 'Small Values Line Graph Test 400px'
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.write('spec/reference_images/line_small_value_small_plot_test.png')
  end

  it 'test_line_large_values' do
    @datasets = [
      [:large, [100_005, 35_000, 28_000, 27_000]],
      [:large2, [35_000, 28_000, 27_000, 100_005]],
      [:large3, [28_000, 27_000, 100_005, 35_000]],
      [:large4, [1_238, 39_092, 27_938, 48_876]]
    ]

    plot = Rubyplot::Line.new
    plot.title = 'Very Large Values Line Graph Test'
    plot.baseline_value = 50_000
    plot.dot_radius = 15
    plot.line_width = 3
    @datasets.each do |data|
      plot.data(data[1],data[0])
    end

    plot.write('spec/reference_images/line_large_test.png')
  end
end
