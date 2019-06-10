require 'thor'

module EIVO
  class CLI < Thor

    desc 'install', 'Initialize default files'
    def install(args = nil)
      system("rails g eivo:install #{args}")
    end

  end
end
