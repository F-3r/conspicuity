module PunchyPP
  class Railtie < ::Rails::Railtie
    initializer "punchy_pp.include_methods" do
      main = Object.const_get(:TOPLEVEL_BINDING).eval("self")
      main.extend(PunchyPP::Methods)
    end
  end
end
