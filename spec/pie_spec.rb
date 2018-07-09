require 'spec_helper'
describe 'Pie' do
  before do
    @datasets = [
      [:China, [25]],
      [:India, [80]],
      [:Nepal, [22]],
      [:Germany, [95]],
      [:Australia, [90]]
    ]
  end

  it 'Sets up a basic reference image for histogram with random numbers' do
    plot = Rubyplot::Pie.new
    plot.title = 'Visual Pie Graph Test'
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.write('spec/reference_images/pie_test_1.png')

    expect(compare_with_reference?('pie.png', 'pie_test_1.png', 10)).to eq(true)
  end

  it 'test pie graph nearly equal' do
    plot = Rubyplot::Pie.new
    plot.title = 'Pie Graph Nearly Equal'

    plot.data(:Arafat, [41])
    plot.data(:Pranav, [42])
    #    plot.data(:Grouch, [40])
    #    plot.data(:Snuffleupagus, [43])

    plot.write('test/output/pie_nearly_equal.png')
  end

  it 'pie graph equal' do
    plot = Rubyplot::Pie.new
    plot.title = 'Pie Graph Equal'

    plot.data(:Arafat, [41])
    plot.data(:Pranav, [41])

    plot.write('test/output/pie_equal.png')
  end

  it 'test pie graph zero' do
    plot = Rubyplot::Pie.new
    plot.title = 'Pie Graph One Zero'

    plot.data(:Car, [0])
    plot.data(:Bus, [1])

    plot.write('test/output/pie_zero.png')
  end
end
