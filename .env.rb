host = ENV['DATABASE_HOST'] || 'localhost'
port = ENV['DATABASE_PORT'] || '5434'
password = ENV['DATABASE_PASSWORD']

case ENV['RACK_ENV'] ||= 'development'
when 'test'
  ENV['MICRO_ADS_SESSION_SECRET'] ||= "MsIZFuH51St6JUm1aNuGDWKCoo0qvCqrnRdtNcLq85ejKS/Ksr78H4hcI6vZ\nkMZrj9ywjDuJwlFL4xWFip8iXQ==\n".unpack('m')[0]
  ENV['MICRO_ADS_DATABASE_URL'] ||= "postgres://micro_ads:#{password}@#{host}:#{port}/micro_ads_test"
when 'production'
  ENV['MICRO_ADS_SESSION_SECRET'] ||= "KUJ6ofvXW3e5AVm9XhcC/o5sky565/JQUQMbEeUVt/kYSLbIOGYEh1+s9aRL\nkQpI0yBXLv0HcJnYbonwC7r4yw==\n".unpack('m')[0]
  ENV['MICRO_ADS_DATABASE_URL'] ||= "postgres://micro_ads:#{password}@#{host}:#{port}/micro_ads_production"
else
  ENV['MICRO_ADS_SESSION_SECRET'] ||= "Qhkj1nM6Y9XPe4MSHXaRpOt8Wno3JOCtoKlXli+LKO/jXw2JY0+GIE/jhKqv\n6WrPMN3cWKNjOM2t1HSMhyxd7w==\n".unpack('m')[0]
  ENV['MICRO_ADS_DATABASE_URL'] ||= "postgres://micro_ads:#{password}@#{host}:#{port}/micro_ads_development"
end

puts '================'
puts ENV['MICRO_ADS_DATABASE_URL']
