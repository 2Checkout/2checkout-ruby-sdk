# encoding: UTF-8
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'twocheckout_client'
  s.version     = '1.2.0'
  s.summary     = '2Checkout Ruby SDK'
  s.description = '1.2.0'
  s.summary     = '2Checkout Ruby SDK'
  s.author        = "2Checkout"
  s.email         = 'supportplus@2checkout.com'
  s.homepage      = 'https://github.com/2Checkout/2checkout-ruby-sdk'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.add_dependency('jwt', '~> 2.2')
  s.require_paths = %w{lib}
  s.requirements << 'none'
  s.license = 'MIT'
end