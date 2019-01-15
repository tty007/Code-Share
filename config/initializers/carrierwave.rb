require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
    # fog_providerをfog-awsにする
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['aws_access_key_id'],
      aws_secret_access_key: ENV['aws_secret_access_key'],
      region: 'ap-northeast-1'
    }
    #S3のバケット名
    config.fog_directory  = 's3-bucket-rails-develop'
    config.cache_storage = :fog
    #S3では料金が発生するので、なるべくブラウザにキャッシュしてもらう設定にする。
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  end