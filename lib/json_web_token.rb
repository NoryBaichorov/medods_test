require 'jwt'

class JsonWebToken
  JWT_SECRET = 'something_very_secret'
  ALG = 'HS512'
 
  def self.encode(payload, exp = 12.hours.from_now)
    payload[:exp] = exp.to_i
 
    JWT.encode(payload, JWT_SECRET, ALG)
  end
 
  def self.decode(token)
    body = JWT.decode(token, JWT_SECRET, true, { algorithm: ALG }).first
 
    HashWithIndifferentAccess.new(body)
  end
end
