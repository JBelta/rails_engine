require 'rails_helper'

describe 'Merchants API', type: :request do
  it 'sends a list of merchants' do
    create_list(:merchant, 10)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(10)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_an(String)
    end
  end

  it "can get a single merchant by id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(Integer)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_an(String)
  end

  it 'can create and destroy a merchant' do
    #Create a Merchant
    merchant_params = {name: 'Market'}

    headers = {'CONTENT_TYPE' => 'application/json'}

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchants: merchant_params)
    new_merchant = Merchant.last

    expect(response).to be_successful
    expect(new_merchant.name).to eq(merchant_params[:name])
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(Integer)


  end
end
