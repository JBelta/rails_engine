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
      expect(item[:unit_price]).to be_an(Float)

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
    expect(item[:unit_price]).to be_a(Float)

    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to be_an(Integer)

  end

  it 'can create and destroy an item' do
    #Create an Item
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

      #Delete an Item
      delete "/api/v1/items/#{new_item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(new_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can update an item" do
    id = create(:item).id
    original_item = Item.last.name
    item_params = {name: "NOT A NAME"}
    headers = {'CONTENT_TYPE' => 'application/json'}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(items: item_params)
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(original_item)
    expect(item.name).to eq("NOT A NAME")
  end

  it 'can get the merchant of a specific item' do
    merchant = create(:merchant, :with_items)
    item = merchant.items[0]

    get "/api/v1/items/#{item.id}/merchants"

    expect(response).to be_successful
  end
end
