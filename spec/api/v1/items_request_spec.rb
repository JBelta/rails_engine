require 'rails_helper'

describe 'Items API', type: :request do
  it "sends a list of items" do
    create_list(:item, 10)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(10)

    items.each do |item|

      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_an(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_an(Integer)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_an(Integer)
    end
  end

  it 'can get a single item by id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(Integer)

    expect(item).to have_key(:name)
    expect(item[:name]).to be_an(String)

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_an(Integer)

    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to be_an(Integer)

  end

  it 'can create an item' do
    merchant = create :merchant
    item_params = ({
      name: 'Coffee Beans',
      description: 'Bold and Robust',
      unit_price: 15.0,
      merchant_id: merchant.id
      })

      headers = {'CONTENT_TYPE' => 'application/json'}

      post '/api/v1/items', headers: headers, params: JSON.generate(items: item_params)
      new_item = Item.last

      expect(response).to be_successful
      expect(new_item.name).to eq(item_params[:name])
      expect(new_item.description).to eq(item_params[:description])
      expect(new_item.unit_price).to eq(item_params[:unit_price])
      expect(new_item.merchant_id).to eq(merchant.id)

  end
end
