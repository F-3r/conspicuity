module PunchyPP
  class Railtie < ::Rails::Railtie
    initializer "punchy_pp.require" do
      require "punchy_pp"
    end
  end
end
