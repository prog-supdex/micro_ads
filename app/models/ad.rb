class Ad < Sequel::Model
  #plugin :timestamps, update_on_create: true

  def validate
    super

    validates_presence %i[title description city]
  end
end
