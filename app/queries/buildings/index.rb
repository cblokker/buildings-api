module Buildings
  class Index

    def initialze
    end


    def sql
      Building
        .joins(:address, :client)
        .select(
          'buildings.id,
          clients.name AS client_name,
          addresses.street_address AS address',
          'kv.key AS field_name',
          'kv.value AS field_value'
          )
        .from("json_each(custom_fields) AS kv") 

    end
  end
end



def sql
  "
  SELECT jsonb_array_elements(payload)
  FROM users
  WHERE id = #{params[:id]}
  LIMIT #{params[:per_page]} OFFSET #{(params[:page].to_i - 1) * params[:per_page].to_i}
  "
end

query = <<-SQL
      SELECT buildings.id, jsonb_array_elements(custom_field)->0->>'value'
      FROM buildings
    SQL