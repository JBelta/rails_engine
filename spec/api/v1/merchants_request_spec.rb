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

    #Delete a Merchant

    delete "/api/v1/merchants/#{new_merchant.id}"
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(new_merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can update a merchant' do
    id = create(:merchant).id
    original_merchant = Merchant.last.name
    merchant_params = {name: "No Old Name Here"}
    headers = {'CONTENT_TYPE' => 'application/json'}

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchants: merchant_params)
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(original_merchant)
    expect(merchant.name).to eq("No Old Name Here")
  end

  it 'can get a list of items from that merchant' do
    merchant = create(:merchant, :with_items)

    expect(merchant.items.count).to eq(3)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful
  end
end
