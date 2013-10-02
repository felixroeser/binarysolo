module Factories

  def raw_domains(nr=1)
    nr.times.collect do |i|
      {name: "domain-#{i}.com", provider_id: i}
    end
  end

  extend self
end