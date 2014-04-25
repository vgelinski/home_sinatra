require 'data_mapper'
require 'digest/sha1'

class User

  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :password, String
  property :salt, String

  def User.create(params)
    params[:salt] = (0..8).map{(33 + rand(92)).chr}.join
    plain_pass = params[:password]
    params[:password] = Digest::SHA1.hexdigest plain_pass + params[:salt]
    super(params)
  end

  def initialize(params)
    attribute_set :name, params[:name]
    attribute_set :password, params[:password]
    attribute_set :salt, params[:salt]
  end

  def check(m_name, m_password)
    name == m_name && (Digest::SHA1.hexdigest(m_password + salt) == password)
  end

end
