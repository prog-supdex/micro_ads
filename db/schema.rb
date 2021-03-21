Sequel.migration do
  change do
    create_table(:ads, :ignore_index_errors=>true) do
      primary_key :id, :type=>:Bignum
      Bignum :user_id, :null=>false
      String :title, :null=>false
      String :city, :null=>false
      String :description, :text=>true, :null=>false
      Float :lat
      Float :lon
      DateTime :created_at, :size=>6, :null=>false
      DateTime :updated_at, :size=>6, :null=>false
      
      index [:user_id], :name=>:index_ads_on_user_id
    end
    
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
  end
end
