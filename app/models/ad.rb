class Ad < Sequel::Model
  def validate
    super

    validates_presence %i[title description city]
  end
end
