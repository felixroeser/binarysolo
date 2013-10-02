require 'spec_helper'

describe BinarySolo::DomainRecord do

  Given(:homebase) { double :homebase}
  Given(:config) { test_config }
  Given(:klass) { BinarySolo::DomainRecord }

  Given(:data) { nil }
  Given(:name) { nil }

  Given(:domain_record) { klass.new(type: type, name: name, data: data) }
  
  context 'for an A record' do
    Given(:type) { 'A' }
    Then { domain_record.type == type }

    context 'with @ name' do
      Given(:name) { '@' }
      Then { domain_record.name == name }
    end

    context 'with a normal name' do
      Given(:name) { 'www' }
      Then { domain_record.name == name }
    end

  end

  context 'for an MX record' do
    Given(:type) { 'MX' }
    Then { domain_record.type == type }

    context 'with gmail data' do
      Given(:data) { 'gmail' }
      Then { domain_record.data == data }
      Then { domain_record.meta? == true }
    end

    context 'with homebase data' do
      Given(:data) { 'homebase' }
      Then { domain_record.data == data }
      Then { domain_record.meta? == true }
    end

    context 'with an ip address as data' do
      Given(:data) { '192.168.1.1' }
      Then { domain_record.data == data }
      Then { domain_record.meta? == false }
    end

  end

end