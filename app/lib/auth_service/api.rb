module AuthService
  module Api
    def auth(token)
      publish(token, type: 'auth')
    end
  end
end
