Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id
      String :title, null: false
      String :description, null: false, text: true
      String :city, null: false
      Float :lat
      Float :lon
      Integer :user_id, null: false
      Timestamp :created_at, null: false
      Timestamp :updated_at, null: false
    end
  end
end
