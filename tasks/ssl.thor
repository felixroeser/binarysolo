require 'colorize'
require 'fileutils'

class Ssl < Thor

  desc "gen_crt", "generate a ssl key and certficate"
  def gen_crt(domain)
    path = "./config/ssl/#{domain}"
    say "Going to generate a server key and certificate to #{domain} in #{path}"

    if File.exist?(path)
      say "Directory already exists! Not doing anything.".colorize(:red)
      exit 1
    end

    FileUtils.mkdir_p path

    [
      "openssl genrsa -des3 -out server.key 1024",
      "openssl req -new -key server.key -out server.csr",
      "cp server.key server.key.org",
      "openssl rsa -in server.key.org -out server.key",
      "openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt"
    ].each_with_index do |cmd, index|
      if index == 3
        puts "Please enter *.#{domain} as common name! The rest is not that important and leave the challenge password blank!!!".colorize(:green)
      end
      `cd #{path} && #{cmd}`
    end

  end

end