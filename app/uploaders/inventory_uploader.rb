require 'csv'

class InventoryUploader < Shrine
  plugin :processing

  process(:cache) do |io, _ctx|
    index = 0
    CSV.foreach(io.path, headers: true) do |row|
      import_item(row)
      index += 1
    end
  end

  private

  def import_item(row)
    p row.to_hash.with_indifferent_access
  end
end
