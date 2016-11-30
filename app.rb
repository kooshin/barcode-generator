require 'slim'
require 'sinatra'
require 'sinatra/reloader'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'

set :bind, '0.0.0.0'

helpers do
  def create_barcode_image(content)
    code = Barby::QrCode.new(content, size: 7)
    code.to_image(xdim: 2).to_data_url
  end

  def tejuns
    @tejuns ||= YAML.load_file('tejuns.yaml')
  end

  def select_tejun(name)
    selected_tejuns = tejuns.select{|t| t['name'] == name }
    raise Sinatra::NotFound if selected_tejuns.size == 0
    selected_tejuns.first
  end
end

not_found do
  '手順書が見つかりません'
end

get '/' do
  slim :index
end

get '/:name' do
  @tejun = select_tejun(params[:name])
  slim :tejun
end

