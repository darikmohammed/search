class AddIpAddressToSearchHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :search_histories, :ip_address, :string
  end
end
