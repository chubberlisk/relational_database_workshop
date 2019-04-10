Sequel.migration do
  change do
    create_table :fruit do
      primary_key :id, null: false
      String :name, null: false
    end

    create_table :harvest do
      primary_key :id, null: false
      integer :fruit_id, null: false
      date :date, null: false
      integer :yield, null: false
    end
  end
end
