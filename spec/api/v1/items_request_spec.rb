require 'rails_helper'

describe 'Items API', type: :request do
  it "sends a list of items" do
    create_list(:item, 10)

    get '/api/v1/items'

    expect(response).to be_successful
  end
end
